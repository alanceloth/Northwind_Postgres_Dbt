{{ config(
    materialized='table',
    schema='silver'
) }}

WITH cleaned_addresses AS (
    SELECT 
        *,
        REPLACE(address, '\n', ' ') AS cleaned_address
    FROM 
        bronze.bronze_database__employees
),

split_addresses AS (
    SELECT
        *,
        REGEXP_EXTRACT(cleaned_address, r'(\d+)\s*-\s*(.+?)(?:,\s*(.+))?$', 1) AS number,
        REGEXP_EXTRACT(cleaned_address, r'(\d+)\s*-\s*(.+?)(?:,\s*(.+))?$', 2) AS street,
        REGEXP_EXTRACT(cleaned_address, r'(\d+)\s*-\s*(.+?)(?:,\s*(.+))?$', 3) AS apartment
    FROM
        cleaned_addresses
),

final_addresses AS (
    SELECT
        *,
        CASE 
            WHEN number IS NULL THEN REGEXP_EXTRACT(cleaned_address, r'(\d+)\s*(.+)', 1)
            ELSE number
        END AS number,
        CASE 
            WHEN street IS NULL THEN REGEXP_EXTRACT(cleaned_address, r'(\d+)\s*(.+)', 2)
            ELSE street
        END AS street,
        apartment
    FROM
        split_addresses
)

SELECT
    *,
    number,
    street,
    apartment
FROM
    final_addresses
