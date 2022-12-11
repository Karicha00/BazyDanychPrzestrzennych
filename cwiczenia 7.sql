
-- 2 

--  "C:\Program Files\PostgreSQL\14\bin\raster2pgsql.exe" -s 27700 -N -32767 -t 4000x4000 -I -C -M -d C:\Users\Kacper\Desktop\Bazy_danych\Bazy_danych_przestrzennych\cwiczenia_7\ras250_gb\data\* public.uk_250k | "C:\Program Files\PostgreSQL\14\bin\psql.exe" -d Cwiczenia_7 -h localhost -U postgres -p 5432

-- 3
CREATE TABLE  mosaic_1 as
select st_union(rast)
FROM uk_250k
WHERE rid <= 35

CREATE TABLE mosaic_2 as
SELECT st_union(rast)
FROM uk_250k
WHERE rid > 35

-- ponieważ nie byłem w stanie wczytać całości naraz

CREATE TABLE tmp_out1 AS
SELECT lo_from_bytea(0,
ST_AsGDALRaster(st_union, 'GTiff')
) AS loid
FROM mosaic_1;
----------------------------------------------
SELECT lo_export(loid, 'C:\Users\Kacper\Desktop\Bazy_danych\Bazy_danych_przestrzennych\cwiczenia_7\raster_250k_1.tiff')
FROM tmp_out1;
----------------------------------------------
SELECT lo_unlink(loid)
FROM tmp_out1; 



CREATE TABLE tmp_out2 AS
SELECT lo_from_bytea(0,
ST_AsGDALRaster(st_union, 'GTiff')
) AS loid
FROM mosaic_2;
----------------------------------------------
SELECT lo_export(loid, 'C:\Users\Kacper\Desktop\Bazy_danych\Bazy_danych_przestrzennych\cwiczenia_7\raster_250k_2.tiff')
FROM tmp_out2;
----------------------------------------------
SELECT lo_unlink(loid)
FROM tmp_out2; 


-- 5

-- wyeksportowane .shp przy pomocy Qgisa
-- "C:\Program Files\PostgreSQL\14\bin\shp2pgsql.exe" -s 27700 "C:\Users\Kacper\Desktop\Bazy_danych\Bazy_danych_przestrzennych\cwiczenia_7\parks.shp" public.parks | "C:\Program Files\PostgreSQL\14\bin\psql.exe" -d Cwiczenia_7 -h localhost -U postgres -p 5432



-- 6
CREATE TABLE  uk_lake_district as
SELECT ST_Union(ST_Clip(uk_250k.rast, parks.geom, true))
FROM uk_250k, parks
WHERE ST_Intersects(uk_250k.rast, parks.geom) AND parks.id = 1



select ST_Intersects(uk_250k.rast, parks.geom)
from uk_250k, parks

-- 7
CREATE TABLE tmp_out3 AS
SELECT lo_from_bytea(0,
ST_AsGDALRaster(st_union, 'GTiff')
) AS loid
FROM uk_lake_district;
----------------------------------------------
SELECT lo_export(loid, 'C:\Users\Kacper\Desktop\Bazy_danych\Bazy_danych_przestrzennych\cwiczenia_7\raster_lake_district.tiff')
FROM tmp_out3;
----------------------------------------------
SELECT lo_unlink(loid)
FROM tmp_out3; 


-- 9

-- wyeksportowane do .tif oraz zmienione SRID na 27700 przy pomocy Qgisa
-- "C:\Program Files\PostgreSQL\14\bin\raster2pgsql.exe" -s 27700 -N -32767 -t 9000x9000 -I -C -M -d D:\BDP_dane\sentinel_1_b03.tif public.sentinel_1_b03 | "C:\Program Files\PostgreSQL\14\bin\psql.exe" -d Cwiczenia_7 -h localhost -U postgres -p 5432
-- inne analogicznie 


-- 10 
	  
CREATE TABLE NDWI_1 AS
WITH r AS (
SELECT st_union(ST_Clip(sentinel_1_b03.rast, parks.geom,true)) AS b03_clip,
		st_union(ST_Clip(sentinel_1_b08.rast, parks.geom,true)) AS b08_clip
FROM sentinel_1_b03, sentinel_1_b08, parks 
WHERE (ST_Intersects(sentinel_1_b03.rast, parks.geom) AND ST_Intersects(sentinel_1_b08.rast, parks.geom))  and parks.id = 1
)
SELECT
ST_MapAlgebra(
r.b08_clip,
r.b03_clip, 
'([rast2.val] - [rast1.val]) / ([rast2.val] +
[rast1.val])::float','32BF'
) AS rast
FROM r;

--------

CREATE TABLE NDWI_2 AS
WITH r AS (
SELECT st_union(ST_Clip(sentinel_2_b03.rast, parks.geom,true)) AS b03_clip,
		st_union(ST_Clip(sentinel_2_b08.rast, parks.geom,true)) AS b08_clip
FROM sentinel_2_b03, sentinel_2_b08, parks 
WHERE (ST_Intersects(sentinel_2_b03.rast, parks.geom) AND ST_Intersects(sentinel_2_b08.rast, parks.geom))  and parks.id = 1
)
SELECT
ST_MapAlgebra(
r.b08_clip,
r.b03_clip, 
'([rast2.val] - [rast1.val]) / ([rast2.val] +
[rast1.val])::float','32BF'
) AS rast
FROM r;

-- 11

CREATE TABLE tmp_out4 AS
SELECT lo_from_bytea(0,
ST_AsGDALRaster(rast, 'GTiff')
) AS loid
FROM NDWI_1;
----------------------------------------------
SELECT lo_export(loid, 'C:\Users\Kacper\Desktop\Bazy_danych\Bazy_danych_przestrzennych\cwiczenia_7\ndwi_1.tiff')
FROM tmp_out4;
----------------------------------------------
SELECT lo_unlink(loid)
FROM tmp_out4; 

------------

CREATE TABLE tmp_out5 AS
SELECT lo_from_bytea(0,
ST_AsGDALRaster(rast, 'GTiff')
) AS loid
FROM NDWI_2;
----------------------------------------------
SELECT lo_export(loid, 'C:\Users\Kacper\Desktop\Bazy_danych\Bazy_danych_przestrzennych\cwiczenia_7\ndwi_2.tiff')
FROM tmp_out5;
----------------------------------------------
SELECT lo_unlink(loid)
FROM tmp_out5; 




