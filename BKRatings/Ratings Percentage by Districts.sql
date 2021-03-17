--Overall Condition & Cleanliness percentages Season to Date for BK Ratings Report published each round
--Last modified: 3/17/2020

USE [DWH]
GO

SELECT	SecondSet.District_2021, --update year names each new inspection year
	  FirstSet.District_2020,
	  SecondSet.[2021 OC],
	  FirstSet.[2020 OC],
	  SecondSet.[2021 C],
	  FirstSet.[2020 C]
FROM (SELECT
		District as District_2020, 
		CASE -- 2020 OC:
			WHEN COUNT(CASE WHEN [Overall Condition] IN ('A','U','U/S') THEN [Overall Condition] ELSE NULL END) = 0 --check if denominator is ZERO 
			THEN NULL -- return null otherwise divide for a percentage:
			ELSE CAST(ROUND(COUNT(CASE WHEN [Overall Condition] = 'A' THEN [Overall Condition] ELSE NULL END) *100.0 /
						   (COUNT(CASE WHEN [Overall Condition] IN ('A','U','U/S') THEN [Overall Condition] ELSE NULL END)),1)as decimal (5,1)) 
			END AS [2020 OC],
		CASE -- 2020 C
			WHEN COUNT(CASE WHEN [Cleanliness] IN ('A','U','U/S') THEN [Cleanliness] ELSE NULL END) = 0 --check if denominator is ZERO 
			THEN NULL -- return null otherwise divide for a percentage:
			ELSE CAST(ROUND((COUNT(CASE WHEN [Cleanliness] = 'A' THEN [Cleanliness] ELSE NULL END)) *100.0/
				  (COUNT(CASE WHEN [Cleanliness] IN ('A','U','U/S') THEN [Cleanliness] ELSE NULL END)),1)as decimal (5,1)) 
			END AS [2020 C]
	  FROM [dbo].[tbl_PIP_InspectionMain]
	  FULL OUTER JOIN tbl_PIP_AllSites
	  ON (tbl_PIP_AllSites.[Prop ID] = tbl_PIP_InspectionMain.[Prop ID] )
	  WHERE Boro = 'B'
	  and InspectionType ='PIP'
	  and [Inspection Year]= '2020'			--previous year
	  and Season ='Spring'					--update season
	  and Round IN ('1')					--update ROUND TO DATE
	  GROUP BY District
	  )	
  AS FirstSet
FULL OUTER JOIN 
	(SELECT
	   District as District_2021,
		CASE -- 2021 OC:
			WHEN COUNT(CASE WHEN [Overall Condition] IN ('A','U','U/S') THEN [Overall Condition] ELSE NULL END) = 0 --check if denominator is ZERO 
			THEN NULL -- return null otherwise divide for a percentage:
			ELSE CAST(ROUND(COUNT(CASE WHEN [Overall Condition] = 'A' THEN [Overall Condition] ELSE NULL END) *100.0 /
						   (COUNT(CASE WHEN [Overall Condition] IN ('A','U','U/S') THEN [Overall Condition] ELSE NULL END)),1)as decimal (5,1)) 
			END AS [2021 OC],
		CASE -- 2021 C
			WHEN COUNT(CASE WHEN [Cleanliness] IN ('A','U','U/S') THEN [Cleanliness] ELSE NULL END) = 0 --check if denominator is ZERO 
			THEN NULL -- return null otherwise divide for a percentage:
			ELSE CAST(ROUND((COUNT(CASE WHEN [Cleanliness] = 'A' THEN [Cleanliness] ELSE NULL END)) *100.0/
				  (COUNT(CASE WHEN [Cleanliness] IN ('A','U','U/S') THEN [Cleanliness] ELSE NULL END)),1)as decimal (5,1)) 
			END AS [2021 C]
	  FROM [dbo].[tbl_PIP_InspectionMain]
	  FULL OUTER JOIN tbl_PIP_AllSites
	  ON (tbl_PIP_AllSites.[Prop ID] = tbl_PIP_InspectionMain.[Prop ID] )
	  WHERE Boro = 'B'
	  and InspectionType ='PIP'
	  and [Inspection Year]= '2021'				--current year
	  and Season ='Spring'						--update season
	  and Round IN ('1')						--update ROUND TO DATE
	  GROUP BY District
	  ) 
 AS SecondSet
 ON FirstSet.District_2020 = SecondSet.District_2021
 ORDER BY Firstset.District_2020
GO


