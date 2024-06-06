{{ config(
    materialized='table',
    schema='bronze'
) }}

SELECT * FROM orders
