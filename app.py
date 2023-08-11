import json
from flask import Flask, render_template, request, redirect, url_for, session, flash
import psycopg2

app = Flask(__name__)
# установим секретный ключ для подписи. Держите это в секрете!
app.secret_key = b'_5#y2L"F4Q8z\n\xec]/'


def conn_bd(login_param, password_param):
    try:
        conn = psycopg2.connect(
            database="test",
            user=login_param,
            password=password_param,
            host="localhost",
            port="5433"
        )

    except:
        return False
    else:
        return conn


def check_cookie():
    return 'login' and 'password' in session


@app.route('/')
def index():
    if check_cookie():
        conn = conn_bd(session['login'], session['password'])
        if conn:
            cur = conn.cursor()
            cur.execute(f"SELECT CURRENT_USER;")
            login = cur.fetchone()

        else:
            flash('Error!!', category='message')
            return redirect(url_for('logout'))

    else:
        flash('Вы не авторизованы!', category='message')
        return redirect(url_for('login'))
    conn.close()
    return render_template('index.html', login=login[0])


@app.route('/products', methods=['GET', 'POST'])
def products():
    if check_cookie():
        conn = conn_bd(session['login'], session['password'])
        if conn:
            cur = conn.cursor()
            cur.execute('SELECT  name, name_type, name_sup, (EXISTS(SELECT id_product FROM products AS F '
                        'JOIN suppliers s on s.id_supplier = F.supplier '
                        'JOIN categorys c on c.id_category = s.category '
                        'JOIN categorys_attributes ca on c.id_category = ca.category '
                        'JOIN attributes a on a.id_attribute = ca.attribute WHERE (attribute = 4 AND F.id_product = p.id_product))), user_order_count_product, user_requests_count_product, user_price_product FROM products as p '
                        'JOIN suppliers s on s.id_supplier = p.supplier '
                        'JOIN machine_parts mp on mp.id_machine_part = p.machine_part '
                        'JOIN types_machine_part tmp on tmp.id_type_machine_part = mp.type_machine_part '
                        'ORDER BY name ASC')
            products = cur.fetchall()
            return render_template('products.html', products=products)
    flash('Вы не авторизованы!', category='message')
    return redirect(url_for('login'))


@app.route('/login_manager', methods=['GET', 'POST'])
def login_manager():
    if request.method == 'POST':
        conn = conn_bd(request.form['login'], request.form['password'])

        if conn:
            curs = conn.cursor()
            try:
                curs.execute(
                    f"SELECT EXISTS (SELECT * FROM managers WHERE(lower(manager_login) = '{request.form['login']}'));")
                check = curs.fetchone()[0]
            except psycopg2.Error as e:
                check = False
            if check:

                session['login'] = request.form['login']
                session['password'] = request.form['password']
                session['type'] = 'manager'
                session['action_profile_manager'] = "1"
                flash('Вход выполнен!', category='success')

            else:
                flash('Не manager', category='message')
                return redirect(url_for('login'))
        else:
            flash('Неправильный логин или пароль', category='message')
            return redirect(url_for('login_manager'))
        return redirect(url_for('profile_manager'))
    return render_template('login_manager.html')


@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        conn = conn_bd(request.form['login'], request.form['password'])
        if conn:
            cur = conn.cursor()
            # try:
            #     cur.execute(f"SELECT EXISTS (SELECT * FROM customers WHERE(lower(login) = '{request.form['login']}'));")
            # except psycopg2.Error as e:
            #     check = False
            cur.execute(f"SELECT EXISTS (SELECT * FROM customers WHERE(lower(login) = '{request.form['login']}'));")
            check = cur.fetchone()[0]
            print(check)
            if check:
                session['login'] = request.form['login']
                session['password'] = request.form['password']
                session['type'] = "user"
                session['check'] = "1"
                flash('Вход выполнен!', category='success')
            else:
                flash('Не user', category='message')
                return redirect(url_for('login_manager'))
        else:
            flash('Неправильный логин или пароль', category='message')
            return redirect(url_for('login'))
        return redirect(url_for('profile_user'))
    return render_template('login.html')


