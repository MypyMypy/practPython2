#! C:/Users/mypymypy/AppData/Local/Programs/Python/Python312/python.exe

import os
import mysql.connector
import urllib.parse

print("Content-Type: text/html; charset=utf-8\n")

# Путь к файлу head.inc
with open(r'C:\Apache24\cgi-bin\practPython\templates\head.inc') as file:
    for line in file:
        print(line.rstrip())

# Подключение к базе данных space_db
myconn = mysql.connector.connect(
    host='localhost', 
    user='root', 
    passwd='shedF34A', 
    db='space_db', 
    charset='utf8mb4', 
    use_unicode=True
)
cur = myconn.cursor()
cur.execute("SET NAMES utf8mb4;")
cur.execute("USE space_db;")

# Удаление строки в БД
query_string = os.environ.get('QUERY_STRING', None)
if query_string:
    urlGets = urllib.parse.parse_qs(query_string)
    if 'delid' in urlGets and 'table_name' in urlGets:
        delid = urlGets['delid'][0]
        table_name = urlGets['table_name'][0]
        try:
            cur.execute(f"DELETE FROM {table_name} WHERE id = %s", (delid,))
            myconn.commit()
        except mysql.connector.Error as err:
            print(f"Error: {err}")
            myconn.rollback()
    
    # Обновление строки в БД
    if 'update' in urlGets and 'table_name' in urlGets:
        table_name = urlGets['table_name'][0]
        row_id = urlGets['id'][0]
        columns = [key for key in urlGets.keys() if key not in ('update', 'table_name', 'id')]
        values = [urlGets[col][0] for col in columns]
        update_query = f"UPDATE {table_name} SET " + ", ".join([f"{col} = %s" for col in columns]) + " WHERE id = %s"
        try:
            cur.execute(update_query, (*values, row_id))
            myconn.commit()
        except mysql.connector.Error as err:
            print(f"Error: {err}")
            myconn.rollback()

# Функция для вывода данных из таблицы
def print_table_data(table_name, cursor):
    print(f'<h2>{table_name.capitalize()}</h2>')
    print(f'<table data-table="{table_name}" class=\'tView1\'>')
    
    try:
        cursor.execute(f"SELECT * FROM {table_name};")
        
        # Получение названий колонок
        column_names = [desc[0] for desc in cursor.description]
        
        # Вывод названий колонок
        print('<tr>')
        for column_name in column_names:
            print(f'<th data-table="{table_name}">{column_name}</th>')
        print('</tr>')
        
        # Вывод данных
        result = cursor.fetchall()
        for line in result:
            print('<tr>')
            for i, cell in enumerate(line):
                sCellNew = str(cell).strip()
                sNewView = f'<td data-id="{table_name}_{line[0]}" data-column="{column_names[i]}"><a href="#" class="update-modal-link" data-table="{table_name}" data-id="{line[0]}" data-column="{column_names[i]}">{sCellNew}</a></td>'
                print(sNewView)
            sNewView = f'<td class="cellDel" title="Delete"><a href="index.py?table_name={table_name}&delid={str(line[0]).strip()}"><img src="/practPython/image/delete2.png"></a></td>'
            print(sNewView)
            print('</tr>')
    except mysql.connector.Error as err:
        print(f"Error: {err}")
        myconn.rollback()
    print('</table>')

# Вывод данных из таблиц
print_table_data('links', cur)
print_table_data('naturalobjects', cur)
print_table_data('objects', cur)
print_table_data('positions', cur)
print_table_data('sector', cur)

# Вызов процедуры JoinTables для объединения таблиц
try:
    cur.execute("CALL JoinTables('Sector', 'Objects')")
    result = cur.fetchall()
    print('<h2>JoinTables Result</h2>')
    print('<table class=\'tView1\'>')
    for row in result:
        print('<tr>')
        for cell in row:
            print(f'<td>{cell}</td>')
        print('</tr>')
    print('</table>')
except mysql.connector.Error as err:
    print(f"Error: {err}")

myconn.close()

# Путь к файлу foot.inc
with open(r'C:\Apache24\cgi-bin\practPython\templates\updateModal.inc') as file:
    for line in file:
        print(line.rstrip())