resource "aws_vpc" "vpc_ap_southeast_1" {
  cidr_block = "10.1.0.0/24"

  tags = {
    Name = "VPC Primary"
  }
}

resource "aws_subnet" "subnet_ap_southeast_1_public" {
  vpc_id            = aws_vpc.vpc_ap_southeast_1.id
  cidr_block        = "10.1.0.0/28"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "Subnet Public Primary"
  }
}

resource "aws_subnet" "subnet_ap_southeast_1_private" {
  vpc_id            = aws_vpc.vpc_ap_southeast_1.id
  cidr_block        = "10.1.0.16/28"
  availability_zone = "ap-southeast-1b"

  tags = {
    Name = "Subnet Private Primary"
  }
}

resource "aws_internet_gateway" "igw_ap_southeast_1" {
  vpc_id = aws_vpc.vpc_ap_southeast_1.id
}

resource "aws_eip" "eip_nat_ap_southeast_1" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_ap_southeast_1" {
  allocation_id = aws_eip.eip_nat_ap_southeast_1.id
  subnet_id     = aws_subnet.subnet_ap_southeast_1_public.id

  tags = {
    Name = "NAT private primary"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw_ap_southeast_1]
}

data "aws_caller_identity" "peer" {
  provider = aws.ap_southeast_3
}

resource "aws_vpc_peering_connection" "peering" {
  vpc_id        = aws_vpc.vpc_ap_southeast_1.id
  peer_vpc_id   = aws_vpc.vpc_ap_southeast_3.id
  peer_owner_id = data.aws_caller_identity.peer.account_id

  peer_region = "ap-southeast-3"
  auto_accept = false

  tags = {
    Side = "Requester"
  }
}

# Divider Region


resource "aws_vpc_peering_connection_accepter" "peer" {
  provider                  = aws.ap_southeast_3
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}

resource "aws_vpc" "vpc_ap_southeast_3" {
  provider   = aws.ap_southeast_3
  cidr_block = "192.168.0.0/24"

  tags = {
    Name = "VPC Secondary"
  }
}

resource "aws_subnet" "subnet_ap_southeast_3_public" {
  provider          = aws.ap_southeast_3
  vpc_id            = aws_vpc.vpc_ap_southeast_3.id
  cidr_block        = "192.168.0.0/28"
  availability_zone = "ap-southeast-3a"

  tags = {
    Name = "Subnet Public Secondary"
  }
}

resource "aws_internet_gateway" "igw_ap_southeast_3" {
  provider = aws.ap_southeast_3
  vpc_id   = aws_vpc.vpc_ap_southeast_3.id
}

resource "aws_subnet" "subnet_ap_southeast_3_private" {
  provider          = aws.ap_southeast_3
  vpc_id            = aws_vpc.vpc_ap_southeast_3.id
  cidr_block        = "192.168.0.16/28"
  availability_zone = "ap-southeast-3b"

  tags = {
    Name = "Subnet Private Secondary"
  }
}

resource "aws_eip" "eip_nat_ap_southeast_3" {
  provider = aws.ap_southeast_3
  domain   = "vpc"
}

resource "aws_nat_gateway" "nat_ap_southeast_3" {
  provider      = aws.ap_southeast_3
  allocation_id = aws_eip.eip_nat_ap_southeast_3.id
  subnet_id     = aws_subnet.subnet_ap_southeast_3_public.id

  tags = {
    Name = "NAT private secondary"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw_ap_southeast_3]
}
