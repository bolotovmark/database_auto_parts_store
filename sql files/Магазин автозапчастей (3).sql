SET ROLE postgres;
------------------------------------------------------------------------------------
--TABLE покупатели
CREATE TABLE "customers" (
  "login" text UNIQUE PRIMARY KEY NOT NULL,
  "first" text,
  "last" text
);
--GRANT
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
    --GRANT USER
      GRANT SELECT (login, first, last) ON customers TO "user";
      GRANT UPDATE (first, last) ON customers TO "user";
      CREATE POLICY select_self_customers ON customers
        FOR SELECT
        TO "user"
        USING (lower(login) = current_user::text);
      CREATE POLICY update_self_customers ON customers
        FOR UPDATE
        TO "user"
        USING (lower(login) = current_user::text);

    --GRANT MANAGER
      GRANT SELECT (login, first, last) ON customers TO "group_manager";
     CREATE POLICY select_customers_managers ON customers
        FOR SELECT
        TO "group_manager"
        USING (TRUE);
    --GRANT ADMIN
      GRANT SELECT, INSERT, UPDATE, DELETE ON customers TO "group_admin";
     CREATE POLICY all_customers_admin ON customers
        FOR ALL
        TO "group_admin"
        USING (TRUE);
------------------------------------------------------------------------------------
--TABLE покупатель-заказ
CREATE TABLE "orders_customers" (
  "id_order_customer" SERIAL PRIMARY KEY,
  "customer_login" text NOT NULL,
  "transaction" int,
  "order_date" date DEFAULT (current_date)
);
--GRANT
ALTER TABLE orders_customers ENABLE ROW LEVEL SECURITY;
    --GRANT USER
      GRANT SELECT ON orders_customers TO "user";
      GRANT INSERT (customer_login) ON orders_customers TO "user";
      CREATE POLICY select_self_customers_orders ON orders_customers
        FOR SELECT
        TO "user"
        USING (lower(customer_login) = current_user::text);
      CREATE POLICY insert_self_orders_customers ON orders_customers
        FOR INSERT
        TO "user"
        WITH CHECK (lower(customer_login) = current_user);

    --GRANT MANAGER
      GRANT SELECT ON orders_customers TO "group_manager";
      CREATE POLICY select_orders_customers_manager ON orders_customers
        FOR SELECT
        TO "group_manager"
        USING (TRUE);
    --GRANT ADMIN
      GRANT SELECT, INSERT, UPDATE, DELETE ON orders_customers TO "group_admin";
      CREATE POLICY all_orders_customers_admin ON orders_customers TO group_admin USING (true) WITH CHECK (true);

------------------------------------------------------------------------------------
--TABLE заказ-покупатель-продукт
CREATE TABLE "orders_customers_products" (
  "id_order_customer_product" SERIAL PRIMARY KEY NOT NULL,
  "order_customer" int NOT NULL,
  "product" int NOT NULL,
  "in_time_price_product" numeric(15, 2) DEFAULT (0),
  "count" int NOT NULL CHECK ( count > 0 )
);

--GRANT
ALTER TABLE orders_customers_products ENABLE ROW LEVEL SECURITY;
    --GRANT USER
      GRANT SELECT ON orders_customers_products TO "user";
      CREATE POLICY select_self_orders_customers_products ON orders_customers_products
        FOR SELECT
        TO "user"
        USING (order_customer IN (SELECT id_order_customer FROM orders_customers WHERE id_order_customer = order_customer
                                                                          AND lower(customer_login) = current_user));
      GRANT INSERT (order_customer, product, count) ON orders_customers_products TO "user";
      CREATE POLICY insert_self_orders_customers_products ON orders_customers_products
        FOR INSERT
        TO "user"
        WITH CHECK (TRUE);
    --GRANT MANAGER
      GRANT SELECT ON orders_customers_products TO "group_manager";
      CREATE POLICY select_orders_customers_products_manager ON orders_customers_products
        FOR SELECT
        TO "group_manager"
        USING (TRUE);
    --GRANT ADMIN
      GRANT SELECT, INSERT, UPDATE, DELETE ON orders_customers_products TO "group_admin";
      CREATE POLICY all_orders_customers_products_admin ON orders_customers_products TO group_admin USING (true) WITH CHECK (true);

------------------------------------------------------------------------------------
--TABLE поставщик
CREATE TABLE "suppliers" (
  "id_supplier" SERIAL PRIMARY KEY NOT NULL,
  "name_sup" text NOT NULL,
  "category" int NOT NULL,
  "status_active" bool NOT NULL
);
--GRANT
    --GRANT USER
      GRANT SELECT ON suppliers TO "user";
    --GRANT MANAGER
      GRANT SELECT, UPDATE, INSERT ON suppliers TO "group_manager";
    --GROUP ADMIN
      GRANT SELECT, UPDATE, INSERT, DELETE ON suppliers TO "group_admin";

