--виды деталей
INSERT INTO public.types_machine_part (id_type_machine_part, name_type) VALUES (1, 'Двигательные детали');
INSERT INTO public.types_machine_part (id_type_machine_part, name_type) VALUES (2, 'Тормозные детали');
INSERT INTO public.types_machine_part (id_type_machine_part, name_type) VALUES (3, 'Ходовые детали');
INSERT INTO public.types_machine_part (id_type_machine_part, name_type) VALUES (4, 'Кузовные детали');
INSERT INTO public.types_machine_part (id_type_machine_part, name_type) VALUES (5, 'Электрические детали');
INSERT INTO public.types_machine_part (id_type_machine_part, name_type) VALUES (6, 'Системы охлаждения');
INSERT INTO public.types_machine_part (id_type_machine_part, name_type) VALUES (7, 'Системы выхлопа');
INSERT INTO public.types_machine_part (id_type_machine_part, name_type) VALUES (8, 'Расходники');
INSERT INTO public.types_machine_part (id_type_machine_part, name_type) VALUES (9, 'Системы передачи');
INSERT INTO public.types_machine_part (id_type_machine_part, name_type) VALUES (10, 'Салонные детали');

--детали
INSERT INTO public.machine_parts (id_machine_part, name, type_machine_part) VALUES (2, 'Поршневые кольца ', 1);
INSERT INTO public.machine_parts (id_machine_part, name, type_machine_part) VALUES (3, 'Ремень ГРМ', 1);
INSERT INTO public.machine_parts (id_machine_part, name, type_machine_part) VALUES (1, 'Головка блока цилиндров', 1);
INSERT INTO public.machine_parts (id_machine_part, name, type_machine_part) VALUES (4, 'Тормозные колодки', 2);
INSERT INTO public.machine_parts (id_machine_part, name, type_machine_part) VALUES (5, 'Диски тормозные', 2);
INSERT INTO public.machine_parts (id_machine_part, name, type_machine_part) VALUES (6, 'Гидравлический тормозной привод', 2);
INSERT INTO public.machine_parts (id_machine_part, name, type_machine_part) VALUES (7, 'Амортизаторы', 3);
INSERT INTO public.machine_parts (id_machine_part, name, type_machine_part) VALUES (8, 'Приводные валы', 3);
INSERT INTO public.machine_parts (id_machine_part, name, type_machine_part) VALUES (9, 'Шаровые опоры', 3);
INSERT INTO public.machine_parts (id_machine_part, name, type_machine_part) VALUES (10, 'Двери', 4);
INSERT INTO public.machine_parts (id_machine_part, name, type_machine_part) VALUES (11, 'Бамперы', 4);
INSERT INTO public.machine_parts (id_machine_part, name, type_machine_part) VALUES (12, 'Крышка багажника', 4);
INSERT INTO public.machine_parts (id_machine_part, name, type_machine_part) VALUES (13, 'Свечи зажигания', 5);
INSERT INTO public.machine_parts (id_machine_part, name, type_machine_part) VALUES (14, 'Аккумулятор', 5);
INSERT INTO public.machine_parts (id_machine_part, name, type_machine_part) VALUES (15, 'Провода', 5);
INSERT INTO public.machine_parts (id_machine_part, name, type_machine_part) VALUES (16, 'Радиатор', 6);
INSERT INTO public.machine_parts (id_machine_part, name, type_machine_part) VALUES (17, 'Вентилятор', 6);
INSERT INTO public.machine_parts (id_machine_part, name, type_machine_part) VALUES (18, 'Термостат', 6);
INSERT INTO public.machine_parts (id_machine_part, name, type_machine_part) VALUES (19, 'Глушитель', 7);
INSERT INTO public.machine_parts (id_machine_part, name, type_machine_part) VALUES (20, 'Катализатор', 7);
INSERT INTO public.machine_parts (id_machine_part, name, type_machine_part) VALUES (21, 'Выхлопной коллектор', 7);
INSERT INTO public.machine_parts (id_machine_part, name, type_machine_part) VALUES (22, 'Компрессор', 8);
INSERT INTO public.machine_parts (id_machine_part, name, type_machine_part) VALUES (23, 'Испаритель', 8);
INSERT INTO public.machine_parts (id_machine_part, name, type_machine_part) VALUES (24, 'Конденсатор', 8);
INSERT INTO public.machine_parts (id_machine_part, name, type_machine_part) VALUES (25, 'Коробка передач', 9);
INSERT INTO public.machine_parts (id_machine_part, name, type_machine_part) VALUES (26, 'Карданный вал', 9);
INSERT INTO public.machine_parts (id_machine_part, name, type_machine_part) VALUES (27, 'Дифференциал', 9);
INSERT INTO public.machine_parts (id_machine_part, name, type_machine_part) VALUES (28, 'Сиденья', 10);
INSERT INTO public.machine_parts (id_machine_part, name, type_machine_part) VALUES (29, 'Рулевая колонка', 10);
INSERT INTO public.machine_parts (id_machine_part, name, type_machine_part) VALUES (30, 'Обшивка потолка', 10);


