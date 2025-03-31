#!/bin/bash

set -euo pipefail

STACK_NAME="ec2datatransfer-stack2-v2"
TEMPLATE_FILE="templates/stack-2-s3-bucket.yaml"
PROFILE="SecOps"  # deploying to Security account
REGION="us-east-1"
TEAM_NAME="sgn"

LOG_GROUP="/aws/cloudformation/stack2-deployment"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
LOG_STREAM="deploy-$TIMESTAMP"

aws logs create-log-group --log-group-name "$LOG_GROUP" --profile "$PROFILE" --region "$REGION" 2>/dev/null || true
aws logs create-log-stream --log-group-name "$LOG_GROUP" --log-stream-name "$LOG_STREAM" --profile "$PROFILE" --region "$REGION"

{ 
  echo "Deploying $STACK_NAME at $TIMESTAMP..."
  aws cloudformation deploy \
    --template-file "$TEMPLATE_FILE" \
    --stack-name "$STACK_NAME" \
    --parameter-overrides TeamName="$TEAM_NAME" \
    --capabilities CAPABILITY_NAMED_IAM \
    --profile "$PROFILE" \
    --region "$REGION"
  echo "Deployment finished at $(date)."
} | tee /tmp/deploy_output.log

aws logs put-log-events \
  --log-group-name "$LOG_GROUP" \
  --log-stream-name "$LOG_STREAM" \
  --log-events "timestamp=$(($(date +%s%N)/1000000)),message=$(cat /tmp/deploy_output.log | jq -Rs .)" \
  --profile "$PROFILE" \
  --region "$REGION"

rm /tmp/deploy_output.log

# NOTE: Make sure that templates/stack-2-s3-bucket.yaml sets the bucket name to sgn-0ps-datatransfer

