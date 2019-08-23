import os
import os.path
import sqlite3

# __file__ is db.py
base_directory = os.path.abspath(os.path.dirname(__file__))

app.config['SQLALCHEMY_DATABSE_URI'] = 'sqlite:///' + os.path.join(base_directory,  'data.sqlite')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

class Doctor(db.Model):
    # manually overwrite tablename
    __tablename__ = 'Doctor'
    id = db.column(db.Integer, primary_key=True)
    name = db.Column(db.Text)
    age = db.Column(db.Integer)

    def __init__(self, name, age):
        self.name = name
        self.age = age

    #return string representation of this object
    def __repr__(self):
        return f"Doctor is {self.name} and age is {self.age}"


def create_tables(con, dbfile, sqlfile):
    if os.path.isfile(dbfile):
        os.remove(dbfile)

    query = open(sqlfile, 'r').read()
    sqlite3.complete_statement(query)
    
    try:
        con.executescript(query)
        con.commit()

    except Exception as e:
    error_message = dbfile + ': ' + str(e)
    print(error_message)
    con.close()


def load_db(con,filename):
    wb = pd.ExcelFile(filename+'.xlsx')
    for sheet in wb.sheet_names:
        df=pd.read_excel(filename+'.xlsx', sheet_name=sheet)
        df.to_sql(sheet, con, index=False, if_exists="append")
    con.commit()


if __name__ == '__main__':

    database_file = "clinetdb"
    sql_file = "create_tables.sql"
    con = sqlite3.connect(database_file+'.db')
    create_tables(con, database_file+'.db', sql_file)
    load_db(con, database_file)


