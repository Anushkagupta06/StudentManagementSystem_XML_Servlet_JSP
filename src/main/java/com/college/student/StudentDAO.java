package com.college.student;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO {

    // READ: Get all student records
    public List<Student> getAllStudents() throws SQLException {
        List<Student> students = new ArrayList<>();

        String sql = "SELECT id, name, email, course, study_year FROM students ORDER BY id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Student student = new Student();
                student.setId(rs.getInt("id"));
                student.setName(rs.getString("name"));
                student.setEmail(rs.getString("email"));
                student.setCourse(rs.getString("course"));
                student.setYear(rs.getInt("study_year"));

                students.add(student);
            }
        }

        return students;
    }

    // READ: Get one student by ID
    public Student getStudentById(int id) throws SQLException {
        String sql = "SELECT id, name, email, course, study_year FROM students WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Student student = new Student();
                    student.setId(rs.getInt("id"));
                    student.setName(rs.getString("name"));
                    student.setEmail(rs.getString("email"));
                    student.setCourse(rs.getString("course"));
                    student.setYear(rs.getInt("study_year"));

                    return student;
                }
            }
        }

        return null;
    }

    // CREATE: Insert a new student
    public boolean insertStudent(Student student) throws SQLException {
        String sql = "INSERT INTO students (name, email, course, study_year) VALUES (?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, student.getName().trim());
            ps.setString(2, student.getEmail().trim());
            ps.setString(3, student.getCourse().trim());
            ps.setInt(4, student.getYear());

            return ps.executeUpdate() == 1;
        }
    }

    // UPDATE: Update an existing student
    public boolean updateStudent(Student student) throws SQLException {
        String sql = "UPDATE students SET name = ?, email = ?, course = ?, study_year = ? WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, student.getName().trim());
            ps.setString(2, student.getEmail().trim());
            ps.setString(3, student.getCourse().trim());
            ps.setInt(4, student.getYear());
            ps.setInt(5, student.getId());

            return ps.executeUpdate() == 1;
        }
    }

    // DELETE: Delete a student by ID
    public boolean deleteStudent(int id) throws SQLException {
        String sql = "DELETE FROM students WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() == 1;
        }
    }
}

