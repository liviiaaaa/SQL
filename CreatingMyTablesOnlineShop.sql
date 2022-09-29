IF OBJECT_ID('dbo.ExceptionsTbl') IS NULL 
	CREATE TABLE dbo.ExceptionsTbl (
		ID TINYINT NOT NULL IDENTITY(1,1),
		ExceptionMessage VARCHAR(200) NOT NULL,
		CONSTRAINT PK_ExceptionsTbl PRIMARY KEY CLUSTERED(ID ASC)
	);
GO

IF OBJECT_ID('dbo.RateSettings') IS NULL 
  CREATE TABLE dbo.RateSettings (
    Rate TINYINT NOT NULL,
	CONSTRAINT PK_RateSettings PRIMARY KEY CLUSTERED(Rate ASC),
	CONSTRAINT CHK_YearSettings_Rate CHECK (Rate > 0 AND Rate <= 5)
  );
GO
IF OBJECT_ID('dbo.YearSettings') IS NULL 
  CREATE TABLE dbo.YearSettings (
    ParameterName VARCHAR(10) NOT NULL,
	ParameterValue SMALLINT NOT NULL,
	CONSTRAINT PK_YearSettings PRIMARY KEY CLUSTERED(ParameterName DESC),
	CONSTRAINT CHK_YearSettings_ParameterValue CHECK ((ParameterValue <= YEAR(GETDATE()) AND ParameterValue >= 2010))
  );
GO
IF OBJECT_ID('dbo.DiscountSettings') IS NULL 
  CREATE TABLE dbo.DiscountSettings (
	ID TINYINT NOT NULL IDENTITY(1,1),
    StartSum INT NOT NULL,
	EndSum INT NOT NULL,
	Discount NUMERIC(3,2) NOT NULL,
	CONSTRAINT PK_DiscountSettings PRIMARY KEY CLUSTERED(ID ASC),
	CONSTRAINT CHK_DiscountSettings_Sum CHECK (StartSum > 0 AND EndSum > 0 AND StartSum < EndSum),
	CONSTRAINT CHK_DiscountSettings_Discount CHECK (Discount > 0)
  );
GO
IF OBJECT_ID('dbo.Manufacturers') IS NULL
	CREATE TABLE dbo.Manufacturers (
		ManufacturerID SMALLINT NOT NULL IDENTITY(1,1),
		ManufacturerName VARCHAR(50) NOT NULL,
		ManufacturerCountry VARCHAR(30) NOT NULL,
		CONSTRAINT PK_Manufacturers PRIMARY KEY CLUSTERED(ManufacturerID)
	);
GO
IF OBJECT_ID('dbo.Clients') IS NULL
	CREATE TABLE dbo.Clients (
		ClientID INT NOT NULL IDENTITY(1,1),
		FirstName VARCHAR(20) NOT NULL,
		LastName VARCHAR(20) NOT NULL,
		PhoneNumber VARCHAR(20) NOT NULL,
		Email VARCHAR(100) NOT NULL,
		CONSTRAINT PK_Clients PRIMARY KEY CLUSTERED(ClientID ASC),
	);
GO
IF OBJECT_ID('dbo.ClientsDiscount') IS NULL
	CREATE TABLE dbo.ClientsDiscount (
		ClientID INT NOT NULL,
		Discount NUMERIC(3,2) NOT NULL,
		CONSTRAINT FK_ClientsDiscount_ClientID FOREIGN KEY (ClientID) REFERENCES dbo.Clients (ClientID),
		CONSTRAINT CHK_ClientsDiscount_Discount CHECK (Discount >= 0 AND Discount < 1)
	);
GO
IF OBJECT_ID('dbo.PaymentType') IS NULL
	CREATE TABLE dbo.PaymentType (
		PaymentTypeID TINYINT NOT NULL IDENTITY(1,1),
		PaymentTypeName VARCHAR(30) NOT NULL,
		CONSTRAINT PK_PaymentType PRIMARY KEY CLUSTERED(PaymentTypeID ASC)
	);
GO
IF OBJECT_ID('dbo.Comments') IS NULL
	CREATE TABLE dbo.Comments (
		CommentID INT NOT NULL IDENTITY(1,1),
		ClientID INT NOT NULL,
		ProductID SMALLINT NOT NULL,
		Comment VARCHAR(1000) NULL,
		Rate TINYINT NOT NULL,
		CommentDate DATETIME NOT NULL,
		CONSTRAINT PK_Comments PRIMARY KEY CLUSTERED(CommentID ASC),
		CONSTRAINT FK_Comments_ClientID FOREIGN KEY (ClientID) REFERENCES dbo.Clients (ClientID),
		CONSTRAINT FK_Comments_ProductID FOREIGN KEY (ProductID) REFERENCES dbo.Products (ProductID),
		CONSTRAINT CHK_Comments_Rate CHECK (Rate > 0 AND Rate <= 5),
		CONSTRAINT CHK_Comments_CommentDate CHECK (GETDATE() >= CommentDate)
	);
GO