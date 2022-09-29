
--===============================================================================================================
/*This procedure makes a report to Data Warehouse DataBase and returns ManagerName, ClientName, Manufacturer, 
ProductName. In this report, you can sort the table by any of the columns and make all columns or only some of
them visible, as well as show ShowSummary string or not.
*/

CREATE OR ALTER PROCEDURE dbo.spCreateReportToDW
	@StartDate date,
	@EndDate date,
	@ManagerIDs varchar(MAX) = NULL,
	@ClientIDs varchar(MAX) = NULL,
	@CityIDs varchar(MAX) = NULL,
	@ManufacturerIDs varchar(MAX) = NULL,
	@ProductIDs varchar(MAX) = NULL,
	@ShowSummary BIT = NULL,
	@VisibleColumns varchar(20) = NULL,
	@SortBy TINYINT = NULL
AS
BEGIN TRY
	SET NOCOUNT ON;
	IF @EndDate < @StartDate OR DATEDIFF(DAY, @StartDate, @EndDate) > 180 
		RAISERROR('EndDate should be bigger or equals to StartDate & We consider only a 180-day range.',16,1)
	IF @SortBy IS NOT NULL AND (@SortBy > 5 OR @SortBy < 1)
		RAISERROR('SortBy parameter should be in a range from 1 to 5',16,1)
	ELSE 
		SET @ShowSummary = ISNULL(@ShowSummary, 0);

		--=================INSERT #Managers=================================================

		IF OBJECT_ID('#Managers') IS NULL
			CREATE TABLE #Managers(
				ManagerID SMALLINT,
				FirstName VARCHAR(25),
				LastName VARCHAR(25)
				);
		IF @ManagerIDs IS NULL
			INSERT INTO #Managers
			SELECT ManagerID, FirstName,LastName FROM dbo.DIM_Managers
		ELSE 
			INSERT INTO #Managers
			SELECT DISTINCT ManagerID, FirstName,LastName FROM dbo.DIM_Managers m CROSS APPLY STRING_SPLIT(@ManagerIDs, ',') s
			WHERE m.ID = s.value


		--=================INSERT #Clients=================================================

		IF OBJECT_ID('#Clients') IS NULL
		CREATE TABLE #Clients(
			ClientID SMALLINT,
			FirstName VARCHAR(25),
			LastName VARCHAR(25)
			);
		IF @ClientIDs IS NULL
			INSERT INTO #Clients
			SELECT ClientID, FirstName,LastName FROM dbo.DIM_Clients
		ELSE 
			INSERT INTO #Clients
			SELECT DISTINCT ClientID, FirstName,LastName FROM dbo.DIM_Clients m CROSS APPLY STRING_SPLIT(@ClientIDs, ',') s
			WHERE m.ID = s.value 
			

		--=================INSERT #Manufacturers=================================================

		IF OBJECT_ID('#Manufacturers') IS NULL
		CREATE TABLE #Manufacturers(
			ManufacturerID SMALLINT,
			ManufacturerName VARCHAR(50)
			);
		IF @ManufacturerIDs IS NULL
			INSERT INTO #Manufacturers
			SELECT ManufacturerID, ManufacturerName FROM dbo.DIM_Manufacturers
		ELSE 
			INSERT INTO #Manufacturers
			SELECT DISTINCT ManufacturerID, ManufacturerName FROM dbo.DIM_Manufacturers m 
			CROSS APPLY STRING_SPLIT(@ManufacturerIDs, ',') s
			WHERE m.ID = s.value

		--=================INSERT #Products=================================================

		IF OBJECT_ID('#Products') IS NULL
		CREATE TABLE #Products(
			ProductID SMALLINT,
			ProductName VARCHAR(200)
			);
		IF @ProductIDs IS NULL
			INSERT INTO #Products
			SELECT ProductID, ProductName FROM dbo.DIM_Products
		ELSE 
			INSERT INTO #Products
			SELECT DISTINCT ProductID, ProductName FROM dbo.DIM_Products m 
			CROSS APPLY STRING_SPLIT(@ProductIDs, ',') s
			WHERE m.ID = s.value



		--=========================IsBestSeller Check=====================================================================
		
		DROP TABLE IF EXISTS #tmpIsBestSeller

		SELECT ProductID
		into #BestProduct
		FROM (SELECT TOP 10 ProductID, SUM(Quantity) AS Sold_quantity 
										FROM Facts_Sales fs
										JOIN DIM_Date d ON d.DateId = fs.DateID
										WHERE Date between @StartDate and @EndDate
										GROUP BY ProductID
										ORDER BY Sold_quantity desc) as t

         SELECT p.ProductID,
		        IsBestSeller = 1
		 INTO #tmpIsBestSeller
		 FROM #Products as p
		 join #BestProduct as bp on p.ProductID = bp.ProductID

		

		--=====================Report==================================================================
		
		DROP TABLE IF EXISTS #ReportTable

		SELECT CONCAT(m.FirstName, ' ', m.LastName, '(', m.ManagerID, ')') as Managers, 
			   CONCAT(c.FirstName, ' ', c.LastName, '(', c.ClientID, ')') as Clients,
			   --CONCAT(WarehousesName, ' ', WarehousesCity, '(', Warehousesid, ')') as WH,
			   CONCAT(ManufacturerName, '(', mf.Manufacturerid, ')') as Manufacturers,
			   CONCAT(p.ProductName, '(', p.ProductID, ')') as Products,
			   IIF(IsBestSeller = 1, IsBestSeller, 0) as IsBestSeller,
			   Cast(Date as varchar(10)) as [Date],
			   SUM(Quantity) as ProductCount,
			   SUM(TotalPrice) as TotalPrice
		INTO #ReportTable
		FROM #Managers m 
		JOIN dbo.Facts_Sales fs ON m.ManagerID = fs.ManagerID 
		JOIN #Clients c ON c.ClientID = fs.ClientID
		--JOIN #Warehouse w ON w.Warehousesid = fs.WarehouseId
		JOIN #Manufacturers mf ON mf.ManufacturerID = fs.ManufacturerID
		JOIN #Products p ON p.ProductID = fs.ProductID
		JOIN DIM_Date dd ON dd.DateId = fs.DateID
		LEFT JOIN #tmpIsBestSeller bs ON p.ProductID = bs.ProductID 
		WHERE [Date] BETWEEN @StartDate AND @EndDate
		GROUP BY CONCAT(m.FirstName, ' ', m.LastName, '(', m.ManagerID, ')'), 
				 CONCAT(c.FirstName, ' ', c.LastName, '(', c.ClientID, ')'),
			     CONCAT(ManufacturerName, '(', mf.Manufacturerid, ')'),
			     CONCAT(p.ProductName, '(', p.ProductID, ')'),
				 IIF(IsBestSeller = 1, IsBestSeller, 0) ,
				 Cast(Date as varchar(10))
		

		--=================SortBy=================================================

		IF OBJECT_ID('#SortBy') IS NULL
			CREATE TABLE #SortBy(
				Column_Name VARCHAR(200),
				Column_Order TINYINT 
				);
		INSERT INTO #SortBy
		VALUES ('Managers', 1),
				('Clients', 2),
				('Manufacturers', 3),
				('Products', 4),
				('Date', 6)

		--======================Visible Columns=================================================

		--==This variable shows how many optional fields are visible by default 
		DECLARE @ColumnsNumber tinyint = 5 

		--====Split string @VisibleColumns to get separate id-s=======================

		IF OBJECT_ID('#Split_Value') IS NULL
			CREATE TABLE #Split_Value (
				ID INT
			);
		INSERT INTO #Split_Value
		SELECT * FROM STRING_SPLIT(@VisibleColumns, ',')

		--===Create temp table where will be saved columns that are visible=============
		
		IF OBJECT_ID('#Visible_Columns') IS NULL
			CREATE TABLE #Visible_Columns (
				FieldName varchar(100)
			);
		INSERT INTO #Visible_Columns
		SELECT case 
					when ID = 1 then 'Managers' 
					when ID = 2 then 'Clients'
					when ID = 3 then 'Manufacturers'
					when ID = 4 then 'Products'
					when ID = 5 then 'IsBestSeller'
		
		end
		FROM #Split_Value

		--===Check if we can sort by columns that are visible======

		IF @SortBy IS NOT NULL AND NOT EXISTS(SELECT 1 FROM #Split_Value WHERE ID = @SortBy)
			RAISERROR('This column is not displayed in the report so you cannot sort the report by it.
			Choose column among those that are visible in the report.',16,1)
		
		--=========Drop column from report if this column should not be visible============

		IF @VisibleColumns IS NOT NULL AND NOT EXISTS (SELECT 1 FROM #Visible_Columns WHERE FieldName = 'Managers')
		BEGIN
			ALTER TABLE #ReportTable DROP COLUMN Managers;
			SET @ColumnsNumber -= 1
		END

		IF @VisibleColumns IS NOT NULL AND NOT EXISTS (SELECT 1 FROM #Visible_Columns WHERE FieldName = 'Clients')
		BEGIN
			ALTER TABLE #ReportTable DROP COLUMN Clients;
			SET @ColumnsNumber -= 1
		END

		IF @VisibleColumns IS NOT NULL AND NOT EXISTS (SELECT 1 FROM #Visible_Columns WHERE FieldName = 'Manufacturers')
		BEGIN
			ALTER TABLE #ReportTable DROP COLUMN Manufacturers;
			SET @ColumnsNumber -= 1
		END

		IF @VisibleColumns IS NOT NULL AND NOT EXISTS (SELECT 1 FROM #Visible_Columns WHERE FieldName = 'Products')
		BEGIN
			ALTER TABLE #ReportTable DROP COLUMN Products;
			SET @ColumnsNumber -= 1
		END

		IF @VisibleColumns IS NOT NULL AND NOT EXISTS (SELECT 1 FROM #Visible_Columns WHERE FieldName = 'IsBestSeller')
		BEGIN
			ALTER TABLE #ReportTable DROP COLUMN IsBestSeller;
			SET @ColumnsNumber -= 1
		END


		--========================Show Total==================================================
		
		DECLARE @sql NVARCHAR(MAX)
		IF @ShowSummary = 1
		BEGIN
			
			IF @SortBy IS NOT NULL
			BEGIN
				SET @sql  = 'SELECT * FROM 
							(SELECT TOP (SELECT COUNT(*) FROM dbo.#ReportTable) * FROM #ReportTable
							'

				SET @sql+=' ORDER BY ' + (SELECT Column_Name FROM #SortBy WHERE Column_Order = @SortBy) 
				SET @sql += ') AS t'
				SET @sql +=' UNION ALL SELECT ''Total'', ' + REPLICATE('''-'', ', @ColumnsNumber) +
						'SUM(ProductCount) , SUM(TotalPrice) FROM #ReportTable'	
			END
			ELSE
				SET @sql  = 'SELECT * FROM #ReportTable UNION ALL SELECT ''Total'', ' 
				 + REPLICATE('''-'', ', @ColumnsNumber) + 'SUM(ProductCount) , SUM(TotalPrice) FROM #ReportTable'
		END

		ELSE

			IF @SortBy IS NOT NULL
			BEGIN
				SET @sql  = 'SELECT * FROM #ReportTable'
				SET @sql+=' ORDER BY ' + (SELECT Column_Name FROM #SortBy WHERE Column_Order = @SortBy)
			END
			ELSE 
				SET @sql  = 'SELECT * FROM #ReportTable'

		EXECUTE sp_executesql @sql;

		DROP TABLE IF EXISTS #ReportTable, #BestProduct, #Clients, #Managers, #Manufacturers, #Products, #SortBy, 
							 #Split_Value, #tmpIsBestSeller, #Visible_Columns

END TRY
BEGIN CATCH
	THROW;
END CATCH

