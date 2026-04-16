variable "vpc_cidr_block" {

  type = string

}



variable "public_subnets" {

  type = map(object({ cidr_block = string, availability_zone = string }))

  default = {

    public-a = { cidr_block = "10.0.1.0/24", availability_zone = "eu-west-2a" }
    public-b = { cidr_block = "10.0.2.0/24", availability_zone = "eu-west-2b" }


  }

}



variable "private_subnets" {

  type = map(object({ cidr_block = string, availability_zone = string }))

  default = {

    private-a = { cidr_block = "10.0.3.0/24", availability_zone = "eu-west-2a" }
    private-b = { cidr_block = "10.0.4.0/24", availability_zone = "eu-west-2b" }


  }

}




variable "domain" {

  type = string

}