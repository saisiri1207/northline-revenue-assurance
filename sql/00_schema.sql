CREATE TABLE customers (customer_id TEXT PRIMARY KEY, plan_code TEXT, region TEXT);
CREATE TABLE rate_plans (plan_code TEXT PRIMARY KEY, monthly_fee REAL, rate_per_min REAL, rate_per_gb REAL);
CREATE TABLE usage_records (usage_id TEXT PRIMARY KEY, customer_id TEXT, month TEXT, service TEXT, quantity REAL);
CREATE TABLE billing_lines (bill_line_id TEXT PRIMARY KEY, customer_id TEXT, month TEXT, service TEXT, quantity REAL, billed_rate REAL, billed_amount REAL);
CREATE VIEW expected_charges AS
SELECT u.customer_id, u.month, u.service, u.quantity,
       CASE u.service WHEN 'VOICE_MIN' THEN r.rate_per_min ELSE r.rate_per_gb END AS plan_rate,
       ROUND(u.quantity * CASE u.service WHEN 'VOICE_MIN' THEN r.rate_per_min ELSE r.rate_per_gb END, 2) AS expected_amount
FROM usage_records u JOIN customers c USING (customer_id) JOIN rate_plans r USING (plan_code);
CREATE INDEX ix_bill ON billing_lines (customer_id, month, service);
CREATE INDEX ix_usage ON usage_records (customer_id, month);
