
create table item(
    item varchar2(25) not null,
    dept number(4) not null,
    item_desc varchar2(25) not null
);
alter table item add constraint pk_item primary key (item);
create index item_i_01 (item);
create index item_i_02 (item, dept);
alter table item add constraint fk_item_deps foreign key (dept) references deps(dept);

create table loc(
    loc number(10) not null,
    loc_desc varchar2(25) not null
);
alter table loc add constraint pk_loc primary key (loc);
create index loc_i_01 (loc);

create table item_loc_soh(
item varchar2(25) not null,
loc number(10) not null,
dept number(4) not null,
unit_cost number(20,4) not null,
stock_on_hand number(12,4) not null
);
alter table item_loc_soh add constraint pk_item_loc_soh primary key (item, loc);
create index item_loc_soh_i_01 (item);
create index item_loc_soh_i_02 (item, loc, dept);
alter table item_loc_soh add constraint fk_ils_item foreign key (item) references item(item);
alter table item_loc_soh add constraint fk_ils_loc foreign key (loc) references loc(loc);
alter table item_loc_soh add constraint fk_ils_deps foreign key (dept) references item(dept);

create table item_loc_soh_value(
item varchar2(25) not null,
loc number(10) not null,
dept number(4) not null,
unit_cost number(20,4) not null,
stock_on_hand number(12,4) not null,
value_stock number not null
);
alter table item_loc_soh_value add constraint pk_item_loc_soh_value primary key (item, loc);
create index item_loc_soh_value_i_01 (item, loc);
create index item_loc_soh_value_i_02 (item, loc, dept);
alter table item_loc_soh_value add constraint fk_ilsv foreign key (item, loc) references item_loc_soh(item, loc);

create table deps(
dept number(4) not null,
dept_name varchar2(20) not null
);
alter table user add constraint pk_deps primary key (dept);
create index deps_i_01 (dept);

create table user(
user_id varchar2(30) not null,
user_name varchar2(60) not null
);
alter table user add constraint pk_user primary key (user);
create index user_i_01 (user);

create table user_priv(
user_id varchar2(30) not null,
loc_acess_type char(1) not null,
dept_acess_type char(1) not null
);
alter table user_priv add constraint pk_user_priv primary key (user_id);
create index user_priv_i_01 (user_id);
alter table user_priv add constraint user_priv_loc_acess check(loc_acess_type in ('F','L'));
alter table user_priv add constraint user_priv_dept_acess check(dept_acess_type in ('F','L'));
alter table user_priv add constraint fk_up_user foreign key (user_id) references user(user_id);

create table user_loc_matrix(
user_id varchar2(30) not null,
loc number(10) not null
);
alter table user_loc_matrix add constraint pk_user_loc_matrix primary key (user_id, loc);
create index user_loc_matrix_i_01 (user_id, loc);
alter table user_loc_matrix add constraint fk_ulm_user foreign key (user_id) references user(user_id);
alter table user_loc_matrix add constraint fk_ulm_loc foreign key (loc) references loc(loc);

create table user_deps_matrix(
user_id varchar2(30) not null,
dept number(4) not null
);
alter table user_deps_matrix add constraint pk_user_deps_matrix primary key (user_id, dept);
create index user_deps_matrix_i_01 (user_id, dept);
alter table user_deps_matrix add constraint fk_upm_user foreign key (user_id) references user(user_id);
alter table user_deps_matrix add constraint fk_upm_deps foreign key (dept) references deps(dept);


create table item_loc_soh_hist(
item varchar2(25) not null,
loc number(10) not null,
dt_oper date not null,
dept number(4) not null,
unit_cost number(20,4) not null,
old_unit_cost number(20,4) ,
stock_on_hand number(12,4) not null,
old_stock_on_hand number(12,4) ,
value_stock number not null,
old_value_stock number ,
st_oper char(1) not null
);
alter table item_loc_soh_hist add constraint item_loc_soh_hist primary key (item, loc, dt_oper);
create index item_loc_soh_hist_i_01 (item, loc, dt_oper);
create index item_loc_soh_hist_i_02 (item, loc, dt_oper, dept);
alter table item_loc_soh_hist add constraint ilsh_st_oper check(st_oper in ('I','U','D'));