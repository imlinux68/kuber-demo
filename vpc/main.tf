data "aws_availability_zones" "available" {}

locals {
	name = var.cluster_name
	region = var.region

	vpc_cidr = "10.0.0.0/16"
	azs      = slice(data.aws_availability_zones.available.names, 0, 3)

	tags = {
		DevtedsStack	= local.name
		DevtedsStackName = "vpc"
		"kubernetes.io/cluster/${var.cluster_name}" = "shared"
	}
}

module "vpc" {
	source = "terraform-aws-modules/vpc/aws"
	version = "4.0.0"

	name = local.name
	cidr = local.vpc_cidr

	azs		= local.azs
	private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
	public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k + 48)]
	intra_subnets   = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k + 52)]

	map_public_ip_on_launch = true

	enable_ipv6 = true
	create_egress_only_igw = true
	private_subnet_ipv6_prefixes = [0, 1, 2]
	public_subnet_ipv6_prefixes = [3, 4, 5]
	intra_subnet_ipv6_prefixes = [6, 7, 8]

	enable_nat_gateway = true
	single_nat_gateway = true
	enable_dns_hostnames = true

	enable_flow_log = true
	enable_flow_log_cloudwatch_iam_role = true
	enable_flowlog_cloudwatch_log_group = true
}

