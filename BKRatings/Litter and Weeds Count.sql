-- Acceptable Litter & Weeds Season to Date for BK Ratings Report published each round
-- Modified 6/22/2021 to compare with 2019 summer season rather than 2020
-- Modified 7/20/2020 AMPSDistrict should always be used to avoid legacy errors with DISTRICT
-- Modified 10/21/2021 b/c underlying tables changed - joined on Inspection Main & All Sites to filter to Borough and group by district

USE [DWH]

--LITTER
SELECT Main.[Inspection Year]
,Main.[AMPSDistrict]
,Feature.[Rating]
,count(case when Main.[Inspection Year]=2019 and (Round in ('1', '2', '3')) then Feature.Feature									 --previous year to date 
	        when Main.[Inspection Year]=2021 and (Round in ('1', '2', '3')) then Feature.Feature else null end) AS 'Litter Count'   --current year season to date
  FROM [dbo].[tbl_PIP_InspectionMain] Main
  FULL OUTER JOIN [dbo].[tbl_PIP_FeatureRatings] Feature
  ON (Main.[Inspection ID] = Feature.[Inspection ID])
  FULL OUTER JOIN [dbo].[TBL_PIP_ALLSITES] AllSites
  ON (Main.[Prop ID] = AllSites.[PropID])
  where AllSites.Boro = 'B'
  and [Inspection Year] in (2019, 2021)						--update years
  and Season ='Fall'					                    --update season
  and Feature = 'Litter'
  and Rating <> 'N'
  --and InspectionType = 'PIP'
group by Feature.Rating, Main.AMPSDistrict, Main.[Inspection Year]
order by Main.AMPSDistrict, Main.[Inspection Year], Feature.Rating
;

--WEEDS (or other feature of interest)
SELECT Main.[Inspection Year]
,Main.[AMPSDistrict]
,Feature.[Rating]
,count(case when Main.[Inspection Year]=2019 and (Round in ('1', '2', '3')) then Feature.Feature									 --previous year to date 
	        when Main.[Inspection Year]=2021 and (Round in ('1', '2', '3')) then Feature.Feature else null end) AS 'Weeds Count'   --current year season to date
  FROM [dbo].[tbl_PIP_InspectionMain] Main
  FULL OUTER JOIN [dbo].[tbl_PIP_FeatureRatings] Feature
  ON (Main.[Inspection ID] = Feature.[Inspection ID])
  FULL OUTER JOIN [dbo].[TBL_PIP_ALLSITES] AllSites
  ON (Main.[Prop ID] = AllSites.[PropID])
  where AllSites.Boro = 'B'
  and [Inspection Year] in (2019, 2021)						--update years
  and Season ='Fall'					                    --update season
  and Feature = 'Weeds'
  and Rating <> 'N'
  --and InspectionType = 'PIP'
group by Feature.Rating, Main.AMPSDistrict, Main.[Inspection Year]
order by Main.AMPSDistrict, Main.[Inspection Year], Feature.Rating
;
