USE DATABASE INGEST_DB;

-- Option A: Internal stage (easiest for demos/interviews)
CREATE OR REPLACE STAGE OPS.STG_INTERNAL
  FILE_FORMAT = OPS.FF_CSV_STD;

-- Upload example (run from SnowSQL/SnowCLI locally):
-- PUT file://C:\data\customers.csv @INGEST_DB.OPS.STG_INTERNAL AUTO_COMPRESS=TRUE;

-- Option B (commented): External stage (S3/Azure/GCS) needs integration
-- CREATE OR REPLACE STAGE OPS.STG_S3
--   URL='s3://your-bucket/path/'
--   STORAGE_INTEGRATION = your_integration
--   FILE_FORMAT = OPS.FF_CSV_STD;
