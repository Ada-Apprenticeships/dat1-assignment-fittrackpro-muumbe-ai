-- FitTrack Pro Database Schema

-- Initial SQLite setup
.open fittrackpro.sqlite
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;
-- Create your tables here
-- Example:
-- CREATE TABLE table_name (
--     column1 datatype,
--     column2 datatype,
--     ...
-- );

-- TODO: Create the following tables:
-- 1. locations
CREATE TABLE locations (
        location_id INTEGER PRIMARY KEY AUTOINCREMENT ,
        name TEXT NOT NULL,
        address TEXT NOT NULL, 
        phone_number TEXT NOT NULL CHECK (phone_number LIKE '___-____'),
        email TEXT NOT NULL,
        opening_hours TEXT NOT NULL CHECK (opening_hours LIKE '_:__-__:__')
);

-- INSERT INTO locations (name, address, phone_number, email, opening_hours)
-- VALUES ('Gym A', '123 Street', '1234567', 'gym@email.com', '9:00-18:00'); -- Fails (Incorrect phone format)

-- 2. members
CREATE TABLE members (
        member_id INTEGER PRIMARY KEY AUTOINCREMENT,
        first_name TEXT NOT NULL,
        last_name TEXT NOT NULL,
        email TEXT NOT NULL CHECK (email LIKE '%@%'),
        phone_number TEXT NOT NULL CHECK (phone_number LIKE '___-____'),
        date_of_birth DATE NOT NULL CHECK (date_of_birth < '2007-02-05'),
        join_date DATE NOT NULL,
        emergency_contact_name TEXT NOT NULL ,
        emergency_contact_phone TEXT NOT NULL CHECK (emergency_contact_phone LIKE '___-____')
); 
--INSERT INTO members (first_name, last_name, email, phone_number, date_of_birth, join_date, emergency_contact_name, emergency_contact_phone)
-- VALUES ('Alice', 'Smith', 'alice@email.com', '123-4567', '2007-06-10', '2025-02-10', 'Bob Smith', '987-6543');
-- Fails (DOB is after 2007-02-05)

-- 3. staff
CREATE TABLE staff (
        staff_id INTEGER PRIMARY KEY AUTOINCREMENT,
        first_name TEXT NOT NULL,
        last_name TEXT NOT NULL,
        email TEXT NOT NULL CHECK (email LIKE '%@%'),
        phone_number TEXT NOT NULL CHECK (phone_number LIKE '___-____'),
        position TEXT NOT NULL CHECK (position IN ('Trainer', 'Manager', 'Receptionist', 'Maintenance')),
        hire_date DATE NOT NULL,
        location_id INTEGER NOT NULL,
        FOREIGN KEY (location_id ) REFERENCES locations (location_id)  
        );

--INSERT INTO staff (first_name, last_name, email, phone_number, position, hire_date, location_id)
--VALUES ('Jane', 'Doe', 'jane@email.com', '555-1234', 'CEO', '2024-01-01', 1); -- Fails (position must be 'Trainer', 'Manager', etc.)



-- 4. equipment
CREATE TABLE equipment (
        equipment_id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL CHECK (type IN ('Cardio', 'Strength')),
        purchase_date DATE NOT NULL,
        last_maintenance_date DATE NOT NULL,
        next_maintenance_date DATE NOT NULL CHECK (next_maintenance_date > last_maintenance_date ), -- AFTER LAST MAINTENANCE
        location_id INTEGER NOT NULL,
        FOREIGN KEY (location_id ) REFERENCES locations (location_id)
);

--INSERT INTO equipment (name, type, purchase_date, last_maintenance_date, next_maintenance_date, location_id)
--VALUES ('Treadmill', 'Cardio', '2022-01-01', '2024-01-10', '2023-12-15', 1); -- Fails


-- 5. classes
CREATE TABLE classes (
        class_id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        capacity INTEGER NOT NULL,
        duration INTEGER NOT NULL,
        location_id INTEGER NOT NULL,
        FOREIGN KEY (location_id ) REFERENCES locations (location_id)
);
-- 6. class_schedule
CREATE TABLE class_schedule (
        schedule_id INTEGER PRIMARY KEY AUTOINCREMENT,
        class_id INTEGER NOT NULL,
        staff_id INTEGER NOT NULL,
        start_time DATETIME NOT NULL,
        end_time DATETIME NOT NULL,
        FOREIGN KEY (class_id) REFERENCES classes (class_id),
        FOREIGN KEY (staff_id) REFERENCES staff (staff_id)
);
--INSERT INTO class_schedule (class_id, staff_id, start_time, end_time)
--VALUES (1, 1, '2024-02-15 10:00:00', '2024-02-15 09:30:00'); -- Fails

