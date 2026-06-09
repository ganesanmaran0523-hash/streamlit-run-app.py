CREATE TABLE aircraft (
    aircraft_id SERIAL PRIMARY KEY,

    registration VARCHAR(20),

    model VARCHAR(100),

    manufacturer VARCHAR(100),

    icao_type_code VARCHAR(20),

    aircraft_owner VARCHAR(255)
);

aircraft_owner

DROP TABLE IF EXISTS aircraft;

CREATE TABLE aircraft (
    aircraft_id SERIAL PRIMARY KEY,
    registration VARCHAR(20),
    model VARCHAR(100),
    manufacturer VARCHAR(100),
    icao_type_code VARCHAR(20),
    aircraft_owner VARCHAR(255)
);

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public';

CREATE TABLE flights (
    flight_id SERIAL PRIMARY KEY,
    flight_number VARCHAR(20),
    aircraft_registration VARCHAR(20),
    aircraft_model VARCHAR(100),
    origin_iata VARCHAR(10),
    destination_iata VARCHAR(10),
    scheduled_departure TIMESTAMP,
    scheduled_arrival TIMESTAMP,
    status VARCHAR(50),
    airline_code VARCHAR(20),
    airline_name VARCHAR(100)
);

CREATE TABLE airport_delays (
    delay_id SERIAL PRIMARY KEY,
    airport_iata VARCHAR(10),
    delay_date DATE,
    total_flights INTEGER,
    delayed_flights INTEGER,
    avg_delay_min INTEGER,
    median_delay_min INTEGER,
    canceled_flights INTEGER
);

SELECT table_name
FROM information_schema.tables
WHERE table_schema='public';

SELECT *
FROM airport;

DELETE FROM airport
WHERE iata_code IS NULL;

SELECT COUNT(*)
FROM airport;

DELETE FROM airport
WHERE iata_code IS NULL;

SELECT airport_id, iata_code, name
FROM airport;

TRUNCATE TABLE flights;

SELECT COUNT(*)
FROM flights;

SELECT COUNT(*) FROM flights;

SELECT COUNT(DISTINCT aircraft_registration)
FROM flights
WHERE aircraft_registration IS NOT NULL;

INSERT INTO aircraft
(
    registration,
    model
)
SELECT DISTINCT
    aircraft_registration,
    aircraft_model
FROM flights
WHERE aircraft_registration IS NOT NULL;

SELECT COUNT(*)
FROM aircraft;
Total flights per aircraft model


SELECT
    a.model,
    COUNT(*) AS total_flights
FROM flights f
JOIN aircraft a
ON f.aircraft_registration = a.registration
GROUP BY a.model
ORDER BY total_flights DESC;

SELECT
    registration,
    model,
    COUNT(*) AS flight_count
FROM aircraft a
JOIN flights f
ON a.registration = f.aircraft_registration
GROUP BY registration, model
HAVING COUNT(*) > 5;

SELECT
    status,
    COUNT(*)
FROM flights
GROUP BY status
ORDER BY COUNT(*) DESC;

SELECT status, COUNT(*)
FROM flights
GROUP BY status;

DELETE FROM airport
WHERE iata_code IS NULL;

INSERT INTO airport
(icao_code,iata_code,name,city,country,continent)
VALUES
('VOBL','BLR','Kempegowda International Airport','Bengaluru','India','Asia'),
('EGLL','LHR','London Heathrow Airport','London','United Kingdom','Europe'),
('KJFK','JFK','John F Kennedy International Airport','New York','United States','North America')
ON CONFLICT (iata_code) DO NOTHING;

SELECT iata_code,name
FROM airport;

SELECT
    airline_code,

    SUM(CASE WHEN status='Expected' THEN 1 ELSE 0 END) AS expected,

    SUM(CASE WHEN status='Delayed' THEN 1 ELSE 0 END) AS delayed,

    SUM(CASE WHEN status='Canceled' THEN 1 ELSE 0 END) AS cancelled,

    COUNT(*) AS total_flights

FROM flights
GROUP BY airline_code
ORDER BY total_flights DESC;


SELECT
    flight_number,
    aircraft_registration,
    origin_iata,
    destination_iata,
    status
