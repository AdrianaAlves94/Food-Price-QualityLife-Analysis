# Food Inflation vs. Quality of Life in Europe (2015–2024)

A SQL analytics project investigating whether the surge in fruit and vegetable
prices across European countries since 2015 has tracked changes in overall
quality of life.

---

## Business questions

1. How has the price of fruits and vegetables evolved in six representative
   European countries (Germany, Greece, Hungary, Spain, Netherlands, Romania)
   since 2015?
2. Which countries have been hit hardest by produce inflation, and which have
   been most resilient?
3. Is there a measurable relationship between produce inflation and the
   country's quality-of-life index?

## Data sources

| Dataset | Source | Granularity |
|---|---|---|
| Harmonised Index of Consumer Prices (HICP) — Fruit (CP0116) & Vegetables (CP0117) | Eurostat (`prc_fsc_idx`) | Country × Product × Month |
| Quality of Life Index | Numbeo | Country × Year |


## Schema

Three lookup tables and two fact tables form a small star schema:

```
  ┌────────────┐      ┌──────────────────────┐      ┌────────────┐
  │ countries  │◄─────┤ hicp_food_yearly     ├─────►│ products   │
  │ (32 rows)  │      │ (fact, ~600 rows)    │      │ (2 rows)   │
  └────────────┘      └──────────┬───────────┘      └────────────┘
        ▲                        │
        │                        ▼
        │             ┌──────────────────────┐
        └─────────────┤ quality_of_life_long │
                      │ (fact, ~60 rows)     │
                      └──────────────────────┘
                             ▲
                             │
                      ┌──────┴───────┐
                      │   measures   │
                      │  (2 rows)    │
                      └──────────────┘
```






## Key findings



- Between 2015 and 2024, produce prices in **Hungary** rose by **133.5%**, the largest
  jump in the sample, while the **Netherlands** saw the smallest increase at **43%**.
- **Hungary** consistently ranked highest for produce inflation across the years
  while **Greece** stayed near the bottom for most of the period, pointing to structural rather than transient differences.

---

*Project by Adriana Alves — Data Analytics Bootcamp, 2026.*