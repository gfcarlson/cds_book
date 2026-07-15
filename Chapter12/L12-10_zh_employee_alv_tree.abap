REPORT zh_employee_alv_tree.

TYPES:
  BEGIN OF ty_gs_hierarchy_display,
    employee              TYPE char4,
    node_text             TYPE text40,
    node_id               TYPE char20,
    parent_id             TYPE char20,
    hierarchy_level       TYPE i,
    hierarchy_tree_size   TYPE i,
    hierarchy_rank        TYPE i,
    hierarchy_parent_rank TYPE i,
    hierarchy_is_orphan   TYPE int1,
    hierarchy_is_cycle    TYPE int1,
    alv_node_key          TYPE salv_de_node_key,
  END OF ty_gs_hierarchy_display.
TYPES: ty_gt_hierarchy_display TYPE STANDARD TABLE OF ty_gs_hierarchy_display.

* read from hierarchy
DATA: gt_hierarchy_display  TYPE ty_gt_hierarchy_display.
SELECT FROM ZHI_HierarchicalEmployee01
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
INTO CORRESPONDING FIELDS OF TABLE @gt_hierarchy_display.

* display hierarchy in ALV tree
DATA: gr_tree                 TYPE REF TO cl_salv_tree.
DATA: gt_hierarchy_display2   TYPE ty_gt_hierarchy_display.
DATA: lr_alv_node             TYPE REF TO cl_salv_node.

* create empty tree
cl_salv_tree=>factory( IMPORTING  r_salv_tree = gr_tree
                       CHANGING   t_table     = gt_hierarchy_display2 ).

* add nodes to the tree
DATA(gr_alv_nodes) = gr_tree->get_nodes( ).
DATA: lv_tree_text TYPE lvc_value.
LOOP AT gt_hierarchy_display ASSIGNING FIELD-SYMBOL(<ls_node_data>).

  IF <ls_node_data>-hierarchy_level = 1.
    lv_tree_text = <ls_node_data>-node_text.
    lr_alv_node = gr_alv_nodes->add_node(
                            related_node = space
                            relationship = cl_gui_column_tree=>relat_last_child
                            text         = lv_tree_text
                        ).
    <ls_node_data>-alv_node_key = lr_alv_node->get_key( ).
    lr_alv_node->set_data_row(  <ls_node_data> ).
  ELSE.
    READ TABLE gt_hierarchy_display WITH KEY hierarchy_rank = <ls_node_data>-hierarchy_parent_rank
                                    ASSIGNING FIELD-SYMBOL(<ls_parent_data>).
    lv_tree_text = <ls_node_data>-node_text.
    lr_alv_node = gr_alv_nodes->add_node(
                            related_node = <ls_parent_data>-alv_node_key
                            relationship = cl_gui_column_tree=>relat_last_child
                            text         = lv_tree_text
                        ).
    <ls_node_data>-alv_node_key = lr_alv_node->get_key( ).
    lr_alv_node->set_data_row(  <ls_node_data> ).
  ENDIF.
ENDLOOP.

* set column width and labels
DATA(lr_columns) = gr_tree->get_columns( ).
lr_columns->set_optimize( 'X' ).

DATA: lr_column               TYPE REF TO cl_salv_column_tree.
lr_column ?= lr_columns->get_column( 'NODE_TEXT' ).
lr_column->set_short_text('Name').
lr_column->set_technical(  ).
lr_column ?= lr_columns->get_column( 'NODE_ID' ).
lr_column->set_short_text('NodeID').
lr_column ?= lr_columns->get_column( 'PARENT_ID' ).
lr_column->set_short_text('ParentID').
lr_column ?= lr_columns->get_column( 'HIERARCHY_LEVEL' ).
lr_column->set_short_text('Lvl').
lr_column ?= lr_columns->get_column( 'HIERARCHY_TREE_SIZE' ).
lr_column->set_short_text('TrSz').
lr_column ?= lr_columns->get_column( 'HIERARCHY_RANK' ).
lr_column->set_short_text('Rnk').
lr_column ?= lr_columns->get_column( 'HIERARCHY_PARENT_RANK' ).
lr_column->set_short_text('PaRnk').
lr_column ?= lr_columns->get_column( 'HIERARCHY_IS_ORPHAN' ).
lr_column->set_short_text('Orph').
lr_column ?= lr_columns->get_column( 'HIERARCHY_IS_CYCLE' ).
lr_column->set_short_text('Cycle').
lr_column ?= lr_columns->get_column( 'EMPLOYEE' ).
lr_column->set_short_text('Employee').
lr_column ?= lr_columns->get_column( 'ALV_NODE_KEY' ).
lr_column->set_short_text('ALVKey').
lr_column->set_technical(  ).

* display the tree
gr_tree->display( ).