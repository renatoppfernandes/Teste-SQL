create or replace view v_item_loc_soh as
select ils.item ||'  -  '||i.item_desc item,
       to_char(ils.loc) ||'  -  '||l.loc_desc loc,
	   to_char(ils.dep) ||'  -  '||d.dept_name dep,
	   ils.unit_cost unit_cost,
	   ils.stock_on_hand stock_on_hand
  from item_loc_soh ils,
       item, i,
	   loc l,
	   deps d
 where ils.item = i.item
   and ils.loc = l.loc
   and ils.dep = d.dept
   ;
	