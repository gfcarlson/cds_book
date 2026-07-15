// Incl. TotalNetAmount for exception aggregation 

@AbapCatalog.sqlViewName: 'ZB_SOIC06'
@EndUserText.label: 'Analytic Cube 06 for Sales Order Items'

@Analytics.dataCategory: #CUBE

define view ZB_SalesOrderItemCube06
  as select from I_SalesOrderItem
  
{
  SalesOrder,
  _SalesOrder,
  SalesOrderItem,
  CreationDate,
  _SalesOrder.SalesOrganization, 
  _SalesOrder._SalesOrganization,
  _SalesOrder.SoldToParty,
  _SalesOrder._SoldToParty,
  _SalesOrder._SoldToParty.Country as SoldToCountry, 
  Material, 
  _Material, 
  @Aggregation.default: #SUM
  OrderQuantity, 
  OrderQuantityUnit,
  _OrderQuantityUnit,
  @Aggregation.default: #SUM
  NetAmount, 
  TransactionCurrency, 
  _TransactionCurrency,
  @Aggregation.default: #MAX
  _SalesOrder.TotalNetAmount
}


