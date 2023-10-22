-- Создание таблицы shipping_info, справочник комиссий по странам, с уникальными доставками shipping_id, связанный с созданными справочниками shipping_country_rates, shipping_agreement, shipping_transfer и константной информации о доставке shipping_plan_datetime, payment_amount, vendor_id

create table shipping_info
(
shipping_id int8 not null,
vendor_id int8 not null,
payment_amount numeric(14, 2) not null,
shipping_plan_datetime timestamp not null,
shipping_transfer_id integer not null,
shipping_agreement_id int8 not null,
shipping_country_rate_id integer not null
);

-- Добавление связей через внешнии ключи с тремя ранее созданными справочниками

alter table shipping_info
add constraint fk_shipping_transfer_id foreign key (shipping_transfer_id)
references shipping_transfer (id);

alter table shipping_info
add constraint fk_shipping_agreement_id foreign key (shipping_agreement_id)
references shipping_agreement (agreement_id);

alter table shipping_info
add constraint fk_shipping_country_rate_id foreign key (shipping_country_rate_id)
references shipping_country_rates (id);

-- Добавление ограничение на вставку только уникальных значений по атрибуту shipping_id

ALTER TABLE shipping_info 
ADD CONSTRAINT unique_shipping_id UNIQUE (shipping_id);

-- Заполнение уникальными данными таблицы shipping_info из отношения shipping и трёх ранее созданных справочников

insert into shipping_info (shipping_id, vendor_id, payment_amount, shipping_plan_datetime, shipping_transfer_id, shipping_agreement_id, shipping_country_rate_id)
distinct select s.shippingid, s.vendorid, s.payment_amount, s.shipping_plan_datetime, st.id as shipping_transfer_id, sa.agreement_id as shipping_agreeement_id, scr.id as shipping_country_rate_id
from shipping s inner join shipping_country_rates scr on 
scr.shipping_country = s.shipping_country
inner join shipping_agreement sa 
ON (SELECT (REGEXP_SPLIT_TO_ARRAY(s.vendor_agreement_description, ':'))[1]) = cast(sa.agreement_id as text)
inner join shipping_transfer st 
on s.shipping_transfer_description = concat(st.transfer_type, ':', st.transfer_model);


