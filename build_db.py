"""Load the CSVs into northline_ra.db (SQLite, standard library only)."""
import csv, sqlite3, os
if os.path.exists("northline_ra.db"): os.remove("northline_ra.db")
con = sqlite3.connect("northline_ra.db")
con.executescript(open("sql/00_schema.sql").read())
for t, fn in [("customers","data/customers.csv"),("rate_plans","data/rate_plans.csv"),("usage_records","data/usage_records.csv"),("billing_lines","data/billing_lines.csv")]:
    rows = list(csv.reader(open(fn)))
    con.executemany(f"INSERT INTO {t} VALUES ({','.join('?'*len(rows[0]))})", rows[1:])
con.commit(); print("Loaded northline_ra.db")
