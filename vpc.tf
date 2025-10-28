resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = var.instance_tentency
  enable_dns_hostnames = true

  tags =merge(
    var.vpc_tags,
    locals.common_tags,
    {
        Name=locals.common_suffix_name
    }
  )
}

# resource "aws_internet_gateway" "internet_gateway" {
#   vpc_id = aws_vpc.main.id

#   tags = {
#     Name = "main"
#   }
# }