@app.route('/create', methods=['GET', 'POST'])
def create():
    if request.method == 'POST':
        val = str(create_users(request.form['login'], request.form['password']))
        if val == '':
            flash(str("Аккаунт создан!"), category='success')
            session['login'] = request.form['login']
            session['password'] = request.form['password']
            session['type'] = "user"
            redirect(url_for('index'))
        else:
            flash(str(val), category='message')
            redirect(url_for('create'))

    return render_template("create.html")


def create_users(log, passw):
    conn = conn_bd('postgres', 'admin')
    if conn:
        cur = conn.cursor()
        error = ''
        try:
            cur.execute("CALL check_login('" + str(log) + "');")
        except psycopg2.Error as e:
            error = str(e.diag.message_primary)
            print(error)
        conn.commit()
        if error == '':
            cur.execute(f"CREATE USER " + str(log) + f" WITH LOGIN PASSWORD '{str(passw)}';")
            conn.commit()
            cur.execute(f'GRANT ' + '"user"' + f" TO {str(log)};")
            conn.commit()
            cur.execute(f"INSERT INTO customers VALUES ('{str(log)}');")
            conn.commit()
        cur.close()
        conn.close()
        return error


@app.route('/profile_user', methods=['GET', 'POST'])
def profile_user():
    if check_cookie():
        conn = conn_bd(session['login'], session['password'])
        if conn and session['type'] == 'user':
            cur = conn.cursor()
            if request.method == 'POST':
                first = request.form['first']
                last = request.form['last']
                cur.execute(f"UPDATE customers SET first = '{first}', last = '{last}' WHERE TRUE;")
                conn.commit()
                cur.close()
                conn.close()
                flash('Изменения сохранены!', category='success')
                return redirect(url_for('profile_user'))
            else:
                cur.execute('SELECT * FROM customers;')
                info = cur.fetchall()
                cur.execute('SELECT * FROM orders_customers')
                orders = cur.fetchall()
                cur.execute('SELECT * FROM requests_customers')
                requests = cur.fetchall()
                cur.execute('SELECT * FROM defective_customers')
                defects = cur.fetchall()
                cur.execute("SELECT id_transaction, name_character, amount FROM money_transactions "
                            "JOIN characters_operations co on co.id_character = money_transactions.character "
                            "WHERE amount != 0")
                transaction = cur.fetchall()
                cur.close()
                conn.close()
                return render_template('profile_user.html', customer=info,
                                       orders=orders,
                                       requests=requests,
                                       defects=defects,
                                       transaction=transaction)
        else:
            flash('Вы не user! Зайдите за user!', category='message')
            return redirect(url_for('profile_manager'))
    else:
        flash('Вы не авторизованы!', category='message')
        return redirect(url_for('login'))


@app.route('/orders_user', methods=['GET', 'POST'])
def orders_user():
    if check_cookie():
        conn = conn_bd(session['login'], session['password'])
        if conn and session['type'] == 'user':
            cur = conn.cursor()
            if request.method == 'POST':
                pass
            else:
                cur.execute(
                    'SELECT id_order_customer, name, name_type, name_sup, (EXISTS(SELECT id_product FROM products AS F '
                    'JOIN suppliers s on s.id_supplier = F.supplier '
                    'JOIN categorys c on c.id_category = s.category '
                    'JOIN categorys_attributes ca on c.id_category = ca.category '
                    'JOIN attributes a on a.id_attribute = ca.attribute WHERE (attribute = 4 AND F.id_product = p.id_product))), in_time_price_product, count, (in_time_price_product * count) as total, amount  FROM orders_customers '
                    'JOIN money_transactions mt on mt.id_transaction = orders_customers.transaction'
                    ' JOIN orders_customers_products ocp on orders_customers.id_order_customer = ocp.order_customer'
                    ' JOIN products p on ocp.product = p.id_product'
                    ' JOIN machine_parts mp on p.machine_part = mp.id_machine_part'
                    ' JOIN types_machine_part tmp on tmp.id_type_machine_part = mp.type_machine_part'
                    ' JOIN suppliers s on p.supplier = s.id_supplier;')
                orders = cur.fetchall()
                cur.execute('SELECT * FROM orders_customers WHERE not EXISTS'
                            '(SELECT * FROM orders_customers_products '
                            '   where order_customer = orders_customers.id_order_customer);')
                empty_orders = cur.fetchall()
                cur.close()
                conn.close()
                return render_template('orders_user.html', orders=orders,
                                       empty_orders=empty_orders)

    flash('Вы не авторизованы!', category='message')
    return redirect(url_for('login'))


