{% set payment_methods_query %}
    select distinct payment_method
    from {{ ref('raw_payments') }}
    order by payment_method
{% endset %}

{% set payment_methods_result = run_query(payment_methods_query) %}
{% if execute %}
    {% set payment_methods = payment_methods_result.columns[0].values() %}
{% else %}
    {% set payment_methods = [] %}
{% endif %}

select
    order_id,
    {% for payment_method in payment_methods %}
        sum(
            case
                when payment_method = '{{ payment_method }}' then amount end
            ) as {{ payment_method }}_amount, -- {% if not loop.last %},{% endif %}{% endfor %}
    sum(amount) as total_amount
from {{ ref('raw_payments') }}
group by 1