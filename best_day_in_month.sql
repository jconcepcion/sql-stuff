-- Using SNOWFLAKE_SAMPLE_DATE.TPCH_SF1

with 
daily_sales as
(
select date_trunc(month, O_ORDERDATE) as sales_month, O_ORDERDATE, sum(o_totalprice) as tot from orders 
group by 1,2
),
monthly_ranking as (
select *, row_number() over (partition by sales_month order by tot desc) as sales_rank from daily_sales
--order by 1,4
)
select * from monthly_ranking where sales_rank = 1
order by 1,4;
