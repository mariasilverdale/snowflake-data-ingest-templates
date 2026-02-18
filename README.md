# Snowflake Data Ingest Templates

Practical templates for ingesting files into Snowflake:
- External/internal stages
- File formats (CSV/JSON)
- COPY INTO patterns (with validation)
- RAW -> CURATED merge/upsert
- Load logging + error capture
- Optional scheduled task

## Run order
1) 00_setup/00_db_schema.sql
2) 00_setup/01_file_formats.sql
3) 00_setup/02_stages.sql
4) 01_raw_tables/00_create_raw_tables.sql
5) 02_ingest_copy/01_copy_csv_into_raw.sql (or JSON)
6) 03_transform_merge/01_create_curated_tables.sql
7) 03_transform_merge/02_merge_upsert.sql
8) (Optional) 04_automation/01_task_schedule.sql# snowflake-data-ingest-templates
