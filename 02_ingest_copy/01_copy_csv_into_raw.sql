USE DATABASE INGEST_DB;

-- Set these values per run
SET PIPELINE_NAME = 'customers_csv_ingest';
SET LOAD_ID = UUID_STRING();

-- Start log
INSERT INTO OPS.LOAD_LOG (LOAD_ID, PIPELINE_NAME, SOURCE_STAGE, TARGET_TABLE, START_TS, STATUS)
SELECT $LOAD_ID, $PIPELINE_NAME, 'OPS.STG_INTERNAL', 'RAW.CUSTOMERS_RAW', CURRENT_TIMESTAMP(), 'RUNNING';

-- COPY into RAW table from internal stage
COPY INTO RAW.CUSTOMERS_RAW (
  LOAD_ID, FILE_NAME, ROW_NUMBER_IN_FILE, INGEST_TS,
  CUSTOMER_ID, FULL_NAME, EMAIL, CITY
)
FROM (
  SELECT
    $LOAD_ID                                    AS LOAD_ID,
    METADATA$FILENAME                           AS FILE_NAME,
    METADATA$FILE_ROW_NUMBER                    AS ROW_NUMBER_IN_FILE,
    CURRENT_TIMESTAMP()                         AS INGEST_TS,
    $1::STRING                                  AS CUSTOMER_ID,
    $2::STRING                                  AS FULL_NAME,
    $3::STRING                                  AS EMAIL,
    $4::STRING                                  AS CITY
  FROM @OPS.STG_INTERNAL
)
FILE_FORMAT = (FORMAT_NAME = OPS.FF_CSV_STD)
ON_ERROR = 'CONTINUE';  -- keep going; errors can be inspected

-- Capture copy history row count (last copy statement)
-- This returns rows loaded per file for the COPY that just ran
SET ROWS_LOADED = (
  SELECT COALESCE(SUM(rows_loaded),0)
  FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()))
);

-- End log
UPDATE OPS.LOAD_LOG
SET END_TS = CURRENT_TIMESTAMP(),
    STATUS = 'SUCCESS',
    ROWS_LOADED = $ROWS_LOADED
WHERE LOAD_ID = $LOAD_ID;