--категория поставщика
INSERT INTO public.categorys (id_category, name_category) VALUES (2, 'Производитель деталей');
INSERT INTO public.categorys (id_category, name_category) VALUES (3, 'Дилер');
INSERT INTO public.categorys (id_category, name_category) VALUES (1, 'Фирмы');
INSERT INTO public.categorys (id_category, name_category) VALUES (4, 'Небольшое производство');
INSERT INTO public.categorys (id_category, name_category) VALUES (5, 'Мелкий поставщик');
INSERT INTO public.categorys (id_category, name_category) VALUES (6, 'Магазин');


--атрибут поставщика
INSERT INTO public.attributes (id_attribute, name_attribute) VALUES (3, 'Пакет документов');
INSERT INTO public.attributes (id_attribute, name_attribute) VALUES (1, 'Надежный партнер');
INSERT INTO public.attributes (id_attribute, name_attribute) VALUES (2, 'Скидка');
INSERT INTO public.attributes (id_attribute, name_attribute) VALUES (4, 'Гарантия');
INSERT INTO public.attributes (id_attribute, name_attribute) VALUES (5, 'Большой объём продукции');
INSERT INTO public.attributes (id_attribute, name_attribute) VALUES (6, 'Низкие цены');
INSERT INTO public.attributes (id_attribute, name_attribute) VALUES (7, 'Договор');


--категория-атрибут
INSERT INTO public.categorys_attributes (id_category_attribute, category, attribute) VALUES (1, 1, 1);
INSERT INTO public.categorys_attributes (id_category_attribute, category, attribute) VALUES (2, 1, 2);
INSERT INTO public.categorys_attributes (id_category_attribute, category, attribute) VALUES (3, 1, 3);
INSERT INTO public.categorys_attributes (id_category_attribute, category, attribute) VALUES (4, 1, 4);
INSERT INTO public.categorys_attributes (id_category_attribute, category, attribute) VALUES (5, 1, 5);
INSERT INTO public.categorys_attributes (id_category_attribute, category, attribute) VALUES (6, 1, 7);
INSERT INTO public.categorys_attributes (id_category_attribute, category, attribute) VALUES (7, 3, 1);
INSERT INTO public.categorys_attributes (id_category_attribute, category, attribute) VALUES (8, 3, 2);
INSERT INTO public.categorys_attributes (id_category_attribute, category, attribute) VALUES (9, 3, 3);
INSERT INTO public.categorys_attributes (id_category_attribute, category, attribute) VALUES (10, 3, 4);
INSERT INTO public.categorys_attributes (id_category_attribute, category, attribute) VALUES (11, 3, 5);
INSERT INTO public.categorys_attributes (id_category_attribute, category, attribute) VALUES (12, 3, 7);
INSERT INTO public.categorys_attributes (id_category_attribute, category, attribute) VALUES (13, 2, 1);
INSERT INTO public.categorys_attributes (id_category_attribute, category, attribute) VALUES (14, 2, 3);
INSERT INTO public.categorys_attributes (id_category_attribute, category, attribute) VALUES (15, 2, 4);
INSERT INTO public.categorys_attributes (id_category_attribute, category, attribute) VALUES (16, 2, 7);
INSERT INTO public.categorys_attributes (id_category_attribute, category, attribute) VALUES (17, 4, 6);
INSERT INTO public.categorys_attributes (id_category_attribute, category, attribute) VALUES (18, 5, 3);
INSERT INTO public.categorys_attributes (id_category_attribute, category, attribute) VALUES (19, 6, 6);


