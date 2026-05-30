-- ====================================================================
-- File:        06_inflation_vs_qol.sql
-- Purpose:     Investigate the relationship between produce inflation
--              and Quality of Life across countries and years.
-- Prereq:      01, 02, 03 must have been run.
-- ====================================================================

USE projectSQL;

-- --------------------------------------------------------------------
-- Side-by-side: cumulative produce inflation since 2015 vs.
-- change in Quality of Life over the same period.
-- --------------------------------------------------------------------
WITH produce_bookends AS (
    SELECT
        country_code,
        country_name,
        MAX(CASE WHEN year = 2015 THEN produce_index END) AS produce_2015,
        MAX(CASE WHEN year = (SELECT MAX(year) FROM v_produce_vs_qol) THEN produce_index END) AS produce_latest
    FROM v_produce_vs_qol
    GROUP BY country_code, country_name
),
qol_bookends AS (
    SELECT
        country_code,
        MAX(CASE WHEN year = 2015 THEN qol_index END) AS qol_2015,
        MAX(CASE WHEN year = (SELECT MAX(year) FROM v_produce_vs_qol) THEN qol_index END) AS qol_latest
    FROM v_produce_vs_qol
    GROUP BY country_code
)
SELECT
    p.country_name,
    ROUND(p.produce_latest - p.produce_2015, 2) AS food_inflation_since_2015,
    ROUND(q.qol_latest - q.qol_2015, 2) AS qol_change_since_2015
FROM produce_bookends p
JOIN qol_bookends q ON q.country_code = p.country_code
ORDER BY food_inflation_since_2015 DESC;
