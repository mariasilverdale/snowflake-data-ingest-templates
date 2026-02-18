USE DATABASE INGEST_DB;

-- Review last COPY results in this session
SELECT * FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));

-- Basic raw validation
SELECT COUNT(*) AS raw_rows FROM RAW.CUSTOMERS_RAW;

-- Null checks example
SELECT
  SUM(IFF(CUSTOMER_ID IS NULL, 1, 0)) AS null_customer_id,
  SUM(IFF(EMAIL IS NULL, 1, 0))       AS null_email
FROM RAW.CUSTOMERS_RAW;
