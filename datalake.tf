resource "random_string" "random-sa" {
  length = 6
  special = false
  upper = false
}


resource "azurerm_storage_account" "fg-datalake-sa" {
  name                = "fgdatalake${random_string.random-sa.result}"
  resource_group_name = azurerm_resource_group.rg.name

  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled = true



  tags = {
    Environment = "Production"
  }
}