use Project

select * from INFORMATION_SCHEMA.TABLES
select * from Employee
select * from PerformanceRating

--how many employees are in the company?
select distinct COUNT(*) 
as [Count of all employees]
from Employee

--WHAT IS THEIR EDUCATION LEVEL
select * from EducationLevel   --KEY: No formal qualifications(1),High School(2),Bachelors(3), Masters(4), Doctorate(5)

select Employee.Education,
COUNT (*) as [Employees]
from Employee
group by Education

--who are the the employees with Bachelors, Masters or Doctorate?
--how many are they?
select * from EducationLevel  --KEY:Bachelors(3), Masters(4), Doctorate(5)

select distinct COUNT(*)
as [Count of employees having an undergraduate degree at least]
from Employee
where Education>=3 -- this shows us that majority of employees have at least an undegraduate degree

--LET US BREAK IT DOWN
select Employee.Education,
COUNT (*) as [Employees]
from Employee
where Education>=3
group by Education

select * from Employee
select * from PerformanceRating

--TOTAL NUMBER OF ATTRITIONS?
--KEY: 0-No attrition, 1-Attrition
select Employee.Attrition,
COUNT(Attrition) as [Total Attrition]
from Employee
where Employee.Attrition=1
group by Attrition 


--How many of these are from each gender?
select Employee.Gender,
Count(Attrition) as [Total Attrition]
from Employee
group by Attrition, Gender
having Attrition=1

--What's the attrition level's across the different education levels?
select 
Employee.Education,
EducationLevel.EducationLevel,
Count(Attrition) as [Total Attrition]
from Employee 
LEFT JOIN EducationLevel ON Education=EducationLevelID
where Employee.Attrition=1
group by  Education, EducationLevel


--AVERAGE SALARIES
--What is the overal average salary for the employees?
select AVG(Employee.Salary)
as [Average salary]
from Employee

--What is the overal average salary for each gender?
select Employee.Gender,
AVG(Employee.Salary) as [Average salary]
from Employee
group by Gender

--We get to know that the average salary of females is higher than that of males
--and male attrition is more than female attrition
--could the salaries be involved?
select * from Employee
select * from PerformanceRating
select * from SatisfiedLevel

--Employees who are very dissatisfied
select Employee.EmployeeID,
Employee.LastName, 
Employee.FirstName, 
Employee.Salary,
PerformanceRating.JobSatisfaction
from Employee, PerformanceRating
where Employee.EmployeeID=PerformanceRating.EmployeeID
group by Employee.EmployeeID, LastName, FirstName, Employee.Salary, JobSatisfaction
having JobSatisfaction=1 
--123 employees are very dissatisfied

--what is the number of very dissatisfied and paid below average employees? 
select  Employee.EmployeeID,
LastName,
FirstName, 
JobSatisfaction,
SatisfiedLevel.SatisfactionID,
SatisfiedLevel.SatisfactionLevel,
Employee.Salary
from PerformanceRating 
LEFT JOIN Employee ON PerformanceRating.EmployeeID=Employee.EmployeeID
RIGHT JOIN SatisfiedLevel on PerformanceRating.JobSatisfaction=SatisfiedLevel.SatisfactionID
where JobSatisfaction=1
group by Employee.EmployeeID,LastName,FirstName, JobSatisfaction,SatisfactionID, SatisfactionLevel, Salary
having Salary<112956
--We have 93 employees that are paid below the average salary and are very dissatisfied
--this accounts for 75.6% of all 'very Dissatisfied' employees

select * from Employee
select * from PerformanceRating

--RETENTION VS ATTRITION
--KEY:0-Retention, 1-Attrition
select Employee.Attrition,
count(Attrition) as [Number of Employees]
from Employee
group by Attrition


--DOES WORKING OVERTIME IMPACT ATTRITION?
 --KEY:0-Retention, 1-Attrition
select Employee.Attrition,
count (Employee.OverTime) as [Count of employees with overtime]
from Employee
where Employee.OverTime=1
group by Employee.Attrition, Employee.OverTime 

--who are the employees with both overtime and attrition?
select Employee.EmployeeID,
Employee.LastName,
Employee.FirstName, 
Employee.Attrition, 
Employee.OverTime
from Employee
where Employee.OverTime=1
group by EmployeeID, Employee.Attrition, Employee.OverTime ,LastName, FirstName
having Attrition=1

--HOW MANY EMPLOYEES ARE THERE IN EACH JOBROLE?
select  Employee.JobRole,
count (Employee.JobRole) as [Count of employees]
from Employee
group by Employee.JobRole

--WHAT IS ATTRITION RATE BY JOB ROLE?

select 
Employee.JobRole,
count (Employee.JobRole) as [Count of Attrition]
from Employee
WHERE Attrition=1
group by  JobRole


