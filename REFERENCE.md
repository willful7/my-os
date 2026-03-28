# My OS — PWA Reference Document
**Build date:** March 2026  
**Status:** Working — syncs across iOS, iPad, and desktop  
**Live URL:** https://willful7.github.io/my-os/

---

## What this app is

A personal operating system built as a Progressive Web App. Single HTML file. No frameworks. Runs on iPhone, iPad, and desktop browser. Syncs across all devices via Supabase.

---

## File inventory

| File | Purpose |
|---|---|
| `index.html` | The entire app — HTML, CSS, and JS in one file |
| `sw.js` | Service worker (currently set to unregister/clear cache on load) |
| `manifest.json` | PWA metadata — name, icons, display mode |
| `schema.sql` | Supabase table setup — run once in SQL Editor |
| `icons/icon-192.png` | App icon (purple W, 192×192) |
| `icons/icon-512.png` | App icon (purple W, 512×512) |
| `README.md` | Setup and deployment instructions |
| `REFERENCE.md` | This file |

---

## Infrastructure

### Hosting
- **GitHub Pages** — free, auto-deploys on commit
- Repo: `https://github.com/willful7/my-os`
- Branch: `main`, root directory

### Database
- **Supabase** — free tier, hosted Postgres
- Project: `qciitzsmtsrotkpkldkf`
- URL: `https://qciitzsmtsrotkpkldkf.supabase.co`
- Anon key: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFjaWl0enNtdHNyb3RrcGtsZGtmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQ0NzIzODMsImV4cCI6MjA5MDA0ODM4M30.WGlX50TVBerWyMTJK1xwVs55lmhseqBwIrcNXOTHtp4`

---

## Supabase tables

### `habit_logs`
Stores daily habit completions. One row per day.
```
id          uuid (PK)
date        text  — "2026-03-25" (unique)
log         jsonb — {"bible": true, "lift": false, ...}
updated_at  timestamptz
```

### `app_state`
Stores task completions, this-week flags, and Big 3 done states. One row per key.
```
id          uuid (PK)
key         text  — "task_done" | "thisweek" | "big3" (unique)
value       jsonb — {task_id: true/false, ...}
updated_at  timestamptz
```

---

## App structure

### Navigation tabs

| Tab | Screen ID | Description |
|---|---|---|
| Today | `screen-today` | Daily habit check-in — main screen |
| Week | `screen-week` | Habit grid, day-by-day scores, Big 3 progress |
| Projects | `screen-projects` | Role-grouped project cards with task lists |
| Plan | `screen-plan` | Not yet built — coming next |

### Today screen (top to bottom)
1. Header — greeting, date, 4 stat chips (done today, best streak, week score, quarter)
2. This Week's Big 3 — 3 weekly commitments, set each Friday
3. Habit sections — collapsible by category (Faith, Workout, Relationships, Self, Health)
4. This Week's Focus — project tasks flagged for this week (hidden when empty)

### Week screen
- Week navigator with full date range (e.g. "Week of Mar 23 – Mar 29")
- 3 stat chips: week score, habits done, vs last week
- Habit grid — all habits × 7 days, tappable dots
- Big 3 progress bars
- Day-by-day score strip (green ≥80%, amber ≥50%, red <50%)

### Projects screen
- Filter chips: All, Work, Self, Life, Active, Done
- Role groups: Work Projects, Self Projects, Life Maintenance
- Each project: expandable card, progress bar, task list, this-week toggles, add task input

---

## Data flow

### Sync strategy (background sync pattern)
1. App renders **immediately** from localStorage on load — no waiting
2. Supabase fetch runs **in background**
3. When Supabase responds, app **re-renders** with fresh data
4. Sync dot shows: gray (local only) → amber (syncing) → green (synced) → red (error)

### What syncs to Supabase
- `habit_logs` — every habit checkbox tap
- `app_state:task_done` — every task completion tap (Projects or Focus)
- `app_state:thisweek` — every This Week toggle tap
- `app_state:big3` — every Big 3 checkbox tap

### What stays local only
- Section collapse/expand state
- Project card collapse/expand state
- New tasks added via "Add task…" sync to Supabase under custom-tasks-{projId} keys

---

## CONFIG block (in index.html)

The `CONFIG` object at the top of the script section controls everything user-facing. Edit here to customize:

```js
const CONFIG = {
  name: "Will",               // Your name — used in greeting

  big3: [                     // Update every Friday for next week
    { id: "b1", text: "..." },
    { id: "b2", text: "..." },
    { id: "b3", text: "..." },
  ],

  projects: [                 // Your projects
    {
      id: "unique-id",        // Never change once set — used as storage key
      name: "Project name",
      role: "work",           // "work" | "self" | "life"
      status: "active",       // "active" | "paused" | "done" | "deck"
      meta: "Goal: ... · Date",
      color: "#185FA5",       // Accent color
      colorLight: "#E6F1FB",  // Light version for backgrounds
      collapsed: false,       // Default collapsed state
      tasks: [
        { id: "t1", text: "Task name", done: false, due: "Apr" },
      ]
    },
  ],

  sections: [                 // Habit sections
    {
      id: "faith",
      name: "Faith",
      color: "#534AB7",
      colorLight: "#EEEDFE",
      collapsed: false,
      habits: [
        { id: "bible", name: "Bible reading", streak: 5 },
      ]
    },
  ]
};
```

### Important: ID stability
Task and habit `id` values are used as localStorage keys and Supabase keys. **Never change an existing ID** — doing so loses all history for that item. Only change `text`, `name`, `due`, `status`, etc.

---

## Section / habit colors

| Section | Color | Light |
|---|---|---|
| Faith | `#534AB7` | `#EEEDFE` |
| Workout | `#1D9E75` | `#E1F5EE` |
| Relationships | `#D4537E` | `#FBEAF0` |
| Self | `#BA7517` | `#FAEEDA` |
| Health | `#378ADD` | `#E6F1FB` |
| Work projects | `#185FA5` | `#E6F1FB` |
| Life projects | `#5F5E5A` | `#F1EFE8` |

