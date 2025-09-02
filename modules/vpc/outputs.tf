output "vpc_id" {
  value = aws_vpc.test-eks-vpc01.id
}
output "vpc_cidr_block" {
  value = aws_vpc.test-eks-vpc01.cidr_block
}

output "pub_subnet01" {
  value = aws_subnet.pub_subnet01.id
}

output "pub_subnet02" {
  value = aws_subnet.pub_subnet02.id
}

output "pvt_subnet01" {
  value = aws_subnet.pvt_subnet01.id
}

output "pvt_subnet02" {
  value = aws_subnet.pvt_subnet02.id
}