output "vpc_id" {
  value = module.vpc.vpc_id
}
output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "pub_subnet01" {
  value = module.vpc.pub_subnet01
}

output "pub_subnet02" {
  value = module.vpc.pub_subnet02
}

output "pvt_subnet01" {
  value = module.vpc.pvt_subnet01
}

output "pvt_subnet02" {
  value = module.vpc.pvt_subnet02
}

output "cluster_id" {
  value = module.eks.cluster_id
}