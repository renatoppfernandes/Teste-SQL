create or replace trigger item_loc_soh_hist
 after update or insert or delete item_loc_soh
 for each row
  declare
    l_st_oper      char(1);
	l_erro_message varchar2(200);
	
  begin
  
    if inserting then
	  l_st_oper = 'I';
	
	elsif updating then
	  l_st_oper = 'U';
		   
	elsif deleting then
	  l_st_oper = 'D';
	
	end if;
	
	insert into item_loc_soh_hist (
           item,
           loc,
           dt_oper,
           dept,
           unit_cost,
           old_unit_cost,
           stock_on_hand,
           old_stock_on_hand,
           value_stock,
           old_value_stock,
           st_oper
           )
     Values (
           :NEW.item,
           :NEW.loc,
           sysdate,
           :NEW.dept,
           :NEW.unit_cost,
           :OLD.old_unit_cost,
           :NEW.stock_on_hand,
           :OLD.old_stock_on_hand,
           :NEW.value_stock,
           :OLD.old_value_stock,
           l_st_oper
           );
		   
  exception
    when others then 
	  l_erro_message := 'Trigger_Error '|| sqlerrm || 'item_loc_soh_hist';
	  
	  raise_application_error(api_library.trigger_exception, l_erro_message):
	
end;

