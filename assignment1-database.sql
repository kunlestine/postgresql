CREATE EXTENSION postgis;

-- creating a schema--

CREATE SCHEMA geography;

-- create table named as census_division--
CREATE TABLE geography.census_division(
    cduid numeric(4) primary key,
	cdname varchar(100),
	cdboundary geometry(Geometry,3348),
	aeboundary geometry(Geometry, 3348)
);

-- creating table named as consolidated_subdivision--
CREATE TABLE geography.census_consolidated_subdivision(
	ccsuid numeric(7) primary key,
	ccsname varchar(100),
	cduid numeric(4) references geography.census_division(cduid)
);

CREATE SCHEMA agriculture;

-- creating table for agriculture_crop--
CREATE TABLE agriculture.crop_type(
	id numeric(2) primary key,
	name varchar(200)
);

-- creating a table called crop_statistics--
CREATE TABLE agriculture.crop_statistics(
	ccsuid numeric(7) references geography.census_consolidated_subdivision(ccsuid),
	year numeric(4),
	cropid numeric(2) references agriculture.crop_type(id),
	area numeric(4),
	farms_reporting numeric(3),
	primary key (ccsuid,year,cropid)
);
