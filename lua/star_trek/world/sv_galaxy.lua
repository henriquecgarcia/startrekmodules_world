---------------------------------------
---------------------------------------
--         Star Trek Modules         --
--                                   --
--            Created by             --
--       Jan 'Oninoni' Ziegler       --
--                                   --
-- This software can be used freely, --
--    but only distributed by me.    --
--                                   --
--    Copyright © 2020 Jan Ziegler   --
---------------------------------------
---------------------------------------

---------------------------------------
--      Default Galaxy | Server      --
---------------------------------------

-- Adding the map ship.
-- An Intrepid class vessel, that is represented by the map.
-- The ship spawns in standard orbit around the given object.
--
-- @param Number parentId
-- @return Boolean success
-- @return String error
function Star_Trek.World:AddMapShip(parentId)
	local parentEnt = self.Entities[parentId]
	if not istable(parentEnt)	then 
		ErrorNoHaltWithStack("AddMapShip failed: Parent entity not found (ID: " .. tostring(parentId) .. ")")
		return false, "Parent entity not found" 
	end

	local model = "models/kingpommes/startrek/intrepid/intrepid_sky_1024.mdl"
	local modelSize = Star_Trek.World:GetModelDiameter(model)

	local success, mapShip = Star_Trek.World:LoadEntity(1, "ship", parentEnt:GetStandardOrbit(), Angle(), model, modelSize)
	if not success then
		ErrorNoHaltWithStack("AddMapShip failed: Could not load entity - " .. tostring(mapShip))
		return false, mapShip
	end
	
	self.MapShip = mapShip
	print("Map ship successfully created with ID 1")

	--Star_Trek.World:LoadEntity(-1, "beam", WorldVector(0, 0, 0, M(145), 0, M(8.5)), Angle(), KM(10), 1, "sprites/tp_beam001", Color(255, 0, 0, 127), 0.4, 4, 0.5)
	--Star_Trek.World:LoadEntity(-2, "beam", WorldVector(0, 0, 0, M(20), 0, -M(15)),  Angle(), KM(10), 1, "sprites/tp_beam001", Color(0, 255, 0, 127), 0.6, 8, -0.5)
	
	return true, mapShip
end

