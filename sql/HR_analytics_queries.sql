use [HR ]
select * from HR
create view hr_vw_employee_clean as 
select EmployeeNumber,
Age,Gender,
Education,
EducationField,
MaritalStatus,
Department,
JobRole,
JobLevel,
MonthlyIncome,
HourlyRate,
PercentSalaryHike,
BusinessTravel,
DistanceFromHome,
TotalWorkingYears,
YearsAtCompany,
YearsInCurrentRole,
YearsSinceLastPromotion,
TrainingTimesLastYear,
(case when OverTime='Yes' then 1 else 0 end) as OverTimeFlag,
JobSatisfaction,
EnvironmentSatisfaction,
WorkLifeBalance,
JobInvolvement,
RelationshipSatisfaction,
PerformanceRating,
(case when Attrition='Yes' then 1 else 0 end) as AttritionFlag
from HR

------- معدل الدوران ------
select 
count(*) as total_employee,
sum(cast(AttritionFlag as float)) as total_attrition,
100.0 * sum(cast(AttritionFlag as float)) / count(*) as attrition_rate_pct
from hr_vw_employee_clean;

--------- الدوران حسب القسم --------- 
select 
Department,
count(*) as headcount,
sum(cast(AttritionFlag as float)) as Attrition,
100.0 * sum(cast(AttritionFlag as float))/ count(*) as attrition_rate_pct
from hr_vw_employee_clean
group by Department
order by attrition_rate_pct;

--------- الدوران حسب الدور الوظيفي ------- 
select 
JobRole,
count(*) as headcount,
sum(cast(AttritionFlag as float)) as attritions,
100.0 * sum(cast(AttritionFlag as float)) / count(*) as attrition_rate_pct,
avg(MonthlyIncome) as avg_income
from hr_vw_employee_clean
group by JobRole
order by attrition_rate_pct desc;

------------- الدوران حسب الجنس و العمر -------------
--- توزيع الدوران حسب الجنس ----
select 
Gender,
(100.0 * sum(cast(AttritionFlag as float)) / count(*)) as attrition_rate_pct,
count(*) as headcount
from hr_vw_employee_clean
group by Gender;

---- توزيع الدوران حسب الفئات العمرية ----
SELECT 
    CASE 
      WHEN Age BETWEEN 18 AND 25 THEN '18-25'
      WHEN Age BETWEEN 26 AND 35 THEN '26-35'
      WHEN Age BETWEEN 36 AND 45 THEN '36-45'
      ELSE '46+' END AS AgeBand,
    COUNT(*) AS headcount,
    SUM(cast(AttritionFlag as float)) AS attritions,
    100.0 * SUM(cast(AttritionFlag as float)) / COUNT(*) AS attrition_rate_pct
FROM hr_vw_employee_clean
GROUP BY CASE 
      WHEN Age BETWEEN 18 AND 25 THEN '18-25'
      WHEN Age BETWEEN 26 AND 35 THEN '26-35'
      WHEN Age BETWEEN 36 AND 45 THEN '36-45'
      ELSE '46+' END
ORDER BY attrition_rate_pct DESC;

-------------------- الرواتب والمسوتى الوظيفي ----------------
select 
JobLevel,
avg(MonthlyIncome) as avg_income,
100.0 * avg(cast(AttritionFlag as float)) as avg_attrition
from hr_vw_employee_clean
group by JobLevel
order by JobLevel;

------------------- العمل الاضافي وتوازن الحياة -------------
select 
OverTimeFlag,
100.0 * avg(cast(AttritionFlag as float)) as attrition_rate_pct,
avg(cast(WorkLifeBalance as float)) as avg_wlb
from hr_vw_employee_clean
group by OverTimeFlag;

--------------------- الترقيات و التدريب ----------------
select 
JobLevel,
avg(cast(YearsSinceLastPromotion as float)) as avg_years_since_promo,
100.0 * avg(cast(AttritionFlag as float)) as attrition_rate_pct,
avg(cast(TrainingTimesLastYear as float)) as avg_training
from hr_vw_employee_clean
group by JobLevel
order by JobLevel;

---------------------- السفر والمسافة --------------------
select 
BusinessTravel,
100.0 * avg(cast(AttritionFlag as float)) as attrition_rate_pct,
avg(cast(DistanceFromHome as float)) as avg_distance
from hr_vw_employee_clean
group by BusinessTravel
order by attrition_rate_pct desc;

