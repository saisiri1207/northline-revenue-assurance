-- Usage with no billing line for the same customer, month and service.
SELECT e.service, COUNT(*) AS records, ROUND(SUM(e.expected_amount), 2) AS leakage
FROM expected_charges e LEFT JOIN billing_lines b
  ON b.customer_id = e.customer_id AND b.month = e.month AND b.service = e.service
WHERE b.bill_line_id IS NULL GROUP BY e.service;