------------------------------------------------------------------------------------
--TABLE товары
CREATE TABLE "products" (
  "id_product" SERIAL PRIMARY KEY NOT NULL,
  "machine_part" int NOT NULL,
  --Для менеджера
  "supplier" int NOT NULL,
  "supplier_count_product" int NOT NULL,
  "supplier_price_product" numeric(15, 2) NOT NULL,
  "tax" int NOT NULL,
  "avg_day_delivery" int,
  "storage_cell" int UNIQUE,
  --Для покупателя
  "user_order_count_product" int,
  "user_requests_count_product" int,
  "user_price_product" numeric(15, 2)
);
--GRANT
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
    --GRANT USER
      GRANT SELECT
          (id_product, machine_part, supplier, user_order_count_product, user_requests_count_product,
           user_price_product) ON products TO "user";
      CREATE POLICY select_products_users ON products
        FOR SELECT
        TO "user"
        USING (user_order_count_product > 0 OR user_requests_count_product > 0
        );
    --GRANT MANAGER
      GRANT SELECT, UPDATE, INSERT ON products TO "group_manager";
      CREATE POLICY all_product_manager ON products TO group_manager USING (true) WITH CHECK (true);
    --GRANT ADMIN
      GRANT SELECT, INSERT, UPDATE, DELETE ON products TO "group_admin";
      CREATE POLICY all_product_admin ON products TO group_admin USING (true) WITH CHECK (true);

------------------------------------------------------------------------------------
--TABLE ячейки
CREATE TABLE storage (
    id SERIAL PRIMARY KEY,
    cell_name TEXT NOT NULL UNIQUE,
    cell_max INTEGER NOT NULL
);
    --GRANT MANAGER
      GRANT SELECT, UPDATE, INSERT ON storage TO "group_manager";
    --GRANT ADMIN
      GRANT SELECT, INSERT, UPDATE, DELETE ON storage TO "group_admin";

------------------------------------------------------------------------------------
--TABLE деталь
CREATE TABLE "machine_parts" (
  "id_machine_part" SERIAL PRIMARY KEY NOT NULL,
  "name" text NOT NULL,
  "type_machine_part" int NOT NULL
);
--GRANT
    --GRANT USER
      GRANT SELECT ON machine_parts TO "user";
    --GRANT MANAGER
      GRANT SELECT, UPDATE, INSERT ON machine_parts TO "group_manager";
    --GRANT ADMIN
      GRANT SELECT, INSERT, UPDATE, DELETE ON machine_parts TO "group_admin";

------------------------------------------------------------------------------------
--TABLE тип детали
CREATE TABLE "types_machine_part" (
  "id_type_machine_part" SERIAL PRIMARY KEY NOT NULL,
  "name_type" text NOT NULL
);
--GRANT
    --GRANT USER
      GRANT SELECT ON types_machine_part TO "user";
    --GRANT MANAGER
      GRANT SELECT, UPDATE, INSERT ON types_machine_part TO "group_manager";
    --GRANT ADMIN
      GRANT SELECT, INSERT, UPDATE, DELETE ON types_machine_part TO "group_admin";

------------------------------------------------------------------------------------
--TABLE категория поставщика
CREATE TABLE "categorys" (
  "id_category" SERIAL PRIMARY KEY NOT NULL,
  "name_category" text NOT NULL
);
--GRANT
    --GRANT USER
      GRANT SELECT ON categorys TO "user";
    --GRANT MANAGER
      GRANT SELECT, UPDATE, INSERT ON categorys TO "group_manager";
    --GROUP ADMIN
      GRANT SELECT, UPDATE, INSERT, DELETE ON categorys TO "group_admin";

------------------------------------------------------------------------------------
--TABLE категория-атрибут
CREATE TABLE "categorys_attributes" (
  "id_category_attribute" SERIAL PRIMARY KEY NOT NULL,
  "category" int NOT NULL,
  "attribute" int NOT NULL
);
--GRANT
    --GRANT USER
      GRANT SELECT ON categorys_attributes TO "user";
    --GRANT MANAGER
      GRANT SELECT, UPDATE, INSERT ON categorys_attributes TO "group_manager";
    --GROUP ADMIN
      GRANT SELECT, UPDATE, INSERT, DELETE ON categorys_attributes TO "group_admin";


------------------------------------------------------------------------------------
--TABLE атрибут
CREATE TABLE "attributes" (
  "id_attribute" SERIAL PRIMARY KEY NOT NULL,
  "name_attribute" text NOT NULL
);
--GRANT
    --GRANT USER
      GRANT SELECT ON attributes TO "user";
    --GRANT MANAGER
      GRANT SELECT, UPDATE, INSERT ON attributes TO "group_manager";
    --GROUP ADMIN
      GRANT SELECT, UPDATE, INSERT, DELETE ON attributes TO "group_admin";

