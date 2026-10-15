 
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.college.student.Student" %>
<%
    Student student = (Student) request.getAttribute("student");
    if (student == null) student = new Student();

    boolean editing = student.getId() > 0;
    String ctx = request.getContextPath();

    java.util.function.Function<String,String> esc = s -> s == null ? "" :
        s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;")
         .replace("\"","&quot;").replace("'","&#39;");

    String fullName = student.getName() == null ? "" : student.getName();
    String email = student.getEmail() == null ? "" : student.getEmail();
    String courseValue = student.getCourse() == null ? "" : student.getCourse();
    int selectedYear = student.getYear() >= 1 && student.getYear() <= 6 ? student.getYear() : 1;
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title><%=editing ? "Edit Student" : "Add Student"%> | StudentHub</title>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%=ctx%>/css/style.css">

<style>
:root {
  --primary:#5b57d9;
  --primary-dark:#4945c5;
  --pale:#efedff;
  --ink:#20283a;
  --muted:#7b879c;
  --line:#e5e8f1;
  --bg:#f6f7fc;
}
* { box-sizing:border-box; }
body {
  margin:0; background:var(--bg); color:var(--ink);
  font-family:'DM Sans',Arial,sans-serif;
}
a { text-decoration:none; }
button,input,select { font:inherit; }
.page { max-width:1200px; margin:auto; padding:25px clamp(14px,4vw,45px) 35px; }

