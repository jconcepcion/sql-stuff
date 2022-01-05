-- Using SNOWFLAKE_SAMPLE_DATE.TPCH_SF1

-- Method using a window function
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


-- Method using join
with 
daily_sales as
(
select date_trunc(month, O_ORDERDATE) as sales_month, O_ORDERDATE, sum(o_totalprice) as tot from orders 
group by 1,2
),
maxb as
(
select sales_month, max(tot) as maxtot from daily_sales group by 1
)
--select * from maxb
select a.* from daily_sales a
join maxb b on a.tot = b.maxtot and a.sales_month = b.sales_month
order by 1,2
;
