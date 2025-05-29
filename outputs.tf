output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private[*].id
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = aws_nat_gateway.main[*].id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = aws_route_table.public.id
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = aws_route_table.private[*].id
}

output "cloudwatch_logs_endpoint_id" {
  description = "The ID of the CloudWatch Logs VPC endpoint"
  value       = var.enable_cloudwatch_logs_endpoint ? aws_vpc_endpoint.cloudwatch_logs[0].id : null
}

output "cloudwatch_monitoring_endpoint_id" {
  description = "The ID of the CloudWatch Monitoring VPC endpoint"
  value       = var.enable_cloudwatch_monitoring_endpoint ? aws_vpc_endpoint.cloudwatch_monitoring[0].id : null
}

output "kms_endpoint_id" {
  description = "The ID of the KMS VPC endpoint"
  value       = var.enable_kms_endpoint ? aws_vpc_endpoint.kms[0].id : null
}

output "ecr_public_endpoint_id" {
  description = "The ID of the ECR Public VPC endpoint"
  value       = var.enable_ecr_public_endpoint ? aws_vpc_endpoint.ecr_public[0].id : null
}

output "stepfunctions_endpoint_id" {
  description = "The ID of the Step Functions VPC endpoint"
  value       = var.enable_stepfunctions_endpoint ? aws_vpc_endpoint.stepfunctions[0].id : null
}

output "lambda_endpoint_id" {
  description = "The ID of the Lambda VPC endpoint"
  value       = var.enable_lambda_endpoint ? aws_vpc_endpoint.lambda[0].id : null
} 