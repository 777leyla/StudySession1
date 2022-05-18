module "app-vpc" {
  source   = "../CHILD"
  vpc_cidr = "29.0.0.0/16"
  pub_cidr = "29.0.1.0/24"
  prv_cidr = "29.0.2.0/24"
  tag      = "leyla"
}