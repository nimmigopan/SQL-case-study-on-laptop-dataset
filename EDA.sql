use demo;
SELECT * FROM laptop_cleaned;

-- -------------------------------------------------------------------------EDA-----------------------------------------------
-- head
select * from laptop_cleaned
order by 'Id' limit 5;

-- tail
select * from laptop_cleaned
order by 'Id' desc limit 5;

-- random samples
select * from laptop_cleaned
order by rand() limit 5;

-- -------------------------------------------------------------UNIVARIATE ANALYSIS---------------------------------------------------------------------------------------
-- numerical columns
-- "Price" column
-- 8 no: summary [count,min,max,mean,std,q1,q2,q3]
select count(Price),
min(Price),
max(Price),
avg(Price),
std(Price)
from laptop_cleaned;

select
percentile_cont(0.25) within group(order by Price) over() as Q1,
percentile_cont(0.5) within group(order by Price) over() as Median,
percentile_cont(0.75) within group(order by Price) over() as Q3
from laptop_cleaned;

-- missing values
select count(price)
from laptop_cleaned
where Price is null;

-- outliers
select * from (select *,
percentile_cont(0.25) within group(order by Price) over() as Q1,
percentile_cont(0.75) within group(order by Price) over() as Q3
from laptop_cleaned) t
where t.Price < t.Q1 - (1.5*(t.Q3 - t.Q1)) or
t.Price > t.Q3 + (1.5*(t.Q3 - t.Q1))

-- horizontal/vertical histogram
select min(Price),max(Price) from laptop_cleaned;  -- price in range of 9k to 3lac

select Price,
case
	when price between 0 and 25000 then '0-25K'
    when price between 25001 and 50000 then '25K-50K'
    when price between 50001 and 75000 then '50-75K'
    when price between 75001 and 100000 then '75-100K'
    else '>100K'    
end as 'buckets'
from laptop_cleaned;

select t.buckets, count(*) from (select Price,
				case
					when price between 0 and 25000 then '0-25K'
					when price between 25001 and 50000 then '25K-50K'
					when price between 50001 and 75000 then '50-75K'
					when price between 75001 and 100000 then '75-100K'
					else '>100K'    
				end as 'buckets'
				from laptop_cleaned)t
				group by t.buckets;  -- created data for histogram
                
select t.buckets, repeat('*',count(*)) from (select Price,
				case
					when price between 0 and 25000 then '0-25K'
					when price between 25001 and 50000 then '25K-50K'
					when price between 50001 and 75000 then '50-75K'
					when price between 75001 and 100000 then '75-100K'
					else '>100K'    
				end as 'buckets'
				from laptop_cleaned)t
group by t.buckets;
                
select t.buckets, repeat('*',count(*)/10) from (select Price,
				case
					when price between 0 and 25000 then '0-25K'
					when price between 25001 and 50000 then '25K-50K'
					when price between 50001 and 75000 then '50-75K'
					when price between 75001 and 100000 then '75-100K'
					else '>100K'    
				end as 'buckets'
				from laptop_cleaned)t
group by t.buckets;

-- "Inches" column
select count(Inches),
min(Inches),
max(Inches),
avg(Inches) 
from laptop_cleaned;

-- missing values
select count(Inches)
from laptop_cleaned
where Inches is null;

select distinct(Inches) from laptop;

SELECT Inches, COUNT(*) AS count
FROM laptop_cleaned
GROUP BY Inches
ORDER BY count DESC;

-- "resolution_width" column
select count(resolution_width),
min(resolution_width),
max(resolution_width),
avg(resolution_width) 
from laptop_cleaned;

select count(resolution_width)
from laptop_cleaned
where resolution_width is null;

select distinct(resolution_width) from laptop;

SELECT resolution_width, COUNT(*) AS count
FROM laptop_cleaned
GROUP BY resolution_width
ORDER BY count DESC;

-- "resolution_height" column
select count(resolution_height),
min(resolution_height),
max(resolution_height),
avg(resolution_height) 
from laptop_cleaned;

select count(resolution_height)
from laptop_cleaned
where resolution_height is null;

select distinct(resolution_height) from laptop;

SELECT resolution_height, COUNT(*) AS count
FROM laptop_cleaned
GROUP BY resolution_height
ORDER BY count DESC;

