use genzdataset;

show tables;

select * from learning_aspirations;

select * from manager_aspirations;

select * from mission_aspirations;

select * from personalized_info;

-- Question 1: What Percentage of Male and Female wants to go to office everyday?

SELECT  
    ROUND((SUM(CASE WHEN p.Gender like 'Male%' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS Male_aspirants,
    ROUND((SUM(CASE WHEN p.Gender like 'Female%' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS Female_aspirants
FROM personalized_info p
INNER JOIN learning_aspirations l
ON p.ResponseID = l.ResponseID
WHERE l.PreferredWorkingEnvironment like 'Every Day%';

-- Question 2: What percentage of GenZ's who have choosen their career in business operations are most likely to be influenced by their parents?

SELECT  
    ROUND((SUM(CASE WHEN ClosestAspirationalCareer like 'Business Operations%' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS Genz_bo_aspirants
FROM learning_aspirations 
WHERE CareerInfluenceFactor='My Parents';

-- Question 3: What Percentage of GenZ prefer opting for higher studies, Give a genderwise approach.

SELECT 
     ROUND((SUM(CASE WHEN p.gender like 'Male%' THEN 1 ELSE 0 END) / COUNT(*)) * 100,2) AS Male_aspirants,
     ROUND((SUM(CASE WHEN p.gender like 'Female%' THEN 1 ELSE 0 END) / COUNT(*)) * 100,2) AS Female_aspirants
FROM personalized_info p
INNER JOIN learning_aspirations l
ON p.ResponseID = l.ResponseID
WHERE HigherEducationAbroad like 'Yes%';

-- Question 4: What percentages of GenZ are willing and not willing to work for a company whose missions are misaligned with their public actions and even their products? (Give Gender Wise Split)

SELECT 
      ROUND((SUM(CASE WHEN p.gender like 'Male%' AND MisalignedMissionLikelihood like 'Will work%' THEN 1 ELSE 0 END) / COUNT(*)) * 100,2) AS Male_willingtowork,
      ROUND((SUM(CASE WHEN p.gender like 'Male%' AND MisalignedMissionLikelihood like 'Will NOT work%' THEN 1 ELSE 0 END) / COUNT(*)) * 100,2) AS Male_Notwillingtowork,
      ROUND((SUM(CASE WHEN p.gender like 'Female%' AND MisalignedMissionLikelihood like 'Will work%' THEN 1 ELSE 0 END) / COUNT(*)) * 100,2) AS Female_willingtowork,
	  ROUND((SUM(CASE WHEN p.gender like 'Female%' AND MisalignedMissionLikelihood like 'Will NOT work%' THEN 1 ELSE 0 END) / COUNT(*)) * 100,2) AS Female_Notwillingtowork
FROM personalized_info p
INNER JOIN mission_aspirations m
ON p.ResponseID=m.ResponseID;

-- Question 5: What is the most suitable working environment according to female GenZ?

SELECT PreferredWorkingEnvironment,COUNT(*) AS most_preferred_workenvironment
FROM learning_aspirations l
INNER JOIN personalized_info p
ON l.ResponseID=p.ResponseID
WHERE p.Gender like 'Female%'
GROUP BY PreferredWorkingEnvironment
ORDER BY COUNT(*) DESC
LIMIT 1;

-- Question 6: Calculate the Total no of females who aspire to work in their closest aspirational career and have a social impact likelihood of 1 to 5.

SELECT COUNT(p.gender) AS female_aspirants
FROM personalized_info p
INNER JOIN mission_aspirations m1 ON p.ResponseID=m1.ResponseID
INNER JOIN learning_aspirations l ON p.ResponseID=l.ResponseID
WHERE p.Gender like 'Female%'
AND m1.NoSocialImpactLikelihood between 1 AND 5;

-- Question 7: Retrieve the Males who are interested in Higher studies abroad and have career influence factor of 'My Parents'

SELECT P.ResponseID,p.gender,l.CareerInfluenceFactor, l.HigherEducationAbroad
FROM personalized_info p
INNER JOIN learning_aspirations l
ON p.ResponseID=l.ResponseID
WHERE p.Gender like 'Male%' 
AND l.CareerInfluenceFactor='My Parents'
AND l.HigherEducationAbroad like 'Yes%';

-- Question 8: Determine the percentage of gender who have a no social impact likelihood of 8-10 among those who are interested in Higher Education Abroad

SELECT
    ROUND((SUM(CASE WHEN p.Gender like 'Male%' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS Male_aspirants,
    ROUND((SUM(CASE WHEN p.Gender like 'Female%' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS Female_aspirants
FROM Personalized_info p
INNER JOIN mission_aspirations m1 ON p.ResponseID=m1.ResponseID
INNER JOIN learning_aspirations l ON p.ResponseID=l.ResponseID
WHERE m1.NoSocialImpactLikelihood BETWEEN 8 AND 10
AND l.HigherEducationAbroad like 'Yes%';

-- Question 9: Give a Detailed Split of the GenZ preferences to work with Teams, 
-- Data should include Male, Female, and overall in counts and also the overall in %.

SELECT
	SUM(CASE WHEN p.Gender like 'Male%' THEN 1 ELSE 0 END) AS male_count,
    SUM(CASE WHEN p.Gender like 'Female%' THEN 1 ELSE 0 END) AS female_count,
    ROUND((SUM(CASE WHEN p.Gender like 'Male%' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS male_percent,
    ROUND((SUM(CASE WHEN p.Gender like 'Female%' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS female_percent
FROM Personalized_info p
INNER JOIN manager_aspirations m2 
ON p.ResponseID=m2.ResponseID
WHERE m2.PreferredWorkSetup like '%Team%';

-- Question 10: Give a detailed breakdown of worklikelihood3years for each gender

SELECT m2.WorkLikelihood3Years,
       SUM(CASE WHEN p.Gender like 'Male%' THEN 1 ELSE 0 END) AS male_count,
       SUM(CASE WHEN p.Gender like 'Female%' THEN 1 ELSE 0 END) AS female_count 
FROM Personalized_info p
INNER JOIN manager_aspirations m2 
ON p.ResponseID = m2.ResponseID
GROUP BY m2.WorkLikelihood3Years;

-- Question 11: Give a detailed breakdown of worklikelihood3years for each state in India

WITH state_cte AS (
SELECT responseid,
    CASE
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '11' AND '11' THEN 'Delhi'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '12' AND '13' THEN 'Haryana'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '14' AND '16' THEN 'Punjab'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '17' AND '17' THEN 'Himachal Pradesh'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '18' AND '19' THEN 'Jammu & Kashmir'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '20' AND '28' THEN 'Uttar Pradesh'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '30' AND '34' THEN 'Rajasthan'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '36' AND '39' THEN 'Gujarat'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '40' AND '44' THEN 'Maharashtra'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '45' AND '48' THEN 'Madhya Pradesh'
        WHEN SUBSTRING(zipcode, 1, 2) = '49' THEN 'Chhattisgarh'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '50' AND '53' THEN 'Andhra Pradesh / Telangana'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '56' AND '59' THEN 'Karnataka'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '60' AND '64' THEN 'Tamil Nadu'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '67' AND '69' THEN 'Kerala'
        WHEN SUBSTRING(zipcode, 1, 3) = '682' THEN 'Lakshadweep'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '70' AND '74' THEN 'West Bengal'
        WHEN SUBSTRING(zipcode, 1, 3) = '744' THEN 'Andaman & Nicobar'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '75' AND '77' THEN 'Orissa'
        WHEN SUBSTRING(zipcode, 1, 2) = '78' THEN 'Assam'
        WHEN SUBSTRING(zipcode, 1, 2) = '79' THEN 'Arunachal Pradesh / Manipur / Meghalaya / Mizoram / Nagaland / Tripura'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '80' AND '85' THEN 'Bihar / Jharkhand'
        ELSE 'Unknown'
    END AS state
FROM personalized_info
)
SELECT s.state,m.WorkLikelihood3Years,count(*) as record_count
FROM state_cte s
INNER JOIN manager_aspirations m
ON s.Responseid=m.ResponseID
GROUP BY state,WorkLikelihood3Years
ORDER BY record_count DESC;

-- Question 12: What is the average starting salary expectation at 3 year mark for each gender

SELECT p.Gender,
    AVG(CAST(SUBSTRING_INDEX(ExpectedSalary3Years, 'k', 1) AS SIGNED)) AS average_starting_salary
FROM personalized_info p
INNER JOIN mission_aspirations m2 
ON p.ResponseID = m2.ResponseID
GROUP BY p.Gender;

-- Question 13: What is the average starting salary expectation at 5 year mark for each gender

SELECT p.Gender,
    AVG(CAST(SUBSTRING_INDEX(ExpectedSalary5Years, 'k', 1) AS SIGNED)) AS average_starting_salary
FROM personalized_info p
INNER JOIN mission_aspirations m2 
ON p.ResponseID = m2.ResponseID
GROUP BY p.Gender;

-- Question 14: What is the average higher bar salary expectation at 3 year mark for each gender

SELECT p.Gender,
       AVG(CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(ExpectedSalary3Years,'to',-1),'k',1) AS SIGNED)) AS average_higherbar_salary
FROM personalized_info p
INNER JOIN mission_aspirations m2 
ON p.ResponseID = m2.ResponseID
GROUP BY p.Gender;

-- Question 15: What is the average higher bar salary expectation at 5 year mark for each gender

SELECT p.Gender,
	   AVG(CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(ExpectedSalary5Years,'to',-1),'k',1) AS SIGNED)) AS average_higherbar_salary
FROM personalized_info p
INNER JOIN mission_aspirations m2
ON p.ResponseID = m2.ResponseID
GROUP BY p.Gender;

-- Question 16: What is the average starting salary expectations at 3 year mark for each gender and each state in india

WITH state AS (
SELECT ResponseID, Gender,
    CASE
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '11' AND '11' THEN 'Delhi'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '12' AND '13' THEN 'Haryana'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '14' AND '16' THEN 'Punjab'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '17' AND '17' THEN 'Himachal Pradesh'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '18' AND '19' THEN 'Jammu & Kashmir'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '20' AND '28' THEN 'Uttar Pradesh'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '30' AND '34' THEN 'Rajasthan'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '36' AND '39' THEN 'Gujarat'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '40' AND '44' THEN 'Maharashtra'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '45' AND '48' THEN 'Madhya Pradesh'
        WHEN SUBSTRING(zipcode, 1, 2) = '49' THEN 'Chhattisgarh'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '50' AND '53' THEN 'Andhra Pradesh / Telangana'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '56' AND '59' THEN 'Karnataka'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '60' AND '64' THEN 'Tamil Nadu'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '67' AND '69' THEN 'Kerala'
        WHEN SUBSTRING(zipcode, 1, 3) = '682' THEN 'Lakshadweep'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '70' AND '74' THEN 'West Bengal'
        WHEN SUBSTRING(zipcode, 1, 3) = '744' THEN 'Andaman & Nicobar'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '75' AND '77' THEN 'Orissa'
        WHEN SUBSTRING(zipcode, 1, 2) = '78' THEN 'Assam'
        WHEN SUBSTRING(zipcode, 1, 2) = '79' THEN 'Arunachal Pradesh / Manipur / Meghalaya / Mizoram / Nagaland / Tripura'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '80' AND '85' THEN 'Bihar / Jharkhand'
        ELSE 'Unknown'
    END AS state
FROM personalized_info
),
avg_salary as(
SELECT s.state,s.Gender,
    AVG(CAST(SUBSTRING_INDEX(ExpectedSalary3Years, 'k', 1) AS SIGNED)) AS average_starting_salary
FROM state s
INNER JOIN mission_aspirations m2 
ON s.ResponseID = m2.ResponseID
GROUP BY s.state,s.Gender
ORDER BY s.state
)
SELECT state,
	SUM(CASE WHEN gender LIKE 'Female%' THEN average_starting_salary ELSE 0 END) AS female_avg_sal,
    SUM(CASE WHEN gender LIKE 'Male%' THEN average_starting_salary ELSE 0 END) AS male_avg_sal
from avg_salary
group by 1;

-- Question 17: What is the average starting salary expectations at 5 year mark for each gender and each state in india

WITH state AS (
SELECT ResponseID, Gender,
    CASE
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '11' AND '11' THEN 'Delhi'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '12' AND '13' THEN 'Haryana'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '14' AND '16' THEN 'Punjab'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '17' AND '17' THEN 'Himachal Pradesh'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '18' AND '19' THEN 'Jammu & Kashmir'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '20' AND '28' THEN 'Uttar Pradesh'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '30' AND '34' THEN 'Rajasthan'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '36' AND '39' THEN 'Gujarat'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '40' AND '44' THEN 'Maharashtra'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '45' AND '48' THEN 'Madhya Pradesh'
        WHEN SUBSTRING(zipcode, 1, 2) = '49' THEN 'Chhattisgarh'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '50' AND '53' THEN 'Andhra Pradesh / Telangana'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '56' AND '59' THEN 'Karnataka'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '60' AND '64' THEN 'Tamil Nadu'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '67' AND '69' THEN 'Kerala'
        WHEN SUBSTRING(zipcode, 1, 3) = '682' THEN 'Lakshadweep'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '70' AND '74' THEN 'West Bengal'
        WHEN SUBSTRING(zipcode, 1, 3) = '744' THEN 'Andaman & Nicobar'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '75' AND '77' THEN 'Orissa'
        WHEN SUBSTRING(zipcode, 1, 2) = '78' THEN 'Assam'
        WHEN SUBSTRING(zipcode, 1, 2) = '79' THEN 'Arunachal Pradesh / Manipur / Meghalaya / Mizoram / Nagaland / Tripura'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '80' AND '85' THEN 'Bihar / Jharkhand'
        ELSE 'Unknown'
    END AS state
FROM personalized_info
),
avg_salary as (
SELECT s.state,s.Gender,
    AVG(CAST(SUBSTRING_INDEX(ExpectedSalary5Years, 'k', 1) AS SIGNED)) AS average_starting_salary
FROM state s
INNER JOIN mission_aspirations m2 
ON s.ResponseID = m2.ResponseID
GROUP BY s.state,s.Gender
ORDER BY s.state)

SELECT state,
SUM(CASE WHEN gender LIKE 'Female%' THEN average_starting_salary ELSE 0 END) AS female_avg_sal,
SUM(CASE WHEN gender LIKE 'Male%' THEN average_starting_salary ELSE 0 END) AS Male_avg_sal
FROM avg_salary
GROUP BY 1;

-- Question 18: What is the average higher bar salary expectations at 3 year mark for each gender and each state in india

WITH state AS (
SELECT ResponseID, Gender,
    CASE
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '11' AND '11' THEN 'Delhi'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '12' AND '13' THEN 'Haryana'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '14' AND '16' THEN 'Punjab'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '17' AND '17' THEN 'Himachal Pradesh'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '18' AND '19' THEN 'Jammu & Kashmir'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '20' AND '28' THEN 'Uttar Pradesh'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '30' AND '34' THEN 'Rajasthan'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '36' AND '39' THEN 'Gujarat'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '40' AND '44' THEN 'Maharashtra'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '45' AND '48' THEN 'Madhya Pradesh'
        WHEN SUBSTRING(zipcode, 1, 2) = '49' THEN 'Chhattisgarh'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '50' AND '53' THEN 'Andhra Pradesh / Telangana'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '56' AND '59' THEN 'Karnataka'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '60' AND '64' THEN 'Tamil Nadu'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '67' AND '69' THEN 'Kerala'
        WHEN SUBSTRING(zipcode, 1, 3) = '682' THEN 'Lakshadweep'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '70' AND '74' THEN 'West Bengal'
        WHEN SUBSTRING(zipcode, 1, 3) = '744' THEN 'Andaman & Nicobar'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '75' AND '77' THEN 'Orissa'
        WHEN SUBSTRING(zipcode, 1, 2) = '78' THEN 'Assam'
        WHEN SUBSTRING(zipcode, 1, 2) = '79' THEN 'Arunachal Pradesh / Manipur / Meghalaya / Mizoram / Nagaland / Tripura'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '80' AND '85' THEN 'Bihar / Jharkhand'
        ELSE 'Unknown'
    END AS state
FROM personalized_info
),
avg_salary as (
SELECT s.state,s.Gender,
    AVG(CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(ExpectedSalary3Years, 'to', -1),'k',1) AS SIGNED)) AS average_higherbar_salary
FROM state s
INNER JOIN mission_aspirations m2 
ON s.ResponseID = m2.ResponseID
GROUP BY s.state,s.Gender
ORDER BY s.state)

SELECT state,
SUM(CASE WHEN gender LIKE 'Female%' THEN average_higherbar_salary ELSE 0 END) AS female_avg_sal,
SUM(CASE WHEN gender LIKE 'Male%' THEN average_higherbar_salary ELSE 0 END) AS male_avg_sal
FROM avg_salary
GROUP BY 1;

-- Question 19: What is the average higher bar salary expectations at 5 year mark for each gender and each state in india

WITH state AS (
SELECT ResponseID, Gender,
    CASE
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '11' AND '11' THEN 'Delhi'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '12' AND '13' THEN 'Haryana'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '14' AND '16' THEN 'Punjab'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '17' AND '17' THEN 'Himachal Pradesh'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '18' AND '19' THEN 'Jammu & Kashmir'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '20' AND '28' THEN 'Uttar Pradesh'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '30' AND '34' THEN 'Rajasthan'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '36' AND '39' THEN 'Gujarat'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '40' AND '44' THEN 'Maharashtra'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '45' AND '48' THEN 'Madhya Pradesh'
        WHEN SUBSTRING(zipcode, 1, 2) = '49' THEN 'Chhattisgarh'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '50' AND '53' THEN 'Andhra Pradesh / Telangana'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '56' AND '59' THEN 'Karnataka'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '60' AND '64' THEN 'Tamil Nadu'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '67' AND '69' THEN 'Kerala'
        WHEN SUBSTRING(zipcode, 1, 3) = '682' THEN 'Lakshadweep'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '70' AND '74' THEN 'West Bengal'
        WHEN SUBSTRING(zipcode, 1, 3) = '744' THEN 'Andaman & Nicobar'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '75' AND '77' THEN 'Orissa'
        WHEN SUBSTRING(zipcode, 1, 2) = '78' THEN 'Assam'
        WHEN SUBSTRING(zipcode, 1, 2) = '79' THEN 'Arunachal Pradesh / Manipur / Meghalaya / Mizoram / Nagaland / Tripura'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '80' AND '85' THEN 'Bihar / Jharkhand'
        ELSE 'Unknown'
    END AS state
FROM personalized_info
),
avg_salary as (
SELECT s.state,s.Gender,
    AVG(CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(ExpectedSalary5Years, 'to', -1),'k',1) AS SIGNED)) AS average_higherbar_salary
FROM state s
INNER JOIN mission_aspirations m2 
ON s.ResponseID = m2.ResponseID
GROUP BY s.state,s.Gender
ORDER BY s.state)

SELECT state,
SUM(CASE WHEN gender LIKE 'Female%' THEN average_higherbar_salary ELSE 0 END) AS female_avg_sal,
SUM(CASE WHEN gender LIKE 'Male%' THEN average_higherbar_salary ELSE 0 END) AS male_avg_sal
FROM avg_salary
GROUP BY 1;

-- Question 20: Give a detailed breakdown of the possibility of GenZ working for an org if the 'mission is misaligned' for each state in india

WITH state AS (
SELECT ResponseID, Gender,
    CASE
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '11' AND '11' THEN 'Delhi'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '12' AND '13' THEN 'Haryana'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '14' AND '16' THEN 'Punjab'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '17' AND '17' THEN 'Himachal Pradesh'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '18' AND '19' THEN 'Jammu & Kashmir'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '20' AND '28' THEN 'Uttar Pradesh'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '30' AND '34' THEN 'Rajasthan'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '36' AND '39' THEN 'Gujarat'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '40' AND '44' THEN 'Maharashtra'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '45' AND '48' THEN 'Madhya Pradesh'
        WHEN SUBSTRING(zipcode, 1, 2) = '49' THEN 'Chhattisgarh'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '50' AND '53' THEN 'Andhra Pradesh / Telangana'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '56' AND '59' THEN 'Karnataka'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '60' AND '64' THEN 'Tamil Nadu'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '67' AND '69' THEN 'Kerala'
        WHEN SUBSTRING(zipcode, 1, 3) = '682' THEN 'Lakshadweep'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '70' AND '74' THEN 'West Bengal'
        WHEN SUBSTRING(zipcode, 1, 3) = '744' THEN 'Andaman & Nicobar'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '75' AND '77' THEN 'Orissa'
        WHEN SUBSTRING(zipcode, 1, 2) = '78' THEN 'Assam'
        WHEN SUBSTRING(zipcode, 1, 2) = '79' THEN 'Arunachal Pradesh / Manipur / Meghalaya / Mizoram / Nagaland / Tripura'
        WHEN SUBSTRING(zipcode, 1, 2) BETWEEN '80' AND '85' THEN 'Bihar / Jharkhand'
        ELSE 'Unknown'
    END AS state
FROM personalized_info
),
mission as (
		SELECT s.state,s.Gender,
		SUM(CASE WHEN MisalignedMissionLikelihood like 'Will work%' THEN 1 ELSE 0 END) AS will_work,
        SUM(CASE WHEN MisalignedMissionLikelihood like 'Will NOT%' THEN 1 ELSE 0 END) AS willnot_work
FROM state s
INNER JOIN mission_aspirations m2
ON s.ResponseID=m2.ResponseID
GROUP BY s.state,s.Gender)

SELECT state,
SUM(CASE WHEN gender LIKE 'Female%' THEN will_work ELSE 0 END) AS female_willwork,
SUM(CASE WHEN gender LIKE 'Male%' THEN will_work ELSE 0 END) AS male_willwork,
SUM(CASE WHEN gender LIKE 'Female%' THEN willnot_work ELSE 0 END) AS female_willnotwork,
SUM(CASE WHEN gender LIKE 'Male%' THEN willnot_work ELSE 0 END) AS male_willnotwork
FROM mission
GROUP BY 1;

