
--ReturnExeption function returns exeptions messages from ExceptionsTbl table by their ID

CREATE OR ALTER FUNCTION dbo.ReturnExeption(@ID TINYINT)
RETURNS VARCHAR(200)
AS
BEGIN
	DECLARE @exception_message VARCHAR(200);
	SET @exception_message = (SELECT ExceptionMessage FROM dbo.ExceptionsTbl WHERE ID = @ID)
    RETURN @exception_message
END
GO

--This procedure returns information about all clients or about specific client if was got his ClientID

CREATE OR ALTER PROCEDURE dbo.spGetClients 
@ClientID INT = NULL
AS
BEGIN TRY
	DECLARE @exception_message VARCHAR(200)
	IF @ClientID IS NOT NULL AND NOT EXISTS(SELECT 1 FROM dbo.Clients WHERE ClientID = @ClientID)
	BEGIN
		SET @exception_message = (SELECT dbo.ReturnExeption(8))
		RAISERROR(@exception_message, 16, 1)
	END
	ELSE
	SELECT	ClientID,
			FirstName,
			LastName,
			PhoneNumber,
			Email
	FROM dbo.Clients 
	WHERE ClientID = ISNULL(@ClientID, ClientID)
END TRY
BEGIN CATCH
	DECLARE @ObjectName VARCHAR(MAX), @OurMessage VARCHAR(MAX), @OccuredAt  DATETIME, @Severity INT, @ErrorState INT,
	@Line INT
    SET @ObjectName = ERROR_PROCEDURE()
    SET @OurMessage = ERROR_MESSAGE()
    SET @OccuredAt = GETDATE()
    SET @Severity = ERROR_SEVERITY()
    SET @ErrorState = ERROR_STATE()
    SET @Line = ERROR_LINE()
    EXEC spInserttoErrorLogs @ObjectName = @ObjectName, @OurMessage = @OurMessage, @OccuredAt  = @OccuredAt, 
	@Severity = @Severity, @ErrorState = @ErrorState, @Line = @Line
END CATCH

--EXEC dbo.spGetClients
--EXEC dbo.spGetClients @ClientID = 1
--EXEC dbo.spGetClients @ClientID = 80000

GO

--This procedure returns discount that all clients have or discount of specific client if was got his ClientID

CREATE OR ALTER PROCEDURE dbo.spGetClientsDiscount 
@ClientID INT = NULL
AS
BEGIN TRY
	DECLARE @exception_message VARCHAR(200)
	IF @ClientID IS NOT NULL AND NOT EXISTS(SELECT 1 FROM dbo.Clients WHERE ClientID = @ClientID)
	BEGIN
		SET @exception_message = (SELECT dbo.ReturnExeption(8))
		RAISERROR(@exception_message, 16, 1)
	END
	ELSE
		SELECT	ClientID,
				Discount
		FROM dbo.ClientsDiscount 
		WHERE ClientID = ISNULL(@ClientID, ClientID)
END TRY
BEGIN CATCH
	DECLARE @ObjectName VARCHAR(MAX), @OurMessage VARCHAR(MAX), @OccuredAt  DATETIME, @Severity INT, @ErrorState INT,
	@Line INT
    SET @ObjectName = ERROR_PROCEDURE()
    SET @OurMessage = ERROR_MESSAGE()
    SET @OccuredAt = GETDATE()
    SET @Severity = ERROR_SEVERITY()
    SET @ErrorState = ERROR_STATE()
    SET @Line = ERROR_LINE()
    EXEC spInserttoErrorLogs @ObjectName = @ObjectName, @OurMessage = @OurMessage, @OccuredAt  = @OccuredAt, 
	@Severity = @Severity, @ErrorState = @ErrorState, @Line = @Line
END CATCH

--EXEC dbo.spGetClientsDiscount @ClientID = NULL
GO

--This procedure returns information about all manufacturers or about specific manufacturer if was got his ManufacturerID

CREATE OR ALTER PROCEDURE dbo.spGetManufacturers 
@ManufacturerID INT = NULL
AS
BEGIN TRY
	DECLARE @exception_message VARCHAR(200)
	IF @ManufacturerID IS NOT NULL AND NOT EXISTS(SELECT 1 FROM dbo.Manufacturers 
												  WHERE ManufacturerID = @ManufacturerID)
	BEGIN
		SET @exception_message = (SELECT dbo.ReturnExeption(22))
		RAISERROR(@exception_message, 16, 1)
	END
	ELSE
		SELECT  ManufacturerID,
				ManufacturerName,
				ManufacturerCountry
		FROM dbo.Manufacturers 
		WHERE ManufacturerID = ISNULL(@ManufacturerID, ManufacturerID)
