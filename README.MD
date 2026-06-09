# Air Tracker – Flight Analytics Dashboard

## Overview

Air Tracker is a Flight Analytics Dashboard developed using Python, PostgreSQL, Streamlit, and AeroDataBox API.

The application collects flight, airport, and aircraft information from the AeroDataBox API, stores it in PostgreSQL, and provides analytical dashboards through Streamlit.

## Technology Stack

* Python
* PostgreSQL
* Streamlit
* Pandas
* Psycopg2
* AeroDataBox API

## Database

Database Name: airtracker

Tables:

* airport
* aircraft
* flights

## Data Summary

* Airports: 10
* Flights: 912
* Aircraft: 110

## Features

### Dashboard

* Total Airports
* Total Flights
* Total Aircraft
* Flight Status Overview
* Top Destination Airports

### Flight Search

Search flights using flight number.

### Airport Explorer

Explore airport details using IATA code.

### Delay Analysis

Analyze delayed flights by destination.

### SQL Insights

Aircraft utilization and destination analytics.

## Project Structure

* app.py
* fetch_airports.py
* fetch_flights.py
* Airtracker.sql
* requirements.txt
* README.md

## Author

Ganesan M
