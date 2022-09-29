/*-------------------------------------------------------------------------
	THIS PART OF CODE FILLS ExceptionsTbl TABLE WITH EXCEPTION MESSAGES
		THAT MAY OCCUR IN OUR STORED PROCEDURES USING CTE
----------------------------------------------------------------------------
*/
WITH cte_ExceptionsTbl AS (
	SELECT * FROM (
		VALUES (1, 'City with this ID does not exist.'),
			   (2, 'Warehouse with this ID does not exist.'),
			   (3, 'Product with this ID does not exist.'),
			   (4, 'Client with this email already exists.'),
			   (5, 'Client with this phone number already exists.'),
			   (6, 'Parameters should not be null.'),
			   (7, 'Parameter should not be null.'),
			   (8, 'Client with this ID doesn''t exists.'),
			   (9, 'This manufacturer already exists.'),
			   (10, 'This payment type already exists'),
			   (11, 'ClientID, ProductID and Rate should not be null'),
			   (12, 'Cannot Update: such record doesn''t exist'),
			   (13, 'Cannot Insert: such record already exists'),
			   (14, 'Number of repetition should be integer and not less than 1'),
			   (15, 'You entered wrong value of Manager ID'),
			   (16, 'You entered wrong value of OrderID'),
			   (17, 'Value of OrderID can not be NULL and must be integer type. Please, change it'),
			   (18, 'You did not fill all requested parameters of procedure. Please, check them: ClientID, ManagerID, OrderDate, CityID, StatusID,PaymentTypeID,Total_sum,DeliveryID'),
			   (19, 'Value of SSN can not be NULL and must contain 10 symbols. Please, change it'),
			   (20, 'You did not fill all requested parameters of procedure. Please, check them: FirstName, LastName, BirthDate, HiredDate'),
			   (21, 'You entered wrong value of product Quantity. It should be integer, grater than 0 and must be available in such range'),
			   (22, 'Manufacturer with this ID does not exists.'),
			   (23, 'Payment Type with this ID does not exists.'),
			   (24, 'Comment with this ID does not exists.'),
			   (25, 'You have to indicate CompanyName'),
			   (26, 'You should enter value of Quantity'),
			   (27, 'No discount.'),
			   (28, 'Both values, WarehouseID and ProductID, must be not NULL'),
			   (29, 'Category with such ID doesn''t exist.'),
			   (30, 'This record already exists.'),
		       (31, 'DeliveryType with such ID doesn''t exist.'),
			   (32, 'OrderStatus with such ID doesn''t exist.'),
			   (33, 'Please, correctly specify OrderID and ProductID'),
			   (34, 'Wrong parameter type.'),
			   (35,	'No such products in warehouses')
		) AS x (ID, ExceptionMessage) 
) 
MERGE dbo.ExceptionsTbl AS t     
	USING cte_ExceptionsTbl AS s ON s.ID = t.ID 
WHEN MATCHED and s.ExceptionMessage <> t.ExceptionMessage     
	THEN UPDATE SET t.ExceptionMessage = s.ExceptionMessage 
WHEN NOT MATCHED BY TARGET     
	THEN INSERT (ExceptionMessage)          
		VALUES (s.ExceptionMessage); 

----------------------CREATING BACKUP FOR TABLE----------------------------------------------------
IF OBJECT_ID ('dbo.ExceptionsTbl_bkp') IS NULL
	SELECT * INTO dbo.ExceptionsTbl_bkp FROM dbo.ExceptionsTbl
GO

-----------------------------------------------------------------------------------------------------
/*		FILLING DiscountSettings TABLE WITH MIN AND MAX SUM OF ORDER 
		AND DISCOUNT OFFERED FOR THIS SUM USING CTE*/

WITH cte_DiscountSettings AS (
	SELECT * FROM (
		VALUES (1, 2000, 3000, 0.05),
			(2, 3100, 5000, 0.10),
			(3, 5100, 15000, 0.15),
			(4, 15100, 999000, 0.20)
		) AS x (ID, StartSum, EndSum, Discount)
)
MERGE dbo.DiscountSettings AS t     
	USING cte_DiscountSettings AS s ON s.ID = t.ID 
WHEN MATCHED and s.StartSum <> t.StartSum OR s.EndSum <> t.EndSum OR s.Discount <> t.Discount 
	THEN UPDATE SET t.StartSum = s.StartSum, t.EndSum = s.EndSum, t.Discount = s.Discount
