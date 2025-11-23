#!/bin/bash
set -e  # Exit immediately if any command fails

# ------------------------------
# Variables and configuration
# ------------------------------
STACK_NAME="awsbootstrap"                         # Name of the CloudFormation stack
REGION="us-east-1"                               # AWS region to deploy to
CLI_PROFILE="default"                             # AWS CLI profile to use
TEMPLATE_FILE="../templates_files/main.yaml"      # Path to the CloudFormation template
EC2_INSTANCE_TYPE="t2.micro"                     # EC2 instance type
AWS_ACCOUNT_ID="$(aws sts get-caller-identity --profile "$CLI_PROFILE" --query "Account" --output text)"  # Fetch AWS account ID
CODEPIPELINE_BUCKET="$STACK_NAME-$REGION-codepipeline-$AWS_ACCOUNT_ID"  # Name for CodePipeline bucket

# Generate a personal access token with repo and admin:repo_hook
# permissions from https://github.com/settings/tokens

GH_ACCESS_TOKEN="$(cat ~/.github/aws-bootstrap-access-token)"
GH_OWNER="$(cat ~/.github/aws-bootstrap-owner)"
GH_REPO="$(cat ~/.github/aws-bootstrap-repo)"
GH_BRANCH="main"

# ------------------------------
# Deploy CloudFormation template
# ------------------------------
echo -e "\n\n=========== Deploying main.yaml ==========="
aws cloudformation deploy \
    --region "$REGION" \
    --profile "$CLI_PROFILE" \
    --stack-name "$STACK_NAME" \
    --template-file "$TEMPLATE_FILE" \
    --no-fail-on-empty-changeset \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides \
        EC2InstanceType="$EC2_INSTANCE_TYPE" \
        CodePipelineBucket="$CODEPIPELINE_BUCKET" \
        GitHubOwner="$GH_OWNER" \
        GitHubRepo="$GH_REPO" \
        GitHubBranch="$GH_BRANCH" \
        GitHubPersonalAccessToken="$GH_ACCESS_TOKEN"


# ------------------------------
# Show stack status
# ------------------------------
echo -e "\nStack status:"
aws cloudformation describe-stacks \
    --stack-name "$STACK_NAME" \
    --profile "$CLI_PROFILE" \
    --query "Stacks[0].StackStatus" \
    --output text

# ------------------------------
# Fetch and display instance endpoint
# ------------------------------
echo -e "\nFetching instance endpoint..."
aws cloudformation list-exports \
    --profile "$CLI_PROFILE" \
    --query "Exports[?Name=='InstanceEndpoint'].Value" \
    --output text
