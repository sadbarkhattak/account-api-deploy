terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    # Backend configuration will be provided via CLI
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "self-service-automation"
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}

# Data sources
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {}

# Local values
locals {
  name_prefix = "${var.application_name}-${var.environment}"

  common_tags = {
    Application = var.application_name
    Environment = var.environment
    Region      = var.aws_region
  }
}