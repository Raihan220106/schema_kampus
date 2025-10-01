-- ================================================================
-- SECTION 1: DATABASE SCHEMA
-- ================================================================

-- Drop existing tables if they exist
DROP TABLE IF EXISTS course_assignments CASCADE;
DROP TABLE IF EXISTS financial_aid CASCADE;
DROP TABLE IF EXISTS scholarships CASCADE;
DROP TABLE IF EXISTS enrollments CASCADE;
DROP TABLE IF EXISTS courses CASCADE;
DROP TABLE IF EXISTS students CASCADE;
DROP TABLE IF EXISTS professors CASCADE;
DROP TABLE IF EXISTS departments CASCADE;

-- Create schema
CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    head_professor_id INTEGER,
    budget NUMERIC(12,2),
    established_year INTEGER
);

CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    birth_date DATE,
    gpa NUMERIC(3,2),
    entry_semester VARCHAR(10),
    status VARCHAR(20) DEFAULT 'ACTIVE',
    department_id INTEGER REFERENCES departments(id)
);

CREATE TABLE professors (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department_id INTEGER REFERENCES departments(id),
    salary NUMERIC(10,2),
    hire_date DATE,
    specialization TEXT
);

CREATE TABLE courses (
    id SERIAL PRIMARY KEY,
    code VARCHAR(10) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    credits INTEGER CHECK (credits BETWEEN 1 AND 6),
    department_id INTEGER REFERENCES departments(id),
    level INTEGER CHECK (level IN (100, 200, 300, 400)),
    prerequisite_id INTEGER REFERENCES courses(id)
);

CREATE TABLE enrollments (
    id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES students(id),
    course_id INTEGER REFERENCES courses(id),
    semester VARCHAR(10),
    grade CHAR(1) CHECK (grade IN ('A', 'B', 'C', 'D', 'F')),
    numeric_score NUMERIC(5,2),
    status VARCHAR(20) DEFAULT 'ENROLLED'
);

CREATE TABLE course_assignments (
    id SERIAL PRIMARY KEY,
    course_id INTEGER REFERENCES courses(id),
    professor_id INTEGER REFERENCES professors(id),
    semester VARCHAR(10),
    room VARCHAR(20),
    max_students INTEGER
);

CREATE TABLE scholarships (
    id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES students(id),
    type VARCHAR(50),
    amount NUMERIC(10,2),
    semester VARCHAR(10),
    criteria_met TEXT
);

CREATE TABLE financial_aid (
    id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES students(id),
    family_income NUMERIC(12,2),
    aid_amount NUMERIC(10,2),
    semester VARCHAR(10),
    need_score INTEGER CHECK (need_score BETWEEN 0 AND 100)
);

-- ================================================================
-- SECTION 2: SAMPLE DATA
-- ================================================================

-- Insert departments
INSERT INTO departments (id, name, budget, established_year) VALUES
(1, 'Computer Science', 15000000.00, 1985),
(2, 'Mathematics', 12000000.00, 1980),
(3, 'Physics', 18000000.00, 1975),
(4, 'Business', 10000000.00, 1990);

-- Insert professors
INSERT INTO professors (id, name, department_id, salary, hire_date, specialization) VALUES
(1, 'Dr. Ahmad Rahman', 1, 8500000, '2010-01-15', 'Database Systems'),
(2, 'Dr. Siti Nurhaliza', 1, 9200000, '2008-03-20', 'Machine Learning'),
(3, 'Prof. Budi Santoso', 2, 10500000, '2005-08-10', 'Statistics'),
(4, 'Dr. Maria Santos', 3, 7800000, '2015-06-01', 'Quantum Physics'),
(5, 'Dr. John Smith', 4, 6500000, '2018-09-15', 'Marketing'),
(6, 'Dr. Lisa Wong', 1, 4500000, '2020-01-10', 'Software Engineering');

-- Insert courses
INSERT INTO courses (id, code, name, credits, department_id, level, prerequisite_id) VALUES
(1, 'CS101', 'Introduction to Programming', 3, 1, 100, NULL),
(2, 'CS201', 'Data Structures', 3, 1, 200, 1),
(3, 'CS301', 'Database Systems', 3, 1, 300, 2),
(4, 'CS401', 'Advanced Database', 3, 1, 400, 3),
(5, 'MATH101', 'Calculus I', 4, 2, 100, NULL),
(6, 'MATH201', 'Statistics', 3, 2, 200, 5),
(7, 'PHY101', 'Physics I', 4, 3, 100, NULL),
(8, 'BUS101', 'Business Fundamentals', 2, 4, 100, NULL),
(9, 'CS102', 'Programming II', 3, 1, 100, 1),
(10, 'CS302', 'Software Engineering', 3, 1, 300, 2);

-- Insert students
INSERT INTO students (id, name, email, birth_date, gpa, entry_semester, status, department_id) VALUES
(1, 'Ahmad Sutrisno', 'ahmad@student.edu', '2002-05-15', 3.85, '2021-1', 'ACTIVE', 1),
(2, 'Siti Rahayu', 'siti@student.edu', '2001-08-20', 3.45, '2020-2', 'ACTIVE', 1),
(3, 'Budi Prakoso', 'budi@student.edu', '2002-12-10', 2.95, '2021-1', 'ACTIVE', 2),
(4, 'Maria Gonzalez', 'maria@student.edu', '2001-03-25', 3.75, '2020-1', 'ACTIVE', 3),
(5, 'John Doe', 'john@student.edu', '2003-01-08', 2.15, '2022-1', 'ACTIVE', 4),
(6, 'Lisa Chen', 'lisa@student.edu', '2002-09-18', 3.92, '2021-2', 'ACTIVE', 1),
(7, 'Robert Wilson', 'robert@student.edu', '2001-11-30', 1.85, '2020-1', 'ACTIVE', 2),
(8, 'Sarah Johnson', 'sarah@student.edu', '2002-07-12', 3.25, '2021-2', 'ACTIVE', 3);