------------------------------------------------------------------------------------
--TABLE транзакции
CREATE TABLE "money_transactions" (
  "id_transaction" SERIAL PRIMARY KEY NOT NULL,
  "character" int NOT NULL,
  "amount" numeric(15, 2) DEFAULT (0)
);
--GRANT
ALTER TABLE money_transactions ENABLE ROW LEVEL SECURITY;
    --GRANT USER
      GRANT SELECT ON money_transactions TO "user";
      CREATE POLICY select_self_money_transactions ON money_transactions
        FOR SELECT
        TO "user"
        USING (id_transaction IN (SELECT transaction FROM orders_customers WHERE lower(customer_login) = current_user
                                UNION SELECT transaction FROM requests_customers WHERE lower(customer_login) = current_user
                                UNION SELECT transaction FROM defective_customers WHERE  lower(customer_login) = current_user));
    --GRANT MANAGER
      GRANT SELECT ON money_transactions TO "group_manager";
      CREATE POLICY select_money_transactions_manager ON money_transactions
      FOR SELECT
      TO "group_manager"
      USING (TRUE);
    --GROUP ADMIN
      GRANT SELECT, UPDATE, INSERT, DELETE ON money_transactions TO "group_admin";
      CREATE POLICY all_money_transactions_admin ON money_transactions TO group_admin USING (true) WITH CHECK (true);

------------------------------------------------------------------------------------
--TABLE характер операции
CREATE TABLE "characters_operations" (
  "id_character" SERIAL PRIMARY KEY,
  "name_character" text
);
--GRANT
    GRANT SELECT ON characters_operations TO "user";
    GRANT SELECT, UPDATE, INSERT ON characters_operations TO group_manager;
    GRANT SELECT, UPDATE, INSERT, DELETE ON characters_operations TO group_admin;

CREATE TABLE "extra_cost" (
  "id_extra_cost" SERIAL PRIMARY KEY,
  "amount" numeric(15,2),
  "date" date DEFAULT (current_date)
);
--GRANT
    GRANT SELECT, INSERT, UPDATE ON characters_operations TO group_manager;
    GRANT SELECT, UPDATE, INSERT, DELETE ON characters_operations TO group_admin;

------------------------------------------------------------------------------------
--TABLE покупатель-заявка
CREATE TABLE "requests_customers" (
  "id_request_customer" SERIAL PRIMARY KEY,
  "customer_login" text NOT NULL ,
  "transaction" int,
  "request_date" date DEFAULT (current_date)
);
--GRANT
ALTER TABLE requests_customers ENABLE ROW LEVEL SECURITY;
    --GRANT USER
      GRANT SELECT ON requests_customers TO "user";
      GRANT INSERT (customer_login) ON requests_customers TO "user";
      CREATE POLICY select_self_requests_orders ON requests_customers
        FOR SELECT
        TO "user"
        USING (lower(customer_login) = current_user::text);
      CREATE POLICY insert_self_request_customers ON requests_customers
        FOR INSERT
        TO "user"
        WITH CHECK (lower(customer_login) = current_user);

    --GRANT MANAGER
      GRANT SELECT ON requests_customers TO "group_manager";
      CREATE POLICY select_requests_customers_manager ON requests_customers
        FOR SELECT
        TO "group_manager"
        USING (TRUE);
    --GRANT ADMIN
      GRANT SELECT, INSERT, UPDATE, DELETE ON requests_customers TO "group_admin";
      CREATE POLICY all_requests_customers_admin ON requests_customers TO group_admin USING (true) WITH CHECK (true);

------------------------------------------------------------------------------------
--TABLE заявка-покупатель-продукт
CREATE TABLE "requests_customers_products" (
  "id_request_customer_product" SERIAL PRIMARY KEY NOT NULL,
  "request_customer" int NOT NULL ,
  "product" int NOT NULL,
  "in_time_price_product" numeric(15, 2) DEFAULT (0),
  "count" int NOT NULL CHECK ( count > 0 )
);
--GRANT
ALTER TABLE requests_customers_products ENABLE ROW LEVEL SECURITY;
    --GRANT USER
      GRANT SELECT ON requests_customers_products TO "user";
      CREATE POLICY select_self_requests_customers_products ON requests_customers_products
        FOR SELECT
        TO "user"
        USING (request_customer IN (SELECT id_request_customer FROM requests_customers WHERE id_request_customer = request_customer
                                                                          AND lower(customer_login) = current_user));
      GRANT INSERT (request_customer, product, count) ON requests_customers_products TO "user";
      CREATE POLICY insert_self_requests_customers_products ON requests_customers_products
        FOR INSERT
        TO "user"
        WITH CHECK (TRUE);
    --GRANT MANAGER
      GRANT SELECT ON requests_customers_products TO "group_manager";
      CREATE POLICY select_requests_customers_products_manager ON requests_customers_products
        FOR SELECT
        TO "group_manager"
        USING (TRUE);
    --GRANT ADMIN
      GRANT SELECT, INSERT, UPDATE, DELETE ON requests_customers_products TO "group_admin";
      CREATE POLICY all_requests_customers_products_admin ON requests_customers_products TO group_admin USING (true) WITH CHECK (true);

