/* -----------------------------------------------------------
   HOSPITAL PATIENT & TREATMENT ANALYSIS
   Author: Yogesh Dange
   Purpose: SQL tasks for operational & analytical insights
   Dataset: Hospital Patient Dataset (Kaggle)
-------------------------------------------------------------- */
CREATE TABLE hospital -- define columns
LOAD DATA LOCAL INFILE 'C:\Users\Admin\Desktop\Hospital Project'
INTO TABLE hospital
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


/* ===========================
   1. AVG TREATMENT COST PER DOCTOR
============================== */
SELECT
    doctor_id,
    doctor_name,
    ROUND(AVG(treatment_cost), 2) AS avg_treatment_cost,
    COUNT(*) AS patients_treated
FROM patients
GROUP BY doctor_id, doctor_name
ORDER BY avg_treatment_cost DESC;



/* ===========================
   2. BUSIEST DEPARTMENTS
============================== */
SELECT
    department,
    COUNT(*) AS total_admissions,
    COUNT(DISTINCT patient_id) AS unique_patients
FROM patients
GROUP BY department
ORDER BY total_admissions DESC;



/* ===========================
   3. PATIENTS WITH LONGEST HOSPITAL STAYS
============================== */
SELECT
    patient_id,
    department,
    diagnosis,
    admission_date,
    discharge_date,
    DATEDIFF(discharge_date, admission_date) AS stay_days
FROM patients
WHERE discharge_date IS NOT NULL
ORDER BY stay_days DESC
LIMIT 20;



/* ===========================
   4. MONTHLY ADMISSION / DISCHARGE STATISTICS
============================== */
SELECT
    DATE_FORMAT(admission_date, '%Y-%m') AS month,
    COUNT(*) AS total_admissions,
    SUM(CASE WHEN discharge_date IS NOT NULL THEN 1 ELSE 0 END) AS total_discharges
FROM patients
GROUP BY month
ORDER BY month;



/* ===========================
   5. RANK DOCTORS BY PATIENTS TREATED
============================== */
SELECT
    doctor_id,
    doctor_name,
    COUNT(*) AS patients_treated
FROM patients
GROUP BY doctor_id, doctor_name
ORDER BY patients_treated DESC;



/* ===========================
   6. READMISSION RATES PER DEPARTMENT
      readmitted_flag = 1 means patient returned
============================== */
SELECT
    department,
    SUM(CASE WHEN readmitted_flag = 1 THEN 1 ELSE 0 END) AS readmissions,
    COUNT(*) AS total_cases,
    ROUND(
        (SUM(CASE WHEN readmitted_flag = 1 THEN 1 ELSE 0 END) 
        / COUNT(*)) * 100, 
    2) AS readmission_rate_pct
FROM patients
GROUP BY department
ORDER BY readmission_rate_pct DESC;



/* ===========================
   7. AVG WAITING TIME BEFORE TREATMENT (IN MINUTES)
============================== */
SELECT
    department,
    ROUND(AVG(
        TIMESTAMPDIFF(
            MINUTE,
            waiting_start_time,
            treatment_start_time
        )
    ), 2) AS avg_wait_minutes
FROM patients
WHERE waiting_start_time IS NOT NULL
  AND treatment_start_time IS NOT NULL
GROUP BY department
ORDER BY avg_wait_minutes DESC;



/* ===========================
   8. OPTIONAL: TOP COSTLY TREATMENTS
============================== */
SELECT
    treatment,
    ROUND(AVG(treatment_cost), 2) AS avg_cost,
    COUNT(*) AS treatment_count
FROM patients
GROUP BY treatment
ORDER BY avg_cost DESC
LIMIT 15;



/* ===========================
   9. OPTIONAL: AGE-GROUP ADMISSION STATS
============================== */
SELECT
    CASE 
        WHEN age < 18 THEN 'Child (0-17)'
        WHEN age BETWEEN 18 AND 35 THEN 'Young Adult (18-35)'
        WHEN age BETWEEN 36 AND 55 THEN 'Middle Age (36-55)'
        ELSE 'Senior (56+)'
    END AS age_group,
    COUNT(*) AS total_patients
FROM patients
GROUP BY age_group
ORDER BY total_patients DESC;



/* ===========================
   END OF SCRIPT
============================== */
