/****** Script for SelectTopNRows command from SSMS  ******/


--Check the product name count, then join product table with the translation table add the product English name
SELECT count(distinct [product_category_name])
FROM [Olist].[dbo].[dim_products]
WHERE [product_category_name] is not null;

Use Olist
SELECT count(distinct [product_category_name])
FROM product_category_name_translation
WHERE [product_category_name] is not null;

--Get the first dim table for products & export to csv:
SELECT * FROM dim_products dp
LEFT JOIN product_category_name_translation pt
ON dp.product_category_name = pt.product_category_name;


go

--Let's joini orders dataset & order items dataset as the order details data:
SELECT f.[order_id]
      ,[customer_id]
      ,[order_status]
      ,[order_purchase_timestamp]
      ,[order_delivered_customer_date]
	  ,[order_item_id]
      ,[product_id]
      ,[seller_id]
      ,[shipping_limit_date]
      ,[price]
      ,[freight_value]
  FROM [Olist].[dbo].[fact_orders] f
  LEFT JOIN [Olist].[dbo].[order_items] i
  ON f.order_id = i.order_id
  go

  --Join this data with order payment & export it as fact_order table :
  SELECT f.[order_id]
      ,[customer_id]
      ,[order_status]
      ,[order_purchase_timestamp]
	  ,CAST([order_purchase_timestamp] AS date) as order_date
	  ,YEAR([order_purchase_timestamp]) as order_year
	  ,MONTH([order_purchase_timestamp]) as order_month
	  ,FORMAT([order_purchase_timestamp], 'yyyy-MM') as order_monthYr
      ,[order_delivered_customer_date]
	  ,CAST([order_delivered_customer_date] AS date) as delivered_date
	  ,[order_item_id]
      ,[product_id]
      ,[seller_id]
      ,[shipping_limit_date]
      ,[price]
      ,[freight_value]
	  ,p.*
  FROM [Olist].[dbo].[fact_orders] f
  LEFT JOIN fact_order_payments p
  ON f.order_id = p.order_id
  LEFT JOIN [Olist].[dbo].[order_items] i
  ON f.order_id = i.order_id
  go

  --Lets analyze the the relation between order price & payment
  SELECT f.[order_id]
      ,[order_status]
      ,[order_purchase_timestamp]
      ,[order_delivered_customer_date]
      ,sum([price]+[freight_value]) as order_value
	  ,sum(payment_value) as payment
  FROM [Olist].[dbo].[fact_orders] f
  LEFT JOIN fact_order_payments p
  ON f.order_id = p.order_id
  LEFT JOIN [Olist].[dbo].[order_items] i
  ON f.order_id = i.order_id
  --WHERE order_status != 'delivered'
  GROUP BY f.order_id,[order_status],[order_purchase_timestamp],[order_delivered_customer_date]
  --HAVING sum([price]+[freight_value]) != sum(payment_value)

  --We can see the payment value is sometimes not equal to the order value, payment value is our sales revenue index


  GO

  USE Olist
  SELECT COUNT (DISTINCT customer_id),
         COUNT (DISTINCT customer_unique_id) 
  FROM dim_customer

  GO

  SELECT * FROM fact_order_reviews

  SELECT * FROM dim_sellers

  SELECT COUNT (DISTINCT product_category_name) FROM dim_products
  --73

  GO

