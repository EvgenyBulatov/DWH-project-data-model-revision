-- Создание таблицы shipping_agreement, справочник тарифов доставки вендора по договору shipping_agreement из данных строки vendor_agreement_description таблицы shipping

create table shipping_agreement 
(
agreement_id int8 not null primary key,
agreement_number varchar(20) not null,
agreement_rate numeric(3, 2) not null,
agreement_commission numeric(3, 2) not null
UNIQUE (agreement_id, agreement_number)
);

-- Заполнение таблицы необходиммыми данными с соблюдением типа данных каждого атрибута 

insert into shipping_agreement (agreement_id, agreement_number, agreement_rate, agreement_commission)
select cast(array_table[1] as int8) as agreement_id, cast(array_table[2] as varchar(20)) as agreement_number, cast(array_table[3] as numeric(3,2)) as agreement_rate, cast(array_table[4] as numeric(3,2)) as agreement_commission  
from (SELECT distinct REGEXP_SPLIT_TO_ARRAY(vendor_agreement_description, ':') AS array_table
from public.shipping s ) as ones;
