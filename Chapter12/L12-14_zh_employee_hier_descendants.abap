REPORT zh_employee_hier_descendants.

SELECT
  FROM HIERARCHY_DESCENDANTS(
    SOURCE  ZHI_HierarchicalEmployee01
    START WHERE employee = '0005'
  )
  FIELDS
    employee,
    \_employee-employeename,
    node_id,
    parent_id,
    hierarchy_level,
    hierarchy_tree_size,
    hierarchy_rank
  ORDER BY hierarchy_rank
  INTO TABLE @DATA(gt_desc).

cl_demo_output=>write_data( gt_desc ).

cl_demo_output=>display( ).