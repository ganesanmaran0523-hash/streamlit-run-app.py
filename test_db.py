import psycopg2

try:
    conn = psycopg2.connect(
        host="localhost",
        database="airtracker",
        user="postgres",
        password="Guys@123"
    )

    print("✅ PostgreSQL Connected")

    conn.close()

except Exception as e:
    print("❌ Error:", e)