------------------------------------------------------------------------------------
--TABLE покупатель-брак
CREATE TABLE "defective_customers" (
  "id_defective_customer" SERIAL PRIMARY KEY,
  "customer_login" text NOT NULL,
  "transaction" int,
  "transaction_past" int NOT NULL,
  "defective_date" date DEFAULT (current_date),
  "type" text
);
--GRANT
ALTER TABLE defective_customers ENABLE ROW LEVEL SECURITY;
    --GRANT USER
      GRANT SELECT ON defective_customers TO "user";
      GRANT INSERT (customer_login, transaction_past) ON defective_customers TO "user";
      CREATE POLICY select_self_defective_orders ON defective_customers
        FOR SELECT
        TO "user"
        USING (lower(customer_login) = current_user::text);
      CREATE POLICY insert_self_defective_orders ON defective_customers
        FOR INSERT
        TO "user"
        WITH CHECK (lower(customer_login) = current_user);

    --GRANT MANAGER
      GRANT SELECT ON defective_customers TO "group_manager";
      CREATE POLICY select_defective_customers_manager ON defective_customers
        FOR SELECT
        TO "group_manager"
        USING (TRUE);
    --GRANT ADMIN
      GRANT SELECT, INSERT, UPDATE, DELETE ON defective_customers TO "group_admin";
      CREATE POLICY all_defective_customers_admin ON defective_customers TO group_admin USING (true) WITH CHECK (true);

------------------------------------------------------------------------------------
--TABLE брак-покупатель-продукт
CREATE TABLE "defective_customers_products" (
  "id_defective_customer_product" SERIAL PRIMARY KEY NOT NULL,
  "defective_customer" int NOT NULL,
  "product" int NOT NULL,
  "in_time_price_product" numeric(15, 2) DEFAULT (0),
  "count" int NOT NULL CHECK ( count > 0 )
);
--GRANT
ALTER TABLE defective_customers_products ENABLE ROW LEVEL SECURITY;
    --GRANT USER
      GRANT SELECT ON defective_customers_products TO "user";
      GRANT INSERT (defective_customer, product, count) ON defective_customers_products TO "user";

      CREATE POLICY select_self_defective_customers_products ON defective_customers_products
        FOR SELECT
        TO "user"
        USING (defective_customer IN (SELECT id_defective_customer FROM defective_customers WHERE id_defective_customer = defective_customer
                                                                          AND lower(customer_login) = current_user));

      CREATE POLICY insert_self_defective_customers_products ON defective_customers_products
        FOR INSERT
        TO "user"
        WITH CHECK (TRUE);
    --GRANT MANAGER
      GRANT SELECT ON defective_customers_products TO "group_manager";
      CREATE POLICY select_defective_customers_products_manager ON defective_customers_products
        FOR SELECT
        TO "group_manager"
        USING (TRUE);
    --GRANT ADMIN
      GRANT SELECT, INSERT, UPDATE, DELETE ON defective_customers_products TO "group_admin";
      CREATE POLICY all_defective_customers_products_admin ON defective_customers_products TO group_admin USING (true) WITH CHECK (true);


------------------------------------------------------------------------------------
--TABLE магазин-заказ
CREATE TABLE "orders_store" (
  "id_order_store" SERIAL PRIMARY KEY,
  "manager_login" text NOT NULL,
  "supplier" int NOT NULL,
  "contract" int DEFAULT (NULL),
  "total_price" numeric(15, 2) DEFAULT (0),
  "order_date" date DEFAULT (current_date)
);
--GRANT
ALTER TABLE orders_store ENABLE ROW LEVEL SECURITY;
    --GRANT MANAGER
      GRANT SELECT, INSERT(supplier, manager_login), UPDATE ON orders_store TO "group_manager";
      CREATE POLICY select_self_manager_orders ON orders_store
        FOR SELECT
        TO "group_manager"
        USING (TRUE);
      CREATE POLICY insert_self_manager_orders ON orders_store
        FOR INSERT
        TO "group_manager"
        WITH CHECK (lower(manager_login) = current_user);

    --GRANT ADMIN
      GRANT SELECT, INSERT, UPDATE, DELETE ON orders_store TO "group_admin";
      CREATE POLICY all_orders_store_admin ON orders_store TO group_admin USING (true) WITH CHECK (true);

------------------------------------------------------------------------------------
--TABLE заказ-магазин-товар
CREATE TABLE "orders_store_products" (
  "id_order_store_product" SERIAL PRIMARY KEY NOT NULL,
  "order_store" int NOT NULL ,
  "product_order" int NOT NULL,
  "in_time_price_product" numeric(15, 2) DEFAULT (0),
  "count" int NOT NULL CHECK ( count > 0 )
);

    --GRANT MANAGER
      GRANT SELECT, INSERT(order_store, product_order, count), UPDATE ON orders_store_products TO "group_manager";
    --GRANT ADMIN
      GRANT SELECT, INSERT, UPDATE, DELETE ON orders_store_products TO "group_admin";

