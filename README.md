# Student Management System — XML, Servlet and JSP

A CRUD web application for a Web Application Development college project.

## Requirements
- JDK 11 or later
- Apache Maven 3.8+
- MySQL 8+
- Apache Tomcat 10.1+
- Eclipse IDE (or another Java IDE)

This project uses **Jakarta Servlet 6**, so use **Tomcat 10.1+**. Tomcat 9 uses the older `javax.servlet` API and is not compatible without code/dependency changes.

## Setup
1. Install and start MySQL.
2. Open MySQL Workbench (or MySQL command line) and run `database.sql`.
3. Open `src/main/java/com/college/student/DBConnection.java` and set `PASSWORD` to your local MySQL root password. If your username differs from `root`, update `USER` too.
4. From the project folder, build the WAR:
   ```bash
   mvn clean package
   ```
5. Deploy `target/StudentManagementSystem.war` to Tomcat's `webapps` directory, then start Tomcat.
6. Open `http://localhost:8080/StudentManagementSystem/` in your browser.

## Eclipse setup (quick route)
- File → Import → Existing Maven Projects → select this folder.
- Update the database credentials in `DBConnection.java`.
- Right-click project → Run As → Maven build… → enter `clean package`.
- Add Tomcat 10.1 to Eclipse's Servers view and deploy the generated WAR.

## Features
- Create, read, update, and delete student records
- JSP-based list and form pages
- Servlet controller mapped in `WEB-INF/web.xml`
- JDBC database access with prepared statements
- Responsive CSS interface

## Request flow
Browser → `StudentServlet` → `StudentDAO` → MySQL
Browser ← JSP view (`students.jsp` / `student-form.jsp`)

## Troubleshooting
- **Access denied for user**: check `USER` and `PASSWORD` in `DBConnection.java`.
- **Unknown database `student_db`**: run `database.sql`.
- **404**: confirm the WAR is deployed and use `/StudentManagementSystem/` in the URL.
- **Servlet class errors**: use Tomcat 10.1+ and Java 11+.
- **Port conflict**: change Tomcat's HTTP port if 8080 is already in use.

For a college demonstration, explain that `web.xml` maps `/students` to `StudentServlet`, the servlet handles requests, the DAO runs SQL through JDBC, and JSP displays the results."# StudentManagementSystem_XML_Servlet_JSP" 
