-- 1.	Show the percentage of wins of each bidder in the order of highest to lowest percentage.

SELECT IPL_BIDDING_DETAILS.BIDDER_ID, COUNT(IPL_BIDDING_DETAILS.BID_STATUS) , NO_OF_BIDS,
(COUNT(IPL_BIDDING_DETAILS.BID_STATUS)/NO_OF_BIDS)*100 AS PERCENTAGE_WIN
FROM IPL_BIDDING_DETAILS
INNER JOIN IPL_BIDDER_POINTS
ON IPL_BIDDING_DETAILS.BIDDER_ID = IPL_BIDDER_POINTS.BIDDER_ID
AND IPL_BIDDING_DETAILS.BID_STATUS ='Won'
GROUP BY IPL_BIDDING_DETAILS.BIDDER_ID, NO_OF_BIDS
ORDER BY PERCENTAGE_WIN DESC;


-- 2.	Display the number of matches conducted at each stadium with stadium name, city from the database.

SELECT IPL_STADIUM.STADIUM_ID, STADIUM_NAME,CITY , COUNT(IPL_STADIUM.STADIUM_ID) AS TOTAL_MATCHES
FROM IPL_STADIUM
INNER JOIN IPL_MATCH_SCHEDULE
ON IPL_STADIUM.STADIUM_ID = IPL_MATCH_SCHEDULE.STADIUM_ID
GROUP BY IPL_STADIUM.STADIUM_ID,STADIUM_NAME
ORDER BY TOTAL_MATCHES;

-- 3.	In a given stadium, what is the percentage of wins by a team which has won the toss?

select stadium_id 'Stadium ID', stadium_name 'Stadium Name',
(select count(*) from ipl_match m join ipl_match_schedule ms on m.match_id = ms.match_id
where ms.stadium_id = s.stadium_id and (toss_winner = match_winner)) /
(select count(*) from ipl_match_schedule ms where ms.stadium_id = s.stadium_id) * 100 
as 'Percentage of Wins by teams who won the toss (%)'
from ipl_stadium s;


-- 4.	Show the total bids along with bid team and team name.

SELECT COUNT(BID_TEAM) ,BID_TEAM,IPL_TEAM.TEAM_NAME
FROM IPL_BIDDING_DETAILS
INNER JOIN IPL_TEAM
ON IPL_BIDDING_DETAILS.BID_TEAM = IPL_TEAM.TEAM_ID
GROUP BY BID_TEAM;


-- 5.	Show the team id who won the match as per the win details.

select  win_details, match_winner from ipl_match
group by win_details;


-- 6.	Display total matches played, total matches won and total matches lost by team along with 
-- its team name.

select its.team_id, it.team_name,
 sum(MATCHES_PLAYED) as total_matches_played, 
 sum(MATCHES_WON) as total_matches_won,
 sum(MATCHES_LOST) as total_matches_lost
 from ipl_team_standings as its
 join ipl_team as it on its.team_id = it.team_id
 group by team_ID;

-- 7.	Display the bowlers for Mumbai Indians team.

select PLAYER_NAME
from
ipl_team_players i1 
join
ipl_team i2 on i1.TEAM_ID = i2.TEAM_ID
join
ipl_player i3 on i1.PLAYER_ID = i3.PLAYER_ID
where 
i1.PLAYER_ROLE = 'Bowler'
and i2.TEAM_NAME = 'Mumbai Indians';


-- 8.	How many all-rounders are there in each team, Display the teams with more than 4 
--       all-rounder in descending order.


SELECT TEAM_NAME, PLAYER_ROLE, COUNT(PLAYER_ROLE) AS TOTAL
FROM IPL_TEAM
INNER JOIN IPL_TEAM_PLAYERS
ON SUBSTR(IPL_TEAM.REMARKS,-2) = SUBSTR(IPL_TEAM_PLAYERS.REMARKS,-2)
GROUP BY PLAYER_ROLE, TEAM_NAME
HAVING PLAYER_ROLE LIKE 'All-Rounder' AND COUNT(PLAYER_ROLE) > 4
ORDER BY COUNT(PLAYER_ROLE) DESC;