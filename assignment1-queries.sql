--Working with areas--

--Area of  the Census divisions in hectares--
SELECT cduid, cdname, ST_Area(cdboundary)/10000 as hectares 
FROM geography.census_division;

-- Area of the largest census division--
SELECT cduid, cdname, ST_Area(cdboundary)/10000 as hectares 
FROM geography.census_division
ORDER BY ST_Area(cdboundary)/10000  DESC
LIMIT 1;


--Area of the smallest census division--
SELECT cduid, cdname, ST_Area(cdboundary)/10000 as hectares 
FROM geography.census_division
ORDER BY ST_Area(cdboundary)/10000 
LIMIT 1;

-- Area of agricultural ecumene in hectares--
SELECT cduid, cdname, ST_Area(aeboundary)/10000 as hectares 
FROM geography.census_division
ORDER BY ST_Area(aeboundary)/10000  DESC;

-- Area of the largest agricultural ecumene --
SELECT cduid, cdname, ST_Area(aeboundary)/10000 as hectares 
FROM geography.census_division
ORDER BY ST_Area(aeboundary)/10000  DESC
LIMIT 1;

-- Area of the smallest agricultural ecumene --
SELECT cduid, cdname, ST_Area(aeboundary)/10000 as hectares 
FROM geography.census_division
ORDER BY ST_Area(aeboundary)/10000  
LIMIT 1;

-- Calculating the proportion of agricultural ecumene to census division--
SELECT cduid, cdname, (ST_Area(aeboundary)/10000)/(ST_Area(cdboundary)/10000) AS ae_cd_proportional
FROM geography.census_division;

--Calculating the proportion of agricultural ecumene to census division in percentage--
-- Largest agricultural ecumene to census division  proportional --
SELECT cduid, cdname, (ST_Area(aeboundary)/10000)/(ST_Area(cdboundary)/10000)*100 AS ae_cd_proportional
FROM geography.census_division
ORDER BY ae_cd_proportional DESC
LIMIT 1;

-- smallest agricultural ecumene to census division  proportional --
SELECT cduid, cdname, (ST_Area(aeboundary)/10000)/(ST_Area(cdboundary)/10000)*100 AS ae_cd_proportional
FROM geography.census_division
ORDER BY ae_cd_proportional
LIMIT 1;

-- Crops --

-- total area of crop grown in 2011 in hectares--
SELECT year,cropid, area 
FROM agriculture.crop_statistics
WHERE year = '2011'
ORDER BY year;

-- LARGEST CROP GROWN BY AREA IN 2011--
SELECT cropid, year, agriculture.crop_type.name, area 
FROM agriculture.crop_statistics
INNER JOIN agriculture.crop_type
ON agriculture.crop_statistics.cropid = agriculture.crop_type.id
WHERE year ='2011'
ORDER BY area DESC
LIMIT 1;

--largest crop grown by area in the maritimes in 2016--
SELECT cropid, year, agriculture.crop_type.name, area 
FROM agriculture.crop_statistics
INNER JOIN agriculture.crop_type
ON agriculture.crop_statistics.cropid = agriculture.crop_type.id
WHERE year ='2016'
ORDER BY area DESC
LIMIT 1;

-- Crop Areas --
-- census area that grew the largest area of potatoes in 2011--
SELECT cd.cdname,cd.cduid, cs.cropid, SUM(cs.area) AS potatoes_area
FROM agriculture.crop_statistics AS cs,
	 agriculture.crop_type AS ct,
	 geography.census_consolidated_subdivision AS ccs,
     geography.census_division AS cd		 
WHERE ccs.cduid = cd.cduid AND cs.cropid= ct.id AND year = 2011 AND ct.name = 'Potatoes' AND cs.ccsuid =ccs.ccsuid
GROUP BY cd.cduid,cs.cropid 
ORDER BY potatoes_area DESC
LIMIT 1

--census area that grew the largest area of potatoes in 2016--
SELECT cd.cdname,cd.cduid, cs.cropid, SUM(cs.area) AS potatoes_area
FROM agriculture.crop_statistics AS cs,
	 agriculture.crop_type AS ct,
	 geography.census_consolidated_subdivision AS ccs,
     geography.census_division AS cd		 
WHERE ccs.cduid = cd.cduid AND cs.cropid= ct.id AND year = 2016 AND ct.name = 'Potatoes' AND cs.ccsuid =ccs.ccsuid
GROUP BY cd.cduid,cs.cropid 
ORDER BY potatoes_area DESC
LIMIT 1

-- largest area of total corn in 2011 --
SELECT cd.cdname, cces.sum/(ST_Area(cd.aeboundary)/10000) AS corn_proportion
FROM geography.census_division AS cd,(SELECT ccs.cduid, SUM(cs.area)
	  FROM geography.census_consolidated_subdivision AS ccs, agriculture.crop_statistics AS cs,
	       agriculture.crop_type AS ct
	  WHERE cs.cropid= ct.id AND cs.ccsuid =ccs.ccsuid AND ct.name  ='Total corn' AND year = '2011'
	  GROUP BY ccs.cduid) AS cces
WHERE  cces.cduid = cd.cduid 
ORDER BY corn_proportion DESC
LIMIT 1;
	  

-- total area of crop grown in 2011 in hectares--
SELECT year, SUM(area) AS hectares
FROM agriculture.crop_statistics
WHERE year = 2011
GROUP BY year;
