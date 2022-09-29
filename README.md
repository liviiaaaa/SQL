# SQL
This SQL code is written in SQL Server Management Studio. It contains the creation of tables, functions, stored procedures for working with the database, 
as well as the creation of Data Warehouse, dimensions, analysis and more.

This code was written by me during my internship at Softserve Academy from 01.07.2022 to 27.09.2022. 
Looking at this code, you can see that there is no complete code for creating all the tables in the database, filling them and so on. 
You should understand that we worked on this project as a team and everyone did their part.
Therefore, here I show only my part of the work on creating a database, tables, filling it and writing stored procedures, functions, etc. 
Here is almost everything I did during my internship and everything I learned by doing real tasks.
Besides functions and stored procedures, I also created several reports for DW and created ABC analysis and Cohort analysis. 
ABC analysis I also implemented in SQL Server Reporting Services and Cohort Analysis I visualized in Power BI.

This database was created for an online electronics store. 
The database contains 23 tables with different types of relationships both one to many and many to many.
Our store has warehouses in different cities of Ukraine and offers several types of delivery in Ukraine.
I have created the following tables: Clients, ClientsDiscount, Comments, Manufacturers, PaymentType, ExceptionTbl, DiscountSettings and two additional tables RateSettings and YearSettings, which I used in the views.
In the ClientsDiscount table I add only customers who have a discount and the amount of their discount.
I created the following rule for customers with discount. This rule says that if the amount of the customer's order is more than 2000 UAH, then the customer gets a discount for the next orders, and the larger the order amount, the greater the discount. Information about what discount is provided according to the order amount is stored in the table DiscountSettings.