-- HOW DOES THE NUMBER OF YEARS AT COMPANY AFFECT ATTRITION?
SELECT 
Employee.YearsAtCompany,
COUNT(Attrition) AS [TOTAL ATTRITION]
FROM Employee
where Attrition=1
GROUP BY YearsAtCompany
--Highest rate of attrition is associated with employees having 1 year at the company
--Lowest rate of attrition is associated with employees with 10 years at the company

--HOW DOES THE NUMBER OF YEARS SINCE LAST PROMOTION AFFECT ATTRITION?
SELECT 
Employee.YearsSinceLastPromotion,
COUNT(Attrition) AS [TOTAL ATTRITION]
FROM Employee
where Attrition=1
Group BY YearsSinceLastPromotion
--Highest attrition happens 0 years since last promotion. 
--Least attrition instances occur with 9 years since last promotion. (9 years is the longest number of years since last promotion)
--IRONICAL!!

--HOW DOES THE NUMBER OF YEARS IN MOST RECENT ROLE AFFECT ATTRITION?
SELECT 
Employee.YearsInMostRecentRole,
COUNT(Attrition) AS [TOTAL ATTRITION]
FROM Employee
where Attrition=1
Group BY YearsInMostRecentRole
--Highest rate of attrition depending on years in most recent role is 0 years with 140 attritions (59% of all attritions)
--Lowest rate of attrition depending on years in most recent role is 6 years with 2 attritions

select * from Employee
select * from PerformanceRating
select * from EducationLevel
select * from RatingLevel
select * from SatisfiedLevel


-- HOW SATISFIED WERE THE EMPLOYEES WHO HAD LEFT AT THE TIME OF REVIEW WITH THEIR WORK-LIFE BALANCE
--KEY: Very Dissatisfied(1), Dissatisfied (2), Neutral(3), Satisfied(4), Very Satisfied(5)

select  PerformanceRating.WorkLifeBalance, 
SatisfiedLevel.SatisfactionID,
SatisfiedLevel.SatisfactionLevel,
COUNT(Attrition) as [Total Attrition]
from PerformanceRating 
LEFT JOIN Employee ON PerformanceRating.EmployeeID=Employee.EmployeeID
RIGHT JOIN SatisfiedLevel on PerformanceRating.WorkLifeBalance=SatisfiedLevel.SatisfactionID
group by WorkLifeBalance, Attrition, SatisfactionID, SatisfactionLevel
having Attrition=1 
--The output here is more than the total number of employees since the employees had a review multiple times from 2013 to 2031
--we realize that most attrition comes from people having a work-life balance of 3 and least comes from work life balance of 1. Ironical.
--might also be due to recycling of employee ID's

--Employees and their satisfaction level at some point
SELECT PerformanceRating.EmployeeID, PerformanceRating.ReviewDate,
SatisfiedLevel.SatisfactionLevel
FROM PerformanceRating 
INNER JOIN SatisfiedLevel 
ON WorkLifeBalance=SatisfactionID


--HOW ARE THE EMPLOYEES RETAINED AT THE TIME OF REVIEW SATISFIED WITH THE OFFICE ENVIRONMENT 
SELECT 
DISTINCT count (PerformanceRating.EmployeeID) as [Number of Reviews],
EnvironmentSatisfaction,
SatisfactionLevel
FROM PerformanceRating 
left join SatisfiedLevel on EnvironmentSatisfaction=SatisfactionID
INNER JOIN Employee ON Employee.EmployeeID=PerformanceRating.EmployeeID
WHERE Attrition=0
GROUP BY EnvironmentSatisfaction, SatisfactionLevel

--WHAT OF THE ONES NOT RETAINED
SELECT 
DISTINCT count (PerformanceRating.EmployeeID) as [Number of Reviews],
EnvironmentSatisfaction,
SatisfactionLevel
FROM PerformanceRating 
left join SatisfiedLevel on EnvironmentSatisfaction=SatisfactionID
INNER JOIN Employee ON Employee.EmployeeID=PerformanceRating.EmployeeID
WHERE Attrition=1
GROUP BY EnvironmentSatisfaction, SatisfactionLevel

--SATISFACTION WITH THE MANAGER 
--Retention
SELECT 
DISTINCT count (PerformanceRating.EmployeeID) as [Number of Reviews],
ManagerRating,
RatingLevel.RatingLevel
FROM PerformanceRating 
left join RatingLevel on ManagerRating=RatingID
INNER JOIN Employee ON Employee.EmployeeID=PerformanceRating.EmployeeID
WHERE Attrition=0
GROUP BY ManagerRating, RatingLevel.RatingLevel

--Attrition
SELECT 
DISTINCT count (PerformanceRating.EmployeeID) as [Number of Reviews],
ManagerRating,
RatingLevel.RatingLevel
FROM PerformanceRating 
left join RatingLevel on ManagerRating=RatingID
INNER JOIN Employee ON Employee.EmployeeID=PerformanceRating.EmployeeID
WHERE Attrition=1
GROUP BY ManagerRating, RatingLevel.RatingLevel