END TRY
BEGIN CATCH
	DECLARE @ObjectName VARCHAR(MAX), @OurMessage VARCHAR(MAX), @OccuredAt  DATETIME, @Severity INT, @ErrorState INT,
	@Line INT
    SET @ObjectName = ERROR_PROCEDURE()
    SET @OurMessage = ERROR_MESSAGE()
    SET @OccuredAt = GETDATE()
    SET @Severity = ERROR_SEVERITY()
    SET @ErrorState = ERROR_STATE()
    SET @Line = ERROR_LINE()
    EXEC spInserttoErrorLogs @ObjectName = @ObjectName, @OurMessage = @OurMessage, @OccuredAt  = @OccuredAt,
	@Severity = @Severity, @ErrorState = @ErrorState, @Line = @Line
END CATCH

--EXEC dbo.spGetManufacturers @ManufacturerID=NULL
GO

----This procedure returns all payment types or specific payment type if was got his PaymentTypeID--------

CREATE OR ALTER PROCEDURE dbo.spGetPaymentType
@PaymentTypeID TINYINT = NULL
AS
BEGIN TRY
	DECLARE @exception_message VARCHAR(200)
	IF @PaymentTypeID IS NOT NULL AND NOT EXISTS(SELECT 1 FROM dbo.PaymentType 
												  WHERE PaymentTypeID = @PaymentTypeID)
	BEGIN
		SET @exception_message = (SELECT dbo.ReturnExeption(23))
		RAISERROR(@exception_message, 16, 1)
	END
	ELSE
	SELECT  PaymentTypeID,
			PaymentTypeName
	FROM dbo.PaymentType 
	WHERE PaymentTypeID = ISNULL(@PaymentTypeID, PaymentTypeID)
END TRY
BEGIN CATCH
	DECLARE @ObjectName VARCHAR(MAX), @OurMessage VARCHAR(MAX), @OccuredAt  DATETIME, @Severity INT, @ErrorState int,
	@Line INT
    SET @ObjectName = ERROR_PROCEDURE()
    SET @OurMessage = ERROR_MESSAGE()
    SET @OccuredAt = GETDATE()
    SET @Severity = ERROR_SEVERITY()
    SET @ErrorState = ERROR_STATE()
    SET @Line = ERROR_LINE()
    EXEC spInserttoErrorLogs @ObjectName = @ObjectName, @OurMessage = @OurMessage, @OccuredAt  = @OccuredAt, 
	@Severity = @Severity, @ErrorState = @ErrorState, @Line = @Line
END CATCH

--EXEC dbo.spGetPaymentType @PaymentTypeID= NULL
GO

------This procedure returns all comments or specific comment if was got his CommentID--------------------

CREATE OR ALTER PROCEDURE dbo.spGetComments 
@CommentID INT = NULL
AS
BEGIN TRY
	DECLARE @exception_message VARCHAR(200)
	IF @CommentID IS NOT NULL AND NOT EXISTS(SELECT 1 FROM dbo.Comments WHERE CommentID = @CommentID)
	BEGIN
		SET @exception_message = (SELECT dbo.ReturnExeption(24))
		RAISERROR(@exception_message, 16, 1)
	END
	ELSE
		SELECT	CommentID,
				ClientID,
				ProductID,
				Comment,
				Rate,
				CommentDate
		FROM dbo.Comments 
		WHERE CommentID = ISNULL(@CommentID, CommentID)
END TRY
BEGIN CATCH
	DECLARE @ObjectName VARCHAR(MAX), @OurMessage VARCHAR(MAX), @OccuredAt  DATETIME, @Severity INT, @ErrorState INT, 
	@Line INT
    SET @ObjectName = ERROR_PROCEDURE()
    SET @OurMessage = ERROR_MESSAGE()
    SET @OccuredAt = GETDATE()
    SET @Severity = ERROR_SEVERITY()
    SET @ErrorState = ERROR_STATE()
    SET @Line = ERROR_LINE()
    EXEC spInserttoErrorLogs @ObjectName = @ObjectName, @OurMessage = @OurMessage, @OccuredAt  = @OccuredAt, 
	@Severity = @Severity, @ErrorState = @ErrorState, @Line = @Line
END CATCH

--EXEC dbo.spGetComments @CommentID = NULL
--SELECT * FROM dbo.Comments
--EXEC dbo.spGetComments @CommentID = 8000

GO


	/*This procedure inserts new client to table if this client doesn't exist here yet,
	otherwise - updates information about this client*/

