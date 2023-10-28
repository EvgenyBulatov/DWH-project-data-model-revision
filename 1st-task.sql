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


-- Очистку таблиц в случае, если необходимо выполнить перезапись данных можно выполнить с помощью каскадного удаления. Так, выполним очистку данных из таблиц shipping_agreement, shipping_country_rates, shipping_transfer. В результате получим очищенные таблицы  shipping_agreement, shipping_country_rates, shipping_transfer, а также очистим таблицы shipping_info и shipping_datamart, поскольку они являются дочерними и данные из них отчистятся автоматически после очистки родительских таблиц. 


truncate shipping_agreement cascade;

truncate shipping_country_rates cascade;

truncate shipping_transfer cascade;

-- Так как таблицa shipping_datamart уже пуста, то нет необходимости выполнять каскадную очистку таблицы shipping_status?  => исполльзуем следующий скрипт

truncate shipping_status;

-- Однако, если нет необходимости очищать данные из таблиц  shipping_agreement, shipping_country_rates, shipping_transfer, то данные в  shipping_datamart останутся => в случае необходимости очистить данные из  shipping_datamart для отношения shipping_status  также понадобиться выполнить каскадное удаление данных => используем слудующий скрипт:

truncate shipping_status cascade;
