--4

SELECT COUNT(popp.geom), popp.geom
INTO tableB
FROM popp
JOIN majrivers ON st_dwithin(popp.geom, majrivers.geom, 1000)
WHERE popp.f_codedesc = 'Building'
GROUP BY popp.geom

SELECT COUNT(geom)
FROM tableB




--5
SELECT airports.name, airports.geom, airports.elev
INTO airportsNew
FROM airports


------ a
-- zachód
SELECT airportsNew.name, st_x(airportsNew.geom) FROM airportsNew
ORDER BY st_x DESC LIMIT 1




-- wschód
SELECT airportsNew.name, st_x(airportsNew.geom) FROM airportsNew
ORDER BY st_x ASC LIMIT 1

------- b
INSERT INTO airportsNew VALUES
('airportB', (SELECT st_centroid(st_shortest_line(
	(SELECT airportsNew.geom FROM airportsNew
ORDER BY st_x(airportsNew.geom) ASC LIMIT 1), (SELECT airportsNew.geom FROM airportsNew
ORDER BY st_x(airportsNew.geom) DESC LIMIT 1)))), 937)

SELECT st_x(geom), st_y(geom), * FROM airportsNew
WHERE name = 'airportB'

--6
SELECT st_area(st_buffer(st_shortestline(
(SELECT lakes.geom FROM lakes WHERE lakes.names = 'Iliamna Lake'),
(SELECT airportsNew.geom FROM airportsNew WHERE airportsNew.name = 'AMBLER')), 1000))
	
--7

SELECT SUM(st_area(trees.geom)), trees.vegdesc
FROM trees, swamp, tundra
WHERE st_contains(trees.geom, swamp.geom) OR st_contains(trees.geom, tundra.geom)
GROUP BY trees.vegdesc