--поставщик
INSERT INTO public.suppliers (id_supplier, name_sup, category, status_active) VALUES (4, 'Mann-Filter', 2, true);
INSERT INTO public.suppliers (id_supplier, name_sup, category, status_active) VALUES (2, 'Denso', 1, false);
INSERT INTO public.suppliers (id_supplier, name_sup, category, status_active) VALUES (3, 'Mahle', 2, true);
INSERT INTO public.suppliers (id_supplier, name_sup, category, status_active) VALUES (1, 'Bosch', 1, true);
INSERT INTO public.suppliers (id_supplier, name_sup, category, status_active) VALUES (5, 'Автоцентр "РОЛЬФ"', 3, true);
INSERT INTO public.suppliers (id_supplier, name_sup, category, status_active) VALUES (6, 'РОНИКО Моторс', 3, true);
INSERT INTO public.suppliers (id_supplier, name_sup, category, status_active) VALUES (7, 'ООО "АвтоДеталь"', 4, true);
INSERT INTO public.suppliers (id_supplier, name_sup, category, status_active) VALUES (8, 'ИП Иванов', 4, true);
INSERT INTO public.suppliers (id_supplier, name_sup, category, status_active) VALUES (9, 'ООО "Деталинка" ', 5, false);
INSERT INTO public.suppliers (id_supplier, name_sup, category, status_active) VALUES (10, 'ИП Петров', 5, false);
INSERT INTO public.suppliers (id_supplier, name_sup, category, status_active) VALUES (11, 'АвтоЗапчасть', 6, false);
INSERT INTO public.suppliers (id_supplier, name_sup, category, status_active) VALUES (12, 'Запчасти-Online', 6, true);


--ячейки склад
INSERT INTO public.storage (id, cell_name, cell_max) VALUES (1, 'A1', 600);
INSERT INTO public.storage (id, cell_name, cell_max) VALUES (2, 'B5', 10000);
INSERT INTO public.storage (id, cell_name, cell_max) VALUES (3, 'Y8', 3000);
INSERT INTO public.storage (id, cell_name, cell_max) VALUES (4, 'XC3', 7800);
INSERT INTO public.storage (id, cell_name, cell_max) VALUES (5, 'U6', 32100);
INSERT INTO public.storage (id, cell_name, cell_max) VALUES (6, 'IR5', 654623);
INSERT INTO public.storage (id, cell_name, cell_max) VALUES (7, 'Y4', 13214);
INSERT INTO public.storage (id, cell_name, cell_max) VALUES (8, 'GH5', 654);
INSERT INTO public.storage (id, cell_name, cell_max) VALUES (9, 'R4', 7544);
INSERT INTO public.storage (id, cell_name, cell_max) VALUES (10, 'GB6', 6574);
INSERT INTO public.storage (id, cell_name, cell_max) VALUES (11, 'YH', 24144);
INSERT INTO public.storage (id, cell_name, cell_max) VALUES (12, 'TT', 6345);
INSERT INTO public.storage (id, cell_name, cell_max) VALUES (13, 'NJ32', 46011);
INSERT INTO public.storage (id, cell_name, cell_max) VALUES (14, 'JKK2', 5019);
INSERT INTO public.storage (id, cell_name, cell_max) VALUES (15, 'OO', 14566);
INSERT INTO public.storage (id, cell_name, cell_max) VALUES (16, 'PPE3', 18491);