CREATE OR ALTER PROCEDURE dbo.spUpsertClients 
@ClientID INT = NULL,
@FirstName VARCHAR(20) = NULL,
@LastName VARCHAR(20) = NULL,
@PhoneNumber VARCHAR(20) = NULL,
@Email VARCHAR(100) = NULL 
AS
BEGIN TRY
	DECLARE @exception_message VARCHAR(200)
	--checking if we are adding the same user
	--addition is not performed if such email or phone number already exists in the table
	IF EXISTS (SELECT Email FROM dbo.Clients WHERE Email = @Email) 
	BEGIN
		SET @exception_message = (SELECT dbo.ReturnExeption(4))
		RAISERROR(@exception_message, 16, 1)
	END
	IF EXISTS (SELECT PhoneNumber FROM dbo.Clients WHERE PhoneNumber = @PhoneNumber)
	BEGIN
		SET @exception_message = (SELECT dbo.ReturnExeption(5))
		RAISERROR(@exception_message, 16, 1)
	END
	ELSE
		IF @ClientID IS NULL OR NOT EXISTS(SELECT 1 FROM dbo.Clients
			WHERE ClientID = @ClientID)
			--addition is not performed if any of the parameters is NULL
			IF @FirstName IS NULL OR @LastName IS NULL OR @PhoneNumber IS NULL OR @Email IS NULL
			BEGIN
				SET @exception_message = (SELECT dbo.ReturnExeption(6))
				RAISERROR(@exception_message, 16, 1)
			END
			ELSE			
				INSERT INTO dbo.Clients(FirstName, LastName, PhoneNumber, Email)
				VALUES (@FirstName,
						@LastName,
						@PhoneNumber,
						@Email)	
		ELSE
			UPDATE dbo.Clients
			SET FirstName = ISNULL(@FirstName, FirstName), LastName = ISNULL(@LastName, LastName), 
			PhoneNumber = ISNULL(@PhoneNumber,PhoneNumber), Email = ISNULL(@Email, Email)
			WHERE ClientID = @ClientID

END TRY
BEGIN CATCH
	DECLARE @ObjectName VARCHAR(MAX), @OurMessage VARCHAR(MAX), @OccuredAt  DATETIME, @Severity INT, @ErrorState INT,
	@Line INT
    SET @ObjectName = ERROR_PROCEDURE()
    SET @OurMessage = ERROR_MESSAGE()
    SET @OccuredAt = GETDATE()
    SET @Severity = ERROR_SEVERITY()
    SET @ErrorState = ERROR_STATE()
    SET @Line = ERROR_LINE()
    EXEC spInserttoErrorLogs @ObjectName = @ObjectName, @OurMessage = @OurMessage, @OccuredAt  = @OccuredAt, 
	@Severity = @Severity, @ErrorState = @ErrorState, @Line = @Line
END CATCH

--Try to add record without parameters
--EXEC dbo.spUpsertClients
--SELECT * FROM dbo.ErrorLogs

--Try to add new client, then try to add client with the same email and phone
--EXEC dbo.spUpsertClients @ClientID = NULL, 
--	@FirstName = 'Natalia',
--	@LastName = 'Hudenko',
--	@PhoneNumber = '+38093389521',
--	@Email = 'nhudenko@gmail.com'
--SELECT * FROM dbo.Clients
--SELECT * FROM dbo.ErrorLogs

--Try to update client's information
--SELECT * FROM dbo.Clients
--EXEC dbo.spUpsertClients @ClientID = 1, 
--@Email = 'lisovska555@gmail.com'

GO

	/*This procedure inserts clientID and his discount to table if this client doesn't have discount yet, 
	otherwise - updates old client's disount to new discount*/
CREATE OR ALTER PROCEDURE dbo.spUpsertClientsDiscount 
@ClientID INT = NULL,
@Discount NUMERIC(3,2) = NULL
AS
BEGIN TRY
		DECLARE @exception_message VARCHAR(200)
		IF @ClientID IS NULL OR NOT EXISTS(SELECT 1 FROM dbo.ClientsDiscount
		  WHERE ClientID = @ClientID)
		  --IF parameter is NULL, we will not add a record
			IF @Discount IS NULL
			BEGIN
				SET @exception_message = (SELECT dbo.ReturnExeption(7))
				RAISERROR(@exception_message, 16, 1)
			END
			ELSE
				IF NOT EXISTS (SELECT ClientID FROM dbo.Clients
							   WHERE ClientID = @ClientID)
				BEGIN
					SET @exception_message = (SELECT dbo.ReturnExeption(8))
					RAISERROR(@exception_message, 16, 1)
				END
				ELSE
					INSERT INTO dbo.ClientsDiscount(ClientID, Discount)
					VALUES (@ClientID,
							@Discount)	
		ELSE
			UPDATE dbo.ClientsDiscount
			SET Discount = ISNULL(@Discount, Discount)
			WHERE ClientID = @ClientID
END TRY
BEGIN CATCH
	DECLARE @ObjectName VARCHAR(MAX), @OurMessage VARCHAR(MAX), @OccuredAt  DATETIME, @Severity INT, @ErrorState INT,
	@Line INT
    SET @ObjectName = ERROR_PROCEDURE()
    SET @OurMessage = ERROR_MESSAGE()
    SET @OccuredAt = GETDATE()
    SET @Severity = ERROR_SEVERITY()
    SET @ErrorState = ERROR_STATE()
    SET @Line = ERROR_LINE()
    EXEC spInserttoErrorLogs @ObjectName = @ObjectName, @OurMessage = @OurMessage, @OccuredAt  = @OccuredAt, 
	@Severity = @Severity, @ErrorState = @ErrorState, @Line = @Line
END CATCH

