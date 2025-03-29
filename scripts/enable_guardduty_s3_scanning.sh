#!/bin/bash

# Script: enable_guardduty_s3_scanning.sh
# Purpose: Configure GuardDuty with EC2 and S3 malware protection in account 557690595061 (SecOps profile)
# Author: Darren
# Region: eu-west-1

ACCOUNT_PROFILE="SecOps"
REGION="eu-west-1"

echo "🔍 Checking for existing GuardDuty detector..."
DETECTOR_ID=$(aws guardduty list-detectors \
  --profile "$ACCOUNT_PROFILE" \
  --region "$REGION" \
  --query "DetectorIds[0]" \
  --output text)

if [ "$DETECTOR_ID" == "None" ] || [ -z "$DETECTOR_ID" ]; then
  echo "⚙️ No detector found. Creating GuardDuty detector..."
  DETECTOR_ID=$(aws guardduty create-detector \
    --enable \
    --profile "$ACCOUNT_PROFILE" \
    --region "$REGION" \
    --query "DetectorId" \
    --output text)
  echo "✅ Created detector: $DETECTOR_ID"
else
  echo "✅ GuardDuty detector found: $DETECTOR_ID"
fi

echo "🔐 Enabling malware protection for EC2 with findings..."
aws guardduty update-malware-protection \
  --detector-id "$DETECTOR_ID" \
  --scan-ec2-instance-with-findings ENABLED \
  --profile "$ACCOUNT_PROFILE" \
  --region "$REGION"

echo "📦 Enabling S3 protection in this account..."
aws guardduty update-detector \
  --detector-id "$DETECTOR_ID" \
  --enable \
  --data-sources '{"S3Logs":{"Enable":true}}' \
  --profile "$ACCOUNT_PROFILE" \
  --region "$REGION"

echo "🔎 Verifying configuration..."
aws guardduty get-detector \
  --detector-id "$DETECTOR_ID" \
  --profile "$ACCOUNT_PROFILE" \
  --region "$REGION" \
  --output json

echo "📋 Listing existing findings (if any)..."
aws guardduty get-findings \
  --detector-id "$DETECTOR_ID" \
  --profile "$ACCOUNT_PROFILE" \
  --region "$REGION" \
  --max-results 5 \
  --output table
