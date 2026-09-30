-- SAIT Medical Clinic - Query Test Script
SET search_path TO sait_medical_clinic;

-- Q1. Total patients
SELECT COUNT(*) AS total_patients FROM patient;

-- Q2. Patients who visited last month
SELECT COUNT(DISTINCT a.patient_id) AS patients_visited_last_month
FROM visit v
JOIN appointment a ON a.appointment_id = v.appointment_id
WHERE v.visit_date >= DATE_TRUNC('month', (SELECT MAX(visit_date) FROM visit)) - INTERVAL '1 month'
  AND v.visit_date < DATE_TRUNC('month', (SELECT MAX(visit_date) FROM visit));

-- Q3. Total billed
SELECT ROUND(SUM(amount),2) AS total_billed FROM bill;

-- Q4. Aggregation
SELECT d.doctor_id, CONCAT(d.first_name,' ',d.last_name) AS doctor_name,
       COUNT(b.bill_id) AS number_of_bills,
       ROUND(AVG(b.amount),2) AS average_bill,
       ROUND(SUM(b.amount),2) AS total_billed
FROM doctor d JOIN bill b ON d.doctor_id=b.doctor_id
GROUP BY d.doctor_id,d.first_name,d.last_name
ORDER BY total_billed DESC;

-- Q5. Subquery + JOIN
SELECT p.patient_id, CONCAT(p.first_name,' ',p.last_name) AS patient_name,
       ROUND(SUM(b.amount),2) AS patient_total
FROM patient p JOIN bill b ON p.patient_id=b.patient_id
GROUP BY p.patient_id,p.first_name,p.last_name
HAVING SUM(b.amount) > (
    SELECT AVG(patient_total)
    FROM (SELECT patient_id,SUM(amount) AS patient_total FROM bill GROUP BY patient_id) patient_totals
)
ORDER BY patient_total DESC;

-- Q6. GROUP BY + HAVING
SELECT d.doctor_id, CONCAT(d.first_name,' ',d.last_name) AS doctor_name,
       ROUND(SUM(b.amount),2) AS total_billed
FROM doctor d JOIN bill b ON d.doctor_id=b.doctor_id
GROUP BY d.doctor_id,d.first_name,d.last_name
HAVING SUM(b.amount)>500
ORDER BY total_billed DESC;

-- Q7. View
SELECT * FROM vw_doctor_billing ORDER BY total_billed DESC;

-- Q8. Top two highest-billed patients per doctor
WITH patient_doctor_totals AS (
    SELECT doctor_id,patient_id,SUM(amount) AS total_billed
    FROM bill GROUP BY doctor_id,patient_id
), ranked AS (
    SELECT *,ROW_NUMBER() OVER(PARTITION BY doctor_id ORDER BY total_billed DESC,patient_id) AS rn
    FROM patient_doctor_totals
)
SELECT d.doctor_id,CONCAT(d.first_name,' ',d.last_name) AS doctor_name,
       p.patient_id,CONCAT(p.first_name,' ',p.last_name) AS patient_name,
       ROUND(r.total_billed,2) AS total_billed
FROM ranked r
JOIN doctor d ON d.doctor_id=r.doctor_id
JOIN patient p ON p.patient_id=r.patient_id
WHERE r.rn<=2
ORDER BY d.doctor_id,r.rn;

-- Q9. Month-to-month changes
WITH monthly AS (
    SELECT DATE_TRUNC('month',v.visit_date)::DATE AS month,
           COUNT(v.visit_id) AS visits,
           COALESCE(SUM(b.amount),0) AS total_billed
    FROM visit v LEFT JOIN bill b ON b.visit_id=v.visit_id
    GROUP BY DATE_TRUNC('month',v.visit_date)
)
SELECT month,visits,ROUND(total_billed,2) AS total_billed,
       visits-LAG(visits) OVER(ORDER BY month) AS visit_change,
       ROUND(total_billed-LAG(total_billed) OVER(ORDER BY month),2) AS billing_change
FROM monthly ORDER BY month;

-- Q10. Above-average doctors and clinic billing share
WITH doctor_totals AS (
    SELECT doctor_id,SUM(amount) AS total_billed FROM bill GROUP BY doctor_id
)
SELECT d.doctor_id,CONCAT(d.first_name,' ',d.last_name) AS doctor_name,
       ROUND(dt.total_billed,2) AS doctor_total,
       ROUND((SELECT AVG(total_billed) FROM doctor_totals),2) AS average_doctor_total,
       ROUND(100.0*dt.total_billed/(SELECT SUM(amount) FROM bill),2) AS clinic_billing_share_pct
FROM doctor_totals dt JOIN doctor d ON d.doctor_id=dt.doctor_id
WHERE dt.total_billed>(SELECT AVG(total_billed) FROM doctor_totals)
ORDER BY dt.total_billed DESC;
