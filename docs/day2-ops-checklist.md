# ✅ Day 2 Operations Checklist - EC2 Data Transfer Pilot

This checklist supports operational readiness and monitoring for the EC2-to-S3 data transfer automation.

---

## 🔐 Security Monitoring

- [ ] Confirm GuardDuty is **enabled** in 557690595061 (SecOps account):
  - `aws guardduty list-detectors --profile SecOps`
- [ ] Confirm S3 Malware Protection is enabled:
  - Run: `./scripts/enable_guardduty_s3_scanning.sh`
- [ ] Periodically check GuardDuty findings:
  - `aws guardduty get-findings --detector-id <id> --profile SecOps`

---

## ⚙️ Lambda + SSM Functionality

- [ ] Confirm `S3FolderStructureCreator` Lambda is up-to-date with latest fallback bucket logic
- [ ] Verify Lambda role (`SGN-OPS-EC2DataTransfer-LambdaExecutionRole`) has valid S3 PutObject permissions
- [ ] Ensure `ec2-data-transfer-ssm-document.yaml` is deployed in both:
  - DevTest T1 (557690595061)
  - DevTest T2 (869935110941)
- [ ] Test SSM automation execution (manual or scheduled)

---

## 🔐 IAM Access Review

- [ ] Validate `SGN-OPS-EC2DataTransfer-AutomationRole` includes `ssm:StartAutomationExecution`
- [ ] Confirm `RemoteAccess` roles in SGN teams can list + start automation docs
- [ ] Ensure `SGN-GuardDuty-EC2Staging-ProtectionRole` exists and has correct GuardDuty trust relationship

---

## 📤 SNS + Notification Checks

- [ ] Ensure SNS Topic exists: `EC2DataTransferApproval`
- [ ] Email subscription is confirmed: `darren.oflaherty@cgi.com`
- [ ] Teams integration (if planned) is active via Lambda or webhook

---

## 🧪 Optional Validations

- [ ] Trigger a manual test Lambda run without a bucket to verify fallback logic
- [ ] Upload a known test file to the bucket to trigger GuardDuty S3 scan
- [ ] Confirm folder structure auto-creates on new executions

---

## 📦 Change Tracking

- [ ] Version tag applied in Lambda or template: `DeploymentVersion: v4`
- [ ] Ensure commits are pushed to `main` branch
- [ ] Tag latest GitHub release if stability is confirmed (e.g., `v1.0.0`)

---

_Last updated: 2025-03-29_  
_Maintainer: Darren O'Flaherty_
