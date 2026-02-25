variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "hospital-management"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.180.0.0/16"
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.180.128.0/20", "10.180.144.0/20", "10.180.160.0/20"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.180.0.0/20", "10.180.16.0/20", "10.180.32.0/20"]
}

variable "existing_vpc_id" {
  description = "(Optional) Use an existing VPC by specifying its ID. Leave empty to create a new VPC."
  type        = string
  default     = ""
}

variable "public_subnet_ids" {
  description = "(Optional) List of existing public subnet IDs to use (in AZ order)"
  type        = list(string)
  default     = []
}

variable "private_subnet_ids" {
  description = "(Optional) List of existing private subnet IDs to use (in AZ order)"
  type        = list(string)
  default     = []
}

variable "ecs_task_cpu" {
  description = "ECS task CPU"
  type        = string
  default     = "256"
}

variable "ecs_task_memory" {
  description = "ECS task memory"
  type        = string
  default     = "512"
}

variable "ecs_service_desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
  default     = 2
}

variable "db_engine_version" {
  description = "MySQL engine version"
  type        = string
  default     = "8.0.35"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "RDS allocated storage (GB)"
  type        = number
  default     = 20
}

variable "db_backup_retention_period" {
  description = "RDS backup retention period (days)"
  type        = number
  default     = 1
}

variable "enable_monitoring" {
  description = "Enable CloudWatch monitoring"
  type        = bool
  default     = true
}

variable "shared_execution_role_arn" {
  description = "Shared IAM role ARN used for ECS task execution and task role"
  type        = string
  default     = ""
}
