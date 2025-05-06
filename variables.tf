variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for your private subnets"
  type        = bool
  default     = true
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "enable_vpc_endpoints" {
  description = "Should be true if you want to provision VPC endpoints for AWS services"
  type        = bool
  default     = true
}

variable "enable_s3_endpoint" {
  description = "Should be true if you want to provision S3 VPC endpoint"
  type        = bool
  default     = false
}

variable "enable_dynamodb_endpoint" {
  description = "Should be true if you want to provision DynamoDB VPC endpoint"
  type        = bool
  default     = false
}

variable "enable_ssm_endpoint" {
  description = "Should be true if you want to provision SSM VPC endpoint"
  type        = bool
  default     = false
}

variable "enable_ssmmessages_endpoint" {
  description = "Should be true if you want to provision SSM Messages VPC endpoint"
  type        = bool
  default     = false
}

variable "enable_ec2messages_endpoint" {
  description = "Should be true if you want to provision EC2 Messages VPC endpoint"
  type        = bool
  default     = false
} 