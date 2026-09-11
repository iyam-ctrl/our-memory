-- OURMEMORY FINAL V2 — jalankan seluruh script ini di Supabase SQL Editor.

create table if not exists public.profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  username text not null unique,
  bio text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create or replace function public.handle_new_user() returns trigger
language plpgsql security definer set search_path = public
as $$
begin
  insert into public.profiles(user_id,username,bio)
  values(new.id,lower(coalesce(new.raw_user_meta_data->>'username',split_part(new.email,'@',1))),coalesce(new.raw_user_meta_data->>'bio','belum ada bio.'))
  on conflict (user_id) do update set username=excluded.username,bio=excluded.bio,updated_at=now();
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users for each row execute procedure public.handle_new_user();

create or replace function public.get_email_by_username(p_username text) returns text
language sql security definer set search_path = public, auth
as $$ select email from auth.users u join public.profiles p on p.user_id=u.id where lower(p.username)=lower(p_username) limit 1; $$;
grant execute on function public.get_email_by_username(text) to anon,authenticated;

create table if not exists public.follows (
  follower_id uuid not null references auth.users(id) on delete cascade,
  following_id uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key(follower_id,following_id),
  check(follower_id<>following_id)
);

create table if not exists public.post_likes (
  memory_id uuid not null references public.memories(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key(memory_id,user_id)
);

create table if not exists public.post_comments (
  id uuid primary key default gen_random_uuid(),
  memory_id uuid not null references public.memories(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  body text not null check(length(body)>0 and length(body)<=300),
  created_at timestamptz not null default now()
);

create table if not exists public.post_saves (
  memory_id uuid not null references public.memories(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key(memory_id,user_id)
);

create table if not exists public.messages (
  id uuid primary key default gen_random_uuid(),
  sender_id uuid not null references auth.users(id) on delete cascade,
  recipient_id uuid not null references auth.users(id) on delete cascade,
  body text not null check(length(body)>0 and length(body)<=1000),
  created_at timestamptz not null default now(),
  check(sender_id<>recipient_id)
);

-- KENANGAN COUPLE: semua akun yang berhasil login dapat melihat kenangan bersama.
alter table public.memories enable row level security;
drop policy if exists "memories couple read" on public.memories;
create policy "memories couple read" on public.memories for select to authenticated using(true);
drop policy if exists "memories owner insert" on public.memories;
create policy "memories owner insert" on public.memories for insert to authenticated with check(auth.uid()=user_id);
drop policy if exists "memories owner update" on public.memories;
create policy "memories owner update" on public.memories for update to authenticated using(auth.uid()=user_id) with check(auth.uid()=user_id);
drop policy if exists "memories owner delete" on public.memories;
create policy "memories owner delete" on public.memories for delete to authenticated using(auth.uid()=user_id);

alter table public.profiles enable row level security;
alter table public.follows enable row level security;
alter table public.post_likes enable row level security;
alter table public.post_comments enable row level security;
alter table public.post_saves enable row level security;
alter table public.messages enable row level security;

drop policy if exists "profiles public read" on public.profiles;
create policy "profiles public read" on public.profiles for select using(true);
drop policy if exists "profiles owner insert" on public.profiles;
create policy "profiles owner insert" on public.profiles for insert to authenticated with check(auth.uid()=user_id);
drop policy if exists "profiles owner update" on public.profiles;
create policy "profiles owner update" on public.profiles for update to authenticated using(auth.uid()=user_id) with check(auth.uid()=user_id);

drop policy if exists "follows read" on public.follows;
create policy "follows read" on public.follows for select using(true);
drop policy if exists "follows insert own" on public.follows;
create policy "follows insert own" on public.follows for insert to authenticated with check(auth.uid()=follower_id);
drop policy if exists "follows delete own" on public.follows;
create policy "follows delete own" on public.follows for delete to authenticated using(auth.uid()=follower_id);

drop policy if exists "likes read" on public.post_likes;
create policy "likes read" on public.post_likes for select using(true);
drop policy if exists "likes insert own" on public.post_likes;
create policy "likes insert own" on public.post_likes for insert to authenticated with check(auth.uid()=user_id);
drop policy if exists "likes delete own" on public.post_likes;
create policy "likes delete own" on public.post_likes for delete to authenticated using(auth.uid()=user_id);

drop policy if exists "comments read" on public.post_comments;
create policy "comments read" on public.post_comments for select using(true);
drop policy if exists "comments insert own" on public.post_comments;
create policy "comments insert own" on public.post_comments for insert to authenticated with check(auth.uid()=user_id);
drop policy if exists "comments delete own" on public.post_comments;
create policy "comments delete own" on public.post_comments for delete to authenticated using(auth.uid()=user_id);

drop policy if exists "saves read own" on public.post_saves;
create policy "saves read own" on public.post_saves for select to authenticated using(auth.uid()=user_id);
drop policy if exists "saves insert own" on public.post_saves;
create policy "saves insert own" on public.post_saves for insert to authenticated with check(auth.uid()=user_id);
drop policy if exists "saves delete own" on public.post_saves;
create policy "saves delete own" on public.post_saves for delete to authenticated using(auth.uid()=user_id);

drop policy if exists "messages participants read" on public.messages;
create policy "messages participants read" on public.messages for select to authenticated using(auth.uid()=sender_id or auth.uid()=recipient_id);
drop policy if exists "messages mutual insert" on public.messages;
create policy "messages mutual insert" on public.messages for insert to authenticated with check(auth.uid()=sender_id and exists(select 1 from public.follows a where a.follower_id=auth.uid() and a.following_id=recipient_id) and exists(select 1 from public.follows b where b.follower_id=recipient_id and b.following_id=auth.uid()));


-- PERJALANAN KITA: satu data bersama untuk semua akun dan semua perangkat.
-- Data tanggal disimpan di Supabase, BUKAN localStorage, sehingga tidak reset
-- saat IAM/SAVISTA login dari akun berbeda atau perangkat berbeda.
create table if not exists public.journey_settings (
  id integer primary key default 1 check (id=1),
  meet_date date,
  relation_date date,
  updated_by uuid references auth.users(id) on delete set null,
  updated_at timestamptz not null default now()
);

alter table public.journey_settings enable row level security;
drop policy if exists "journey shared read" on public.journey_settings;
create policy "journey shared read" on public.journey_settings for select to authenticated using(true);
drop policy if exists "journey shared insert" on public.journey_settings;
create policy "journey shared insert" on public.journey_settings for insert to authenticated with check(true);
drop policy if exists "journey shared update" on public.journey_settings;
create policy "journey shared update" on public.journey_settings for update to authenticated using(true) with check(true);

-- Aktifkan realtime agar perubahan tanggal langsung tersinkron di perangkat lain.
do $$
begin
  if not exists (select 1 from pg_publication_tables where pubname='supabase_realtime' and schemaname='public' and tablename='journey_settings') then
    alter publication supabase_realtime add table public.journey_settings;
  end if;
exception when undefined_object then
  null;
end $$;


-- moments table (aman bila sudah ada)
create table if not exists public.moments (
  id uuid primary key, user_id uuid not null references auth.users(id) on delete cascade, photo_path text not null unique, photo_url text not null, caption text not null default '', created_at timestamptz not null default now()
);
alter table public.moments enable row level security;
drop policy if exists "public view moments" on public.moments;
create policy "public view moments" on public.moments for select using(true);
drop policy if exists "owner insert moments" on public.moments;
create policy "owner insert moments" on public.moments for insert to authenticated with check(auth.uid()=user_id);
drop policy if exists "owner delete moments" on public.moments;
create policy "owner delete moments" on public.moments for delete to authenticated using(auth.uid()=user_id);

notify pgrst,'reload schema';
