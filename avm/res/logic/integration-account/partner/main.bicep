metadata name = 'Integration Account Partners'
metadata description = 'This module deploys a Integration Account Partner.'

@description('Required. The Name of the partner resource.')
param name string

@description('Optional. Resource location.')
param location string = resourceGroup().location

@description('Conditional. The name of the parent integration account. Required if the template is used in a standalone deployment.')
param integrationAccountName string

@allowed([
  'B2B'
  'NotSpecified'
])
@description('Required. The partner type.')
param partnerType string

@description('Optional. B2B partner content settings.')
param b2bPartnerContent b2bPartnerContentType?

@description('Optional. The partner metadata.')
param metadata object?

@description('Optional. Resource tags.')
param tags resourceInput<'Microsoft.Logic/integrationAccounts/partners@2019-05-01'>.tags?

resource integrationAccount 'Microsoft.Logic/integrationAccounts@2019-05-01' existing = {
  name: integrationAccountName
}

resource partner 'Microsoft.Logic/integrationAccounts/partners@2019-05-01' = {
  name: name
  parent: integrationAccount
  location: location
  properties: {
    partnerType: partnerType
    metadata: metadata
    content: {
      b2b: b2bPartnerContent
    }
  }
  tags: tags
}

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The type for a B2B partner content.')
type b2bPartnerContentType = {
  @description('Required. The list of partner business identities.')
  businessIdentities: businessIdentityType[]
}

@description('The type for a business identity.')
type businessIdentityType = {
  @description('Required. The business identity qualifier e.g. as2identity, ZZ, ZZZ, 31, 32.')
  qualifier: string
  @description('Required. The user defined business identity value.')
  value: string
}

// ============ //
// Outputs      //
// ============ //

@description('The resource ID of the integration account partner.')
output resourceId string = partner.id

@description('The name of the integration account partner.')
output name string = partner.name

@description('The resource group the integration account partner was deployed into.')
output resourceGroupName string = resourceGroup().name
