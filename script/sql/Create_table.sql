DROP TABLE IF EXISTS Car;
CREATE TABLE Car (
	index integer,
    "No" integer,
    "Symboling" integer, 
    "Normalized-losses" text, 
    "Make" text, 
    "type" text, 
    "Aspiration" text,  
    "Num-of-doors" text, 
    "Body-style" text, 
    "Drive-wheels" text, 
    "Engine-location" text, 
    "Wheel-base" float, 
    "Curb-weight" integer, 
    "Engine-type" text, 
    "Num_cylinders" text, 
    "Fuel-system" text, 
    "Compression-ratio" float, 
    "Horsepower" text, 
    "peak-rpm" text, 
    "city-mpg" integer, 
    "highway-mpg" integer, 
    "Load-date" DATE
);
	
DROP TABLE IF EXISTS Symboling;
CREATE TABLE Symboling (
    id SERIAL,
    Symboling integer UNIQUE,
    PRIMARY KEY (id)
);

DROP TABLE IF EXISTS Make;
CREATE TABLE Make (
    id SERIAL,
    Make VARCHAR(50) UNIQUE,
    PRIMARY KEY (id)
);

DROP TABLE IF EXISTS Type;
CREATE TABLE Type (
    id SERIAL,
    Type VARCHAR(50) UNIQUE,
    PRIMARY KEY (id)
);

DROP TABLE IF EXISTS Aspiration;
CREATE TABLE Aspiration (
    id SERIAL,
    Aspiration VARCHAR(50) UNIQUE,
    PRIMARY KEY (id)
);

DROP TABLE IF EXISTS Num_of_doors;
CREATE TABLE Num_of_doors (
    id SERIAL,
    Num_of_doors VARCHAR(50) UNIQUE,
    PRIMARY KEY (id)
);

DROP TABLE IF EXISTS Body_style;
CREATE TABLE Body_style (
    id SERIAL,
    Body_style VARCHAR(50) UNIQUE,
    PRIMARY KEY (id)
);

DROP TABLE IF EXISTS Drive_wheels;
CREATE TABLE Drive_wheels (
    id SERIAL,
    Drive_wheels VARCHAR(50) UNIQUE,
    PRIMARY KEY (id)
);

DROP TABLE IF EXISTS Engine_location;
CREATE TABLE Engine_location (
    id SERIAL,
    Engine_location VARCHAR(50) UNIQUE,
    PRIMARY KEY (id)
);

DROP TABLE IF EXISTS Engine_type;
CREATE TABLE Engine_type (
    id SERIAL,
    Engine_type VARCHAR(50) UNIQUE,
    PRIMARY KEY (id)
);

DROP TABLE IF EXISTS Num_cylinders;
CREATE TABLE Num_cylinders (
    id SERIAL,
    Num_cylinders VARCHAR(50) UNIQUE,
    PRIMARY KEY (id)
);
DROP TABLE IF EXISTS Fuel_system;
CREATE TABLE Fuel_system (
    id SERIAL,
    Fuel_system VARCHAR(50) UNIQUE,
    PRIMARY KEY (id)
);

DROP TABLE IF EXISTS std_car;
CREATE TABLE std_car (
	id SERIAL,
    "No" integer UNIQUE,
    id_Symboling integer, 
    Normalized_losses text, 
    id_Make integer, 
    id_type integer, 
    id_Aspiration integer,  
    id_Num_of_doors integer, 
    id_Body_style integer, 
    id_Drive_wheels integer, 
    id_Engine_location integer, 
    Wheel_base float, 
    Curb_weight integer, 
    id_Engine_type integer, 
    id_Num_cylinders integer, 
    id_Fuel_system integer, 
    Compression_ratio float, 
    Horsepower text, 
    peak_rpm text, 
    city_mpg integer, 
    highway_mpg integer, 
    Load_date DATE,
    
    FOREIGN KEY(id_Symboling) REFERENCES Symboling(id),
--     FOREIGN KEY(id_Normalized_losses) REFERENCES Normalized_losses(id),
    FOREIGN KEY(id_Make) REFERENCES Make(id),
    FOREIGN KEY(id_type) REFERENCES Type(id),
    FOREIGN KEY(id_Aspiration) REFERENCES Aspiration(id),
    FOREIGN KEY(id_Num_of_doors) REFERENCES Num_of_doors(id),
    FOREIGN KEY(id_Body_style) REFERENCES Body_style(id),
    FOREIGN KEY(id_Drive_wheels) REFERENCES Drive_wheels(id),
    FOREIGN KEY(id_Engine_location) REFERENCES Engine_location(id),
--     FOREIGN KEY(id_Wheel_base) REFERENCES Wheel_base(id),
--     FOREIGN KEY(id_Curb_weight) REFERENCES Curb_weight(id),
    FOREIGN KEY(id_Engine_type) REFERENCES Engine_type(id),
    FOREIGN KEY(id_Num_cylinders) REFERENCES Num_cylinders(id),
    FOREIGN KEY(id_Fuel_system) REFERENCES Fuel_system(id),
--     FOREIGN KEY(id_Compression_ratio) REFERENCES Compression_ratio(id),
--     FOREIGN KEY(id_Horsepower) REFERENCES Horsepower(id),
--     FOREIGN KEY(id_peak_rpm) REFERENCES peak_rpm(id),
--     FOREIGN KEY(id_city_mpg) REFERENCES city_mpg(id),
--     FOREIGN KEY(id_highway_mpg) REFERENCES highway_mpg(id),
--     FOREIGN KEY(id_load_date) REFERENCES load_date(id),
    PRIMARY KEY(id));