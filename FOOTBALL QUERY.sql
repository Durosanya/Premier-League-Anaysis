/**

Arsenal Performances and Premier League 2023/2024 Analysis
**/
  
  -- Arsenal Home record in 2023/2024 season--
  Select season, 
		 Home_teams,
		 Case when Home_Goals > Away_Goals then 'won'
		 when Home_Goals < Away_Goals then 'lost to'
		 when Home_Goals = Away_Goals then 'drew'
		 end as home_stats,
		 Away_Teams
  from [Projects].[dbo].[Matches]
  where Home_Teams = 'Arsenal' 
  And season ='2023/2024';

select *
from [Projects].[dbo].[Premiership Statss]
where season = '2022/2023';

  --Arsenal Away record in 2023/2024 season--
  Select season, 
		 Home_teams,
		 Case when Home_Goals < Away_Goals then 'lost to'
		 when Home_Goals > Away_Goals then 'won'
		 when Home_Goals = Away_Goals then 'drew'
		 end as Away_stats,
		 Away_Teams
  from [Projects].[dbo].[Matches]
  where Away_Teams = 'Arsenal' 
  And season = '2022/2023';

  -- Comparing the above with Manchester City statistics--

  -- Manchester City Home record in 2023/2024 season--
  Select season, 
		 Home_teams,
		 Case when Home_Goals > Away_Goals then 'won'
		 when Home_Goals < Away_Goals then 'lost to'
		 when Home_Goals = Away_Goals then 'drew'
		 end as home_stats,
		 Away_Teams
  from [Projects].[dbo].[Matches]
  where Home_Teams = 'Manchester city' 
  And season in('2023/2024');

  --Manchester city Away record in 2023/2024 season--
  Select season, 
		 Home_teams,
		 Case when Home_Goals < Away_Goals then 'lost to'
		 when Home_Goals > Away_Goals then 'won'
		 when Home_Goals = Away_Goals then 'drew'
		 end as Away_stats,
		 Away_Teams
  from [Projects].[dbo].[Matches]
  where Away_Teams = 'Manchester city' 
  And season in('2023/2024');

  
  --The first is query for teams that are not strong enough to finish top 5 for the last seasons--
  
  With point_rank as(
 Select Season, 
		 Teams, 
		 Points,	 
		 dense_rank() over(partition by season order by points desc) as rnk
  FROM [Projects].[dbo].[Premiership Statss] as ps
  )
  Select Season,
		 Case when rnk between 1 and 5 then Teams end as Teams, 
		 Points,
		 rnk
  from point_rank 
  where Case when rnk between 1 and 5 then Teams end is not null
  and season = '2023/2024'
		 
order by 1 desc
  ;

-- Arsenal Home lost to teams not strong enough to be in top 5 in 2023/2024 season--
 with Arsenal_stats as(
 Select season, 
		 Home_teams,
		 Case when Home_Goals > Away_Goals then 'won'
		 when Home_Goals < Away_Goals then 'lost to'
		 when Home_Goals = Away_Goals then 'drew'
		 end as home_stats,
		 Away_Teams
  from [Projects].[dbo].[Matches]
  where Home_Teams = 'Arsenal' 
  And season = ('2023/2024')
  AND Away_Teams NOT IN ( 'Manchester city', 'Liverpool', 'Aston Villa' , 'Tottenham')
  )
  Select season, Home_teams, home_stats, Away_Teams
  from Arsenal_stats
  where home_stats IN ('lost to', 'drew')
  ;

  --Arsenal Away lost to teams not strong enough to be in top 5 in 2023/2024 season--
 with Arsenal_stats as(
 Select season, 
		 Home_teams,
		 Case when Home_Goals < Away_Goals then 'lost to'
		 when Home_Goals > Away_Goals then 'won'
		 when Home_Goals = Away_Goals then 'drew'
		 end as Away_stats,
		 Away_Teams
  from [Projects].[dbo].[Matches]
  where Away_Teams = 'Arsenal' 
  And season in('2023/2024')
  AND Home_Teams NOT IN ( 'Manchester city', 'Liverpool', 'Aston Villa' , 'Tottenham')
  )
  Select season, Home_teams, Away_stats, Away_Teams
  from Arsenal_stats
  where Away_stats IN ('won', 'drew');

/**
Comparing the above Arsenal statistics with Manchester City
**/

  -- Man City Home lost to teams not strong enough to be in top 5 in 2023/2024 season--
 with Man_city_stats as(
 Select season, 
		 Home_teams,
		 Case when Home_Goals > Away_Goals then 'won'
		 when Home_Goals < Away_Goals then 'lost to'
		 when Home_Goals = Away_Goals then 'drew'
		 end as home_stats,
		 Away_Teams
  from [Projects].[dbo].[Matches]
  where Home_Teams =  'Manchester city'
  And season = ('2023/2024')
  AND Away_Teams NOT IN ( 'Arsenal', 'Liverpool', 'Aston Villa' , 'Tottenham')
  )
  Select season, Home_teams, home_stats, Away_Teams
  from Man_city_stats
  where home_stats IN ('lost to', 'drew')
  ;

 --Man City Away lost to teams not strong enough to be in top 5 in 2023/2024 season--
 with Man_city_stats as(
 Select season, 
		 Home_teams,
		 Case when Home_Goals < Away_Goals then 'lost to'
		 when Home_Goals > Away_Goals then 'won'
		 when Home_Goals = Away_Goals then 'drew'
		 end as Away_stats,
		 Away_Teams
  from [Projects].[dbo].[Matches]
  where Away_Teams =  'Manchester city'
  And season in('2023/2024')
  AND Home_Teams NOT IN ( 'Arsenal', 'Liverpool', 'Aston Villa' , 'Tottenham')
  )
  Select season, Home_teams, Away_stats, Away_Teams
  from Man_city_stats
  where Away_stats IN ('won', 'drew');

