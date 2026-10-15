 
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, java.util.Set, java.util.TreeSet, java.util.HashSet, com.college.student.Student" %>

<%
    List<Student> students = (List<Student>) request.getAttribute("students");
    String ctx = request.getContextPath();

    if (students == null) {
        students = java.util.Collections.emptyList();
    }

    java.util.function.Function<String, String> esc = s -> s == null ? "" :
        s.replace("&", "&amp;").replace("<", "&lt;")
         .replace(">", "&gt;").replace("\"", "&quot;")
         .replace("'", "&#39;");

    Set<String> courses = new TreeSet<>();
    Set<String> years = new TreeSet<>();
    Set<String> emails = new HashSet<>();

    for (Student s : students) {
        if (s.getCourse() != null && !s.getCourse().trim().isEmpty()) {
            courses.add(s.getCourse().trim());
        }
        years.add(String.valueOf(s.getYear()));
        if (s.getEmail() != null) {
            emails.add(s.getEmail().toLowerCase());
        }
    }

    int total = students.size();
    int courseCount = courses.size();
    int yearCount = years.size();

    String notice = request.getParameter("message");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>StudentHub | Student Management</title>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%=ctx%>/css/style.css">

<style>
:root {
  --primary:#5b57d9; --primary-light:#f0efff; --ink:#20283a;
  --muted:#7b879c; --line:#e8ebf3; --bg:#f6f7fc;
}
* { box-sizing:border-box; }
body { margin:0; background:var(--bg); color:var(--ink); font-family:'DM Sans',Arial,sans-serif; }
a { text-decoration:none; }
button,input,select { font:inherit; }
.dashboard { max-width:1500px; margin:auto; padding:28px clamp(14px,4vw,48px); }
.topbar { display:flex; align-items:center; justify-content:space-between; gap:18px; margin-bottom:26px; }
.brand { display:flex; align-items:center; gap:12px; }
.brand-logo { display:grid; place-items:center; width:46px; height:46px; border-radius:15px; background:var(--primary); color:white; font-size:23px; box-shadow:0 8px 20px #5b57d933; }
.brand-name { font-size:19px; font-weight:800; letter-spacing:-.5px; }
.brand-sub { margin-top:4px; color:var(--muted); font-size:10px; letter-spacing:1.6px; }
.top-right { display:flex; align-items:center; gap:15px; }
.live { font-size:12px; color:#309b78; }
.live:before { content:""; display:inline-block; width:7px; height:7px; margin-right:7px; border-radius:50%; background:#42c497; }
.btn { display:inline-flex; align-items:center; justify-content:center; gap:8px; border:0; border-radius:10px; padding:12px 16px; font-size:13px; font-weight:700; cursor:pointer; transition:.2s; }
.btn:hover { transform:translateY(-1px); }
.btn-primary { background:var(--primary); color:white; box-shadow:0 6px 16px #5b57d926; }
.btn-primary:hover { background:#4945c5; }
.btn-soft { background:var(--primary-light); color:var(--primary); }
.hero { position:relative; display:grid; grid-template-columns:1.15fr .85fr; overflow:hidden; min-height:265px; margin-bottom:22px; border-radius:23px; background:#eeedff; }
.hero-copy { position:relative; z-index:2; padding:clamp(25px,4vw,45px); }
.eyebrow { color:var(--primary); font-size:10px; font-weight:800; letter-spacing:1.9px; }
.eyebrow:before { content:""; display:inline-block; width:7px; height:7px; margin-right:8px; border-radius:50%; background:var(--primary); }
.hero h1 { margin:17px 0 12px; max-width:510px; font-size:clamp(30px,4vw,43px); line-height:1.12; letter-spacing:-1.8px; }
.hero h1 em { color:var(--primary); font-style:normal; }
.hero p { max-width:440px; color:#737c96; font-size:13px; line-height:1.8; }
.hero-visual { position:relative; min-height:265px; overflow:hidden; }
.hero-visual img { position:absolute; width:100%; height:100%; inset:0; object-fit:cover; }
.hero-visual:after { content:""; position:absolute; inset:0; background:linear-gradient(90deg,#eeedff 0%,#eeedff60 25%,#292d5112 100%); }
.hero-tag { position:absolute; z-index:2; top:22px; right:22px; padding:10px 13px; border-radius:11px; background:#ffffffeb; color:#596177; font-size:11px; font-weight:700; box-shadow:0 8px 20px #252b4618; }
.hero-floating { position:absolute; z-index:2; bottom:25px; left:5px; display:flex; align-items:center; gap:10px; padding:13px 16px; border-radius:13px; background:#ffffffed; box-shadow:0 10px 30px #252b4618; }
.hero-floating-icon { display:grid; place-items:center; width:34px; height:34px; border-radius:10px; background:#eeecff; color:var(--primary); font-size:18px; }
.hero-floating b,.hero-floating small { display:block; font-size:11px; }
.hero-floating small { margin-top:4px; color:var(--muted); }
.stats { display:grid; grid-template-columns:repeat(4,minmax(0,1fr)); gap:15px; margin-bottom:24px; }
.stat { position:relative; min-height:138px; overflow:hidden; padding:19px; border:1px solid var(--line); border-radius:17px; background:white; }
.stat-label { display:flex; align-items:center; justify-content:space-between; gap:6px; color:var(--muted); font-size:12px; }
.stat-icon { display:grid; place-items:center; width:34px; height:34px; border-radius:11px; background:#efedff; color:var(--primary); font-size:18px; }
.stat-value { margin:10px 0 3px; font-size:31px; font-weight:800; letter-spacing:-1px; }
.stat-caption { color:#99a2b3; font-size:11px; }
.stat-line { position:absolute; bottom:0; left:0; right:0; height:3px; background:var(--primary); }
.stat:nth-child(2) .stat-icon { background:#e8f4ff; color:#3b86cf; }
.stat:nth-child(2) .stat-line { background:#65a9e9; }
.stat:nth-child(3) .stat-icon { background:#e3f8ef; color:#269c78; }
.stat:nth-child(3) .stat-line { background:#55c9a4; }
.stat:nth-child(4) .stat-icon { background:#fff0e4; color:#d18a43; }
.stat:nth-child(4) .stat-line { background:#f2b66f; }
.notice { display:flex; align-items:center; gap:10px; margin:0 0 17px; padding:13px 16px; border-radius:10px; font-size:12px; }
.notice.success { background:#e8faf2; color:#187c5c; }
.notice.error { background:#fff0f1; color:#b12f43; }
.notice button { margin-left:auto; border:0; background:none; color:inherit; cursor:pointer; font-size:18px; }
.panel { overflow:hidden; border:1px solid var(--line); border-radius:19px; background:white; box-shadow:0 8px 28px #28304a06; }
.panel-heading { display:flex; align-items:center; justify-content:space-between; gap:15px; padding:24px 25px 19px; }
.section-label { color:var(--primary); font-size:10px; font-weight:800; letter-spacing:1.6px; }
.panel-heading h2 { margin:7px 0 5px; font-size:21px; letter-spacing:-.6px; }
.panel-heading p { margin:0; color:var(--muted); font-size:12px; }
.count { display:inline-grid; place-items:center; min-width:29px; height:28px; padding:0 9px; border-radius:9px; background:var(--primary-light); color:var(--primary); font-size:12px; font-weight:800; }
.filters { display:flex; align-items:center; gap:10px; padding:14px 24px; border-top:1px solid #f0f1f6; border-bottom:1px solid #edf0f6; background:#fafbfe; }
.search { display:flex; align-items:center; gap:9px; flex:1; min-width:130px; height:42px; padding:0 12px; border:1px solid #e4e7f0; border-radius:9px; background:white; color:#929bae; }
.search input { width:100%; min-width:0; border:0; outline:0; background:transparent; color:var(--ink); font-size:12px; }
.filters select { height:42px; min-width:135px; padding:0 10px; border:1px solid #e4e7f0; border-radius:9px; background:white; color:#59647a; font-size:12px; }
.clear-btn { padding:10px; border:0; background:transparent; color:var(--muted); cursor:pointer; font-size:12px; }
.table-wrap { width:100%; overflow-x:auto; }
table { width:100%; border-collapse:collapse; white-space:nowrap; }
thead { background:white; }
th { padding:15px 17px; border-bottom:1px solid #edf0f5; color:#929bad; text-align:left; font-size:10px; letter-spacing:1px; }
td { padding:14px 17px; border-bottom:1px solid #f0f2f7; font-size:12px; }
tbody tr { transition:background .15s; }
tbody tr:hover { background:#fafaff; }
.student { display:flex; align-items:center; gap:11px; }
.avatar { display:grid; place-items:center; flex-shrink:0; width:39px; height:39px; border-radius:13px; background:#eeebff; color:#6258bd; font-size:11px; font-weight:800; }
.avatar.a1 { background:#ffede3; color:#a45d3d; }
.avatar.a2 { background:#dff7ed; color:#237e65; }
.avatar.a3 { background:#e0f1ff; color:#337bb5; }
.avatar.a4 { background:#ffe5ef; color:#b24d78; }
.student b,.student small { display:block; }
.student b { margin-bottom:4px; font-size:12px; }
.student small { color:var(--muted); font-size:11px; }
.course { display:inline-flex; align-items:center; gap:7px; padding:7px 10px; border-radius:8px; background:#f7f7fc; color:#5d667b; font-size:11px; }
.course:before { content:""; width:6px; height:6px; border-radius:50%; background:#8177e8; }
.year { display:inline-block; padding:6px 9px; border-radius:7px; background:#f1f3f8; color:#63708a; font-size:11px; }
.actions { display:flex; justify-content:center; gap:7px; }
.action { display:grid; place-items:center; width:32px; height:32px; border:1px solid #e8eaf2; border-radius:9px; background:white; color:#737e93; cursor:pointer; font-size:15px; }
.action.edit:hover { color:var(--primary); background:#efedff; border-color:#dcd8ff; }
.action.delete:hover { color:#d83d55; background:#fff0f1; border-color:#ffd6db; }
.empty { padding:45px 20px; text-align:center; }
.empty-icon { display:grid; place-items:center; width:56px; height:56px; margin:0 auto 14px; border-radius:17px; background:#efedff; color:var(--primary); font-size:26px; }
.empty h3 { margin:0 0 8px; }
.empty p { margin:0 0 18px; color:var(--muted); font-size:13px; }
.table-footer { display:flex; justify-content:space-between; gap:12px; padding:16px 24px; color:var(--muted); font-size:11px; }
.table-footer b { color:var(--ink); }
footer { display:flex; justify-content:space-between; gap:15px; padding:23px 2px; color:#9aa2b2; font-size:11px; }
footer strong { color:var(--primary); }
.modal { position:fixed; inset:0; z-index:100; display:none; align-items:center; justify-content:center; padding:20px; background:#171b2c88; backdrop-filter:blur(4px); }
.modal.show { display:flex; }
.modal-card { width:100%; max-width:390px; padding:29px; border-radius:19px; background:white; text-align:center; box-shadow:0 25px 80px #0002; }
.modal-icon { display:grid; place-items:center; width:50px; height:50px; margin:0 auto 14px; border-radius:15px; background:#fff0f1; color:#d83d55; font-size:23px; }
.modal-card h3 { margin:0 0 9px; }
.modal-card p { color:var(--muted); font-size:13px; line-height:1.7; }
.modal-actions { display:flex; justify-content:center; gap:10px; margin-top:20px; }
@media(max-width:1000px) { .stats { grid-template-columns:repeat(2,minmax(0,1fr)); } }
@media(max-width:700px) {
 .dashboard { padding:17px 12px; }
 .topbar { align-items:flex-start; }
 .top-right { align-items:flex-end; flex-direction:column; gap:8px; }
 .brand-name { font-size:16px; }
 .brand-logo { width:39px; height:39px; }
 .hero { grid-template-columns:1fr; }
 .hero-copy { padding:26px; }
 .hero-visual { min-height:175px; }
 .hero-visual:after { background:linear-gradient(180deg,#eeedff 0%,transparent 65%); }
 .stats { gap:10px; }
 .stat { padding:13px; min-height:125px; }
 .stat-value { font-size:26px; }
 .panel-heading { align-items:flex-start; padding:20px 16px; }
 .filters { flex-wrap:wrap; padding:12px; }
 .search { flex-basis:100%; }
 .filters select { flex:1; min-width:0; }
 .table-footer,footer { flex-direction:column; }
}
@media(max-width:390px) { .btn { padding:10px; font-size:11px; } .hero h1 { font-size:30px; } }
@media print { .top-right,.hero,.stats,.filters,.actions,footer { display:none!important; } .dashboard { padding:0; } body { background:white; } }
</style>
</head>

<body>
<main class="dashboard">

<header class="topbar">
  <div class="brand">
    <div class="brand-logo">S</div>
    <div>
      <div class="brand-name">Student<span style="color:var(--primary)">Hub</span></div>
      <div class="brand-sub">STUDENT MANAGEMENT PORTAL</div>
    </div>
  </div>
  <div class="top-right">
    <span class="live">System online</span>
    <a class="btn btn-primary" href="<%=ctx%>/students?action=new">＋ Add Student</a>
  </div>
</header>

<section class="hero">
  <div class="hero-copy">
    <div class="eyebrow">WEB APPLICATION DEVELOPMENT</div>
    <h1>Every student.<br>Every <em>possibility.</em></h1>
    <p>Keep student records organised, discover information quickly, and manage your academic community from one simple dashboard.</p>
    <a class="btn btn-soft" href="#directory">Explore directory &nbsp; ↘</a>
  </div>
  <div class="hero-visual">
    <img src="https://images.unsplash.com/photo-1523240795612-9a054b0db644?auto=format&fit=crop&w=1000&q=85" alt="University students studying together" onerror="this.style.display='none'">
    <div class="hero-tag">✦ &nbsp; Your academic workspace</div>
    <div class="hero-floating">
      <div class="hero-floating-icon">♧</div>
      <div><b>Student directory</b><small>All your records in one place</small></div>
    </div>
  </div>
</section>

<% if ("created".equals(notice) || "updated".equals(notice) || "deleted".equals(notice)) { %>
<div class="notice success" role="status">
  ✓
  <span><%= "created".equals(notice) ? "Student added successfully." : "updated".equals(notice) ? "Student details updated successfully." : "Student record deleted successfully." %></span>
  <button type="button" onclick="this.parentElement.remove()" aria-label="Close">×</button>
</div>
<% } %>
<% if (error != null && !error.isEmpty()) { %>
<div class="notice error" role="alert">
  ⚠ <span>There was a problem processing your request. Please check the record and try again.</span>
  <button type="button" onclick="this.parentElement.remove()" aria-label="Close">×</button>
</div>
<% } %>

<section class="stats" aria-label="Student statistics">
  <article class="stat">
    <div class="stat-label">Total students <span class="stat-icon">♙</span></div>
    <div class="stat-value"><%=total%></div>
    <div class="stat-caption">Registered student records</div>
    <div class="stat-line"></div>
  </article>
  <article class="stat">
    <div class="stat-label">Courses represented <span class="stat-icon">▤</span></div>
    <div class="stat-value"><%=courseCount%></div>
    <div class="stat-caption">Distinct courses in the directory</div>
    <div class="stat-line"></div>
  </article>
  <article class="stat">
    <div class="stat-label">Study years <span class="stat-icon">⌁</span></div>
    <div class="stat-value"><%=yearCount%></div>
    <div class="stat-caption">Different years represented</div>
    <div class="stat-line"></div>
  </article>
  <article class="stat">
    <div class="stat-label">Unique emails <span class="stat-icon">✉</span></div>
    <div class="stat-value"><%=emails.size()%></div>
    <div class="stat-caption">Distinct email addresses</div>
    <div class="stat-line"></div>
  </article>
</section>

<section class="panel" id="directory">
  <div class="panel-heading">
    <div>
      <div class="section-label">DIRECTORY OVERVIEW</div>
      <h2>Registered Students <span class="count" id="visibleCount"><%=total%></span></h2>
      <p>View, search, edit, and manage student information.</p>
    </div>
    <button type="button" class="btn btn-soft" onclick="window.print()">⤓ Export / Print</button>
  </div>

  <div class="filters">
    <label class="search">
      <span>⌕</span>
      <input type="search" id="studentSearch" placeholder="Search name, email, ID or course..." aria-label="Search students">
    </label>
    <select id="courseFilter" aria-label="Filter by course">
      <option value="">All courses</option>
      <% for (String course : courses) { %>
        <option value="<%=esc.apply(course).toLowerCase()%>"><%=esc.apply(course)%></option>
      <% } %>
    </select>
    <select id="yearFilter" aria-label="Filter by year">
      <option value="">All years</option>
      <% for (String year : years) { %>
        <option value="<%=esc.apply(year)%>">Year <%=esc.apply(year)%></option>
      <% } %>
    </select>
    <button class="clear-btn" type="button" id="clearFilters">Clear</button>
  </div>

  <% if (students.isEmpty()) { %>
  <div class="empty">
    <div class="empty-icon">♙</div>
    <h3>Your directory starts here</h3>
    <p>No student records are registered yet. Add the first student to get started.</p>
    <a class="btn btn-primary" href="<%=ctx%>/students?action=new">＋ Add your first student</a>
  </div>
  <% } else { %>
  <div class="table-wrap">
    <table id="studentTable">
      <thead>
        <tr>
          <th>STUDENT</th>
          <th>EMAIL ADDRESS</th>
          <th>COURSE</th>
          <th>YEAR</th>
          <th>ID</th>
          <th style="text-align:center">ACTIONS</th>
        </tr>
      </thead>
      <tbody>
      <% int index = 0; for (Student s : students) {
           String name = s.getName() == null ? "" : s.getName().trim();
           String initials = name.isEmpty() ? "ST" : name.substring(0,1).toUpperCase();
           int lastSpace = name.lastIndexOf(' ');
           if (lastSpace >= 0 && lastSpace < name.length()-1) initials += name.substring(lastSpace+1,lastSpace+2).toUpperCase();
           String email = s.getEmail() == null ? "" : s.getEmail();
           String course = s.getCourse() == null ? "" : s.getCourse();
           String searchable = (s.getId()+" "+name+" "+email+" "+course+" "+s.getYear()).toLowerCase();
      %>
        <tr class="student-row"
            data-search="<%=esc.apply(searchable)%>"
            data-course="<%=esc.apply(course.toLowerCase())%>"
            data-year="<%=s.getYear()%>">
          <td>
            <div class="student">
              <div class="avatar a<%=index % 5%>"><%=esc.apply(initials)%></div>
              <div><b><%=esc.apply(name)%></b><small>Student profile</small></div>
            </div>
          </td>
          <td><%=esc.apply(email)%></td>
          <td><span class="course"><%=esc.apply(course)%></span></td>
          <td><span class="year">Year <%=s.getYear()%></span></td>
          <td>#<%=s.getId()%></td>
          <td>
            <div class="actions">
              <a class="action edit" title="Edit student" aria-label="Edit student" href="<%=ctx%>/students?action=edit&id=<%=s.getId()%>">✎</a>
              <button class="action delete" type="button" title="Delete student" aria-label="Delete student"
                      data-id="<%=s.getId()%>" data-name="<%=esc.apply(name)%>" onclick="confirmDelete(this)">⌫</button>
            </div>
          </td>
        </tr>
      <% index++; } %>
      </tbody>
    </table>
  </div>
  <div class="empty" id="noMatches" style="display:none">
    <div class="empty-icon">⌕</div>
    <h3>No matching students</h3>
    <p>Try another name, course, email, or study year.</p>
  </div>
  <div class="table-footer">
    <span>Showing <b id="showingCount"><%=total%></b> of <b><%=total%></b> registered students</span>
    <span>✦ &nbsp; Records are loaded from your student database</span>
  </div>
  <% } %>
</section>

<footer>
  <span>© <%=java.time.Year.now()%> <strong>StudentHub</strong> · Academic records management</span>
  <span>Java Servlet &nbsp;·&nbsp; JSP &nbsp;·&nbsp; XML &nbsp;·&nbsp; MySQL</span>
</footer>

</main>

<div class="modal" id="deleteModal" role="dialog" aria-modal="true" aria-labelledby="deleteTitle">
  <div class="modal-card">
    <div class="modal-icon">⌫</div>
    <h3 id="deleteTitle">Delete student record?</h3>
    <p>This will permanently remove <strong id="deleteStudentName">this student</strong> from your database. This action cannot be undone.</p>
    <div class="modal-actions">
      <button type="button" class="btn btn-soft" onclick="closeDelete()">Cancel</button>
      <form method="post" action="<%=ctx%>/students" id="deleteForm">
        <input type="hidden" name="action" value="delete">
        <input type="hidden" name="id" id="deleteStudentId">
        <button type="submit" class="btn" style="background:#d83d55;color:white">Yes, delete</button>
      </form>
    </div>
  </div>
</div>

<script>
(function () {
  const search = document.getElementById('studentSearch');
  const course = document.getElementById('courseFilter');
  const year = document.getElementById('yearFilter');
  const clear = document.getElementById('clearFilters');
  const rows = Array.from(document.querySelectorAll('.student-row'));
  const showing = document.getElementById('showingCount');
  const visible = document.getElementById('visibleCount');
  const empty = document.getElementById('noMatches');

  function filterRows() {
    const q = search ? search.value.trim().toLowerCase() : '';
    const c = course ? course.value : '';
    const y = year ? year.value : '';
    let count = 0;

    rows.forEach(function (row) {
      const match = row.dataset.search.includes(q)
        && (!c || row.dataset.course === c)
        && (!y || row.dataset.year === y);
      row.style.display = match ? '' : 'none';
      if (match) count++;
    });

    if (showing) showing.textContent = count;
    if (visible) visible.textContent = count;
    if (empty) empty.style.display = count === 0 ? 'block' : 'none';
    const table = document.getElementById('studentTable');
    if (table) table.style.display = count === 0 ? 'none' : 'table';
  }

  if (search) search.addEventListener('input', filterRows);
  if (course) course.addEventListener('change', filterRows);
  if (year) year.addEventListener('change', filterRows);
  if (clear) clear.addEventListener('click', function () {
    if (search) search.value = '';
    if (course) course.value = '';
    if (year) year.value = '';
    filterRows();
  });

  document.addEventListener('keydown', function (e) {
    if (e.key === '/' && !['INPUT','TEXTAREA','SELECT'].includes(document.activeElement.tagName)) {
      e.preventDefault();
      if (search) search.focus();
    }
    if (e.key === 'Escape') closeDelete();
  });
})();

function confirmDelete(button) {
  document.getElementById('deleteStudentId').value = button.dataset.id;
  document.getElementById('deleteStudentName').textContent = button.dataset.name;
  document.getElementById('deleteModal').classList.add('show');
}
function closeDelete() {
  const modal = document.getElementById('deleteModal');
  if (modal) modal.classList.remove('show');
}
document.getElementById('deleteModal').addEventListener('click', function (event) {
  if (event.target === this) closeDelete();
});
</script>
</body>
</html>
