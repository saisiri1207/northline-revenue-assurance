-- Billed below the customer's plan rate.
SELECT e.service, COUNT(*) AS lines, ROUND(SUM(e.expected_amount - b.billed_amount), 2) AS leakage
FROM expected_charges e JOIN billing_lines b
  ON b.customer_id = e.customer_id AND b.month = e.month AND b.service = e.service
WHERE b.billed_rate < e.plan_rate GROUP BY e.service;
