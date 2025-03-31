#!/bin/bash

aws cloudformation deploy \
  --template-file templates/stack-1b-lambda-sns.yaml \
  --stack-name ec2datatransfer-lambda-sns \
  --parameter-overrides TeamName=sgn \
  --capabilities CAPABILITY_NAMED_IAM \
  --profile SecOps \
  --region us-east-1