@app.route('/requests_user', methods=['GET', 'POST'])
def requests_user():
    if check_cookie():
        conn = conn_bd(session['login'], session['password'])
        if conn and session['type'] == 'user':
            cur = conn.cursor()
            if request.method == 'POST':
                pass
            else:
                cur.execute(
                    'SELECT id_request_customer, name, name_type, name_sup, (EXISTS(SELECT id_product FROM products AS F '
                    'JOIN suppliers s on s.id_supplier = F.supplier '
                    'JOIN categorys c on c.id_category = s.category '
                    'JOIN categorys_attributes ca on c.id_category = ca.category '
                    'JOIN attributes a on a.id_attribute = ca.attribute WHERE (attribute = 4 AND F.id_product = p.id_product))), in_time_price_product, count, (in_time_price_product * count) as total, amount  FROM requests_customers '
                    'JOIN money_transactions mt on mt.id_transaction = requests_customers.transaction '
                    'JOIN requests_customers_products rcp on requests_customers.id_request_customer = rcp.request_customer '
                    'JOIN characters_operations co on mt.character = co.id_character'
                    ' JOIN products p on p.id_product = rcp.product'
                    ' JOIN machine_parts mp on p.machine_part = mp.id_machine_part'
                    ' JOIN types_machine_part tmp on mp.type_machine_part = tmp.id_type_machine_part'
                    ' JOIN suppliers s on p.supplier = s.id_supplier;')
                requests = cur.fetchall()
                cur.execute('SELECT * FROM requests_customers WHERE not EXISTS'
                            '(SELECT * FROM requests_customers_products '
                            'where request_customer = requests_customers.id_request_customer);')
                empty_requests = cur.fetchall()
                cur.close()
                conn.close()
                return render_template('requests_user.html', requests=requests,
                                       empty_requests=empty_requests)

    flash('Вы не авторизованы!', category='message')
    return redirect(url_for('login'))


@app.route('/defectives_user', methods=['GET', 'POST'])
def defectives_user():
    if check_cookie():
        conn = conn_bd(session['login'], session['password'])
        if conn and session['type'] == 'user':
            cur = conn.cursor()
            if request.method == 'POST':
                pass
            else:
                cur.execute(
                    'SELECT id_defective_customer, name, name_type, name_sup, type, in_time_price_product, count, (in_time_price_product * count) as total, amount FROM defective_customers '
                    'JOIN defective_customers_products dcp on defective_customers.id_defective_customer = dcp.defective_customer '
                    'JOIN products p on p.id_product = dcp.product '
                    'JOIN suppliers s on p.supplier = s.id_supplier '
                    'JOIN machine_parts mp on p.machine_part = mp.id_machine_part '
                    'JOIN types_machine_part tmp on tmp.id_type_machine_part = mp.type_machine_part '
                    'JOIN money_transactions mt on defective_customers.transaction = mt.id_transaction '
                    'JOIN characters_operations co on co.id_character = mt.character;')
                defects = cur.fetchall()
                cur.execute('SELECT * FROM defective_customers WHERE not EXISTS'
                            '(SELECT * FROM defective_customers_products '
                            'where defective_customer = defective_customers.id_defective_customer);')
                empty_defects = cur.fetchall()
                cur.close()
                conn.close()
                return render_template('defectives_user.html', defects=defects,
                                       empty_defects=empty_defects)

    flash('Вы не авторизованы!', category='message')
    return redirect(url_for('login'))


