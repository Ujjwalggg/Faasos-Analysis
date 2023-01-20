create table driver(
	driver_id integer,
	reg_date date);

insert into driver(driver_id,reg_date) 
 values (1,'01-01-2021'),
		(2,'01-03-2021'),
		(3,'01-08-2021'),
		(4,'01-15-2021');

select * from driver;


create table ingredients(
	ingredient_id integer,
	ingredient_name varchar(60));

insert into ingredients(ingredient_id ,ingredient_name) 
 values (1,'BBQ Chicken'),
		(2,'Chilli Sauce'),
		(3,'Chicken'),
		(4,'Cheese'),
		(5,'Kebab'),
		(6,'Mushrooms'),
		(7,'Onions'),
		(8,'Egg'),
		(9,'Peppers'),
		(10,'schezwan sauce'),
		(11,'Tomatoes'),
		(12,'Tomato Sauce');

select * from ingredients;


create table rolls(
	roll_id integer,
	roll_name varchar(30)); 

insert into rolls(roll_id ,roll_name) 
 values (1,'Non Veg Roll'),
	    (2,'Veg Roll');

select * from rolls;


create table driver_order(
	order_id integer,
	driver_id integer,
	pickup_time datetime,
	distance VARCHAR(7),
	duration VARCHAR(10),
	cancellation VARCHAR(23));

insert into driver_order(order_id,driver_id,pickup_time,distance,duration,cancellation) 
 values (1,1,'01-01-2021 18:15:34','20km','32 minutes',''), 
		(2,1,'01-01-2021 19:10:54','20km','27 minutes',''),
		(3,1,'01-03-2021 00:12:37','13.4km','20 mins','NaN'),
		(4,2,'01-04-2021 13:53:03','23.4','40','NaN'),
		(5,3,'01-08-2021 21:10:57','10','15','NaN'),
		(6,3,null,null,null,'Cancellation'),
		(7,2,'01-08-2020 21:30:45','25km','25mins',null),
		(8,2,'01-10-2020 00:15:02','23.4 km','15 minute',null),
		(9,2,null,null,null,'Customer Cancellation'),
		(10,1,'01-11-2020 18:50:20','10km','10minutes',null);

select * from driver_order;


create table customer_orders(
	order_id integer,
	customer_id integer,
	roll_id integer,
	not_include_items VARCHAR(4),
	extra_items_included VARCHAR(4),
	order_date datetime);

insert into customer_orders(order_id,customer_id,roll_id,not_include_items,extra_items_included,order_date)
 values (1,101,1,'','','01-01-2021  18:05:02'),
		(2,101,1,'','','01-01-2021 19:00:52'),
		(3,102,1,'','','01-02-2021 23:51:23'),
		(3,102,2,'','NaN','01-02-2021 23:51:23'),
		(4,103,1,'4','','01-04-2021 13:23:46'),
		(4,103,1,'4','','01-04-2021 13:23:46'),
		(4,103,2,'4','','01-04-2021 13:23:46'),
		(5,104,1,null,'1','01-08-2021 21:00:29'),
		(6,101,2,null,null,'01-08-2021 21:03:13'),
		(7,105,2,null,'1','01-08-2021 21:20:29'),
		(8,102,1,null,null,'01-09-2021 23:54:33'),
		(9,103,1,'4','1,5','01-10-2021 11:22:59'),
		(10,104,1,null,null,'01-11-2021 18:34:49'),
		(10,104,1,'2,6','1,4','01-11-2021 18:34:49');

select * from customer_orders;


ROLL METRICS

1. How many rolls were ordered?

select count(roll_id) from customer_orders;


2. How many unique orders were placed?

select count(distinct order_id) from customer_orders;


3. How many unique customer orders were placed?

select count(distinct customer_id) from customer_orders;


4. How many sucessful orders were delivered by each driver?

select driver_id, count(distinct order_id) from driver_order where cancellation not like 'Cancellation' or cancellation not like 'Customer Cancellation' group by driver_id;


5. How many of each type of roll was delivered?

select roll_id, count(roll_id) from customer_orders where order_id in (select order_id from driver_order where cancellation not in ('Cancellation', 'Customer Cancellation')) group by roll_id;


6. How many veg and non-veg rolls were delivered by each customer?

select a.*, b.roll_name from (select customer_id, roll_id, count(roll_id) as count from customer_orders group by customer_id, roll_id) a join rolls b on a.roll_id=b.roll_id order by customer_id; 


7. What were the maximum number of rolls delivered in a single order?

select * from
(select *, rank() over(order by cnt desc) rnk from
(select order_id, count(roll_id) as cnt from
(select * from customer_orders where order_id in 
(select order_id from 
(select *, case when cancellation in ('Cancellation', 'Customer Cancellation') then 'c' else 'nc' end as order_details from driver_order)a
where order_details='nc'))b group by order_id)c)d where rnk=1;




