Declare @specified_date AS DATE
SET @specified_date = '10-21-2020'				--date change

SELECT Z.SECTOR AS [Sector]
,Z.route_name AS [Route_Name]
,Z.route__id AS [Route_ID]
,COUNT(DISTINCT
		CASE	
		WHEN Z.off_route = '0'
		THEN Z.omppropid
		END) AS [On_Route_Visits]
,COUNT(DISTINCT
		CASE
		WHEN Z.off_route = '1'
		THEN Z.omppropid
		END) AS [Off_Route_Visits]
,COUNT(DISTINCT Z.omppropid) AS [Total_Properties_Visited]
,COUNT(DISTINCT X.property_number) AS [Locations_On_Route]
,FORMAT(ROUND(CAST(COUNT(DISTINCT
		CASE	
		WHEN Z.off_route = '0'
		THEN Z.omppropid
		END)*1.00/COUNT(DISTINCT X.property_number) AS decimal(10,4)),4),'P') AS [%_On_Route_Visited]
FROM dwh.dbo.tbl_dailytasks as z
LEFT JOIN DailyTasks.DBO.tbl_route_property as x
	ON Z.route__id = X. route__id
WHERE Z.date_worked = @specified_date			 
AND activity = 'WORK'
AND sector LIKE 'b%'						    --BORO CHANGE
AND X.active = 1
GROUP BY z.route__id,Z.route_name,z.sector
order by z.sector