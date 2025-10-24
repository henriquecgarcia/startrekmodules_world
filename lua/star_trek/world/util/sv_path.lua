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
--       Path Planning | Server      --
---------------------------------------

local MAX_DEPTH = 15
local DEBUG_PATH = false -- Set to true to enable path debugging

-- Optional debugging function to visualize calculated paths
local function debugPath(path, color)
	if not DEBUG_PATH or not path or #path < 2 then return end
	
	color = color or Color(0, 255, 0)
	
	for i = 1, #path - 1 do
		local startPos = path[i]
		local endPos = path[i + 1]
		
		-- Create visual beam between waypoints (only visible in debug mode)
		if game.SinglePlayer() or GetConVar("developer"):GetInt() > 0 then
			print(string.format("Path segment %d: %s -> %s (Distance: %.2f)", 
				i, tostring(startPos), tostring(endPos), startPos:Distance(endPos)))
		end
	end
end

-- Calculates the distance to a line AB from a point C.
--
-- @param WorldVector a
-- @param WorldVector b
-- @param WorldVector c
-- @return Number closestApproach
-- @return WorldVector approachPos
-- @return Number approachPoint
function Star_Trek.World:DistanceToLine(a, b, c)
	local ab = b - a
	local abLen = ab:Length()

	local ac = c - a
	local acLen = ac:Length()

	local area = ab:Cross(ac):Length()
	local cdLen = area / abLen

	local adLen = math.sqrt(acLen ^2 - cdLen)
	local d = a + ab:GetNormalized() * adLen

	return cdLen, d, adLen
end

local printed = false
local function debugPrint(str, ret)
	print(string.format("DEBUG: %s =:= %s (%s)", str, tostring(ret), type(ret)))
end

-- Helper function to calculate total path distance
local function calculatePathDistance(path)
	if not path or #path < 2 then return 0 end
	
	local totalDistance = 0
	for i = 1, #path - 1 do
		totalDistance = totalDistance + path[i]:Distance(path[i + 1])
	end
	return totalDistance
end



-- Helper function to find collision entities along a path segment
local function findCollisionEntities(self, shipId, startPos, endPos)
	local collisionEntities = {}
	local distance = startPos:Distance(endPos)
	
	for id, ent in pairs(self.Entities) do
		if id == shipId then continue end
		if not ent.Solid then continue end

		local pos = ent.Pos
		local closestApproach, approachPos, approachPoint = Star_Trek.World:DistanceToLine(startPos, endPos, pos)
		
		-- Handle edge case where entity is exactly on the line
		if closestApproach == 0 then
			local dir = endPos - startPos
			closestApproach = 1
			approachPos = pos + dir:GetNormalized():Angle():Right() * 1
			approachPoint = approachPos:Distance(startPos)
		end

		-- Check if object is beyond course
		if approachPoint > distance or approachPoint < 0 then
			continue
		end

		-- Check if object is far enough away from course
		local orbitDistance = ent.Diameter * Star_Trek.World.MinimumOrbitMultiplier
		local minimumApproach = orbitDistance * 0.5
		if closestApproach > minimumApproach then
			continue
		end

		-- Collision detected - add to list with priority based on distance from start
		table.insert(collisionEntities, {
			entity = ent,
			pos = pos,
			orbitDistance = orbitDistance,
			approachPoint = approachPoint,
			approachPos = approachPos,
			closestApproach = closestApproach
		})
	end
	
	-- Sort by approach point (closest to start first)
	table.sort(collisionEntities, function(a, b)
		return a.approachPoint < b.approachPoint
	end)
	
	return collisionEntities
end

