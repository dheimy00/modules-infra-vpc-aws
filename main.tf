resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    var.tags,
    {
      Name        = var.vpc_name
      Environment = var.environment
      Project     = var.project_name
    }
  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name        = "${var.vpc_name}-igw"
      Environment = var.environment
      Project     = var.project_name
    }
  )
}

resource "aws_eip" "nat" {
  count  = var.enable_nat_gateway ? length(var.private_subnets) : 0
  domain = "vpc"

  tags = merge(
    var.tags,
    {
      Name        = "${var.vpc_name}-nat-eip-${count.index}"
      Environment = var.environment
      Project     = var.project_name
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
      Name        = "${var.vpc_name}-nat-${count.index}"
      Environment = var.environment
      Project     = var.project_name
    }
  )

  depends_on = [aws_internet_gateway.main]
}

# VPC Endpoints
resource "aws_vpc_endpoint" "s3" {
  count             = var.enable_s3_endpoint ? 1 : 0
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private[0].id]

  tags = merge(
    var.tags,
    {
      Name        = "${var.vpc_name}-s3-endpoint"
      Environment = var.environment
      Project     = var.project_name
    }
  )
}

resource "aws_vpc_endpoint" "dynamodb" {
  count             = var.enable_dynamodb_endpoint ? 1 : 0
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.aws_region}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private[0].id]

  tags = merge(
    var.tags,
    {
      Name        = "${var.vpc_name}-dynamodb-endpoint"
      Environment = var.environment
      Project     = var.project_name
    }
  )
}

# Interface endpoints for other AWS services
resource "aws_vpc_endpoint" "ssm" {
  count             = var.enable_ssm_endpoint ? 1 : 0
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.aws_region}.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids        = aws_subnet.private[*].id

  security_group_ids = [aws_security_group.vpc_endpoints[0].id]

  private_dns_enabled = true

  tags = merge(
    var.tags,
    {
      Name        = "${var.vpc_name}-ssm-endpoint"
      Environment = var.environment
      Project     = var.project_name
    }
  )
}

resource "aws_vpc_endpoint" "ssmmessages" {
  count             = var.enable_ssmmessages_endpoint ? 1 : 0
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.aws_region}.ssmmessages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = aws_subnet.private[*].id

  security_group_ids = [aws_security_group.vpc_endpoints[0].id]

  private_dns_enabled = true

  tags = merge(
    var.tags,
    {
      Name        = "${var.vpc_name}-ssmmessages-endpoint"
      Environment = var.environment
      Project     = var.project_name
    }
  )
}

resource "aws_vpc_endpoint" "ec2messages" {
  count             = var.enable_ec2messages_endpoint ? 1 : 0
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.aws_region}.ec2messages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = aws_subnet.private[*].id

  security_group_ids = [aws_security_group.vpc_endpoints[0].id]

  private_dns_enabled = true

  tags = merge(
    var.tags,
    {
      Name        = "${var.vpc_name}-ec2messages-endpoint"
      Environment = var.environment
      Project     = var.project_name
    }
  )
}

resource "aws_vpc_endpoint" "ecr_api" {
  count               = var.enable_ecr_api_endpoint ? 1 : 0
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = [aws_security_group.vpc_endpoints[0].id]
  private_dns_enabled = true
  tags = merge(
    var.tags,
    {
      Name        = "${var.vpc_name}-ecr-api-endpoint"
      Environment = var.environment
      Project     = var.project_name
    }
  )
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  count               = var.enable_ecr_dkr_endpoint ? 1 : 0
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = [aws_security_group.vpc_endpoints[0].id]
  private_dns_enabled = true
  tags = merge(
    var.tags,
    {
      Name        = "${var.vpc_name}-ecr-dkr-endpoint"
      Environment = var.environment
      Project     = var.project_name
    }
  )
}

resource "aws_vpc_endpoint" "sns" {
  count               = var.enable_sns_endpoint ? 1 : 0
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.sns"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = [aws_security_group.vpc_endpoints[0].id]
  private_dns_enabled = true

  tags = merge(
    var.tags,
    {
      Name        = "${var.vpc_name}-sns-endpoint"
      Environment = var.environment
      Project     = var.project_name
    }
  )
}