--EXEC dbo.spUpsertClientsDiscount @ClientID=24, 
--	@Discount = 0.05
--SELECT * FROM dbo.ClientsDiscount

GO


	/*This procedure inserts Manufacturer if this Manufacturer doesn't exist yet in our DB, 
	otherwise - updates information about existing Manufacturers*/

CREATE OR ALTER PROCEDURE dbo.spUpsertManufacturers 
@ManufacturerID SMALLINT = NULL,
@ManufacturerName VARCHAR(50) = NULL,
@ManufacturerCountry VARCHAR(30) = NULL
AS
BEGIN TRY
	DECLARE @exception_message VARCHAR(200)
	IF EXISTS (SELECT ManufacturerName FROM dbo.Manufacturers
			   WHERE ManufacturerName = @ManufacturerName) 
	BEGIN
		SET @exception_message = (SELECT dbo.ReturnExeption(9))
		RAISERROR(@exception_message, 16, 1)
	END
	IF @ManufacturerID IS NULL OR NOT EXISTS(SELECT 1 FROM dbo.Manufacturers
											 WHERE ManufacturerID = @ManufacturerID)
		IF @ManufacturerName IS NULL OR @ManufacturerCountry IS NULL
		BEGIN
			SET @exception_message = (SELECT dbo.ReturnExeption(6))
			RAISERROR(@exception_message, 16, 1)
		END
		ELSE
			INSERT INTO dbo.Manufacturers(ManufacturerName, ManufacturerCountry)
			VALUES (@ManufacturerName,
					@ManufacturerCountry)	
	ELSE
		UPDATE dbo.Manufacturers
		SET ManufacturerName = ISNULL(@ManufacturerName, ManufacturerName), 
		ManufacturerCountry = ISNULL(@ManufacturerCountry, ManufacturerCountry)
		WHERE ManufacturerID = @ManufacturerID
END TRY
BEGIN CATCH
	DECLARE @ObjectName VARCHAR(MAX), @OurMessage VARCHAR(MAX), @OccuredAt  DATETIME, @Severity INT, @ErrorState INT, 
	@Line INT
    SET @ObjectName = ERROR_PROCEDURE()
    SET @OurMessage = ERROR_MESSAGE()
    SET @OccuredAt = GETDATE()
    SET @Severity = ERROR_SEVERITY()
    SET @ErrorState = ERROR_STATE()
    SET @Line = ERROR_LINE()
    EXEC spInserttoErrorLogs @ObjectName = @ObjectName, @OurMessage = @OurMessage, @OccuredAt  = @OccuredAt, 
	@Severity = @Severity, @ErrorState = @ErrorState, @Line = @Line
END CATCH

--EXEC dbo.spUpsertManufacturers @ManufacturerID=18, 
--	@ManufacturerName = NULL,
--	@ManufacturerCountry = 'Japan'

--SELECT * FROM dbo.Manufacturers
GO

/*This procedure inserts PaymentType if this PaymentType doesn't exist yet in our DB, 
	otherwise - updates information about existing PaymentType*/

CREATE OR ALTER PROCEDURE dbo.spUpsertPaymentType
@PaymentTypeID TINYINT = NULL,
@PaymentTypeName VARCHAR(30) = NULL
AS
BEGIN TRY
	DECLARE @exception_message VARCHAR(200)
	IF EXISTS (SELECT PaymentTypeName FROM dbo.PaymentType
			   WHERE PaymentTypeName = @PaymentTypeName) 
	BEGIN
		SET @exception_message = (SELECT dbo.ReturnExeption(10))
		RAISERROR(@exception_message, 16, 1)
	END
	IF @PaymentTypeID IS NULL OR NOT EXISTS(SELECT 1 FROM dbo.PaymentType
											 WHERE PaymentTypeID = @PaymentTypeID)
		
		IF @PaymentTypeName IS NULL
		BEGIN
			SET @exception_message = (SELECT dbo.ReturnExeption(7))
			RAISERROR(@exception_message, 16, 1)
		END
		ELSE
			INSERT INTO dbo.PaymentType(PaymentTypeName)
			VALUES (@PaymentTypeName)	
	ELSE	
		UPDATE dbo.PaymentType
		SET PaymentTypeName = ISNULL(@PaymentTypeName, PaymentTypeName)
		WHERE PaymentTypeID = @PaymentTypeID
END TRY
BEGIN CATCH
	DECLARE @ObjectName VARCHAR(MAX), @OurMessage VARCHAR(MAX), @OccuredAt  DATETIME, @Severity INT, @ErrorState INT, 
	@Line INT
    SET @ObjectName = ERROR_PROCEDURE()
    SET @OurMessage = ERROR_MESSAGE()
    SET @OccuredAt = GETDATE()
    SET @Severity = ERROR_SEVERITY()
    SET @ErrorState = ERROR_STATE()
    SET @Line = ERROR_LINE()
    EXEC spInserttoErrorLogs @ObjectName = @ObjectName, @OurMessage = @OurMessage, @OccuredAt  = @OccuredAt, 
	@Severity = @Severity, @ErrorState = @ErrorState, @Line = @Line
