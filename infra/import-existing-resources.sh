#!/bin/bash

# Terraform Import Script for Existing Resources
# This script imports existing AWS resources into Terraform state

set -e

echo "🔧 Importing existing AWS resources into Terraform state..."

# Set variables
APPLICATION_NAME="account-api"
ENVIRONMENT="dev"
REGION="us-east-1"
NAME_PREFIX="${APPLICATION_NAME}-${ENVIRONMENT}"

echo "📦 Application: $APPLICATION_NAME"
echo "🌍 Environment: $ENVIRONMENT"
echo "📍 Region: $REGION"
echo "🏷️ Name Prefix: $NAME_PREFIX"
echo ""

# Initialize Terraform if not already done
echo "🚀 Initializing Terraform..."
terraform init

# Import existing resources
echo "📥 Importing existing resources..."

# Import Load Balancer (if exists)
echo "🔍 Checking for existing Load Balancer..."
ALB_ARN=$(aws elbv2 describe-load-balancers --names "${NAME_PREFIX}-alb" --region $REGION --query 'LoadBalancers[0].LoadBalancerArn' --output text 2>/dev/null || echo "None")
if [ "$ALB_ARN" != "None" ] && [ "$ALB_ARN" != "null" ]; then
    echo "📥 Importing Load Balancer: $ALB_ARN"
    terraform import aws_lb.main "$ALB_ARN" || echo "⚠️ Load Balancer import failed or already imported"
else
    echo "ℹ️ No existing Load Balancer found"
fi

# Import Target Group (if exists)
echo "🔍 Checking for existing Target Group..."
TG_ARN=$(aws elbv2 describe-target-groups --names "${NAME_PREFIX}-tg" --region $REGION --query 'TargetGroups[0].TargetGroupArn' --output text 2>/dev/null || echo "None")
if [ "$TG_ARN" != "None" ] && [ "$TG_ARN" != "null" ]; then
    echo "📥 Importing Target Group: $TG_ARN"
    terraform import aws_lb_target_group.main "$TG_ARN" || echo "⚠️ Target Group import failed or already imported"
else
    echo "ℹ️ No existing Target Group found"
fi

# Import CloudWatch Log Group (if exists)
echo "🔍 Checking for existing CloudWatch Log Group..."
LOG_GROUP_NAME="/ecs/${NAME_PREFIX}"
if aws logs describe-log-groups --log-group-name-prefix "$LOG_GROUP_NAME" --region $REGION --query 'logGroups[0].logGroupName' --output text 2>/dev/null | grep -q "$LOG_GROUP_NAME"; then
    echo "📥 Importing CloudWatch Log Group: $LOG_GROUP_NAME"
    terraform import aws_cloudwatch_log_group.main "$LOG_GROUP_NAME" || echo "⚠️ Log Group import failed or already imported"
else
    echo "ℹ️ No existing CloudWatch Log Group found"
fi

# Import IAM Role (if exists)
echo "🔍 Checking for existing IAM Role..."
ROLE_NAME="${NAME_PREFIX}-ecs-execution-role"
if aws iam get-role --role-name "$ROLE_NAME" --region $REGION >/dev/null 2>&1; then
    echo "📥 Importing IAM Role: $ROLE_NAME"
    terraform import aws_iam_role.ecs_execution "$ROLE_NAME" || echo "⚠️ IAM Role import failed or already imported"
else
    echo "ℹ️ No existing IAM Role found"
fi

# Import ECS Cluster (if exists)
echo "🔍 Checking for existing ECS Cluster..."
CLUSTER_NAME="${NAME_PREFIX}-cluster"
if aws ecs describe-clusters --clusters "$CLUSTER_NAME" --region $REGION --query 'clusters[0].clusterName' --output text 2>/dev/null | grep -q "$CLUSTER_NAME"; then
    echo "📥 Importing ECS Cluster: $CLUSTER_NAME"
    terraform import aws_ecs_cluster.main "$CLUSTER_NAME" || echo "⚠️ ECS Cluster import failed or already imported"
else
    echo "ℹ️ No existing ECS Cluster found"
fi

echo ""
echo "✅ Import process completed!"
echo "🚀 Now running terraform plan to see what needs to be created/updated..."
echo ""

# Run terraform plan
terraform plan -var="docker_image=placeholder" -var="application_name=$APPLICATION_NAME" -var="environment=$ENVIRONMENT" -var="aws_region=$REGION"

echo ""
echo "💡 If the plan looks good, run: terraform apply -auto-approve"