
--======================COHORT ANALYSIS================================================

	/*This procedure performs a cohort analysis for customers who made their first purchase 
	in our store between 2021-08-01 and 2022-09-20.
	I visualized the results of this analysis in PowerBI.*/

CREATE OR ALTER PROCEDURE dbo.spCohortAnalysis
AS
BEGIN TRY

	DROP TABLE IF EXISTS #cohort, #data, #date_diff_tbl, #cohort_pivot

	--Chosing customers that made first purchase during specified period

	SELECT CLIENTID ClientID, MIN(DATE) AS First_purchase_date,
			DATEFROMPARTS(YEAR(MIN(date)), month(MIN(date)), 1) Cohort_Date
	INTO #cohort
	FROM Facts_Sales fs JOIN DIM_Date dd ON fs.DateId = dd.DateId 
	GROUP BY ClientID
	HAVING MIN(DATE) between '2021-08-01' AND '2022-08-31'
	ORDER BY clientid
	
	--Chosing dates when this customers made next purchases and recording it as invoice_year and invoice_month
	--year and month of first purchase recording as cohort_year and cohort_month

	SELECT DISTINCT
		fs.ClientID,
		c.Cohort_Date,
		YEAR(dd.DATE) invoice_year,
		MONTH(dd.DATE) invoice_month,
		YEAR(c.Cohort_Date) cohort_year,
		MONTH(c.Cohort_Date) cohort_month
	INTO #data
	FROM Facts_Sales fs join DIM_Date dd on fs.DateId = dd.DateId
	JOIN #cohort c
		ON fs.ClientID = c.ClientID
	WHERE DATE BETWEEN '2021-08-01' AND '2022-09-20'
	ORDER BY ClientID
	
	--Counting the difference between dates of first purchase and next purchases
	
	SELECT
			ClientID,
			Cohort_Date,
			year_diff = invoice_year - cohort_year,
			month_diff = invoice_month - cohort_month
	into #date_diff_tbl
	FROM #data

	--Computing cohort_index and using PIVOT function in order to form a table

	SELECT *
	INTO #cohort_pivot
	FROM(
		SELECT DISTINCT
			ClientID,
			Cohort_Date,
			cohort_index = year_diff * 12 + month_diff
		FROM #date_diff_tbl
	)tbl
		PIVOT(
			COUNT(ClientID)
			FOR cohort_index IN
				(
				[0],
				[1],
				[2],
				[3],
				[4],
				[5],
				[6],
				[7],
				[8],
				[9],
				[10],
				[11],
				[12])
		) AS pivot_table

	--Calculating the ratio of returning customers to the number of new customers at the beginning of the month

	SELECT Cohort_Date, 
		[0] as [New customers],
		1.0 * [1]/[0] AS [1],
		1.0 * [2]/[0] AS [2],
		1.0 * [3]/[0] AS [3],
		1.0 * [4]/[0] AS [4],
		1.0 * [5]/[0] AS [5],
		1.0 * [6]/[0] AS [6],
		1.0 * [7]/[0] AS [7],
		1.0 * [8]/[0] AS [8],
		1.0 * [9]/[0] AS [9],
		1.0 * [10]/[0] AS [10],
		1.0 * [11]/[0] AS [11],
		1.0 * [12]/[0] AS [12]
	FROM #cohort_pivot
	ORDER BY Cohort_Date
	DROP TABLE IF EXISTS #cohort, #data, #cohort_pivot
END TRY
BEGIN CATCH
	THROW;
END CATCH

--EXEC dbo.spCohortAnalysis