-- "cpu_speed" column
select count(cpu_speed),
min(cpu_speed),
max(cpu_speed),
avg(cpu_speed) 
from laptop_cleaned;

select count(cpu_speed)
from laptop_cleaned
where cpu_speed is null;

select distinct(cpu_speed) from laptop;

SELECT cpu_speed, COUNT(*) AS count
FROM laptop_cleaned
GROUP BY cpu_speed
ORDER BY count DESC;

-- "primary_storage" column
select count(primary_storage),
min(primary_storage),
max(primary_storage),
avg(primary_storage)
from laptop_cleaned;

select count(primary_storage)
from laptop_cleaned
where primary_storage is null;

select primary_storage,count(*) as count
from laptop_cleaned
group by primary_storage
order by count desc;

-- "secondary_storage" column
select count(secondary_storage),
min(secondary_storage),
max(secondary_storage),
avg(secondary_storage)
from laptop_cleaned;

select count(secondary_storage)
from laptop_cleaned
where secondary_storage is null;

select secondary_storage,count(*) as count
from laptop_cleaned
group by secondary_storage
order by count desc;

-- "weight" column
select count(weight),
min(weight),
max(weight),
avg(weight)
from laptop_cleaned;

select count(weight)
from laptop_cleaned
where weight is null;

select weight, count(*) as count
from laptop_cleaned
group by weight
order by count desc;

-- CATEGORICAL COLUMNS-------------------------------------------------------------
-- "Company" column
select Company, count(company) as count
from laptop_cleaned
group by Company
order by count desc;

-- "Typename" column
select Typename, count(Typename) as count
from laptop_cleaned
group by Typename
order by count desc;

-- "touchscreen" column
select touchscreen, count(touchscreen) as count
from laptop_cleaned
group by touchscreen
order by count desc;

-- "ips_panel" column
select ips_panel, count(ips_panel) as count
from laptop_cleaned
group by ips_panel
order by count desc;

-- "cpu_brand" column
select cpu_brand, count(cpu_brand) as count
from laptop_cleaned
group by cpu_brand
order by count desc;

-- "Ram" column
select Ram, count(Ram) as count
from laptop_cleaned
group by Ram
order by count desc;

-- "memory_type" column
select memory_type, count(memory_type) as count
from laptop_cleaned
group by memory_type
order by count desc;

-- "gpu_brand" column
select gpu_brand, count(gpu_brand) as count
from laptop_cleaned
group by gpu_brand
order by count desc;

-- "OpSys" column
select OpSys, count(OpSys) as count
from laptop_cleaned
group by OpSys
order by count desc;

-- -----------------------------------------------------BIVARIATE ANALYSIS---------------------------------------------------------------------------------------------------
-- NUMERICAL & NUMERICAL-----------------------------------
select cpu_speed, Price from laptop_cleaned;
select resolution_width, Price from laptop_cleaned;
select resolution_height, Price from laptop_cleaned;
select Inches, Price from laptop_cleaned;
select Weight, Price from laptop_cleaned;

-- CATEGORICAL & CATEGORICAL--------------------------------
select Company, touchscreen from laptop_cleaned;
select Company,
sum(case when touchscreen = 1 then 1 else 0 end) as 'Touchscreen_yes',
sum(case when touchscreen = 0 then 1 else 0 end) as 'Touchscreen_no'
from laptop_cleaned
group by Company;

select Company, Typename from laptop_cleaned;
select distinct(Typename) from laptop_cleaned;
select Company,
sum(case when Typename = 'Ultrabook' then 1 else 0 end) as 'Ultrabook',
sum(case when Typename = 'Notebook' then 1 else 0 end) as 'Notebook',
sum(case when Typename = 'Gaming' then 1 else 0 end) as 'Gaming',
sum(case when Typename = '2 in 1 Convertible' then 1 else 0 end) as '2 in 1 Convertible',
sum(case when Typename = 'Workstation' then 1 else 0 end) as 'Workstation',
sum(case when Typename = 'Netbook' then 1 else 0 end) as 'Netbook'
from laptop_cleaned
group by Company;

