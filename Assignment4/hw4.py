import sqlite3
import csv  # Use this to read the csv file


def create_connection(db_file):  
    Connection = None
    try:
        Connection = sqlite3.connect(db_file)
    except sqlite3.Error as e:
        print(e)

    return Connection


def update_employee_salaries(conn, increase):
    try:
        update_query = "UPDATE ConstructorEmployee SET SalaryPerDay = SalaryPerDay + (SalaryPerDay * (?) /100) WHERE ConstructorEmployee.EID IN (SELECT Employee.EID FROM(Employee JOIN ConstructorEmployee ON Employee.EID=ConstructorEmployee.EID) WHERE (strftime('%Y', 'now') - strftime('%Y', BirthDate)) - (strftime('%m-%d', 'now') < strftime('%m-%d', BirthDate))>=50);"
        cursor = conn.cursor()
        cursor.execute(update_query, (str(increase),))
        conn.commit()
    except sqlite3.Error as error:
        print(error)


def get_employee_total_salary(conn):
    total_salary = None
    try:
        cursor = conn.cursor()
        query = "select sum(SalaryPerDay) from ConstructorEmployee;"
        total_salary = cursor.execute(query).fetchone()[0]
    except sqlite3.Error as error:
        print(error)
    return total_salary


def get_total_projects_budget(conn):
    total_budget = None
    try:
        cursor = conn.cursor()
        query = "select sum(Budget) from Project;"
        total_budget = cursor.execute(query).fetchone()[0]
    except sqlite3.Error as error:
        print(error)
    return total_budget


def calculate_income_from_parking(conn, year):
    query = "select sum(Cost) from CarParking where StartTime like (?);"
    output = None
    try:
        cursor = conn.cursor()
        year = '%'+year+'%'
        output = cursor.execute(query, (year,)).fetchone()[0]
    except sqlite3.Error as error:
        print(error)
        
    return output

def get_most_profitable_parking_areas(conn):
    output = []
    try:
        query = "SELECT DISTINCT ParkingArea.AID, x.profit FROM ((SELECT DISTINCT AID, sum(Cost) as 'profit' FROM CarParking GROUP By AID ORDER BY profit DESC, AID DESC) as 'x' JOIN ParkingArea On ParkingArea.AID=x.AID)as 'y' LIMIT 5;"
        cursor = conn.cursor()
        cursor_output = cursor.execute(query).fetchall()
        for i in range(cursor_output.__len__()):
            output.insert(i, cursor_output[i])
    except sqlite3.Error as error:
        print(error)
    return output


def get_number_of_distinct_cars_by_area(conn):
    output = []
    try:
        query = "SELECT AID, count(DISTINCT cid) as 'numberOfCars' FROM CarParking GROUP BY AID ORDER BY numberOfCars DESC;"
        cursor = conn.cursor()
        cursor_output = cursor.execute(query).fetchall()
        for i in range(cursor_output.__len__()):
            output.insert(i, cursor_output[i])
    except sqlite3.Error as error:
        print(error)
    return output


def add_employee(conn, eid, firstname, lastname, birthdate, street_name, number, door, city): 
    try:
        cursor = conn.cursor()
        query = "INSERT INTO Employee (EID, FirstName, LastName, BirthDate, Door, Number, StreetName, City) VALUES (?, ?,?,?,?,?,?,?);"
        cursor.execute(query, (eid, firstname, lastname, birthdate, door, number, street_name, city))
        conn.commit()
    except sqlite3.Error as error:
        print(error)

def load_neighborhoods(conn, csv_path):
    try:
        cursor = conn.cursor()
        csv_file = open(csv_path)
        rows = csv.reader(csv_file)
        cursor.executemany("INSERT INTO Neighborhood VALUES (?,?);", rows)
        conn.commit()
    except sqlite3.Error as error:
        print(error)
        
        
        
        
        
def main():
    conn = create_connection("C:/Users/luee/Desktop/207951773_208035824/Assignment4/B7_DB.db")
    update_employee_salaries(conn,200)
    
    

if __name__ == "__main__":
    main()