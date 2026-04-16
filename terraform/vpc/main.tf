resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

}



resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}



resource "aws_subnet" "public_subnets" {

  for_each = var.public_subnets
  vpc_id   = aws_vpc.main.id


  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true

  tags = {
    "kubernetes.io/role/elb" = "1"
  }

}


resource "aws_subnet" "private_subnets" {
  for_each             = var.private_subnets
  vpc_id               = aws_vpc.main.id
  cidr_block           = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnets["public-a"].id

  tags = {
    Name = "gw NAT"
  }

}



resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id

  }

}

resource "aws_route_table_association" "public" {


  for_each = var.public_subnets
  subnet_id = aws_subnet.public_subnets[each.key].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  for_each = var.private_subnets
  subnet_id = aws_subnet.private_subnets[each.key].id
  route_table_id = aws_route_table.private.id
}
