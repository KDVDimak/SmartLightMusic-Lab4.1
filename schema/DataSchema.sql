-- SmartLight & Music Assistant — PostgreSQL DDL

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    CONSTRAINT users_email_template CHECK (
        email ~ '^[a-z0-9][a-z0-9._-]*@[a-z][a-z0-9._-]*\.[a-z]{2,}$'
    )
);

CREATE TABLE rooms (
    room_id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    user_id INTEGER NOT NULL REFERENCES users (user_id)
);

CREATE TABLE devices (
    device_id SERIAL PRIMARY KEY,
    device_type VARCHAR(20) NOT NULL,
    model VARCHAR(50),
    serial_no VARCHAR(50) NOT NULL UNIQUE,
    room_id INTEGER NOT NULL REFERENCES rooms (room_id),
    CONSTRAINT devices_type_allowed CHECK (
        device_type IN ('light', 'speaker', 'sensor-hub')
    ),
    CONSTRAINT devices_serial_template CHECK (serial_no ~ '^[A-Z0-9-]{5,}$')
);

CREATE TABLE sensors (
    sensor_id SERIAL PRIMARY KEY,
    sensor_type VARCHAR(20) NOT NULL,
    unit VARCHAR(10) NOT NULL,
    location_note VARCHAR(100),
    room_id INTEGER NOT NULL REFERENCES rooms (room_id),
    CONSTRAINT sensors_type_allowed CHECK (
        sensor_type IN ('illumination', 'motion', 'noise')
    ),
    CONSTRAINT sensors_unit_allowed CHECK (unit IN ('lx', 'bool', 'dB'))
);

CREATE TABLE readings (
    reading_id SERIAL PRIMARY KEY,
    sensor_id INTEGER NOT NULL REFERENCES sensors (sensor_id),
    ts TIMESTAMP NOT NULL,
    value NUMERIC(8, 2) NOT NULL
);

CREATE TABLE playlists (
    playlist_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users (user_id),
    title VARCHAR(100) NOT NULL,
    mood VARCHAR(30)
);

CREATE TABLE activities (
    activity_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE recommendations (
    reco_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users (user_id),
    reading_id INTEGER REFERENCES readings (reading_id),
    activity_id INTEGER REFERENCES activities (activity_id),
    reco_type VARCHAR(10) NOT NULL,
    text TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    CONSTRAINT reco_type_allowed CHECK (
        reco_type IN ('light', 'music', 'safety')
    )
);

CREATE TABLE preferences (
    pref_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users (user_id),
    activity_id INTEGER NOT NULL REFERENCES activities (activity_id),
    preferred_light_level SMALLINT NOT NULL CHECK (
        preferred_light_level BETWEEN 0 AND 100
    ),
    preferred_genre VARCHAR(40),
    CONSTRAINT preferences_user_activity_uk UNIQUE (user_id, activity_id)
);

-- Індекси для швидких запитів
CREATE INDEX idx_rooms_user ON rooms (user_id);
CREATE INDEX idx_devices_room ON devices (room_id);
CREATE INDEX idx_sensors_room ON sensors (room_id);
CREATE INDEX idx_readings_sensor_ts ON readings (sensor_id, ts);
CREATE INDEX idx_playlists_user ON playlists (user_id);
CREATE INDEX idx_reco_user_created ON recommendations (user_id, created_at);
