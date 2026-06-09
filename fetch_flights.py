import requests
import psycopg2

API_HOST = "aerodatabox.p.rapidapi.com"

API_KEY = "a321c98816msh5baeadd0faf9275p1a5a16jsn30ee7c2354c2"

HEADERS = {
    "x-rapidapi-key": API_KEY,
    "x-rapidapi-host": API_HOST
}

conn = psycopg2.connect(
    host="localhost",
    database="airtracker",
    user="postgres",
    password="Guys@123"
)

cursor = conn.cursor()

AIRPORTS = [
    "DEL",
    "BOM",
    "MAA",
    "HYD",
    "DXB"
]

for airport_code in AIRPORTS:

    print(f"\nFetching {airport_code}")

    try:

        url = f"https://{API_HOST}/flights/airports/iata/{airport_code}"

        response = requests.get(
            url,
            headers=HEADERS
        )

        data = response.json()

        departures = data.get("departures", [])

        for flight in departures:

            flight_number = flight.get("number")

            status = flight.get("status")

            airline_code = flight.get(
                "airline", {}
            ).get(
                "iata"
            )

            airline_name = flight.get(
                "airline", {}
            ).get(
                "name"
            )

            aircraft_reg = flight.get(
                "aircraft", {}
            ).get(
                "reg"
            )

            aircraft_model = flight.get(
                "aircraft", {}
            ).get(
                "model"
            )

            destination = flight.get(
                "movement", {}
            ).get(
                "airport", {}
            ).get(
                "iata"
            )

            departure_time = flight.get(
                "movement", {}
            ).get(
                "scheduledTime", {}
            ).get(
                "utc"
            )

            cursor.execute("""
            INSERT INTO flights
            (
                flight_number,
                aircraft_registration,
                aircraft_model,
                origin_iata,
                destination_iata,
                scheduled_departure,
                status,
                airline_code,
                airline_name
            )
            VALUES
            (%s,%s,%s,%s,%s,%s,%s,%s,%s)
            """,
            (
                flight_number,
                aircraft_reg,
                aircraft_model,
                airport_code,
                destination,
                departure_time,
                status,
                airline_code,
                airline_name
            ))

        conn.commit()

        print(
            f"Inserted {len(departures)} flights"
        )

    except Exception as e:

        print(
            f"Error {airport_code}: {e}"
        )

cursor.close()

conn.close()

print("\nDone")