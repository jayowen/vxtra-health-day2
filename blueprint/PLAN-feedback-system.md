# Plan: Section-Level Feedback System for Blueprint

**Status:** Planned — come back to implement later

## Context

Larry (non-technical CEO, age 75) needs to review the Vxtra Health blueprint and leave section-by-section feedback for Jay. The blueprint and all supporting files will be hosted on a server (GitHub Pages or Railway), so we can use `fetch()` and server-side features if needed.

## Hosting Advantage

Since files are server-hosted (not `file://`), we gain:
- **Email delivery** — Use a form service (Formspree, EmailJS, or a simple Railway endpoint) to send feedback directly to jay@businessbldrs.com without Larry needing to copy/paste
- **Shared state** — Could store feedback server-side so Jay sees it in real-time (optional, adds complexity)
- **No CORS issues** — Can fetch external resources if needed

**Recommended approach:** Keep it client-side with localStorage for persistence, but add a **one-click "Send to Jay" button** that POSTs feedback to a lightweight email service (Formspree free tier or similar). Larry clicks one button, Jay gets an email. Zero friction.

## Approach

Add a lightweight feedback system directly into `vxtra-health-blueprint.html` — CSS (~100 lines), JS (~200 lines), and a feedback badge on each of the 10 section headers. No external dependencies beyond optional email delivery endpoint.

### File to modify

`blueprint/vxtra-health-blueprint.html` — all changes are in this single file.

## UX Flow (Larry's perspective)

1. Opens blueprint, scrolls through it
2. Each section header (dark blue band) has a small **"Add Feedback"** button in the top-right
3. Clicks it → simple modal opens with section name and a textarea
4. Types feedback, clicks **"Save Feedback"** → modal closes
5. Badge updates to **"1 comment"** with teal highlight; inline confirmation appears below the header
6. Repeats for other sections
7. When done, clicks floating **"Review & Send"** coral button (bottom-right, appears after first comment)
8. Review modal shows all comments in one view
9. Clicks **"Send to Jay"** → feedback emailed directly to jay@businessbldrs.com
10. Confirmation: "Feedback sent!" (Copy to clipboard available as fallback)

**3 clicks to leave feedback. 3 clicks to send.**

## Implementation Details

### 1. CSS additions (~100 lines, append after `.badge-done`)

| Class | Purpose |
|-------|---------|
| `.feedback-badge` | Pill button, absolute top-right of each `.section-band`, semi-transparent white on dark |
| `.feedback-badge.has-feedback` | Teal-tinted when comment exists |
| `.feedback-inline` | Teal left-bordered confirmation bar below section header |
| `.feedback-overlay` | Fixed full-screen dark overlay (z-index: 200) |
| `.feedback-modal` | Centered white card (max-width: 540px) with textarea |
| `.feedback-review-btn` | Fixed bottom-right coral pill button, hidden until feedback exists |
| Print/mobile rules | Hide all feedback UI in print; adjust positioning for mobile |

Also add `position: relative` to `.section-band` (needed for absolute badge positioning).

### 2. HTML additions (10 badges)

Add a feedback badge button inside each `.section-band[id]` div. The 10 sections:

- `#cover`, `#summary`, `#employer`, `#broker`, `#physician`, `#employee`, `#website`, `#audiences`, `#assets`, `#next-steps`

Each gets:
```html
<button class="feedback-badge" data-section="employer" onclick="BlueprintFeedback.openModal('employer')">
  <span class="feedback-label">Add Feedback</span>
</button>
```

Also add static elements at end of `<body>`:
- Modal overlay div (single shared modal, content swapped per section)
- Floating "Review & Send" button

### 3. JavaScript additions (~200 lines, append to existing `<script>`)

`BlueprintFeedback` object with:

| Method | Purpose |
|--------|---------|
| `init()` | Load localStorage, update all badges, bind ESC key |
| `openModal(sectionId)` | Show modal with section name, load existing text |
| `closeModal()` | Hide modal |
| `save()` | Save textarea to localStorage, update badge, show inline confirmation |
| `deleteFeedback(sectionId)` | Remove from localStorage, reset badge |
| `openReview()` | Show summary modal with all comments |
| `copyAll()` | Format all feedback as text, copy to clipboard (fallback) |
| `sendToJay()` | POST formatted feedback to email service → jay@businessbldrs.com |

**localStorage key:** `vxtra_blueprint_feedback`
**Data shape:** `{ "employer": { "text": "...", "ts": "2026-02-14T..." }, ... }`

### 4. Section name mapping

```
cover → "Cover Page"
summary → "Executive Summary"
employer → "The Employer"
broker → "The Broker"
physician → "The Physician"
employee → "The Employee"
website → "Website Concept"
audiences → "Audience Pages Preview"
assets → "Asset Inventory"
next-steps → "Next Steps"
```

### 5. Formatted output (what gets copied/emailed)

```
Vxtra Health Blueprint — Feedback
Date: February 14, 2026

──────────────────────────────────
The Employer
──────────────────────────────────
[Larry's comment text]

──────────────────────────────────
The Broker
──────────────────────────────────
[Larry's comment text]
```

## Key Design Decisions

- **Always-visible badges** (no hover/toggle) — Larry shouldn't have to discover a hidden feature
- **Plain textarea** (no rich text) — less to break
- **One comment per section** (not threaded) — simpler mental model
- **One-click send** — POST to email service (Formspree/EmailJS) so Larry just clicks "Send to Jay" and it's done. Copy to clipboard as fallback.
- **localStorage persistence** — Larry can close and come back later
- **Emoji-free** — matches the professional blueprint aesthetic
- **z-index: 200** for modal — above sidebar (100) and everything else

## Verification

1. Open `blueprint/vxtra-health-blueprint.html` in browser
2. Confirm "Add Feedback" badges visible on all 10 section headers
3. Click a badge → modal opens with correct section name, textarea focused
4. Type text, click Save → modal closes, badge shows "1 comment", inline bar appears
5. Click badge again → modal opens with existing text, "Update Feedback" button
6. Delete feedback → badge resets to "Add Feedback"
7. Add feedback to 3+ sections → floating coral "Review & Send" button appears
8. Click review button → summary shows all comments
9. Click "Send to Jay" → verify email arrives at jay@businessbldrs.com
10. Close browser, reopen file → all feedback persists
11. Test on mobile viewport → badges and modal still functional
12. Print preview → no feedback UI visible
