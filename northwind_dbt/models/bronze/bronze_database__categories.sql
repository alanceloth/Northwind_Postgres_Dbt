{{ config(
    materialized='table',
    schema='bronze'
) }}

SELECT * FROM categories
