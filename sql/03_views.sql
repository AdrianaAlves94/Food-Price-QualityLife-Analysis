 -- ====================================================================
-- File:        03_views.sql
-- Purpose:     Define reusable views that encapsulate logic appearing
--              in multiple downstream analysis scripts.
-- Prereq:      01 and 02 must have been run.
-- ====================================================================

USE projectSQL;

-- --------------------------------------------------------------------
-- For each of the 6 focus countries, the yearly average HICP across
-- BOTH fruits (CP0116) and vegetables (CP0117), using the index
-- measure (I15: 2015 = 100).
-- --------------------------------------------------------------------
CREATE OR REPLACE VIEW v_produce_yearly_avg AS
SELECT
    c.country_code,
    c.country_name,
    h.year,
    ROUND(AVG(h.value), 2) AS avg_value
FROM hicp_food_yearly h
JOIN countries c ON c.country_code = h.country_code
WHERE h.measure_code = 'I15'
  AND h.product_code IN ('CP0116', 'CP0117')
  AND c.country_code IN ('DE', 'EL', 'RO', 'HU', 'ES', 'NL')
  AND h.year <= 2024
GROUP BY c.country_code, c.country_name, h.year;

-- --------------------------------------------------------------------
-- One row per country × year, combining produce inflation index with
-- the Quality of Life index.
-- --------------------------------------------------------------------
CREATE OR REPLACE VIEW v_produce_vs_qol AS
SELECT
    p.country_code,
    p.country_name,
    p.year,
    p.avg_value  AS produce_index,
    q.qol_value  AS qol_index
FROM v_produce_yearly_avg p
JOIN quality_of_life q
  ON q.country_code = p.country_code
 AND q.year = p.year;


SELECT * FROM v_produce_vs_qol ORDER BY country_name, year;
