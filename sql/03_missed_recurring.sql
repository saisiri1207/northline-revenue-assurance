-- Active customers with usage in a month but no monthly recurring charge.
SELECT COUNT(*) AS customer_months, ROUND(SUM(r.monthly_fee), 2) AS leakage
FROM (SELECT DISTINCT customer_id, month FROM usage_records) a
JOIN customers c USING (customer_id) JOIN rate_plans r USING (plan_code)
WHERE NOT EXISTS (SELECT 1 FROM billing_lines b WHERE b.customer_id = a.customer_id AND b.month = a.month AND b.service = 'MRC');
