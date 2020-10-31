variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "us-east-1"
}
variable "acm_front_end_arn" {
	description = "ARN for ssl certificate"
}

# variable "aws_account_id" {
#   description = "AWS account ID"
# }

variable "az_count" {
  description = "Number of AZs to cover in a given AWS region"
  default     = "2"
}

variable "web_app_image" {
  description = "Docker image to run in the ECS cluster"
}

variable "data_app_image" {
  description = "Docker image for data server to run in the ECS cluster"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 3000
}

variable "data_app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 5001
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 2
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "256"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "512"
}
