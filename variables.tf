# General variables
variable "environment" {
  type    = string
  default = "dev"
}

variable "location" {
  type    = string
  default = "eastasia"
}

variable "rg_name" {
  type    = string
  default = "terraform_test"
}