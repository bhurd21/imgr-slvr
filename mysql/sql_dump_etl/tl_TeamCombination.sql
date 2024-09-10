--
-- Creates TeamCombination
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


DROP TABLE IF EXISTS `TeamCombination`;

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;

CREATE TABLE `TeamCombination` (
    `playerID` VARCHAR(10),
    `teamID1` VARCHAR(4),
    `teamID2` VARCHAR(4),
    PRIMARY KEY (`playerID`, `teamID1`, `teamID2`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `TeamCombination` (playerID, teamID1, teamID2)
SELECT DISTINCT playerID, fs1.teamID AS teamID1, fs2.teamID AS teamID2
FROM FieldingSeason fs1
JOIN FieldingSeason fs2
	USING(playerID)
WHERE fs1.teamID < fs2.teamID;