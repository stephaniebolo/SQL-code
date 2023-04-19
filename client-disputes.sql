

--importing data

CREATE TABLE yellevate_invoices (
	country varchar,
	customer_id varchar,
	invoice_number numeric,
	invoice_date date,
	due_date date,
	invoice_amount_usd numeric,
	disputed numeric ,
	dispute_lost numeric,
	settled_date date,
	days_settled integer,
	days_late integer 
);



-- processing time in which invoices are settled

SELECT ROUND (AVG(days_settled)) AS ave_days_settled 
FROM yellevate_invoices



--processing time for the company to settle disputes 

SELECT ROUND (AVG(days_to_settle)) AS ave_days_settled
FROM yellevate_invoices
WHERE disputed = 1



--percentage of disputes received by the company that were lost 

SELECT ROUND ((SELECT SUM(dispute_lost) FROM yellevate_invoices WHERE dispute_lost = 1) / 
(SELECT SUM(disputed) FROM yellevate_invoices WHERE disputed =1 ) * 100 , 2) AS percent_dispute_lost



--percentage of revenue lost from disputes 

SELECT ROUND ((SELECT SUM(invoice_amount_usd) 
FROM yellevate_invoices WHERE dispute_lost = 1) 
/ (SELECT SUM(invoice_amount_usd) FROM yellevate_invoices)*100 , 2) AS percent_revenue_lost



--country where the company reached the highest losses from lost disputes (in USD)

SELECT DISTINCT country, SUM (invoice_amount_usd) AS highestloss_fromdisputes
FROM yellevate_invoices
WHERE dispute_lost = 1
GROUP BY country
ORDER BY SUM (invoice_amount_usd) DESC
