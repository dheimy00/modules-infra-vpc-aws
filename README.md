# Terraform AWS VPC Module

This module creates a VPC with public and private subnets in an AWS environment.

## Features

- Creates a VPC with configurable CIDR block
- Creates public and private subnets across multiple availability zones
- Creates Internet Gateway for public subnets
- Creates NAT Gateway for private subnets (optional)
- Configurable DNS support and hostnames
- Optional VPC Endpoints for AWS services:
  - S3 (Gateway endpoint - free)
  - DynamoDB (Gateway endpoint - free)
  - SSM (Interface endpoint)
  - SSM Messages (Interface endpoint)
  - EC2 Messages (Interface endpoint)
- Tagging support for all resources

## Usage

```hcl
module "vpc" {
  source = "./modules/vpc"

  vpc_name = "my-vpc"
  vpc_cidr = "10.0.0.0/16"

  # Public subnets - one per AZ for high availability
  public_subnets = [
    "10.0.1.0/24",  # AZ-a
    "10.0.2.0/24"   # AZ-b
  ]

  # Private subnets - one per AZ for high availability
  private_subnets = [
    "10.0.11.0/24",  # AZ-a
    "10.0.12.0/24"   # AZ-b
  ]

  # Enable NAT Gateway for private subnets
  enable_nat_gateway = true

  # Enable specific VPC endpoints
  enable_s3_endpoint        = true  # Free gateway endpoint
  enable_dynamodb_endpoint  = true  # Free gateway endpoint
  enable_ssm_endpoint       = false # Interface endpoint
  enable_ssmmessages_endpoint = false
  enable_ec2messages_endpoint = false

  # Enable DNS support and hostnames
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Environment = "production"
    Terraform   = "true"
    Project     = "my-project"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| vpc_name | Name of the VPC | string | - | yes |
| vpc_cidr | CIDR block for the VPC | string | - | yes |
| enable_dns_hostnames | Should be true to enable DNS hostnames in the VPC | bool | true | no |
| enable_dns_support | Should be true to enable DNS support in the VPC | bool | true | no |
| enable_nat_gateway | Should be true if you want to provision NAT Gateways for your private subnets | bool | true | no |
| enable_s3_endpoint | Should be true if you want to provision S3 VPC endpoint | bool | false | no |
| enable_dynamodb_endpoint | Should be true if you want to provision DynamoDB VPC endpoint | bool | false | no |
| enable_ssm_endpoint | Should be true if you want to provision SSM VPC endpoint | bool | false | no |
| enable_ssmmessages_endpoint | Should be true if you want to provision SSM Messages VPC endpoint | bool | false | no |
| enable_ec2messages_endpoint | Should be true if you want to provision EC2 Messages VPC endpoint | bool | false | no |
| public_subnets | A list of public subnets inside the VPC | list(string) | [] | no |
| private_subnets | A list of private subnets inside the VPC | list(string) | [] | no |
| tags | A map of tags to add to all resources | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | The ID of the VPC |
| vpc_cidr_block | The CIDR block of the VPC |
| public_subnet_ids | List of IDs of public subnets |
| private_subnet_ids | List of IDs of private subnets |
| nat_gateway_ids | List of NAT Gateway IDs |
| internet_gateway_id | The ID of the Internet Gateway | 