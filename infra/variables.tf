# Core Application Variables
variable "application_name" {
  description = "Name of the application to deploy"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev/prod)"
  type        = string
}

variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "docker_image" {
  description = "Docker image URI to deploy"
  type        = string
}

variable "container_port" {
  description = "Port on which the application listens"
  type        = number
  default     = 3000
}

# Environment-specific defaults
locals {
  environment_config = {
    dev = {
      desired_count = 1
      cpu          = 256
      memory       = 512
      max_capacity = 3
    }
    prod = {
      desired_count = 2
      cpu          = 512
      memory       = 1024
      max_capacity = 10
    }
  }

  config = local.environment_config[var.environment]
}