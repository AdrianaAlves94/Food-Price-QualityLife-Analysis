-- ====================================================================
-- File:        02_load_hicp_data.sql
-- Purpose:     Load monthly HICP food-price CSV from Eurostat and
--              aggregate to yearly averages.
-- Prereq:      Run 01_schema_setup.sql first.
-- ====================================================================

USE projectSQL;

-- --------------------------------------------------------------------
-- Staging raw monthly observations as they appear in the CSV.
-- Dropped at the end of this script.
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS hicp_food_monthly_raw;
CREATE TABLE hicp_food_monthly_raw (
    freq         VARCHAR(2),
    unit         VARCHAR(10),
    indx         VARCHAR(10),
    coicop       VARCHAR(10),
    geo          VARCHAR(2),
    time_period  VARCHAR(7),
    obs_value    DECIMAL(8,2),
    obs_flag     VARCHAR(5)
);

-- --------------------------------------------------------------------
-- Roll up monthly observations to yearly averages.
-- Track months_averaged so we can later filter incomplete years.
-- --------------------------------------------------------------------
INSERT INTO hicp_food_yearly
    (country_code, product_code, measure_code, year, value, months_averaged)
SELECT
    geo                                       AS country_code,
    coicop                                    AS product_code,
    unit                                      AS measure_code,
    CAST(LEFT(time_period, 4) AS UNSIGNED)    AS year,
    ROUND(AVG(obs_value), 2)                  AS value,
    COUNT(obs_value)                          AS months_averaged
FROM hicp_food_monthly_raw
WHERE obs_value IS NOT NULL
GROUP BY geo, coicop, unit, year;


DROP TABLE hicp_food_monthly_raw;


SELECT
    COUNT(*)                  AS total_rows,
    COUNT(DISTINCT country_code) AS countries,
    MIN(year)                 AS first_year,
    MAX(year)                 AS last_year
FROM hicp_food_yearly;