---

## Weekly ritual (how to use the system)

### Every morning (~4am)
1. Open app from home screen
2. Check off today's habits as you do them
3. Review Focus tasks — check off anything completed

### During the day
- Check off Focus tasks as you complete project work
- Add tasks to projects via "Add task…" as things come up

### Friday weekly review (~15–20 min)
1. Open Week tab — review day-by-day scores honestly
2. Open Plan tab (when built) or review goals mentally
3. Go to Projects — toggle This Week on/off for next week's tasks
4. Update Big 3 in the CONFIG for next week, commit to GitHub
5. Note what went well and what got bumped

---

## How to update the app

### Minor text changes (habits, Big 3, project tasks)
1. Go to `github.com/willful7/my-os`
2. Click `index.html` → pencil icon
3. Edit the `CONFIG` block
4. Scroll down → Commit changes
5. Wait 30 seconds → reload app

### Code changes (new features, bug fixes)
1. Download updated `index.html` from Claude
2. Verify Supabase credentials are present (they should be auto-injected)
3. Upload to GitHub → replace existing file → commit
4. Wait 30 seconds → reload

---

## Known issues / limitations

- New tasks added via "Add task…" persist to localStorage and Supabase, syncing across all devices.
- Streak counts are calculated live from habit_log history (up to 365 days back). Supabase loads last 30 days on sync so all devices have accurate streaks.
- All habit and project edits (names, order, due labels, status, new items) persist to Supabase and sync across devices.
- Big 3 text is stored per week in app_state table with key `big3-text-YYYY-WNN`.
- Plan tab not yet built.

---

## Build history

| Version | What was added |
|---|---|
| v0.1 | Today screen, habits, Big 3, localStorage, GitHub Pages |
| v0.2 | Supabase sync for habit logs, green sync dot |
| v0.3 | Week view — habit grid, day scores, vs last week comparison |
| v0.4 | Projects tab — role groups, task lists, progress bars, filter chips |
| v0.5 | This Week toggles, Focus section on Today, cross-platform sync for task/thisweek/big3 states |
| v0.5.1 | Background sync pattern (render first, sync second) — fixes iOS loading |
| v0.5.2 | Section reorder (Big 3 → Habits → Focus), week label shows full date range |
| v0.6 | In-app Big 3 editing — set weekly commitments without touching code, syncs to Supabase |
| v0.7 | Persistent new tasks — tasks added via "Add task…" survive reload and sync across devices |
| v0.7.1 | Fix: custom tasks now appear in This Week's Focus when toggled from Projects tab |
| v0.8 | Auto-calculated streaks from real habit log history, loads 30 days from Supabase on sync |
| v0.8.1 | Fix: Today screen re-renders on every tab switch, streaks always current |
| v0.9 | Full habit management — add/delete/rename/reorder habits, add/delete sections, all synced |
| v0.9.1 | Project task management — delete tasks, edit task text/due labels unlimited times |
| v0.9.2 | Task reordering with up/down arrows, project status cycling, iOS overflow fixes |

---

## Next planned sprints

1. **Plan tab** — quarterly goals, deep work blocks, ideal week template, mission/roles
1. **Plan tab** — quarterly goals, ideal week template, mission/roles
2. **Weekly review prompt** — Friday notification/reminder to do the review
