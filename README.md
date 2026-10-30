# Northline Revenue Assurance (SQL)

Compare network usage with billing to find unbilled usage, wrong tariffs and missed recurring charges, then size the revenue leakage.

> Northline Telecom is a fictional company. All data in `data/` is generated sample data, not from any real employer.

## Problem

Northline Telecom bills 4,400 business customers for voice minutes, data and a monthly recurring charge. Finance suspected billed revenue was running below what customers actually used, but no one had tied usage records to billing lines.

## What I built

| File | Purpose |
|---|---|
| `generate_data.py` | Creates customers, rate plans, 26,400 usage records and 38,536 billing lines for Apr to Jun 2026 |
| `build_db.py` | Loads the CSVs into SQLite (`northline_ra.db`) with an `expected_charges` view (usage x plan rate) |
| `sql/01_unbilled_usage.sql` | Usage with no billing line |
| `sql/02_wrong_tariff.sql` | Lines billed below the customer's plan rate |
| `sql/03_missed_recurring.sql` | Active customers with no monthly recurring charge |
| `sql/04_leakage_summary.sql` | Leakage by type, annualized, and share of expected revenue |
| `run_queries.py` | Runs every query and prints results (no sqlite3 CLI needed) |

## How to run

```
python3 generate_data.py
python3 build_db.py
python3 run_queries.py northline_ra.db
```

## Key results (from the query output)

| Leakage type | Apr to Jun 2026 | Annualized | Share of expected revenue |
|---|---|---|---|
| Unbilled usage (625 records) | $162,870 | $651,479 | 1.92% |
| Wrong tariff (572 data lines) | $105,748 | $422,993 | 1.25% |
| Missed recurring charge (439 customer months) | $40,525 | $162,100 | 0.48% |
| **Total** | **$309,143** | **$1,236,572** | **3.64%** |

Annualized equals the quarter times 4.

## Conclusion

About **$1.2M a year** of sample revenue was leaking, and most of it came from usage that never reached an invoice and from an old data tariff still loaded in billing. Fixing the rate table and adding a monthly usage to billing check would recover most of it. These queries can run each month as a standing control.

## Stack

SQL (SQLite), Python standard library.