@app.route('/create_order', methods=['GET', 'POST'])
def create_order():
    if check_cookie():
        conn = conn_bd(session['login'], session['password'])
        if conn and session['type'] == 'user':
            cur = conn.cursor()
            if request.method == 'POST':
                if request.form['action'] == 'VALUE1':
                    cur.execute('INSERT INTO orders_customers (customer_login) VALUES (current_user);')
                    conn.commit()
                    cur.close()
                    conn.close()
                    flash('Заказ создан', category='success')

                elif request.form['action'] == 'VALUE2':
                    id_order = request.form['id_order']
                    id_product = request.form['id_product']
                    count = request.form['count']
                    error = ''
                    try:
                        cur.execute(
                            f"INSERT INTO orders_customers_products (order_customer, product, count) VALUES ({id_order}, {id_product}, {count});")
                    except psycopg2.Error as e:
                        error = str(e)
                        print(error)

                    if error == '':
                        conn.commit()
                        flash('Товар добавлен в заказ', category='success')
                    else:
                        flash(f"{error}", category='message')
                    cur.close()
                    conn.close()
                return redirect(url_for('create_order'))
            else:
                cur.execute(
                    'SELECT id_product, name, name_type, name_sup, (EXISTS(SELECT id_product FROM products AS F '
                    'JOIN suppliers s on s.id_supplier = F.supplier '
                    'JOIN categorys c on c.id_category = s.category '
                    'JOIN categorys_attributes ca on c.id_category = ca.category '
                    'JOIN attributes a on a.id_attribute = ca.attribute WHERE (attribute = 4 AND F.id_product = p.id_product))), user_order_count_product, user_price_product FROM products as p '
                    'JOIN suppliers s on s.id_supplier = p.supplier '
                    'JOIN machine_parts mp on mp.id_machine_part = p.machine_part '
                    'JOIN types_machine_part tmp on tmp.id_type_machine_part = mp.type_machine_part '
                    'ORDER BY name ASC')

                products = cur.fetchall()
                cur.execute('SELECT * FROM orders_customers')
                orders = cur.fetchall()
                cur.close()
                conn.close()
                return render_template('create_order.html', orders=orders, products=products)

    flash('Вы не авторизованы!', category='message')
    return redirect(url_for('login'))


@app.route('/create_request', methods=['GET', 'POST'])
def create_request():
    if check_cookie():
        conn = conn_bd(session['login'], session['password'])
        if conn and session['type'] == 'user':
            cur = conn.cursor()
            if request.method == 'POST':
                if request.form['action'] == 'VALUE1':
                    cur.execute('INSERT INTO requests_customers (customer_login) VALUES (current_user);')
                    conn.commit()
                    cur.close()
                    conn.close()
                    flash('Заявка создана', category='success')

                elif request.form['action'] == 'VALUE2':
                    id_request = request.form['id_request']
                    id_product = request.form['id_product']
                    count = request.form['count']
                    error = ''
                    try:
                        cur.execute(
                            f"INSERT INTO requests_customers_products (request_customer, product, count) VALUES ({id_request}, {id_product}, {count});")
                    except psycopg2.Error as e:
                        error = str(e)
                        print(error)

                    if error == '':
                        conn.commit()
                        flash('Товар добавлен в заявку', category='success')
                    else:
                        flash(f"{error}", category='message')
                    cur.close()
                    conn.close()
                return redirect(url_for('create_request'))
            else:
                cur.execute(
                    'SELECT id_product, name, name_type, name_sup, (EXISTS(SELECT id_product FROM products AS F '
                    'JOIN suppliers s on s.id_supplier = F.supplier '
                    'JOIN categorys c on c.id_category = s.category '
                    'JOIN categorys_attributes ca on c.id_category = ca.category '
                    'JOIN attributes a on a.id_attribute = ca.attribute WHERE (attribute = 4 AND F.id_product = p.id_product))), user_requests_count_product, user_price_product FROM products as p '
                    'JOIN suppliers s on s.id_supplier = p.supplier '
                    'JOIN machine_parts mp on mp.id_machine_part = p.machine_part '
                    'JOIN types_machine_part tmp on tmp.id_type_machine_part = mp.type_machine_part '
                    'ORDER BY name ASC')

                products = cur.fetchall()
                cur.execute('SELECT * FROM requests_customers')
                requests = cur.fetchall()

                cur.close()
                conn.close()
                return render_template('create_request.html',
                                       requests=requests,
                                       products=products)

    flash('Вы не авторизованы!', category='message')
    return redirect(url_for('login'))


