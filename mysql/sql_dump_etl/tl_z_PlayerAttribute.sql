--
-- Creates PlayerAttribute
--

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


CREATE DATABASE IF NOT EXISTS immaculateGrid;
USE immaculateGrid;


DROP TABLE IF EXISTS `PlayerAttribute`;

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;

CREATE TABLE `PlayerAttribute` (
    `playerID` VARCHAR(10),
    `fullName` VARCHAR(255),
	`birthYear` INT,
	`bornInUSAFlag` TINYINT,
    `HallOfFameFlag` TINYINT,
	`onlyTeamID` VARCHAR(4) DEFAULT NULL,
    PRIMARY KEY (`playerID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
INSERT INTO `PlayerAttribute` (playerID, fullName, birthYear, bornInUSAFlag, HallOfFameFlag, onlyTeamID)
WITH one_team_players AS (
	SELECT playerID, MIN(teamID) as onlyTeamID
	FROM FieldingSeason
	GROUP BY playerID
	HAVING COUNT(DISTINCT teamID) = 1
)
SELECT
	p.playerID,
	CONCAT(p.nameFirst, " ", p.nameLast) AS fullName,
	p.birthYear,
	CASE 
		WHEN p.birthCountry = "USA" THEN 1
		ELSE 0
	END AS bornInUSAFlag,
	CASE
		WHEN hof.category IS NOT NULL THEN 1
		ELSE 0
	END AS HallOfFameFlag,
	otp.onlyTeamID
FROM People p
LEFT JOIN HallOfFame hof
	ON hof.playerID = p.playerID
		AND hof.inducted = "Y"
LEFT JOIN one_team_players otp
	ON p.playerID = otp.playerID;

DROP TABLE `HallOfFame`;
DROP TABLE `People`;