END CATCH

--EXEC dbo.spUpsertPaymentType @PaymentTypeID= NULL, 
--	@PaymentTypeName = 'ApplePay'

--SELECT * FROM dbo.PaymentType
GO

/*This procedure inserts Comment if this Comment doesn't exist yet in our DB, 
	otherwise - updates this Comment*/

CREATE OR ALTER PROCEDURE dbo.spUpsertComments 
@CommentID INT = NULL,
@ClientID INT = NULL,
@ProductID SMALLINT = NULL,
@Comment VARCHAR(1000) = NULL,
@Rate TINYINT = NULL,
@CommentDate DATETIME = NULL
AS
BEGIN TRY
	DECLARE @exception_message VARCHAR(200)
	IF @CommentID IS NULL OR NOT EXISTS(SELECT 1 FROM dbo.Comments
										WHERE CommentID = @CommentID)
		--addition is not performed if any of the parameters is NULL
		IF @ClientID IS NULL OR @ProductID IS NULL OR @Rate IS NULL
		BEGIN
			SET @exception_message = (SELECT dbo.ReturnExeption(11))
			RAISERROR(@exception_message, 16, 1)
		END
		ELSE
			IF NOT EXISTS (SELECT ClientID FROM dbo.Clients
							WHERE ClientID = @ClientID) 
			BEGIN
				SET @exception_message = (SELECT dbo.ReturnExeption(8))
				RAISERROR(@exception_message, 16, 1)
			END
			ELSE
				IF NOT EXISTS (SELECT ProductID FROM dbo.Products
								WHERE ProductID = @ProductID) 
				BEGIN
					SET @exception_message = (SELECT dbo.ReturnExeption(3))
					RAISERROR(@exception_message, 16, 1)
				END	
				ELSE
					INSERT INTO dbo.Comments(ClientID, ProductID, Comment, Rate, CommentDate)
					VALUES (@ClientID,
							@ProductID,
							@Comment,
							@Rate,
							ISNULL(@CommentDate, GETDATE()))
	ELSE
		UPDATE dbo.Comments
		SET ClientID = ISNULL(@ClientID, ClientID), ProductID = ISNULL(@ProductID, ProductID), 
		Comment = @Comment, Rate = ISNULL(@Rate, Rate), CommentDate = GETDATE()
		WHERE CommentID = @CommentID
END TRY
BEGIN CATCH
	DECLARE @ObjectName VARCHAR(MAX), @OurMessage VARCHAR(MAX), @OccuredAt  DATETIME, @Severity INT, @ErrorState INT,
	@Line INT
    SET @ObjectName = ERROR_PROCEDURE()
    SET @OurMessage = ERROR_MESSAGE()
    SET @OccuredAt = GETDATE()
    SET @Severity = ERROR_SEVERITY()
    SET @ErrorState = ERROR_STATE()
    SET @Line = ERROR_LINE()
    EXEC spInserttoErrorLogs @ObjectName = @ObjectName, @OurMessage = @OurMessage, @OccuredAt  = @OccuredAt, 
	@Severity = @Severity, @ErrorState = @ErrorState, @Line = @Line
END CATCH


--EXEC dbo.spUpsertComments  @CommentID = NULL, 
--		@ClientID = 8,
--		@ProductID = 8000,
--		--@Comment
--		@Rate = 5,
--		@CommentDate = NULL

------------------------
--SELECT * FROM dbo.Comments
GO

-----------------------------This procedure generates random names----------------------------------------

CREATE OR ALTER PROCEDURE dbo.spGenerateClientName
@return_value VARCHAR(20) OUTPUT
AS
BEGIN TRY
	DECLARE @cons VARCHAR(20) --consonant letters
	DECLARE @vowel VARCHAR(6) --vowel letters
	DECLARE @count INT = 1 
	DECLARE @string VARCHAR(20) = ''
	DECLARE @lengthName INT 
	DECLARE @rand_cons INT
	DECLARE @rand_vowel INT
	SET @cons = 'bcdfghjklmnpqrstvwxz'
	SET @vowel = 'aeiouy'
	SET @lengthName = ABS(CHECKSUM(NEWID()) % 3) + 2 --generate a number between 2 and 4 for every row.
	SET @rand_cons = ABS(CHECKSUM(NEWID()) % 20) + 1 ----generate a number between 1 and 20 for every row.
	SET @string += SUBSTRING(UPPER(@cons), @rand_cons, 1)
	WHILE @count < @lengthName
	BEGIN
		SET @rand_cons = ABS(CHECKSUM(NEWID()) % 20) + 1
		SET @rand_vowel = ABS(CHECKSUM(NEWID()) % 6) + 1
		SET @string += SUBSTRING(@vowel, @rand_vowel, 1)
		SET @string += SUBSTRING(@cons, @rand_cons, 1) 
		SET @count += 1
	END
	SET @return_value = @string
END TRY
BEGIN CATCH
	THROW;
