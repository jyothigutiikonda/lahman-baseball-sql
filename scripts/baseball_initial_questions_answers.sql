-- Comment Added
-- Another comment
-- new branch created
SELECT MIN(year) --1871
FROM homegames

SELECT MAX(year) --2016
FROM homegames

----1. What range of years for baseball games played does the provided database cover? 
-- 1871 to 2016
SELECT min(year) as start_year,
       MAx(year) as end_year
FRom homegames


--2.. Find the name and height of the shortest player in the database. How many games did he play in? What is the name of the team for which he played
SELECT namegiven,
      appearances.g_all,
	  teams.name,
      MIN(height) AS shortest_player
FROM  people
INNER JOIN appearances USING(playerid)
INNER JOIN teams USING(teamid)
GROUP BY namegiven,playerid,appearances.g_all,
	  teams.name
order by shortest_player nulls last
LIMIT 1



-----3. Find all players in the database who played at Vanderbilt University. Create a list showing each player’s first and
--- last names as well as the total salary they earned in the major leagues. 
--   Sort this list in descending order by the total salary earned. Which Vanderbilt player earned the most money in the majors?

---David price whos earned most money of $245,553,888

SELECT  namefirst,
	    namelast,
		SUM(salary::numeric::money) AS total_salary
FROM people 
            INNER JOIN salaries USING(playerid)
            INNER JOIN collegeplaying USING(playerid)
            INNER JOIN schools USING(schoolid)
WHERE schoolname ILIKE '%Vanderbilt%'
GROUP BY namefirst,
	    namelast
ORDER BY total_salary DESC


--4. Using the fielding table, group players into three groups based on their position: label players with position OF as "Outfield", 
--those with position "SS", "1B", "2B", and "3B" as "Infield", and those with position "P" or "C" as "Battery". 
--Determine the number of putouts made by each of these three groups in 2016.


SELECT 
       CASE WHEN pos IN('OF') THEN 'outfield'
	        WHEN pos IN ('SS','1B','2B','3B') THEN 'Infield'
	        WHEN pos IN ('p','C') THEN 'Battery'
			ELSE 'other'
			END AS position_group,
			SUM(po) AS total_putouts
FROM fielding
WHERE yearid = 2016
GROUP BY position_group;



SELECT *
FROM fielding


--5. Find the average number of strikeouts per game by decade since 1920.   --so is stirkeouts,g is games,
--Round the numbers you report to 2 decimal places. Do the same for home runs per game. Do you see any trends?

SELECT ROUND(AVG(so),2) As avg_strikeouts,
       ROUND(AVG(r),2) AS avg_runs,
	   G AS games
FROM batting
WHERE yearid = 1920   
GROUP BY G
ORDER BY games DESC


---6 Find the player who had the most success stealing bases in 2016, where __success__ is measured as the percentage of stolen base
--   attempts which are successful. (A stolen base attempt results either in a stolen base or being caught stealing.) 
--  Consider only players who attempted _at least_ 20 stolen bases.



SELECT 
     namefirst,namelast,
     ROUND((sb::decimal / (sb + cs)),2) * 100 AS stolen_base_percent,
	 sb AS stolen_bases,
	 cs As caught_stealing,
	 sb + cs AS total_steal_attempts
FROM batting 
INNER JOIN people USING(playerid)
WHERE yearid =2016
AND sb >= 20
ORDER BY stolen_base_percent DESC
LIMIT 1;


--7.  From 1970 – 2016, what is the largest number of wins for a team that did not win the world series?
--    What is the smallest number of wins for a team that did win the world series? Doing this will probably result in an unusually small number of wins for
--    a world series champion determine why this is the case. 
--    Then redo your query, excluding the problem year. How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? What percentage of the time?


WITH 
SELECT wswin as word_series_winner
from teams
WHERE yearid BETWEEN 1970 AND 2016 


SELECT wswin as word_series_winner
from teams
WHERE 

SELECT SUM(w) AS wins,name,wswin,
        CASE when wswin = 'Y' THEN 'yes'
             ELSE 'did not win'
			 END as wswin_category
FROM teams
GROUP BY name,wswin
ORDER BY name




--8. Using the attendance figures from the homegames table, 
--ind the teams and parks which had the top 5 average attendance per game in 2016 
--(where average attendance is defined as total attendance divided by number of games).
---Only consider parks where there were at least 10 games played.
--Report the park name, team name, and average attendance. Repeat for the lowest 5 average attendance.

--hometable -attendence--avg(attendence) -totalattendence /no of games
            --games
			--2016 year
            --parks >=10 games
----lowest 5 avagerage 

with avg_games As
(select team,year,
     attendance/games as avg_attendence
from homegames
WHERE year = 2016
AND games >= 10
GROUP BY team,games,attendance,year
--ORDER BY avg_attendence DESC)
)
SELECT team,yearid,
	   avg_attendence
	   FROM  avg_games a
INNER JOIN teams t On a.team = t.teamid
AND a.year = t.yearid 
ORDER BY avg_attendence
limit 5;




--

--9. Which managers have won the TSN Manager of the Year award in both the National League (NL)and the American League (AL)?
--   Give their full name and the teams that they were managing when they won the award.


-- people table--playerid key,namefirst,namelast
--teams -- lgid,teamid,name
--awradmanagers --lgid,playerid

SELECT DISTINCT a.playerid As manager,
       awardid,
       a.lgid As league_id,
	  p.namefirst || ' ' || p.namelast AS fullname,
	   p.namelast,
	   t.name As team_name
from awardsmanagers a
INNER JOIN people p USING(playerid)
INNER JOIN teams t On t.lgid = a.lgid
WHERE awardid LIKE 'TSN Manager of the Year'
AND a.lgid IN ('NL','AL')


SELECT * from awardsmanagers
SELECT * from people
SELECT *  FROM teams




--10. Find all players who hit their career highest number of home runs in 2016. Consider only players
---who have played in the league for at least 10 years, and who hit at least one home run in 2016.
--Report the players' first and last names and the number of home runs they hit in 2016.


--batting --playerid,yearid ,HR for homeruns,order by homeruns in 2016
--


WITH players_highest_homeruns As
(SELECT playerid,
       hr as homeruns,
	   yearid
from batting
WHERE yearid =2016
ORDER BY homeruns DESC)

--LEFT(finalgame, 4)::numeric
	        -- >= LEFT(debut,4)::numeric + 10

SELECT LEFT(finalgame, 4)::numeric
	      = LEFT(debut,4)::numeric + 10
FROM players_highest_homeruns
INNER JOIN people USING(playerid)






SELECT * from batting









