USE [DWH]
GO

SELECT FirstSet.District
	  ,SecondSet.[2020 OC]
	  ,FirstSet.[2019 OC]
	  ,SecondSet.[2020 C]
	  ,FirstSet.[2019 C]
FROM(SELECT
	  District 
	  ,CAST(ROUND(COUNT(CASE WHEN
				[Overall Condition] = 'A' 
				THEN [Overall Condition] ELSE NULL END) *100.0/
	  (COUNT(CASE WHEN [Overall Condition] IN ('A','U','U/S') 
				THEN [Overall Condition] ELSE NULL END)),1)as decimal (5,1))AS [2019 OC]
      ,CAST(ROUND((COUNT(CASE WHEN
				[Cleanliness] = 'A' 
				THEN [Cleanliness] ELSE NULL END)) *100.0/
	  (COUNT(CASE WHEN [Cleanliness] IN ('A','U','U/S') 
				THEN [Cleanliness] ELSE NULL END)),1)as decimal (5,1))AS [2019 C]
  FROM [dbo].[tbl_PIP_InspectionMain]
  FULL OUTER JOIN tbl_PIP_AllSites
  ON (tbl_PIP_AllSites.[Prop ID] = tbl_PIP_InspectionMain.[Prop ID] )
  WHERE Boro = 'B'
  and InspectionType ='PIP'
  and [Inspection Year]= '2019'				--previous year
  and Season ='Winter'						--update season
  and Round IN ('1', '2', '3', '4', '5')	--update round
  GROUP BY District
  )AS FirstSet
FULL OUTER JOIN (
SELECT
	   District 
	  ,CAST(ROUND(COUNT(CASE WHEN
				[Overall Condition] = 'A' 
				THEN [Overall Condition] ELSE NULL END) *100.0/
	  (COUNT(CASE WHEN
				[Overall Condition] IN ('A', 'U', 'U/S') 
				THEN [Overall Condition] ELSE NULL END)),1)as decimal (5,1))AS [2020 OC]
      ,CAST(ROUND((COUNT(CASE WHEN
				[Cleanliness] = 'A' 
				THEN [Cleanliness] ELSE NULL END)) *100.0/
	  (COUNT(CASE WHEN
				[Cleanliness] IN ('A', 'U', 'U/S') 
				THEN [Cleanliness] ELSE NULL END)),1)as decimal (5,1))AS [2020 C]
  FROM [dbo].[tbl_PIP_InspectionMain]
  FULL OUTER JOIN tbl_PIP_AllSites
  ON (tbl_PIP_AllSites.[Prop ID] = tbl_PIP_InspectionMain.[Prop ID] )
  WHERE Boro = 'B'
  and InspectionType ='PIP'
  and [Inspection Year]= '2020'				--current year
  and Season ='Winter'						--update season
  and Round IN ('1', '2', '3', '4', '5')	--update round
  GROUP BY District
  )AS SecondSet
 ON FirstSet.District = SecondSet.District
 ORDER BY Firstset.District
GO

