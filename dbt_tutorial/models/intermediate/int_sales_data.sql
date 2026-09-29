{{
    config(
        materialized='table',
    )
}}
with total_sales as (
select
id,
sum(amount) as total_sales
from {{ source('sales_raw', 'raw_payments') }}
group by id
)
select
    id,
    total_sales,
    case
        when total_sales >= {{ var('sales_expectation') }} then 'met'
        else 'not met'
    end as sales_expectation_status
from total_sales