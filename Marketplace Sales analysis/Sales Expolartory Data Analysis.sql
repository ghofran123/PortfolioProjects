
/* EXPLORATORY DATA ANALYSIS */

	/* Total Sales, Total Units, Average Order Value */

Select 
		Count(distinct(TRANSACTION_ID)) as Total_orders,
		Sum(Units_Sold) as Total_units,
		Round(Sum(Total_Revenue),2) as Total_revenue,
		Round(Sum(Total_Revenue)/Count(distinct(TRANSACTION_ID)),2) as Avg_Order_revenue
from [Online Sales Data];

	/* Monthly Sales Trend */

select 
		Format(Date,'yyyy-MM') as Year_Month,
		Round(SUM(Total_Revenue),2) as Total_revenue,
		Sum(Units_Sold) as Total_units
from [Online Sales Data]
group by Format(Date,'yyyy-MM')
order by Year_Month asc;
		
	/* Top Products and Categories */
		/* TOP 10 Performing products*/

select TOP 10
		Product_name,
		Round(SUM(Total_Revenue),2) as Total_sales,
		Sum(Units_Sold) as Total_units		
from [Online Sales Data]
group by Product_Name
order by  Total_sales Desc ;

	/* TOP 10 Performing Categories*/

select TOP 10
		Product_Category,
		Round(SUM(Total_Revenue),2) as Total_sales,
		Sum(Units_Sold) as Total_units		
from [Online Sales Data]
group by Product_Category
order by  Total_sales Desc ;

	/*Sales by Region*/

select 
	Region,
	Round(Sum(Total_Revenue),2) as Total_Sales,
	Sum(Units_Sold) as Total_units
from [Online Sales Data]
group by Region
order by Total_Sales desc;

	/*Month-over-Month (MoM) Growth*/

with Monthly_sales as(
	select 
			FORMAT(date,'yyyy-MM') as Year_Month,
			Round(sum(Total_Revenue),2) as Total_sales
	from [Online Sales Data]
	Group By FORMAT(date,'yyyy-MM')
	)
select 
		Year_Month,
		Total_sales,
		Round((Total_sales-lag(Total_sales,1,0) over (order by Year_Month))*100.0/
		NULLIF(lag(Total_sales)over (order by Year_Month),0),2) 
		as Growth_Percentage 
from Monthly_sales;

	/*Product Performance Trends (Seasonal)*/

select 
		Year(date) as Year,
		Month(date) as Month,
		Round(sum(Total_Revenue),2) as Total_Sales,
		Product_name
from [Online Sales Data]
group by Year(date),Month(date),Product_name
order by Year,Month,Product_name;

	/*Correlation Between Units Sold and Revenue*/

select
		Round(CORR(Units_Sold,Total_revenue),2) as units_revenue_correlation
from [Online Sales Data];

	/*Payment Method Trends*/

select 
		Count(transaction_ID) as Number_Of_Transactions,
		Round(Sum(Total_revenue),2) as Total_Revenue,
		Payment_Method
from [Online Sales Data]
group by Payment_Method
order by Total_Revenue desc;

	/*Payment Method Trends by Region*/

select 
		Count(transaction_ID)as Number_Of_Transactions,
		Round(Sum(total_Revenue),2) as Total_Revenue,
		Region,
		Payment_Method
from [Online Sales Data]
group by Region,payment_Method
order by Total_Revenue desc;