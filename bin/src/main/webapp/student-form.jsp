<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.college.student.Student" %>
<%
    Student student = (Student) request.getAttribute("student");
    if (student == null) student = new Student();
    boolean editing = student.getId() > 0;
    String ctx = request.getContextPath();
    java.util.function.Function<String,String> esc = s -> s == null ? "" : s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");
%>
<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title><%=editing?"Edit":"Add"%> Student</title><link rel="stylesheet" href="<%=ctx%>/css/style.css"></head><body>
<main class="container form-container"><a class="back" href="<%=ctx%>/students">← Back to students</a>
<section class="panel form-panel"><p class="eyebrow">STUDENT RECORD</p><h1><%=editing?"Edit Student":"Add New Student"%></h1><p class="muted">Enter the student details below.</p>
<form method="post" action="<%=ctx%>/students" class="student-form">
<input type="hidden" name="action" value="<%=editing?"update":"insert"%>">
<% if (editing) { %><input type="hidden" name="id" value="<%=student.getId()%>"><% } %>
<label>Full name<input name="name" required maxlength="100" value="<%=esc.apply(student.getName())%>" placeholder="e.g. Aditi Sharma"></label>
<label>Email address<input type="email" name="email" required maxlength="150" value="<%=esc.apply(student.getEmail())%>" placeholder="student@example.com"></label>
<label>Course<input name="course" required maxlength="100" value="<%=esc.apply(student.getCourse())%>" placeholder="e.g. Computer Science"></label>
<label>Year of study<select name="year" required><% for(int y=1;y<=6;y++){ %><option value="<%=y%>" <%=student.getYear()==y?"selected":""%>>Year <%=y%></option><% } %></select></label>
<div class="form-actions"><button class="button" type="submit"><%=editing?"Save Changes":"Add Student"%></button><a class="cancel" href="<%=ctx%>/students">Cancel</a></div>
</form></section></main></body></html>