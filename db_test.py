import psycopg2

conn = psycopg2.connect(
    host="localhost",
    database="airtracker",
    user="postgres",
    password="Guys@123"
)

print("Connected Successfully")

conn.close()