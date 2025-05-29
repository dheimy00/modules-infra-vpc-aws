# AWS VPC Terraform Module

This Terraform module creates a VPC with the following features:

- VPC with custom CIDR block
- Public and private subnets across multiple Availability Zones
- Internet Gateway for public subnets
- NAT Gateways for private subnets
- Route tables for public and private subnets
- VPC Endpoints for various AWS services
- Security groups for VPC endpoints
- Consistent resource tagging across all resources

## Usage

```hcl
module "vpc" {
  source = "path/to/module"

  vpc_name = "my-vpc"
  vpc_cidr = "10.0.0.0/16"

  # Environment and project configuration
  environment  = "prod"
  project_name = "my-project"
  
  # Network configuration
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway = true

  # VPC Endpoints
  enable_s3_endpoint              = true
  enable_dynamodb_endpoint        = true
  enable_ssm_endpoint            = true  # Enables access to SSM, Parameter Store, and Session Manager
  enable_ssmmessages_endpoint    = true
  enable_ec2messages_endpoint    = true
  enable_ecr_api_endpoint        = true  # Enables access to ECR API and login
  enable_ecr_dkr_endpoint        = true
  enable_sns_endpoint            = true
  enable_sqs_endpoint            = true
  enable_secretsmanager_endpoint = true
  enable_cloudwatch_logs_endpoint = true
  enable_cloudwatch_monitoring_endpoint = true
  enable_kms_endpoint            = true
  enable_ecr_public_endpoint     = true
  enable_stepfunctions_endpoint  = true

  # Additional tags for all resources
  tags = {
    Environment = "production"
    Project     = "my-project"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| aws | ~> 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_name | Name of the VPC | `string` | n/a | yes |
| vpc_cidr | CIDR block for the VPC | `string` | n/a | yes |
| environment | Environment name (e.g., dev, staging, prod) | `string` | `"dev"` | no |
| project_name | Name of the project | `string` | `"default"` | no |
| enable_dns_hostnames | Should be true to enable DNS hostnames in the VPC | `bool` | `true` | no |
| enable_dns_support | Should be true to enable DNS support in the VPC | `bool` | `true` | no |
| enable_nat_gateway | Should be true if you want to provision NAT Gateways for your private subnets | `bool` | `true` | no |
| public_subnets | A list of public subnets inside the VPC | `list(string)` | `[]` | no |
| private_subnets | A list of private subnets inside the VPC | `list(string)` | `[]` | no |
| tags | A map of additional tags to add to all resources | `map(string)` | `{}` | no |
| enable_vpc_endpoints | Should be true if you want to provision VPC endpoints for AWS services | `bool` | `true` | no |
| enable_s3_endpoint | Should be true if you want to provision S3 VPC endpoint | `bool` | `false` | no |
| enable_dynamodb_endpoint | Should be true if you want to provision DynamoDB VPC endpoint | `bool` | `false` | no |
| enable_ssm_endpoint | Should be true if you want to provision SSM VPC endpoint (includes Parameter Store and Session Manager) | `bool` | `false` | no |
| enable_ssmmessages_endpoint | Should be true if you want to provision SSM Messages VPC endpoint | `bool` | `false` | no |
| enable_ec2messages_endpoint | Should be true if you want to provision EC2 Messages VPC endpoint | `bool` | `false` | no |
| enable_ecr_api_endpoint | Should be true if you want to provision ECR API VPC endpoint (includes ECR login) | `bool` | `false` | no |
| enable_ecr_dkr_endpoint | Should be true if you want to provision ECR DKR VPC endpoint | `bool` | `false` | no |
| enable_sns_endpoint | Should be true if you want to provision SNS VPC endpoint | `bool` | `false` | no |
| enable_sqs_endpoint | Should be true if you want to provision SQS VPC endpoint | `bool` | `false` | no |
| enable_secretsmanager_endpoint | Should be true if you want to provision Secrets Manager VPC endpoint | `bool` | `false` | no |
| enable_cloudwatch_logs_endpoint | Enable CloudWatch Logs VPC endpoint | `bool` | `false` | no |
| enable_cloudwatch_monitoring_endpoint | Enable CloudWatch Monitoring VPC endpoint | `bool` | `false` | no |
| enable_kms_endpoint | Enable KMS VPC endpoint | `bool` | `false` | no |
| enable_ecr_public_endpoint | Enable ECR Public VPC endpoint | `bool` | `false` | no |
| enable_stepfunctions_endpoint | Enable Step Functions VPC endpoint | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | The ID of the VPC |
| vpc_cidr_block | The CIDR block of the VPC |
| public_subnet_ids | List of IDs of public subnets |
| private_subnet_ids | List of IDs of private subnets |
| nat_gateway_ids | List of NAT Gateway IDs |
| internet_gateway_id | The ID of the Internet Gateway |
| public_route_table_id | The ID of the public route table |
| private_route_table_ids | List of IDs of private route tables |
| cloudwatch_logs_endpoint_id | The ID of the CloudWatch Logs VPC endpoint |
| cloudwatch_monitoring_endpoint_id | The ID of the CloudWatch Monitoring VPC endpoint |
| kms_endpoint_id | The ID of the KMS VPC endpoint |
| ecr_public_endpoint_id | The ID of the ECR Public VPC endpoint |
| stepfunctions_endpoint_id | The ID of the Step Functions VPC endpoint |

## Resource Tagging

All resources created by this module are tagged with the following default tags:

- `Name`: Resource-specific name (e.g., "my-vpc", "my-vpc-public-0", etc.)
- `Environment`: Value from `var.environment` (default: "dev")
- `Project`: Value from `var.project_name` (default: "default")

Additional tags can be provided through the `tags` variable, which will be merged with the default tags.

Example of resource tags:
```hcl
{
  Name        = "my-vpc-public-0"
  Environment = "prod"
  Project     = "my-project"
  Owner       = "DevOps Team"
  CostCenter  = "12345"
  ManagedBy   = "Terraform"
}
```

## Notes

- NAT Gateways are created in public subnets and are used by private subnets to access the internet
- VPC endpoints are created in private subnets
- Each VPC endpoint is optional and can be enabled/disabled using the corresponding variable
- The module supports multiple Availability Zones through the subnet configuration
- The SSM endpoint (`enable_ssm_endpoint`) provides access to Systems Manager, Parameter Store, and Session Manager services
- The ECR API endpoint (`enable_ecr_api_endpoint`) provides access to both ECR API and login functionality
- Subnets are automatically created in available AZs in the current region
- All resources are consistently tagged for better resource management and cost allocation

## License

MIT Licensed. See LICENSE for full details. 