------------------------------------------------------------------------------------
--TABLE менеджеры
CREATE TABLE "managers" (
  "manager_login" text UNIQUE PRIMARY KEY NOT NULL,
  "first" text,
  "last" text
);
--GRANT
ALTER TABLE managers ENABLE ROW LEVEL SECURITY;
    --GRANT MANAGER
      GRANT SELECT, UPDATE (first, last) ON managers TO "group_manager";
      CREATE POLICY select_self_managers ON managers
        FOR SELECT
        TO "group_manager"
        USING (lower(manager_login) = current_user);
      CREATE POLICY update_self_managers ON managers
        FOR UPDATE
        TO "group_manager"
        USING (lower(manager_login) = current_user);
    --GRANT ADMIN
      GRANT SELECT, INSERT, UPDATE, DELETE ON managers TO "group_admin";
      CREATE POLICY all_managers_admin ON managers TO group_admin USING (true) WITH CHECK (true);

------------------------------------------------------------------------------------
--TABLE договор
CREATE TABLE "contracts" (
  "id_contract" SERIAL PRIMARY KEY,
  "date_a" date DEFAULT (current_date),
  "date_b" date DEFAULT (current_date)
);
    --GRANT MANAGER
      GRANT SELECT, INSERT (date_a), UPDATE ON contracts TO "group_manager";
    --GRANT ADMIN
      GRANT SELECT, INSERT, UPDATE, DELETE ON contracts TO "group_admin";


--REF ПОКУПАТЕЛЬ-ЗАКАЗЫ
    ALTER TABLE "orders_customers"
        ADD FOREIGN KEY ("customer_login") REFERENCES "customers" ("login");
    ALTER TABLE "orders_customers"
        ADD FOREIGN KEY ("transaction") REFERENCES "money_transactions" ("id_transaction");

--REF ЗАКАЗЫ-ПОКУПАТЕЛЬ-ТОВАРЫ
    ALTER TABLE "orders_customers_products"
        ADD FOREIGN KEY ("order_customer") REFERENCES "orders_customers" ("id_order_customer") ON DELETE CASCADE;
    ALTER TABLE "orders_customers_products"
        ADD FOREIGN KEY ("product") REFERENCES "products" ("id_product");

--REF ПОКУПАТЕЛЬ-ЗАЯВКА
    ALTER TABLE "requests_customers"
        ADD FOREIGN KEY ("customer_login") REFERENCES "customers" ("login");
    ALTER TABLE "requests_customers"
        ADD FOREIGN KEY ("transaction") REFERENCES "money_transactions" ("id_transaction");

--REF ЗАЯВКА-ПОКУПАТЕЛЬ-ТОВАРЫ
    ALTER TABLE "requests_customers_products"
        ADD FOREIGN KEY ("request_customer") REFERENCES "requests_customers" ("id_request_customer");
    ALTER TABLE "requests_customers_products"
        ADD FOREIGN KEY ("product") REFERENCES "products" ("id_product");

--REF ПОКУПАТЕЛЬ-БРАК
    ALTER TABLE "defective_customers"
        ADD FOREIGN KEY ("customer_login") REFERENCES "customers" ("login");
    ALTER TABLE "defective_customers"
        ADD FOREIGN KEY ("transaction") REFERENCES "money_transactions" ("id_transaction");

--REF БРАК-ПОКУПАТЕЛЬ-ТОВАРЫ
    ALTER TABLE "defective_customers_products"
        ADD FOREIGN KEY ("defective_customer") REFERENCES "defective_customers" ("id_defective_customer");
    ALTER TABLE "defective_customers_products"
        ADD FOREIGN KEY ("product") REFERENCES "products" ("id_product");

--REF ТОВАРЫ
    ALTER TABLE "products"
        ADD FOREIGN KEY ("machine_part") REFERENCES "machine_parts" ("id_machine_part");
    ALTER TABLE "products"
        ADD FOREIGN KEY ("supplier") REFERENCES "suppliers" ("id_supplier");
    ALTER TABLE "products"
            ADD FOREIGN KEY ("storage_cell") REFERENCES "storage" ("id");


--REF ДЕТАЛИ
    ALTER TABLE "machine_parts"
        ADD FOREIGN KEY ("type_machine_part") REFERENCES "types_machine_part" ("id_type_machine_part");

--REF ПОСТАВЩИК
    ALTER TABLE "suppliers"
        ADD FOREIGN KEY ("category") REFERENCES "categorys" ("id_category");

--REF КАТЕГОРИЯ-АТРИБУТ
    ALTER TABLE "categorys_attributes"
        ADD FOREIGN KEY ("category") REFERENCES "categorys" ("id_category");
    ALTER TABLE "categorys_attributes"
        ADD FOREIGN KEY ("attribute") REFERENCES "attributes" ("id_attribute");

--REF МАГАЗИН-ЗАКАЗ
    ALTER TABLE "orders_store"
        ADD FOREIGN KEY ("manager_login") REFERENCES "managers" ("manager_login");
    ALTER TABLE "orders_store"
        ADD FOREIGN KEY ("supplier") REFERENCES "suppliers" ("id_supplier");
    ALTER TABLE "orders_store"
        ADD FOREIGN KEY ("contract") REFERENCES "contracts" ("id_contract");

