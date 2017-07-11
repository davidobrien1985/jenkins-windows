#!/bin/bash

# Generate a unique identified for this build. UUID is the easiest
uuid=$(date +"%s")
export AWS_DEFAULT_REGION="$AWS_DEFAULT_REGION"
export AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY"
export jenkins_password="$JENKINS_DEFAULT_PASSWORD"

export ami_id=$(powershell -command '$ami = (Get-EC2ImageByName -Names WINDOWS_2016_BASE -AccessKey $env:AWS_ACCESS_KEY_ID -SecretKey $env:AWS_SECRET_ACCESS_KEY -Region $env:AWS_DEFAULT_REGION).ImageId; $ami')
echo "$ami_id"

packer build \
  -var "soe_version=1.0.1" \
  -var "build_number=1" \
  -var "aws_source_ami=$ami_id" \
  -var "aws_instance_type=m4.large" \
  -var "aws_region=$AWS_DEFAULT_REGION" \
  -var "build_uuid=$uuid" \
  -var "jenkins_password=$jenkins_password" \
  packer/jenkins-master.json
