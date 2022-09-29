
--=======================STORED PROCEDURES FOR WORKING WITH DIMENSIONS====================================

	/*This procedure fills Date dimension with dates from date when Online Shop was opened 
	and adds as much next days as was passed by input parameter*/

CREATE OR ALTER PROCEDURE dbo.spPopulateDIM_Date
@DaysNumber SMALLINT
AS
BEGIN TRY
	DECLARE @StartDate DATE
	IF NOT EXISTS(SELECT 1 FROM dbo.DIM_Date)
		SELECT TOP 1 @StartDate = Date FROM dbo.DateSettings
	ELSE 
		SELECT @StartDate = MAX(Date) FROM dbo.DIM_Date;
	WITH cte_Date AS
	(
		SELECT @StartDate AS [Date]
		UNION ALL
		SELECT DATEADD(day, 1, [Date])
		FROM cte_Date
		WHERE [Date] < DATEADD(day, @DaysNumber - 1, @StartDate)
	)
	INSERT INTO dbo.DIM_Date(Date, Day, Month, Year, Quarter)
	SELECT t.[Date] as Date, SUBSTRING(DATENAME(WEEKDAY, t.[Date]), 1, 3) AS Day, 
			RIGHT('00' + CONVERT(VARCHAR(2), MONTH(t.[Date])), 2) AS Month , YEAR(t.[Date]) AS Year, 
			DATEPART(QUARTER, t.[Date]) AS Quarter 
	FROM cte_Date t LEFT JOIN DIM_Date d ON t.Date = d.Date
	WHERE d.Date IS NULL
	OPTION (MAXRECURSION 0)
END TRY
BEGIN CATCH
	THROW;
END CATCH

--SELECT * FROM dbo.DIM_Date

GO

--===============================================================================================================================

	/*This procedure adds records to Clients dimension in Data Warehouse from Clients table in Online Shop DB 
	if they doesn't exists in DW or updates EndDate of record in dimension if something was changed in source DB 
	and adds new record with updated information. We do it in this way because here we are using Slowly Changing Dimensions Type 2.
	Also this procedure counts how many rows were transferred to DW in order to write the amount of added rows to a Logstable - 
	this is done using SQL Server Integration Services in Visual Studio.*/

CREATE OR ALTER PROCEDURE dbo.spMergeClients
(@InsertedRows INT OUTPUT)
AS
BEGIN TRY
	DECLARE @prRowCount INT = NULL
	DECLARE @newRowCount INT = NULL
	IF OBJECT_ID('dbo.DIM_Clients') IS NOT NULL
		SET @prRowCount = (SELECT COUNT(*)  FROM dbo.DIM_Clients)
	INSERT INTO dbo.DIM_Clients(ClientID, FirstName, LastName, PhoneNumber, Email, Discount, StartDate, EndDate)
	SELECT DISTINCT t.ClientID, 
					t.FirstName, 
					t.LastName, 
					t.PhoneNumber, 
					t.Email, 
					t.Discount, 
					StartDate = GETDATE(), 
					EndDate = NULL
	FROM dbo.tmpClients t LEFT JOIN dbo.DIM_Clients d ON t.ClientID = d.ClientID 
	WHERE (d.ClientID IS NULL OR (t.FirstName <> d.FirstName OR t.LastName <> d.LastName 
			OR t.PhoneNumber <> d.PhoneNumber OR t.Email <> d.Email OR t.Discount <> d.Discount)) AND EndDate IS NULL

	UPDATE dbo.DIM_Clients
	SET EndDate = IIF(CAST(DATEADD(DAY, -1, GETDATE()) AS DATE) < StartDate, CAST(GETDATE() AS DATE), 
	CAST(DATEADD(DAY, -1, GETDATE()) AS DATE))
	FROM dbo.tmpClients t RIGHT JOIN dbo.DIM_Clients d ON t.ClientID = d.ClientID
	WHERE (t.ClientID IS NULL OR t.FirstName <> d.FirstName OR t.LastName <> d.LastName 
			OR t.PhoneNumber <> d.PhoneNumber OR t.Email <> d.Email OR t.Discount <> d.Discount) AND EndDate IS NULL;

	IF OBJECT_ID('dbo.DIM_Clients') IS NOT NULL
		SET @newRowCount = (SELECT COUNT(*) FROM dbo.DIM_Clients)
		SET @InsertedRows = ABS(@newRowCount - @prRowCount)

