import requests
import json

API_HOST = "aerodatabox.p.rapidapi.com"

API_KEY = "a321c98816msh5baeadd0faf9275p1a5a16jsn30ee7c2354c2"

headers = {
    "x-rapidapi-key": API_KEY,
    "x-rapidapi-host": API_HOST
}

url = "https://aerodatabox.p.rapidapi.com/flights/airports/iata/DEL"

response = requests.get(url, headers=headers)

print("Status Code:", response.status_code)

data = response.json()

print(type(data))

print(json.dumps(data, indent=2)[:5000])