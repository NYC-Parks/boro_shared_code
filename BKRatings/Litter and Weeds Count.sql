--Acceptable Litter & Weeds Season to Date for BK Ratings Report published each round
--Last modified: 3/17/2021

USE [DWH]

--LITTER
SELECT [Inspection Year]
,[District]
,[Rating]
,count(case when [Inspection Year]=2020 and (Round in ('1')) then Feature									 --previous year to date 
	        when [Inspection Year]=2021 and (Round in ('1')) then Feature else null end) AS 'Litter Count'   --current year season to date
  FROM [dbo].[tbl_PIP_FeatureRatings]
  where Borough = 'Brooklyn'
  and [Inspection Year] in (2020, 2021)						--update years
  and Season ='Spring'					                    --update season
  and Feature = 'Litter'
  and Rating <> 'N'
  and InspectionType = 'PIP'
group by Rating, District, [Inspection Year]
order by District, [Inspection Year], Rating
;

--WEEDS (or other feature of interest)
SELECT [Inspection Year]
,[District]
,[Rating]
,count(case when [Inspection Year]=2020 and (Round in ('1')) then Feature										--previous year to date
	        when [Inspection Year]=2021 and (Round in ('1')) then Feature else null end) AS 'Paved Surfaces'	--current year season to date
  FROM [dbo].[tbl_PIP_FeatureRatings]
  where Borough = 'Brooklyn'
  and [Inspection Year] in (2020, 2021)						--update years
  and Season ='Spring'					                    --update season
  and Feature = 'Paved Surfaces'							--feature to query
  and Rating <> 'N'
  and InspectionType = 'PIP'
group by Rating, District, [Inspection Year]
order by District, [Inspection Year], Rating
;