FROM flights
WHERE status='Canceled';

SELECT
    destination_iata,

    ROUND(
        100.0 *
        SUM(CASE WHEN status='Delayed' THEN 1 ELSE 0 END)
        /
        COUNT(*),
        2
    ) AS delay_percentage

FROM flights

GROUP BY destination_iata

ORDER BY delay_percentage DESC;

SELECT COUNT(*) FROM aircraft;

SELECT
    a.model,
    COUNT(*) AS total_flights
FROM flights f
JOIN aircraft a
ON f.aircraft_registration = a.registration
GROUP BY a.model
ORDER BY total_flights DESC;

SELECT
    registration,
    model,
    COUNT(*) AS flight_count
FROM aircraft a
JOIN flights f
ON a.registration = f.aircraft_registration
GROUP BY registration, model
HAVING COUNT(*) > 5;

SELECT
    ap.name,
    COUNT(*) AS outbound_flights
FROM airport ap
JOIN flights f
ON ap.iata_code = f.origin_iata
GROUP BY ap.name
HAVING COUNT(*) > 5;

SELECT
    destination_iata,
    COUNT(*) AS arrivals
FROM flights
GROUP BY destination_iata
ORDER BY arrivals DESC
LIMIT 3;

SELECT
    flight_number,
    origin_iata,
    destination_iata,

    CASE
        WHEN destination_iata IN
        ('DEL','BOM','MAA','BLR','HYD')
        THEN 'Domestic'

        ELSE 'International'
    END AS flight_type

FROM flights;

SELECT
    flight_number,
    origin_iata,
    destination_iata,

    CASE
        WHEN destination_iata IN
        ('DEL','BOM','MAA','BLR','HYD')
        THEN 'Domestic'

        ELSE 'International'
    END AS flight_type

FROM flights;

SELECT
    flight_number,
    aircraft_registration,
    destination_iata,
    scheduled_departure

FROM flights

WHERE origin_iata='DEL'

ORDER BY scheduled_departure DESC

LIMIT 5;

SELECT
    iata_code,
    name

FROM airport

WHERE iata_code NOT IN
(
    SELECT DISTINCT destination_iata
    FROM flights
    WHERE destination_iata IS NOT NULL
);

SELECT
    a.name,
    a.city,
    COUNT(*) AS arrivals
FROM flights f
JOIN airport a
ON f.destination_iata = a.iata_code
WHERE f.destination_iata IS NOT NULL
GROUP BY a.name, a.city
ORDER BY arrivals DESC
LIMIT 3;

SELECT
    destination_iata,
    COUNT(*) AS arrivals
FROM flights
WHERE destination_iata IS NOT NULL
GROUP BY destination_iata
ORDER BY arrivals DESC
LIMIT 3;

SELECT
    destination_iata,
    COUNT(*) AS arrivals
FROM flights
WHERE destination_iata IS NOT NULL
GROUP BY destination_iata
ORDER BY arrivals DESC
LIMIT 3;

SELECT
    flight_number,
    origin_iata,
    destination_iata,

    CASE
        WHEN destination_iata IN
        ('DEL','BOM','MAA','BLR','HYD')
        THEN 'Domestic'
        ELSE 'International'
    END AS flight_type

FROM flights;

SELECT column_name
FROM information_schema.columns
WHERE table_name='flights';

SELECT
    flight_number,
    origin_iata,
    destination_iata,

    CASE
        WHEN destination_iata IN
        ('DEL','BOM','MAA','BLR','HYD')
        THEN 'Domestic'
        ELSE 'International'
    END AS flight_type

FROM flights
WHERE destination_iata IS NOT NULL;

SELECT
    flight_number,
    origin_iata,
    destination_iata,

    CASE
        WHEN destination_iata IN
        ('DEL','BOM','MAA','BLR','HYD')
        THEN 'Domestic'
        ELSE 'International'
    END AS flight_type

FROM flights
WHERE destination_iata IS NOT NULL;

SELECT
    flight_number,
    aircraft_registration,
    destination_iata,
    scheduled_departure

FROM flights

WHERE origin_iata='DEL'

AND scheduled_departure IS NOT NULL

