--Overall Condition & Cleanliness percentages Season to Date for BK Ratings Report published each round
-- Modified: 6/22/2021 to compare with 2019 summer season rather than 2020
-- Modified 7/20/2020 AMPSDistrict should always be used to avoid legacy errors with DISTRICT
-- Modified 10/21/2021 b/c underlying tables changed - variable names changed slightly and InspectionType variable no longer exists

USE [DWH]
GO

SELECT	SecondSet.District_2021, --update year names each new inspection year
	  FirstSet.District_2019,
	  SecondSet.[2021 OC],
	  FirstSet.[2019 OC],
	  SecondSet.[2021 C],
	  FirstSet.[2019 C]
FROM (SELECT
		Main.[AMPSDistrict] as District_2019, 
		CASE -- 2019 OC:
			WHEN COUNT(CASE WHEN [Overall Condition] IN ('A','U','U/S') THEN [Overall Condition] ELSE NULL END) = 0 --check if denominator is ZERO 
			THEN NULL -- return null otherwise divide for a percentage:
			ELSE CAST(ROUND(COUNT(CASE WHEN [Overall Condition] = 'A' THEN [Overall Condition] ELSE NULL END) *100.0 /
						   (COUNT(CASE WHEN [Overall Condition] IN ('A','U','U/S') THEN [Overall Condition] ELSE NULL END)),1)as decimal (5,1)) 
			END AS [2019 OC],
		CASE -- 2019 C
			WHEN COUNT(CASE WHEN [Cleanliness] IN ('A','U','U/S') THEN [Cleanliness] ELSE NULL END) = 0 --check if denominator is ZERO 
			THEN NULL -- return null otherwise divide for a percentage:
			ELSE CAST(ROUND((COUNT(CASE WHEN [Cleanliness] = 'A' THEN [Cleanliness] ELSE NULL END)) *100.0/
				  (COUNT(CASE WHEN [Cleanliness] IN ('A','U','U/S') THEN [Cleanliness] ELSE NULL END)),1)as decimal (5,1)) 
			END AS [2019 C]
	  FROM [dbo].[tbl_PIP_InspectionMain] Main
	  FULL OUTER JOIN tbl_PIP_AllSites AllSites
	  ON (AllSites.[PropID] = Main.[Prop ID] )
	  WHERE Boro = 'B'
	  --and InspectionType ='PIP'			--variable no longer available, all PIP?
	  and [Inspection Year]= '2019'			--previous year
	  and Season ='Fall'					--update season
	  and Round IN ('1', '2', '3')					--update ROUND TO DATE
	  GROUP BY Main.AMPSDistrict
	  )	
  AS FirstSet
FULL OUTER JOIN 
	(SELECT
	   Main.AMPSDistrict as District_2021,
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
	  FROM [dbo].[tbl_PIP_InspectionMain] Main
	  FULL OUTER JOIN tbl_PIP_AllSites AllSites
	  ON (AllSites.[PropID] = Main.[Prop ID] )
	  WHERE Boro = 'B'
	  --and InspectionType ='PIP'				--variable no longer available, all PIP?
	  and [Inspection Year]= '2021'				--current year
	  and Season ='Fall'						--update season
	  and Round IN ('1', '2', '3')						--update ROUND TO DATE
	  GROUP BY Main.AMPSDistrict
	  ) 
 AS SecondSet
 ON FirstSet.District_2019 = SecondSet.District_2021
 ORDER BY Firstset.District_2019
GO


