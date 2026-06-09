import requests
import psycopg2

# -----------------------
# API SETTINGS
# -----------------------

API_HOST = "aerodatabox.p.rapidapi.com"

API_KEY = "a321c98816msh5baeadd0faf9275p1a5a16jsn30ee7c2354c2"

HEADERS = {
    "x-rapidapi-key": API_KEY,
    "x-rapidapi-host": API_HOST
}

# -----------------------
# DATABASE CONNECTION
# -----------------------

conn = psycopg2.connect(
    host="localhost",
    database="airtracker",
    user="postgres",
    password="Guys@123"
)

cursor = conn.cursor()

# -----------------------
# AIRPORT LIST
# -----------------------

AIRPORTS = [
    "DEL",
    "BOM",
    "MAA",
    "BLR",
    "HYD",
    "LHR",
    "DXB",
    "SIN",
    "JFK",
    "CDG"
]

# -----------------------
# FETCH + INSERT
# -----------------------

for airport_code in AIRPORTS:

    try:

        url = f"https://{API_HOST}/airports/iata/{airport_code}"

        response = requests.get(
            url,
            headers=HEADERS
        )

        data = response.json()

        cursor.execute("""
        INSERT INTO airport
        (
            icao_code,
            iata_code,
            name,
            city,
            country,
            continent,
            latitude,
            longitude,
            timezone
        )
        VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s)
        ON CONFLICT (iata_code)
        DO NOTHING
        """,
        (
            data.get("icao"),
            data.get("iata"),
            data.get("fullName"),
            data.get("municipalityName"),
            data.get("country",{}).get("name"),
            data.get("continent",{}).get("name"),
            data.get("location",{}).get("lat"),
            data.get("location",{}).get("lon"),
            data.get("timeZone")
        ))

        print(f"Inserted {airport_code}")

    except Exception as e:

        print(f"Error {airport_code}: {e}")

conn.commit()

cursor.close()

conn.close()

print("Done")