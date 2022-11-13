CREATE TABLE obiekty
(id INT PRIMARY KEY, 
 geom GEOMETRY,
 nazwa VARCHAR(20))


INSERT INTO obiekty(id, geom, nazwa)
VALUES
(1, St_GeomFromEWKT('MULTICURVE(
					LINESTRING(0 1, 1 1),
					CIRCULARSTRING(1 1, 2 0, 3 1),
					CIRCULARSTRING(3 1, 4 2, 5 2), 
					LINESTRING(5 1, 6 1))'), 'obiekt1')
					
INSERT INTO obiekty(id, geom, nazwa) 
VALUES
(2,ST_GeomFromEWKT('CURVEPOLYGON(COMPOUNDCURVE(
				   	LINESTRING(10 6, 14 6), 
				   	CIRCULARSTRING(14 6, 16 4, 14 2), 
					CIRCULARSTRING(14 2, 12 0, 10 2),
				   	LINESTRING(10 2, 10 6)),
				   	CIRCULARSTRING(11 2, 13 2, 11 2))'), 'obiekt2')

INSERT INTO obiekty(id, geom, nazwa) 
VALUES
(3,ST_GeomFromEWKT('MULTILINESTRING((7 15, 10 17, 12 13, 7 15))'), 'obiekt3')

INSERT INTO obiekty(id, geom, nazwa) 
VALUES
(4,ST_GeomFromEWKT('MULTILINESTRING(
				   	(20 20, 25 25), 
				   	(25 25, 27 24), 
				  	(27 24, 25 22), 
					(25 22, 26 21), 
				   	(26 21, 22 19), 
				   	(22 19, 20.5 19.5))'),'obiekt4')

INSERT INTO obiekty(id, geom, nazwa) 
VALUES
(5,ST_GeomFromEWKT('MULTIPOINTM((30 30 59),
						 (38 32 234))'),'obiekt5')
						 
						 
INSERT INTO obiekty(id, geom, nazwa)
VALUES
(6,ST_GeomFromEWKT('GEOMETRYCOLLECTION(LINESTRING(1 1, 3 2), POINT(4 2))'),'obiekt6')
		

-- 1
SELECT st_area(st_buffer(st_shortestline(
(SELECT geom FROM obiekty WHERE id = 3), 
(SELECT geom FROM obiekty WHERE id = 4)
), 5))


-- 2


UPDATE obiekty
SET id = 4, geom = (st_makepolygon(st_addpoint(ST_LineMerge(geom), st_startpoint(ST_LineMerge(geom))))), nazwa = 'obiekt4'
WHERE id = 4


-- 3

INSERT INTO obiekty(id, geom, nazwa)
VALUES
(7,  ST_Collect(
    (SELECT geom FROM obiekty WHERE id = 3),
    (SELECT geom FROM obiekty WHERE id = 4)), 'obiekt7')

-- 4


SELECT SUM(ST_Area(ST_Buffer(obiekty.geom, 5))) FROM obiekty 
WHERE ST_HasArc( obiekty.geom ) = 'False'