ORDER BY scheduled_departure DESC

LIMIT 5;

SELECT
COUNT(*)
FROM flights
WHERE origin_iata='DEL';

SELECT
flight_number,
aircraft_registration,
destination_iata,
scheduled_departure

FROM flights

ORDER BY scheduled_departure DESC

LIMIT 5;

SELECT
    iata_code,
    name

FROM airport

WHERE iata_code NOT IN
(
    SELECT DISTINCT destination_iata
    FROM flights
    WHERE destination_iata IS NOT NULL
);

SELECT

    origin_iata,

    destination_iata,

    COUNT(
        DISTINCT aircraft_model
    ) AS aircraft_models

FROM flights

WHERE aircraft_model IS NOT NULL

GROUP BY
origin_iata,
destination_iata

HAVING COUNT(
    DISTINCT aircraft_model
) > 2

ORDER BY aircraft_models DESC;

SELECT COUNT(*)
FROM flights
WHERE destination_iata IS NOT NULL;

SELECT COUNT(*)
FROM flights
WHERE aircraft_model IS NOT NULL;

SELECT COUNT(*)
FROM flights
WHERE scheduled_departure IS NOT NULL;

SELECT
    aircraft_model,
    COUNT(*) AS total_flights
FROM flights
WHERE aircraft_model IS NOT NULL
GROUP BY aircraft_model
ORDER BY total_flights DESC;

SELECT
    aircraft_registration,
    aircraft_model,
    COUNT(*) AS flight_count
FROM flights
WHERE aircraft_registration IS NOT NULL
GROUP BY aircraft_registration, aircraft_model
HAVING COUNT(*) > 5
ORDER BY flight_count DESC;

SELECT
    origin_iata,
    COUNT(*) AS outbound_flights
FROM flights
GROUP BY origin_iata
HAVING COUNT(*) > 5
ORDER BY outbound_flights DESC;

SELECT
    destination_iata,
    COUNT(*) AS arrivals
FROM flights
WHERE destination_iata IS NOT NULL
GROUP BY destination_iata
ORDER BY arrivals DESC
LIMIT 3;

SELECT
    flight_number,
    origin_iata,
    destination_iata,

    CASE
        WHEN destination_iata IN
        ('DEL','BOM','MAA','BLR','HYD')
        THEN 'Domestic'
        ELSE 'International'
    END AS flight_type

FROM flights
WHERE destination_iata IS NOT NULL;

SELECT
    flight_number,
    aircraft_registration,
    destination_iata,
    scheduled_departure

FROM flights

WHERE origin_iata='DEL'

ORDER BY scheduled_departure DESC

LIMIT 5;

SELECT
    flight_number,
    aircraft_registration,
    destination_iata,
    scheduled_departure

FROM flights

ORDER BY scheduled_departure DESC

LIMIT 5;

SELECT
    iata_code,
    name
FROM airport
WHERE iata_code NOT IN
(
    SELECT DISTINCT destination_iata
    FROM flights
    WHERE destination_iata IS NOT NULL
);

SELECT

    airline_code,

    SUM(
        CASE
        WHEN status='Expected'
        THEN 1
        ELSE 0
        END
    ) AS expected,

    SUM(
        CASE
        WHEN status='Delayed'
        THEN 1
        ELSE 0
        END
    ) AS delayed,

    SUM(
        CASE
        WHEN status='Canceled'
        THEN 1
        ELSE 0
        END
    ) AS cancelled,

    COUNT(*) AS total_flights

FROM flights

GROUP BY airline_code

ORDER BY total_flights DESC;

SELECT

    airline_code,

    SUM(
        CASE
        WHEN status='Expected'
        THEN 1
        ELSE 0
        END
    ) AS expected,

    SUM(
        CASE
        WHEN status='Delayed'
        THEN 1
        ELSE 0
        END
    ) AS delayed,

    SUM(
        CASE
        WHEN status='Canceled'
        THEN 1
        ELSE 0
        END
    ) AS cancelled,

    COUNT(*) AS total_flights

FROM flights

GROUP BY airline_code

ORDER BY total_flights DESC;

SELECT

    flight_number,

    aircraft_registration,

    origin_iata,

    destination_iata,

    status