-- Load the default galaxy.
function Star_Trek.World:LoadDefaultGalaxy()
	local systems_data = {
		-- ANCHOR POINTS (FIXED COORDINATES)
		{
			name = "Sol", x = LY(0), y = LY(0),
			objects = {
				{Name = "Sun", Class = "sun", Diameter = KM(1392700), LightColor = Vector(255, 255, 230)},
				{Name = "Mercury", Class = "planet", OrbitRadius = AU(0.39), Model = "models/planets/mercury.mdl", Diameter = KM(4880)},
				{Name = "Venus", Class = "planet", OrbitRadius = AU(0.72), Model = "models/planets/venus.mdl", Diameter = KM(12104)},
				{Name = "Earth", Class = "planet", OrbitRadius = AU(1), Model = "models/planets/earth.mdl", Diameter = KM(12742)},
				{Name = "Moon", ParentName = "Earth", Class = "planet", OrbitRadius = KM(384400), Model = "models/planets/luna_small.mdl", Diameter = KM(3475)},
				{Name = "Earth Space Dock", ParentName = "Earth", Class = "base", OrbitRadius = KM(36000), Model = "models/crazycanadian/star_trek/stations/spacedock.mdl", Diameter = KM(5)},
				{Name = "Mars", Class = "planet", OrbitRadius = AU(1.52), Model = "models/planets/mars.mdl", Diameter = KM(6780)},
				{Name = "Utopia Planitia Shipyards", ParentName = "Mars", Class = "base", OrbitRadius = KM(20000), Model = "models/star_trek/stations/utopiaplanitia.mdl", Diameter = KM(4.5)},
				{Name = "Phobos", ParentName = "Mars", Class = "planet", OrbitRadius = KM(9376), Model = "models/crazycanadian/space/sol/phobos.mdl", Diameter = KM(22.5)},
				{Name = "Deimos", ParentName = "Mars", Class = "planet", OrbitRadius = KM(23463), Model = "models/crazycanadian/space/sol/deimos.mdl", Diameter = KM(12.6)},
				{Name = "Jupiter", Class = "planet", OrbitRadius = AU(5.20), Model = "models/planets/jupiter.mdl", Diameter = KM(139822)},
				{Name = "Io", ParentName = "Jupiter", Class = "planet", OrbitRadius = KM(422000), Model = "models/planets/io.mdl", Diameter = KM(3643.2)},
				{Name = "Europa", ParentName = "Jupiter", Class = "planet", OrbitRadius = KM(671000), Model = "models/crazycanadian/space/sol/europa.mdl", Diameter = KM(3121.6)},
				{Name = "Ganymede", ParentName = "Jupiter", Class = "planet", OrbitRadius = KM(1070000), Model = "models/crazycanadian/space/sol/ganymede.mdl", Diameter = KM(5268.2)},
				{Name = "Callisto", ParentName = "Jupiter", Class = "planet", OrbitRadius = KM(1880000), Model = "models/planets/callisto.mdl", Diameter = KM(4800.6)},
				{Name = "Saturn", Class = "planet", OrbitRadius = AU(9.58), Model = "models/planets/saturn.mdl", Diameter = KM(116464)},
				{Name = "Titan", ParentName = "Saturn", Class = "planet", OrbitRadius = KM(1221870), Model = "models/planets/titan.mdl", Diameter = KM(5150)},
				{Name = "Enceladus", ParentName = "Saturn", Class = "planet", OrbitRadius = KM(238020), Model = "models/planets/enceladus.mdl", Diameter = KM(504.2)},
				{Name = "Mimas", ParentName = "Saturn", Class = "planet", OrbitRadius = KM(185520), Model = "models/planets/mimas.mdl", Diameter = KM(396.4)},
				{Name = "Uranus", Class = "planet", OrbitRadius = AU(19.20), Model = "models/planets/uranus.mdl", Diameter = KM(50724)},
				{Name = "Neptune", Class = "planet", OrbitRadius = AU(30.05), Model = "models/planets/neptune.mdl", Diameter = KM(49244)},
				{Name = "Triton", ParentName = "Neptune", Class = "planet", OrbitRadius = KM(354800), Model = "models/planets/triton.mdl", Diameter = KM(2706.8)},
			}
		},

		-- FEDERATION CORE SYSTEMS (Near Sol)
		{
			name = "Vulcan", x = LY(-7.02), y = LY(14.92), -- Canon distance ~16.5 LY (40 Eridani A from Sol, Memory Alpha); bearing preserved
			objects = {
				{Name = "40 Eridani A", Class = "sun", Diameter = KM(1130872.4), LightColor = Vector(255, 179, 102)},
				{Name = "Vulcan", Class = "planet", OrbitRadius = AU(0.6), Model = "models/planets/vulcan.mdl", Diameter = KM(15720)},
				{Name = "T'Khut", Class = "planet", OrbitRadius = AU(0.6), Model = "models/planets/mars.mdl", Diameter = KM(11500)},
				{Name = "Delta Vega", Class = "planet", OrbitRadius = AU(2.2), Model = "models/planets/luna_small.mdl", Diameter = KM(2000)},
				{Name = "40 Eridani B", Class = "sun", OrbitRadius = AU(35), Diameter = KM(19497.8), LightColor = Vector(230, 230, 255)},
				{Name = "40 Eridani C", ParentName = "40 Eridani B", Class = "sun", OrbitRadius = AU(4), Diameter = KM(431737), LightColor = Vector(255, 102, 51)},
			}
		},
		{
			name = "Andoria", x = LY(1.91), y = LY(10.82), -- Canon distance ~11 LY from Sol (Memory Alpha); bearing preserved
			objects = {
				{Name = "Procyon A", Class = "sun", Diameter = KM(2855035), LightColor = Vector(255, 255, 230)},
				{Name = "Procyon B", Class = "sun", OrbitRadius = AU(15), Diameter = KM(16712.4), LightColor = Vector(230, 230, 255)},
				{Name = "Andoria Major", Class = "planet", OrbitRadius = AU(2.1), Model = "models/planets/jupiter.mdl", Diameter = KM(150000)},
				{Name = "Andor", ParentName = "Andoria Major", Class = "planet", OrbitRadius = KM(500000), Model = "models/planets/andor.mdl", Diameter = KM(4870)},
			}
		},
		{
			name = "Tellar", x = LY(-4.16), y = LY(10.18), -- Canon distance ~11 LY from Sol (Memory Alpha Tellar Prime); bearing preserved
			objects = {
				{Name = "61 Cygni A", Class = "sun", Diameter = KM(926145.5), LightColor = Vector(255, 179, 102)},
				{Name = "61 Cygni B", Class = "sun", OrbitRadius = AU(86), Diameter = KM(828656.5), LightColor = Vector(255, 179, 102)},
				{Name = "Tellar Prime", Class = "planet", OrbitRadius = AU(0.6), Model = "models/planets/earth.mdl", Diameter = KM(13000)},
				{Name = "Tellar Prime Moon 1", ParentName = "Tellar Prime", Class = "planet", OrbitRadius = KM(300000), Model = "models/planets/moon.mdl", Diameter = KM(1000)},
				{Name = "Tellar Prime Moon 2", ParentName = "Tellar Prime", Class = "planet", OrbitRadius = KM(450000), Model = "models/planets/moon.mdl", Diameter = KM(1200)},
			}
		},
		{
			name = "Alpha Centauri", x = LY(-3.04), y = LY(3.14), -- Canon distance 4.37 LY from Sol (real astronomical; cited on Memory Alpha); bearing preserved
			objects = {
				{Name = "Rigel Kentaurus (Alpha Centauri A)", Class = "sun", Diameter = KM(1700000), LightColor = Vector(255, 255, 230)},
				{Name = "Toliman (Alpha Centauri B)", Class = "sun", OrbitRadius = AU(23.4), Diameter = KM(1200000), LightColor = Vector(255, 179, 102)},
				{Name = "Proxima Centauri", Class = "sun", OrbitRadius = AU(12950), Diameter = KM(202000), LightColor = Vector(255, 102, 51)},
				{Name = "Alpha Centauri IV", Class = "planet", OrbitRadius = AU(1.25), Model = "models/planets/earth.mdl", Diameter = KM(13000)},
			}
		},
		{
			name = "Betazed", x = LY(15.3), y = LY(-8.2), -- Adjusted to match map distance
			objects = {
				{Name = "Beta Zeta", Class = "sun", Diameter = KM(950000), LightColor = Vector(255, 230, 179)},
				{Name = "Betazed", Class = "planet", OrbitRadius = AU(0.9), Model = "models/planets/earth.mdl", Diameter = KM(12700)},
			}
		},
		{
			name = "Trill", x = LY(22.1), y = LY(8.3), -- Adjusted to match map distance
			objects = {
				{Name = "Trill Star", Class = "sun", Diameter = KM(1000000), LightColor = Vector(255, 179, 102)},
				{Name = "Trill", Class = "planet", OrbitRadius = AU(1.1), Model = "models/planets/earth.mdl", Diameter = KM(12600)},
				{Name = "Trill Moon", ParentName = "Trill", Class = "planet", OrbitRadius = KM(380000), Model = "models/planets/moon.mdl", Diameter = KM(1500)},
			}
		},
		{
			name = "Wolf 359", x = LY(6), y = LY(6),
			objects = {
				{Name = "Wolf 359", Class = "sun", Diameter = KM(222832), LightColor = Vector(255, 102, 51)},
				{Name = "Ship Cemetery", Class = "debris_field", OrbitRadius = AU(0.5), Model = "models/effects/ship_debris.mdl", Diameter = KM(20000)},
			}
		},

		-- MAJOR FEDERATION SYSTEMS
		{
			name = "Rigel", x = LY(25), y = LY(12),
			objects = {
				{Name = "Beta Rigel", Class = "sun", Diameter = KM(1750000), LightColor = Vector(255, 255, 240)},
				{Name = "Rigel II", Class = "planet", OrbitRadius = AU(0.8), Model = "models/planets/earth.mdl", Diameter = KM(12000)},
				{Name = "Rigel III", Class = "planet", OrbitRadius = AU(1.1), Model = "models/planets/earth.mdl", Diameter = KM(13200)},
				{Name = "Rigel IV", Class = "planet", OrbitRadius = AU(1.5), Model = "models/planets/earth.mdl", Diameter = KM(12800)},
				{Name = "Rigel V", Class = "planet", OrbitRadius = AU(2.0), Model = "models/planets/earth.mdl", Diameter = KM(13500)},
				{Name = "Rigel VI", Class = "planet", OrbitRadius = AU(2.8), Model = "models/planets/mars.mdl", Diameter = KM(11000)},
				{Name = "Starbase 134", ParentName = "Rigel VI", Class = "base", OrbitRadius = KM(40000), Model = "models/star_trek/stations/starbase.mdl", Diameter = KM(3)},
			}
		},
		{
			name = "Deneb", x = LY(-18), y = LY(28),
			objects = {
				{Name = "Alpha Cygni", Class = "sun", Diameter = KM(180000000), LightColor = Vector(240, 240, 255)},
				{Name = "Deneb II", Class = "planet", OrbitRadius = AU(15), Model = "models/planets/earth.mdl", Diameter = KM(11000)},
				{Name = "Deneb IV", Class = "planet", OrbitRadius = AU(22), Model = "models/planets/earth.mdl", Diameter = KM(13000)},
				{Name = "Deneb V", Class = "planet", OrbitRadius = AU(28), Model = "models/planets/earth.mdl", Diameter = KM(12500)},
			}
		},
		{
			name = "Altair", x = LY(12), y = LY(12),
			objects = {
				{Name = "Alpha Aquilae", Class = "sun", Diameter = KM(2600000), LightColor = Vector(255, 255, 240)},
				{Name = "Altair III", Class = "planet", OrbitRadius = AU(0.9), Model = "models/planets/earth.mdl", Diameter = KM(12000)},
				{Name = "Altair IV", Class = "planet", OrbitRadius = AU(1.3), Model = "models/planets/earth.mdl", Diameter = KM(13500)},
				{Name = "Altair VI", Class = "planet", OrbitRadius = AU(2.0), Model = "models/planets/earth.mdl", Diameter = KM(12800)},
			}
		},
		{
			name = "Vega", x = LY(18), y = LY(15),
			objects = {
				{Name = "Alpha Lyrae", Class = "sun", Diameter = KM(3200000), LightColor = Vector(255, 255, 255)},
				{Name = "Vega Colony", Class = "planet", OrbitRadius = AU(1.4), Model = "models/planets/earth.mdl", Diameter = KM(13200)},
				{Name = "Vega II", Class = "planet", OrbitRadius = AU(2.1), Model = "models/planets/mars.mdl", Diameter = KM(8000)},
			}
		},
		{
			name = "Arcturus", x = LY(-25), y = LY(20),
			objects = {
				{Name = "Alpha Bootis", Class = "sun", Diameter = KM(35700000), LightColor = Vector(255, 200, 150)},
				{Name = "Arcturus IV", Class = "planet", OrbitRadius = AU(8), Model = "models/planets/earth.mdl", Diameter = KM(14000)},
			}
		},
		{
			name = "Deneva", x = LY(8), y = LY(-6),
			objects = {
				{Name = "Kappa Fornacis", Class = "sun", Diameter = KM(1400000), LightColor = Vector(255, 255, 230)},
				{Name = "Deneva", Class = "planet", OrbitRadius = AU(1.0), Model = "models/planets/earth.mdl", Diameter = KM(12900)},
			}
		},
		{
			name = "Tau Ceti", x = LY(9), y = LY(-6),
			objects = {
				{Name = "Tau Ceti", Class = "sun", Diameter = KM(1100000), LightColor = Vector(255, 255, 230)},
				{Name = "Tau Ceti III", Class = "planet", OrbitRadius = AU(0.9), Model = "models/planets/earth.mdl", Diameter = KM(12500)},
				{Name = "Tau Ceti IV", Class = "planet", OrbitRadius = AU(1.4), Model = "models/planets/earth.mdl", Diameter = KM(13000)},
			}
		},
		{
			name = "Benzar", x = LY(14), y = LY(22),
			objects = {
				{Name = "Gamma Fornacis", Class = "sun", Diameter = KM(1300000), LightColor = Vector(255, 255, 230)},
				{Name = "Benzar", Class = "planet", OrbitRadius = AU(1.1), Model = "models/planets/earth.mdl", Diameter = KM(12800)},
			}
		},
		{
			name = "Bolarus", x = LY(20), y = LY(18),
			objects = {
				{Name = "Bolarus Star", Class = "sun", Diameter = KM(1200000), LightColor = Vector(255, 255, 230)},
				{Name = "Bolarus IX", Class = "planet", OrbitRadius = AU(2.8), Model = "models/planets/earth.mdl", Diameter = KM(13200)},
			}
		},

		-- KLINGON EMPIRE
		{
			name = "Qo'noS", x = LY(45.2), y = LY(-102.4), -- Adjusted to be exactly 112 LY from Sol
			objects = {
				{Name = "Omega Sagittarii", Class = "sun", Diameter = KM(1392700), LightColor = Vector(255, 230, 179)},
				{Name = "Qo'noS", Class = "planet", OrbitRadius = AU(1.2), Model = "models/planets/qonos.mdl", Diameter = KM(19530)},
				{Name = "Praxis", ParentName = "Qo'noS", Class = "planet", OrbitRadius = KM(380000), Model = "models/planets/moon.mdl", Diameter = KM(2000)},
				{Name = "Corvix", Class = "planet", OrbitRadius = AU(2.5), Model = "models/planets/mars.mdl", Diameter = KM(8200)},
			}
		},
		{
			name = "Khitomer", x = LY(-55), y = LY(-85),
			objects = {
				{Name = "Khitomer Star", Class = "sun", Diameter = KM(1200000), LightColor = Vector(255, 179, 102)},
				{Name = "Khitomer", Class = "planet", OrbitRadius = AU(1.1), Model = "models/planets/mars.mdl", Diameter = KM(13500)},
			}
		},
		{
			name = "Boreth", x = LY(38), y = LY(-95),
			objects = {
				{Name = "Boreth Star", Class = "sun", Diameter = KM(1100000), LightColor = Vector(255, 179, 102)},
				{Name = "Boreth", Class = "planet", OrbitRadius = AU(1.0), Model = "models/planets/mars.mdl", Diameter = KM(11000)},
			}
		},
		{
			name = "Ty'Gokor", x = LY(50), y = LY(-108),
			objects = {
				{Name = "Ty'Gokor Star", Class = "sun", Diameter = KM(1250000), LightColor = Vector(255, 179, 102)},
				{Name = "Ty'Gokor", Class = "planet", OrbitRadius = AU(1.3), Model = "models/planets/mars.mdl", Diameter = KM(12000)},
			}
		},

		-- ROMULAN STAR EMPIRE
		{
			name = "Romulus", x = LY(62), y = LY(15),
			objects = {
				{Name = "Eisus", Class = "sun", Diameter = KM(1392700), LightColor = Vector(255, 230, 179)},
				{Name = "Romulus", Class = "planet", OrbitRadius = AU(1.0), Model = "models/planets/romulus.mdl", Diameter = KM(12742)},
				{Name = "Remus", Class = "planet", OrbitRadius = AU(1.8), Model = "models/planets/remus.mdl", Diameter = KM(11700)},
				{Name = "Calder II", Class = "planet", OrbitRadius = AU(0.4), Model = "models/planets/mercury.mdl", Diameter = KM(6000)},
				{Name = "Chelon", Class = "planet", OrbitRadius = AU(3.5), Model = "models/planets/jupiter.mdl", Diameter = KM(95000)},
			}
		},
		{
			name = "Nelvana", x = LY(55), y = LY(22),
			objects = {
				{Name = "Nelvana Star", Class = "sun", Diameter = KM(1150000), LightColor = Vector(255, 230, 179)},
				{Name = "Nelvana III", Class = "planet", OrbitRadius = AU(0.8), Model = "models/planets/earth.mdl", Diameter = KM(11500)},
			}
		},

		-- CARDASSIAN UNION
		{
			name = "Cardassia", x = LY(28), y = LY(-52),
			objects = {
				{Name = "Cardassia", Class = "sun", Diameter = KM(1100000), LightColor = Vector(255, 230, 179)},
				{Name = "Cardassia Prime", Class = "planet", OrbitRadius = AU(0.95), Model = "models/planets/earth.mdl", Diameter = KM(13200)},
				{Name = "Cardassia Prime Moon", ParentName = "Cardassia Prime", Class = "planet", OrbitRadius = KM(350000), Model = "models/planets/moon.mdl", Diameter = KM(1000)},
			}
		},
		{
			name = "Bajoran", x = LY(38), y = LY(-68),
			objects = {
				{Name = "B'hava'el", Class = "sun", Diameter = KM(1300000), LightColor = Vector(255, 255, 230)},
				{Name = "Bajor", Class = "planet", OrbitRadius = AU(1), Model = "models/planets/bajor.mdl", Diameter = KM(12900)},
				{Name = "Derna", ParentName = "Bajor", Class = "planet", OrbitRadius = KM(180000), Model = "models/planets/moon.mdl", Diameter = KM(1200)},
				{Name = "Rilka", ParentName = "Bajor", Class = "planet", OrbitRadius = KM(250000), Model = "models/planets/luna_small.mdl", Diameter = KM(1500)},
				{Name = "Jeraddo", ParentName = "Bajor", Class = "planet", OrbitRadius = KM(400000), Model = "models/planets/moon.mdl", Diameter = KM(900)},
				{Name = "Deep Space 9", Class = "base", OrbitRadius = AU(1.5), Model = "models/star_trek/stations/ds9.mdl", Diameter = KM(2)},
			}
		},

		-- FEDERATION BORDER & STRATEGIC SYSTEMS
		{
			name = "Ceti Alpha", x = LY(18), y = LY(-22),
			objects = {
				{Name = "Ceti Alpha", Class = "sun", Diameter = KM(1450000), LightColor = Vector(255, 255, 230)},
				{Name = "Ceti Alpha IV", Class = "planet", OrbitRadius = AU(1.2), Model = "models/planets/earth.mdl", Diameter = KM(12000)},
				{Name = "Ceti Alpha V", Class = "planet", OrbitRadius = AU(1.8), Model = "models/planets/desert.mdl", Diameter = KM(14000)},
				{Name = "Ceti Alpha VI", Class = "planet", OrbitRadius = AU(2.4), Model = "models/planets/desert.mdl", Diameter = KM(15000)},
			}
		},
		{
			name = "Sector 001 (K-7)", x = LY(-12), y = LY(-45),
			objects = {
				{Name = "G-type Star", Class = "sun", Diameter = KM(1000000), LightColor = Vector(255, 230, 179)},
				{Name = "Sherman's Planet", Class = "planet", OrbitRadius = AU(1.0), Model = "models/planets/earth.mdl", Diameter = KM(12742)},
				{Name = "Deep Space K-7", Class = "base", OrbitRadius = AU(3.0), Model = "models/star_trek/stations/k7_station.mdl", Diameter = KM(1.5)},
			}
		},
		{
			name = "Memory Alpha", x = LY(32), y = LY(28),
			objects = {
				{Name = "Memory Alpha Star", Class = "sun", Diameter = KM(1200000), LightColor = Vector(255, 255, 230)},
				{Name = "Memory Alpha", Class = "planet", OrbitRadius = AU(1.2), Model = "models/planets/earth.mdl", Diameter = KM(11000)},
			}
		},
		{
			name = "Starbase 1", x = LY(5), y = LY(8),
			objects = {
				{Name = "Starbase 1 Star", Class = "sun", Diameter = KM(1150000), LightColor = Vector(255, 255, 230)},
				{Name = "Starbase 1", Class = "base", OrbitRadius = AU(1.5), Model = "models/star_trek/stations/starbase.mdl", Diameter = KM(4)},
			}
		},
		{
			name = "Cestus", x = LY(-28), y = LY(-42),
			objects = {
				{Name = "Cestus Star", Class = "sun", Diameter = KM(1180000), LightColor = Vector(255, 255, 230)},
				{Name = "Cestus III", Class = "planet", OrbitRadius = AU(0.95), Model = "models/planets/earth.mdl", Diameter = KM(12500)},
			}
		},
		{
			name = "Regulus", x = LY(-35), y = LY(25),
			objects = {
				{Name = "Alpha Leonis", Class = "sun", Diameter = KM(5600000), LightColor = Vector(255, 230, 200)},
				{Name = "Regulus", Class = "planet", OrbitRadius = AU(2.5), Model = "models/planets/earth.mdl", Diameter = KM(13000)},
				{Name = "Regulus III", Class = "planet", OrbitRadius = AU(3.8), Model = "models/planets/earth.mdl", Diameter = KM(12200)},
				{Name = "Regulus V", Class = "planet", OrbitRadius = AU(5.2), Model = "models/planets/mars.mdl", Diameter = KM(9000)},
			}
		},
		{
			name = "Argelius", x = LY(22), y = LY(-18),
			objects = {
				{Name = "Argelius Star", Class = "sun", Diameter = KM(1100000), LightColor = Vector(255, 255, 230)},
				{Name = "Argelius II", Class = "planet", OrbitRadius = AU(0.85), Model = "models/planets/earth.mdl", Diameter = KM(11800)},
			}
		},
		{
			name = "Risa", x = LY(28), y = LY(-12),
			objects = {
				{Name = "Epsilon Ceti", Class = "sun", Diameter = KM(1250000), LightColor = Vector(255, 255, 230)},
				{Name = "Risa", Class = "planet", OrbitRadius = AU(1.0), Model = "models/planets/earth.mdl", Diameter = KM(12700)},
			}
		},
		{
			name = "Coridan", x = LY(18), y = LY(25),
			objects = {
				{Name = "Chi 1 Orionis", Class = "sun", Diameter = KM(1300000), LightColor = Vector(255, 255, 230)},
				{Name = "Coridan", Class = "planet", OrbitRadius = AU(1.1), Model = "models/planets/earth.mdl", Diameter = KM(12900)},
			}
		},
		{
			name = "Capella", x = LY(-28), y = LY(32),
			objects = {
				{Name = "Alpha Aurigae", Class = "sun", Diameter = KM(16000000), LightColor = Vector(255, 255, 200)},
				{Name = "Capella IV", Class = "planet", OrbitRadius = AU(5.0), Model = "models/planets/earth.mdl", Diameter = KM(13500)},
			}
		},
		{
			name = "Pollux", x = LY(24), y = LY(20),
			objects = {
				{Name = "Beta Geminorum", Class = "sun", Diameter = KM(12600000), LightColor = Vector(255, 200, 150)},
				{Name = "Pollux IV", Class = "planet", OrbitRadius = AU(3.5), Model = "models/planets/earth.mdl", Diameter = KM(13000)},
			}
		},

		-- MINOR POWERS & INDEPENDENT SYSTEMS
		{
			name = "Orion", x = LY(28), y = LY(15),
			objects = {
				{Name = "Rigel VIII Star", Class = "sun", Diameter = KM(1400000), LightColor = Vector(255, 230, 179)},
				{Name = "Orion (Rigel VIII)", Class = "planet", OrbitRadius = AU(2.5), Model = "models/planets/earth.mdl", Diameter = KM(13500)},
			}
		},
		{
			name = "Gorn Hegemony", x = LY(-35), y = LY(-52),
			objects = {
				{Name = "Gorn Star", Class = "sun", Diameter = KM(1350000), LightColor = Vector(255, 230, 179)},
				{Name = "Gornar", Class = "planet", OrbitRadius = AU(1.3), Model = "models/planets/mars.mdl", Diameter = KM(14000)},
			}
		},
		{
			name = "Tholian Assembly", x = LY(65), y = LY(-75),
			objects = {
				{Name = "Tholia Star", Class = "sun", Diameter = KM(1500000), LightColor = Vector(255, 150, 100)},
				{Name = "Tholia", Class = "planet", OrbitRadius = AU(0.4), Model = "models/planets/mercury.mdl", Diameter = KM(9000)},
			}
		},
		{
			name = "Breen Confederacy", x = LY(-45), y = LY(-68),
			objects = {
				{Name = "Breen Star", Class = "sun", Diameter = KM(1200000), LightColor = Vector(230, 230, 255)},
				{Name = "Breen", Class = "planet", OrbitRadius = AU(2.5), Model = "models/planets/earth.mdl", Diameter = KM(13000)},
			}
		},
		{
			name = "Ferengi Alliance", x = LY(-52), y = LY(-58),
			objects = {
				{Name = "Ferenginar Star", Class = "sun", Diameter = KM(1100000), LightColor = Vector(255, 200, 150)},
				{Name = "Ferenginar", Class = "planet", OrbitRadius = AU(1.0), Model = "models/planets/earth.mdl", Diameter = KM(12800)},
			}
		},
		{
			name = "Talos", x = LY(-42), y = LY(35),
			objects = {
				{Name = "Talos Star", Class = "sun", Diameter = KM(1250000), LightColor = Vector(255, 255, 230)},
				{Name = "Talos IV", Class = "planet", OrbitRadius = AU(1.3), Model = "models/planets/earth.mdl", Diameter = KM(12500)},
			}
		},

		-- DEEP SPACE & EXPLORATION SYSTEMS
		{
			name = "Sigma Draconis", x = LY(14), y = LY(5),
			objects = {
				{Name = "Sigma Draconis", Class = "sun", Diameter = KM(1150000), LightColor = Vector(255, 255, 230)},
				{Name = "Sigma Draconis IV", Class = "planet", OrbitRadius = AU(1.0), Model = "models/planets/earth.mdl", Diameter = KM(11500)},
				{Name = "Sigma Draconis VI", Class = "planet", OrbitRadius = AU(1.8), Model = "models/planets/earth.mdl", Diameter = KM(12000)},
			}
		},
		{
			name = "Delta Vega (Sector)", x = LY(-48), y = LY(12),
			objects = {
				{Name = "Delta Vega Star", Class = "sun", Diameter = KM(1300000), LightColor = Vector(255, 255, 230)},
				{Name = "Delta Vega", Class = "planet", OrbitRadius = AU(1.5), Model = "models/planets/mars.mdl", Diameter = KM(8500)},
			}
		},
		{
			name = "Eminiar", x = LY(32), y = LY(-28),
			objects = {
				{Name = "NGC 321", Class = "sun", Diameter = KM(1200000), LightColor = Vector(255, 255, 230)},
				{Name = "Eminiar VII", Class = "planet", OrbitRadius = AU(1.2), Model = "models/planets/earth.mdl", Diameter = KM(12700)},
			}
		},
		{
			name = "Neural", x = LY(25), y = LY(-35),
			objects = {
				{Name = "Zeta Bootis", Class = "sun", Diameter = KM(1400000), LightColor = Vector(255, 255, 230)},
				{Name = "Neural", Class = "planet", OrbitRadius = AU(1.1), Model = "models/planets/earth.mdl", Diameter = KM(12300)},
			}
		},
		{
			name = "Nimbus", x = LY(-38), y = LY(-72),
			objects = {
				{Name = "Nimbus Star", Class = "sun", Diameter = KM(1150000), LightColor = Vector(255, 230, 179)},
				{Name = "Nimbus III", Class = "planet", OrbitRadius = AU(1.0), Model = "models/planets/desert.mdl", Diameter = KM(11800)},
			}
		},
		{
			name = "Organia", x = LY(12), y = LY(-68),
			objects = {
				{Name = "Organia Star", Class = "sun", Diameter = KM(1100000), LightColor = Vector(255, 255, 230)},
				{Name = "Organia", Class = "planet", OrbitRadius = AU(1.0), Model = "models/planets/earth.mdl", Diameter = KM(12000)},
			}
		},
		{
			name = "Axanar", x = LY(-8), y = LY(-22),
			objects = {
				{Name = "Epsilon Eridani", Class = "sun", Diameter = KM(1200000), LightColor = Vector(255, 179, 102)},
				{Name = "Axanar", Class = "planet", OrbitRadius = AU(1.0), Model = "models/planets/earth.mdl", Diameter = KM(12500)},
			}
		},
		{
			name = "Berengaria", x = LY(8), y = LY(20),
			objects = {
				{Name = "Berengaria Star", Class = "sun", Diameter = KM(1250000), LightColor = Vector(255, 255, 230)},
				{Name = "Berengaria VII", Class = "planet", OrbitRadius = AU(2.0), Model = "models/planets/earth.mdl", Diameter = KM(15000)},
			}
		},
		{
			name = "Elba", x = LY(-15), y = LY(5),
			objects = {
				{Name = "Elba Star", Class = "sun", Diameter = KM(1100000), LightColor = Vector(255, 255, 230)},
				{Name = "Elba II", Class = "planet", OrbitRadius = AU(0.9), Model = "models/planets/mars.mdl", Diameter = KM(9500)},
			}
		},
		{
			name = "Iotia", x = LY(35), y = LY(-42),
			objects = {
				{Name = "Sigma Iotia", Class = "sun", Diameter = KM(1200000), LightColor = Vector(255, 255, 230)},
				{Name = "Sigma Iotia II", Class = "planet", OrbitRadius = AU(1.0), Model = "models/planets/earth.mdl", Diameter = KM(12600)},
			}
		},
		{
			name = "Janus", x = LY(42), y = LY(22),
			objects = {
				{Name = "Janus Star", Class = "sun", Diameter = KM(1150000), LightColor = Vector(255, 255, 230)},
				{Name = "Janus VI", Class = "planet", OrbitRadius = AU(1.8), Model = "models/planets/mars.mdl", Diameter = KM(10000)},
			}
		},
		{
			name = "Minos", x = LY(48), y = LY(-35),
			objects = {
				{Name = "Minos Star", Class = "sun", Diameter = KM(1200000), LightColor = Vector(255, 255, 230)},
				{Name = "Minos", Class = "planet", OrbitRadius = AU(1.1), Model = "models/planets/earth.mdl", Diameter = KM(11500)},
			}
		},
		{
			name = "Omicron Ceti", x = LY(-18), y = LY(-8),
			objects = {
				{Name = "Omicron Ceti", Class = "sun", Diameter = KM(1300000), LightColor = Vector(255, 179, 102)},
				{Name = "Omicron Ceti III", Class = "planet", OrbitRadius = AU(1.0), Model = "models/planets/earth.mdl", Diameter = KM(12400)},
			}
		},
		{
			name = "Peliar Zel", x = LY(38), y = LY(32),
			objects = {
				{Name = "Peliar Zel Star", Class = "sun", Diameter = KM(1250000), LightColor = Vector(255, 255, 230)},
				{Name = "Peliar Zel II", Class = "planet", OrbitRadius = AU(0.8), Model = "models/planets/earth.mdl", Diameter = KM(11000)},
			}
		},
		{
			name = "Pyris", x = LY(-25), y = LY(-15),
			objects = {
				{Name = "Pyris Star", Class = "sun", Diameter = KM(1100000), LightColor = Vector(255, 255, 230)},
				{Name = "Pyris VII", Class = "planet", OrbitRadius = AU(2.0), Model = "models/planets/mars.mdl", Diameter = KM(9000)},
			}
		},
		{
			name = "Stratos", x = LY(32), y = LY(5),
			objects = {
				{Name = "Stratos Star", Class = "sun", Diameter = KM(1200000), LightColor = Vector(255, 255, 230)},
				{Name = "Ardana", Class = "planet", OrbitRadius = AU(1.0), Model = "models/planets/earth.mdl", Diameter = KM(12300)},
				{Name = "Stratos City", ParentName = "Ardana", Class = "base", OrbitRadius = KM(50000), Model = "models/star_trek/stations/cloud_city.mdl", Diameter = KM(2)},
			}
		},
		{
			name = "Tantalus", x = LY(-8), y = LY(-35),
			objects = {
				{Name = "Tantalus Star", Class = "sun", Diameter = KM(1150000), LightColor = Vector(255, 255, 230)},
				{Name = "Tantalus V", Class = "planet", OrbitRadius = AU(1.4), Model = "models/planets/earth.mdl", Diameter = KM(11800)},
			}
		},
		{
			name = "Tiburon", x = LY(15), y = LY(32),
			objects = {
				{Name = "Omega Fornacis", Class = "sun", Diameter = KM(1200000), LightColor = Vector(255, 255, 230)},
				{Name = "Tiburon", Class = "planet", OrbitRadius = AU(1.0), Model = "models/planets/earth.mdl", Diameter = KM(12700)},
			}
		},
		{
			name = "Yonada", x = LY(22), y = LY(-48),
			objects = {
				{Name = "Fabrina Star", Class = "sun", Diameter = KM(1100000), LightColor = Vector(255, 255, 230)},
				{Name = "Daran V", Class = "planet", OrbitRadius = AU(1.4), Model = "models/planets/earth.mdl", Diameter = KM(12000)},
			}
		},
		{
			name = "Antares", x = LY(-58), y = LY(-15),
			objects = {
				{Name = "Alpha Scorpii", Class = "sun", Diameter = KM(1200000000), LightColor = Vector(255, 150, 100)},
				{Name = "Antares IV", Class = "planet", OrbitRadius = AU(45), Model = "models/planets/earth.mdl", Diameter = KM(13500)},
			}
		},
		{
			name = "Canopus", x = LY(52), y = LY(-8),
			objects = {
				{Name = "Alpha Carinae", Class = "sun", Diameter = KM(95000000), LightColor = Vector(255, 255, 240)},
				{Name = "Canopus Planet", Class = "planet", OrbitRadius = AU(12), Model = "models/planets/earth.mdl", Diameter = KM(13000)},
			}
		},

		-- ADDITIONAL STRATEGIC SYSTEMS
		{
			name = "Starbase 11", x = LY(-22), y = LY(18),
			objects = {
				{Name = "Starbase 11 Star", Class = "sun", Diameter = KM(1200000), LightColor = Vector(255, 255, 230)},
				{Name = "Starbase 11", Class = "base", OrbitRadius = AU(1.5), Model = "models/star_trek/stations/starbase.mdl", Diameter = KM(4)},
			}
		},
		{
			name = "Starbase 375", x = LY(12), y = LY(-55),
			objects = {
				{Name = "Starbase 375 Star", Class = "sun", Diameter = KM(1150000), LightColor = Vector(255, 255, 230)},
				{Name = "Starbase 375", Class = "base", OrbitRadius = AU(2.0), Model = "models/star_trek/stations/starbase.mdl", Diameter = KM(4)},
			}
		},
		{
			name = "Starbase 24", x = LY(-5), y = LY(-58),
			objects = {
				{Name = "Starbase 24 Star", Class = "sun", Diameter = KM(1100000), LightColor = Vector(255, 255, 230)},
				{Name = "Starbase 24", Class = "base", OrbitRadius = AU(1.8), Model = "models/star_trek/stations/starbase.mdl", Diameter = KM(3.5)},
			}
		},
	}

	-- [ O seu código de processamento continua aqui, sem alterações necessárias ]
	local object_id_counter = 1
	local created_systems = {}

	for _, system_data in ipairs(systems_data) do
		local processed_objects = {}
		local name_to_id_map = {}
		
		for _, object_data in ipairs(system_data.objects) do
			local new_object = table.Copy(object_data)
			new_object.Id = object_id_counter
			name_to_id_map[new_object.Name] = new_object.Id
			object_id_counter = object_id_counter + 1

			if new_object.ParentName then
				new_object.ParentId = name_to_id_map[new_object.ParentName]
				if not new_object.ParentId then
					print("WARNING: Object '" .. new_object.Name .. "' has an invalid ParentName: '" .. new_object.ParentName .. "'")
				end
				new_object.ParentName = nil
			end
			
			if new_object.Class == "sun" or new_object.Class == "star" then
				new_object.Class = "sun"
				new_object.Model = {Model = "models/planets/sun.mdl", Skin = 2}
				if not new_object.OrbitRadius then
					new_object.OrbitRadius = AU(0)
				end
			end
			table.insert(processed_objects, new_object)
		end

		local star_system = self:InitializeStarSystem(system_data.name, system_data.x, system_data.y, processed_objects)
		created_systems[system_data.name] = star_system
	end

	if created_systems["Sol"] then
		self:LoadStarSystem(created_systems["Sol"])
		local system_sol = created_systems["Sol"]
		if not system_sol then
			ErrorNoHaltWithStack("System 'Sol' not found when loading the map.")
			return
		end
		local found_dock = false
		for _, obj in ipairs(system_sol.Data and system_sol.Data.Entities or {}) do
			if obj.Name == "Earth Space Dock" then
				local success, result = self:AddMapShip(obj.Id)
				if not success then
					ErrorNoHaltWithStack("Failed to add map ship: " .. tostring(result))
				else
					found_dock = true
					print("'Earth Space Dock' added to map ships.")
				end
				break
			end
		end
		if not found_dock then
			ErrorNoHaltWithStack("'Earth Space Dock' not found in system Sol.")
		end
	else
		ErrorNoHaltWithStack("System 'Sol' not found!")
	end
end