@app.route('/create_defect', methods=['GET', 'POST'])
def create_defect():
    if check_cookie():
        conn = conn_bd(session['login'], session['password'])
        if conn and session['type'] == 'user':
            cur = conn.cursor()
            if request.method == 'POST':
                if request.form['action'] == '1':
                    session['check'] = request.form['action']
                elif request.form['action'] == '2':
                    session['check'] = request.form['action']
                elif request.form['action'] == '3':
                    id_past = request.form['id_past']
                    error = ''
                    try:
                        cur.execute(
                            f"INSERT INTO defective_customers (customer_login, transaction_past) VALUES (current_user, {id_past});")
                    except psycopg2.Error as e:
                        error = str(e)
                        print(error)

                    if error == '':
                        conn.commit()
                        flash('Заявка на брак создана', category='success')
                    else:
                        cur.close()
                        conn.close()
                        flash(f"{error}", category='message')
                elif request.form['action'] == '4':
                    id_defect = request.form['id_defect']
                    id_product = request.form['id_product']
                    count = request.form['count']
                    error = ''
                    try:
                        cur.execute(
                            f"INSERT INTO defective_customers_products(defective_customer, product, count) "
                            f"VALUES ({id_defect}, {id_product}, {count});")
                    except psycopg2.Error as e:
                        error = str(e)
                        print(error)

                    if error == '':
                        conn.commit()
                        flash('Товар добавлен в заявку на брак', category='success')
                    else:
                        cur.close()
                        conn.close()
                        flash(f"{error}", category='message')

                return redirect(url_for('create_defect'))
            else:
                if session['check'] == '1':
                    cur.execute(
                        'SELECT id_order_customer, id_product, name, name_type, name_sup, (EXISTS(SELECT id_product FROM products AS F '
                        'JOIN suppliers s on s.id_supplier = F.supplier '
                        'JOIN categorys c on c.id_category = s.category '
                        'JOIN categorys_attributes ca on c.id_category = ca.category '
                        'JOIN attributes a on a.id_attribute = ca.attribute WHERE (attribute = 4 AND F.id_product = p.id_product))), in_time_price_product, count, (in_time_price_product * count) as total, amount  FROM orders_customers '
                        'JOIN money_transactions mt on mt.id_transaction = orders_customers.transaction'
                        ' JOIN orders_customers_products ocp on orders_customers.id_order_customer = ocp.order_customer'
                        ' JOIN products p on ocp.product = p.id_product'
                        ' JOIN machine_parts mp on p.machine_part = mp.id_machine_part'
                        ' JOIN types_machine_part tmp on tmp.id_type_machine_part = mp.type_machine_part'
                        ' JOIN suppliers s on p.supplier = s.id_supplier;')
                    current = 'Заказ'

                elif session['check'] == '2':
                    cur.execute(
                        'SELECT id_request_customer, id_product, name, name_type, name_sup, (EXISTS(SELECT id_product FROM products AS F '
                        'JOIN suppliers s on s.id_supplier = F.supplier '
                        'JOIN categorys c on c.id_category = s.category '
                        'JOIN categorys_attributes ca on c.id_category = ca.category '
                        'JOIN attributes a on a.id_attribute = ca.attribute WHERE (attribute = 4 AND F.id_product = p.id_product))), in_time_price_product, count, (in_time_price_product * count) as total, amount  FROM requests_customers '
                        'JOIN money_transactions mt on mt.id_transaction = requests_customers.transaction '
                        'JOIN requests_customers_products rcp on requests_customers.id_request_customer = rcp.request_customer '
                        'JOIN characters_operations co on mt.character = co.id_character'
                        ' JOIN products p on p.id_product = rcp.product'
                        ' JOIN machine_parts mp on p.machine_part = mp.id_machine_part'
                        ' JOIN types_machine_part tmp on mp.type_machine_part = tmp.id_type_machine_part'
                        ' JOIN suppliers s on p.supplier = s.id_supplier;')
                    current = 'Заявка'

                info = cur.fetchall()
                cur.execute('SELECT * FROM defective_customers')
                defects = cur.fetchall()
                cur.execute("SELECT id_transaction, name_character, amount FROM money_transactions "
                            "JOIN characters_operations co on co.id_character = money_transactions.character "
                            "WHERE amount != 0 AND name_character != 'Возврат за брак' ;")
                transaction = cur.fetchall()
                cur.close()
                conn.close()
            return render_template('create_defect.html', info=info,
                                   current=current,
                                   defects=defects,
                                   transaction=transaction)
    flash('Вы не авторизованы!', category='message')
    return redirect(url_for('login'))


