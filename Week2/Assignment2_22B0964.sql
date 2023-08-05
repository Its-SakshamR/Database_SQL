1.  (select distinct name from instructor)
    union
    (select distinct name from student)

2.  select distinct course.course_id,course.title,teaches.id from course,teaches
    where course.course_id=teaches.course_id

3.  select id,name,salary from instructor
    where salary<75000

4.  select S.dept_name as dept_name, count(id) as Instructors
    from instructor as S
    group by dept_name

5.  select course.title,prereq.course_id,prereq.prereq_id
    from course,prereq
    where course.course_id=prereq.course_id

6.  select instructor.name
    from instructor,department
    where instructor.salary>department.budget*0.1 and instructor.dept_name=department.dept_name

7.  select dept_name 
    from department as A
    where A.building=some(select building
					      from department as B
					      where A.dept_name!=B.dept_name)

8.  select distinct S.dept_name as dept_name, count(id)*5000 as Income
    from student as S
    group by dept_name

9.  select id
    from instructor
    except ((select id from teaches)
		    union
	        (select i_id from advisor))

10. (select distinct S.name, S.id
    from student as S,takes as T,course as C
    where C.dept_name='Comp. Sci.' and T.course_id=C.course_id and S.id=T.id)
    union
    (select distinct S.name, S.id
    from student as S,takes as T,course as C
    where C.dept_name='Biology' and T.course_id=C.course_id and S.id=T.id)

11. (select distinct S.name, S.id
    from student as S,takes as T,course as C
    where C.dept_name='Comp. Sci.' and T.course_id=C.course_id and S.id=T.id)
    intersect
    (select distinct S.name, S.id
    from student as S,takes as T,course as C
    where C.dept_name='Biology' and T.course_id=C.course_id and S.id=T.id)

12. select name,id from student
    where tot_cred>30

13. select I.id,I.name,I.dept_name,D.building
    from instructor as I,department as D
    where I.dept_name=D.dept_name

14. select S.id
    from takes as S
    where S.course_id='CS-101' and
	    exists (select *
		        from takes as T
		        where S.id=T.id and T.course_id='CS-190')

15. select count(distinct takes.id)
    from takes, teaches
    where takes.course_id=teaches.course_id and teaches.id='22222'










1.  select distinct A.title from movies as A, tags as B, ratings as C
    where A.movieid=C.movieid and 
    C.rating >= (select MAX(P.rating)
			  	        from ratings as P,tags as Q
			            where P.movieid=Q.movieid
			            and Q.tag='Quentin Tarantino')
			     and
    	(
        split_part(A.genres,'|',1)='Drama'
        	or
        split_part(A.genres,'|',2)='Drama'
    	    or
        split_part(A.genres,'|',3)='Drama'
        	or
        split_part(A.genres,'|',4)='Drama'
    	    or
        split_part(A.genres,'|',5)='Drama'
        )

2.  select T.userid from ratings as T, movies as S
    where T.movieid=S.movieid and T.movieid<=3 and
    (
    split_part(S.genres,'|',1)='Comedy'
    	or
    split_part(S.genres,'|',2)='Comedy'
    	or
    split_part(S.genres,'|',3)='Comedy'
    	or
    split_part(S.genres,'|',4)='Comedy'
    	or
    split_part(S.genres,'|',5)='Comedy'
    )

3.  select ratings_master.rating,count(A.userid) 
    from ratings as A, movies as B, generate_series(0.0, 5.0, 0.5) as ratings_master(rating)
    where A.movieid=B.movieid and B.title='City Hall (1996)' and A.rating=ratings_master
    group by ratings_master

4.  WITH movie AS (
    Select movieid, title, string_to_array(genres,'|') as genres
    from movies
    )

    Select movieid, title, unnest(genres) as genres
    from movie

5.  WITH normal_movies AS(
	    WITH movie AS (
	    Select movieid, title, string_to_array(genres,'|') as genres
	    from movies
	    )
    
    	Select movieid, title, unnest(genres) as genres
    	from movie
    )

    select distinct genres, count(title) as Number_of_movies
    from normal_movies
    group by genres

6.  WITH normal_movies AS(
        WITH movie AS (
        Select movieid, title, string_to_array(genres,'|') as genres
        from movies
        )
    
       	Select movieid, title, unnest(genres) as genres
    	from movie
    )

    select S.movieid, S.title
    from normal_movies as S, ratings as R
    where S.movieid=R.movieid and S.genres='Children' and 
    R.rating>(select avg(P.rating) from ratings as P, normal_movies as M 
                where M.movieid=P.movieid and M.genres='Comedy')