--товары
INSERT INTO public.products (machine_part, supplier, supplier_count_product, supplier_price_product, avg_day_delivery, storage_cell, tax, user_order_count_product, user_requests_count_product, user_price_product) VALUES (14, 9, 50, 9000, 5, 1, 10, 10, 20, 12500);
INSERT INTO public.products (machine_part, supplier, supplier_count_product, supplier_price_product, avg_day_delivery, storage_cell, tax, user_order_count_product, user_requests_count_product, user_price_product) VALUES (13, 2, 50, 2500, 10, 5, 10, 20, 30, 3500);
INSERT INTO public.products (machine_part, supplier, supplier_count_product, supplier_price_product, avg_day_delivery, storage_cell, tax, user_order_count_product, user_requests_count_product, user_price_product) VALUES (7, 6, 100, 5000, 14, 2, 15, 20, 80, 7000);
INSERT INTO public.products (machine_part, supplier, supplier_count_product, supplier_price_product, avg_day_delivery, storage_cell, tax, user_order_count_product, user_requests_count_product, user_price_product) VALUES (7, 7, 5, 6000, 1, 8, 0, 0, 0, 0);
-- Пример 1: Добавление товара от поставщика №1 в ячейку склада №1
INSERT INTO "products" ("machine_part", "supplier", "supplier_count_product", "supplier_price_product", "tax", "avg_day_delivery", "storage_cell")
VALUES (1, 1, 1000, 10.99, 20, 5, 10);
-- Пример 2: Добавление товара от поставщика №2 в ячейку склада №2
INSERT INTO "products" ("machine_part", "supplier", "supplier_count_product", "supplier_price_product", "tax", "avg_day_delivery", "storage_cell")
VALUES (2, 2, 500, 15.99, 10, 2, 7);
-- Пример 3: Добавление товара от поставщика №3 в ячейку склада №3, с указанием количества товара, заказанного покупателем
INSERT INTO "products" ("machine_part", "supplier", "supplier_count_product", "supplier_price_product", "tax", "avg_day_delivery", "storage_cell", "user_order_count_product", "user_price_product")
VALUES (3, 3, 200, 20.99, 15, 3, 3, 50, 40.65);
-- Пример 4: Добавление товара от поставщика №4 в ячейку склада №4, с указанием цены, предложенной покупателем
INSERT INTO "products" ("machine_part", "supplier", "supplier_count_product", "supplier_price_product", "tax", "avg_day_delivery", "storage_cell", "user_order_count_product", "user_price_product")
VALUES (4, 4, 100, 25.99, 5, 4, 4, 75, 30.99);
-- Пример 5: Добавление товара от поставщика №5 в ячейку склада №5, с указанием количества товара, заказанного покупателем, и цены, предложенной покупателем
INSERT INTO "products" ("machine_part", "supplier", "supplier_count_product", "supplier_price_product", "tax", "avg_day_delivery", "storage_cell", "user_order_count_product", user_requests_count_product, "user_price_product")
VALUES (5, 5, 300, 30.99, 20, 5, 9, 100, 50, 27.99);
INSERT INTO products (machine_part, supplier, supplier_count_product, supplier_price_product, tax, avg_day_delivery, storage_cell, user_order_count_product, user_requests_count_product, user_price_product)
VALUES (5, 3, 100, 50.99, 20, 7, 6, 10, 5, 60.00);
INSERT INTO products (machine_part, supplier, supplier_count_product, supplier_price_product, tax, avg_day_delivery, storage_cell, user_order_count_product, user_requests_count_product, user_price_product)
VALUES (2, 3, 200, 30.49, 15, 5, 15, 8, 3, 40.00);
INSERT INTO products (machine_part, supplier, supplier_count_product, supplier_price_product, tax, avg_day_delivery, storage_cell, user_order_count_product, user_requests_count_product, user_price_product)
VALUES (8, 3, 150, 80.99, 25, 9, 14, 15, 8, 75.00);
INSERT INTO products (machine_part, supplier, supplier_count_product, supplier_price_product, tax, avg_day_delivery, storage_cell, user_order_count_product, user_requests_count_product, user_price_product)
VALUES (5, 1, 50, 10.99, 20, 3, 13, 10, 5, 12.99);
INSERT INTO products (machine_part, supplier, supplier_count_product, supplier_price_product, tax, avg_day_delivery, storage_cell, user_order_count_product, user_requests_count_product, user_price_product)
VALUES (2, 5, 100, 50.00, 15, 7, 12, 25, 10, 55.00);
INSERT INTO products (machine_part, supplier, supplier_count_product, supplier_price_product, tax, avg_day_delivery, storage_cell, user_order_count_product, user_requests_count_product, user_price_product)
VALUES (8, 5, 75, 20.50, 18, 2, 11, 20, 8, 23.99);





