<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List,com.college.student.Student" %>
<%
    List<Student> students = (List<Student>) request.getAttribute("students");
    String ctx = request.getContextPath();
    // Escape output to reduce the risk of HTML injection.
    java.util.function.Function<String,String> esc = s -> s == null ? "" : s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");
%>
<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>Student Management</title><link rel="stylesheet" href="<%=ctx%>/css/style.css"></head>
<body><main class="container">
<header class="top"><div><p class="eyebrow">WEB APPLICATION DEVELOPMENT</p><h1>Student Management System</h1><p class="muted">Manage student records in one place.</p></div><a class="button" href="<%=ctx%>/students?action=new">+ Add Student</a></header>
<section class="panel"><div class="panel-head"><h2>Registered Students</h2><span class="count"><%= students == null ? 0 : students.size() %> records</span></div>
<% if (students == null || students.isEmpty()) { %><div class="empty"><h3>No students yet</h3><p>Add your first student to get started.</p><a class="button" href="<%=ctx%>/students?action=new">Add a student</a></div>
<% } else { %><div class="table-wrap"><table><thead><tr><th>ID</th><th>Name</th><th>Email</th><th>Course</th><th>Year</th><th>Actions</th></tr></thead><tbody>
<% for (Student s : students) { %><tr><td><%=s.getId()%></td><td><strong><%=esc.apply(s.getName())%></strong></td><td><%=esc.apply(s.getEmail())%></td><td><%=esc.apply(s.getCourse())%></td><td><%=s.getYear()%></td><td class="actions"><a class="edit" href="<%=ctx%>/students?action=edit&id=<%=s.getId()%>">Edit</a>
<form method="post" action="<%=ctx%>/students" onsubmit="return confirm('Delete this student record?');"><input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="<%=s.getId()%>"><button class="delete" type="submit">Delete</button></form></td></tr><% } %>
</tbody></table></div><% } %></section><footer>Student Management System · Java Servlet + JSP + XML + MySQL</footer></main></body></html>