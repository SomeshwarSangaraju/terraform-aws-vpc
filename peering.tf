resource "aws_vpc_peering_connection" "main" {

  count = var.isPeering ? 1: 0
#   peer_owner_id = var.peer_owner_id if different account we need peer_owner_id, same account optional
  peer_vpc_id   = data.aws_vpc.default.id # acceptor
  vpc_id        = aws_vpc.main.id # receiver

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  
  auto_accept   = true

  tags = merge(
    var.vpc_tags,
    local.common_tags,
    {
        Name = "${local.common_suffix_name}-default"
    }
  )
}

resource "aws_route" "public_peering" {
  count = var.isPeering ? 1 : 0
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.main[count.index].id
}

resource "aws_route" "default_peering" {
  count = var.isPeering ? 1 : 0
  route_table_id            = data.aws_route_table.main.id
  destination_cidr_block    = var.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.main[count.index].id
}