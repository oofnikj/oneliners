#!/bin/bash

## example use of some AWS CLI filters to launch EC2 instance ##

set -ex

region="${AWS_DEFAULT_REGION:-us-east-1}"
instance_type="t3.micro"
instance_name="test-1"

function get_latest_ubuntu_bionic_ami {
  aws ec2 describe-images --region=$region \
    --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*" \
    --query='Images[*].{CreationDate: CreationDate, ImageId: ImageId}' \
    --output=text | sort -n | tail -n-1 | awk '{print $2}'
}

function get_subnet {
  aws ec2 describe-subnets --region=$region \
    --filters="Name=default-for-az,Values=false" \
    --query='Subnets[-1].{SubnetId: SubnetId}' --output=text
}

aws ec2 run-instances \
  --instance-type $instance_type \
  --image-id $(get_latest_ubuntu_bionic_ami) \
  --subnet-id $(get_subnet) \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance_name}]" \
  --output=json
