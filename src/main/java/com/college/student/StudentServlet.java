package com.college.student;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class StudentServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private StudentDAO studentDAO;

    @Override
    public void init() throws ServletException {
        studentDAO = new StudentDAO();
    }

    // READ: Display all students; open the add/edit form when requested
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        try {
            if ("new".equals(action)) {
                request.setAttribute("student", new Student());
                request.getRequestDispatcher("/student-form.jsp")
                       .forward(request, response);

            } else if ("edit".equals(action)) {
                int id = parseId(request.getParameter("id"));

                Student student = studentDAO.getStudentById(id);

                if (student == null) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND,
                                       "Student record not found.");
                    return;
                }

                request.setAttribute("student", student);
                request.getRequestDispatcher("/student-form.jsp")
                       .forward(request, response);

            } else {
                List<Student> students = studentDAO.getAllStudents();
                request.setAttribute("students", students);

                request.getRequestDispatcher("/students.jsp")
                       .forward(request, response);
            }

        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                               "Invalid student ID.");
        } catch (SQLException e) {
            throw new ServletException("Unable to retrieve student records.", e);
        }
    }

    // CREATE, UPDATE, DELETE: Process submitted forms
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        try {
            if ("insert".equals(action)) {
                Student student = readStudentForm(request);

                if (studentDAO.insertStudent(student)) {
                    redirectWithMessage(request, response, "created");
                } else {
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                                       "Student could not be added.");
                }

            } else if ("update".equals(action)) {
                int id = parseId(request.getParameter("id"));
                Student student = readStudentForm(request);
                student.setId(id);

                if (studentDAO.updateStudent(student)) {
                    redirectWithMessage(request, response, "updated");
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND,
                                       "Student record not found or not updated.");
                }

            } else if ("delete".equals(action)) {
                int id = parseId(request.getParameter("id"));

                if (studentDAO.deleteStudent(id)) {
                    redirectWithMessage(request, response, "deleted");
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND,
                                       "Student record not found.");
                }

            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                                   "Unknown action.");
            }

        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                               "Invalid student ID or form data.");
        } catch (SQLException e) {
            // Log details in Eclipse's server console, not in the browser.
            getServletContext().log("Student database operation failed.", e);

            String message = e.getSQLState() != null
                    && e.getSQLState().startsWith("23")
                    ? "Email may already exist, or a required field is invalid."
                    : "A database error occurred. Check the server console.";

            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                               message);
        }
    }

    private Student readStudentForm(HttpServletRequest request) {
        String name = trim(request.getParameter("name"));
        String email = trim(request.getParameter("email"));
        String course = trim(request.getParameter("course"));
        String yearValue = trim(request.getParameter("year"));

        if (name.isEmpty() || email.isEmpty() || course.isEmpty()) {
            throw new IllegalArgumentException("Required fields are missing.");
        }

        if (name.length() > 100 || email.length() > 150
                || course.length() > 100) {
            throw new IllegalArgumentException("Field length exceeded.");
        }

        if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            throw new IllegalArgumentException("Invalid email address.");
        }

        int year;
        try {
            year = Integer.parseInt(yearValue);
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid study year.");
        }

        if (year < 1 || year > 6) {
            throw new IllegalArgumentException("Study year must be between 1 and 6.");
        }

        Student student = new Student();
        student.setName(name);
        student.setEmail(email);
        student.setCourse(course);
        student.setYear(year);

        return student;
    }

    private int parseId(String value) {
        try {
            int id = Integer.parseInt(value);
            if (id <= 0) {
                throw new IllegalArgumentException("ID must be positive.");
            }
            return id;
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid ID.");
        }
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private void redirectWithMessage(HttpServletRequest request,
                                     HttpServletResponse response,
                                     String message) throws IOException {
        String ctx = request.getContextPath();
        response.sendRedirect(ctx + "/students?message="
                + URLEncoder.encode(message, StandardCharsets.UTF_8));
    }
}
