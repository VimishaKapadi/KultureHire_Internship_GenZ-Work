use genzdataset;

show tables;


select * from learning_aspirations;

select * from manager_aspiartions;

select * from mission_aspirations;

select * from personalized_info;


-- Question 1: How many Males have responded from India

SELECT COUNT(*) AS Male_Respondents
FROM personalized_info 
WHERE Gender like "Male%" AND CurrentCountry="India";  

-- Question 2: How many Females have responded from India
SELECT COUNT(*) AS Female_Respondents 
FROM personalized_info 
WHERE Gender like "Fe%" AND CurrentCountry="India";

-- Question 3: How many GenZ are influenced by their parents in regards to their career choices from India

SELECT COUNT(*) AS Genz_aspirants
FROM learning_aspirations
WHERE CareerInfluenceFactor="My Parents";

-- Question 4: How many Female GenZ are influenced by their parents in regards to their career choices from India

SELECT COUNT(*) AS Female_aspirants 
FROM personalized_info p
INNER JOIN learning_aspirations l
ON p.ResponseID=l.ResponseID
WHERE p.Gender like "Fe%" AND p.CurrentCountry='India'AND l.CareerInfluenceFactor="My Parents";

-- Question 5: How many Male GenZ are influenced by their parents in regards to their career choices from India

SELECT COUNT(*) AS Male_aspirants 
FROM personalized_info p
INNER JOIN learning_aspirations l
ON p.ResponseID=l.ResponseID
WHERE p.Gender like "Male%" 
AND p.CurrentCountry='India'
AND l.CareerInfluenceFactor="My Parents";

-- Question 6: How many Male and Female GenZ are influenced by their parents in regards to their career choices from India

SELECT
    COUNT(CASE WHEN p.Gender like 'Male%' THEN 1 END) AS Male_aspirants,
    COUNT(CASE WHEN p.Gender like 'Female%' THEN 1 END) AS Female_aspirants
FROM personalized_info p
JOIN learning_aspirations l 
ON p.ResponseID = l.ResponseID 
WHERE l.CareerInfluenceFactor = 'My Parents' 
AND p.CurrentCountry = 'India';

-- Question 7: How many GenZ are influenced by Social Media and Influencers together from India

SELECT
	COUNT( CASE WHEN l.CareerInfluenceFactor like 'Social%' then 1 end ) AS SocialMedia,
	COUNT( CASE WHEN l.CareerInfluenceFactor like 'Influencers%' then 1 end ) AS Influencers 
FROM learning_aspirations l
JOIN personalized_info p 
ON  p.ResponseID = l.ResponseID 
WHERE p.CurrentCountry = 'India';

-- Question 8: How many Gen-Z are infuenced by Social Media and Influencers together, display for Male and Female seperately from India

SELECT CareerInfluenceFactor,
    COUNT(CASE WHEN p.Gender like 'Male%' THEN 1 END) AS Male_aspirants,
    COUNT(CASE WHEN p.Gender like 'Female%' THEN 1 END) AS Female_aspirants
FROM personalized_info p
JOIN learning_aspirations l 
ON p.ResponseID = l.ResponseID 
WHERE p.CurrentCountry = 'India'
GROUP BY l.CareerInfluenceFactor
LIMIT 2
OFFSET 1;

-- Question 9: How many of the Gen-Z who are influenced by the social media for their career aspiration are looking to go abroad

SELECT COUNT(*) AS Genz_aspirants 
FROM learning_aspirations
WHERE HigherEducationAbroad like 'Yes%' 
AND CareerInfluenceFactor like 'Social%' ;

-- Question 10: How many of the Gen-Z who are influenced by "people in their circle" for career aspiration are looking to go abroad

SELECT COUNT(*) AS Genz_aspirants
FROM learning_aspirations
WHERE HigherEducationAbroad like 'Yes%'
AND CareerInfluenceFactor like '%circle%';