select Company, cpu_brand from laptop_cleaned;
select distinct(cpu_brand) from laptop_cleaned;
select Company,
sum(case when cpu_brand = 'Intel' then 1 else 0 end) as 'Intel',
sum(case when cpu_brand = 'AMD' then 1 else 0 end) as 'AMD',
sum(case when cpu_brand = 'Samsung' then 1 else 0 end) as 'Samsung'
from laptop_cleaned
group by Company;

select Company, gpu_brand from laptop_cleaned;
select distinct(gpu_brand) from laptop_cleaned;
select Company,
sum(case when gpu_brand = 'Intel' then 1 else 0 end) as 'Intel',
sum(case when gpu_brand = 'AMD' then 1 else 0 end) as 'AMD',
sum(case when gpu_brand = 'Nvidia' then 1 else 0 end) as 'Nvidia',
sum(case when gpu_brand = 'ARM' then 1 else 0 end) as 'ARM'
from laptop_cleaned
group by Company;

select Company, OpSys from laptop_cleaned;
select distinct(OpSys) from laptop_cleaned;
select Company,
sum(case when OpSys = 'macOS' then 1 else 0 end) as 'macOS',
sum(case when OpSys = 'windows' then 1 else 0 end) as 'windows',
sum(case when OpSys = 'linux' then 1 else 0 end) as 'linux',
sum(case when OpSys = 'Android' then 1 else 0 end) as 'Android',
sum(case when OpSys = 'other' then 1 else 0 end) as 'other',
sum(case when OpSys = 'No OS' then 1 else 0 end) as 'No OS'
from laptop_cleaned
group by Company;

select Company, memory_type from laptop_cleaned;
select distinct(memory_type) from laptop_cleaned;
select Company,
sum(case when memory_type = 'SSD' then 1 else 0 end) as 'SSD',
sum(case when memory_type = 'HDD' then 1 else 0 end) as 'HDD',
sum(case when memory_type = 'Flash Storage' then 1 else 0 end) as 'Flash Storage',
sum(case when memory_type = 'Hybrid' then 1 else 0 end) as 'Hybrid'
from laptop_cleaned
group by Company;

-- NUM & CAT ---------------------------------------------------------------------------------------
-- company vs price
select company, min(Price), max(Price), avg(Price), std(Price)
from laptop
group by Company;

-- MISSING VALUE TREATMENT------------------------------------------------------------------------------------------------------------------------------------------
-- if there are missing values in 'price',
-- (1) replace missing values with mean of price
update laptop
set price = (select avg(Price) from laptop)
where Price is null;

-- (2) replace missing values with mean Price of corresponding company
update laptop l1
set price = (select avg(Price) from laptop l2 where l2.Company = l1.Company)
where Price is null;

-- (3) corresponding company + Processor
update laptop l1
set price = (select avg(Price) from laptop l2 
			where l2.Company = l1.Company
            and l2.cpu_name = l2.cpu_name)
where Price is null;

-- ----------------------------------------FEATURE ENGINEERING--------------------------------------------------------------------------------------------------------------

-- creating new column "PPI"
alter table laptop_cleaned
add column ppi int;

select round(sqrt((resolution_width*resolution_width)+(resolution_height*resolution_height))/Inches)
from laptop_cleaned;

SET SQL_SAFE_UPDATES = 0;
update laptop_cleaned
set ppi = round(sqrt((resolution_width*resolution_width)+(resolution_height*resolution_height))/Inches);

select * from laptop_cleaned;

-- generalizing "Inches" column
select Inches from laptop_cleaned;
alter table laptop_cleaned
add column screen_size varchar(255);

update laptop_cleaned
set screen_size = 
case
	when Inches < 14.0 then 'small'
    when Inches >= 14.0 and Inches < 17.0 then 'medium'
    else 'large'
end;

select * from laptop_cleaned;

select screen_size, avg(Price)
from laptop_cleaned
group by screen_size;

-- ---------------------------------------- ONE HOT ENCODING---------------------------------------------------------------------------------------------------------------
-- eg) gpu_brand

select gpu_brand,
case when gpu_brand = 'Intel' then 1 else 0 end as 'Intel',
case when gpu_brand = 'AMD' then 1 else 0 end as 'AMD',
case when gpu_brand = 'Nvidia' then 1 else 0 end as 'Nvidia',
case when gpu_brand = 'ARM' then 1 else 0 end as 'ARM'
from laptop_cleaned;