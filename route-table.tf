resource "aws_route_table" "rt_public_primary" {
  vpc_id = aws_vpc.vpc_ap_southeast_1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_ap_southeast_1.id
  }
}

resource "aws_route_table_association" "public_primary_association" {
  subnet_id      = aws_subnet.subnet_ap_southeast_1_public.id
  route_table_id = aws_route_table.rt_public_primary.id
}

resource "aws_route_table" "rt_private_primary" {
  vpc_id = aws_vpc.vpc_ap_southeast_1.id

  route {
    cidr_block                = "192.168.0.16/28"
    vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
  }
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_ap_southeast_1.id
  }
}

resource "aws_route_table_association" "private_primary_association" {
  subnet_id      = aws_subnet.subnet_ap_southeast_1_private.id
  route_table_id = aws_route_table.rt_private_primary.id
}


# Divider region


resource "aws_route_table" "rt_public_secondary" {
  provider = aws.ap_southeast_3
  vpc_id   = aws_vpc.vpc_ap_southeast_3.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_ap_southeast_3.id
  }
}

resource "aws_route_table_association" "public_secondary_association" {
  provider       = aws.ap_southeast_3
  subnet_id      = aws_subnet.subnet_ap_southeast_3_public.id
  route_table_id = aws_route_table.rt_public_secondary.id
}

resource "aws_route_table" "rt_private_secondary" {
  provider = aws.ap_southeast_3
  vpc_id   = aws_vpc.vpc_ap_southeast_3.id

  route {
    cidr_block                = "10.1.0.16/28"
    vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
  }
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_ap_southeast_3.id
  }
}

resource "aws_route_table_association" "private_secondary_association" {
  provider       = aws.ap_southeast_3
  subnet_id      = aws_subnet.subnet_ap_southeast_3_private.id
  route_table_id = aws_route_table.rt_private_secondary.id
}