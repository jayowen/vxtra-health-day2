import re, os

SECTIONS_DIR = "/Users/jayowen/projects/vxtra-health/blueprint/sections"

def split_html_sections(filepath):
    """Split an HTML file into sections based on h2 tags."""
    with open(filepath) as f:
        html = f.read()
    # Split on h2 tags, keeping the delimiter
    parts = re.split(r'(<h2[^>]*>.*?</h2>)', html)
    sections = {}
    current_key = "_preamble"
    current_content = ""
    for part in parts:
        h2_match = re.match(r'<h2[^>]*>(.*?)</h2>', part)
        if h2_match:
            if current_content.strip():
                sections[current_key] = current_content
            current_key = h2_match.group(1)
            current_content = ""
        else:
            current_content += part
    if current_content.strip():
        sections[current_key] = current_content
    return sections

# Define section mapping: (source_file, section_key_contains, band_id, badge, title, subtitle)
section_map = [
    ("corporate-strategy.html", "SECTION A", "site-architecture", "Strategy", "Site Architecture", "How the Vxtra Health website is structured"),
    ("corporate-strategy.html", "SECTION B", "corporate-strategy", "Strategy", "Corporate Positioning Strategy", "Brand position, differentiation, and channel approach"),
    ("employer-deliverables.html", "SECTION A", "employer-wireframe", "ICP #1 — Employer", "Employer Landing Page Wireframe", "Page structure based on existing homepage"),
    ("employer-deliverables.html", "SECTION B", "employer-marketing", "ICP #1 — Employer", "Employer Marketing Strategy", "Funnels, lead magnets, email sequences, and KPIs"),
    ("broker-deliverables.html", "SECTION A", "broker-landing", "ICP #2 — Broker", "Broker Landing Page Copy", "Conversion-focused copy for the broker persona"),
    ("broker-deliverables.html", "SECTION B", "broker-wireframe", "ICP #2 — Broker", "Broker Wireframe", "Visual page layout for the broker landing page"),
    ("broker-deliverables.html", "SECTION C", "broker-marketing", "ICP #2 — Broker", "Broker Marketing Strategy", "Funnels, outreach, sales enablement, and KPIs"),
    ("physician-deliverables.html", "SECTION A", "physician-landing", "ICP #3 — Physician", "Physician Landing Page Copy", "Conversion-focused copy for the physician persona"),
    ("physician-deliverables.html", "SECTION B", "physician-wireframe", "ICP #3 — Physician", "Physician Wireframe", "Visual page layout for the physician landing page"),
    ("physician-deliverables.html", "SECTION C", "physician-marketing", "ICP #3 — Physician", "Physician Recruitment Strategy", "Network recruitment, outreach, and onboarding"),
    ("employee-deliverables.html", "SECTION A", "employee-landing", "ICP #4 — Employee", "Employee Experience Page Copy", "Onboarding and welcome page for employees"),
    ("employee-deliverables.html", "SECTION B", "employee-wireframe", "ICP #4 — Employee", "Employee Page Wireframe", "Visual page layout for the employee experience page"),
    ("employee-deliverables.html", "SECTION C", "employee-engagement", "ICP #4 — Employee", "Employee Engagement Strategy", "Activation, onboarding, and adoption tactics"),
    ("implementation-roadmap.html", "Section A", "asset-inventory", "Implementation", "Asset Inventory", "Complete collateral list for the Augusta pilot launch"),
    ("implementation-roadmap.html", "Section B", "technical-scope", "Implementation", "Technical Scope", "Digital infrastructure requirements"),
    ("implementation-roadmap.html", "Section C", "timeline-budget", "Implementation", "Project Timeline &amp; Budget", "Phased delivery plan through December 2026"),
]

# Cache parsed files
cache = {}
output_sections = []

for src_file, key_contains, band_id, badge, title, subtitle in section_map:
    filepath = os.path.join(SECTIONS_DIR, src_file)
    if filepath not in cache:
        cache[filepath] = split_html_sections(filepath)
    
    sections = cache[filepath]
    content = ""
    for key, val in sections.items():
        if key_contains in key:
            content = val
            break
    
    if not content:
        content = f"<p><em>Content pending — see {src_file} for details.</em></p>"
    
    output_sections.append(f'''
<div class="section-band" id="{band_id}">
  <span class="badge">{badge}</span>
  <h2>{title}</h2>
  <p class="band-sub">{subtitle}</p>
</div>
<section class="doc-section">
{content}
</section>
''')

# Write all sections to a single file
with open(os.path.join(SECTIONS_DIR, "all-sections.html"), "w") as f:
    for s in output_sections:
        f.write(s)

print(f"Assembled {len(output_sections)} sections")
lines = sum(s.count('\n') for s in output_sections)
print(f"Total lines: ~{lines}")
