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

#public subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr[count.index]
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = true
  
  tags = merge(
    var.public_subnet_tags,
    local.common_tags,
    {
        Name="${local.common_suffix_name}-public-${local.az_names[count.index]}"
    }
  )
}

#private subnets
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr[count.index]
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = true
  
  tags = merge(
    var.private_subnet_tags,
    local.common_tags,
    {
        Name="${local.common_suffix_name}-private-${local.az_names[count.index]}"
    }
  )
}

#database subnets
resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_subnet_cidr[count.index]
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = true
  
  tags = merge(
    var.database_subnet_tags,
    local.common_tags,
    {
        Name="${local.common_suffix_name}-database-${local.az_names[count.index]}"
    }
  )
}

#public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags =  merge(
    var.public_route_table_tags,
    local.common_tags,
    {
        Name="${local.common_suffix_name}-public"
    }
  )
}

#private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags =  merge(
    var.private_route_table_tags,
    local.common_tags,
    {
        Name="${local.common_suffix_name}-private"
    }
  )
}

#database route table
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags =  merge(
    var.database_route_table_tags,
    local.common_tags,
    {
        Name="${local.common_suffix_name}-database"
    }
  )
}

# public route
resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.internet_gateway.id
}

# elastic ip
resource "aws_eip" "elastic_ip" {
  domain   = "vpc"

  tags =  merge(
    var.elastic_ip_tags,
    local.common_tags,
    {
        Name="${local.common_suffix_name}-elastic_ip"
    }
  )
}

# nat gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public[0].id

   tags =  merge(
    var.nat_tags,
    local.common_tags,
    {
        Name="${local.common_suffix_name}-nat"
    }
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.internet_gateway]
}

# Private egress route through NAT
resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}

# Database egress route through NAT
resource "aws_route" "database" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidr)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database" {
  count = length(var.database_subnet_cidr)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}