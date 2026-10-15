CREATE DATABASE IF NOT EXISTS student_db
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE student_db;

CREATE TABLE IF NOT EXISTS students (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL,
  course VARCHAR(100) NOT NULL,
  study_year TINYINT NOT NULL CHECK (study_year BETWEEN 1 AND 6),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY unique_student_email (email)
);

-- Optional sample rows. Run once; remove if you want an empty table.
INSERT IGNORE INTO students (name, email, course, study_year) VALUES
('Aditi Sharma', 'aditi@example.com', 'Computer Science', 2),
('Rahul Verma', 'rahul@example.com', 'Information Technology', 3);