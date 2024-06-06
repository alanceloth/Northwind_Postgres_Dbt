{{ config(
    materialized='table',
    schema='bronze'
) }}

SELECT * FROM us_states
