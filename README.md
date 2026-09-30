# advdb-activity2-4

# SAIT Medical Clinic — Advanced Database Activity 2

## PostgreSQL / pgAdmin Version

This project implements the SAIT Medical Clinic scenario using **PostgreSQL**. It is designed to be executed in pgAdmin or another PostgreSQL client.

### Business Rules

1. A patient can make multiple appointments with one or more doctors.
2. A doctor can have appointments with many patients.
3. Each appointment has exactly one patient and one doctor.
4. A kept appointment becomes a visit.
5. A visit records diagnosis and treatment.
6. Each visit updates medical history.
7. Each visit generates one bill.
8. Each bill is linked to the doctor providing the service.
9. The patient pays the bill directly to the clinic.

## Database Design

### Entities

- Patient
- Doctor
- Appointment
- Visit
- Medical History
- Bill

### Relationships

- Patient 1:M Appointment
- Doctor 1:M Appointment
- Appointment 0:1 Visit
- Patient 1:M Medical History
- Visit 1:1 Medical History
- Visit 1:1 Bill
- Patient 1:M Bill
- Doctor 1:M Bill

## PostgreSQL Implementation

The database uses:
- Primary keys
- Foreign keys
- NOT NULL
- UNIQUE
- CHECK
- PostgreSQL ENUM types
- Identity columns
- A database view
- CTEs and window functions

### Sample Data

**Entity** | **Records** 

Patient | 20 |
Doctor | 20 |
Appointment | 32 |
Visit | 25 |
Medical History | 25 |
Bill | 25 |

## Setup in pgAdmin

1. Open **pgAdmin**.
2. Connect to your PostgreSQL server.
3. Open the Query Tool.
4. Open `sait_medical_clinic_postgresql.sql`.
5. Run the complete script.
6. The script creates a schema called `sait_medical_clinic`.
7. Run `query_tests.sql` after the schema/data have been created.

## Query Screenshots

**Q1** — **Total Patients**
<img width="550" height="183" alt="Q1" src="https://github.com/user-attachments/assets/d213b4d6-daea-4205-a997-fed625c0e6f8" />

**Q2** — **Patients Who Visited Last Month**
<img width="621" height="167" alt="Q2" src="https://github.com/user-attachments/assets/0ddfff78-d4fd-47c4-a722-caa622584874" />

**Q3** — **Total Billing**
<img width="627" height="155" alt="Q3" src="https://github.com/user-attachments/assets/3e445641-9e06-4ac9-9519-2bcaa74b437c" />

**Q4** — **Aggregation**
<img width="711" height="256" alt="Q4" src="https://github.com/user-attachments/assets/9a6d1c73-ac99-499a-bf97-2d575f6e26ee" />

**Q5** — **Subquery and JOIN**
<img width="588" height="313" alt="Q5" src="https://github.com/user-attachments/assets/4e710cb5-727f-4ea4-a0b0-45f0d4e7a474" />

**Q6** — **GROUP BY and HAVING**
<img width="643" height="221" alt="Q6" src="https://github.com/user-attachments/assets/4a3c0676-8296-4730-88bf-a00d96f9b054" />

**Q7** — **View**
<img width="1025" height="572" alt="Q7" src="https://github.com/user-attachments/assets/f775618b-b17b-4783-94a5-0ae2b02c3014" />

**Q8** — **Top Two Highest-Billed Patients per Doctor**
<img width="810" height="306" alt="Q8" src="https://github.com/user-attachments/assets/ad7bb4c6-7452-410a-994e-8765380ac419" />

**Q9** — **Month-to-Month Changes**
<img width="754" height="316" alt="Q9" src="https://github.com/user-attachments/assets/05997d1e-4dff-476b-a00e-6c3b2ee9e867" />

**Q10** — **Above-Average Doctors and Billing Share**
<img width="747" height="192" alt="Q10" src="https://github.com/user-attachments/assets/8f65c263-51a4-4a42-8331-aeb5731aa930" />


## Files

- `sait_medical_clinic_postgresql.sql` & 'query_tests.sql' — full schema and sample data
- `eer_diagram.png` — EERD image
- `SAIT_Medical_Clinic_PostgreSQL_Report.pdf` — PDF submission template

## GitHub Repository

Repository name:

`advdb-activity2-4`
