USE projectSQL;

-- --------------------------------------------------------------------
-- Lookup table: products
-- HICP code → human-readable product name
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS products;
CREATE TABLE products (
    product_code VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL
);

INSERT INTO products VALUES
    ('CP0116', 'Fruit'),
    ('CP0117', 'Vegetables');

-- --------------------------------------------------------------------
-- Lookup table: countries
-- ISO 2-letter code → full name (uses Eurostat 'EL' for Greece and 'UK')
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS countries;
CREATE TABLE countries (
    country_code VARCHAR(2) PRIMARY KEY,
    country_name VARCHAR(50) NOT NULL
);

INSERT INTO countries VALUES
    ('AT','Austria'),('BE','Belgium'),('BG','Bulgaria'),('CY','Cyprus'),
    ('CZ','Czechia'),('DE','Germany'),('DK','Denmark'),('EE','Estonia'),
    ('EL','Greece'),('ES','Spain'),('FI','Finland'),('FR','France'),
    ('HR','Croatia'),('HU','Hungary'),('IE','Ireland'),('IT','Italy'),
    ('LT','Lithuania'),('LU','Luxembourg'),('LV','Latvia'),('MT','Malta'),
    ('NL','Netherlands'),('PL','Poland'),('PT','Portugal'),('RO','Romania'),
    ('SE','Sweden'),('SI','Slovenia'),('SK','Slovakia'),('UK','United Kingdom'),
    ('CH','Switzerland'),('IS','Iceland'),('NO','Norway'),('TR','Türkiye');

-- --------------------------------------------------------------------
-- Lookup table: measures
-- Tells us which kind of value a given HICP observation represents
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS measures;
CREATE TABLE measures (
    measure_code VARCHAR(10) PRIMARY KEY,
    measure_name VARCHAR(50) NOT NULL
);

INSERT INTO measures VALUES
    ('I15',     'Index 2015=100'),
    ('PCH_M12', 'YoY % change');

-- --------------------------------------------------------------------
-- Yearly average HICP per country × product × measure.
-- Populated in 02_load_hicp_data.sql from the monthly raw CSV.
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS hicp_food_yearly;
CREATE TABLE hicp_food_yearly (
    country_code     VARCHAR(2)    NOT NULL,
    product_code     VARCHAR(10)   NOT NULL,
    measure_code     VARCHAR(10)   NOT NULL,
    year             INT           NOT NULL,
    value            DECIMAL(8,2),
    months_averaged  INT,
    PRIMARY KEY (country_code, product_code, measure_code, year)
);

-- --------------------------------------------------------------------
-- Quality of Life index per country × year
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS quality_of_life;
CREATE TABLE quality_of_life (
    year          INT           NOT NULL,
    country_code  VARCHAR(2)    NOT NULL,
    qol_value     DECIMAL(8,2)  NOT NULL,
    PRIMARY KEY (year, country_code)
);

INSERT INTO quality_of_life (year, country_code, qol_value) VALUES
    (2015,'DE',220.10),(2015,'EL',112.50),(2015,'HU',103.40),(2015,'NL',193.80),(2015,'ES',156.85),(2015,'RO', 95.50),
    (2016,'DE',194.80),(2016,'EL',161.10),(2016,'HU',140.35),(2016,'NL',189.45),(2016,'ES',185.55),(2016,'RO',145.50),
    (2017,'DE',184.30),(2017,'EL',139.70),(2017,'HU',132.30),(2017,'NL',176.50),(2017,'ES',174.65),(2017,'RO',140.60),
    (2018,'DE',189.55),(2018,'EL',137.45),(2018,'HU',133.40),(2018,'NL',190.75),(2018,'ES',174.65),(2018,'RO',142.50),
    (2019,'DE',185.65),(2019,'EL',136.70),(2019,'HU',133.80),(2019,'NL',187.65),(2019,'ES',173.90),(2019,'RO',138.00),
    (2020,'DE',178.55),(2020,'EL',132.30),(2020,'HU',128.30),(2020,'NL',183.95),(2020,'ES',168.45),(2020,'RO',132.05),
    (2021,'DE',176.00),(2021,'EL',128.95),(2021,'HU',134.25),(2021,'NL',181.80),(2021,'ES',164.00),(2021,'RO',131.30),
    (2022,'DE',179.30),(2022,'EL',128.15),(2022,'HU',136.65),(2022,'NL',188.45),(2022,'ES',170.75),(2022,'RO',132.25),
    (2023,'DE',177.50),(2023,'EL',128.75),(2023,'HU',132.95),(2023,'NL',198.40),(2023,'ES',175.75),(2023,'RO',131.40),
    (2024,'DE',180.75),(2024,'EL',129.35),(2024,'HU',136.45),(2024,'NL',203.00),(2024,'ES',178.65),(2024,'RO',133.30);


SELECT 'products'              AS table_name, COUNT(*) AS row_count FROM products
UNION ALL SELECT 'countries',             COUNT(*) FROM countries
UNION ALL SELECT 'measures',              COUNT(*) FROM measures
UNION ALL SELECT 'quality_of_life',  COUNT(*) FROM quality_of_life;
