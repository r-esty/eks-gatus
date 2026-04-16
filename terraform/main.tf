module "vpc" {

    source = "./vpc"

    vpc_cidr_block = "10.0.0.0/16"
    domain = "romeoesty.com"


}