terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.44.0"
    }
  }
}

provider "azurerm" {
  features {

  }

  subscription_id = "9980875a-5dfa-46b2-8b06-99c745492c74"
}