--REF ЗАКАЗ-МАГАЗИН-ТОВАРЫ
    ALTER TABLE "orders_store_products"
        ADD FOREIGN KEY ("order_store") REFERENCES "orders_store" ("id_order_store");
    ALTER TABLE "orders_store_products"
        ADD FOREIGN KEY ("product_order") REFERENCES "products" ("id_product");

--REF ТРАНЗАКЦИЯ
    ALTER TABLE "money_transactions"
        ADD FOREIGN KEY ("character") REFERENCES "characters_operations" ("id_character");


--------------------------------------------------------------------------------------------------------------
-- TRIGGER добавление заказа (создания оплаты)
    CREATE FUNCTION add_trans_order() RETURNS trigger SECURITY DEFINER AS $add_trans_order$
    DECLARE
    inserted_id INTEGER;
    BEGIN
        INSERT INTO money_transactions(character) VALUES (1) RETURNING id_transaction INTO inserted_id;
        new.transaction = inserted_id;
        RETURN NEW;
    END;
    $add_trans_order$ LANGUAGE plpgsql;
    CREATE TRIGGER add_trans_order
    BEFORE INSERT ON orders_customers FOR EACH ROW EXECUTE PROCEDURE add_trans_order();

--TRIGGER добавления товаров в заказ (привязка суммы)
    CREATE FUNCTION add_price_order(new_row record, user_kekw text) RETURNS RECORD SECURITY DEFINER AS $add_price_order$
    DECLARE
    price_product numeric(15, 2);
    cur_user text = user_kekw;
    BEGIN
        IF new_row.count > (SELECT user_order_count_product FROM products WHERE (id_product = new_row.product)) THEN
            RAISE EXCEPTION 'Кол-во товара в заказе больше доступного кол-ва';
        END IF;

        IF new_row.order_customer NOT IN (SELECT id_order_customer FROM orders_customers WHERE lower(customer_login) = cur_user) THEN
            RAISE EXCEPTION 'Не ваш заказ %', cur_user;
        END IF;

        SELECT user_price_product FROM products WHERE (id_product = new_row.product) INTO price_product;
        new_row.in_time_price_product = price_product;

        UPDATE money_transactions SET amount = amount + price_product * new_row.count
                                  WHERE (id_transaction =
                                         (SELECT transaction FROM orders_customers WHERE (id_order_customer = new_row.order_customer)));
        UPDATE products SET user_order_count_product = user_order_count_product - new_row.count
                                  WHERE (id_product = new_row.product);
        RETURN new_row;
    END;
    $add_price_order$ LANGUAGE plpgsql;

CREATE FUNCTION add_price_order2() RETURNS trigger AS $$
    DECLARE
    cur_user text = current_user;
    BEGIN
        RETURN add_price_order(new, cur_user);
    END;
    $$ LANGUAGE plpgsql;
    CREATE TRIGGER add_price_order
    BEFORE INSERT ON orders_customers_products FOR EACH ROW EXECUTE PROCEDURE add_price_order2();

------------------------------------------------------------------------------------------------------------
--TRIGGER добавление заявки (создания оплаты)
    CREATE FUNCTION add_trans_request() RETURNS trigger SECURITY DEFINER AS $add_trans_request$
    DECLARE
    inserted_id INTEGER;
    BEGIN
        INSERT INTO money_transactions(character) VALUES (2) RETURNING id_transaction INTO inserted_id;
        new.transaction = inserted_id;
        RETURN NEW;
    END;
    $add_trans_request$ LANGUAGE plpgsql;
    CREATE TRIGGER add_trans_request
    BEFORE INSERT ON requests_customers FOR EACH ROW EXECUTE PROCEDURE add_trans_request();

--TRIGGER добавления товаров в заявку (привязка суммы)
    CREATE FUNCTION add_price_request(new_row record, user_kekw text) RETURNS RECORD SECURITY DEFINER AS $add_price_request$
    DECLARE
    price_product numeric(15, 2);
    cur_user text = user_kekw;
    BEGIN
        IF new_row.count > (SELECT user_requests_count_product FROM products WHERE (id_product = new_row.product)) THEN
            RAISE EXCEPTION 'Кол-во товара в заявке больше доступного кол-ва для заявки';
        END IF;

        IF new_row.request_customer NOT IN (SELECT id_request_customer FROM requests_customers WHERE lower(customer_login) = cur_user) THEN
            RAISE EXCEPTION 'Не ваша заявка %', cur_user;
        END IF;

        SELECT user_price_product FROM products WHERE (id_product = new_row.product) INTO price_product;
        new_row.in_time_price_product = price_product;

        UPDATE money_transactions SET amount = amount + price_product * new_row.count
                                  WHERE (id_transaction =
                                         (SELECT transaction FROM requests_customers WHERE (id_request_customer = new_row.request_customer)));
        UPDATE products SET user_requests_count_product = user_requests_count_product - new_row.count
                        WHERE (id_product = new_row.product);
        RETURN new_row;
    END;
    $add_price_request$ LANGUAGE plpgsql;

