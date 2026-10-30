-- Leakage by type for Apr to Jun 2026, plus annualized (quarter x 4) and share of expected revenue.
WITH lk AS (
  SELECT 'Unbilled usage' AS leakage_type, SUM(e.expected_amount) AS amt
  FROM expected_charges e LEFT JOIN billing_lines b ON b.customer_id = e.customer_id AND b.month = e.month AND b.service = e.service
  WHERE b.bill_line_id IS NULL
  UNION ALL
  SELECT 'Wrong tariff', SUM(e.expected_amount - b.billed_amount)
  FROM expected_charges e JOIN billing_lines b ON b.customer_id = e.customer_id AND b.month = e.month AND b.service = e.service
  WHERE b.billed_rate < e.plan_rate
  UNION ALL
  SELECT 'Missed recurring charge', SUM(r.monthly_fee)
  FROM (SELECT DISTINCT customer_id, month FROM usage_records) a JOIN customers c USING (customer_id) JOIN rate_plans r USING (plan_code)
  WHERE NOT EXISTS (SELECT 1 FROM billing_lines b WHERE b.customer_id = a.customer_id AND b.month = a.month AND b.service = 'MRC')),
exp AS (SELECT (SELECT SUM(expected_amount) FROM expected_charges)
             + (SELECT SUM(r.monthly_fee) FROM (SELECT DISTINCT customer_id, month FROM usage_records) a JOIN customers USING (customer_id) JOIN rate_plans r USING (plan_code)) AS total)
SELECT leakage_type, ROUND(amt, 0) AS quarter_leakage, ROUND(amt * 4, 0) AS annualized,
       ROUND(100.0 * amt / (SELECT total FROM exp), 2) AS pct_of_expected
FROM lk UNION ALL
SELECT 'Total', ROUND(SUM(amt), 0), ROUND(SUM(amt) * 4, 0), ROUND(100.0 * SUM(amt) / (SELECT total FROM exp), 2) FROM lk;
