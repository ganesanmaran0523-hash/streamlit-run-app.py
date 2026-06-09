import streamlit as st
import psycopg2
import pandas as pd

# -----------------------------
# PAGE CONFIG
# -----------------------------

st.set_page_config(
    page_title="Air Tracker Dashboard",
    layout="wide"
)

# -----------------------------
# DATABASE CONNECTION
# -----------------------------


def get_connection():
    return psycopg2.connect(
        host="127.0.0.1",
        database="airtracker",
        user="postgres",
        password="Guys@123"
    )

conn = get_connection()

# -----------------------------
# TITLE
# -----------------------------

st.title("✈️ Air Tracker Dashboard")
st.success("Database Connected Successfully")

# -----------------------------
# SIDEBAR
# -----------------------------

page = st.sidebar.selectbox(
    "Navigation",
    [
        "Dashboard",
        "Flight Search",
        "Airport Explorer",
        "Delay Analysis",
        "SQL Insights"
    ]
)

# ==================================================
# DASHBOARD
# ==================================================

if page == "Dashboard":

    airport_count = pd.read_sql(
        "SELECT COUNT(*) FROM airport",
        conn
    ).iloc[0,0]

    flight_count = pd.read_sql(
        "SELECT COUNT(*) FROM flights",
        conn
    ).iloc[0,0]

    aircraft_count = pd.read_sql(
        "SELECT COUNT(*) FROM aircraft",
        conn
    ).iloc[0,0]

    col1, col2, col3 = st.columns(3)

    col1.metric("✈️ Airports", airport_count)
    col2.metric("🛫 Flights", flight_count)
    col3.metric("🛩️ Aircraft", aircraft_count)

    st.markdown("---")

    st.subheader("Flight Status Overview")

    status_df = pd.read_sql(
        """
        SELECT
            status,
            COUNT(*) AS total
        FROM flights
        GROUP BY status
        ORDER BY total DESC
        """,
        conn
    )

    st.bar_chart(
        status_df.set_index("status")
    )

    st.subheader("Top 10 Destination Airports")

    dest_df = pd.read_sql(
        """
        SELECT
            destination_iata,
            COUNT(*) AS arrivals
        FROM flights
        WHERE destination_iata IS NOT NULL
        GROUP BY destination_iata
        ORDER BY arrivals DESC
        LIMIT 10
        """,
        conn
    )

    st.dataframe(dest_df)

# ==================================================
# FLIGHT SEARCH
# ==================================================

elif page == "Flight Search":

    st.header("🔍 Flight Search")

    flight_no = st.text_input(
        "Enter Flight Number"
    )

    if flight_no:

        query = f"""
        SELECT
            flight_number,
            airline_name,
            origin_iata,
            destination_iata,
            status,
            scheduled_departure
        FROM flights
        WHERE flight_number ILIKE '%{flight_no}%'
        """

        df = pd.read_sql(
            query,
            conn
        )

        st.dataframe(df)

# ==================================================
# AIRPORT EXPLORER
# ==================================================

elif page == "Airport Explorer":

    st.header("🛫 Airport Explorer")

    airports_df = pd.read_sql(
        "SELECT * FROM airport",
        conn
    )

    selected_airport = st.selectbox(
        "Choose Airport",
        airports_df["iata_code"].tolist(),
        key="airport_explorer"
    )

    result = airports_df[
        airports_df["iata_code"] == selected_airport
    ]

    st.dataframe(result)

# ==================================================
# DELAY ANALYSIS
# ==================================================

elif page == "Delay Analysis":

    st.header("📊 Delay Analysis")

    query = """
    SELECT
        destination_iata,
        COUNT(*) AS total_flights,
        SUM(
            CASE
                WHEN status='Delayed'
                THEN 1
                ELSE 0
            END
        ) AS delayed_flights
    FROM flights
    WHERE destination_iata IS NOT NULL
    GROUP BY destination_iata
    ORDER BY delayed_flights DESC
    """

    df = pd.read_sql(
        query,
        conn
    )

    st.subheader("Delayed Flights by Destination")

    st.bar_chart(
        df.set_index(
            "destination_iata"
        )["delayed_flights"]
    )

    status_df = pd.read_sql(
        """
        SELECT
            status,
            COUNT(*) AS total
        FROM flights
        GROUP BY status
        """,
        conn
    )

    st.subheader(
        "Flight Status Distribution"
    )

    st.bar_chart(
        status_df.set_index(
            "status"
        )
    )

# ==================================================
# SQL INSIGHTS
# ==================================================

elif page == "SQL Insights":

    st.header("📈 SQL Insights")

    query1 = """
    SELECT
        aircraft_model,
        COUNT(*) AS total_flights
    FROM flights
    WHERE aircraft_model IS NOT NULL
    GROUP BY aircraft_model
    ORDER BY total_flights DESC
    """

    df1 = pd.read_sql(
        query1,
        conn
    )

    st.subheader(
        "Flights by Aircraft Model"
    )

    st.dataframe(df1)

    query2 = """
    SELECT
        destination_iata,
        COUNT(*) AS arrivals
    FROM flights
    WHERE destination_iata IS NOT NULL
    GROUP BY destination_iata
    ORDER BY arrivals DESC
    LIMIT 10
    """

    df2 = pd.read_sql(
        query2,
        conn
    )

    st.subheader(
        "Top Destination Airports"
    )

    st.dataframe(df2)