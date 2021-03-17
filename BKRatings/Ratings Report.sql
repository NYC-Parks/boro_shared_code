--Sites included in the most recent PIP inspection round
--For BK Query Report

USE [BKDB]
GO

SELECT [District]
      ,[Prop ID]
      ,[Site Name]
      ,[PIP Inpsection Date-Time]
      ,[DoW]
      ,[Prior Daily Tasks Visit]
      ,[Staff Type]
      ,[SLA]
      ,[Prior Self Inspection]
      ,[OC]
      ,[CL]
      ,[Unacceptable Features]
      ,[Category]
      ,[OC Last 2 Inspections]
      ,[OC Last 4 Inspections]
	  ,(SELECT CASE WHEN SLA = 'A' AND COUNT(DISTINCT date_worked) >= 5 THEN 'Y'
					WHEN SLA = 'A' AND COUNT(DISTINCT date_worked) < 5 THEN 'N'
					WHEN SLA = 'B' AND COUNT(DISTINCT date_worked) >= 3 THEN 'Y'
					WHEN SLA = 'B' AND COUNT(DISTINCT date_worked) < 3 THEN 'N'
					WHEN SLA = 'C' AND COUNT(DISTINCT date_worked) > 0 THEN 'Y'
					WHEN SLA = 'C' AND COUNT(DISTINCT date_worked) = 0 THEN 'N' END
		FROM DWH.dbo.tbl_dailytasks
		WHERE date_worked >= CONVERT(DATE,DATEADD(wk, DATEDIFF(wk,0,[PIP Inpsection Date-Time]), -8))
		AND date_worked <= CONVERT(DATE,DATEADD(wk, DATEDIFF(wk,0,[PIP Inpsection Date-Time]), -2))
		AND omppropid = [Prop ID]) AS 'SLA Week Prior'
	   ,(SELECT CASE WHEN SLA = 'A' AND COUNT(DISTINCT date_worked) >= 5 THEN 'Y'
					WHEN SLA = 'A' AND COUNT(DISTINCT date_worked) < 5 THEN 'N'
					WHEN SLA = 'B' AND COUNT(DISTINCT date_worked) >= 3 THEN 'Y'
					WHEN SLA = 'B' AND COUNT(DISTINCT date_worked) < 3 THEN 'N'
					WHEN SLA = 'C' AND COUNT(DISTINCT date_worked) > 0 THEN 'Y'
					WHEN SLA = 'C' AND COUNT(DISTINCT date_worked) = 0 THEN 'N' END
		FROM DWH.dbo.tbl_dailytasks T
		WHERE date_worked >= CONVERT(DATE,DATEADD(wk, DATEDIFF(wk,0,[PIP Inpsection Date-Time]), -1))
		AND date_worked <= CONVERT(DATE,DATEADD(wk, DATEDIFF(wk,0,[PIP Inpsection Date-Time]), 5))
		AND omppropid = [Prop ID]) AS 'SLA Week Of'
		,(SELECT MIN(DATETIME_WORKED)
			FROM BKDB.dbo.DailyTasks_Visits
			WHERE DATETIME_WORKED >= [PIP Inpsection Date-Time] AND omppropid = [Prop ID]) AS 'Cleaned Post'

  FROM [dbo].[All Sites Ratings]


  --CHANGE AFTER THIS LINE

  WHERE [Inspection Year] = 2020
  AND Season = 'Winter'
  AND Round = 1

  ORDER BY District, [Prop ID]

GO


