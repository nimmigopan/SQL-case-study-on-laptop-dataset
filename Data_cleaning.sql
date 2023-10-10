use demo;
select * from laptop;

-- CREATING BACKUP
create table laptop_backup like laptop;

insert into laptop_backup
select * from laptop;

-- CHECK MEMORY CONSUMPTION
select * from information_schema.TABLES
WHERE table_schema = 'demo' 
AND table_name = 'laptop';

select data_length from information_schema.TABLES
WHERE table_schema = 'demo' 
AND table_name = 'laptop';

select data_length/1024 from information_schema.TABLES
WHERE table_schema = 'demo' 
AND table_name = 'laptop';

-- NO.OF ROWS IN TABLE
select count(*) from laptop;

-- DISPLAYING COLUMN NAMES
show columns from laptop;
-- or
SELECT column_name
FROM information_schema.columns
WHERE table_schema = 'demo' 
AND table_name = 'laptop';

-- DROPING UNNECESSARY COLUMNS

-- RENAMING COLUMNS
alter table laptop
change `Unnamed: 0` `Id` int;

-- DROP NULL COLUMNS
select * from laptop
where Id is null and Company is null and TypeName is null and Inches is null and ScreenResolution is null and Cpu is null and Ram is null and
Memory is null and Gpu is null and OpSys is null and Weight is null and Price is null;

-- delete from laptop
-- where 'Id' in (select 'Id' from laptop
-- where Company is null and TypeName is null and Inches is null and ScreenResolution is null and Cpu is null and Ram is null and
-- Memory is null and Gpu is null and OpSys is null and Weight is null and Price is null);

-- DROP DUPLICATES
select Company,Cpu,Gpu,Inches,Memory,OpSys,Price,Ram,ScreenResolution,TypeName,Weight,Count(*),min(Id)
from laptop
group by Company,Cpu,Gpu,Inches,Memory,OpSys,Price,Ram,ScreenResolution,TypeName,Weight 
having count(*) > 1;

delete from laptop
where Id not in (select min(Id)
				from laptop
				group by Company,Cpu,Gpu,Inches,Memory,OpSys,Price,Ram,ScreenResolution,TypeName,Weight
                having count(*) > 1);

select count(*) from laptop;

-- DATA CLEANING

select distinct(Company) from laptop;
select distinct(TypeName) from laptop;
select distinct(Inches) from laptop;

-- "RAM" column ---------------------------------------------------
select distinct(Ram) from laptop;

select replace(Ram,'GB','') from laptop;

SET SQL_SAFE_UPDATES = 0;

UPDATE laptop
SET Ram = (select REPLACE(Ram, 'GB', ''));

alter table laptop modify column Ram int;

select * from laptop;

-- "Weight" column-------------------------------------------------
select distinct(Weight) from laptop;

select replace(Ram,'Kg','') from laptop;

UPDATE laptop
SET Weight = (select REPLACE(Weight, 'kg', ''));

-- alter table laptop modify column Memory decimal(10,2);

select * from laptop;

-- "Price" column ------------------------------------------------------
select distinct(Price) from laptop;

UPDATE laptop
SET Price = (select round(Price));

alter table laptop modify column Price int;

select * from laptop;

-- "OpSys" column -----------------------------------------------------
select distinct(OpSys) from laptop;

select OpSys,
case
	when OpSys like '%mac%' then 'macOS'
    when OpSys like '%windows%' then 'windows'
    when OpSys like '%linux%' then 'linux'
    when OpSys like '%No OS%' then 'No OS'
    when OpSys like '%chrome OS%' then 'chrome'
    when OpSys like '%Android%' then 'Android'
    else 'other'
end
from laptop;

update laptop
set OpSys = case
	when OpSys like '%mac%' then 'macOS'
    when OpSys like '%windows%' then 'windows'
    when OpSys like '%linux%' then 'linux'
    when OpSys like '%No OS%' then 'No OS'
    when OpSys like '%chrome OS%' then 'chrome'
    when OpSys like '%Android%' then 'Android'
    else 'other'
end;

select * from laptop;

-- 'Gpu' column ---------------------------------------------
select distinct(Gpu) from laptop;

alter table laptop
add column gpu_brand varchar(255) after Gpu,
add column gpu_name varchar(255) after gpu_brand;

select * from laptop;

update laptop
set gpu_brand = (select substring_index(Gpu,' ',1));

select * from laptop;

select replace (Gpu,gpu_brand,'') from laptop;

update laptop
set gpu_name = (select replace (Gpu,gpu_brand,''));

alter table laptop drop column Gpu;
select * from laptop;

-- "Cpu" column------------------------------------------------------------------------------------------------------------
select distinct(Cpu) from laptop;

alter table laptop
add column cpu_brand varchar(255) after Cpu,
add column cpu_name varchar(255) after cpu_brand,
add column cpu_speed decimal(10,1) after cpu_name;

select * from laptop;

update laptop
set cpu_brand = (select substring_index(Cpu,' ',1));