WHEN NOT MATCHED BY TARGET     
	THEN INSERT (StartSum, EndSum, Discount)          
		VALUES (s.StartSum, s.EndSum, s.Discount); 
GO

----------------------CREATING BACKUP FOR TABLE----------------------------------------------------
IF OBJECT_ID ('dbo.DiscountSettings_bkp') IS NULL
	SELECT * INTO dbo.DiscountSettings_bkp FROM dbo.ExceptionsTbl
GO

-----------------------------------------------------------------------------------------------------
------------------------FILLING PaymentType TABLE USING CTE------------------------------------------

WITH cte_PaymentType AS (
	SELECT * FROM (
		VALUES (1, 'MasterCard/Visa on site'),
			   (2, 'PayPal'),
			   (3, 'Payment upon receipt')
		) AS x (PaymentTypeID, PaymentTypeName) 
) 
MERGE dbo.PaymentType AS t     
	USING cte_PaymentType AS s ON s.PaymentTypeID = t.PaymentTypeID 
WHEN MATCHED and s.PaymentTypeName <> t.PaymentTypeName     
	THEN UPDATE SET t.PaymentTypeName = s.PaymentTypeName 
WHEN NOT MATCHED BY TARGET     
	THEN INSERT (PaymentTypeName)          
		VALUES (s.PaymentTypeName); 		 

----------------------CREATING BACKUP FOR TABLE----------------------------------------------------
IF OBJECT_ID ('dbo.PaymentType_bkp') IS NULL
	SELECT * INTO dbo.PaymentType_bkp FROM dbo.PaymentType
GO

-----------------------------------------------------------------------------------------------------
-----------FILLING Clients TABLE WITH ALL INFORMATION ABOUT CLIENTS USING CTE-------------------------

WITH cte_Clients AS (
	SELECT * FROM (
		VALUES (1, 'Mariia', 'Lisovska', '+380933575436', 'mlisovska@gmail.com'), 
			   (2, 'Yevhen', 'Kravtsov', '+380674475856', 'yekravts@gmail.com'), 			   
			   (3, 'Volodymyr', 'Tarasenko', '+380638564475', 'tarasenkov@gmail.com'), 			   
			   (4, 'Maksym', 'Ovtsinov', '+380978564453', 'ovtsmaks@gmail.com'), 			   
			   (5, 'Anna', 'Savkiv', '+380668532234', 'savkiva@gmail.com'), 			   
			   (6, 'Anton', 'Zorin', '+380671734256', 'antonzorro@gmail.com'), 			   
			   (7, 'Andriy', 'Melnyk', '+380932811175', 'melnykandrey@ukr.net'), 			   
			   (8, 'Serhiy', 'Koshelenko', '+380953564425', 'serhiyko123@gmail.com'), 			   
			   (9, 'Bozhena', 'Vlasova', '+380971833318', 'bozhena2901@gmail.com'), 			   
			   (10, 'Oleksii', 'Novak', '+380989634756', 'novakol01@gmail.com'), 			   
			   (11, 'Olha', 'Polishchuk', '+380661844275', 'polishchuk333@gmail.com'), 			   
			   (12, 'Oleksandr', 'Korotynskiy', '+380508531248', 'alex130600@gmail.com'), 			   
			   (13, 'Bohdan', 'Pastuhov', '+380501238815', 'bohdanpas@gmail.com'), 			   
			   (14, 'Alina', 'Fedchenko', '+380938761175', 'fedchalina@gmail.com'), 			   
			   (15, 'Stepan', 'Homenko', '+380953684231', 'stepan2701@gmail.com')) 
		AS x (ClientID, FirstName, LastName, PhoneNumber, Email) ) 
MERGE dbo.Clients AS t     
	USING cte_Clients AS s ON s.ClientID= t.ClientID 
WHEN MATCHED and s.FirstName <> t.FirstName OR s.LastName <> t.LastName OR s.PhoneNumber <> t.PhoneNumber
	OR s.Email <> t.Email     
	THEN UPDATE SET t.FirstName = s.FirstName, t.LastName = s.LastName, t.PhoneNumber = s.PhoneNumber, 
	t.Email = s.Email
