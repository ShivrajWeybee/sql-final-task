

-- 1) Write a SQL query to find the name and year of the movies. Return movie title, movie release year
select mov_title, mov_year from movie;

-- 2) write a SQL query to find when the movie ‘American Beauty’ released. Return movie release year.
select mov_year from movie where mov_title = 'American Beauty';

-- 3)  write a SQL query to find the movie, which was made in the year 1999. Return movie title.
select mov_title from movie where mov_year = 1999;

-- 4)  write a SQL query to find those movies, which was made before 1998. Return movie title.
select mov_title from movie where mov_year < 1998;

-- 5) write a SQL query to find the name of all reviewers and movies together in a single list.
select mov_title, 'Movie' from movie
union
select rev_name, 'Reviwer' from reviewer

-- 6) write a SQL query to find all reviewers who have rated 7 or more stars to their rating.
-- Return reviewer name.
select * from reviewer re
inner join rating ra
on re.rev_id=ra.rev_id
where rev_stars >= 7;

-- 7) write a SQL query to find the movies without any rating. Return movie title.
select mov_title 'Movie without rating' from movie m
inner join rating ra
on m.mov_id=ra.mov_id
where rev_stars is NULL OR rev_stars = 0;

-- 8) write a SQL query to find the movies with ID 905 or 907 or 917. Return movie title.
select  mov_title from movie
where mov_id in (905, 907, 917);

-- 9) write a SQL query to find those movie titles, which include the words 'Boogie Nights'.
-- Sort the result-set in ascending order by movie year. Return movie ID, movie title and movie release year.
select mov_id, mov_title, mov_year from movie
where mov_title like '%Boogie Nights%'
order by mov_year asc;

-- 10) write a SQL query to find those actors whose first name is 'Woody' and the last name is 'Allen'.
-- Return actor ID
select act_id from actor
where act_fname = 'Woody' and act_lname = 'Allen';



-----------------------------------------------------------------------------------------------------
------------------------------------------ Subqueires ------------------------------------------
-----------------------------------------------------------------------------------------------------



-- 1) Find the actors who played a role in the movie 'Annie Hall'. Return all the fields of actor table.
select * from actor
where act_id in
(select act_id from movie_cast where mov_id in (select mov_id from movie where mov_title = 'Annie Hall'));

-- 2) write a SQL query to find the director who directed a movie that casted a role for 'Eyes Wide Shut'.
-- Return director first name, last name.
select dir_fname 'First Name', dir_lname 'Last Name' from director
where dir_id in (select dir_id from movie_direction where mov_id in
(select mov_id from movie where mov_title = 'Eyes Wide Shut'));

-- 3) write a SQL query to find those movies, which released in the country besides UK.
-- Return movie title, movie year, movie time, date of release, releasing country.
select mov_title, mov_year mov_time, mov_dt_rel, mov_rel_country from movie
where mov_rel_country != 'UK';

-- 4)  write a SQL query to find those movies where reviewer is unknown.
-- Return movie title, year, release date, director first name, last name, actor first name, last name.
select distinct m.mov_title, m.mov_year, m.mov_dt_rel, d.dir_fname, d.dir_lname, a.act_fname, a.act_lname
from movie m, actor a, director d, reviewer r, rating ra
where m.mov_id=ra.mov_id and ra.rev_id=r.rev_id and r.rev_name is null
(select mov_id from rating where rev_id in (select rev_id from reviewer where rev_name = ' '));

-- 5) write a SQL query to find those movies directed by the director whose first name is ‘Woddy’ and
-- last name is ‘Allen’. Return movie title. 
select mov_title from movie
where mov_id in (select mov_id from movie_direction where dir_id in
(select dir_id from director where dir_fname = 'Woody' and dir_lname = 'Allen'));

-- 6) write a SQL query to find those years, which produced at least one movie and that,
-- received a rating of more than three stars. Sort the result-set in ascending order by movie year.
-- Return movie year.
select mov_year from movie m
where m.mov_id in (select mov_id from rating where rev_stars > 3)
group by mov_year

-- 7) write a SQL query to find those movies, which have no ratings. Return movie title
select mov_title from movie m
where m.mov_id in (select mov_id from rating where rev_stars = 0 or rev_stars is null)
or m.mov_id not in (select mov_id from rating);

-- 8) write a SQL query to find those reviewers who have rated nothing for some movies.
-- Return reviewer name.
select rev_name from reviewer
where rev_id not in (select rev_id from rating)

-- 9) write a SQL query to find those movies, which reviewed by a reviewer and got a rating.
-- Sort the result-set in ascending order by
-- reviewer name, movie title, review Stars. Return reviewer name, movie title, review Stars.
select (select r.rev_name from reviewer r where r.rev_id=ra.rev_id) 'Reviewer Name',
		(select m.mov_title from movie m where m.mov_id=ra.mov_id) 'Movie Name',
		(select ra.rev_stars from reviewer r where r.rev_id=ra.rev_id) 'Review Star'
		from rating ra
