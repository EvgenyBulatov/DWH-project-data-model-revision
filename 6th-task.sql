-- Создание представления исходя из требованийй:

/*  shipping_id - id доставки

    vendor_id - уникальный идентификатор вендора
    
    transfer_type — тип доставки из таблицы shipping_transfer
    
    full_day_at_shipping — количество полных дней, в течение которых длилась доставка
    
    is_delay — статус, показывающий просрочена ли доставка
    
    is_shipping_finish — статус, показывающий, что доставка завершена
    
    delay_day_at_shipping — количество дней, на которые была просрочена доставка
    
    payment_amount  — сумма платежа пользователя
    
    vat — итоговый налог на доставку
    
    profit — итоговый доход компании с доставки
*/

create view shipping_datamart as
select si.shipping_id , si.vendor_id, st.transfer_type, case 
	when ss.shipping_start_fact_datetime is not null and ss.shipping_end_fact_datetime is not null then extract(day from (ss.shipping_end_fact_datetime - ss.shipping_start_fact_datetime))
	else 0
end full_day_at_shipping,
case 	
	when ss.shipping_end_fact_datetime is not null and shp.plan is not null and ss.shipping_end_fact_datetime > shp.plan then 1
	else 0
end as is_delay, 
case 
	when ss.status = 'finished' then 1
	else 0
end as is_shipping_finish,
case 
	when ss.shipping_end_fact_datetime > shp.plan then extract(day from (ss.shipping_end_fact_datetime - shp.plan))
	else 0
end as delay_day_at_shipping,
si.payment_amount,
si.payment_amount*(scr.shipping_country_base_rate + sa.agreement_rate + st.shipping_transfer_rate) as vat,
si.payment_amount*sa.agreement_commission as profit
from shipping_transfer st
inner join shipping_info si on si.shipping_transfer_id = st.id
inner join shipping_status ss on ss.shipping_id = si.shipping_id
inner join shipping_agreement sa on sa.agreement_id  = si.shipping_agreement_id
inner join shipping_country_rates scr on scr.id = si.shipping_country_rate_id 
inner join (select distinct shippingid as sid, shipping_plan_datetime as plan
from shipping s) as shp on shp.sid = si.shipping_id 
order by si.shipping_id