@app.route('/profile_manager', methods=['GET', 'POST'])
def profile_manager():
    if check_cookie():

        conn = conn_bd(session['login'], session['password'])
        if conn and session['type'] == 'manager':
            cur = conn.cursor()

            if request.method == 'POST':
                session['action_profile_manager'] = request.form['action']
                return redirect(url_for('profile_manager'))

            else:
                if session['action_profile_manager'] == "1":
                    cur.execute('SELECT name, name_sup, total FROM products '
                                'JOIN (SELECT product, SUM(count)AS total FROM orders_customers_products '
                                'GROUP BY product) prod on prod.product = products.id_product '
                                'JOIN machine_parts mp on products.machine_part = mp.id_machine_part '
                                'JOIN suppliers s on products.supplier = s.id_supplier '
                                'ORDER BY total DESC;')
                    current = "Топ по заказам"
                elif session['action_profile_manager'] == "2":
                    cur.execute('SELECT name, name_sup, total FROM products '
                                'JOIN (SELECT product, SUM(count)AS total FROM requests_customers_products '
                                'GROUP BY product) prod on prod.product = products.id_product '
                                'JOIN machine_parts mp on products.machine_part = mp.id_machine_part '
                                'JOIN suppliers s on products.supplier = s.id_supplier '
                                'ORDER BY total DESC;')
                    current = "Топ по заявкам"
                elif session['action_profile_manager'] == "3":
                    cur.execute('SELECT name, name_sup, total FROM products '
                                'JOIN (SELECT product, SUM(count)AS total FROM (SELECT product, count FROM orders_customers_products UNION '
                                'SELECT product, count FROM requests_customers_products) as f '
                                'GROUP BY product) prod on prod.product = products.id_product '
                                'JOIN machine_parts mp on products.machine_part = mp.id_machine_part '
                                'JOIN suppliers s on products.supplier = s.id_supplier '
                                'ORDER BY total DESC;')
                    current = "Общий топ"
                stat = cur.fetchall()
                cur.execute('SELECT * FROM managers WHERE (lower(manager_login) = current_user);')
                manager = cur.fetchall()
            cur.close()
            conn.close()
            return render_template('profile_manager.html',
                                   manager=manager,
                                   current=current,
                                   stat=stat)
    flash('Вы не авторизованы как менеджер!', category='message')
    return redirect(url_for('login_manager'))


@app.route('/logout', methods=['GET', 'POST'])
def logout():
    session.pop('login', None)
    session.pop('password', None)
    session.pop('type', None)
    session.pop('check', None)
    session.pop('action_profile_manager', None)
    flash('Logout!', category='success')
    return redirect(url_for('index'))


if __name__ == '__main__':
    app.run()