--Покупатели
INSERT INTO public.customers (login, first, last) VALUES ('AnnaSmith', null, null);
INSERT INTO public.customers (login, first, last) VALUES ('JohnDoe88', null, null);
INSERT INTO public.customers (login, first, last) VALUES ('LisaGreen', null, null);
INSERT INTO public.customers (login, first, last) VALUES ('DavidBrown81', null, null);
INSERT INTO public.customers (login, first, last) VALUES ('EmmaLee', null, null);
INSERT INTO public.customers (login, first, last) VALUES ('PeterWhite', null, null);
INSERT INTO public.customers (login, first, last) VALUES ('OliviaDavis', null, null);
INSERT INTO public.customers (login, first, last) VALUES ('MichaelBlack', null, null);
INSERT INTO public.customers (login, first, last) VALUES ('SarahTaylor79', null, null);
INSERT INTO public.customers (login, first, last) VALUES ('RobertJones', null, null);
INSERT INTO public.customers (login, first, last) VALUES ('mark', null, null);
INSERT INTO public.customers (login, first, last) VALUES ('kekw', null, null);

--характер операции
INSERT INTO public.characters_operations (id_character, name_character) VALUES (1, 'Оплата Заказа');
INSERT INTO public.characters_operations (id_character, name_character) VALUES (2, 'Оплата Заявки');
INSERT INTO public.characters_operations (id_character, name_character) VALUES (3, 'Возврат за брак');


--заказы-покупатели
INSERT INTO public.orders_customers (customer_login, transaction) VALUES ('EmmaLee', null);
INSERT INTO public.orders_customers (customer_login, transaction) VALUES ('PeterWhite', null);
INSERT INTO public.orders_customers (customer_login, transaction) VALUES ('RobertJones', null);
INSERT INTO public.orders_customers (customer_login, transaction) VALUES ('EmmaLee', null);
INSERT INTO public.orders_customers (customer_login, transaction) VALUES ('PeterWhite', null);
INSERT INTO public.orders_customers (customer_login, transaction) VALUES ('MichaelBlack', null);
INSERT INTO public.orders_customers (customer_login, transaction) VALUES ('OliviaDavis', null);
INSERT INTO public.orders_customers (customer_login, transaction) VALUES ('DavidBrown81', null);
INSERT INTO public.orders_customers (customer_login, transaction) VALUES ('EmmaLee', null);
INSERT INTO public.orders_customers (customer_login, transaction) VALUES ('LisaGreen', null);
INSERT INTO public.orders_customers (customer_login, transaction) VALUES ('RobertJones', null);
INSERT INTO public.orders_customers (customer_login, transaction) VALUES ('mark', null);
INSERT INTO public.orders_customers (customer_login, transaction) VALUES ('kekw', null);

INSERT INTO "managers" ("manager_login", "first", "last") VALUES ('john_smith', 'John', 'Smith');
INSERT INTO "managers" ("manager_login", "first", "last") VALUES ('jane_doe', 'Jane', 'Doe');
INSERT INTO "managers" ("manager_login", "first", "last") VALUES ('mike_brown', 'Mike', 'Brown');
INSERT INTO "managers" ("manager_login", "first", "last") VALUES ('susan_wong', 'Susan', 'Wong');
INSERT INTO "managers" ("manager_login", "first", "last") VALUES ('steve_johnson', 'Steve', 'Johnson');
INSERT INTO "managers" ("manager_login", "first", "last") VALUES ('kate_davis', 'Kate', 'Davis');
INSERT INTO "managers" ("manager_login", "first", "last") VALUES ('david_lee', 'David', 'Lee');
INSERT INTO "managers" ("manager_login", "first", "last") VALUES ('amy_wood', 'Amy', 'Wood');
INSERT INTO "managers" ("manager_login", "first", "last") VALUES ('peter_smith', 'Peter', 'Smith');
INSERT INTO "managers" ("manager_login", "first", "last") VALUES ('lisa_kim', 'Lisa', 'Kim');

