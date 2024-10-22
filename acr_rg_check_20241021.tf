# data "azurerm_resource_group" "acr_terraform_rg" {
#   name = "acr_terraform_test"
# }

# output "display_rg_id" {
#   value = data.azurerm_resource_group.acr_terraform_rg.id
# }

# resource "azurerm_resource_group_policy_assignment" "acr_terraform_rg_check_20241022" {
#   name                 = "acr_terraform_rg_check_20241022"
#   display_name         = "acr_terraform_rg_check_20241022"
#   resource_group_id    = data.azurerm_resource_group.acr_terraform_rg.id
#   policy_definition_id = azurerm_policy_definition.acr_premium_tier.id
# }