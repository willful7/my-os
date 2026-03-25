# my-os
NOW app
My Personal OS — PWA
A personal habit tracker and life operating system.
Built as a Progressive Web App — works on iPhone, iPad, and desktop.
---
Quick start (no backend needed)
Open `index.html` in a browser — it works immediately with localStorage.
Edit the `CONFIG` block at the bottom of `index.html`:
Change `name` to yours
Update `big3` with this week's commitments
Add/remove habits in `sections`
Save and reload.
That's it. No install, no account, no server.
---
Add to iPhone home screen
Host the files anywhere — the easiest free options:
GitHub Pages: push to a repo, enable Pages in settings
Netlify: drag the folder to netlify.com/drop
Open the URL in Safari on your iPhone
Tap the Share button → "Add to Home Screen"
Name it and tap Add
It will appear as a full-screen app icon with no browser chrome.
---
Wire up Supabase (cross-device sync)
Go to supabase.com → New project (free)
In your project: SQL Editor → paste and run `schema.sql`
Go to Settings → API — copy your Project URL and anon key
In `index.html`, paste them:
```js
   const SUPABASE_URL = "https://your-project.supabase.co";
   const SUPABASE_KEY = "your-anon-key";
   const USE_SUPABASE = true;   // flip this to true
   ```
Deploy and reload — you now have real-time cross-device sync.
The sync dot in the top-right shows status:
Gray = local only
Amber = syncing
Green = synced
Red = error (probably offline)
---
File structure
```
pwa-os/
├── index.html      ← The entire app (edit CONFIG here)
├── sw.js           ← Service worker (offline support)
├── manifest.json   ← PWA install metadata
├── schema.sql      ← Supabase table setup
├── icons/
│   ├── icon-192.png  ← App icon (create these)
│   └── icon-512.png
└── README.md
```
---
Make your own icon
Create two square PNG images (192×192 and 512×512) and put them in an `icons/` folder.
Use your initials, a simple shape, or generate one at favicon.io.
---
V1 roadmap (what's built)
[x] Today screen — habit check-in with sections
[x] Big 3 weekly commitments
[x] Streak display
[x] Stats (done today, best streak, week score)
[x] Offline support via service worker
[x] localStorage persistence (works without backend)
[x] Supabase sync (enable with USE_SUPABASE = true)
[x] Midnight auto-reset
V2 ideas (next sprints)
[ ] Week view — habit grid with day-by-day scores
[ ] Projects tab — task lists by role
[ ] Plan tab — quarterly goals + ideal week template
[ ] Weekly review prompt (Friday notification)
[ ] Export to JSON / email backup
[ ] Push notifications via web push API
[ ] iCal feed for deep work blocks
---
Customizing habits
Edit the `CONFIG.sections` array in `index.html`:
```js
{
  id: "myrole",           // unique ID, no spaces
  name: "My Role",        // display name
  color: "#534AB7",       // accent color (hex)
  colorLight: "#EEEDFE",  // light version (for backgrounds)
  collapsed: false,       // start open or closed
  habits: [
    { id: "habit1", name: "My habit", streak: 0 },
  ]
}
```
Habit IDs become the keys in the daily log — keep them short and stable.
If you change an ID, that habit's history resets.
