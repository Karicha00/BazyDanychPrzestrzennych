--1

SELECT sum(trees.area_km2) FROM trees
WHERE trees.vegdesc='Mixed Trees';

-- 3
SELECT sum(st_length(st_intersection(railroads.geom, regions.geom)))FROM railroads, regions
WHERE name_2 = 'Matanuska-Susitna'

-- 4

SELECT avg(elev) FROM airports
WHERE use = 'Military'

--5
SELECT popp.gid, popp.cat, popp.f_codedesc, popp.f_code, popp.type, popp.geom
INTO Buildings_Bristol_Bay
FROM popp, regions
WHERE st_contains(regions.geom, popp.geom) AND  popp.f_codedesc = 'Building' AND regions.name_2 = 'Bristol Bay'
--6

SELECT st_distance(Buildings_Bristol_Bay.geom, rivers.geom), Buildings_Bristol_Bay.gid AS building_gid, rivers.gid AS river_gid, Buildings_Bristol_Bay.geom
INTO Buildings_Bristol_Bay_100km_river
FROM Buildings_Bristol_Bay
JOIN rivers 
ON st_dwithin(rivers.geom, Buildings_bristol_bay.geom, 100000)

-- 7

SELECT sum(st_npoints(st_intersection(majrivers.geom, railroads.geom))), st_intersection(majrivers.geom, railroads.geom)
FROM majrivers, railroads
GROUP  BY st_intersection

--8

SELECT sum(st_npoints(railroads.geom))
INTO tabela_z_wynikiem
FROM railroads


--9

SELECT st_intersection
(ST_difference(st_buffer(airports.geom, 100000), st_buffer(railroads.geom,50000)),
(st_buffer(trails.geom, 10000))) 
INTO hotel_area
FROM airports, railroads, trails

--10 


SELECT  sum(st_npoints(swamp.geom)),  sum(st_area(swamp.geom))
FROM swamp


SELECT  sum(st_npoints(st_simplify(swamp.geom, 100))), sum(st_area(st_simplify(swamp.geom, 100)))
FROM swamp