CREATE FUNCTION add_price_request2() RETURNS trigger AS $$
    DECLARE
    cur_user text = current_user;
    BEGIN
        RETURN add_price_request(new, cur_user);
    END;
    $$ LANGUAGE plpgsql;
    CREATE TRIGGER add_price_request
    BEFORE INSERT ON requests_customers_products FOR EACH ROW EXECUTE PROCEDURE add_price_request2();


------------------------------------------------------------------------------------------------------------
--TRIGGER добавление брака (создания возврат)
    CREATE FUNCTION add_trans_defective(new_row record, user_k text) RETURNS record SECURITY DEFINER AS $add_trans_defective2$
    DECLARE
    inserted_id INTEGER;
    cur_user text = user_k;
    BEGIN
        IF new_row.transaction_past NOT IN (SELECT transaction FROM orders_customers WHERE (lower(customer_login) = cur_user) UNION
                                       (SELECT transaction FROM requests_customers WHERE (lower(customer_login) = cur_user))) THEN
            RAISE EXCEPTION 'Не ваш номер транзакции, либо не существует  %', cur_user;
        END IF;

        INSERT INTO money_transactions(character) VALUES (3) RETURNING id_transaction INTO inserted_id;
        new_row.transaction = inserted_id;
        RETURN new_row;
    END;
    $add_trans_defective2$ LANGUAGE plpgsql;

    CREATE FUNCTION add_trans_defective2() RETURNS trigger AS $$
    DECLARE
    cur_user text = current_user;
    BEGIN
        RETURN add_trans_defective(new, cur_user);
    END;
    $$ LANGUAGE plpgsql;
    CREATE TRIGGER add_trans_defective
    BEFORE INSERT ON defective_customers FOR EACH ROW EXECUTE PROCEDURE add_trans_defective2();

--TRIGGER добавления товаров в брак (привязка суммы)
    CREATE FUNCTION add_price_defective(new_row record, user_kekw text) RETURNS RECORD SECURITY DEFINER AS $add_price_defective$
    DECLARE
    price_product numeric(15, 2);
    past_trans int;
    id_cart int;
    check_o bool ;
    cur_user text = user_kekw;
    BEGIN
        IF new_row.defective_customer NOT IN (SELECT id_defective_customer FROM defective_customers WHERE lower(customer_login) = cur_user) THEN
            RAISE EXCEPTION 'Не ваш номер брака %', cur_user;
        END IF;

        IF NOT EXISTS(SELECT id_product FROM products
                        JOIN suppliers s on s.id_supplier = products.supplier
                        JOIN categorys c on c.id_category = s.category
                        JOIN categorys_attributes ca on c.id_category = ca.category
                        JOIN attributes a on a.id_attribute = ca.attribute WHERE (attribute = 4 AND id_product = new_row.product))
           THEN
           RAISE EXCEPTION 'Гарантии на этот продукт нет';
        END IF;

        SELECT transaction_past FROM defective_customers WHERE (id_defective_customer = new_row.defective_customer) INTO past_trans;

        IF EXISTS(SELECT transaction FROM orders_customers WHERE (transaction = past_trans)) THEN
            SELECT id_order_customer FROM orders_customers WHERE (transaction = past_trans) INTO id_cart;
            check_o = true;
        ELSE
            SELECT id_request_customer FROM requests_customers WHERE (transaction = past_trans) INTO id_cart;
            check_o = false;
        END IF;

        IF check_o = true THEN
            SELECT in_time_price_product FROM orders_customers_products WHERE (order_customer = id_cart
                                                                               AND product = new_row.product) INTO price_product;
            IF new_row.product NOT IN (SELECT product FROM orders_customers_products WHERE (order_customer = id_cart)) THEN
                RAISE EXCEPTION 'Такого товара не было в заказе';
            end if;
            IF new_row.count > (SELECT count FROM orders_customers_products WHERE (order_customer = id_cart AND product = new_row.product)) THEN
                RAISE EXCEPTION 'Такого товара было меньше в заказе';
            end if;
            UPDATE defective_customers SET type = 'ЗАКАЗ' WHERE id_defective_customer = new_row.defective_customer;
        ELSE
            SELECT in_time_price_product FROM requests_customers_products WHERE (request_customer = id_cart
                                                                           AND product = new_row.product) INTO price_product;
            IF new_row.product NOT IN (SELECT product FROM requests_customers_products WHERE (request_customer = id_cart)) THEN
                RAISE EXCEPTION 'Такого товара не было в заявке % "%"', new_row.product, id_cart;
            end if;
            IF new_row.count > (SELECT count FROM requests_customers_products WHERE (request_customer = id_cart AND product = new_row.product)) THEN
                RAISE EXCEPTION 'Такого товара было меньше в заявке';
            end if;
            UPDATE defective_customers SET type = 'ЗАЯВКА' WHERE id_defective_customer = new_row.defective_customer;
        END IF;

        new_row.in_time_price_product = price_product;
        UPDATE money_transactions SET amount = amount + price_product * new_row.count
                    WHERE (id_transaction =
                           (SELECT transaction FROM defective_customers WHERE (id_defective_customer = new_row.defective_customer)));
        RETURN new_row;
    END;
    $add_price_defective$ LANGUAGE plpgsql;

