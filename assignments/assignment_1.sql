use warehouse demo_warehouse;

use demo_database;

create or replace table ysr_sales_data_final (
  order_id	varchar(30) ,
  order_date date ,	
  ship_date	date ,
  ship_mode	varchar(30) ,
  customer_name	varchar(30) ,
  segment	varchar(30) ,
  state	varchar(100) ,
  country varchar(50) ,	
  market	varchar(20) ,
  region	varchar(20) ,
  product_id	varchar(30) ,
  category	varchar(30) ,
  sub_category	varchar(20) ,
  product_name	varchar(400) ,
  sales	int ,
  quantity	int , 
  discount	number(10 , 3),
  profit	number(15 , 5) ,
  shipping_cost	number(10 , 3) , 
  order_priority varchar(10) ,	
  year int
);


  select * from ysr_sales_data_final;

  create table ysr_sales_data_final_copy as select * from ysr_sales_data_final;

  select * from ysr_sales_data_final_copy;

 --1 .SET PRIMARY KEY.
 
  alter table ysr_sales_data_final
  add primary key (order_id);

  --3. EXTACT THE LAST NUMBER AFTER THE - AND CREATE OTHER COLUMN AND UPDATE IT.
  
  alter table ysr_sales_data_final
  add column order_id_extract int;
  
  update ysr_sales_data_final
  set order_id_extract =  substr(order_id,9) ;
  
  
--4.  FLAG ,IF DISCOUNT IS GREATER THEN 0 THEN  YES ELSE FALSE AND PUT IT IN NEW COLUMN FRO EVERY ORDER ID.

  alter table ysr_sales_data_final
  add column flag_discount char(5);
 
  update ysr_sales_data_final
  set flag_discount =  case when discount > 0 then 'yes'
                      else 'no' 
                      end ;
      
           
--5.  FIND OUT THE FINAL PROFIT AND PUT IT IN COLUMN FOR EVERY ORDER ID

  alter table ysr_sales_data_final
  add column final_profit  decimal(15,5);
  
  update ysr_sales_data_final
  set  final_profit =  profit - shipping_cost ;

--6.  FIND OUT HOW MUCH DAYS TAKEN FOR EACH ORDER TO PROCESS FOR THE SHIPMENT FOR EVERY ORDER ID.

select order_id , datediff(day , order_date, ship_date) as process_day
from ysr_sales_data_final;


/*
   7 . FLAG THE PROCESS DAY AS BY RATING IF IT TAKES LESS OR EQUAL 3  DAYS MAKE 5,
   LESS OR EQUAL THAN 6 DAYS BUT MORE THAN 3 MAKE 4,LESS THAN 10 BUT MORE THAN 6 MAKE 3,
   MORE THAN 10 MAKE IT 2 FOR EVERY ORDER ID.
*/

alter table ysr_sales_data_final
add column process_days int;

update ysr_sales_data_final
set process_day = datediff(day , order_date, ship_date);

select * , case when process_day <= 3 then 5
           when process_day <= 6 then 4
           when process_day <=10 then 3
           else 2 
           end as flag_process_days
from ysr_sales_data_final;