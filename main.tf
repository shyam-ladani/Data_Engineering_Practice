# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"

  backend "azurerm" {

    resource_group_name  = "terraform-backend"
    storage_account_name = "terraformbackend2024"
    container_name       = "terraform"
    key                  = "terraformfg-demo-terraform.tfstate"
    #sas_token = "sp=racwdl&st=2023-02-28T22:08:19Z&se=2033-01-03T06:08:19Z&spr=https&sv=2021-06-08&sr=c&sig=s%2F320YVsraHQKMuXGoHq5tJMj8PG2hR7mQrfNnMrY3s%3D"

        
  }

}

provider "azurerm" {
  features {}
}



resource "azurerm_resource_group" "rg" {
  name     = "fg-adf-rg"
  location = "Uk south"
}

