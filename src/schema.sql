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
        location_id
        name
        address
        phone_number
        email
        opening_hours
)
-- 2. members
CREATE TABLE members(
        member_id
        first_name
        last_name
        email
        phone_number
        date_of_birth
        join_date
        emergency_contact_name
        emergency_contact_phone
)

-- 3. staff
CREATE TABLE staff (
        staff_id
        first_name
        last_name
        email
        phone_number
        position
        hire_date
        location_id        
        )
-- 4. equipment
CREATE TABLE equipment (
        equipment_id
        name
        type
        purchase_date
        last_maintenance_date
        next_maintenance_date
        location_id
)

-- 5. classes
CREATE TABLE classes (
        class_id
        name
        description
        capacity
        duration
        location_id
)
-- 6. class_schedule
CREATE TABLE class_schedule (
        schedule_id
        class_id
        staff_id
        start_time
        end_time
)
-- 7. memberships
CREATE TABLE memberships (
        membership_id
        member_id
        type
        start_date
        end_date
        status
)
-- 8. attendance
CREATE TABLE attendance (
        attendance_id
        member_id
        location_id
        check_in_time
        check_out_time
)

-- 9. class_attendance
CREATE TABLE class_attendance (
        class_attendance_id
        schedule_id
        member_id
        attendance_status
)

-- 10. payments
CREATE TABLE payments (
)
-- 11. personal_training_sessions
CREATE TABLE personal_training_sessions (
)
-- 12. member_health_metrics
CREATE TABLE member_health_metrics (
)
-- 13. equipment_maintenance_log
CREATE TABLE equipment_maintenance_log (
)



-- After creating the tables, you can import the sample data using:
-- `.read data/sample_data.sql` in a sql file or `npm run import` in the terminal