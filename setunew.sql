-- Run this in Supabase: Database → SQL Editor → New query → paste → Run

-- Drop existing tables to start clean
drop table if exists reports cascade;
drop table if exists tech_names cascade;

-- Reports table: one row per store+type combination
create table reports (
  id            uuid default gen_random_uuid() primary key,
  store         text not null,
  report_type   text not null,
  data          jsonb not null,
  uploaded_at   timestamptz default now(),
  unique(store, report_type)
);

-- Tech name mappings
create table tech_names (
  initial   text primary key,
  full_name text not null,
  updated_at timestamptz default now()
);

-- Enable RLS
alter table reports enable row level security;
alter table tech_names enable row level security;

-- Allow everything from the anon key (dashboard + upload portal)
create policy "full access reports"    on reports    for all using (true) with check (true);
create policy "full access tech_names" on tech_names for all using (true) with check (true);