WHEN NOT MATCHED BY TARGET
	THEN INSERT (FirstName, LastName, PhoneNumber, Email)          
		VALUES (s.FirstName, s.LastName, s.PhoneNumber, s.Email); 

----------------------CREATING BACKUP FOR TABLE----------------------------------------------------
IF OBJECT_ID ('dbo.Clients_bkp') IS NULL
	SELECT * INTO dbo.Clients_bkp FROM dbo.Clients
GO

------------------------------------------------------------------------------------------------------
--FILLING ClientsDiscount TABLE WITH ID OF CLIENT THAT HAS A DISCOUNT AND HIS DISCOUNT USING CTE

WITH cte_ClientsDiscount AS (
	SELECT * FROM (
		VALUES (1, 0.15), 			   
			   (3, 0.05), 			    			   
			   (6, 0.02), 			   
			   (7, 0.12), 			   			   
			   (9, 0.07), 			   			   
			   (12, 0.15), 			   
			   (13, 0.05)) 
		as x (ClientID, Discount) ) 
MERGE dbo.ClientsDiscount AS t     
	USING cte_ClientsDiscount AS s ON s.ClientID= t.ClientID 
WHEN MATCHED and s.Discount <> t.Discount     
	THEN UPDATE SET t.Discount = s.Discount
WHEN NOT MATCHED BY TARGET
	THEN INSERT (ClientID, Discount)          
		VALUES (s.ClientID, s.Discount)
WHEN NOT MATCHED BY SOURCE
	THEN DELETE;

----------------------CREATING BACKUP FOR TABLE----------------------------------------------------
IF object_id ('dbo.ClientsDiscount_bkp') IS NULL
	SELECT * INTO dbo.ClientsDiscount_bkp FROM dbo.Clients
GO

------------------------------------------------------------------------------------------------------
----FILLING Manufacturers TABLE WITH ID, NAME OF THE COMPANY AND COUNTRY OF MANUFACTURER USING CTE----

WITH cte_Manufacturers AS (
    SELECT * FROM (
        VALUES (1, 'BOSCH', 'Germany'),
               (2, 'Tefal', 'France'),
			   (3, 'Toshiba', 'Japan'),
			   (4, 'Dell', 'USA'),
			   (5, 'Philips', 'Netherlands'),
			   (6, 'Canon', 'Japan'),
			   (7, 'Nikon', 'Japan'),
			   (8, 'LG Electronics', 'South Korea'),
			   (9, 'ASUS', 'Taiwan'),
			   (10, 'Samsung Electronics', 'South Korea'),
			   (11, 'Sony', 'Japan'),
			   (12, 'Apple Inc.', 'USA'),
			   (13, 'Huawei', 'China'),
			   (14, 'Beko Electronik', 'Turkey'),
			   (15, 'Sharp Corporation', 'Japan'),
			   (16, 'Lenovo Group Limited', 'China')
    ) AS x (ManufacturerID, ManufacturerName, ManufacturerCountry)
)
MERGE dbo.Manufacturers AS t
    USING cte_Manufacturers AS s ON s.ManufacturerID = t.ManufacturerID
WHEN MATCHED and s.ManufacturerName <> t.ManufacturerName OR s.ManufacturerCountry <> t.ManufacturerCountry
    THEN UPDATE SET t.ManufacturerName = s.ManufacturerName , t.ManufacturerCountry = s.ManufacturerCountry
WHEN NOT MATCHED BY TARGET
    THEN INSERT (ManufacturerName, ManufacturerCountry)
         VALUES (s.ManufacturerName, s.ManufacturerCountry);

----------------------CREATING BACKUP FOR TABLE----------------------------------------------------
IF OBJECT_ID ('dbo.Manufacturers_bkp') IS NULL
	SELECT * INTO dbo.Manufacturers_bkp FROM dbo.Manufacturers
GO

------------------------------------------------------------------------------------------------------
----FILLING Comments TABLE WITH COMMENTID, CLIENTID, PRODUCTID, COMMENT, RATE, COMMENTDATE USING CTE--

