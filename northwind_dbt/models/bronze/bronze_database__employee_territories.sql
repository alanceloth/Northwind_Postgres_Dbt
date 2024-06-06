{{ config(
    materialized='table',
    schema='bronze'
) }}

SELECT * FROM employee_territories
