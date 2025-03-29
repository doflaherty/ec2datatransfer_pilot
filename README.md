# EC2 Data Transfer Automation (Pilot)

This repository supports the CR2261 AWS Security Optimisation pilot for secure EC2 file transfers using SSM Automation, IAM roles, S3 bucket policies, and GuardDuty integration.

## Structure

- **templates/**: CloudFormation templates and SSM document
- **docs/**: Background documentation
- **README.md**: Project overview

## Deployment Steps

1. Deploy `stack-2-s3-bucket.yaml` to the Security (DevTest T2) account
2. Deploy `stack-1-iam-lambda-sns.yaml` to the Member (DevTest T1) account
3. Import and activate `ec2-data-transfer-ssm-document.yaml` in both accounts
4. Verify the IAM roles and S3 policy conditions for correct execution
5. Execute automation via SSM with direction, file name, and EC2 instance ID parameters