-- Insert enrollments
INSERT INTO enrollments (id, student_id, course_id, semester, grade, numeric_score, status) VALUES
-- Ahmad Sutrisno (student 1) - excellent student
(1, 1, 1, '2021-1', 'A', 92.5, 'COMPLETED'),
(2, 1, 2, '2021-2', 'A', 88.0, 'COMPLETED'),
(3, 1, 3, '2022-1', 'B', 85.5, 'COMPLETED'),
(4, 1, 4, '2022-2', 'A', 90.0, 'COMPLETED'),
(5, 1, 5, '2021-1', 'B', 82.0, 'COMPLETED'),

-- Siti Rahayu (student 2) - good student
(6, 2, 1, '2020-2', 'B', 78.5, 'COMPLETED'),
(7, 2, 2, '2021-1', 'B', 81.0, 'COMPLETED'),
(8, 2, 3, '2021-2', 'C', 72.5, 'COMPLETED'),
(9, 2, 5, '2020-2', 'A', 89.0, 'COMPLETED'),

-- Budi Prakoso (student 3) - average student
(10, 3, 5, '2021-1', 'C', 65.0, 'COMPLETED'),
(11, 3, 6, '2021-2', 'D', 58.5, 'COMPLETED'),
(12, 3, 1, '2022-1', 'B', 75.0, 'COMPLETED'),

-- Maria Gonzalez (student 4) - good student
(13, 4, 7, '2020-1', 'A', 91.5, 'COMPLETED'),
(14, 4, 5, '2020-2', 'B', 83.0, 'COMPLETED'),
(15, 4, 1, '2021-1', 'A', 87.5, 'COMPLETED'),

-- John Doe (student 5) - poor student
(16, 5, 8, '2022-1', 'D', 55.0, 'COMPLETED'),
(17, 5, 1, '2022-2', 'F', 42.0, 'COMPLETED'),
(18, 5, 5, '2023-1', 'D', 59.5, 'COMPLETED'),

-- Lisa Chen (student 6) - excellent student
(19, 6, 1, '2021-2', 'A', 95.0, 'COMPLETED'),
(20, 6, 2, '2022-1', 'A', 93.5, 'COMPLETED'),
(21, 6, 3, '2022-2', 'A', 91.0, 'COMPLETED'),
(22, 6, 10, '2023-1', 'A', 89.5, 'COMPLETED'),

-- Robert Wilson (student 7) - poor student
(23, 7, 5, '2020-1', 'F', 35.0, 'COMPLETED'),
(24, 7, 1, '2020-2', 'D', 57.5, 'COMPLETED'),
(25, 7, 6, '2021-1', 'F', 41.0, 'COMPLETED'),
(26, 7, 1, '2021-2', 'F', 45.0, 'COMPLETED'), -- Retake

-- Sarah Johnson (student 8) - average student
(27, 8, 7, '2021-2', 'B', 76.0, 'COMPLETED'),
(28, 8, 5, '2022-1', 'C', 68.5, 'COMPLETED'),
(29, 8, 1, '2022-2', 'B', 79.0, 'COMPLETED');

-- Insert course assignments
INSERT INTO course_assignments (id, course_id, professor_id, semester, room, max_students) VALUES
(1, 1, 1, '2024-1', 'LAB-101', 30),
(2, 1, 6, '2024-1', 'LAB-102', 25),  -- CS101 has 2 classes
(3, 2, 1, '2024-1', 'LAB-201', 35),
(4, 3, 1, '2024-1', 'LAB-301', 40),
(5, 4, 2, '2024-1', 'LAB-401', 20),
(6, 5, 3, '2024-1', 'MATH-101', 50),
(7, 6, 3, '2024-1', 'MATH-201', 30),
(8, 7, 4, '2024-1', 'PHY-101', 45),
(9, 8, 5, '2024-1', 'BUS-101', 40),
(10, 9, 6, '2024-1', 'LAB-103', 25),
(11, 10, 6, '2024-1', 'LAB-302', 30),
(12, 10, 2, '2024-1', 'LAB-303', 25);  -- CS302 has 2 classes

-- Insert scholarships
INSERT INTO scholarships (id, student_id, type, amount, semester, criteria_met) VALUES
(1, 1, 'MERIT_HIGH', 3000000, '2024-1', 'GPA >= 3.7'),
(2, 4, 'MERIT_HIGH', 3000000, '2024-1', 'GPA >= 3.7'),
(3, 6, 'MERIT_HIGH', 3000000, '2024-1', 'GPA >= 3.7'),
(4, 2, 'MERIT_MEDIUM', 2000000, '2024-1', 'GPA 3.3-3.69'),
(5, 8, 'MERIT_MEDIUM', 2000000, '2024-1', 'GPA 3.3-3.69'),
(6, 3, 'MERIT_LOW', 1000000, '2024-1', 'GPA 3.0-3.29');

-- Insert financial aid
INSERT INTO financial_aid (id, student_id, family_income, aid_amount, semester, need_score) VALUES
(1, 1, 25000000, 1500000, '2024-1', 75),
(2, 2, 18000000, 2000000, '2024-1', 85),
(3, 3, 15000000, 2500000, '2024-1', 90),
(4, 5, 12000000, 3000000, '2024-1', 95),
(5, 7, 10000000, 3500000, '2024-1', 98),
(6, 8, 22000000, 1800000, '2024-1', 80);
