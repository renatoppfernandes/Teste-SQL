CREATE OR REPLACE PACKAGE BODY PCK_TEST
IS

 FUNCTION tab_loc 
   RETURN loc_type_collection PIPELINED 
   AS
   
   l_loc_type_collection loc_type_collection;
   
   CURSOR c_loc_type is
           select loc_type(loc,loc_desc)
		     from loc
			 ;   
  BEGIN
      
   OPEN c_loc_type;
    LOOP 
	
     FETCH c_loc_type bulk collection into l_loc_type_collection limit 10000;
	 
	 EXIT WHEN l_loc_type_collection.count = 0;
	 
	 FOR i in 1..l_loc_type_collection.count 
	  LOOP
	   pipe row(l_loc_type_collection(i))
	  END LOOP
	 
	END LOOP;
	
   CLOSE c_loc_type;
   
   RETURN;
   
  END;
   

 PROCEDURE MERG_ITEM_LOC_SOH_VALUE
   (i_item          IN item_loc_soh_value.item%TYPE,
    i_loc           IN item_loc_soh_value.loc%TYPE)
 IS 
 BEGIN
 
   MERGE INTO MERG_ITEM_LOC_SOH_VALUE a
     USING (Select item item,
	               loc loc,
	               dept dept,
                   unit_cost unit_cost,
                   stock_on_hand stock_on_hand
               FROM item_loc_soh
			 Where item = i_item
			   and loc  =  nvl(i_loc,loc)
				   ) b
           ON (a.item = b.item and a.loc = b.loc)
     WHEN NOT MATCHED THEN
          INSERT VALUES (b.item, b.loc, b.dept, b.unit_cost, b.stock_on_hand, (b.unit_cost * b.stock_on_hand))
     WHEN MATCHED THEN
          UPDATE SET a.dept = b.dept, a.unit_cost = b.unit_cost, a.stock_on_hand = b.stock_on_hand, a.value_stock = (b.unit_cost * b.stock_on_hand)
		  ;
   
 EXCEPTION
   WHEN OTHERS THEN
   RAISE_APPLICATION_ERROR(-20001, 'Erro Oracle ' || SQLCODE || SQLERRM);
 END;

 PROCEDURE GET_ITEM_LOC_USER
   (i_item     IN  item_loc_soh_value.item%TYPE,
    i_loc      IN  item_loc_soh_value.loc%TYPE,
    i_user_id  IN  user.user_id%TYPE
    o_data     OUT sys_refcursor)
 IS
 
   l_loc_acess_type user_priv.loc_acess_type%TYPE;
   
   cursor get_loc_acess_type is
        select loc_acess_type 
		  from user_priv
		 where user_id = i_user_id;
 BEGIN
   
   OPEN get_loc_acess_type;
    FETCH get_loc_acess_type into l_loc_acess_type;
   CLOSE get_loc_acess_type;
   
   OPEN o_data FOR
   SELECT item item,
	      loc loc,
	      dept dept,
          unit_cost unit_cost,
          stock_on_hand stock_on_hand
     FROM item_loc_soh ils
	WHERE item = nvl(i_item,item)
	  AND loc = nvl(i_loc,loc)
	  AND exists ( select 1
	                 from loc c
					where l_loc_acess_type = 'F'
					  and c.loc = ils.loc
					union
				   select loc 
				     from user_loc_matrix ulm
					where ulm.user_id = i_user_id
					  and l_loc_acess_type != 'F'
					  and ulm.loc = ils.loc
				 )
		  ;

 EXCEPTION
   WHEN OTHERS 
   THEN
   
     IF get_loc_acess_type%isopen then
       close get_loc_acess_type;
     END IF;  
     
     RAISE_APPLICATION_ERROR(-20001, 'Erro Oracle: ' || SQLCODE || ' - ' || SQLERRM);
 END;


 FUNCTION CREATE_FILE ()
   RETURN TRUE
   AS
   
    l_file      UTL_FILE.FILE_TYPE;
    l_line      VARCHAR2(32767);
   
   BEGIN
    l_file := UTL_FILE.FOPEN('<<directory_to_be_defined>>', 'file.csv', 'W');

    l_line := 'LOC;ITEM;DEPT;SOH;UNIT_COST';
    UTL_FILE.PUT_LINE(l_file, l_line);
	
    FOR rec IN (SELECT loc, item, dept, stock_on_hand, unit_cost FROM item_loc_soh) LOOP
        
		l_line := rec.loc || ';' || rec.item || ';' || rec.dept || ';' || rec.stock_on_hand || ';' || rec.unit_cost;
        UTL_FILE.PUT_LINE(l_file, l_line);
    END LOOP;

    UTL_FILE.FCLOSE(l_file);
    
EXCEPTION
    WHEN OTHERS THEN
        
		IF UTL_FILE.IS_OPEN(l_file) THEN
            UTL_FILE.FCLOSE(l_file);
	    END IF;
   
   RETURN;
   
  END;
   
END PCK_TEST;
