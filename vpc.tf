#vpc
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = var.instance_tentency
  enable_dns_hostnames = true

  tags = merge(
    var.vpc_tags,
    local.common_tags,
    {
        Name=local.common_suffix_name
    }
  )
}

#IGW
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.igw_tags,
    local.common_tags,
    {
        Name=local.common_suffix_name
    }
  )
}

#subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr[count.index]
  
  tags = merge(
    var.igw_tags,
    local.common_tags,
    {
        Name=local.common_suffix_name
    }
  )
}