resource "aws_vpc_endpoint" "sqs" {
  count               = var.enable_sqs_endpoint ? 1 : 0
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.sqs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = [aws_security_group.vpc_endpoints[0].id]
  private_dns_enabled = true

  tags = merge(
    var.tags,
    {
      Name        = "${var.vpc_name}-sqs-endpoint"
      Environment = var.environment
      Project     = var.project_name
    }
  )
}

resource "aws_vpc_endpoint" "secretsmanager" {
  count               = var.enable_secretsmanager_endpoint ? 1 : 0
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.secretsmanager"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = [aws_security_group.vpc_endpoints[0].id]
  private_dns_enabled = true

  tags = merge(
    var.tags,
    {
      Name        = "${var.vpc_name}-secretsmanager-endpoint"
      Environment = var.environment
      Project     = var.project_name
    }
  )
}

resource "aws_vpc_endpoint" "cloudwatch_logs" {
  count               = var.enable_cloudwatch_logs_endpoint ? 1 : 0
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = [aws_security_group.vpc_endpoints[0].id]
  private_dns_enabled = true

  tags = merge(
    var.tags,
    {
      Name        = "${var.vpc_name}-cloudwatch-logs-endpoint"
      Environment = var.environment
      Project     = var.project_name
    }
  )
}

resource "aws_vpc_endpoint" "cloudwatch_monitoring" {
  count               = var.enable_cloudwatch_monitoring_endpoint ? 1 : 0
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.monitoring"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = [aws_security_group.vpc_endpoints[0].id]
  private_dns_enabled = true

  tags = merge(
    var.tags,
    {
      Name        = "${var.vpc_name}-cloudwatch-monitoring-endpoint"
      Environment = var.environment
      Project     = var.project_name
    }
  )
}

resource "aws_vpc_endpoint" "kms" {
  count               = var.enable_kms_endpoint ? 1 : 0
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.kms"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = [aws_security_group.vpc_endpoints[0].id]
  private_dns_enabled = true

  tags = merge(
    var.tags,
    {
      Name        = "${var.vpc_name}-kms-endpoint"
      Environment = var.environment
      Project     = var.project_name
    }
  )
}

resource "aws_vpc_endpoint" "ecr_public" {
  count               = var.enable_ecr_public_endpoint ? 1 : 0
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.public"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = [aws_security_group.vpc_endpoints[0].id]
  private_dns_enabled = true

  tags = merge(
    var.tags,
    {
      Name        = "${var.vpc_name}-ecr-public-endpoint"
      Environment = var.environment
      Project     = var.project_name
    }
  )
}

resource "aws_vpc_endpoint" "stepfunctions" {
  count               = var.enable_stepfunctions_endpoint ? 1 : 0
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.states"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = [aws_security_group.vpc_endpoints[0].id]
  private_dns_enabled = true

  tags = merge(
    var.tags,
    {
      Name        = "${var.vpc_name}-stepfunctions-endpoint"
      Environment = var.environment
      Project     = var.project_name
    }
  )
}

resource "aws_vpc_endpoint" "lambda" {
  count               = var.enable_lambda_endpoint ? 1 : 0
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.lambda"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = [aws_security_group.vpc_endpoints[0].id]
  private_dns_enabled = true

  tags = merge(
    var.tags,
    {
      Name        = "${var.vpc_name}-lambda-endpoint"
      Environment = var.environment
      Project     = var.project_name
    }
  )
}

# Security group for VPC endpoints
resource "aws_security_group" "vpc_endpoints" {
  count = (
    var.enable_ssm_endpoint ||
    var.enable_ssmmessages_endpoint ||
    var.enable_ec2messages_endpoint ||
    var.enable_ecr_api_endpoint ||
    var.enable_ecr_dkr_endpoint ||
    var.enable_sns_endpoint ||
    var.enable_sqs_endpoint ||
    var.enable_secretsmanager_endpoint ||
    var.enable_cloudwatch_logs_endpoint ||
    var.enable_cloudwatch_monitoring_endpoint ||
    var.enable_kms_endpoint ||
    var.enable_ecr_public_endpoint ||
    var.enable_stepfunctions_endpoint ||
    var.enable_lambda_endpoint
  ) ? 1 : 0
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
      Name        = "${var.vpc_name}-vpc-endpoints-sg"
      Environment = var.environment
      Project     = var.project_name
    }
  )
}