END CATCH

GO

--DECLARE @return_name VARCHAR(20)
--EXEC dbo.spGenerateClientName @return_name OUTPUT
--SELECT @return_name

----------------------------------This procedure generates random phone number----------------------------------------------

CREATE OR ALTER PROCEDURE dbo.spGenerateClientPhoneNumber
@return_phone VARCHAR(20) OUTPUT
AS
BEGIN TRY
	DECLARE @count INT = 1 
	DECLARE @string VARCHAR(20) = ''
	DECLARE @lengthName INT 
	DECLARE @numbers VARCHAR(10)
	DECLARE @rand INT
	SET @numbers = '0123456789'
	SET @lengthName = 9
	SET @string += '+380'
	WHILE @count <= @lengthName
		BEGIN
			SET @rand = ABS(CHECKSUM(NEWID()) % 10) + 1 --generate a number between 1 and 10.
			SET @string += SUBSTRING(@numbers, @rand, 1)
			SET @count += 1
		END
	SET @return_phone = @string
END TRY
BEGIN CATCH
	THROW;
END CATCH
GO

--DECLARE @return_phone VARCHAR(20)
--EXEC spGenerateClientPhoneNumber @return_phone OUT
--SELECT @return_phone


-----------This procedure was created in order to populate our Clients table with more random generated data-------------------

