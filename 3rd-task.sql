-- Создание таблицы shipping_transfer, справочник о типах доставки shipping_transfer из строки shipping_transfer_description

create table shipping_transfer
(
id serial primary key,
transfer_type varchar(2) not null,
transfer_model text not null,
shipping_transfer_rate numeric(14, 3) not null,
UNIQUE (transfer_type, transfer_model, shipping_transfer_rate)
);

-- Заполнение таблицы данными из отношения shipping

insert into shipping_transfer (transfer_type, transfer_model, shipping_transfer_rate)
select cast(descrip[1] as varchar(2)) as transfer_type, cast(descrip[2] as text) as  transfer_model, shipping_transfer_rate
from
(select distinct REGEXP_SPLIT_TO_ARRAY(shipping_transfer_description, ':') as descrip, shipping_transfer_rate  from public.shipping) as table_for_aaray;

