REPORT zh_employee_hier_select.

SELECT
  FROM ZHI_HierarchicalEmployee01
  FIELDS
    employee,
    \_employee-employeename AS node_text,
    node_id,
    parent_id,
    hierarchy_level,
    hierarchy_tree_size,
    hierarchy_rank,
    hierarchy_parent_rank,
    hierarchy_is_orphan,
    hierarchy_is_cycle
  ORDER BY hierarchy_rank
  INTO TABLE @DATA(gt_hier).

cl_demo_output=>write_data( gt_hier ).
cl_demo_output=>display( ).