-- Helper function to optimize path by removing unnecessary waypoints
local function optimizePath(self, shipId, path)
	if not path or #path <= 2 then return path end
	
	local optimizedPath = {path[1]} -- Always keep start point
	
	for i = 2, #path - 1 do
		local prevPoint = optimizedPath[#optimizedPath]
		local currentPoint = path[i]
		local nextPoint = path[i + 1]
		
		-- Check if we can skip current point by going directly from previous to next
		local collisionEntities = findCollisionEntities(self, shipId, prevPoint, nextPoint)
		
		-- If no collisions, we can skip this waypoint
		if #collisionEntities == 0 then
			-- Skip current point
		else
			-- Keep current point as it's necessary
			table.insert(optimizedPath, currentPoint)
		end
	end
	
	table.insert(optimizedPath, path[#path]) -- Always keep end point
	return optimizedPath
end

-- Helper function to calculate bypass points around an obstacle
local function calculateBypassPoints(startPos, endPos, obstacle)
	local pos = obstacle.pos
	local orbitDistance = obstacle.orbitDistance
	local approachPos = obstacle.approachPos
	
	-- Calculate perpendicular vector to the line
	local lineDir = (endPos - startPos):GetNormalized()
	local perpVector = lineDir:Angle():Right()
	
	-- Calculate safe distance around the obstacle
	local safeDistance = orbitDistance * 1.2 -- 20% safety margin
	
	-- Calculate two possible bypass points (left and right of obstacle)
	local bypassPoint1 = pos + perpVector * safeDistance
	local bypassPoint2 = pos - perpVector * safeDistance
	
	return bypassPoint1, bypassPoint2
end

-- Advanced pathfinding for handling multiple simultaneous collisions
function Star_Trek.World:PlotCourseAdvanced(shipId, startPos, endPos, depth)
	if not shipId or not startPos or not endPos then
		return false, "Invalid Arguments"
	end
	depth = depth or MAX_DEPTH
	
	if depth == 0 then
		return false, "Maximum Depth Reached"
	end

	-- Check for direct path first
	local collisionEntities = findCollisionEntities(self, shipId, startPos, endPos)
	
	-- If no collisions, return direct path
	if #collisionEntities == 0 then
		return true, {startPos, endPos}
	end
	
	-- Handle multiple collisions by processing them in order
	local currentStart = startPos
	local pathSegments = {}
	
	for i, collision in ipairs(collisionEntities) do
		-- Calculate where this collision occurs on our path
		local collisionPoint = collision.approachPos
		
		-- Add path segment to collision avoidance point
		if currentStart:Distance(collisionPoint) > 0.1 then -- Avoid tiny segments
			table.insert(pathSegments, {currentStart, collisionPoint})
		end
		
		-- Calculate bypass points for this collision
		local bypassPoint1, bypassPoint2 = calculateBypassPoints(currentStart, endPos, collision)
		
		-- Choose the bypass point that's closer to our destination
		local chosenBypass = bypassPoint1
		if bypassPoint2:Distance(endPos) < bypassPoint1:Distance(endPos) then
			chosenBypass = bypassPoint2
		end
		
		-- Add bypass segment
		table.insert(pathSegments, {collisionPoint, chosenBypass})
		currentStart = chosenBypass
	end
	
	-- Add final segment to destination
	if currentStart:Distance(endPos) > 0.1 then
		table.insert(pathSegments, {currentStart, endPos})
	end
	
	-- Recursively calculate each segment
	local fullPath = {}
	for i, segment in ipairs(pathSegments) do
		local segmentStart, segmentEnd = segment[1], segment[2]
		local success, pathSegment = self:PlotCourse(shipId, segmentStart, segmentEnd, depth - 1)
		
		if not success then
			return false, pathSegment -- Return error message
		end
		
		-- Merge path segments
		if i == 1 then
			-- First segment, add all points
			for j = 1, #pathSegment do
				table.insert(fullPath, pathSegment[j])
			end
		else
			-- Skip first point to avoid duplication
			for j = 2, #pathSegment do
				table.insert(fullPath, pathSegment[j])
			end
		end
	end
	
	-- Optimize the final path
	if depth == MAX_DEPTH then
		fullPath = optimizePath(self, shipId, fullPath)
	end
	
	return true, fullPath
end

-- Improved pathfinding algorithm with A* approach
function Star_Trek.World:PlotCourse(shipId, startPos, endPos, depth)
	if not shipId or not startPos or not endPos then
		return false, "Invalid Arguments"
	end
	depth = depth or MAX_DEPTH
	
	if depth == 0 then
		return false, "Maximum Depth Reached"
	end

	-- Check for direct path first
	local collisionEntities = findCollisionEntities(self, shipId, startPos, endPos)
	
	-- If no collisions, return direct path
	if #collisionEntities == 0 then
		return true, {startPos, endPos}
	end
	
	-- Find the closest collision
	local closestCollision = collisionEntities[1]
	local pos = closestCollision.pos
	local orbitDistance = closestCollision.orbitDistance
	
	-- Calculate bypass points
	local bypassPoint1, bypassPoint2 = calculateBypassPoints(startPos, endPos, closestCollision)
	
	-- Validate bypass points don't go backwards
	local directDistance = startPos:Distance(endPos)
	if bypassPoint1:Distance(endPos) >= directDistance and bypassPoint2:Distance(endPos) >= directDistance then
		return false, "No viable path found - all bypass routes go backwards"
	end
	
	local bestPath = nil
	local shortestDistance = math.huge
	
	-- Try both bypass routes
	for _, bypassPoint in ipairs({bypassPoint1, bypassPoint2}) do
		-- Skip if this route goes backwards
		if bypassPoint:Distance(endPos) >= directDistance then
			continue
		end
		
		-- Recursively plot course through bypass point
		local success1, path1 = self:PlotCourse(shipId, startPos, bypassPoint, depth - 1)
		if not success1 then continue end
		
		local success2, path2 = self:PlotCourse(shipId, bypassPoint, endPos, depth - 1)
		if not success2 then continue end
		
		-- Merge paths
		local fullPath = {}
		for i = 1, #path1 do
			table.insert(fullPath, path1[i])
		end
		for i = 2, #path2 do -- Skip first point to avoid duplication
			table.insert(fullPath, path2[i])
		end
		
		-- Calculate total distance
		local totalDistance = calculatePathDistance(fullPath)
		
		-- Keep the shortest valid path
		if totalDistance < shortestDistance then
			shortestDistance = totalDistance
			bestPath = fullPath
		end
	end
	
	-- Optimize and return best path found
	if bestPath then
		-- Only optimize at the top level to avoid excessive recursion
		if depth == MAX_DEPTH then
			bestPath = optimizePath(self, shipId, bestPath)
			-- Debug the final optimized path
			debugPath(bestPath, Color(0, 255, 0))
		end
		return true, bestPath
	else
		return false, "No viable path found around obstacle"
	end
end