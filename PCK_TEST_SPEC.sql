create or replace PACKAGE PCK_TEST
IS

 FUNCTION tab_loc 
   RETURN loc_type_collection PIPELINED;

 PROCEDURE MERG_ITEM_LOC_SOH_VALUE 
 (i_item          IN item_loc_soh_value.item%TYPE,
  i_loc           IN item_loc_soh_value.loc%TYPE,
  i_dept          IN item_loc_soh_value.dept%TYPE,
  i_unit_cost     IN item_loc_soh_value.unit_cost%TYPE,
  i_stock_on_hand IN item_loc_soh_value.stock_on_hand%TYPE,
  i_value_stock   IN item_loc_soh_value.value_stock%TYPE);

 PROCEDURE GET_ITEM_LOC_USER
 (i_item     IN  item_loc_soh_value.item%TYPE,
  i_loc      IN  item_loc_soh_value.loc%TYPE,
  i_user_id  IN  user.user_id%TYPE
  o_data     OUT sys_refcursor)

 
 FUNCTION CREATE_FILE ()
   RETURN TRUE;

END PCK_TEST;