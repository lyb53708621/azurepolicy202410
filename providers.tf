terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.44.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "terraform_test"
    storage_account_name = "tfstatefileyibo"
    container_name       = "tfstatefilecontainer"
    key                  = "dev.terraform.tfstate"
  }
}

provider "azurerm" {
#  skip_provider_registration = true
  features {
  }
}

/* resource "azurerm_resource_group" "tfrg" {
  name     = "${var.environment}-tfrg"
  location = var.location
  tags = {
    Env  = "${var.environment}"
    Costcenter = "nioad001"
  }
} */
