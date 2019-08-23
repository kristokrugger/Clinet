-- DOCTOR FUNCTIONALITY
-- ==========================

-- a doctor can search for a patient's lab results using the patient's ID
-- this query uses the patient table view which excludes personal patient information
-- such as their password. {patient_id} indicates that this is input from the app.
SELECT patient_id, first_name, last_name, test_name, outcome, 
                                    dateCompleted, isSuccessful
FROM PatientView NATURAL JOIN MedicalRecord NATURAL JOIN LabTest NATURAL JOIN LabResult
WHERE patient_id = {patient_id} 

-- A doctor can search for patients either by their ID, full name, first name, last name, age, 
-- blood type, gender diagnosis, or phone number. The queries for each case varies slightly depending on
-- whether the input is non-atomic, numeric or textual. These are the variations
-- (please not anything inside {} is user input):

--This one is to search by full name
SELECT patient_id, first_name, last_name, age, gender, telephone_num, blood_type
FROM PatientView
WHERE LOWER(first_name) LIKE '{firstname}' AND LOWER(last_name) LIKE '{lastname}' 

--This one is to search by diagnosis
SELECT patient_id, first_name, last_name, age, gender, telephone_num, blood_type, diagnosis
FROM PatientView NATURAL JOIN Visit
WHERE LOWER(diagnosis) LIKE '{val}'

--This one is to search by ID, age or phone num
SELECT patient_id, first_name, last_name, age, gender, telephone_num, blood_type
FROM PatientView
WHERE {filter} = {val} 

--This one is to search by first name, last name, gender, or blood type
SELECT patient_id, first_name, last_name, age, gender, telephone_num, blood_type
FROM PatientView
WHERE LOWER({filter}) LIKE '{val}'

-- -- A doctor can retrieve diagnosis statistics using the following query.
-- This query is also used to create plots in the doctor page
SELECT V.diagnosis, COUNT(*) AS number_of_patients, AVG(age) AS average_age,
              100*COUNT(*)/totalcount AS percentage_of_patients
FROM Visit V, PatientView P, (SELECT COUNT(*) AS totalcount FROM PatientView) T
WHERE V.patient_id = P.patient_id
GROUP BY V.diagnosis

-- This query is used to create a blood type distribution histogram in the doctor page
SELECT blood_type, COUNT(*) AS number_of_patients 
FROM PatientView 
GROUP BY blood_type

-- This query was used to create a new prescription. Note that getattr(self, self.id_column)
-- refers to the doctor_id and anything inside {} refers to user input
INSERT INTO Prescription(date, patient_id, doctor_id, medrecord_id) 
VALUES({date}, {patient_id}, {getattr(self, self.id_column)}, {medrecord_id})
      
-- This query was used to add drugs to an existing prescription
INSERT INTO PrescriptionSpecifies(prescription_id, drug_id, dose, quantity) 
VALUES({prescription_id}, {drug_id}, {dose}, {quantity})

-- This query is used to delete an existing prescription using the prescription_id
DELETE FROM Prescription WHERE prescription_id = {prescription_id}

-- This query is used to diagnose a patient 
INSERT INTO Visit(date, diagnosis, duration, patient_id, doctor_id, medrecord_id)
VALUES({date}, '{diagnosis}', {duration}, {patient_id}, {getattr(self, self.id_column)}, 
{medrecord_id})

-- This query is used to look up drug information
SELECT * FROM Drug WHERE drug_id = {drug_id}

-- TECHNICIAN FUNCTIONALITY
-- ==========================

-- retrieves all equipment
SELECT *
FROM Equipment

-- retrieves equipment managed by the technician making the query
-- {technician_id} refers to the current user id variable
SELECT equipment_id, name, description, producer, age, status
FROM Equipment E NATURAL JOIN ManagesEquipment M
WHERE E.equipment_id = M.equipment_id and {technician_id} = M.technician_id

-- adds a new equipment
INSERT INTO Equipment (equipment_id, name, description, status, producer, age)
VALUES ({name}, {description}, {status}, {producer}, {age})
-- assigns the newly added equipment to the technician id
INSERT INTO ManagesEquipment (equipment_id, technician_id)
VALUES ({equipment_id}, {technician_id})

-- updates an equipment
UPDATE Equipment
SET name = {name}, description = {description}, status = {status}, producer = {producer}, age = {age}
WHERE equipment_id = {equipment_id}

-- deletes an equipment
DELETE FROM Equipment WHERE equipment_id = {equipment_id}

-- marks an equipment as fixed
UPDATE Equipment
SET status = 'working'
WHERE equipment_id = {equipment_id}


-- RECEPTIONIST FUNCTIONALITY
-- ==========================

-- Select all UNCONFIRMED appointments to show to the receptionist
SELECT
    A.appointment_id, A.date, A.doctor_name, A.reason,
    P.first_name as patient_first_name, P.last_name as patient_last_name, P.email as patient_email
FROM AppointmentBooking A, PatientView P
WHERE
    A.patient_id = P.patient_id AND
    A.receptionist_id IS NULL
ORDER BY A.date;

-- Select all CONFIRMED appointments to show to the receptionist
SELECT
    A.appointment_id, A.date, A.doctor_name, A.reason,
    P.first_name as patient_first_name, P.last_name as patient_last_name, P.email as patient_email,
    R.first_name as receptionist_first_name, R.last_name as receptionist_last_name
FROM AppointmentBooking A, Receptionist R, PatientView P
WHERE
    A.receptionist_id IS NOT NULL AND
    A.receptionist_id = R.receptionist_id AND
    A.patient_id = P.patient_id
ORDER BY A.date;

-- DELETE an appointment
DELETE FROM AppointmentBooking
WHERE appointment_id = {selected appointment};

-- INSERT an appointment
INSERT INTO AppointmentBooking
(date, patient_id, doctor_name, reason, receptionist_id)
VALUES ('2015-01-01 12:00:00', 1, 'Anthony', 'Coughing', {ID of logged in receptionist});

-- UPDATE an appointment
UPDATE AppointmentBooking
SET receptionist_id = {current logged in receptionist ID}, date = {date},
        patient_id = {patient_id}, doctor_name = {doctor_name}, reason = {reason}
WHERE appointment_id = {selected_appointment};

-- Mark an appointment as confirmed
UPDATE AppointmentBooking
SET receptionist_id = {current logged in receptionist ID}
WHERE appointment_id = {selected appointment};


-- PATIENT FUNCTIONALITY
-- ==========================

-- A patient can view his or her prescriptions 
SELECT prescription_id, date, D.first_name as doctor_name,drug_name, brand, dose, quantity 
FROM DOCTOR D NATURAL JOIN Prescription NATURAL JOIN PrescriptionSpecifies NATURAL JOIN Drug
WHERE patient_id = {patient_id}

-- A patient can view his or her appointments
SELECT R.first_name as receptionist_name,A.doctor_name, date, reason 
FROM APPOINTMENTBOOKING A  NATURAL JOIN RECEPTIONIST R 
WHERE patient_id= {patient_id}

--A patient can request an appointment, for example patient
--with ID 1 can request an appointment with a doctor named Anthony
INSERT INTO AppointmentBooking
(date, patient_id, doctor_name, reason, receptionist_id)
VALUES ('2015-01-01 12:00:00', 1, 'Anthony', 'Coughing', NULL);
