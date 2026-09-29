# **MATERIALIZATIONS**

Materializations are strategies for persisting dbt models in a warehouse.

There are five types of materializations built into dbt:
* Table
* View
* Incremental
* Ephemeral
* Materialized Viewa

## **MATERIALIZATIONS**
### **TABLE MATERIALIZATIONS**

When using the table materialization, your model is rebuilt as a table on each run, via a creata table statement.

```python
{{
    config(
        materialized='table'
    )
}}
```

### **VIEW MATERIALIZATIONS**

When using view materialization, your model is rebuilt as a view on each run, via a create view as statement.

```python
{{
    config(
        materialized='view'
    )
}}
```

### **INCREMENTAL MATERIALIZATIONS**

Incremental models allow dbt to insert or update records into a table since the last time that model was run.

```python
{{
    config(
        materialized='incremental'
    )
}}
```

# **TEMPLATING USING JINJA**

Using Jinja you can turn your dbt project into a programming environment for SQL, giving tou the ability to do things that aren't normally possible in SQL.

**Things you can do:**
* IF and ELSE statements
* Loops
* Set varaibles
* Write reusable functions

```jinja
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
            ) as {{ payment_method }}_amount{% if not loop.last %},{% endif %}
    {% endfor %}
    sum(amount) as total_amount
from {{ ref('raw_payments') }}
group by 1
```

# **MACROS IN DBT**

In short, dbt macros are reusable blocks of Jinja code that enable you to encapsulate and resude complex logic or SQL snippets within your dbt models or transformations

Think macros as functions in programming language term