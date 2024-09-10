-- team and team
SELECT pa.playerID, pa.fullName
FROM TeamCombination tc
JOIN PlayerAttribute pa
    USING(playerID)
WHERE teamID1 = "NYA" -- var
    AND teamID2 = "WAS" -- var
ORDER BY pa.birthYear;


-- team and award
-- includes award = "All Star"
SELECT pa.playerID, pa.fullName
FROM Award a
JOIN PlayerAttribute pa
	USING(playerID)
WHERE a.teamID = "ATL" -- var
	AND a.award = "Cy Young Award"; -- var
	
	
-- award only
-- includes award = "All Star"
SELECT DISTINCT pa.playerID, pa.fullName
FROM Award a
JOIN PlayerAttribute pa
	USING(playerID)
WHERE a.award = "Cy Young Award"; -- var


-- team and season batting stat
SELECT DISTINCT pa.playerID, pa.fullName
FROM BattingSeason bs
JOIN PlayerAttribute pa
	USING(playerID)
WHERE teamID = "SEA" -- var
	AND H >= 100; -- var >= var
	
-- team and career batting stat
SELECT
	bs.playerID,
	pa.fullName
FROM BattingSeason bs
JOIN PlayerAttribute pa
	USING(playerID)
GROUP BY pa.playerID
HAVING SUM(CASE WHEN bs.teamID = "SEA" THEN 1 ELSE 0 END) > 0 -- var = "SEA"
	AND SUM(H) >= 2000; -- var = "H", var = "2000"
    -- 	COALESCE(ROUND(SUM(H) / SUM(AB), 3), 0.000) if "AVG"
    -- CASE WHEN SUM(IPOuts) = 0 AND SUM(ER) != 0 THEN NULL ELSE ROUND(SUM(ER) / SUM(IPOuts) * 27, 3) END if "ERA"
	
	
	
-- only team
SELECT playerID, fullName
FROM PlayerAttribute
WHERE onlyTeamID = "WAS";


-- hall of fame players only
SELECT playerID, fullName
FROM PlayerAttribute
WHERE HallOfFameFlag = 1;

-- hall of fame player with team
WITH players_with_team AS (
	SELECT DISTINCT playerID, teamID
	FROM FieldingSeason
)
SELECT 
	pa.playerID,
	pa.fullName
FROM PlayerAttribute pa
LEFT JOIN players_with_team pwt
	USING(playerID)
WHERE pwt.teamID = "NYA" -- variable
	AND pa.HallOfFameFlag = 1;

	
	
-- foriegn players only
SELECT playerID, fullName
FROM PlayerAttribute
WHERE bornInUSAFlag = 0;



-- position with team
SELECT DISTINCT fs.playerID, pa.fullname
FROM FieldingSeason fs
JOIN PlayerAttribute pa
	USING(playerID)
WHERE fs.C = 1 -- var
	AND fs.teamID = "CHN"; -- var


-- position in career
SELECT DISTINCT fs.playerID, pa.fullname
FROM FieldingSeason fs
JOIN PlayerAttribute pa
	USING(playerID)
WHERE fs.C = 1; -- var

-- ws champ in career
SELECT DISTINCT fs.playerID, pa.fullName
FROM FieldingSeason fs
JOIN TeamAttribute ta
	USING(teamID, year)
JOIN PlayerAttribute pa
	USING(playerID)
WHERE ta.WSFlag = 1;

-- ws champ on team
SELECT DISTINCT fs.playerID, pa.fullName
FROM FieldingSeason fs
JOIN TeamAttribute ta
	USING(teamID, year)
JOIN PlayerAttribute pa
	USING(playerID)
WHERE ta.WSFlag = 1
	AND ta.teamID = "NYA";