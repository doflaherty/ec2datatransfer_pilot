#!/bin/bash
cd /mnt/data/ec2datatransfer_pilot
git init
git remote add origin https://github.com/doflaherty/ec2datatransfer_pilot.git
git checkout -b main
git add .
git commit -m "Split Stack 1 into roles and lambda/sns components. Updated README and S3 naming."
git push -u origin main