where ra.mov_id not in (select mov_id from rating where rev_stars is not null or rev_stars > 0);

-- 10) write a SQL query to find those reviewers who rated more than one movie.
-- Group the result set on reviewer’s name, movie title. Return reviewer’s name, movie title.
select (select r.rev_name from reviewer r where r.rev_id=ra.rev_id) 'Reviewer Name',
		(select m.mov_title from movie m where m.mov_id=ra.mov_id) 'Movie Name'
		from rating ra
where ra.rev_id in (select ra.rev_id from rating ra group by ra.rev_id having COUNT(ra.mov_id) > 1);

-- 11)  write a SQL query to find those movies, which have received highest number of stars.
-- Group the result set on movie title and sorts the result-set in ascending order by movie title.
-- Return movie title and maximum number of review stars.

select m.mov_title, MAX(r.rev_stars) max_rating from movie m, rating r 
where r.rev_stars is not null and m.mov_id in (select mov_id from movie where mov_id = r.mov_id)
group by m.mov_title
order by m.mov_title;


-- 12) write a SQL query to find all reviewers who rated the movie 'American Beauty'.
-- Return reviewer name.
select r.rev_name from reviewer r
where r.rev_id in
(select rev_id from rating where mov_id = (select mov_id from movie where mov_title = 'American Beauty'));

-- 13) write a SQL query to find the movies, which have reviewed by any reviewer body except by 'Paul Monks'.
-- Return movie title. 
select mov_title from movie
where mov_id in
(select mov_id from rating where rev_id in (select rev_id from reviewer where rev_name != 'Paul Monks'));

-- 14) write a SQL query to find the lowest rated movies.
-- Return reviewer name, movie title, and number of stars for those movies.
select (select r.rev_name from reviewer r where r.rev_id=ra.rev_id) 'Reviwer Name',
		(select m.mov_title from movie m where m.mov_id=ra.mov_id) 'Movie Title',
		(select ra.rev_stars from rating ra) 'Rating Stars'
		from rating ra
where rev_id = (select MIN(rev_stars) from rating);

-- 15)  write a SQL query to find the movies directed by 'James Cameron'. Return movie title. 
select mov_title from movie
where mov_id in
(select mov_id from movie_direction where dir_id in
(select dir_id from director where dir_fname+' '+dir_lname = 'James Cameron'));

-- 16) Write a query in SQL to find the name of those movies where one or more actors acted in two or more movies.
select mov_title from movie
where mov_id in (select mov_id from movie_cast where act_id in
(select act_id from movie_cast group by act_id having count(mov_id) > 1));



-----------------------------------------------------------------------------------------------------
------------------------------------------ Joins ------------------------------------------
-----------------------------------------------------------------------------------------------------



-- 1) write a SQL query to find the name of all reviewers who have rated their ratings with a NULL value.
-- Return reviewer name.
select rev_name from reviewer r
inner join rating ra
on r.rev_id=ra.rev_id
where ra.rev_stars is null;

-- 2) write a SQL query to find the actors who were cast in the movie 'Annie Hall'.
-- Return actor first name, last name and role.
select a.act_fname, a.act_lname from actor a
inner join movie_cast mc
on a.act_id=mc.act_id
inner join movie m
on m.mov_id=mc.mov_id
where m.mov_title = 'Annie Hall';

-- 3) write a SQL query to find the director who directed a movie that casted a role for 'Eyes Wide Shut'.
-- Return director first name, last name and movie title.
select d.dir_fname, d.dir_lname, m.mov_title from director d
inner join movie_direction md
on d.dir_id=md.dir_id
inner join movie m
on m.mov_id=md.mov_id
where m.mov_title = 'Eyes Wide Shut';

-- 4) write a SQL query to find who directed a movie that casted a role as ‘Sean Maguire’.
-- Return director first name, last name and movie title.
select d.dir_fname, d.dir_lname, m.mov_title from director d
inner join movie_direction md
on d.dir_id=md.dir_id
inner join movie_cast mc
on md.mov_id=mc.mov_id
inner join movie m
on m.mov_id=mc.mov_id
where mc.role='Sean Maguire'

-- 5) write a SQL query to find the actors who have not acted in any movie between 1990 and 2000
-- (Begin and end values are included). Return actor first name, last name, movie title and release year.
select a.act_fname, a.act_lname, m.mov_title, m.mov_year from actor a
inner join movie_cast mc
on a.act_id=mc.act_id
inner join movie m
on mc.mov_id=m.mov_id
where m.mov_year not between 1990 and 2000;

