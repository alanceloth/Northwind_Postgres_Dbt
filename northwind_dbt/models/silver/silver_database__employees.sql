{{ config(
    materialized='table',
    schema='silver'
) }}

WITH cleaned_addresses AS (
    SELECT 
        *,
        REPLACE(address, E'\n', ' ') AS cleaned_address
    FROM 
        public_bronze.bronze_database__employees
),

extracted_numbers AS (
    SELECT
        *,
        (SELECT (REGEXP_MATCHES(cleaned_address, '^(\d+)\s*-?\s*'))[1]) AS number
    FROM
        cleaned_addresses
),

extracted_street_apartment AS (
    SELECT
        en.*,
        (SELECT (REGEXP_MATCHES(en.cleaned_address, '^\d+\s*-?\s*(.+?)(?:\s+Apt\.?\s*(.+))?$'))[1]) AS street,
        (SELECT (REGEXP_MATCHES(en.cleaned_address, '^\d+\s*-?\s*(.+?)(?:\s+Apt\.?\s*(.+))?$'))[2]) AS apartment
    FROM
        extracted_numbers en
),

final_addresses AS (
    SELECT
        esa.*,
        COALESCE(esa.number, (SELECT (REGEXP_MATCHES(esa.cleaned_address, '^(\d+)\s+'))[1])) AS final_number,
        COALESCE(esa.street, (SELECT (REGEXP_MATCHES(esa.cleaned_address, '^\d+\s+(.+)$'))[1])) AS final_street
    FROM
        extracted_street_apartment esa
)

SELECT
    employee_id, 
    last_name, 
    first_name, 
    title, 
    title_of_courtesy, 
    birth_date, 
    hire_date, 
    address,
    final_number AS number,
    final_street AS street,
    city, 
    region, 
    postal_code, 
    country, 
    home_phone, 
    extension, 
    photo, 
    notes, 
    reports_to, 
    photo_path
FROM
    final_addresses