.topbar {
  display:flex; align-items:center; justify-content:space-between;
  gap:15px; margin-bottom:28px;
}
.brand { display:flex; align-items:center; gap:12px; }
.brand-logo {
  display:grid; place-items:center; width:44px; height:44px;
  border-radius:14px; background:var(--primary); color:white;
  font-size:22px; font-weight:800; box-shadow:0 7px 18px #5b57d933;
}
.brand-name { font-size:18px; font-weight:800; }
.brand-name span { color:var(--primary); }
.brand-sub { margin-top:3px; color:var(--muted); font-size:9px; letter-spacing:1.5px; }
.back {
  display:inline-flex; align-items:center; gap:8px;
  padding:11px 14px; border:1px solid var(--line); border-radius:10px;
  background:white; color:#667188; font-size:12px; font-weight:700;
  transition:.2s;
}
.back:hover { border-color:#c9c4ff; color:var(--primary); transform:translateX(-2px); }

.intro { margin:0 0 22px; }
.eyebrow { color:var(--primary); font-size:10px; font-weight:800; letter-spacing:1.8px; }
.eyebrow:before {
  content:""; display:inline-block; width:7px; height:7px;
  margin-right:8px; border-radius:50%; background:var(--primary);
}
.intro h1 { margin:11px 0 8px; font-size:clamp(29px,4vw,39px); letter-spacing:-1.3px; }
.intro p { margin:0; color:var(--muted); font-size:13px; line-height:1.7; }

.layout { display:grid; grid-template-columns:minmax(0,1fr) 300px; gap:22px; align-items:start; }
.form-card {
  overflow:hidden; border:1px solid var(--line); border-radius:20px;
  background:white; box-shadow:0 10px 30px #28304a07;
}
.card-heading {
  padding:24px 26px; border-bottom:1px solid #edf0f6;
  background:linear-gradient(120deg,#fff 45%,#f7f6ff);
}
.heading-row { display:flex; align-items:center; justify-content:space-between; gap:12px; }
.heading-icon {
  display:grid; place-items:center; width:43px; height:43px;
  border-radius:13px; background:var(--pale); color:var(--primary); font-size:22px;
}
.card-heading h2 { margin:0 0 5px; font-size:19px; letter-spacing:-.5px; }
.card-heading p { margin:0; color:var(--muted); font-size:11px; }
.step-pill {
  padding:8px 10px; border-radius:8px; background:#efedff;
  color:var(--primary); font-size:10px; font-weight:800; white-space:nowrap;
}
.progress { height:4px; background:#eeeff7; }
.progress-bar { width:0; height:100%; background:var(--primary); transition:width .25s; }

.student-form { padding:25px 26px 27px; }
.section-title {
  display:flex; align-items:center; gap:9px; margin:0 0 18px;
  font-size:12px; font-weight:800; letter-spacing:.3px;
}
.section-number {
  display:grid; place-items:center; width:24px; height:24px;
  border-radius:8px; background:var(--pale); color:var(--primary); font-size:11px;
}
.fields { display:grid; grid-template-columns:1fr 1fr; gap:19px 17px; }
.field { min-width:0; }
.field.full { grid-column:1/-1; }
.field label {
  display:block; margin-bottom:8px; color:#3d465a; font-size:11px; font-weight:700;
}
.required { color:#d94d68; }
.control { position:relative; }
.control-icon {
  position:absolute; left:13px; top:50%; transform:translateY(-50%);
  color:#939cb0; font-size:16px; pointer-events:none;
}
.field input,.field select {
  width:100%; height:46px; padding:0 13px 0 40px;
  border:1px solid #e1e5ef; border-radius:10px; outline:none;
  background:#fff; color:var(--ink); font-size:12px; transition:.2s;
}
.field input::placeholder { color:#aab1bf; }
.field input:focus,.field select:focus {
  border-color:#8c85f0; box-shadow:0 0 0 3px #5b57d915;
}
.field input:focus:invalid { border-color:#df7b8b; }
.field select { cursor:pointer; }
.help { margin-top:7px; color:#9aa2b2; font-size:10px; line-height:1.5; }
.divider { height:1px; margin:25px 0 21px; background:#edf0f6; }

.form-actions {
  display:flex; align-items:center; justify-content:space-between;
  gap:12px; margin-top:26px; padding-top:21px; border-top:1px solid #edf0f6;
}
.action-group { display:flex; align-items:center; gap:10px; }
.btn {
  display:inline-flex; align-items:center; justify-content:center; gap:8px;
  min-height:43px; padding:11px 16px; border:0; border-radius:10px;
  cursor:pointer; font-size:12px; font-weight:800; transition:.2s;
}
.btn:hover { transform:translateY(-1px); }
.btn-primary { background:var(--primary); color:white; box-shadow:0 6px 16px #5b57d926; }
.btn-primary:hover { background:var(--primary-dark); }
.btn-light { border:1px solid var(--line); background:white; color:#68738a; }
.btn-light:hover { background:#f7f7fc; }

.side { display:flex; flex-direction:column; gap:16px; }
.preview-card {
  overflow:hidden; border:1px solid var(--line); border-radius:19px;
  background:white; box-shadow:0 10px 30px #28304a07;
}
.preview-banner {
  position:relative; min-height:125px; overflow:hidden;
  background:linear-gradient(125deg,#504bc5,#8982f4);
}
.preview-banner img {
  position:absolute; inset:0; width:100%; height:100%; object-fit:cover;
  opacity:.4;
}
.preview-banner:after {
  content:""; position:absolute; inset:0;
  background:linear-gradient(120deg,#4945b9aa,#7770e033);
}
.preview-label {
  position:absolute; z-index:1; top:16px; left:17px; color:white;
  font-size:9px; font-weight:800; letter-spacing:1.6px;
}
.profile { position:relative; z-index:2; margin:-36px 19px 0; }
.profile-avatar {
  display:grid; place-items:center; width:72px; height:72px;
  border:5px solid white; border-radius:23px; background:#eeebff;
  color:var(--primary); font-size:22px; font-weight:800;
  box-shadow:0 5px 15px #272c4215;
}
.preview-content { padding:12px 20px 21px; }
.preview-content h3 { overflow-wrap:anywhere; margin:0 0 6px; font-size:17px; letter-spacing:-.4px; }
.preview-email { overflow-wrap:anywhere; color:var(--muted); font-size:11px; }
.preview-badges { display:flex; flex-wrap:wrap; gap:7px; margin-top:16px; }
.preview-badge {
  padding:7px 9px; border-radius:8px; background:#f0efff;
  color:#5b57c5; font-size:10px; font-weight:700;
}
.preview-badge.year { background:#e9f7f0; color:#288263; }
.preview-note {
  display:flex; align-items:flex-start; gap:10px; margin-top:16px;
  padding:12px; border-radius:10px; background:#f8f9fc;
  color:#7e899d; font-size:10px; line-height:1.6;
}
.preview-note span { color:var(--primary); font-size:15px; }
.tip-card {
  padding:19px; border:1px solid #e6e4ff; border-radius:17px;
  background:#f0efff;
}
.tip-title { display:flex; align-items:center; gap:9px; margin-bottom:10px; font-size:12px; font-weight:800; }
.tip-icon {
  display:grid; place-items:center; width:29px; height:29px;
  border-radius:9px; background:white; color:var(--primary); font-size:16px;
}
.tip-card p { margin:0; color:#737b96; font-size:11px; line-height:1.8; }
.tip-card ul { margin:12px 0 0; padding-left:17px; color:#737b96; font-size:10px; line-height:2; }

footer {
  display:flex; justify-content:space-between; flex-wrap:wrap; gap:12px;
  padding:24px 2px 0; color:#9aa2b2; font-size:10px;
}
footer strong { color:var(--primary); }
.toast {
  position:fixed; right:20px; bottom:20px; z-index:20;
  max-width:calc(100% - 40px); padding:13px 17px; border-radius:12px;
  background:#262b40; color:white; box-shadow:0 12px 35px #0002;
  font-size:12px; opacity:0; transform:translateY(12px); pointer-events:none; transition:.25s;
}
.toast.show { opacity:1; transform:translateY(0); }
@media(max-width:850px) {
  .layout { grid-template-columns:minmax(0,1fr) 260px; gap:14px; }
  .student-form { padding:21px; }
}
@media(max-width:700px) {
  .page { padding:16px 12px 25px; }
  .layout { grid-template-columns:1fr; }
  .side { display:grid; grid-template-columns:1fr 1fr; align-items:start; }
  .preview-banner { min-height:105px; }
}
@media(max-width:480px) {
  .brand-name { font-size:16px; }
  .brand-logo { width:39px; height:39px; }
  .back { padding:10px; font-size:11px; }
  .fields { grid-template-columns:1fr; gap:16px; }
  .field.full { grid-column:auto; }
  .student-form { padding:19px 16px; }
  .card-heading { padding:19px 16px; }
  .side { grid-template-columns:1fr; }
  .form-actions { align-items:stretch; flex-direction:column; }
  .action-group { width:100%; }
  .action-group .btn { flex:1; }
}
@media(prefers-reduced-motion:reduce) {
  *,*::before,*::after { transition:none!important; scroll-behavior:auto!important; }
}
</style>
</head>

<body>
<main class="page">

<header class="topbar">
  <div class="brand">
    <div class="brand-logo">S</div>
    <div>
      <div class="brand-name">Student<span>Hub</span></div>
      <div class="brand-sub">STUDENT MANAGEMENT PORTAL</div>
    </div>
  </div>
  <a class="back" href="<%=ctx%>/students">← Back to directory</a>
</header>

<section class="intro">
  <div class="eyebrow">STUDENT RECORDS</div>
  <h1><%=editing ? "Update student details" : "Let's add a student."%></h1>
  <p><%=editing ? "Review the existing information and save your changes." : "Create a new student profile and keep your academic directory up to date."%></p>
</section>

<div class="layout">
  <section class="form-card">
    <div class="card-heading">
      <div class="heading-row">
        <div style="display:flex;align-items:center;gap:13px">
          <div class="heading-icon"><%=editing ? "✎" : "＋"%></div>
          <div>
            <h2><%=editing ? "Edit student profile" : "New student profile"%></h2>
            <p>Fields marked <span class="required">*</span> are required.</p>
          </div>
        </div>
        <span class="step-pill"><%=editing ? "EDIT MODE" : "NEW RECORD"%></span>
      </div>
    </div>

    <div class="progress"><div class="progress-bar" id="progressBar"></div></div>

    <form method="post" action="<%=ctx%>/students" class="student-form" id="studentForm">
      <input type="hidden" name="action" value="<%=editing ? "update" : "insert"%>">
      <% if (editing) { %>
        <input type="hidden" name="id" value="<%=student.getId()%>">
      <% } %>

      <h3 class="section-title"><span class="section-number">1</span> Personal information</h3>

      <div class="fields">
        <div class="field full">
          <label for="name">Full name <span class="required">*</span></label>
          <div class="control">
            <span class="control-icon">♙</span>
            <input id="name" name="name" type="text" required maxlength="100"
                   autocomplete="name" pattern=".*\S.*"
                   value="<%=esc.apply(fullName)%>" placeholder="e.g. Anushka Gupta">
          </div>
          <div class="help">Enter the student's full name.</div>
        </div>

        <div class="field full">
          <label for="email">Email address <span class="required">*</span></label>
          <div class="control">
            <span class="control-icon">✉</span>
            <input id="email" name="email" type="email" required maxlength="150"
                   autocomplete="email" value="<%=esc.apply(email)%>"
                   placeholder="student@example.com">
          </div>
          <div class="help">Use a valid email address. It should be unique for each student.</div>
        </div>
      </div>

      <div class="divider"></div>

      <h3 class="section-title"><span class="section-number">2</span> Academic information</h3>

      <div class="fields">
        <div class="field">
          <label for="course">Course / programme <span class="required">*</span></label>
          <div class="control">
            <span class="control-icon">▤</span>
            <input id="course" name="course" type="text" required maxlength="100"
                   list="courseOptions" pattern=".*\S.*"
                   value="<%=esc.apply(courseValue)%>" placeholder="e.g. Computer Science">
            <datalist id="courseOptions">
              <option value="Computer Science">
              <option value="Information Technology">
              <option value="Artificial Intelligence and Machine Learning">
              <option value="Data Science">
              <option value="Electronics and Communication">
              <option value="Mechanical Engineering">
              <option value="Civil Engineering">
              <option value="Business Administration">
            </datalist>
          </div>
          <div class="help">Choose a suggestion or enter your own course.</div>
        </div>

        <div class="field">
          <label for="year">Year of study <span class="required">*</span></label>
          <div class="control">
            <span class="control-icon">▦</span>
            <select id="year" name="year" required>
              <% for (int y = 1; y <= 6; y++) { %>
                <option value="<%=y%>" <%=selectedYear == y ? "selected" : ""%>>
                  Year <%=y%><%=y == 1 ? " — First year" : y == 2 ? " — Second year" : y == 3 ? " — Third year" : y == 4 ? " — Fourth year" : ""%>
                </option>
              <% } %>
            </select>
          </div>
          <div class="help">Select the student's current year.</div>
        </div>
      </div>

      <div class="form-actions">
        <span style="color:var(--muted);font-size:10px">✦ &nbsp; Review details before saving.</span>
        <div class="action-group">
          <a class="btn btn-light" href="<%=ctx%>/students">Cancel</a>
          <button class="btn btn-primary" type="submit">
            <%=editing ? "✓ Save changes" : "＋ Create student"%>
          </button>
        </div>
      </div>
    </form>
  </section>

  <aside class="side">
    <section class="preview-card">
      <div class="preview-banner">
        <img src="https://images.unsplash.com/photo-1523050854058-8df90110c9f1?auto=format&fit=crop&w=800&q=80"
             alt="University campus" onerror="this.style.display='none'">
        <div class="preview-label">PROFILE PREVIEW</div>
      </div>
      <div class="profile">
        <div class="profile-avatar" id="avatar">ST</div>
      </div>
      <div class="preview-content">
        <h3 id="previewName"><%=fullName.isEmpty() ? "Student full name" : esc.apply(fullName)%></h3>
        <div class="preview-email" id="previewEmail"><%=email.isEmpty() ? "student@example.com" : esc.apply(email)%></div>
        <div class="preview-badges">
          <span class="preview-badge" id="previewCourse"><%=courseValue.isEmpty() ? "Course name" : esc.apply(courseValue)%></span>
          <span class="preview-badge year" id="previewYear">Year <%=selectedYear%></span>
        </div>
        <div class="preview-note">
          <span>✦</span>
          <div>This is a live preview. Your information will be saved when you submit the form.</div>
        </div>
      </div>
    </section>

    <section class="tip-card">
      <div class="tip-title"><span class="tip-icon">✓</span> Helpful reminders</div>
      <p>Keep the student information accurate so records are easy to find and maintain.</p>
      <ul>
        <li>Use the student's correct full name.</li>
        <li>Check spelling in the email address.</li>
        <li>Enter the correct course and year.</li>
      </ul>
    </section>
  </aside>
</div>

<footer>
  <span>© <%=java.time.Year.now()%> <strong>StudentHub</strong> · Academic records management</span>
  <span>Java Servlet · JSP · XML · MySQL</span>
</footer>

<div class="toast" id="toast" role="status" aria-live="polite"></div>
</main>

<script>
(function () {
  const form = document.getElementById('studentForm');
  const name = document.getElementById('name');
  const email = document.getElementById('email');
  const course = document.getElementById('course');
  const year = document.getElementById('year');
  const bar = document.getElementById('progressBar');
  const toast = document.getElementById('toast');

  function initials(value) {
    const parts = value.trim().split(/\s+/).filter(Boolean);
    if (!parts.length) return 'ST';
    return (parts[0][0] + (parts.length > 1 ? parts[parts.length - 1][0] : '')).toUpperCase();
  }

  function updatePreview() {
    document.getElementById('previewName').textContent = name.value.trim() || 'Student full name';
    document.getElementById('previewEmail').textContent = email.value.trim() || 'student@example.com';
    document.getElementById('previewCourse').textContent = course.value.trim() || 'Course name';
    document.getElementById('previewYear').textContent = 'Year ' + year.value;
    document.getElementById('avatar').textContent = initials(name.value);

    const fields = [name, email, course, year];
    const filled = fields.filter(function (field) {
      return field.value.trim() !== '';
    }).length;
    bar.style.width = (filled / fields.length * 100) + '%';
  }

  [name, email, course, year].forEach(function (field) {
    field.addEventListener('input', updatePreview);
    field.addEventListener('change', updatePreview);
  });

  form.addEventListener('submit', function (event) {
    if (!form.checkValidity()) {
      event.preventDefault();
      form.reportValidity();
      return;
    }

    if (!name.value.trim() || !course.value.trim()) {
      event.preventDefault();
      toast.textContent = 'Please enter a name and course.';
      toast.classList.add('show');
      setTimeout(function () { toast.classList.remove('show'); }, 2800);
    }
  });

  updatePreview();
})();
</script>
</body>
</html>
