------------------------------------------------------------------------------------------------------------------------
--1) Получите перечень и общее число поставщиков определенной категории,
--поставляющих указанный вид товара либо поставивших указанный товар в объеме, не менее заданного за определенный период.

SELECT DISTINCT (s.name_sup)
FROM suppliers s
JOIN products p ON s.id_supplier = p.supplier
JOIN orders_store os on s.id_supplier = os.supplier
JOIN categorys c on c.id_category = s.category
JOIN machine_parts mp on p.machine_part = mp.id_machine_part
JOIN types_machine_part tmp on mp.type_machine_part = tmp.id_type_machine_part
JOIN orders_store_products osp on os.id_order_store = osp.order_store
JOIN (SELECT product_order, SUM(count)AS total FROM (SELECT product_order, count FROM orders_store_products) as f
GROUP BY product_order) prod_sum on prod_sum.product_order = p.id_product

WHERE (c.name_category = 'Дилер' AND tmp.name_type = 'Ходовые детали')
    OR (prod_sum.total >= 2 AND mp.name = 'Амортизаторы'
    AND os.order_date BETWEEN '2023-04-05' AND '2023-06-05');

------------------------------------------------------------------------------------------------------------------------
--2) Получите сведения о конкретном виде деталей: какими поставщиками поставляется, их расценки, время поставки.
SELECT name, name_type, name_sup, supplier_price_product, avg_day_delivery FROM products
JOIN machine_parts mp on products.machine_part = mp.id_machine_part
JOIN types_machine_part tmp on mp.type_machine_part = tmp.id_type_machine_part
JOIN suppliers s on s.id_supplier = products.supplier
WHERE name_type = 'Ходовые детали';

------------------------------------------------------------------------------------------------------------------------
--3)Получите перечень и общее число покупателей,
-- купивших указанный вид товара за некоторый период либо сделавших покупку товара в объеме, не менее указанного.
SELECT distinct c.login FROM customers c
JOIN orders_customers oc on c.login = oc.customer_login
JOIN orders_customers_products ocp on oc.id_order_customer = ocp.order_customer
JOIN products p on ocp.product = p.id_product
JOIN machine_parts mp on p.machine_part = mp.id_machine_part
JOIN types_machine_part tmp on mp.type_machine_part = tmp.id_type_machine_part
JOIN (SELECT product, SUM(count)AS total FROM (SELECT product, count FROM orders_customers_products) as f
GROUP BY product) prod_sum on prod_sum.product = p.id_product

WHERE oc.order_date BETWEEN '2023-04-05' AND '2023-06-05' AND name_type = 'Двигательные детали'
OR (prod_sum.total >= 1 AND mp.name = 'Амортизаторы');

------------------------------------------------------------------------------------------------------------------------
--4)Получите перечень, объем и номер ячейки для всех деталей, хранящихся на складе.
SELECT cell_name, cell_max, name FROM storage
JOIN products p on storage.id = p.storage_cell
JOIN machine_parts mp on mp.id_machine_part = p.machine_part;

------------------------------------------------------------------------------------------------------------------------
--5) Выведите в порядке возрастания десять самых продаваемых деталей и десять самых «дешевых» поставщиков.
SELECT name, name_sup, total FROM products
JOIN (SELECT product, SUM(count)AS total FROM (SELECT product, count FROM orders_customers_products UNION
                                               SELECT product, count FROM requests_customers_products) as f
GROUP BY product) prod on prod.product = products.id_product
JOIN machine_parts mp on products.machine_part = mp.id_machine_part
JOIN suppliers s on products.supplier = s.id_supplier
ORDER BY total DESC;

------------------------------------------------------------------------------------------------------------------------
--6) Получите среднее число продаж на месяц по любому виду деталей.
SELECT EXTRACT(MONTH FROM order_date) AS sale_month, AVG(count) AS average_sales
FROM orders_customers
JOIN orders_customers_products ocp on orders_customers.id_order_customer = ocp.order_customer
JOIN products p on p.id_product = ocp.product
JOIN machine_parts mp on mp.id_machine_part = p.machine_part
JOIN types_machine_part tmp on mp.type_machine_part = tmp.id_type_machine_part
WHERE tmp.name_type = 'Ходовые детали'
GROUP BY sale_month;

------------------------------------------------------------------------------------------------------------------------
--7) Получите долю товара конкретного поставщика в процентах, деньгах, единицах от всего оборота магазина,
-- прибыль магазина за указанный период.

SELECT (SUM(amount) - (SELECT SUM(total_price) FROM orders_store
                        WHERE order_date BETWEEN '2023-04-05' AND '2023-06-05')) as pribyl
