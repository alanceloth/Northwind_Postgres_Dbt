{{ config(
    materialized='table',
    schema='bronze'
) }}

SELECT * FROM customer_demographics