CREATE OR ALTER PROCEDURE dbo.spGenerateDataForClients
AS
BEGIN TRY
	SET NOCOUNT ON
	IF OBJECT_ID('#RandDomains') IS NULL
		CREATE TABLE #RandDomains(
			ID TINYINT IDENTITY(1,1),
			Domain VARCHAR(15),
			CONSTRAINT PK_RandDomains PRIMARY KEY CLUSTERED(ID ASC)
			);
	INSERT INTO #RandDomains
	VALUES  ('@gmail.com'), 
			('@ukr.net'),
			('@yahoo.com'),
			('@outlook.com')

	DECLARE @loop_count INT = 1
	WHILE (@loop_count < 500)
		BEGIN
			DECLARE @randID INT
			SET @randID = ABS(CHECKSUM(NEWID()) % 1000000) + 1
	
			DECLARE @return_name VARCHAR(20)
			EXEC dbo.spGenerateClientName @return_name OUTPUT
	
			DECLARE @return_surname VARCHAR(20)
			EXEC dbo.spGenerateClientName @return_surname OUTPUT
	
			DECLARE @return_phone VARCHAR(20)
			EXEC spGenerateClientPhoneNumber @return_phone OUT
	
			DECLARE @rand_email_domain VARCHAR(15)
			SET @rand_email_domain = (SELECT TOP 1 Domain FROM #RandDomains  ORDER BY NEWID())

			DECLARE @rand_email VARCHAR(100) = CONCAT(LEFT(@return_name, 1), LOWER(@return_surname) , @rand_email_domain)
	
	
			EXEC dbo.spUpsertClients @ClientID = @randID,
			@FirstName = @return_name,
			@LastName = @return_surname,
			@PhoneNumber = @return_phone,
			@Email = @rand_email

	
			SET @loop_count += 1
		END

END TRY
BEGIN CATCH
	THROW;
END CATCH

--EXEC dbo.spGenerateDataForClients
--SELECT * FROM dbo.Clients
GO

-----------This procedure was created in order to populate our Comments table with more random generated data-------------------

CREATE OR ALTER PROCEDURE dbo.spGenerateDataForComments
AS
BEGIN TRY
	SET NOCOUNT ON
	IF OBJECT_ID('#RandComments') IS NULL
		CREATE TABLE #RandComments(
			ID TINYINT IDENTITY(1,1),
			Comment VARCHAR(1000),
			CONSTRAINT PK_RandComments PRIMARY KEY CLUSTERED(ID ASC)
			);
	INSERT INTO #RandComments
	VALUES  ('Good'), 
			('Great!'),
			('Product is fine'),
			('I am delighted'),
			('Very cool'),
			('Everything is OK'),
			('Very well'),
			('Normal'),
			('I like it!'),
			('Awful!'),
			('Bad'),
			('I am not satisfied'),
			('Such a good product!'),
			('Excelent'),
			('Nice'),
			('Perfect'),
			('I am happy to buy this'),
			('I am disappointed.');
	
	DECLARE @loopCount INT = 1
	WHILE (@loopCount < 300)
	BEGIN
		DECLARE @FromDate DATETIME
		DECLARE @RandCommentDate DATETIME
		DECLARE @high_rate TINYINT
		DECLARE @low_rate TINYINT
		DECLARE @comment VARCHAR(1000)
		DECLARE @randID INT
		DECLARE @ProductId SMALLINT
		DECLARE @ClientId INT
		DECLARE @rate TINYINT
		SET @randID = ABS(CHECKSUM(NEWID()) % 1000000) + 1
		SET @FromDate = '2015-01-01 08:22:13.000' 

		DECLARE @Seconds INT = DATEDIFF(SECOND, @FromDate, GETDATE())
		DECLARE @Random INT = ROUND((@Seconds * RAND()), 0)
		DECLARE @Milliseconds INT = ROUND((999 * RAND()), 0)
		SET @RandCommentDate = DATEADD(MILLISECOND, @Milliseconds, DATEADD(SECOND, @Random, @FromDate))

		SET @high_rate = (ABS(CHECKSUM(NEWID())) % 2) + 4 --4,5
		SET @low_rate = (ABS(CHECKSUM(NEWID())) % 3) + 1 --1,2,3 
	
		SET @comment = (SELECT TOP 1 Comment FROM #RandComments  ORDER BY NEWID())
		SET @ProductId = (SELECT TOP 1 ProductID FROM dbo.Products ORDER BY NEWID())
		SET @ClientId = (SELECT TOP 1 ClientID FROM dbo.Clients ORDER BY NEWID())
		SET @rate = IIF(@comment IN ('Awful!','Bad','I am not satisfied', 'I am disappointed.'), @low_rate, @high_rate)

		EXEC dbo.spUpsertComments @CommentID = @randID,
		@ClientID = @ClientId,
		@ProductID = @ProductId,
		@Comment = @comment,
		@Rate = @rate,
		@CommentDate = @RandCommentDate

		SET @loopCount = @loopCount +1
	END

END TRY
BEGIN CATCH
	THROW;
END CATCH

--EXEC dbo.spGenerateDataForComments
--SELECT * FROM dbo.Comments
GO

-----------This procedure was created in order to populate ClientsDiscount table with more random generated data-------------------


CREATE OR ALTER PROCEDURE dbo.spGenerateDiscounts 
AS
BEGIN TRY
	SET NOCOUNT ON
	IF OBJECT_ID('#discount_tbl') IS NULL
		CREATE TABLE #discount_tbl(
			ID TINYINT IDENTITY(1,1),
			discount NUMERIC(3,2) NOT NULL,
			CONSTRAINT PK_discount_tbl PRIMARY KEY CLUSTERED(ID ASC)
		);
	INSERT INTO #discount_tbl
		VALUES (0.05),
			   (0.1),
			   (0.15),
			   (0.2);

	DECLARE @loop_count INT = 1
	WHILE (@loop_count < 5)
	BEGIN
		DECLARE @client_id INT 
		SET @client_id = (SELECT TOP 1 ClientID FROM dbo.Clients ORDER BY NEWID())
		DECLARE @str_discount NUMERIC(3,2)
		SET @str_discount = (SELECT TOP 1 discount FROM #discount_tbl ORDER BY NEWID())
	
		EXEC dbo.spUpsertClientsDiscount @ClientID = @client_id,
			@Discount = @str_discount
	
		SET @loop_count += 1
	END
END TRY
BEGIN CATCH
	THROW;
END CATCH

--SELECT * FROM dbo.ClientsDiscount
--EXEC spGenerateDiscounts

GO

--------------This function calculates discount for client depending on sum of his order-----------------------

CREATE OR ALTER FUNCTION dbo.CalculateDiscount(@Sum NUMERIC(10,2))
RETURNS NUMERIC(3,2)
AS
BEGIN
	DECLARE @discount NUMERIC(3,2)
	SET @discount = CASE
						WHEN @Sum BETWEEN (SELECT StartSum FROM dbo.DiscountSettings WHERE ID = 1) AND 
						(SELECT EndSum FROM dbo.DiscountSettings WHERE ID = 1) 
						THEN (SELECT Discount FROM dbo.DiscountSettings WHERE ID = 1)
						WHEN @Sum BETWEEN (SELECT StartSum FROM dbo.DiscountSettings WHERE ID = 2) AND 
						(SELECT EndSum FROM dbo.DiscountSettings WHERE ID = 2) 
						THEN (SELECT Discount FROM dbo.DiscountSettings WHERE ID = 2)
						WHEN @Sum BETWEEN (SELECT StartSum FROM dbo.DiscountSettings WHERE ID = 3) AND 
						(SELECT EndSum FROM dbo.DiscountSettings WHERE ID = 3) 
						THEN (SELECT Discount FROM dbo.DiscountSettings WHERE ID = 3)
						WHEN @Sum BETWEEN (SELECT StartSum FROM dbo.DiscountSettings WHERE ID = 4) AND 
						(SELECT EndSum FROM dbo.DiscountSettings WHERE ID = 4) 
						THEN (SELECT Discount FROM dbo.DiscountSettings WHERE ID = 4)
					END
    RETURN @discount
END

--SELECT * FROM DiscountSettings
--SELECT dbo.CalculateDiscount(3000)

GO


---------Procedure inserts discount for user into ClientsDiscount table or update existing discount to bigger-------------

CREATE OR ALTER PROCEDURE dbo.spAddDiscount
@ClientID INT = NULL,
@Sum NUMERIC(10,2) = NULL
AS
BEGIN TRY
	DECLARE @exception_message VARCHAR(200)
	DECLARE @discount NUMERIC(3,2)
	DECLARE @current_disc NUMERIC(3,2)
	--Discount will be calculated only if sum of order >= 2000 AND NOT NULL
	IF @Sum < 2000 OR @Sum IS NULL
	BEGIN 
		SET @exception_message = (SELECT dbo.ReturnExeption(27))
		RAISERROR(@exception_message, 16, 1)
	END
	ELSE
		--Check if client with this ID exists
		IF NOT EXISTS (SELECT ClientID FROM dbo.Clients WHERE ClientID = @ClientID)
		BEGIN 
			SET @exception_message = (SELECT dbo.ReturnExeption(8))
			RAISERROR(@exception_message, 16, 1)
		END
		ELSE
			--Using function CalculateDiscount
			SET @discount = (SELECT dbo.CalculateDiscount(@Sum))
			--getting current user's discount
			SET @current_disc = (SELECT Discount From ClientsDiscount WHERE ClientID = @ClientID)
			--Check if client with this id already has a discount. If not - we insert him to the table 
			IF @current_disc IS NULL
				INSERT INTO dbo.ClientsDiscount(ClientID, Discount)
				VALUES (@ClientID, @discount)
			ELSE
				--we update disount only if new discount is bigger than old discount, otherwise nothing will be changed
				IF @discount > @current_disc
					UPDATE dbo.ClientsDiscount
					SET Discount = @discount
					WHERE ClientID = @ClientID
END TRY
BEGIN CATCH
DECLARE @ObjectName VARCHAR(MAX), @OurMessage VARCHAR(MAX), @OccuredAt  DATETIME, @Severity INT, @ErrorState INT,
	@Line INT
    SET @ObjectName = ERROR_PROCEDURE()
    SET @OurMessage = ERROR_MESSAGE()
    SET @OccuredAt = GETDATE()
    SET @Severity = ERROR_SEVERITY()
    SET @ErrorState = ERROR_STATE()
    SET @Line = ERROR_LINE()
    EXEC spInserttoErrorLogs @ObjectName = @ObjectName, @OurMessage = @OurMessage, @OccuredAt  = @OccuredAt, 
	@Severity = @Severity, @ErrorState = @ErrorState, @Line = @Line
END CATCH

--select * from dbo.ClientsDiscount
--EXEC dbo.spAddDiscount @ClientID = NULL, @Sum = 1000
--EXEC dbo.spAddDiscount @ClientID = NULL, @Sum = 2000
--EXEC dbo.spAddDiscount @ClientID = 4, @Sum = 15000
GO

--------------------------VIEWS--------------------------------------------------------------------------------------------

--------This function is used in views and returns required value by the parameter name from YearSettings table----------

CREATE OR ALTER FUNCTION dbo.ReturnYear(@ParameterName VARCHAR(10))
RETURNS SMALLINT
AS
BEGIN
	RETURN (SELECT ParameterValue FROM dbo.YearSettings WHERE ParameterName = @ParameterName)
END
GO
--SELECT * FROM dbo.YearSettings

	/*This view returns only products that had a not satisfied rate : 1,2,3 ; also returns categories of this products 
	and number of purchases for each products, and number of bad rates that each product have during 2021 and 2022 years.
	*/

CREATE OR ALTER VIEW dbo.vwGetQuantityOfBadRates
AS
SELECT CategoryName, ProductName, COUNT(op.ProductID) number_of_purchases, bad_rates_number
FROM (SELECT ProductID, COUNT(Rate) AS bad_rates_number FROM Comments
	  WHERE Rate IN (SELECT Rate FROM dbo.RateSettings) AND 
	  YEAR(CommentDate) BETWEEN (SELECT dbo.ReturnYear('YearStart')) AND (SELECT dbo.ReturnYear('YearEnd'))
	  GROUP BY ProductID) query
JOIN Orders_Products op ON op.ProductID = query.ProductID
JOIN Products p ON op.ProductID = p.ProductID
JOIN Categories c ON p.CategoryID = c.CategoryID
GROUP BY CategoryName, ProductName, bad_rates_number

--RateSettings table contains not satisfied rates: 1,2,3	
--SELECT * FROM dbo.RateSettings
--SELECT * FROM dbo.vwGetQuantityOfBadRates
--SELECT * FROM Comments

GO 

----This view returns payment types and number of uses of each of them by clients during 2021 and 2022 years.---

CREATE OR ALTER VIEW dbo.vwGetMostPopularPaymentType
AS
SELECT PaymentTypeName, COUNT(o.PaymentTypeID) AS number_of_use
FROM dbo.PaymentType AS pt
JOIN dbo.Orders AS o ON pt.PaymentTypeID = o.PaymentTypeID
WHERE YEAR(OrderDate) BETWEEN (SELECT dbo.ReturnYear('YearStart')) AND (SELECT dbo.ReturnYear('YearEnd'))
GROUP BY PaymentTypeName

GO
--SELECT * FROM dbo.vwGetMostPopularPaymentType
