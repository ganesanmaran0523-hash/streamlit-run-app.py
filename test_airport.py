import requests

API_HOST = "aerodatabox.p.rapidapi.com"

API_KEY = "a321c98816msh5baeadd0faf9275p1a5a16jsn30ee7c2354c2"

headers = {
    "x-rapidapi-key": API_KEY,
    "x-rapidapi-host": API_HOST
}

for airport in ["BLR","LHR","JFK"]:

    url = f"https://{API_HOST}/airports/iata/{airport}"

    response = requests.get(
        url,
        headers=headers
    )

    print("\n", airport)
    print("Status:", response.status_code)
    print(response.text[:300])