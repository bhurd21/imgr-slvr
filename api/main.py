from fastapi import FastAPI, Query
from typing import List, Union

from database.connector import DatabaseConnector

app = FastAPI()

db = DatabaseConnector()


@app.get("/v1/grid/solve/teamandteam")
async def team_and_team(
    team1: str = Query(..., description="First team"),
    team2: str = Query(..., description="Second team")
) -> List[dict]:

    query = """
        SELECT pa.fullName
        FROM TeamCombination tc
        JOIN PlayerAttribute pa
            USING(playerID)
        WHERE teamID1 = %s
            AND teamID2 = %s
        ORDER BY pa.birthYear;"""
    
    team1, team2 = sorted([team1, team2])
    db_result = db.query_get(query, param=(team1, team2))

    return db_result
    # http://localhost:8000/v1/grid/solve/teamandteam/?team1=NYA&team2=BOS


@app.get("/v1/grid/solve/teamandaward")
async def team_and_award(
    teamID: str = Query(..., description="teamID"),
    award: str = Query(..., description="award")
) -> List[dict]:

    query = """
        SELECT pa.fullName
        FROM Award a
        JOIN PlayerAttribute pa
            USING(playerID)
        WHERE a.teamID = %s -- var
            AND a.award = %s
        ORDER BY pa.birthYear;"""
    
    db_result = db.query_get(query, param=(teamID, award))

    return db_result
    # http://localhost:8000/v1/grid/solve/teamandaward?teamID=NYA&award=Cy%20Young%20Award


@app.get("/v1/grid/solve/teamandseasonstat")
async def team_and_season_stat(
    teamID: str = Query(..., description="teamID"),
    category: str = Query(..., description="category"),
    stat: str = Query(..., description="stat"),
    value: Union[float, int] = Query(..., description="value"),
    gte: bool = Query(..., description="True for greater than")
) -> List[dict]:
    
    cat = category.capitalize()
    comp = ">=" if gte else "<="
    
    query = f"""
        SELECT DISTINCT pa.fullName, pa.birthYear
        FROM {cat}Season {cat[0]}s
        JOIN PlayerAttribute pa
            USING(playerID)
        WHERE {cat[0]}s.teamID = %s
            AND {cat[0]}s.{stat} {comp} %s
        ORDER BY pa.birthYear;"""
    
    db_result = db.query_get(query, param=(teamID, value))

    return db_result

    # http://localhost:8000/v1/grid/solve/teamandseasonstat?teamID=NYA&category=batting&stat=H&value=100




# TODO: start here...






@app.get("/v1/grid/solve/teamandcareerstat")
async def team_and_career_stat(
    teamID: str = Query(..., description="teamID"),
    category: str = Query(..., description="category"),
    stat: str = Query(..., description="stat"),
    value: Union[float, int] = Query(..., description="value"),
    gte: bool = Query(..., description="True for greater than")
) -> List[dict]:
    
    cat = category.capitalize()
    comp = ">=" if gte else "<="
    if stat == "ERA":
        stat_cleaned = "CASE WHEN SUM(IPOuts) = 0 AND SUM(ER) != 0 THEN NULL ELSE ROUND(SUM(ER) / SUM(IPOuts) * 27, 3) END"
    elif stat == "AVG":
        stat_cleaned = "COALESCE(ROUND(SUM(H) / SUM(AB), 3), 0.000)"
    else:
        stat_cleaned = f"SUM({stat})"
    
    stat_query = f"{stat_cleaned} {comp} {value}"
    
    query = f"""
        SELECT
            pa.fullName,
            pa.birthYear
        FROM BattingSeason bs
        JOIN PlayerAttribute pa
            USING(playerID)
        GROUP BY pa.playerID
        HAVING SUM(CASE WHEN bs.teamID = %s THEN 1 ELSE 0 END) > 0
            AND %s
        ORDER BY pa.birthYear;"""
    
    db_result = db.query_get(query, param=(teamID, stat_query))

    return db_result

    # http://localhost:8000/v1/grid/solve/teamandcareerstat?teamID=NYA&category=batting&stat=H&value=3000&gte=true
