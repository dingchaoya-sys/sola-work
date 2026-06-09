-- SOLA CAREER 完全版 初期化SQL
-- 先に Supabase Authentication > Users で admin@sola-career.com を作成してください。

create table if not exists user_profiles (
  id uuid primary key default gen_random_uuid(),
  auth_user_id uuid,
  email text unique,
  role text,
  name text,
  tel text,
  status text default 'active',
  student_id uuid,
  company_id uuid,
  created_at timestamptz default now()
);
create table if not exists students (
  id uuid primary key default gen_random_uuid(),
  auth_user_id uuid,
  email text unique,
  name text,
  tel text,
  school text default 'SOLA学園',
  class_name text,
  nationality text,
  resume_url text,
  photo_url text,
  created_at timestamptz default now()
);
create table if not exists companies (
  id uuid primary key default gen_random_uuid(),
  auth_user_id uuid,
  email text unique,
  company_name text,
  tel text,
  contact_person text,
  approved boolean default true,
  status text default 'approved',
  created_at timestamptz default now()
);
create table if not exists dispatch_jobs (
  id uuid primary key default gen_random_uuid(),
  company_id uuid,
  company text,
  job_type text,
  work_content text,
  work_place text,
  pay text,
  detail_description text,
  active boolean default true,
  created_at timestamptz default now()
);
create table if not exists career_jobs (
  id uuid primary key default gen_random_uuid(),
  company_id uuid,
  company text,
  job_type text,
  work_content text,
  work_place text,
  pay text,
  detail_description text,
  active boolean default true,
  created_at timestamptz default now()
);
create table if not exists dispatch_apps (
  id uuid primary key default gen_random_uuid(),
  job_id uuid,
  student_id uuid,
  status text default '応募中',
  created_at timestamptz default now()
);
create table if not exists career_apps (
  id uuid primary key default gen_random_uuid(),
  job_id uuid,
  student_id uuid,
  status text default '応募中',
  created_at timestamptz default now()
);
create table if not exists site_notices (
  id uuid primary key default gen_random_uuid(),
  category text,
  title text,
  body text,
  important boolean default false,
  active boolean default true,
  created_at timestamptz default now()
);
create table if not exists graduate_paths (
  id uuid primary key default gen_random_uuid(),
  student_id uuid unique,
  student_name text,
  class_name text,
  nationality text,
  graduation_year text,
  path_type text,
  company_name text,
  job_type text,
  memo text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

alter table user_profiles enable row level security;
alter table students enable row level security;
alter table companies enable row level security;
alter table dispatch_jobs enable row level security;
alter table career_jobs enable row level security;
alter table dispatch_apps enable row level security;
alter table career_apps enable row level security;
alter table site_notices enable row level security;
alter table graduate_paths enable row level security;

drop policy if exists "all_user_profiles" on user_profiles;
drop policy if exists "all_students" on students;
drop policy if exists "all_companies" on companies;
drop policy if exists "all_dispatch_jobs" on dispatch_jobs;
drop policy if exists "all_career_jobs" on career_jobs;
drop policy if exists "all_dispatch_apps" on dispatch_apps;
drop policy if exists "all_career_apps" on career_apps;
drop policy if exists "all_site_notices" on site_notices;
drop policy if exists "all_graduate_paths" on graduate_paths;

create policy "all_user_profiles" on user_profiles for all using (true) with check (true);
create policy "all_students" on students for all using (true) with check (true);
create policy "all_companies" on companies for all using (true) with check (true);
create policy "all_dispatch_jobs" on dispatch_jobs for all using (true) with check (true);
create policy "all_career_jobs" on career_jobs for all using (true) with check (true);
create policy "all_dispatch_apps" on dispatch_apps for all using (true) with check (true);
create policy "all_career_apps" on career_apps for all using (true) with check (true);
create policy "all_site_notices" on site_notices for all using (true) with check (true);
create policy "all_graduate_paths" on graduate_paths for all using (true) with check (true);

insert into site_notices(category,title,body,important,active)
values
('重要','SOLA CAREERを公開しました','学生の皆さんは、アカウント登録後、求人情報を確認してください。',true,true),
('案内','求人応募前のお願い','応募前に、履歴書PDFと証明写真を登録してください。',false,true)
on conflict do nothing;

-- 管理者プロフィール自動作成・修復
insert into user_profiles(auth_user_id,email,role,name,status)
select id,email,'admin','管理者','active'
from auth.users
where email='admin@sola-career.com'
on conflict(email) do update
set auth_user_id=excluded.auth_user_id,
    role='admin',
    name='管理者',
    status='active';