FROM flights

WHERE status='Canceled';

SELECT

    origin_iata,

    destination_iata,

    COUNT(
        DISTINCT aircraft_model
    ) AS aircraft_models

FROM flights

WHERE aircraft_model IS NOT NULL

GROUP BY
origin_iata,
destination_iata

HAVING COUNT(
    DISTINCT aircraft_model
) > 2

ORDER BY aircraft_models DESC;

SELECT

    destination_iata,

    ROUND(
        100.0 *
        SUM(
            CASE
            WHEN status='Delayed'
            THEN 1
            ELSE 0
            END
        )
        /
        COUNT(*)
    ,2) AS delay_percentage

FROM flights

WHERE destination_iata IS NOT NULL

GROUP BY destination_iata

ORDER BY delay_percentage DESC;

SELECT *
FROM flights
LIMIT 10;

SELECT *
FROM airport;

SELECT
    status,
    COUNT(*)
FROM flights
GROUP BY status
ORDER BY COUNT(*) DESC;

SELECT COUNT(*)
FROM flights
WHERE origin_iata='DEL';

SELECT *
FROM flights
LIMIT 10;

SELECT *
FROM airport;

SELECT
    status,
    COUNT(*)
FROM flights
GROUP BY status
ORDER BY COUNT(*) DESC;

SELECT COUNT(*)
FROM flights
WHERE origin_iata='DEL';

SELECT
    flight_number,
    origin_iata,
    destination_iata,
    CASE
        WHEN destination_iata IN ('BOM','MAA','BLR','HYD','DEL')
        THEN 'Domestic'
        ELSE 'International'
    END AS flight_type
FROM flights
WHERE destination_iata IS NOT NULL;

SELECT
    flight_number,
    aircraft_registration,
    destination_iata,
    scheduled_departure
FROM flights
WHERE origin_iata='DEL'
ORDER BY scheduled_departure DESC
LIMIT 5;

SELECT
    iata_code,
    name
FROM airport
WHERE iata_code NOT IN
(
    SELECT DISTINCT destination_iata
    FROM flights
    WHERE destination_iata IS NOT NULL
);

SELECT
    airline_code,

    COUNT(*) FILTER (WHERE status='Expected') AS expected,

    COUNT(*) FILTER (WHERE status='Delayed') AS delayed,

    COUNT(*) FILTER (WHERE status='Canceled') AS cancelled,

    COUNT(*) AS total_flights

FROM flights

GROUP BY airline_code

ORDER BY total_flights DESC;

SELECT
    flight_number,
    aircraft_registration,
    origin_iata,
    destination_iata,
    status
FROM flights
WHERE status='Canceled';

SELECT
    origin_iata,
    destination_iata,
    COUNT(DISTINCT aircraft_model) AS aircraft_models
FROM flights
WHERE
    destination_iata IS NOT NULL
    AND aircraft_model IS NOT NULL
GROUP BY
    origin_iata,
    destination_iata
HAVING COUNT(DISTINCT aircraft_model) > 2
ORDER BY aircraft_models DESC;

SELECT
    destination_iata,

    ROUND(
        (
            COUNT(*) FILTER (WHERE status='Delayed') * 100.0
        ) / COUNT(*),
        2
    ) AS delay_percentage

FROM flights

WHERE destination_iata IS NOT NULL

GROUP BY destination_iata

ORDER BY delay_percentage DESC;

SELECT
    iata_code,
    name
FROM airport
EXCEPT
SELECT
    destination_iata,
    destination_iata
FROM flights
WHERE destination_iata IS NOT NULL;

SELECT
    airline_code,

    SUM(CASE WHEN status='Expected' THEN 1 ELSE 0 END) AS expected,

    SUM(CASE WHEN status='Delayed' THEN 1 ELSE 0 END) AS delayed,

    SUM(CASE WHEN status='Canceled' THEN 1 ELSE 0 END) AS cancelled,

    COUNT(*) AS total_flights

FROM flights

GROUP BY airline_code

ORDER BY total_flights DESC;