/**
Looking and comparing the points achieved home and away over 2 seasons
**/
  --Arsenal's total number of points picked home and away by Arsenal in '2022/2023 and 2023/2024--
  
  select season, home_win + home_draws As Home_points, Away_win + Away_draws AS Away_points, home_win + home_draws + Away_win + Away_draws AS Total_points
from (select Season,
		  SUM(CASE WHEN Home_Teams = 'Arsenal' and Home_Goals > Away_Goals THEN 3 END) AS home_win,
		   SUM(CASE WHEN Home_Teams = 'Arsenal' and Home_Goals = Away_Goals THEN 1 END) AS home_draws,
		   SUM(CASE WHEN Away_Teams = 'Arsenal' and Home_Goals < Away_Goals THEN 3 END) AS Away_win,
		   SUM(CASE WHEN Away_Teams = 'Arsenal' and Home_Goals = Away_Goals THEN 1 END) AS Away_draws
	from Projects.dbo.Matches
	where season in ('2022/2023', '2023/2024')
	group by Season) as points
	;

 --Mancity's total number of points picked home and away by Arsenal in '2022/2023 and 2023/2024--

 select season, home_win + home_draws As Home_points, Away_win + Away_draws AS Away_points, home_win + home_draws + Away_win + Away_draws AS Total_points
from (select Season,
		   SUM(CASE WHEN Home_Teams = 'Manchester city' and Home_Goals > Away_Goals THEN 3 END) AS home_win,
		   SUM(CASE WHEN Home_Teams = 'Manchester city' and Home_Goals = Away_Goals THEN 1 END) AS home_draws,
		   SUM(CASE WHEN Away_Teams = 'Manchester city' and Home_Goals < Away_Goals THEN 3 END) AS Away_win,
		   SUM(CASE WHEN Away_Teams = 'Manchester city' and Home_Goals = Away_Goals THEN 1 END) AS Away_draws
	from Projects.dbo.Matches
	where season in ('2022/2023', '2023/2024')
	group by Season) as points
	;
/**
Looking at some other Premiership Statistics in the last seasons
**/

--Percentage of shots vs shots on target -- 
select season, 
	   teams, 
	   Goal_For, 
	   shots,
	   shot_on_target,
	   round(shot_on_target/cast(shots as float)*100,2)as percentage_of_shot_on_target,
	   dense_rank() over(partition by season order by round(shot_on_target/cast(shots as float)*100,2)desc ) rank 
from [Projects].[dbo].[Premiership Statss]
where season = '2023/2024'
order by season desc;

--Percentage of shots resulting into goals-- 
select season, 
	   teams, 
	   Goal_For, 
	   shots,
	   round(Goal_For/cast(shots as float)*100,2)as goal_percentage,
	   dense_rank() over(partition by season order by round(Goal_For/cast(shots as float)*100,2)desc ) rank 
from [Projects].[dbo].[Premiership Statss]
where season = '2023/2024'
order by season desc;


--Average shots and goals per match in 2023/2024 season

select season, 
	   teams, 
	   Goal_For, 
	   shots,
	   round(Goal_For/cast(shots as float)*100,2)as goal_percentage,
	   round(shots,2)/ 38 as Avg_shot_per_match,
	   round(Goal_For/cast(38.0 as float),2) as Avg_goal_per_match,
	   dense_rank() over(partition by season order by shots desc ) rank 
from [Projects].[dbo].[Premiership Statss]
where season in ('2023/2024')
order by season desc;


--Total number of points picked home and away by Arsenal over 2 seasons--

select season, home_win + home_draws As Home_points, Away_win + Away_draws AS Away_points, home_win + home_draws + Away_win + Away_draws AS Total_points
from (select Season,
		   SUM(CASE WHEN Home_Teams = 'Arsenal' and Home_Goals > Away_Goals THEN 3 END) AS home_win,
		   SUM(CASE WHEN Home_Teams = 'Arsenal' and Home_Goals = Away_Goals THEN 1 END) AS home_draws,
		   SUM(CASE WHEN Away_Teams = 'Arsenal' and Home_Goals < Away_Goals THEN 3 END) AS Away_win,
		   SUM(CASE WHEN Away_Teams = 'Arsenal' and Home_Goals = Away_Goals THEN 1 END) AS Away_draws
	from Projects.dbo.Matches
	where season in ('2022/2023', '2023/2024')
	group by Season) as points
	;

 --Total number of points picked home and away by Manchester City over 2 seasons--

 select season, home_win + home_draws As Home_points, Away_win + Away_draws AS Away_points, home_win + home_draws + Away_win + Away_draws AS Total_points
from (select Season,
		   SUM(CASE WHEN Home_Teams = 'Manchester city' and Home_Goals > Away_Goals THEN 3 END) AS home_win,
		   SUM(CASE WHEN Home_Teams = 'Manchester city' and Home_Goals = Away_Goals THEN 1 END) AS home_draws,
		   SUM(CASE WHEN Away_Teams = 'Manchester city' and Home_Goals < Away_Goals THEN 3 END) AS Away_win,
		   SUM(CASE WHEN Away_Teams = 'Manchester city' and Home_Goals = Away_Goals THEN 1 END) AS Away_draws
	from Projects.dbo.Matches
	where season in ('2022/2023', '2023/2024')
	group by Season) as points
	;

	/**Link to the data set below
	https://www.kaggle.com/datasets/evangora/premier-league-data
	**/