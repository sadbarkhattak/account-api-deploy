# Application URL Output
output "application_url" {
  description = "URL of the deployed application"
  value       = "http://${aws_lb.main.dns_name}"
}

# Load Balancer Information
output "load_balancer_dns" {
  description = "DNS name of the load balancer"
  value       = aws_lb.main.dns_name
}

output "load_balancer_arn" {
  description = "ARN of the load balancer"
  value       = aws_lb.main.arn
}

# ECS Information
output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "ecs_cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = aws_ecs_cluster.main.arn
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.main.name
}

output "ecs_service_arn" {
  description = "ARN of the ECS service"
  value       = aws_ecs_service.main.id
}

# Container Registry Information
output "container_registry" {
  description = "ECR repository information"
  value = {
    repository_url  = data.aws_ecr_repository.main.repository_url
    registry_id     = data.aws_ecr_repository.main.registry_id
    repository_arn  = data.aws_ecr_repository.main.arn
    repository_name = data.aws_ecr_repository.main.name
  }
}

# CloudWatch Information
output "log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.main.name
}

output "log_group_arn" {
  description = "ARN of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.main.arn
}

# VPC Information
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}