*&---------------------------------------------------------------------*
*& Report zh_hier_descendants_aggregate
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zh_hier_descendants_aggregate.

SELECT
  FROM HIERARCHY_DESCENDANTS_AGGREGATE(
    SOURCE  ZHI_HierarchicalEmployee01 AS h
    JOIN    zhi_employee AS t ON h~employee = t~employee
    MEASURES SUM( t~FullTimeEquivalent ) AS AggFullTimeEquivalent
  )
  FIELDS
    employee,
    \_employee-employeename,
    \_employee-parttimepercent,
    AggFullTimeEquivalent

  INTO TABLE @DATA(gt_aggr).

cl_demo_output=>write_data( gt_aggr ).

cl_demo_output=>display( ).