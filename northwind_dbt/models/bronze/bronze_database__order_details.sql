{{ config(
    materialized='table',
    schema='bronze'
) }}

SELECT * FROM order_details