-- 6) write a SQL query to find the directors with number of genres movies.
-- Group the result set on director first name, last name and generic title.
-- Sort the result-set in ascending order by director first name and last name.
-- Return director first name, last name and number of genres movies.
select d.dir_fname, d.dir_lname, count(mg.gen_id) 'Number of Genres Movie' from director d
inner join movie_direction md
on d.dir_id=md.dir_id
inner join movie_genres mg
on md.mov_id=mg.mov_id
inner join genres g
on mg.gen_id=g.gen_id
group by d.dir_fname, d.dir_lname,g.gen_title
order by d.dir_fname,d.dir_lname;

-- 7) write a SQL query to find the movies with year and genres.
-- Return movie title, movie year and generic title.
select m.mov_title, m.mov_year, g.gen_title from movie m
inner join movie_genres mg
on m.mov_id=mg.mov_id
inner join genres g
on mg.gen_id=g.gen_id;

-- 8) write a SQL query to find all the movies with year, genres, and name of the director.
select m.mov_year, g.gen_title, d.dir_fname+' '+d.dir_lname 'Director' from movie m
left join movie_genres mg
on m.mov_id=mg.mov_id
left join genres g
on mg.gen_id=g.gen_id
left join movie_direction md
on m.mov_id=md.mov_id
left join director d
on md.dir_id=d.dir_id;

-- 9) write a SQL query to find the movies released before 1st January 1989.
-- Sort the result-set in descending order by date of release.
-- Return movie title, release year, date of release, duration, and first and last name of the director.
select m.mov_title, m.mov_year, m.mov_time, d.dir_fname, d.dir_lname from movie m
inner join movie_direction md
on m.mov_id=md.mov_id
inner join director d
on md.dir_id=d.dir_id
where m.mov_year < 1989;

-- 10) write a SQL query to compute the average time and count number of movies for each genre.
-- Return genre title, average time and number of movies for each genre.
select g.gen_title, avg(m.mov_time) 'Average Time', count(m.mov_id) 'Number of movies' from genres g
inner join movie_genres mg
on g.gen_id=mg.gen_id
inner join movie m
on mg.mov_id=m.mov_id
group by g.gen_title;

-- 11) write a SQL query to find movies with the lowest duration.
-- Return movie title, movie year, director first name, last name, actor first name, last name and role.
select m.mov_title, m.mov_year, d.dir_fname+' '+d.dir_lname 'Director Name',
a.act_fname+' '+a.act_lname 'Actor Name', mc.role from movie m
inner join movie_direction md
on m.mov_id=md.mov_id
inner join director d
on md.dir_id=d.dir_id
inner join movie_cast mc
on m.mov_id=mc.mov_id
inner join actor a
on mc.act_id=a.act_id
where m.mov_time = (select MIN(m.mov_time) from movie m);

-- 12) write a SQL query to find those years when a movie received a rating of 3 or 4.
-- Sort the result in increasing order on movie year. Return move year.
select distinct m.mov_year from movie m
inner join rating r
on m.mov_id=r.mov_id
where r.rev_stars between 3 and 4;

-- 13) write a SQL query to get the reviewer name, movie title, and stars
-- in an order that reviewer name will come first, then by movie title, and lastly by number of stars.
select r.rev_name 'Reviwers Name', m.mov_title 'Movie Title', ra.rev_stars 'Review Stars' from reviewer r
inner join rating ra
on r.rev_id=ra.rev_id
inner join movie m
on ra.mov_id=m.mov_id
order by r.rev_name asc, m.mov_title asc, ra.rev_stars asc;

-- 14) write a SQL query to find those movies that have at least one rating and received highest number
-- of stars. Sort the result-set on movie title. Return movie title and maximum review stars.
select m.mov_title, ra.rev_stars from movie m
inner join rating ra
on m.mov_id=ra.mov_id
where ra.num_o_ratings > 0
order by m.mov_title;

-- 15) write a SQL query to find those movies, which have received ratings.
-- Return movie title, director first name, director last name and review stars.
select m.mov_title, d.dir_fname+' '+d.dir_lname 'Director Name', ra.rev_stars from movie m
inner join rating ra
on m.mov_id=ra.mov_id
left join movie_direction md
on m.mov_id=md.mov_id
left join director d
on d.dir_id=md.dir_id
where ra.num_o_ratings > 0;

-- 16) Write a query in SQL to find the movie title, actor first and last name,
-- and the role for those movies where one or more actors acted in two or more movies.
select m.mov_title, a.act_fname+' '+a.act_lname, mc.role from movie m
inner join movie_cast mc
on m.mov_id=mc.mov_id
inner join actor a
on a.act_id=mc.act_id
where a.act_id = (select act_id from movie_cast group by act_id having count(mov_id) > 1);