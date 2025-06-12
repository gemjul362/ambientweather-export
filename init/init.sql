CREATE TABLE IF NOT EXISTS weather_data (
    id SERIAL PRIMARY KEY,
    timestamp TIMESTAMP UNIQUE,
    tempf FLOAT,
    humidity INT,
    windspeed FLOAT,
    windgust FLOAT,
    winddir INT,
    pressure FLOAT,
    solarRadiation FLOAT,
    uv FLOAT
);
