--- 1

ALTER TABLE t2018_kar_buildings
  ALTER COLUMN geom
    TYPE geometry(Multipolygon, 4326)
    USING ST_SetSRID(geom, 4326);
	
ALTER TABLE t2019_kar_buildings
  ALTER COLUMN geom
    TYPE geometry(Multipolygon, 4326)
    USING ST_SetSRID(geom, 4326);

SELECT * 
INTO Zadanie_1
FROM t2019_kar_buildings
WHERE NOT EXISTS (
SELECT polygon_id FROM t2018_kar_buildings
WHERE t2018_kar_buildings.geom = t2019_kar_buildings.geom)

SELECT * FROM Zadanie_1

---- 2

SELECT *
INTO Zadanie_2
FROM t2019_kar_poi_table
WHERE NOT EXISTS (
SELECT poi_id FROM t2018_kar_poi_table
WHERE t2018_kar_poi_table.geom = t2019_kar_poi_table.geom)

SELECT Zadanie_2.type, ST_DistanceSphere(Zadanie_1.geom, Zadanie_2.geom) AS odleglosc
INTO Zadanie_2_final
FROM Zadanie_1, Zadanie_2

SELECT count(*) FROM Zadanie_2_final
WHERE odleglosc<500

SELECT type, Count(type) FROM Zadanie_2_final
WHERE odleglosc<500
GROUP BY type

----3


SELECT * 
INTO streets_reprojected
FROM T2019_KAR_STREETS

ALTER TABLE streets_reprojected
  ALTER COLUMN geom
    TYPE geometry(MultiLineString, 3068)
    USING ST_SetSRID(geom, 3068);


--- 4

CREATE TABLE input_points(
points_id INTEGER,
geom GEOMETRY
);

INSERT INTO input_points(points_id, geom) VALUES 
(1, ST_geomFROMtext('Point(8.36093 49.03174)', 4326)),
(2, ST_geomFROMtext('Point(8.39876 49.00644)', 4326))


-- 5

ALTER TABLE input_points
  ALTER COLUMN geom
    TYPE geometry(Point, 3068)
    USING ST_SetSRID(geom, 3068);


SELECT ST_AStext(geom) FROM input_points
 --6

ALTER TABLE T2019_kar_STREET_NODE
  ALTER COLUMN geom
    TYPE geometry(Point, 4326)
    USING ST_SetSRID(geom, 4326);

ALTER TABLE input_points
  ALTER COLUMN geom
    TYPE geometry(Point, 4326)
    USING ST_SetSRID(geom, 4326);

SELECT st_makeline(
((SELECT input_points.geom FROM input_points
	 WHERE points_id = 1)),
((SELECT input_points.geom FROM input_points
	 WHERE points_id = 2)))
	 INTO Zadanie_6


SELECT *, st_distancesphere(Zadanie_6.st_makeline, T2019_kar_STREET_NODE.geom) AS odleglosc
INTO Zadanie_6_final
	FROM Zadanie_6, T2019_kar_STREET_NODE
	GROUP BY t2019_kar_street_node.gid, zadanie_6.st_makeline


SELECT * FROM Zadanie_6_final
WHERE odleglosc<200


--7


SELECT t2019_kar_poi_table.gid AS poi_gid, t2019_kar_LAND_USE_A.gid AS land_gid, st_distancesphere(t2019_kar_poi_table.geom, t2019_kar_LAND_USE_A.geom) AS odleglosc
INTO Zadanie_7_final
	FROM t2019_kar_poi_table, t2019_kar_LAND_USE_A
	WHERE t2019_kar_poi_table.type = 'Sporting Goods Store' AND
 t2019_kar_LAND_USE_A.type = 'Park (City/County)' 


SELECT * FROM Zadanie_7_final
WHERE odleglosc<300 
ORDER BY poi_gid ASC

--8

SELECT st_AStext((st_intersection(t2019_kar_water_lines.geom, t2019_kar_railways.geom))) FROM
t2019_kar_water_lines, t2019_kar_railways
GROUP BY st_AStext


