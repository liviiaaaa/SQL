--===============================================================================

--An ABC analysis gives a snapshot of your best- and worst-selling inventory over a period of time. 
--A-grade inventory are your bestselling products that account for 80% of total revenue. 
--B-grade inventory counts for 15% of total revenue. 
--C-grade inventory is the rest of your products, which account for 5% of revenue. 


CREATE OR ALTER PROCEDURE dbo.spAnalyseSales
	@StartDate DATE,
	@EndDate DATE,
	@watchBy BIT = NULL,
	@category_name VARCHAR(100) = NULL
AS
BEGIN TRY
	
	DECLARE @Total_Revenue NUMERIC(13,2)
	
	IF @EndDate < @StartDate
		RAISERROR('EndDate should be bigger or equals to StartDate.',16,1)

	IF @watchBy IS NOT NULL AND (@watchBy > 1 OR @watchBy < 0)
		RAISERROR('@watchBy parameter should equals to 0 or 1',16,1)
	ELSE 
		SET @watchBy = ISNULL(@watchBy, 0);

	
	--This procedure provides 2 options depending on @watchBy parameter value : 
							--if @watchBy = 1 - shows ABC analysis only by categories
							--if @watchBy = 0, NULL - shows ABC analysis by each product

	--shows ABC analysis only by categories

	IF @watchBy = 1
	begin
		IF @category_name IS NOT NULL 
			RAISERROR('You have selected analysis by all categories.
		To see a single category, set the watchby parameter to 0.',16,1)
		DROP TABLE IF EXISTS #SalesByCategory
		SELECT CategoryName Category, COUNT(fs.ProductID) Sales_amount, SUM(TotalPrice) Revenue
		INTO #SalesByCategory
		FROM  Facts_Sales fs JOIN DIM_Products p ON p.ID = fs.ProductID
		JOIN DIM_Date d ON fs.DateID = d.DateId
		WHERE Date BETWEEN @StartDate AND @EndDate
		GROUP BY CategoryName
	
		DROP TABLE IF EXISTS #AnalysisByCategory

		/*The breakdown of all products that were sold during this period into three grades A, B and C 
		according to the income they brought us*/

		SELECT Category, CONVERT(VARCHAR(100), Sales_amount) Sales_amount, Revenue,
		CONVERT(VARCHAR(100), (CAST(Revenue/ SUM(Revenue) OVER () * 100 AS NUMERIC(10,4))))  + '%' 
		AS CumulativePercentage,
		CASE 
				WHEN SUM(Revenue) OVER (ORDER BY Revenue DESC) / SUM(Revenue) OVER () <= 0.8 
					THEN 'A'
				WHEN SUM(Revenue) OVER (ORDER BY Revenue DESC) / SUM(Revenue) OVER () <= 0.95 
					THEN 'B'
				ELSE 'C'
			END AS Grade
		INTO #AnalysisByCategory
		FROM #SalesByCategory 
		UNION ALL 
		SELECT 'Total', ' ', SUM(Revenue) , ' ', ' ' FROM #SalesByCategory;

		SELECT * FROM #AnalysisByCategory
	END
	ELSE

	--shows ABC analysis by each product

	BEGIN
		IF @category_name IS NOT NULL AND NOT EXISTS (SELECT 1 from DIM_Products where CategoryName = @category_name)
			RAISERROR('Such category does not exists.',16,1)

		--Creating table with revenue by product

		DROP TABLE IF EXISTS #SalesByProduct
		SELECT CategoryName Category, p.ProductID ProductID, p.ProductName ProductName, 
			   COUNT(fs.ProductID) Sales_amount, SUM(TotalPrice) Revenue,
			   (
				SELECT min_date 
				FROM (
						SELECT ProductID, MIN(DATE) AS min_date FROM Facts_Sales fs 
						JOIN DIM_Date dd ON fs.DateID = dd.DateId 
						GROUP BY ProductID
					 ) t 
				WHERE t.ProductID = p.ProductID
			   ) First_ordered, 
			   MAX(DATE) Last_ordered
		INTO #SalesByProduct
		FROM  Facts_Sales fs 
		JOIN DIM_Products p ON p.ID = fs.ProductID
		JOIN DIM_Date d ON fs.DateID = d.DateId
		WHERE [Date] BETWEEN @StartDate AND @EndDate
		GROUP BY CategoryName, p.ProductID, p.ProductName
	
		--IF @category_name IS NULL - report displays all products and all categories
		--IF @category_name equals to specific category name - report displays analysis only by this category

		DROP TABLE IF EXISTS #BySpecificCategory
		CREATE TABLE #BySpecificCategory (
			Category VARCHAR(100),
			ProductID INT,
			ProductName VARCHAR(MAX),
			Sales_amount INT,
			Revenue NUMERIC(11,2),
			First_ordered DATE,
			Last_ordered DATE
		)

		IF @category_name IS NOT NULL
			INSERT INTO #BySpecificCategory 
			SELECT * FROM #SalesByProduct
			WHERE Category = @category_name 

		ELSE
			INSERT INTO #BySpecificCategory  
			SELECT * FROM #SalesByProduct


		SET @Total_Revenue = (SELECT SUM(Revenue) FROM #BySpecificCategory)

		--Creating report with ABC grades 

		/*The breakdown of all products that were sold during this period into three grades A, B and C 
		according to the income they brought us*/

		DROP TABLE IF EXISTS #AnalysisByProduct

		SELECT Category, CAST(CONCAT('(', pb.ProductID, ')', pb.ProductName) AS VARCHAR(50)) AS ProductName, 
				CONVERT(VARCHAR(100), IIF(Discount = 0, NULL, Discount)) Discount, 
				CAST(First_ordered AS VARCHAR(10)) AS First_ordered, 
				CAST(Last_ordered AS VARCHAR(10)) AS Last_ordered,
				CONVERT(varchar(100), Sales_amount) Sales_amount, Revenue,
				CONVERT(varchar(100), (CAST(Revenue/ @Total_Revenue * 100 AS NUMERIC(10,4))))  + '%' 
				AS CumulativePercentage,
		CASE 
				WHEN SUM(Revenue) OVER (ORDER BY Revenue DESC) / @Total_Revenue <= 0.8 or Revenue/@Total_Revenue > 0.15
					THEN 'A'
				WHEN SUM(Revenue) OVER (ORDER BY Revenue DESC) / @Total_Revenue <= 0.95 
					THEN 'B'
				ELSE 'C'
			END AS Grade
		INTO #AnalysisByProduct
		FROM #BySpecificCategory pb JOIN DIM_Products p ON pb.ProductID = p.ProductID
		UNION ALL 
		SELECT 'Total', ' ', ' ', ' ', ' ', ' ', @Total_Revenue , ' ',' '

		SELECT * FROM #AnalysisByProduct

	END
	
	DROP TABLE IF EXISTS #SalesByCategory, #AnalysisByCategory, #SalesByProduct, #BySpecificCategory, #AnalysisByProduct
	
END TRY
BEGIN CATCH
	THROW;
END CATCH


--EXEC dbo.spAnalyseSales @StartDate = '2022-04-10', @EndDate = '2022-09-12', @watchBy = 0,
	--@category_name = 'Multicooks' --null
