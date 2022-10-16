CREATE EXTENSION postgis;

CREATE TABLE budynki(
    id_budynku INTEGER PRIMARY KEY,
    geometria GEOMETRY,
    nazwa VARCHAR,
	wysokosc INTEGER
);

CREATE TABLE drogi(
    id_drogi INTEGER PRIMARY KEY,
    geometria GEOMETRY,
    nazwa VARCHAR
);

CREATE TABLE pktinfo(
    id_pktinfo INTEGER PRIMARY KEY,
    geometria GEOMETRY,
    nazwa VARCHAR,
	liczprac INTEGER
);

	
INSERT INTO budynki(id_budynku, geometria, nazwa, wysokosc) VALUES
	(1, ST_GeomFromText('POLYGON((8 4, 10.5 4, 10.5 1.5, 8 1.5, 8 4))') , 'A', '25'),
	(2, ST_GeomFromText('POLYGON((4 7, 6 7, 6 5, 4 5, 4 7))') , 'B', '30'),
	(3, ST_GeomFromText('POLYGON((3 8, 5 8, 5 6, 3 6, 3 8))') , 'C', '15'),
	(4, ST_GeomFromText('POLYGON((9 9, 10 9, 10 8, 9 8, 9 9))') , 'D', '40'),
	(5, ST_GeomFromText('POLYGON((1 2, 2 2, 2 1, 1 1, 1 2))') , 'F', '40');

INSERT INTO drogi(id_drogi, geometria, nazwa) VALUES
	(1, ST_GeomFromText('LINESTRING(0 4.5, 12 4.5)',0), 'X'),
	(2, ST_GeomFromText('LINESTRING(7.5 10.5, 7.5 0)',0), 'Y');

INSERT INTO pktinfo(id_pktinfo, geometria, nazwa, liczprac) VALUES
	(1, ST_GeomFromText('POINT(1 3.5)'), 'G', 5),
	(2, ST_GeomFromText('POINT(5.5 1.5)'), 'H', 10),
	(3, ST_GeomFromText('POINT(9.5 6)'), 'I', 12),
	(4, ST_GeomFromText('POINT(6.5 6)'), 'J', 16),
	(5, ST_GeomFromText('POINT(6 9.5)'), 'K', 21);


-- 1. Wyznacz całkowitą długość dróg w analizowanym mieście. 

SELECT SUM(st_length(geometria)) FROM drogi;

-- 2. Wypisz geometrię (WKT), pole powierzchni oraz obwód poligonu reprezentującego BuildingA. 

SELECT st_astext(Geometria), st_area(Geometria), st_perimeter(Geometria) FROM budynki
WHERE nazwa='A'
 
 -- 3. Wypisz nazwy i pola powierzchni wszystkich poligonów w warstwie budynki. Wyniki posortuj alfabetycznie.
 
SELECT nazwa, st_area(Geometria) FROM budynki
ORDER BY nazwa ASC

-- 4. Wypisz nazwy i obwody 2 budynków o największej powierzchni. 

SELECT nazwa, st_perimeter(Geometria) FROM budynki
ORDER BY st_perimeter DESC
LIMIT  2

-- 5. Wyznacz najkrótszą odległość między budynkiem BuildingC a punktem G. 


SELECT st_distance(budynki.Geometria, pktinfo.Geometria)
FROM budynki, pktinfo
WHERE budynki.nazwa = 'C' AND pktinfo.nazwa = 'G'

-- 6. Wypisz pole powierzchni tej części budynku BuildingC, która znajduje się w odległości większej 
-- niż 0.5 od budynku BuildingB

SELECT st_area(st_difference(
    (SELECT budynki.geometria FROM budynki WHERE budynki.nazwa = 'C'),
    st_buffer(budynki.geometria, 0.5)
    ))
FROM budynki WHERE budynki.nazwa ='B';


-- 7. Wybierz te budynki, których centroid (ST_Centroid) znajduje się powyżej drogi RoadX.

SELECT budynki.nazwa FROM budynki, drogi
WHERE st_y(st_centroid(budynki.geometria)) > st_y(st_centroid(drogi.geometria))
		   AND drogi.nazwa = 'X'


-- 8. Oblicz pole powierzchni tych części budynku BuildingC i poligonu o współrzędnych (4 7, 6 7, 6 8, 
-- 4 8, 4 7), które nie są wspólne dla tych dwóch obiektów.
SELECT st_area(st_symdifference((
	SELECT budynki.geometria FROM budynki WHERE budynki.nazwa = 'C'), ('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))')))

