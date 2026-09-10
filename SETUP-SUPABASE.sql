-- OURMEMORY — DATABASE + STORAGE
-- Jalankan seluruh script ini di Supabase SQL Editor.

create table if not exists public.memories(
  id uuid primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null,
  date date not null default current_date,
  album text not null default 'Umum',
  note text not null default '',
  type text not null check(type in('image','video')),
  storage_path text not null unique,
  media_url text not null,
  fav boolean not null default false,
  created_at timestamptz not null default now()
);

alter table public.memories enable row level security;
drop policy if exists "public view memories" on public.memories;
create policy "public view memories" on public.memories for select using(true);
drop policy if exists "owner insert memories" on public.memories;
create policy "owner insert memories" on public.memories for insert to authenticated with check(auth.uid()=user_id);
drop policy if exists "owner update memories" on public.memories;
create policy "owner update memories" on public.memories for update to authenticated using(auth.uid()=user_id) with check(auth.uid()=user_id);
drop policy if exists "owner delete memories" on public.memories;
create policy "owner delete memories" on public.memories for delete to authenticated using(auth.uid()=user_id);

-- FITUR MOMEN FOTO: posting foto singkat untuk mengabari pengguna lain.
create table if not exists public.moments(
  id uuid primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  photo_path text not null unique,
  photo_url text not null,
  caption text not null default '',
  created_at timestamptz not null default now()
);

alter table public.moments enable row level security;
drop policy if exists "public view moments" on public.moments;
create policy "public view moments" on public.moments for select using(true);
drop policy if exists "owner insert moments" on public.moments;
create policy "owner insert moments" on public.moments for insert to authenticated with check(auth.uid()=user_id);
drop policy if exists "owner delete moments" on public.moments;
create policy "owner delete moments" on public.moments for delete to authenticated using(auth.uid()=user_id);

-- STORAGE
insert into storage.buckets(id,name,public)
values('ourmemory','ourmemory',true)
on conflict(id) do update set public=true;

drop policy if exists "public read ourmemory" on storage.objects;
create policy "public read ourmemory" on storage.objects for select using(bucket_id='ourmemory');
drop policy if exists "owner upload ourmemory" on storage.objects;
create policy "owner upload ourmemory" on storage.objects for insert to authenticated with check(bucket_id='ourmemory' and (storage.foldername(name))[1]=auth.uid()::text);
drop policy if exists "owner update ourmemory" on storage.objects;
create policy "owner update ourmemory" on storage.objects for update to authenticated using(bucket_id='ourmemory' and (storage.foldername(name))[1]=auth.uid()::text) with check(bucket_id='ourmemory' and (storage.foldername(name))[1]=auth.uid()::text);
drop policy if exists "owner delete ourmemory" on storage.objects;
create policy "owner delete ourmemory" on storage.objects for delete to authenticated using(bucket_id='ourmemory' and (storage.foldername(name))[1]=auth.uid()::text);
