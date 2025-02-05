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
        email TEXT UNIQUE CHECK (email LIKE '%@%'),
        opening_hours TEXT NOT NULL CHECK (opening_hours LIKE '_:__-__:__')
);
-- 2. members
CREATE TABLE members (
        member_id INTEGER PRIMARY KEY AUTOINCREMENT,
        first_name TEXT NOT NULL,
        last_name TEXT NOT NULL,
        email TEXT NOT NULL CHECK (email LIKE '%@%'),
        phone_number TEXT NOT NULL CHECK (phone_number LIKE '___-____'),
        date_of_birth DATE NOT NULL CHECK (date_of_birth < '2005-02-05'),
        join_date DATE NOT NULL,
        emergency_contact_name TEXT NOT NULL ,
        emergency_contact_phone TEXT NOT NULL CHECK (emergency_contact_phone LIKE '___-____')
);

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
        FOREIGN KEY (location_id ) REFERENCES staff (location_id)  
        );
-- 4. equipment
CREATE TABLE equipment (
        equipment_id INTEGER PRIMARY KEY AUTOINCREMENT,
        name,
        type,
        purchase_date,
        last_maintenance_date,
        next_maintenance_date,
        location_id
);

-- 5. classes
CREATE TABLE classes (
        class_id INTEGER PRIMARY KEY AUTOINCREMENT,
        name,
        description,
        capacity,
        duration,
        location_id
);
-- 6. class_schedule
CREATE TABLE class_schedule (
        schedule_id INTEGER PRIMARY KEY AUTOINCREMENT,
        class_id,
        staff_id,
        start_time,
        end_time
);
-- 7. memberships
CREATE TABLE memberships (
        membership_id INTEGER PRIMARY KEY AUTOINCREMENT,
        member_id,
        type,
        start_date,
        end_date,
        status
);
-- 8. attendance
CREATE TABLE attendance (
        attendance_id INTEGER PRIMARY KEY AUTOINCREMENT,
        member_id,
        location_id,
        check_in_time,
        check_out_time
);

-- 9. class_attendance
CREATE TABLE class_attendance (
        class_attendance_id INTEGER PRIMARY KEY AUTOINCREMENT,
        schedule_id,
        member_id,
        attendance_status
);

-- 10. payments
CREATE TABLE payments (
        payment_id INTEGER PRIMARY KEY AUTOINCREMENT,
        member_id,
        amount,
        payment_date,
        payment_method,
        description,
        payment_type
);
-- 11. personal_training_sessions
CREATE TABLE personal_training_sessions (
        session_id INTEGER PRIMARY KEY AUTOINCREMENT,
        member_id,
        staff_id,
        session_date,
        start_time,
        end_time,
        notes
);
-- 12. member_health_metrics
CREATE TABLE member_health_metrics (
        metric_id INTEGER PRIMARY KEY AUTOINCREMENT,
        member_id,
        measurement_date,
        weight,
        body_fat_percentage,
        muscle_mass,
        bmi
);
-- 13. equipment_maintenance_log
CREATE TABLE equipment_maintenance_log (
        log_id INTEGER PRIMARY KEY AUTOINCREMENT,
        equipment_id,
        maintenance_date,
        description,
        staff_id
);



-- After creating the tables, you can import the sample data using:
-- `.read data/sample_data.sql` in a sql file or `npm run import` in the terminal