END TRY
BEGIN CATCH
	THROW;
END CATCH

 GO

--====================TESTING dbo.spMergeClients PROCEDURE================================

--SELECT * FROM dbo.DIM_CLIENTS
--TRUNCATE TABLE dbo.DIM_Clients
--Set identificator equals 1
DBCC CHECKIDENT ('dbo.DIM_Clients', 'RESEED', 1)

--TRUNCATE TABLE dbo.DIM_Manufacturers
DBCC CHECKIDENT ('dbo.DIM_Manufacturers', 'RESEED', 1)
--SELECT * FROM dbo.DIM_Manufacturers

--See what saves LogTable
SELECT * FROM LogTable

GO

--=================================================================================================================================

	/*This procedure adds records to Manufacturers dimension in Data Warehouse from Manufacturers table in Online Shop DB 
	if they doesn't exists in DW or updates EndDate of record in dimension if something was changed in source DB 
	and adds new record with updated information. We do it in this way because here we are using Slowly Changing Dimensions Type 2.
	Also this procedure counts how many rows were transferred to DW in order to write the amount of added rows to a Logstable - 
	this is done using SQL Server Integration Services in Visual Studio.*/

CREATE OR ALTER PROCEDURE dbo.spMergeManufacturers
(@InsertedRows INT OUTPUT)
AS
BEGIN TRY
	DECLARE @prRowCount INT = NULL
	DECLARE @newRowCount INT = NULL
	IF OBJECT_ID('dbo.DIM_Manufacturers') IS NOT NULL
		SET @prRowCount = (SELECT COUNT(*)  FROM dbo.DIM_Manufacturers)
	INSERT INTO dbo.DIM_Manufacturers(ManufacturerID, ManufacturerName, ManufacturerCountry, StartDate, EndDate)
	SELECT DISTINCT t.ManufacturerID, 
					t.ManufacturerName, 
					t.ManufacturerCountry, 
					StartDate = GETDATE(), 
					EndDate = NULL
	FROM dbo.tmpManufacturers t LEFT JOIN dbo.DIM_Manufacturers d ON t.ManufacturerID = d.ManufacturerID 
	WHERE (d.ManufacturerID IS NULL OR (t.ManufacturerName <> d.ManufacturerName OR 
			t.ManufacturerCountry <> d.ManufacturerCountry)) AND EndDate IS NULL

	UPDATE dbo.DIM_Manufacturers
	SET EndDate = IIF(CAST(DATEADD(DAY, -1, GETDATE()) AS DATE) < StartDate, CAST(GETDATE() AS DATE), 
	CAST(DATEADD(DAY, -1, GETDATE()) AS DATE))
	FROM dbo.tmpManufacturers t RIGHT JOIN dbo.DIM_Manufacturers d ON t.ManufacturerID = d.ManufacturerID
	WHERE (t.ManufacturerID IS NULL OR t.ManufacturerName <> d.ManufacturerName 
			OR t.ManufacturerCountry <> d.ManufacturerCountry)
			AND EndDate IS NULL;
	IF OBJECT_ID('dbo.DIM_Manufacturers') IS NOT NULL
		SET @newRowCount = (SELECT COUNT(*) FROM dbo.DIM_Manufacturers)
		SET @InsertedRows = ABS(@newRowCount - @prRowCount)

END TRY
BEGIN CATCH
	THROW;
END CATCH

