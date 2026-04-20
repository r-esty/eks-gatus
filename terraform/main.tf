module "vpc" {

    source = "./vpc"

    vpc_cidr_block = "10.0.0.0/16"
    domain = "romeoesty.com"


}

module "eks" {

    source = "./eks"
    private_subnets_ids = module.vpc.private_subnets_ids
    public_subnets_ids = module.vpc.public_subnets_ids
}