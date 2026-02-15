#!/bin/bash
cd /Users/jayowen/projects/vxtra-health/blueprint
SECTIONS=sections
OUT=vxtra-health-execution-plan.html

cat > "$OUT" << 'HEADER'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Vxtra Health — Execution Plan</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=DM+Serif+Display:ital@0;1&family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
<style>
:root{--teal:#22BAB4;--teal-dark:#1a9e99;--teal-light:#e6f7f6;--coral:#E8734A;--coral-dark:#d45e36;--coral-light:#fdf0eb;--ink:#1B2A3D;--ink-light:#2d3f55;--white:#fff;--off-white:#f8f9fa;--light-gray:#f1f3f5;--mid-gray:#6c757d;--border:#dee2e6;--font-body:'Inter',-apple-system,sans-serif;--font-heading:'DM Serif Display',Georgia,serif;--sidebar-w:260px;--section-max:900px}
*{margin:0;padding:0;box-sizing:border-box}
html{scroll-behavior:smooth}
body{font-family:var(--font-body);background:var(--off-white);color:var(--ink);line-height:1.7;-webkit-font-smoothing:antialiased}

/* SIDEBAR */
.sidebar{position:fixed;top:0;left:0;width:var(--sidebar-w);height:100vh;background:var(--ink);padding:32px 0;overflow-y:auto;z-index:100;display:flex;flex-direction:column}
.sidebar-logo{padding:0 24px 24px;border-bottom:1px solid rgba(255,255,255,.08);margin-bottom:16px}
.sidebar-logo img{height:32px;width:auto}
.sidebar nav{flex:1}
.sidebar nav a{display:flex;align-items:center;gap:10px;padding:10px 24px;color:rgba(255,255,255,.5);text-decoration:none;font-size:13px;font-weight:500;letter-spacing:.2px;transition:all .2s;border-left:3px solid transparent}
.sidebar nav a:hover{color:rgba(255,255,255,.85);background:rgba(255,255,255,.04)}
.sidebar nav a.active{color:var(--white);border-left-color:var(--teal);background:rgba(34,186,180,.08)}
.sidebar nav a .nav-num{font-size:11px;font-weight:700;color:var(--teal);min-width:20px}
.sidebar-footer{padding:20px 24px;border-top:1px solid rgba(255,255,255,.08)}
.sidebar-footer img{height:22px;width:auto;opacity:.35}
.sidebar-footer p{font-size:11px;color:rgba(255,255,255,.3);margin-top:8px}
.sidebar .nav-divider{height:1px;background:rgba(255,255,255,.06);margin:8px 24px}

/* MOBILE NAV */
.mobile-nav{display:none;position:fixed;top:0;left:0;right:0;height:56px;background:var(--ink);z-index:200;align-items:center;justify-content:space-between;padding:0 20px}
.mobile-nav img{height:26px}
.hamburger{background:none;border:none;color:var(--white);font-size:24px;cursor:pointer;padding:8px;line-height:1}
.mobile-menu{display:none;position:fixed;top:56px;left:0;right:0;bottom:0;background:var(--ink);z-index:199;padding:16px 0;overflow-y:auto}
.mobile-menu.open{display:block}
.mobile-menu a{display:block;padding:12px 24px;color:rgba(255,255,255,.7);text-decoration:none;font-size:15px;font-weight:500;border-bottom:1px solid rgba(255,255,255,.05)}
.mobile-menu a.active{color:var(--teal)}

/* MAIN */
.main{margin-left:var(--sidebar-w);min-height:100vh}

/* COVER */
.cover{min-height:70vh;background:linear-gradient(135deg,var(--ink) 0%,#0f1c2e 60%,#112233 100%);display:flex;flex-direction:column;justify-content:center;align-items:center;text-align:center;padding:80px 40px;position:relative;overflow:hidden}
.cover::before{content:'';position:absolute;top:-30%;right:-20%;width:600px;height:600px;border-radius:50%;background:radial-gradient(circle,rgba(34,186,180,.06) 0%,transparent 70%);pointer-events:none}
.cover-logos{display:flex;align-items:center;gap:24px;margin-bottom:48px;position:relative;z-index:1}
.cover-logos img{height:44px;width:auto}
.cover-logos .divider{width:1px;height:32px;background:rgba(255,255,255,.2)}
.cover-label{display:inline-block;font-size:12px;font-weight:700;letter-spacing:3px;text-transform:uppercase;color:var(--teal);margin-bottom:20px;position:relative;z-index:1}
.cover h1{font-family:var(--font-heading);font-size:56px;font-weight:400;color:var(--white);line-height:1.1;margin-bottom:16px;position:relative;z-index:1}
.cover .subtitle{font-size:18px;color:rgba(255,255,255,.55);max-width:600px;line-height:1.6;position:relative;z-index:1}
.cover-footer{position:absolute;bottom:40px;font-size:13px;color:rgba(255,255,255,.25);z-index:1}
.cover .back-link{display:inline-block;margin-top:32px;color:var(--teal);font-size:14px;font-weight:600;text-decoration:none;position:relative;z-index:1;opacity:.7;transition:opacity .2s}
.cover .back-link:hover{opacity:1}

/* SECTION BANDS */
.section-band{background:var(--ink);color:var(--white);padding:36px 48px}
.section-band .badge{display:inline-block;padding:4px 14px;border-radius:50px;font-size:12px;font-weight:700;letter-spacing:1px;text-transform:uppercase;background:var(--coral);color:var(--white);margin-bottom:12px}
.section-band h2{font-family:var(--font-heading);font-size:36px;font-weight:400;line-height:1.2;color:var(--white)}
.section-band .band-sub{font-size:16px;color:rgba(255,255,255,.55);margin-top:8px}

/* CONTENT SECTIONS */
.doc-section{padding:48px;max-width:calc(var(--section-max) + 96px)}
.doc-section h1{font-family:var(--font-heading);font-size:32px;font-weight:400;margin:32px 0 16px;color:var(--ink);border-bottom:2px solid var(--teal);padding-bottom:12px}
.doc-section h2{font-family:var(--font-heading);font-size:26px;font-weight:400;margin:28px 0 12px;color:var(--ink)}
.doc-section h3{font-size:18px;font-weight:700;margin:24px 0 8px;color:var(--ink)}
.doc-section h4{font-size:14px;font-weight:700;margin:16px 0 6px;color:var(--ink-light);text-transform:uppercase;letter-spacing:1px}
.doc-section h5{font-size:14px;font-weight:700;margin:12px 0 4px;color:var(--coral)}
.doc-section p{font-size:15px;line-height:1.7;margin-bottom:12px}
.doc-section ul,.doc-section ol{margin:8px 0 16px 24px;font-size:15px;line-height:1.7}
.doc-section li{margin-bottom:6px}
.doc-section strong{color:var(--ink)}
.doc-section blockquote{border-left:4px solid var(--teal);padding:16px 24px;margin:16px 0;background:var(--teal-light);border-radius:0 8px 8px 0;font-style:italic}
.doc-section blockquote p{margin-bottom:0;font-size:16px}
.doc-section table{width:100%;border-collapse:collapse;margin:16px 0;font-size:14px}
.doc-section th{background:var(--ink);color:var(--white);padding:10px 14px;text-align:left;font-weight:600;font-size:13px;text-transform:uppercase;letter-spacing:.5px}
.doc-section td{padding:10px 14px;border-bottom:1px solid var(--border);vertical-align:top}
.doc-section tr:nth-child(even) td{background:var(--light-gray)}
.doc-section hr{border:none;height:2px;background:var(--border);margin:32px 0}

/* WIREFRAME BLOCKS */
.wireframe-block{border:2px dashed var(--border);border-radius:8px;padding:16px 20px;margin:8px 0;background:var(--light-gray);text-align:center;font-size:13px;font-weight:600;color:var(--mid-gray);text-transform:uppercase;letter-spacing:1px}

/* BACK TO TOP */
.back-to-top{position:fixed;bottom:32px;right:32px;width:44px;height:44px;border-radius:50%;background:var(--ink);color:var(--white);border:none;font-size:20px;cursor:pointer;z-index:150;opacity:0;transform:translateY(20px);transition:all .3s;box-shadow:0 2px 12px rgba(0,0,0,.15)}
.back-to-top.visible{opacity:1;transform:translateY(0)}

/* RESPONSIVE */
@media(max-width:1024px){.sidebar{display:none}.mobile-nav{display:flex}.main{margin-left:0;padding-top:56px}.doc-section{padding:32px 24px}.section-band{padding:32px 24px}.cover h1{font-size:40px}}

/* PRINT */
@media print{.sidebar,.mobile-nav,.back-to-top{display:none!important}.main{margin-left:0!important}.cover{min-height:auto;padding:40px}.doc-section{padding:24px 0;page-break-inside:avoid}.section-band{page-break-before:always;-webkit-print-color-adjust:exact;print-color-adjust:exact}}
</style>
</head>
<body>

<!-- SIDEBAR TOC -->
<aside class="sidebar">
<div class="sidebar-logo">
  <img src="../assets/vxtra-logo-color.png" alt="Vxtra Health">
</div>
<nav>
  <a href="#cover"><span class="nav-num"></span>Cover</a>
  <div class="nav-divider"></div>
  <a href="#site-architecture"><span class="nav-num">01</span>Site Architecture</a>
  <a href="#corporate-strategy"><span class="nav-num">02</span>Positioning Strategy</a>
  <div class="nav-divider"></div>
  <a href="#employer-wireframe"><span class="nav-num">03</span>Employer Wireframe</a>
  <a href="#employer-marketing"><span class="nav-num">04</span>Employer Marketing</a>
  <div class="nav-divider"></div>
  <a href="#broker-landing"><span class="nav-num">05</span>Broker Landing Page</a>
  <a href="#broker-wireframe"><span class="nav-num">06</span>Broker Wireframe</a>
  <a href="#broker-marketing"><span class="nav-num">07</span>Broker Marketing</a>
  <div class="nav-divider"></div>
  <a href="#physician-landing"><span class="nav-num">08</span>Physician Landing</a>
  <a href="#physician-wireframe"><span class="nav-num">09</span>Physician Wireframe</a>
  <a href="#physician-marketing"><span class="nav-num">10</span>Physician Marketing</a>
  <div class="nav-divider"></div>
  <a href="#employee-landing"><span class="nav-num">11</span>Employee Landing</a>
  <a href="#employee-wireframe"><span class="nav-num">12</span>Employee Wireframe</a>
  <a href="#employee-engagement"><span class="nav-num">13</span>Employee Engagement</a>
  <div class="nav-divider"></div>
  <a href="#asset-inventory"><span class="nav-num">14</span>Asset Inventory</a>
  <a href="#technical-scope"><span class="nav-num">15</span>Technical Scope</a>
  <a href="#timeline-budget"><span class="nav-num">16</span>Timeline & Budget</a>
</nav>
<div class="sidebar-footer">
  <img src="../assets/bb-logo-white.png" alt="Business Builders">
  <p>Prepared by Business Builders</p>
</div>
</aside>

<!-- MOBILE NAV -->
<div class="mobile-nav">
  <img src="../assets/vxtra-logo-color.png" alt="Vxtra Health">
  <button class="hamburger" onclick="toggleMobileMenu()">&#9776;</button>
</div>
<div class="mobile-menu" id="mobileMenu">
  <a href="#site-architecture" onclick="closeMobileMenu()">01 Site Architecture</a>
  <a href="#corporate-strategy" onclick="closeMobileMenu()">02 Positioning Strategy</a>
  <a href="#employer-wireframe" onclick="closeMobileMenu()">03 Employer Wireframe</a>
  <a href="#employer-marketing" onclick="closeMobileMenu()">04 Employer Marketing</a>
  <a href="#broker-landing" onclick="closeMobileMenu()">05 Broker Landing Page</a>
  <a href="#broker-wireframe" onclick="closeMobileMenu()">06 Broker Wireframe</a>
  <a href="#broker-marketing" onclick="closeMobileMenu()">07 Broker Marketing</a>
  <a href="#physician-landing" onclick="closeMobileMenu()">08 Physician Landing</a>
  <a href="#physician-wireframe" onclick="closeMobileMenu()">09 Physician Wireframe</a>
  <a href="#physician-marketing" onclick="closeMobileMenu()">10 Physician Marketing</a>
  <a href="#employee-landing" onclick="closeMobileMenu()">11 Employee Landing</a>
  <a href="#employee-wireframe" onclick="closeMobileMenu()">12 Employee Wireframe</a>
  <a href="#employee-engagement" onclick="closeMobileMenu()">13 Employee Engagement</a>
  <a href="#asset-inventory" onclick="closeMobileMenu()">14 Asset Inventory</a>
  <a href="#technical-scope" onclick="closeMobileMenu()">15 Technical Scope</a>
  <a href="#timeline-budget" onclick="closeMobileMenu()">16 Timeline & Budget</a>
</div>

<main class="main">

<!-- COVER -->
<section class="cover" id="cover">
<div class="cover-logos">
  <img src="../assets/vxtra-logo-color.png" alt="Vxtra Health">
  <div class="divider"></div>
  <img src="../assets/bb-logo-white.png" alt="Business Builders" style="opacity:.6">
</div>
<span class="cover-label">Execution Plan</span>
<h1>StoryBrand Blueprint<br>Part II</h1>
<p class="subtitle">Landing Pages, Wireframes, Marketing Strategies & Implementation Roadmap</p>
<a href="vxtra-health-blueprint.html" class="back-link">&larr; Back to Part I: Messaging Framework</a>
<p class="cover-footer">February 2026 &middot; Prepared by Business Builders</p>
</section>

HEADER

echo "<!-- shell written, injecting sections -->"

# ---- Corporate Strategy ----
echo '<div class="section-band" id="site-architecture"><span class="badge">Strategy</span><h2>Site Architecture</h2><p class="band-sub">How the Vxtra Health website is structured</p></div>' >> "$OUT"
echo '<section class="doc-section">' >> "$OUT"
# Extract just the Site Architecture section from corporate-strategy.html
python3 -c "
import re
with open('$SECTIONS/corporate-strategy.html') as f:
    html = f.read()
# Split on h1 tags
parts = re.split(r'<h1[^>]*>', html)
headers = re.findall(r'<h1[^>]*>(.*?)</h1>', html)
for i, header in enumerate(headers):
    if 'Site Architecture' in header or 'Strategic Site' in header or 'SECTION A' in header:
        # Get content up to next h1 or end
        content = parts[i+1] if i+1 < len(parts) else ''
        # Remove the closing h1 tag content
        content = re.split(r'</h1>', content, 1)[-1] if '</h1>' in content else content
        # Find next major section
        next_section = re.search(r'<h1', content)
        if next_section:
            content = content[:next_section.start()]
        print(content)
        break
" >> "$OUT" 2>/dev/null || cat "$SECTIONS/corporate-strategy.html" | head -200 >> "$OUT"
echo '</section>' >> "$OUT"

echo '<div class="section-band" id="corporate-strategy"><span class="badge">Strategy</span><h2>Corporate Positioning Strategy</h2><p class="band-sub">Brand position, differentiation, and channel approach</p></div>' >> "$OUT"
echo '<section class="doc-section">' >> "$OUT"
python3 -c "
import re
with open('$SECTIONS/corporate-strategy.html') as f:
    html = f.read()
parts = re.split(r'<h1[^>]*>', html)
headers = re.findall(r'<h1[^>]*>(.*?)</h1>', html)
found = False
for i, header in enumerate(headers):
    if 'Positioning' in header or 'Marketing' in header or 'SECTION B' in header:
        content = parts[i+1] if i+1 < len(parts) else ''
        content = re.split(r'</h1>', content, 1)[-1] if '</h1>' in content else content
        print(content)
        found = True
        break
if not found:
    # Just grab second half
    mid = len(html) // 2
    print(html[mid:])
" >> "$OUT" 2>/dev/null
echo '</section>' >> "$OUT"

# ---- Employer ----
echo '<div class="section-band" id="employer-wireframe"><span class="badge">ICP #1 — Employer</span><h2>Employer Landing Page Wireframe</h2><p class="band-sub">Page structure based on existing homepage</p></div>' >> "$OUT"
echo '<section class="doc-section">' >> "$OUT"
python3 -c "
import re
with open('$SECTIONS/employer-deliverables.html') as f:
    html = f.read()
parts = re.split(r'<h1[^>]*>', html)
headers = re.findall(r'<h1[^>]*>(.*?)</h1>', html)
for i, header in enumerate(headers):
    if 'Wireframe' in header or 'SECTION A' in header or 'Landing Page' in header:
        content = parts[i+1] if i+1 < len(parts) else ''
        content = re.split(r'</h1>', content, 1)[-1] if '</h1>' in content else content
        next_h1 = re.search(r'<h1', content)
        if next_h1:
            content = content[:next_h1.start()]
        print(content)
        break
" >> "$OUT" 2>/dev/null || head -400 "$SECTIONS/employer-deliverables.html" >> "$OUT"
echo '</section>' >> "$OUT"

echo '<div class="section-band" id="employer-marketing"><span class="badge">ICP #1 — Employer</span><h2>Employer Marketing Strategy</h2><p class="band-sub">Funnels, lead magnets, email sequences, and KPIs</p></div>' >> "$OUT"
echo '<section class="doc-section">' >> "$OUT"
python3 -c "
import re
with open('$SECTIONS/employer-deliverables.html') as f:
    html = f.read()
parts = re.split(r'<h1[^>]*>', html)
headers = re.findall(r'<h1[^>]*>(.*?)</h1>', html)
for i, header in enumerate(headers):
    if 'Marketing' in header or 'SECTION B' in header:
        content = parts[i+1] if i+1 < len(parts) else ''
        content = re.split(r'</h1>', content, 1)[-1] if '</h1>' in content else content
        print(content)
        break
" >> "$OUT" 2>/dev/null
echo '</section>' >> "$OUT"

# ---- Broker ----
echo '<div class="section-band" id="broker-landing"><span class="badge">ICP #2 — Broker</span><h2>Broker Landing Page Copy</h2><p class="band-sub">Conversion-focused copy for the broker persona</p></div>' >> "$OUT"
echo '<section class="doc-section">' >> "$OUT"
python3 -c "
import re
with open('$SECTIONS/broker-deliverables.html') as f:
    html = f.read()
parts = re.split(r'<h1[^>]*>', html)
headers = re.findall(r'<h1[^>]*>(.*?)</h1>', html)
for i, header in enumerate(headers):
    if ('Landing' in header and 'Copy' in header) or 'SECTION A' in header:
        content = parts[i+1] if i+1 < len(parts) else ''
        content = re.split(r'</h1>', content, 1)[-1] if '</h1>' in content else content
        next_h1 = re.search(r'<h1', content)
        if next_h1: content = content[:next_h1.start()]
        print(content)
        break
" >> "$OUT" 2>/dev/null || head -500 "$SECTIONS/broker-deliverables.html" >> "$OUT"
echo '</section>' >> "$OUT"

echo '<div class="section-band" id="broker-wireframe"><span class="badge">ICP #2 — Broker</span><h2>Broker Wireframe</h2><p class="band-sub">Visual page layout for the broker landing page</p></div>' >> "$OUT"
echo '<section class="doc-section">' >> "$OUT"
python3 -c "
import re
with open('$SECTIONS/broker-deliverables.html') as f:
    html = f.read()
parts = re.split(r'<h1[^>]*>', html)
headers = re.findall(r'<h1[^>]*>(.*?)</h1>', html)
for i, header in enumerate(headers):
    if 'Wireframe' in header or 'SECTION B' in header:
        content = parts[i+1] if i+1 < len(parts) else ''
        content = re.split(r'</h1>', content, 1)[-1] if '</h1>' in content else content
        next_h1 = re.search(r'<h1', content)
        if next_h1: content = content[:next_h1.start()]
        print(content)
        break
" >> "$OUT" 2>/dev/null
echo '</section>' >> "$OUT"

echo '<div class="section-band" id="broker-marketing"><span class="badge">ICP #2 — Broker</span><h2>Broker Marketing Strategy</h2><p class="band-sub">Funnels, outreach, sales enablement, and KPIs</p></div>' >> "$OUT"
echo '<section class="doc-section">' >> "$OUT"
python3 -c "
import re
with open('$SECTIONS/broker-deliverables.html') as f:
    html = f.read()
parts = re.split(r'<h1[^>]*>', html)
headers = re.findall(r'<h1[^>]*>(.*?)</h1>', html)
for i, header in enumerate(headers):
    if 'Marketing' in header or 'SECTION C' in header:
        content = parts[i+1] if i+1 < len(parts) else ''
        content = re.split(r'</h1>', content, 1)[-1] if '</h1>' in content else content
        print(content)
        break
" >> "$OUT" 2>/dev/null
echo '</section>' >> "$OUT"

# ---- Physician ----
echo '<div class="section-band" id="physician-landing"><span class="badge">ICP #3 — Physician</span><h2>Physician Landing Page Copy</h2><p class="band-sub">Conversion-focused copy for the physician persona</p></div>' >> "$OUT"
echo '<section class="doc-section">' >> "$OUT"
python3 -c "
import re
with open('$SECTIONS/physician-deliverables.html') as f:
    html = f.read()
parts = re.split(r'<h1[^>]*>', html)
headers = re.findall(r'<h1[^>]*>(.*?)</h1>', html)
for i, header in enumerate(headers):
    if ('Landing' in header and 'Copy' in header) or 'SECTION A' in header:
        content = parts[i+1] if i+1 < len(parts) else ''
        content = re.split(r'</h1>', content, 1)[-1] if '</h1>' in content else content
        next_h1 = re.search(r'<h1', content)
        if next_h1: content = content[:next_h1.start()]
        print(content)
        break
" >> "$OUT" 2>/dev/null || head -300 "$SECTIONS/physician-deliverables.html" >> "$OUT"
echo '</section>' >> "$OUT"

echo '<div class="section-band" id="physician-wireframe"><span class="badge">ICP #3 — Physician</span><h2>Physician Wireframe</h2><p class="band-sub">Visual page layout for the physician landing page</p></div>' >> "$OUT"
echo '<section class="doc-section">' >> "$OUT"
python3 -c "
import re
with open('$SECTIONS/physician-deliverables.html') as f:
    html = f.read()
parts = re.split(r'<h1[^>]*>', html)
headers = re.findall(r'<h1[^>]*>(.*?)</h1>', html)
for i, header in enumerate(headers):
    if 'Wireframe' in header or 'SECTION B' in header:
        content = parts[i+1] if i+1 < len(parts) else ''
        content = re.split(r'</h1>', content, 1)[-1] if '</h1>' in content else content
        next_h1 = re.search(r'<h1', content)
        if next_h1: content = content[:next_h1.start()]
        print(content)
        break
" >> "$OUT" 2>/dev/null
echo '</section>' >> "$OUT"

echo '<div class="section-band" id="physician-marketing"><span class="badge">ICP #3 — Physician</span><h2>Physician Recruitment Strategy</h2><p class="band-sub">Network recruitment, outreach, and onboarding</p></div>' >> "$OUT"
echo '<section class="doc-section">' >> "$OUT"
python3 -c "
import re
with open('$SECTIONS/physician-deliverables.html') as f:
    html = f.read()
parts = re.split(r'<h1[^>]*>', html)
headers = re.findall(r'<h1[^>]*>(.*?)</h1>', html)
for i, header in enumerate(headers):
    if 'Marketing' in header or 'Recruitment' in header or 'SECTION C' in header:
        content = parts[i+1] if i+1 < len(parts) else ''
        content = re.split(r'</h1>', content, 1)[-1] if '</h1>' in content else content
        print(content)
        break
" >> "$OUT" 2>/dev/null
echo '</section>' >> "$OUT"

# ---- Employee ----
echo '<div class="section-band" id="employee-landing"><span class="badge">ICP #4 — Employee</span><h2>Employee Experience Page Copy</h2><p class="band-sub">Onboarding and welcome page for employees</p></div>' >> "$OUT"
echo '<section class="doc-section">' >> "$OUT"
python3 -c "
import re
with open('$SECTIONS/employee-deliverables.html') as f:
    html = f.read()
parts = re.split(r'<h1[^>]*>', html)
headers = re.findall(r'<h1[^>]*>(.*?)</h1>', html)
for i, header in enumerate(headers):
    if ('Landing' in header and 'Copy' in header) or 'SECTION A' in header:
        content = parts[i+1] if i+1 < len(parts) else ''
        content = re.split(r'</h1>', content, 1)[-1] if '</h1>' in content else content
        next_h1 = re.search(r'<h1', content)
        if next_h1: content = content[:next_h1.start()]
        print(content)
        break
" >> "$OUT" 2>/dev/null || head -300 "$SECTIONS/employee-deliverables.html" >> "$OUT"
echo '</section>' >> "$OUT"

echo '<div class="section-band" id="employee-wireframe"><span class="badge">ICP #4 — Employee</span><h2>Employee Page Wireframe</h2><p class="band-sub">Visual page layout for the employee experience page</p></div>' >> "$OUT"
echo '<section class="doc-section">' >> "$OUT"
python3 -c "
import re
with open('$SECTIONS/employee-deliverables.html') as f:
    html = f.read()
parts = re.split(r'<h1[^>]*>', html)
headers = re.findall(r'<h1[^>]*>(.*?)</h1>', html)
for i, header in enumerate(headers):
    if 'Wireframe' in header or 'SECTION B' in header:
        content = parts[i+1] if i+1 < len(parts) else ''
        content = re.split(r'</h1>', content, 1)[-1] if '</h1>' in content else content
        next_h1 = re.search(r'<h1', content)
        if next_h1: content = content[:next_h1.start()]
        print(content)
        break
" >> "$OUT" 2>/dev/null
echo '</section>' >> "$OUT"

echo '<div class="section-band" id="employee-engagement"><span class="badge">ICP #4 — Employee</span><h2>Employee Engagement Strategy</h2><p class="band-sub">Activation, onboarding, and adoption tactics</p></div>' >> "$OUT"
echo '<section class="doc-section">' >> "$OUT"
python3 -c "
import re
with open('$SECTIONS/employee-deliverables.html') as f:
    html = f.read()
parts = re.split(r'<h1[^>]*>', html)
headers = re.findall(r'<h1[^>]*>(.*?)</h1>', html)
for i, header in enumerate(headers):
    if 'Engagement' in header or 'Activation' in header or 'SECTION C' in header:
        content = parts[i+1] if i+1 < len(parts) else ''
        content = re.split(r'</h1>', content, 1)[-1] if '</h1>' in content else content
        print(content)
        break
" >> "$OUT" 2>/dev/null
echo '</section>' >> "$OUT"

# ---- Implementation Roadmap ----
echo '<div class="section-band" id="asset-inventory"><span class="badge">Implementation</span><h2>Asset Inventory</h2><p class="band-sub">Complete collateral list for the Augusta pilot launch</p></div>' >> "$OUT"
echo '<section class="doc-section">' >> "$OUT"
python3 -c "
import re
with open('$SECTIONS/implementation-roadmap.html') as f:
    html = f.read()
parts = re.split(r'<h1[^>]*>', html)
headers = re.findall(r'<h1[^>]*>(.*?)</h1>', html)
for i, header in enumerate(headers):
    if 'Asset' in header or 'Inventory' in header or 'SECTION A' in header:
        content = parts[i+1] if i+1 < len(parts) else ''
        content = re.split(r'</h1>', content, 1)[-1] if '</h1>' in content else content
        next_h1 = re.search(r'<h1', content)
        if next_h1: content = content[:next_h1.start()]
        print(content)
        break
" >> "$OUT" 2>/dev/null || head -500 "$SECTIONS/implementation-roadmap.html" >> "$OUT"
echo '</section>' >> "$OUT"

echo '<div class="section-band" id="technical-scope"><span class="badge">Implementation</span><h2>Technical Scope</h2><p class="band-sub">Digital infrastructure requirements</p></div>' >> "$OUT"
echo '<section class="doc-section">' >> "$OUT"
python3 -c "
import re
with open('$SECTIONS/implementation-roadmap.html') as f:
    html = f.read()
parts = re.split(r'<h1[^>]*>', html)
headers = re.findall(r'<h1[^>]*>(.*?)</h1>', html)
for i, header in enumerate(headers):
    if 'Technical' in header or 'SECTION B' in header:
        content = parts[i+1] if i+1 < len(parts) else ''
        content = re.split(r'</h1>', content, 1)[-1] if '</h1>' in content else content
        next_h1 = re.search(r'<h1', content)
        if next_h1: content = content[:next_h1.start()]
        print(content)
        break
" >> "$OUT" 2>/dev/null
echo '</section>' >> "$OUT"

echo '<div class="section-band" id="timeline-budget"><span class="badge">Implementation</span><h2>Project Timeline & Budget</h2><p class="band-sub">Phased delivery plan from February through December 2026</p></div>' >> "$OUT"
echo '<section class="doc-section">' >> "$OUT"
python3 -c "
import re
with open('$SECTIONS/implementation-roadmap.html') as f:
    html = f.read()
parts = re.split(r'<h1[^>]*>', html)
headers = re.findall(r'<h1[^>]*>(.*?)</h1>', html)
for i, header in enumerate(headers):
    if 'Timeline' in header or 'Budget' in header or 'SECTION C' in header:
        content = parts[i+1] if i+1 < len(parts) else ''
        content = re.split(r'</h1>', content, 1)[-1] if '</h1>' in content else content
        print(content)
        break
" >> "$OUT" 2>/dev/null
echo '</section>' >> "$OUT"

# ---- FOOTER ----
cat >> "$OUT" << 'FOOTER'

</main>

<button class="back-to-top" id="backToTop" onclick="window.scrollTo({top:0})">&#8593;</button>

<script>
function toggleMobileMenu(){document.getElementById('mobileMenu').classList.toggle('open')}
function closeMobileMenu(){document.getElementById('mobileMenu').classList.remove('open')}

var sections=document.querySelectorAll('section[id],.section-band[id]');
var navLinks=document.querySelectorAll('.sidebar nav a');
var tocObserver=new IntersectionObserver(function(entries){entries.forEach(function(entry){if(entry.isIntersecting){navLinks.forEach(function(link){link.classList.remove('active')});var active=document.querySelector('.sidebar nav a[href="#'+entry.target.id+'"]');if(active)active.classList.add('active')}})},{rootMargin:'-20% 0px -70% 0px'});
sections.forEach(function(s){tocObserver.observe(s)});

window.addEventListener('scroll',function(){var btn=document.getElementById('backToTop');if(window.scrollY>600){btn.classList.add('visible')}else{btn.classList.remove('visible')}});
</script>
</body>
</html>
FOOTER

echo "Build complete: $(wc -l < "$OUT") lines"
