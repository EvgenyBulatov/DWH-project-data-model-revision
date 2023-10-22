-- Создание таблицы shipping_country_rates, справочник стоимости доставки в страны shipping_country_rates из данных, указанных в shipping_country и shipping_country_base_rate

CREATE TABLE shipping_country_rates (
    id SERIAL PRIMARY KEY,
    shipping_country VARCHAR(255) NOT NULL,
    shipping_country_base_rate DECIMAL(10, 2) NOT NULL,
    UNIQUE (shipping_country, shipping_country_base_rate)
);

-- Заполнение данных из таблицы shipping

insert into shipping_country_rates (shipping_country, shipping_country_base_rate)
select distinct shipping_country, shipping_country_base_rate 
from public.shipping;