FROM orders_customers
JOIN money_transactions mt on orders_customers.transaction = mt.id_transaction
JOIN orders_customers_products ocp on orders_customers.id_order_customer = ocp.order_customer
WHERE order_date BETWEEN '2023-04-05' AND '2023-06-05';

SELECT (sup / total) * 100 AS percentage_total, sup as money, edinicy.count FROM (SELECT SUM(in_time_price_product * count) as sup FROM orders_customers
JOIN orders_customers_products ocp on orders_customers.id_order_customer = ocp.order_customer
JOIN products p on p.id_product = ocp.product
WHERE supplier = 6) sup, (SELECT SUM(amount) as total FROM orders_customers
JOIN money_transactions mt on orders_customers.transaction = mt.id_transaction
JOIN orders_customers_products ocp on orders_customers.id_order_customer = ocp.order_customer) total, (SELECT SUM(count) as count FROM orders_store_products
JOIN orders_store os on os.id_order_store = orders_store_products.order_store
WHERE supplier = 6) edinicy

------------------------------------------------------------------------------------------------------------------------
--8)Получите накладные расходы в процентах от объема продаж.
SELECT (SELECT SUM(extra_cost.amount) FROM extra_cost) / (SUM(amount)) * 100 as persent FROM orders_customers
JOIN money_transactions mt on orders_customers.transaction = mt.id_transaction
JOIN orders_customers_products ocp on orders_customers.id_order_customer = ocp.order_customer

------------------------------------------------------------------------------------------------------------------------
--9)Получите перечень и общее количество непроданного товара на складе за
-- определенный период и его объем от общего товара в процентах.

------------------------------------------------------------------------------------------------------------------------
--10) Получите перечень и общее количество бракованного товара, пришедшего за определенный период
-- и список поставщиков, поставивших товар.
SELECT name, count, name_sup FROM defective_customers
JOIN defective_customers_products dcp on defective_customers.id_defective_customer = dcp.defective_customer
JOIN products p on p.id_product = dcp.product
JOIN machine_parts mp on mp.id_machine_part = p.machine_part
JOIN suppliers s on p.supplier = s.id_supplier
WHERE defective_date BETWEEN '2023-04-05' AND '2023-06-05';

------------------------------------------------------------------------------------------------------------------------
--11) Получите перечень, общее количество и стоимость товара, реализованного за конкретный день
SELECT name, SUM(count), SUM(amount) FROM orders_customers
JOIN orders_customers_products ocp on orders_customers.id_order_customer = ocp.order_customer
JOIN products p on ocp.product = p.id_product
JOIN machine_parts mp on p.machine_part = mp.id_machine_part
JOIN money_transactions mt on mt.id_transaction = orders_customers.transaction
WHERE order_date = '2023-05-05'
GROUP BY ROLLUP (name) ;

------------------------------------------------------------------------------------------------------------------------
--12) Получите кассовый отчет за определенный период.
SELECT name, name_sup, SUM(count) * in_time_price_product AS total, SUM(count) FROM orders_customers
JOIN orders_customers_products ocp on orders_customers.id_order_customer = ocp.order_customer
JOIN products p on ocp.product = p.id_product
JOIN suppliers s on s.id_supplier = p.supplier
JOIN machine_parts mp on mp.id_machine_part = p.machine_part
JOIN money_transactions mt on orders_customers.transaction = mt.id_transaction
WHERE order_date BETWEEN '2023-04-05' AND '2023-06-05'
GROUP BY name, name_sup, in_time_price_product
ORDER BY total DESC;

------------------------------------------------------------------------------------------------------------------------
--13) Получите инвентаризационную ведомость.
SELECT name, user_order_count_product as "кол-во на складе" FROM products
JOIN machine_parts mp on mp.id_machine_part = products.machine_part
WHERE user_order_count_product > 0

------------------------------------------------------------------------------------------------------------------------
--15) Подсчитайте, сколько пустых ячеек на складе и сколько он сможет вместить товара.
SELECT COUNT(*) AS empty_cells_count, SUM(cell_max) AS total_capacity
FROM storage
WHERE id NOT IN (SELECT DISTINCT storage_cell FROM products);

------------------------------------------------------------------------------------------------------------------------
--16) Получите перечень и общее количество заявок от покупателей на ожидаемый товар,
-- подсчитайте, на какую сумму даны заявки
SELECT id_request_customer, amount FROM requests_customers
JOIN money_transactions mt on mt.id_transaction = requests_customers.transaction
WHERE amount != 0
UNION ALL
SELECT NULL, SUM(amount)
FROM requests_customers
JOIN money_transactions mt on mt.id_transaction = requests_customers.transaction
UNION ALL
SELECT NULL, COUNT(id_request_customer) FROM requests_customers
JOIN money_transactions mt on mt.id_transaction = requests_customers.transaction
WHERE amount != 0


