terraform {
  backend "s3" {
    bucket = "eks-gatus-statefile"
    key    = "path/to/my/key"
    region = "eu-west-2"
  }
}
