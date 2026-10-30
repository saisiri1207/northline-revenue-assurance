"""Generate sample Northline Telecom usage and billing data (fictional data)."""
import csv, random
random.seed(7)
plans = [("BIZ-BASIC", 45.0, 0.08, 9.0), ("BIZ-PLUS", 85.0, 0.06, 7.5), ("BIZ-PRO", 140.0, 0.05, 6.0)]  # plan, monthly fee, rate per min, rate per GB
months = ["2026-04", "2026-05", "2026-06"]
cust, usage, bill = [], [], []
for c in range(1, 4401):
    p = random.choice(plans)
    cust.append([f"C{c:05d}", p[0], random.choice(["Northeast", "Midwest", "South", "West"])])
uid = bid = 1
for m in months:
    for cid, plan, _ in cust:
        p = next(x for x in plans if x[0] == plan)
        mins = random.randint(200, 2500); gb = round(random.uniform(5, 120), 1)
        for svc, qty, rate in [("VOICE_MIN", mins, p[2]), ("DATA_GB", gb, p[3])]:
            usage.append([f"U{uid:06d}", cid, m, svc, qty]); uid += 1
            r = random.random()
            if r < 0.025:   # unbilled usage
                continue
            billed_rate = rate
            if r < 0.07 and svc == "DATA_GB":  # wrong (old) tariff loaded
                billed_rate = round(rate * 0.6, 2)
            bill.append([f"BL{bid:06d}", cid, m, svc, qty, billed_rate, round(qty * billed_rate, 2)]); bid += 1
        if random.random() > 0.03:  # missed recurring charge 3% of the time
            bill.append([f"BL{bid:06d}", cid, m, "MRC", 1, p[1], p[1]]); bid += 1
def w(fn, hdr, rows):
    with open(fn, "w", newline="") as f:
        x = csv.writer(f); x.writerow(hdr); x.writerows(rows)
w("data/customers.csv", ["customer_id", "plan_code", "region"], cust)
w("data/rate_plans.csv", ["plan_code", "monthly_fee", "rate_per_min", "rate_per_gb"], plans)
w("data/usage_records.csv", ["usage_id", "customer_id", "month", "service", "quantity"], usage)
w("data/billing_lines.csv", ["bill_line_id", "customer_id", "month", "service", "quantity", "billed_rate", "billed_amount"], bill)
print(len(usage), "usage rows,", len(bill), "billing rows")
