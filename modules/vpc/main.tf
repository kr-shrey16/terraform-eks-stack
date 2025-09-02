resource "aws_vpc" "test-eks-vpc01" {
  cidr_block = "172.16.0.0/16"
}

resource "aws_subnet" "pub_subnet01" {
  vpc_id     = aws_vpc.test-eks-vpc01.id
  cidr_block = "172.16.0.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "test-eks-vpc01-public-subnet01"
  }
}

resource "aws_subnet" "pub_subnet02" {
  vpc_id     = aws_vpc.test-eks-vpc01.id
  cidr_block = "172.16.1.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name = "test-eks-vpc01-public-subnet02"
  }
}

resource "aws_subnet" "pvt_subnet01" {
  vpc_id     = aws_vpc.test-eks-vpc01.id
  cidr_block = "172.16.2.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name = "test-eks-vpc01-pvt-subnet01"
  }
}

resource "aws_subnet" "pvt_subnet02" {
  vpc_id     = aws_vpc.test-eks-vpc01.id
  cidr_block = "172.16.3.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "test-eks-vpc01-pvt-subnet02"
  }
}

resource "aws_internet_gateway" "test_eks_vpc_igw" {
  vpc_id = aws_vpc.test-eks-vpc01.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_route_table" "test_vpc_eks_pub_route_table" {
  vpc_id = aws_vpc.test-eks-vpc01.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_eks_vpc_igw.id
  }

  tags = {
    Name = "${var.vpc_name}-public-igw"
  }
}

resource "aws_route_table_association" "pub_association" {
  for_each = {
    "sub1" = aws_subnet.pub_subnet01.id
    "sub2" = aws_subnet.pub_subnet02.id
  }
  subnet_id      = each.value
  route_table_id = aws_route_table.test_vpc_eks_pub_route_table.id
}

resource "aws_eip" "test_eks_eip" {
  domain   = "vpc"
}


resource "aws_nat_gateway" "test-eks-nat" {
  allocation_id = aws_eip.test_eks_eip.id
  subnet_id     = aws_subnet.pub_subnet01.id

  tags = {
    Name = "${var.vpc_name}-NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.test_eks_vpc_igw]
}

resource "aws_route_table" "test_vpc_eks_pvt_route_table" {
  vpc_id = aws_vpc.test-eks-vpc01.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.test-eks-nat.id
  }

  tags = {
    Name = "${var.vpc_name}-pvt-route-table"
  }
}

resource "aws_route_table_association" "pvt_association" {
  for_each = {
    "sub1" = aws_subnet.pvt_subnet01.id
    "sub2" = aws_subnet.pvt_subnet02.id
  }
  subnet_id      = each.value
  route_table_id = aws_route_table.test_vpc_eks_pvt_route_table.id
}
