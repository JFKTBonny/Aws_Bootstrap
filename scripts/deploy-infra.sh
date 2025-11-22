#!/bin/bash
set -e  # exit on any error

STACK_NAME="awsbootstrap"
REGION="us-east-1"
CLI_PROFILE="default"
TEMPLATE_FILE="../templates_files/main.yaml"
EC2_INSTANCE_TYPE="t2.micro"

# Deploy the CloudFormation template
echo -e "\n\n=========== Deploying main.yaml ==========="
aws cloudformation deploy \
    --region "$REGION" \
    --profile "$CLI_PROFILE" \
    --stack-name "$STACK_NAME" \
    --template-file "$TEMPLATE_FILE" \
    --no-fail-on-empty-changeset \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides EC2InstanceType="$EC2_INSTANCE_TYPE"

# If the deploy succeeded, show the DNS name of the created instance
echo -e "\nFetching instance endpoint..."
aws cloudformation list-exports \
    --profile "$CLI_PROFILE" \
    --query "Exports[?Name=='InstanceEndpoint'].Value" \
    --output text