CREATE FUNCTION add_price_defective2() RETURNS trigger AS $$
    DECLARE
    cur_user text = current_user;
    BEGIN
        RETURN add_price_defective(new, cur_user);
    END;
    $$ LANGUAGE plpgsql;
    CREATE TRIGGER add_price_defective
    BEFORE INSERT ON defective_customers_products FOR EACH ROW EXECUTE PROCEDURE add_price_defective2();

------------------------------------------------------------------------------------------------------------
--ТРИГЕР ДОБАВЛЕНИЯ КОНТРАКТА МАГАЗИН-ЗАКАЗ
    CREATE FUNCTION add_contract_order_store() RETURNS trigger SECURITY DEFINER AS $add_contract_order$
    DECLARE
    inserted_id INTEGER;
    BEGIN
        IF NOT EXISTS(SELECT status_active FROM suppliers WHERE (id_supplier = new.supplier AND status_active = true))
           THEN
           RAISE EXCEPTION 'C этим поставщиком не работаем';
        END IF;

        IF EXISTS(SELECT name_attribute
                  FROM categorys_attributes
                           JOIN attributes a on categorys_attributes.attribute = a.id_attribute
                           JOIN categorys c on categorys_attributes.category = c.id_category
                           JOIN suppliers s on categorys_attributes.category = s.category
                  WHERE (id_attribute = 7 AND id_supplier = new.supplier))
        THEN
            INSERT INTO contracts (date_a) VALUES (DEFAULT) RETURNING (id_contract) INTO inserted_id;
            new.contract = inserted_id;
        END IF;

        RETURN NEW;
    END;
    $add_contract_order$ LANGUAGE plpgsql;
    CREATE TRIGGER add_contract_order_store
    BEFORE INSERT ON orders_store FOR EACH ROW EXECUTE PROCEDURE add_contract_order_store();

--TRIGGER добавления товаров в заказ (привязка суммы)

CREATE FUNCTION add_price_order_store2() RETURNS trigger SECURITY DEFINER AS $add_price_order_store2$
    DECLARE
    price_product numeric(15, 2);
    contract_id integer;
    avg_deliver integer;
    tax_prod integer;
    supplier_id integer;
    BEGIN
        IF new.count > (SELECT supplier_count_product FROM products WHERE (id_product = new.product_order)) THEN
            RAISE EXCEPTION 'У поставщика нет такого кол-ва товара';
        END IF;

        SELECT supplier FROM products WHERE (id_product = new.product_order) INTO supplier_id;

        IF supplier_id != (SELECT supplier FROM orders_store WHERE (id_order_store = new.order_store)) THEN
            RAISE EXCEPTION 'У поставщика нет такого товара %', supplier_id;
        END IF;
        SELECT supplier_price_product FROM products WHERE (id_product = new.product_order) INTO price_product;
        new.in_time_price_product = price_product;

        UPDATE orders_store SET total_price = total_price + price_product * new.count
            WHERE (id_order_store = new.order_store);

        UPDATE products SET supplier_count_product = supplier_count_product - new.count
            WHERE (id_product = new.product_order);

        UPDATE products SET user_requests_count_product = user_requests_count_product + new.count
            WHERE (id_product = new.product_order);

        SELECT contract FROM orders_store WHERE (id_order_store = new.order_store) INTO contract_id;
        SELECT avg_day_delivery FROM products WHERE (id_product = new.product_order) INTO avg_deliver;

        IF (SELECT date_a FROM contracts WHERE (id_contract = contract_id)) + avg_deliver > (SELECT date_b FROM contracts WHERE (id_contract = contract_id)) THEN
            UPDATE contracts SET date_b = date_a + avg_deliver
                WHERE (id_contract = contract_id);
        END IF;

        SELECT tax FROM products WHERE (id_product = new.product_order) INTO tax_prod;
        INSERT INTO extra_cost (amount) VALUES (price_product * new.count * tax_prod / 100);
        RETURN NEW;
    END;
    $add_price_order_store2$ LANGUAGE plpgsql;
    CREATE TRIGGER add_price_order_store
    BEFORE INSERT ON orders_store_products FOR EACH ROW EXECUTE PROCEDURE add_price_order_store2();



------------------------------------------------------------------------------------------------------------
--прцедура проверки совпадения логина
create procedure check_login(IN login text)
    language plpgsql
as
$$
    BEGIN
    IF ((SELECT usename from pg_user where lower(usename) = lower(login)) IS NOT NULL) THEN
         RAISE EXCEPTION 'Логин занят' USING HINT = 'Error duplicate login';
    ELSE
        RAISE NOTICE 'Пользователь создан';
    END IF;
END
$$;
alter procedure check_login(text) owner to postgres;

GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO "user";
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO "group_manager";
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO "group_admin";

