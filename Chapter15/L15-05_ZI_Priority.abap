@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Processing Priority'
@ObjectModel.representativeKey: 'Priority'
define view entity ZI_Priority as select from DDCDS_CUSTOMER_DOMAIN_VALUE( p_domain_name: 'ZZPRIORITY' )
  association [0..*] to ZI_PriorityText as _Text on $projection.Priority = _Text.Priority
{
      @ObjectModel.text.association: '_Text'
  key cast( value_low as zzpriority ) as Priority,
      _Text
}
