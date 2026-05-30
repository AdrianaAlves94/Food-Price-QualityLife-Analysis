-- ====================================================================
-- File:        04_inflation_trends.sql
-- Purpose:     How have produce prices moved
--              year over year, who's been hit hardest, who has the
--              highest/lowest inflation each year.
-- Prereq:      01, 02, 03 must have been run.
-- ====================================================================

USE projectSQL;

-- --------------------------------------------------------------------
-- Year-over-year change in produce inflation for each country.
-- --------------------------------------------------------------------
SELECT
    country_name,
    year,
    avg_value,
    LAG(avg_value)  OVER (PARTITION BY country_name ORDER BY year) AS prev_year,
    LEAD(avg_value) OVER (PARTITION BY country_name ORDER BY year) AS next_year,
    ROUND(avg_value - LAG(avg_value) OVER (PARTITION BY country_name ORDER BY year), 2) AS yoy_change,
    ROUND(
        (avg_value - LAG(avg_value) OVER (PARTITION BY country_name ORDER BY year))
        / LAG(avg_value) OVER (PARTITION BY country_name ORDER BY year) * 100,
        2
    ) AS yoy_pct_change
FROM v_produce_yearly_avg
ORDER BY country_name, year;

-- --------------------------------------------------------------------
-- Cumulative inflation per country (2015 - latest year).
-- --------------------------------------------------------------------
WITH bookends AS (
    SELECT
        country_name,
        MIN(year)                                            AS first_year,
        MAX(year)                                            AS last_year,
        MAX(CASE WHEN year = 2015 THEN avg_value END)        AS value_2015,
        MAX(CASE WHEN year = (SELECT MAX(year) FROM v_produce_yearly_avg) THEN avg_value END) AS value_latest
    FROM v_produce_yearly_avg
    GROUP BY country_name
)
SELECT
    country_name,
    first_year,
    last_year,
    value_2015,
    value_latest,
    ROUND(value_latest - value_2015, 2)                          AS cumulative_pts,
    ROUND((value_latest - value_2015) / value_2015 * 100, 2)     AS cumulative_pct
FROM bookends
ORDER BY cumulative_pct DESC;

-- --------------------------------------------------------------------
-- For every year, country rank from highest to lowest produce inflation index.
-- --------------------------------------------------------------------
SELECT
    year,
    country_name,
    avg_value,
    RANK() OVER (PARTITION BY year ORDER BY avg_value DESC) AS rank_highest,
    RANK() OVER (PARTITION BY year ORDER BY avg_value ASC)  AS rank_lowest
FROM v_produce_yearly_avg
ORDER BY year, rank_highest;
