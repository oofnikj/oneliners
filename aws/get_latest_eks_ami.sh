# get the latest AWS EKS AMI for your region

KUBE_VERSION=1.16
AWS_REGION=us-east-1

aws ec2 describe-images --region=${AWS_REGION} \
  --filters "Name=name,Values=amazon-eks-node-${KUBE_VERSION}-*" \
  --query='Images[*].{CreationDate: CreationDate, ImageId: ImageId}' \
  --output=text | sort -n | tail -n-1 | awk '{print $2}'
