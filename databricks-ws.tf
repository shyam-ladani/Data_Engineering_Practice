resource "azurerm_databricks_workspace" "fg-databricks" {
  name                = "fg-databricks-ws"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "trial"



  tags = {
    Environment = "Production"
  }
}