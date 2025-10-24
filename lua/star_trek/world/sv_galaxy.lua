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
	if not istable(parentEnt)	then return false, "Parent entity not found" end

	local model = "models/kingpommes/startrek/intrepid/intrepid_sky_1024.mdl"
	local modelSize = Star_Trek.World:GetModelDiameter(model)

	local _, mapShip = Star_Trek.World:LoadEntity(1, "ship", parentEnt:GetStandardOrbit(), Angle(), model, modelSize)
	self.MapShip = mapShip

	--Star_Trek.World:LoadEntity(-1, "beam", WorldVector(0, 0, 0, M(145), 0, M(8.5)), Angle(), KM(10), 1, "sprites/tp_beam001", Color(255, 0, 0, 127), 0.4, 4, 0.5)
	--Star_Trek.World:LoadEntity(-2, "beam", WorldVector(0, 0, 0, M(20), 0, -M(15)),  Angle(), KM(10), 1, "sprites/tp_beam001", Color(0, 255, 0, 127), 0.6, 8, -0.5)
end

-- Load the default galaxy.
function Star_Trek.World:LoadDefaultGalaxy()
	local systems_data = {
		-- PONTOS DE ÂNCORA (COORDENADAS FIXAS)
		{
			name = "Sistema Solar", x = LY(0), y = LY(0),
			objects = {
				{Name = "Sol", Class = "sun", Diameter = KM(1392700), LightColor = Vector(255, 255, 230)},
				{Name = "Mercúrio", Class = "planet", OrbitRadius = AU(0.39), Model = "models/planets/mercury.mdl", Diameter = KM(4880)},
				{Name = "Vênus", Class = "planet", OrbitRadius = AU(0.72), Model = "models/planets/venus.mdl", Diameter = KM(12104)},
				{Name = "Terra", Class = "planet", OrbitRadius = AU(1), Model = "models/planets/earth.mdl", Diameter = KM(12742)},
				{Name = "Lua", ParentName = "Terra", Class = "planet", OrbitRadius = KM(384400), Model = "models/planets/luna_small.mdl", Diameter = KM(3475)},
				{Name = "Doca Espacial Terrestre", ParentName = "Terra", Class = "base", OrbitRadius = KM(36000), Model = "models/crazycanadian/star_trek/stations/spacedock.mdl", Diameter = KM(5)},
				{Name = "Estação McKinley", ParentName = "Terra", Class = "base", OrbitRadius = KM(42000), Model = "models/star_trek/stations/mckinley.mdl", Diameter = KM(3.8), OrbitOffset = Vector(0, KM(42000), 0)},
				{Name = "Marte", Class = "planet", OrbitRadius = AU(1.52), Model = "models/planets/mars.mdl", Diameter = KM(6780)},
				{Name = "Estaleiros de Utopia Planitia", ParentName = "Marte", Class = "base", OrbitRadius = KM(20000), Model = "models/star_trek/stations/utopiaplanitia.mdl", Diameter = KM(4.5)},
				{Name = "Phobos", ParentName = "Marte", Class = "planet", OrbitRadius = KM(9376), Model = "models/crazycanadian/space/sol/phobos.mdl", Diameter = KM(22.5)},
				{Name = "Deimos", ParentName = "Marte", Class = "planet", OrbitRadius = KM(23463), Model = "models/crazycanadian/space/sol/deimos.mdl", Diameter = KM(12.6)},
				{Name = "Júpiter", Class = "planet", OrbitRadius = AU(5.20), Model = "models/planets/jupiter.mdl", Diameter = KM(139822)},
				{Name = "Io", ParentName = "Júpiter", Class = "planet", OrbitRadius = KM(422000), Model = "models/planets/io.mdl", Diameter = KM(3643.2)},
				{Name = "Europa", ParentName = "Júpiter", Class = "planet", OrbitRadius = KM(671000), Model = "models/crazycanadian/space/sol/europa.mdl", Diameter = KM(3121.6)},
				{Name = "Ganimedes", ParentName = "Júpiter", Class = "planet", OrbitRadius = KM(1070000), Model = "models/crazycanadian/space/sol/ganymede.mdl", Diameter = KM(5268.2)},
				{Name = "Calisto", ParentName = "Júpiter", Class = "planet", OrbitRadius = KM(1880000), Model = "models/planets/callisto.mdl", Diameter = KM(4800.6)},
				{Name = "Saturno", Class = "planet", OrbitRadius = AU(9.58), Model = "models/planets/saturn.mdl", Diameter = KM(116464)},
				{Name = "Titã", ParentName = "Saturno", Class = "planet", OrbitRadius = KM(1221870), Model = "models/planets/titan.mdl", Diameter = KM(5150)},
				{Name = "Encélado", ParentName = "Saturno", Class = "planet", OrbitRadius = KM(238020), Model = "models/planets/enceladus.mdl", Diameter = KM(504.2)},
				{Name = "Mimas", ParentName = "Saturno", Class = "planet", OrbitRadius = KM(185520), Model = "models/planets/mimas.mdl", Diameter = KM(396.4)},
				{Name = "Urano", Class = "planet", OrbitRadius = AU(19.20), Model = "models/planets/uranus.mdl", Diameter = KM(50724)},
				{Name = "Netuno", Class = "planet", OrbitRadius = AU(30.05), Model = "models/planets/neptune.mdl", Diameter = KM(49244)},
				{Name = "Tritão", ParentName = "Netuno", Class = "planet", OrbitRadius = KM(354800), Model = "models/planets/triton.mdl", Diameter = KM(2706.8)},
			}
		},
		{
			name = "Sistema Vulcano", x = LY(-0.616), y = LY(-12.837),
			objects = {
				{Name = "40 Eridani A", Class = "sun", Diameter = KM(1130872.4), LightColor = Vector(255, 179, 102)},
				{Name = "Vulcano", Class = "planet", OrbitRadius = AU(0.6), Model = "models/planets/vulcan.mdl", Diameter = KM(15720)},
				{Name = "T'Khut", Class = "planet", OrbitRadius = AU(0.6), Model = "models/planets/mars.mdl", Diameter = KM(11500)},
				{Name = "40 Eridani B", Class = "sun", OrbitRadius = AU(35), Diameter = KM(19497.8), LightColor = Vector(230, 230, 255)},
				{Name = "40 Eridani C", ParentName = "40 Eridani B", Class = "sun", OrbitRadius = AU(4), Diameter = KM(431737), LightColor = Vector(255, 102, 51)},
			}
		},
		{
			name = "Sistema Qo'noS", x = LY(-321.5), y = LY(48.6),
			objects = {
				{Name = "Omega Sagittarii", Class = "sun", Diameter = KM(1392700), LightColor = Vector(255, 230, 179)},
				{Name = "Qo'noS", Class = "planet", OrbitRadius = AU(1.2), Model = "models/planets/qonos.mdl", Diameter = KM(19530)},
				-- {Name = "Fragmentos de Praxis", ParentName = "Qo'noS", Class = "asteroid_field", OrbitRadius = KM(380000), Model = "models/effects/praxis_ring.mdl", Diameter = KM(5000)},
				{Name = "Corvix", Class = "planet", OrbitRadius = AU(2.5), Model = "models/planets/mars.mdl", Diameter = KM(8200)},
			}
		},

		-- SISTEMAS RECALIBRADOS COM DADOS COMPLETOS
		{
			name = "Sistema Andoria", x = LY(12.2), y = LY(8.6),
			objects = {
				{Name = "Procyon A", Class = "sun", Diameter = KM(2855035), LightColor = Vector(255, 255, 230)},
				{Name = "Procyon B", Class = "sun", OrbitRadius = AU(15), Diameter = KM(16712.4), LightColor = Vector(230, 230, 255)},
				{Name = "Andoria Major", Class = "planet", OrbitRadius = AU(2.1), Model = "models/planets/jupiter.mdl", Diameter = KM(150000)},
				{Name = "Andor", ParentName = "Andoria Major", Class = "planet", OrbitRadius = KM(500000), Model = "models/planets/andor.mdl", Diameter = KM(4870)},
			}
		},
		{
			name = "Sistema Romulus", x = LY(23.7), y = LY(-48.4),
			objects = {
				{Name = "Eisus", Class = "sun", Diameter = KM(1392700), LightColor = Vector(255, 230, 179)},
				{Name = "Romulus", Class = "planet", OrbitRadius = AU(1.0), Model = "models/planets/romulus.mdl", Diameter = KM(12742)},
				{Name = "Remus", Class = "planet", OrbitRadius = AU(1.8), Model = "models/planets/remus.mdl", Diameter = KM(11700)},
				{Name = "Calder II", Class = "planet", OrbitRadius = AU(0.4), Model = "models/planets/mercury.mdl", Diameter = KM(6000)},
				{Name = "Chelon", Class = "planet", OrbitRadius = AU(3.5), Model = "models/planets/jupiter.mdl", Diameter = KM(95000)},
				-- {Name = "Estação de Batalha 'V'Ger'", ParentName = "Romulus", Class = "base", OrbitRadius = KM(150000), Model = "models/star_trek/stations/romulan_starbase.mdl", Diameter = KM(6)},
			}
		},
		{
			name = "Sistema Bajorano", x = LY(201.1), y = LY(-325.8),
			objects = {
				{Name = "Bajor-B'Hava'el", Class = "sun", Diameter = KM(1300000), LightColor = Vector(255, 255, 230)},
				{Name = "Bajor", Class = "planet", OrbitRadius = AU(1), Model = "models/planets/bajor.mdl", Diameter = KM(12900)},
				{Name = "Derna", ParentName = "Bajor", Class = "planet", OrbitRadius = KM(180000), Model = "models/planets/moon.mdl", Diameter = KM(1200)},
				{Name = "Rilka", ParentName = "Bajor", Class = "planet", OrbitRadius = KM(250000), Model = "models/planets/luna_small.mdl", Diameter = KM(1500)},
				{Name = "Jeraddo", ParentName = "Bajor", Class = "planet", OrbitRadius = KM(400000), Model = "models/planets/moon.mdl", Diameter = KM(900)},
				{Name = "Deep Space 9", Class = "base", OrbitRadius = AU(1.5), Model = "models/star_trek/stations/ds9.mdl", Diameter = KM(2)},
				-- {Name = "Buraco de Minhoca Bajorano", Class = "wormhole", OrbitRadius = AU(1.55), Model = "models/effects/wormhole.mdl", Diameter = KM(10), OrbitOffset = Vector(KM(50000), 0, 0)},
			}
		},
		{
			name = "Wolf 359", x = LY(6.8), y = LY(3.9),
			objects = {
				{Name = "Wolf 359", Class = "sun", Diameter = KM(222832), LightColor = Vector(255, 102, 51)},
				{Name = "Cemitério de Naves", Class = "debris_field", OrbitRadius = AU(0.5), Model = "models/effects/ship_debris.mdl", Diameter = KM(20000)},
			}
		},
		{
			name = "Sistema Alpha Centauri", x = LY(-3.1), y = LY(3.0),
			objects = {
				{Name = "Alpha Centauri A", Class = "sun", Diameter = KM(1700000), LightColor = Vector(255, 255, 230)},
				{Name = "Alpha Centauri B", Class = "sun", OrbitRadius = AU(23.4), Diameter = KM(1200000), LightColor = Vector(255, 179, 102)},
				{Name = "Proxima Centauri", Class = "sun", OrbitRadius = AU(12950), Diameter = KM(202000), LightColor = Vector(255, 102, 51)},
				{Name = "Alpha Centauri IV", Class = "planet", OrbitRadius = AU(1.25), Model = "models/planets/earth.mdl", Diameter = KM(13000)},
			}
		},
		{
			name = "Sistema Ceti Alpha", x = LY(23.8), y = LY(-45.3),
			objects = {
				{Name = "Ceti Alpha", Class = "sun", Diameter = KM(1450000), LightColor = Vector(255, 255, 230)},
				{Name = "Ceti Alpha V", Class = "planet", OrbitRadius = AU(1.8), Model = "models/planets/desert.mdl", Diameter = KM(14000)},
				-- -- {Name = "Fragmentos de Ceti Alpha VI", Class = "asteroid_field", OrbitRadius = AU(2.5), Model = "models/effects/asteroid_field.mdl", Diameter = KM(10000)},
			}
		},
		{
			name = "Sistema Khitomer", x = LY(-290.4), y = LY(95.1),
			objects = {
				{Name = "Estrela de Khitomer", Class = "sun", Diameter = KM(1200000), LightColor = Vector(255, 179, 102)},
				{Name = "Khitomer", Class = "planet", OrbitRadius = AU(1.1), Model = "models/planets/mars.mdl", Diameter = KM(13500)},
			}
		},
		{
			name = "Setor 001 (K-7)", x = LY(-255.1), y = LY(25.9),
			objects = {
				{Name = "Estrela do Setor", Class = "sun", Diameter = KM(1000000), LightColor = Vector(255, 230, 179)},
				-- {Name = "Deep Space K-7", Class = "base", OrbitRadius = AU(3.0), Model = "models/star_trek/stations/k7_station.mdl", Diameter = KM(1.5)},
			}
		},
		{
			name = "Cardassia", x = LY(204.9), y = LY(-329.8),
			objects = {
				{Name = "Cardassia Prime", Class = "sun", Diameter = KM(1100000), LightColor = Vector(255, 230, 179)},
				{Name = "Cardassia", Class = "planet", OrbitRadius = AU(0.95), Model = "models/planets/earth.mdl", Diameter = KM(13200)},
			}
		},
		{
			name = "Betazed", x = LY(1.5), y = LY(-34.9),
			objects = {
				{Name = "Betazed Star", Class = "sun", Diameter = KM(950000), LightColor = Vector(255, 230, 179)},
				{Name = "Betazed", Class = "planet", OrbitRadius = AU(0.9), Model = "models/planets/earth.mdl", Diameter = KM(12700)},
			}
		},
		{
			name = "Trill", x = LY(196.4), y = LY(-316.5),
			objects = {
				{Name = "Trill Star", Class = "sun", Diameter = KM(1000000), LightColor = Vector(255, 179, 102)},
				{Name = "Trill", Class = "planet", OrbitRadius = AU(1.1), Model = "models/planets/earth.mdl", Diameter = KM(12600)},
			}
		},
		{
			name = "Sistema Tellar", x = LY(-4.0), y = LY(14.7), -- Coordenada ajustada com base em Andoria/Terra
			objects = {
				{Name = "61 Cygni A", Class = "sun", Diameter = KM(926145.5), LightColor = Vector(255, 179, 102)},
				{Name = "61 Cygni B", Class = "sun", OrbitRadius = AU(86), Diameter = KM(828656.5), LightColor = Vector(255, 179, 102)},
				{Name = "Tellar Prime", Class = "planet", OrbitRadius = AU(0.6), Model = "models/planets/earth.mdl", Diameter = KM(13000)},
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
					print("AVISO: Objeto '" .. new_object.Name .. "' tem um ParentName inválido: '" .. new_object.ParentName .. "'")
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

	if created_systems["Sistema Solar"] then
		self:LoadStarSystem(created_systems["Sistema Solar"])
		local system_solar = created_systems["Sistema Solar"]
		if not system_solar then
			ErrorNoHaltWithStack("Sistema Solar não encontrado ao carregar o mapa.")
			return
		end
		local found_dock = false
		for _, obj in ipairs(system_solar.Data and system_solar.Data.Entities or {}) do
			if obj.Name == "Doca Espacial Terrestre" then
				self:AddMapShip(obj.Id)
				found_dock = true
				break
			end
		end
		if not found_dock then
			ErrorNoHaltWithStack("Doca Espacial Terrestre não encontrada no Sistema Solar.")
		end
	else
		ErrorNoHaltWithStack("Sistema Solar não encontrado!")
	end
end