INSERT INTO orders_store(manager_login, supplier) VALUES ('lisa_kim', 8);
INSERT INTO orders_store(manager_login, supplier) VALUES ('lisa_kim', 5);
INSERT INTO orders_store(manager_login, supplier) VALUES ('lisa_kim', 3);
INSERT INTO orders_store(manager_login, supplier) VALUES ('lisa_kim', 1);
INSERT INTO orders_store(manager_login, supplier) VALUES ('kate_davis', 3);
INSERT INTO orders_store(manager_login, supplier) VALUES ('kate_davis', 1);
INSERT INTO orders_store(manager_login, supplier) VALUES ('kate_davis', 7);
INSERT INTO orders_store(manager_login, supplier) VALUES ('kate_davis', 8);
INSERT INTO orders_store(manager_login, supplier) VALUES ('john_smith', 3);
INSERT INTO orders_store(manager_login, supplier) VALUES ('john_smith', 8);
INSERT INTO orders_store(manager_login, supplier) VALUES ('john_smith', 6);
INSERT INTO orders_store(manager_login, supplier) VALUES ('john_smith', 7);

INSERT INTO requests_customers(customer_login) VALUES ('EmmaLee');
INSERT INTO requests_customers(customer_login) VALUES ('PeterWhite');
INSERT INTO requests_customers(customer_login) VALUES ('RobertJones');
INSERT INTO requests_customers(customer_login) VALUES ('PeterWhite');
INSERT INTO requests_customers(customer_login) VALUES ('EmmaLee');
INSERT INTO requests_customers(customer_login) VALUES ('RobertJones');
INSERT INTO requests_customers(customer_login) VALUES ('RobertJones');
INSERT INTO requests_customers(customer_login) VALUES ('PeterWhite');
INSERT INTO requests_customers(customer_login) VALUES ('EmmaLee');
INSERT INTO requests_customers(customer_login) VALUES ('RobertJones');


SET ROLE mark;
INSERT INTO orders_customers_products (order_customer, product, count) VALUES (12, 3, 8);
INSERT INTO orders_customers_products (order_customer, product, count) VALUES (12, 1, 1);
INSERT INTO orders_customers_products (order_customer, product, count) VALUES (12, 8, 2);
INSERT INTO orders_customers_products (order_customer, product, count) VALUES (12, 9, 5);
SET ROLE DavidBrown81;
INSERT INTO orders_customers_products (order_customer, product, count) VALUES (8, 2, 1);
INSERT INTO orders_customers_products (order_customer, product, count) VALUES (8, 7, 1);
SET ROLE RobertJones;
INSERT INTO orders_customers_products (order_customer, product, count) VALUES (3, 7, 1);

SET ROLE EmmaLee;
INSERT INTO requests_customers_products (request_customer, product, count) VALUES (1, 1, 5);
INSERT INTO requests_customers_products (request_customer, product, count) VALUES (1, 2, 15);
INSERT INTO requests_customers_products (request_customer, product, count) VALUES (1, 9, 6);
SET ROLE RobertJones;
INSERT INTO requests_customers_products (request_customer, product, count) VALUES (10, 9, 1);
INSERT INTO requests_customers_products (request_customer, product, count) VALUES (10, 3, 2);

SET ROLE EmmaLee;
INSERT INTO defective_customers (customer_login, transaction_past) VALUES ('EmmaLee', 14);
INSERT INTO defective_customers_products(defective_customer, product, count) values (1, 2, 1);
SET ROLE mark;
INSERT INTO defective_customers (customer_login, transaction_past) VALUES ('mark', 12);
INSERT INTO defective_customers_products(defective_customer, product, count) values (2, 9, 2);

SET ROLE lisa_kim;
INSERT INTO orders_store_products(ORDER_STORE, PRODUCT_ORDER, COUNT) VALUES (2, 9, 10);
INSERT INTO orders_store_products(ORDER_STORE, PRODUCT_ORDER, COUNT) VALUES (2, 14, 6);
INSERT INTO orders_store_products(ORDER_STORE, PRODUCT_ORDER, COUNT) VALUES (2, 15, 43);

SET ROLE kate_davis;
INSERT INTO orders_store_products(ORDER_STORE, PRODUCT_ORDER, COUNT) VALUES (5, 7, 24);
INSERT INTO orders_store_products(ORDER_STORE, PRODUCT_ORDER, COUNT) VALUES (5, 10, 6);
INSERT INTO orders_store_products(ORDER_STORE, PRODUCT_ORDER, COUNT) VALUES (5, 12, 10);

SET ROLE john_smith;
INSERT INTO orders_store_products(ORDER_STORE, PRODUCT_ORDER, COUNT) VALUES (12, 4, 2);

SET ROLE postgres;