select * from laptop;

select substring_index(Cpu,' ',-1) from laptop;

ALTER TABLE laptop
MODIFY COLUMN cpu_speed DECIMAL(5, 2);

-- update laptop
-- set cpu_speed = (select substring_index(Cpu,' ',-1));

UPDATE laptop
SET cpu_speed = CAST(REPLACE(SUBSTRING_INDEX(Cpu, ' ', -1), 'GHz', '') AS DECIMAL(5, 2));

select * from laptop;

select Cpu, replace(Cpu,cpu_brand,''),
substring_index(replace(Cpu,cpu_brand,''),' ',-1)
from laptop;

select replace(replace(Cpu,cpu_brand,''),substring_index(replace(Cpu,cpu_brand,''),' ',-1),'') from laptop;

update laptop
set cpu_name = (select replace(replace(Cpu,cpu_brand,''),substring_index(replace(Cpu,cpu_brand,''),' ',-1),''));

select distinct(cpu_name) from laptop;
select cpu_name,
substring_index(trim(cpu_name),' ',2)
from laptop;

update laptop
set cpu_name = substring_index(trim(cpu_name),' ',2);

alter table laptop drop column Cpu;

select * from laptop;

-- "ScreenResolution" column------------------------------------------------------------------------------------------------
select distinct(ScreenResolution) from laptop;

select ScreenResolution, substring_index(ScreenResolution,' ',-1) from laptop;

select ScreenResolution, 
substring_index(substring_index(ScreenResolution,' ',-1),'x',1), 
substring_index(substring_index(ScreenResolution,' ',-1),'x',-1) 
from laptop;

alter table laptop 
add column resolution_width int after ScreenResolution,
add column resolution_height int after resolution_width;

select * from laptop;

update laptop
set resolution_width = substring_index(substring_index(ScreenResolution,' ',-1),'x',1),
resolution_height = substring_index(substring_index(ScreenResolution,' ',-1),'x',-1);

select * from laptop;

alter table laptop 
add column touchscreen int after resolution_height;

select * from laptop;

select ScreenResolution like '%Touch%' from laptop;

update laptop
set touchscreen = ScreenResolution like '%Touch%';

select * from laptop;

alter table laptop 
add column ips_panel int after touchscreen;

select * from laptop;

select ScreenResolution like '%IPS Panel%' from laptop;

update laptop
set ips_panel = ScreenResolution like '%IPS Panel%';

alter table laptop
drop column ScreenResolution;

select * from laptop;

-- "Memory" column----------------------------------------------------------------------------------------------------------------
select distinct(Memory) from laptop;

alter table laptop
add column memory_type varchar(255) after Memory,
add column primary_storage int after memory_type,
add column secondary_storage int after primary_storage;

select * from laptop;

select Memory,
case
	when Memory like '%SSD%' and Memory like '%HDD%' then 'Hybrid'
    when Memory like '%SSD%' then 'SSD'
    when Memory like '%HDD%' then 'HDD'
    when Memory like '%Flash Storage%' then 'Flash Storage'
	when Memory like '%Hybrid%' then 'Hybrid'
	when Memory like '%Flash Storage%' and Memory like '%HDD%' then 'Hybrid'
    else null
end as 'memory_type'
from laptop;
    
update laptop
set memory_type = case
	when Memory like '%SSD%' and Memory like '%HDD%' then 'Hybrid'
    when Memory like '%SSD%' then 'SSD'
    when Memory like '%HDD%' then 'HDD'
    when Memory like '%Flash Storage%' then 'Flash Storage'
	when Memory like '%Hybrid%' then 'Hybrid'
	when Memory like '%Flash Storage%' and Memory like '%HDD%' then 'Hybrid'
    else null
end;

select * from laptop;

select Memory,
substring_index(Memory,'+',1),
case 
	when Memory like '%+%' then substring_index(Memory,'+',-1) else 0 
end
from laptop;

select Memory,
regexp_substr(substring_index(Memory,'+',1),'[0-9]+'),
case 
	when Memory like '%+%' then regexp_substr(substring_index(Memory,'+',-1),'[0-9]+') else 0 
end
from laptop;

update laptop
set primary_storage = regexp_substr(substring_index(Memory,'+',1),'[0-9]+'),
secondary_storage = case when Memory like '%+%' then regexp_substr(substring_index(Memory,'+',-1),'[0-9]+') else 0 end;

select * from laptop;

select primary_storage,
case when primary_storage <= 2 then primary_storage * 1024 else primary_storage end
from laptop;

select secondary_storage,
case when secondary_storage <= 2 then secondary_storage * 1024 else secondary_storage end
from laptop;

update laptop
set primary_storage = case when primary_storage <= 2 then primary_storage * 1024 else primary_storage end,
secondary_storage = case when secondary_storage <= 2 then secondary_storage * 1024 else secondary_storage end;

alter table laptop
drop column Memory;

select * from laptop;

alter table laptop
drop column gpu_name;

select * from laptop;








