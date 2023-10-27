-- Создание таблицы shipping_status, таблица стутусов по каждой доставке, которая включает в себя информацию из лога shipping (status , state), а также информацию по фактическому времени доставки shipping_start_fact_datetime, shipping_end_fact_datetime. 

-- shipping_start_fact_datetime — это время state_datetime, когда state заказа перешёл в состояние booked

-- shipping_end_fact_datetime — это время state_datetime , когда state заказа перешел в состояние received

CREATE TABLE public.shipping_status (
	shipping_id int8 NOT NULL,
	status varchar(15) NOT NULL,
	state varchar(15) NOT NULL,
	shipping_start_fact_datetime timestamp NULL,
	shipping_end_fact_datetime timestamp NULL
);

-- Используем оператор with для объявления временных таблиц для хранения последнего актулаьного времени какого-либо действия с заказом, а также для вычисления времени перехода статуса заказа в 'booked' или 'recieved'

with shipping_data as (SELECT shippingid,
       MAX(CASE WHEN state = 'booked' THEN state_datetime else null END) AS shipping_start_fact_datetime,
       MAX(CASE WHEN state = 'recieved' THEN state_datetime else null END) AS shipping_end_fact_datetime
FROM shipping
GROUP BY shippingid),

max_state_datetime AS (
  SELECT shippingid, MAX(state_datetime) AS max_datetime
  FROM shipping
  GROUP BY shippingid)

-- Выполняем заполнение созданной таблицы данными  

insert into shipping_status (shipping_id, status, state, shipping_start_fact_datetime, shipping_end_fact_datetime)
select s.shippingid, s.status, s.state, sd.shipping_start_fact_datetime, sd.shipping_end_fact_datetime from shipping_data sd
right join max_state_datetime msd on msd.shippingid = sd.shippingid
inner join shipping s 
on s.shippingid = msd.shippingid and msd.max_datetime = s.state_datetime 
order by s.shippingid
