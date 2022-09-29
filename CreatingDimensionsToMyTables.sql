
-----------------CREATING DIMENSIONS FOR DATA WAREHOUSE------------------------------------

----This is the additional table that saves the year when Online Shop was opened--

IF OBJECT_ID('dbo.DateSettings') IS NULL 
	CREATE TABLE dbo.DateSettings (
		ID TINYINT NOT NULL IDENTITY(1,1),
		Date DATE NOT NULL,
		CONSTRAINT PK_DateSettings PRIMARY KEY CLUSTERED(ID ASC)
	);
GO

IF NOT EXISTS (SELECT 1 FROM dbo.DateSettings)
	INSERT INTO dbo.DateSettings
	VALUES ('2010-02-25')
GO

---------------Creating Date dimension--------------

IF OBJECT_ID('dbo.DIM_Date') IS NULL 
	CREATE TABLE dbo.DIM_Date (
		DateId INT NOT NULL IDENTITY(1,1),
		Date DATE NOT NULL,
		Day VARCHAR(3) NOT NULL,
		Month VARCHAR(2) NOT NULL,
		Year  SMALLINT NOT NULL,
		Quarter TINYINT NOT NULL,
		CONSTRAINT PK_DIM_Date PRIMARY KEY CLUSTERED(DateId ASC)
	);
GO

----------------Creating Manufacturers dimension--------------

IF OBJECT_ID('dbo.DIM_Manufacturers') IS NULL 
	CREATE TABLE dbo.DIM_Manufacturers (
		ID INT NOT NULL IDENTITY(1,1),
		ManufacturerID SMALLINT NOT NULL,
		ManufacturerName VARCHAR(50) NOT NULL,
		ManufacturerCountry VARCHAR(30) NOT NULL,
		StartDate DATE NOT NULL,
		EndDate DATE NULL,
		CONSTRAINT PK_DIM_Manufacturers PRIMARY KEY CLUSTERED(ID ASC)
	);
GO

----------------Creating Clients dimension------------------------

IF OBJECT_ID('dbo.DIM_Clients') IS NULL 
	CREATE TABLE dbo.DIM_Clients (
		ID INT NOT NULL IDENTITY(1,1),
		ClientID INT NOT NULL,
		FirstName VARCHAR(20) NOT NULL,
		LastName VARCHAR(20) NOT NULL,
		PhoneNumber VARCHAR(20) NOT NULL,
		Email VARCHAR(100) NOT NULL,
		Discount NUMERIC(3,2) NULL,
		StartDate DATE NOT NULL,
		EndDate DATE NULL,
		CONSTRAINT PK_DIM_Clients PRIMARY KEY CLUSTERED(ID ASC)
	);
GO
