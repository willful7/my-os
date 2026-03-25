-- ══════════════════════════════════════════════════════════════
-- My Personal OS — Supabase Schema
-- Run this in: supabase.com → your project → SQL Editor
-- ══════════════════════════════════════════════════════════════

-- 1. HABIT LOGS
-- One row per day. Stores the full completion map as JSON.
-- e.g. log = {"bible": true, "lift": true, "becky": false}

create table if not exists habit_logs (
  id          uuid default gen_random_uuid() primary key,
  date        text not null unique,       -- "2026-03-25"
  log         jsonb not null default '{}',
  updated_at  timestamptz default now()
);

-- Index for fast date lookups
create index if not exists habit_logs_date_idx on habit_logs(date);

-- 2. PROJECTS
create table if not exists projects (
  id          uuid default gen_random_uuid() primary key,
  name        text not null,
  role        text not null,              -- "work" | "self" | "life"
  status      text default 'active',      -- "active" | "paused" | "done" | "deck"
  goal        text,
  due_date    text,
  created_at  timestamptz default now(),
  updated_at  timestamptz default now()
);

-- 3. TASKS
create table if not exists tasks (
  id          uuid default gen_random_uuid() primary key,
  project_id  uuid references projects(id) on delete cascade,
  name        text not null,
  completed   boolean default false,
  due_label   text,                       -- "This week" | "Apr" | "Q2"
  sort_order  int default 0,
  created_at  timestamptz default now()
);

-- 4. WEEKLY PLANS (Big 3)
create table if not exists weekly_plans (
  id          uuid default gen_random_uuid() primary key,
  week_key    text not null unique,       -- "2026-W12"
  big3        jsonb default '[]',         -- [{id, text, role, done}]
  deep_blocks jsonb default '[]',         -- [{day, time, label, project_id}]
  created_at  timestamptz default now(),
  updated_at  timestamptz default now()
);

-- 5. QUARTERLY GOALS
create table if not exists quarterly_goals (
  id          uuid default gen_random_uuid() primary key,
  quarter     text not null,             -- "2026-Q1"
  role        text not null,
  name        text not null,
  target      text,
  progress    int default 0,             -- 0–100 percent
  created_at  timestamptz default now(),
  updated_at  timestamptz default now()
);

-- ── Row Level Security ─────────────────────────────────────────
-- Since this is a solo personal app, we keep it simple.
-- Enable RLS but allow all operations (you're the only user).
-- For extra security, add auth.uid() checks once you wire up login.

alter table habit_logs      enable row level security;
alter table projects        enable row level security;
alter table tasks           enable row level security;
alter table weekly_plans    enable row level security;
alter table quarterly_goals enable row level security;

-- Allow all operations (personal app, single user)
-- Replace these with auth-based policies once you add login
create policy "allow all" on habit_logs      for all using (true) with check (true);
create policy "allow all" on projects        for all using (true) with check (true);
create policy "allow all" on tasks           for all using (true) with check (true);
create policy "allow all" on weekly_plans    for all using (true) with check (true);
create policy "allow all" on quarterly_goals for all using (true) with check (true);

-- ── Sample data ────────────────────────────────────────────────
-- Uncomment to seed a few projects for testing

/*
insert into projects (name, role, status, goal, due_date) values
  ('InfoComm 2026 talk',     'work', 'active', 'Thought leadership', '2026-06'),
  ('AV Value Report tool',   'work', 'active', 'Ops excellence',     NULL),
  ('PMP certification',      'self', 'active', 'Career growth',      '2026-06'),
  ('Python 12-week path',    'self', 'paused', 'Maker skills',       '2026-Q2'),
  ('Living portrait concept','self', 'deck',   'Side income',        '2026-Q3');
*/
