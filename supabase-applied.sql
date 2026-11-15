-- This is what was already applied to your Supabase project "najimul-xmx-portfolio".
-- You do NOT need to run it again. Kept for reference / backup.
-- (The admin account itself was created separately; no password is stored in any file.)
create table if not exists public.pf_admins (email text primary key);
alter table public.pf_admins enable row level security;
insert into public.pf_admins (email) values ('najimnajim75598@gmail.com') on conflict do nothing;
create or replace function public.pf_is_admin() returns boolean language sql stable security definer set search_path = public, auth as $$
  select exists (select 1 from auth.users u join public.pf_admins a on lower(a.email)=lower(u.email) where u.id = auth.uid() and u.email_confirmed_at is not null);
$$;
grant execute on function public.pf_is_admin() to anon, authenticated;
create table if not exists public.pf_site_config (id int primary key default 1 check (id=1), data jsonb not null default '{}', updated_at timestamptz default now());
create table if not exists public.pf_projects (id uuid primary key default gen_random_uuid(), title text not null, status text, description text, tech text[] default '{}', demo_url text, github_url text, sort int default 0, created_at timestamptz default now());
create table if not exists public.pf_messages (id uuid primary key default gen_random_uuid(), name text not null check (char_length(name) between 1 and 120), email text not null check (char_length(email) between 3 and 200), message text not null check (char_length(message) between 1 and 3000), created_at timestamptz default now());
alter table public.pf_site_config enable row level security; alter table public.pf_projects enable row level security; alter table public.pf_messages enable row level security;
create policy "pf read config" on public.pf_site_config for select using (true);
create policy "pf admin config" on public.pf_site_config for all using (public.pf_is_admin()) with check (public.pf_is_admin());
create policy "pf read projects" on public.pf_projects for select using (true);
create policy "pf admin projects" on public.pf_projects for all using (public.pf_is_admin()) with check (public.pf_is_admin());
create policy "pf send message" on public.pf_messages for insert to anon, authenticated with check (true);
create policy "pf admin read messages" on public.pf_messages for select using (public.pf_is_admin());
create policy "pf admin delete messages" on public.pf_messages for delete using (public.pf_is_admin());
insert into storage.buckets (id, name, public) values ('pf-avatars','pf-avatars',true) on conflict do nothing;
create policy "pf read avatars" on storage.objects for select using (bucket_id='pf-avatars');
create policy "pf admin avatars" on storage.objects for all using (bucket_id='pf-avatars' and public.pf_is_admin()) with check (bucket_id='pf-avatars' and public.pf_is_admin());

-- visitor counter used by the admin dashboard charts
create table if not exists public.pf_visits (id bigint generated always as identity primary key, path text default '/', device text, referrer text, created_at timestamptz default now());
create index if not exists pf_visits_created_idx on public.pf_visits (created_at desc);
alter table public.pf_visits enable row level security;
create policy "pf log visit" on public.pf_visits for insert to anon, authenticated with check (char_length(coalesce(path,'')) < 200 and char_length(coalesce(referrer,'')) < 300 and device in ('mobile','desktop','tablet'));
create policy "pf admin read visits" on public.pf_visits for select using (public.pf_is_admin());
create policy "pf admin delete visits" on public.pf_visits for delete using (public.pf_is_admin());
