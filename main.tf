terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    var.tags,
    {
      Name = var.vpc_name
    }
  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-igw"
    }
  )
}

resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? length(var.private_subnets) : 0
  vpc   = true

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-nat-eip-${count.index}"
    }
  )
}

resource "aws_nat_gateway" "main" {
  count         = var.enable_nat_gateway ? length(var.private_subnets) : 0
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-nat-${count.index}"
    }
  )

  depends_on = [aws_internet_gateway.main]
}

# VPC Endpoints
resource "aws_vpc_endpoint" "s3" {
  count             = var.enable_s3_endpoint ? 1 : 0
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private[0].id]

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-s3-endpoint"
    }
  )
}

resource "aws_vpc_endpoint" "dynamodb" {
  count             = var.enable_dynamodb_endpoint ? 1 : 0
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private[0].id]

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-dynamodb-endpoint"
    }
  )
}

# Interface endpoints for other AWS services
resource "aws_vpc_endpoint" "ssm" {
  count             = var.enable_ssm_endpoint ? 1 : 0
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids        = aws_subnet.private[*].id

  security_group_ids = [aws_security_group.vpc_endpoints[0].id]

  private_dns_enabled = true

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-ssm-endpoint"
    }
  )
}

resource "aws_vpc_endpoint" "ssmmessages" {
  count             = var.enable_ssmmessages_endpoint ? 1 : 0
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.ssmmessages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = aws_subnet.private[*].id

  security_group_ids = [aws_security_group.vpc_endpoints[0].id]

  private_dns_enabled = true

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-ssmmessages-endpoint"
    }
  )
}

resource "aws_vpc_endpoint" "ec2messages" {
  count             = var.enable_ec2messages_endpoint ? 1 : 0
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.ec2messages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = aws_subnet.private[*].id

  security_group_ids = [aws_security_group.vpc_endpoints[0].id]

  private_dns_enabled = true

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-ec2messages-endpoint"
    }
  )
}

# Security group for VPC endpoints
resource "aws_security_group" "vpc_endpoints" {
  count       = (var.enable_ssm_endpoint || var.enable_ssmmessages_endpoint || var.enable_ec2messages_endpoint) ? 1 : 0
  name        = "${var.vpc_name}-vpc-endpoints-sg"
  description = "Security group for VPC endpoints"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-vpc-endpoints-sg"
    }
  )
}

# Get current region
data "aws_region" "current" {} 