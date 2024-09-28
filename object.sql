CREATE OR REPLACE TYPE loc_type AS OBJECT (
    loc number(10),
    loc_desc varchar2(25)
);
/

CREATE OR REPLACE TYPE loc_type_collection AS TABLE OF loc_type;