SELECT
    destination_iata,

    ROUND(
        (
            SUM(CASE WHEN status='Delayed' THEN 1 ELSE 0 END) * 100.0
        ) /
        COUNT(*),
        2
    ) AS delay_percentage

FROM flights

WHERE destination_iata IS NOT NULL

GROUP BY destination_iata

ORDER BY delay_percentage DESC;

SELECT
    airline_code,
    status,
    COUNT(*) AS flight_count
FROM flights
GROUP BY airline_code, status
ORDER BY airline_code, flight_count DESC;

SELECT
    destination_iata,
    COUNT(*) AS total_flights,
    SUM(
        CASE
            WHEN status = 'Delayed' THEN 1
            ELSE 0
        END
    ) AS delayed_flights
FROM flights
WHERE destination_iata IS NOT NULL
GROUP BY destination_iata
ORDER BY delayed_flights DESC;

SELECT
    aircraft_model,
    COUNT(*) AS total_flights
FROM flights
WHERE aircraft_model IS NOT NULL
GROUP BY aircraft_model
ORDER BY total_flights DESC;

SELECT
    aircraft_registration,
    aircraft_model,
    COUNT(*) AS flight_count
FROM flights
WHERE aircraft_registration IS NOT NULL
GROUP BY aircraft_registration, aircraft_model
HAVING COUNT(*) > 5
ORDER BY flight_count DESC;

SELECT
    origin_iata,
    COUNT(*) AS outbound_flights
FROM flights
GROUP BY origin_iata
HAVING COUNT(*) > 5
ORDER BY outbound_flights DESC;

SELECT
    destination_iata,
    COUNT(*) AS arrivals
FROM flights
WHERE destination_iata IS NOT NULL
GROUP BY destination_iata
ORDER BY arrivals DESC
LIMIT 3;

SELECT
    flight_number,
    origin_iata,
    destination_iata,
    CASE
        WHEN destination_iata IN
        ('DEL','BOM','MAA','BLR','HYD')
        THEN 'Domestic'
        ELSE 'International'
    END AS flight_type
FROM flights
WHERE destination_iata IS NOT NULL;.

SELECT
    flight_number,
    aircraft_registration,
    destination_iata,
    scheduled_departure
FROM flights
WHERE origin_iata='DEL'
ORDER BY scheduled_departure DESC
LIMIT 5;

SELECT
    iata_code,
    name
FROM airport
EXCEPT
SELECT
    destination_iata,
    destination_iata
FROM flights
WHERE destination_iata IS NOT NULL;

SELECT
    airline_code,
    status,
    COUNT(*) AS flight_count
FROM flights
GROUP BY airline_code, status
ORDER BY airline_code, flight_count DESC;

SELECT
    flight_number,
    aircraft_registration,
    origin_iata,
    destination_iata,
    status
FROM flights
WHERE status='Canceled';

SELECT
    origin_iata,
    destination_iata,
    COUNT(DISTINCT aircraft_model) AS aircraft_models
FROM flights
WHERE
    destination_iata IS NOT NULL
    AND aircraft_model IS NOT NULL
GROUP BY
    origin_iata,
    destination_iata
HAVING COUNT(DISTINCT aircraft_model) > 2
ORDER BY aircraft_models DESC;

SELECT
    destination_iata,
    COUNT(*) AS total_flights,
    SUM(CASE WHEN status='Delayed' THEN 1 ELSE 0 END) AS delayed_flights,
    ROUND(
        SUM(CASE WHEN status='Delayed' THEN 1 ELSE 0 END)::numeric
        * 100
        / COUNT(*),
        2
    ) AS delay_percentage
FROM flights
WHERE destination_iata IS NOT NULL
GROUP BY destination_iata
ORDER BY delay_percentage DESC;

SELECT
    aircraft_registration,
    COUNT(*) AS flight_count
FROM flights
WHERE aircraft_registration IS NOT NULL
GROUP BY aircraft_registration
ORDER BY flight_count DESC;

SELECT
    aircraft_registration,
    aircraft_model,
    COUNT(*) AS flight_count
FROM flights
WHERE aircraft_registration IS NOT NULL
GROUP BY aircraft_registration, aircraft_model
HAVING COUNT(*) >= 2
ORDER BY flight_count DESC;