WITH cte_Comments AS (
    SELECT * FROM (
        VALUES (1, 1, 19, NULL, 5, '2022-01-23 23:59:59.993'),
               (2, 1, 11, 'I purchased the headphones AS I was transitioning into a fully remote position and it has 
			   been fantastic. The noise cancelling is great, the calls seem to be very clear, and the function of 
			   stopping the noise cancelling when you start talking or tap the right headphone twice is great!
			   so far they have been great and they also last for a very long time. I would definitely buy these again.', 
			   5, '2022-02-05 21:35:59.992'),
			   (3, 3, 11, 'I have owned several Sony noise cancelling headphones and this one is definitely their best one
			   yet. worth every penny to me because I use these almost daily. I never go anywhere without them.',
			   5, '2022-01-12 20:01:48.983'),
			   (4, 6, 10, 'The Sony Alpha a7 has everything you need for quality photography. In my opinion it is 
			   the best camera', 5, '2022-02-01 13:59:59.993'),
			   (5, 7, 15, 'For several months everything was fine. In the last few weeks, it stinks of plastic when
			   cooking, and the food soaks up that smell, too', 2, '2022-01-14 16:50:51.872'),
			   (6, 9, 15, 'Very satisfied. Good multicook. I have already cooked in it both the first and second course
			   and even desserts! I liked the large and easy-to-use screen with tips.', 5, '2022-01-23 18:39:35.773'),
			   (7, 12, 1, 'Bought the laptop two weeks ago. Had time to work, test to leave a review. Large screen, 
			   does not change colors at different viewing angles. Fast SSD drive. There is one slot for installing
			   an additional memory card. Have installed 16GB memory card.', 5, '2022-06-21 23:58:45.993'),
			   (8, 13, 5, NULL, 5, '2022-06-21 21:45:59.993'),
			   (9, 3, 7, 'Ive been using it for a week and I am already tired of setting it up, the settings are 
			   too complicated.The settings are very inconvenient, to tweak the brightness or color you have to go
			   to one menu, then to the second and there to look for the right parameters.',
			   3, '2022-04-10 18:45:40.666'),
			   (10, 7, 7, 'The TV is great. Colors, brightness, contrast, sound - everything is perfect. Ambilight
			   is beyond praise. The TV is definitely worth the money.', 5, '2022-03-18 17:59:59.993'),
			   (11, 7, 17, 'The camera, of course, is like a pro camera.For bloggers and travelers is the best, 
			   lightweight, compact, high-quality. Very fast and keeps the charge for a long time.',
			   5, '2022-05-15 19:00:59.993'),
			   (12, 9, 6, NULL, 5, '2022-06-23 21:00:58.993'),
			   (13, 13, 8, 'Small but works great.Cleans thoroughly, its suction power picks up trash from such areas
			   from which even manually could not get.', 5, '2022-07-03 20:00:59.993'),
			   (14, 13, 14, 'Good laptop, the noise only when playing games and then not much, the battery lasts 
			   for 4.5 hours, I use a month, very pleased. But GTA hangs - for gamers is not good.', 4, '2022-07-13 14:38:57.993'),
			   (15, 1, 20, NULL, 5, '2022-07-13 15:01:59.993')
    ) AS x (CommentID, ClientID, ProductID, Comment, Rate, CommentDate)
)
MERGE dbo.Comments AS t
    USING cte_Comments AS s ON s.CommentID = t.CommentID
WHEN MATCHED and s.ClientID <> t.ClientID OR s.ProductID <> t.ProductID OR s.Comment <> t.Comment OR s.Rate <> t.Rate
	OR s.CommentDate <> t.CommentDate 
    THEN UPDATE SET t.ClientID = s.ClientID, t.ProductID = s.ProductID, t.Comment = s.Comment, t.Rate = s.Rate, 
	t.CommentDate = s.CommentDate
WHEN NOT MATCHED BY TARGET
    THEN INSERT (ClientID, ProductID, Comment, Rate, CommentDate)
         VALUES (s.ClientID, s.ProductID, s.Comment, s.Rate, s.CommentDate);

----------------------CREATING BACKUP FOR TABLE----------------------------------------------------
 IF OBJECT_ID ('dbo.Comments_bkp') IS NULL
	SELECT * INTO dbo.Comments_bkp FROM dbo.Comments
GO

----------------------WAS ADDED SOME CHANGES TO DATABASE--------------------------------------------
ALTER TABLE dbo.ClientsDiscount
ADD CONSTRAINT PK_ClientsDiscount PRIMARY KEY CLUSTERED(ClientID ASC);
GO

ALTER TABLE dbo.Clients
ADD CONSTRAINT UC_Email_PhoneNumber UNIQUE (Email,PhoneNumber);
GO