-- 7. memberships
CREATE TABLE memberships (
        membership_id INTEGER PRIMARY KEY AUTOINCREMENT,
        member_id INTEGER NOT NULL,
        type TEXT NOT NULL CHECK (type IN ('Premium', 'Basic')) ,
        start_date DATE NOT NULL,
        end_date DATE NOT NULL CHECK (end_date > start_date ),
        status TEXT NOT NULL CHECK (status IN ('Active', 'Inactive')),
        FOREIGN KEY (member_id) REFERENCES members (member_id)
);

--INSERT INTO memberships (member_id, type, start_date, end_date, status)
--VALUES (1, 'Basic', '2024-02-01', '2024-06-01', 'Pending'); -- Fails

-- 8. attendance
CREATE TABLE attendance (
        attendance_id INTEGER PRIMARY KEY AUTOINCREMENT,
        member_id INTEGER NOT NULL,
        location_id INTEGER NOT NULL,
        check_in_time DATETIME NOT NULL,
        check_out_time DATETIME,
        FOREIGN KEY (member_id) REFERENCES members (member_id),
        FOREIGN KEY (location_id ) REFERENCES locations (location_id)
);
--INSERT INTO attendance (member_id, location_id, check_in_time, check_out_time)
--VALUES (2, 1, NULL, '2024-02-10 15:30:00'); -- Fails MEMBER cannot check out without checking in

-- 9. class_attendance
CREATE TABLE class_attendance (
        class_attendance_id INTEGER PRIMARY KEY AUTOINCREMENT,
        schedule_id INTEGER NOT NULL,
        member_id INTEGER NOT NULL,
        attendance_status TEXT NOT NULL CHECK (attendance_status IN ('Attended', 'Registered','Unattended')),
        FOREIGN KEY (member_id) REFERENCES members (member_id),
        FOREIGN KEY (schedule_id) REFERENCES class_schedule (schedule_id)
);

-- 10. payments
CREATE TABLE payments (
        payment_id INTEGER PRIMARY KEY AUTOINCREMENT,
        member_id INTEGER NOT NULL,
        amount INTEGER NOT NULL,
        payment_date DATETIME NOT NULL,
        payment_method TEXT NOT NULL CHECK (payment_method IN ('Credit Card', 'Bank Transfer','PayPal', 'Cash')),
        payment_type TEXT NOT NULL CHECK(payment_type IN ('Monthly membership fee', 'Day pass'))
);


-- 11. personal_training_sessions
CREATE TABLE personal_training_sessions (
        session_id INTEGER PRIMARY KEY AUTOINCREMENT,
        member_id INTEGER NOT NULL,
        staff_id INTEGER NOT NULL,
        session_date DATE NOT NULL,
        start_time TIME NOT NULL,
        end_time TIME NOT NULL CHECK (end_time > start_time),
        notes TEXT NOT NULL,
        FOREIGN KEY (member_id) REFERENCES members (member_id),
        FOREIGN KEY (staff_id) REFERENCES staff (staff_id)

);

--INSERT INTO personal_training_sessions (member_id, staff_id, session_date, start_time, end_time, notes)
--VALUES (1, 1, '2024-02-10', '15:00:00', '14:30:00', 'Strength training'); -- Fails

-- 12. member_health_metrics
CREATE TABLE member_health_metrics (
        metric_id INTEGER PRIMARY KEY AUTOINCREMENT,
        member_id INTEGER NOT NULL,
        measurement_date DATE NOT NULL,
        weight REAL NOT NULL,
        body_fat_percentage REAL NOT NULL,
        muscle_mass REAL NOT NULL,
        bmi REAL NOT NULL CHECK (bmi BETWEEN 0 AND 50),
        FOREIGN KEY (member_id) REFERENCES members (member_id)
);

--INSERT INTO member_health_metrics (member_id, measurement_date, weight, body_fat_percentage, muscle_mass, bmi)
--VALUES (1, '2024-02-10', 75.5, 20.5, 30.0, 55.0); -- Fails

-- 13. equipment_maintenance_log
CREATE TABLE equipment_maintenance_log (
        log_id INTEGER PRIMARY KEY AUTOINCREMENT,
        equipment_id INTEGER NOT NULL,
        maintenance_date DATE NOT NULL,
        description TEXT NOT NULL,
        staff_id INTEGER NOT NULL,
        FOREIGN KEY (equipment_id) REFERENCES equipment (equipment_id)
);



-- After creating the tables, you can import the sample data using:
-- `.read data/sample_data.sql` in a sql file or `npm run import` in the terminal