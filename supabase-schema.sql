-- Supabase SQL para Generador de Presupuestos de Obra
-- Pegar completo en Supabase > SQL Editor > New query > Run.
-- No requiere service_role key en el frontend.

create extension if not exists "pgcrypto";

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create table if not exists public.budgets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  client_name text,
  project_name text,
  location text,
  budget_number text,
  budget_date date,
  notes text,
  direct_cost numeric default 0,
  overhead_percent numeric default 0,
  overhead_amount numeric default 0,
  profit_percent numeric default 0,
  profit_amount numeric default 0,
  discount_amount numeric default 0,
  tax_percent numeric default 19,
  tax_amount numeric default 0,
  total_net numeric default 0,
  total_final numeric default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.budget_items (
  id uuid primary key default gen_random_uuid(),
  budget_id uuid not null references public.budgets(id) on delete cascade,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  category text,
  description text,
  unit text,
  quantity numeric default 0,
  unit_price numeric default 0,
  subtotal numeric default 0,
  item_order integer default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.apus (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  code text,
  category text,
  name text,
  description text,
  unit text,
  materials_cost numeric default 0,
  labor_cost numeric default 0,
  equipment_cost numeric default 0,
  subcontract_cost numeric default 0,
  waste_percent numeric default 0,
  unit_price numeric default 0,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.schedule_tasks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  budget_id uuid references public.budgets(id) on delete cascade,
  task_name text,
  category text,
  start_date date,
  end_date date,
  duration_days integer default 0,
  predecessor_id uuid references public.schedule_tasks(id) on delete set null,
  progress_percent numeric default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists budgets_user_id_idx on public.budgets(user_id);
create index if not exists budgets_updated_at_idx on public.budgets(updated_at desc);
create index if not exists budget_items_budget_id_idx on public.budget_items(budget_id);
create index if not exists budget_items_user_id_idx on public.budget_items(user_id);
create index if not exists apus_user_id_idx on public.apus(user_id);
create index if not exists schedule_tasks_user_id_idx on public.schedule_tasks(user_id);
create index if not exists schedule_tasks_budget_id_idx on public.schedule_tasks(budget_id);

drop trigger if exists set_budgets_updated_at on public.budgets;
create trigger set_budgets_updated_at
before update on public.budgets
for each row execute function public.set_updated_at();

drop trigger if exists set_budget_items_updated_at on public.budget_items;
create trigger set_budget_items_updated_at
before update on public.budget_items
for each row execute function public.set_updated_at();

drop trigger if exists set_apus_updated_at on public.apus;
create trigger set_apus_updated_at
before update on public.apus
for each row execute function public.set_updated_at();

drop trigger if exists set_schedule_tasks_updated_at on public.schedule_tasks;
create trigger set_schedule_tasks_updated_at
before update on public.schedule_tasks
for each row execute function public.set_updated_at();

alter table public.budgets enable row level security;
alter table public.budget_items enable row level security;
alter table public.apus enable row level security;
alter table public.schedule_tasks enable row level security;

drop policy if exists "budgets_select_own" on public.budgets;
create policy "budgets_select_own"
on public.budgets
for select
to authenticated
using (user_id = auth.uid());

drop policy if exists "budgets_insert_own" on public.budgets;
create policy "budgets_insert_own"
on public.budgets
for insert
to authenticated
with check (user_id = auth.uid());

drop policy if exists "budgets_update_own" on public.budgets;
create policy "budgets_update_own"
on public.budgets
for update
to authenticated
using (user_id = auth.uid())
with check (user_id = auth.uid());

drop policy if exists "budgets_delete_own" on public.budgets;
create policy "budgets_delete_own"
on public.budgets
for delete
to authenticated
using (user_id = auth.uid());

drop policy if exists "budget_items_select_own" on public.budget_items;
create policy "budget_items_select_own"
on public.budget_items
for select
to authenticated
using (user_id = auth.uid());

drop policy if exists "budget_items_insert_own" on public.budget_items;
create policy "budget_items_insert_own"
on public.budget_items
for insert
to authenticated
with check (
  user_id = auth.uid()
  and exists (
    select 1 from public.budgets
    where budgets.id = budget_items.budget_id
      and budgets.user_id = auth.uid()
  )
);

drop policy if exists "budget_items_update_own" on public.budget_items;
create policy "budget_items_update_own"
on public.budget_items
for update
to authenticated
using (user_id = auth.uid())
with check (
  user_id = auth.uid()
  and exists (
    select 1 from public.budgets
    where budgets.id = budget_items.budget_id
      and budgets.user_id = auth.uid()
  )
);

drop policy if exists "budget_items_delete_own" on public.budget_items;
create policy "budget_items_delete_own"
on public.budget_items
for delete
to authenticated
using (user_id = auth.uid());

drop policy if exists "apus_select_own" on public.apus;
create policy "apus_select_own"
on public.apus
for select
to authenticated
using (user_id = auth.uid());

drop policy if exists "apus_insert_own" on public.apus;
create policy "apus_insert_own"
on public.apus
for insert
to authenticated
with check (user_id = auth.uid());

drop policy if exists "apus_update_own" on public.apus;
create policy "apus_update_own"
on public.apus
for update
to authenticated
using (user_id = auth.uid())
with check (user_id = auth.uid());

drop policy if exists "apus_delete_own" on public.apus;
create policy "apus_delete_own"
on public.apus
for delete
to authenticated
using (user_id = auth.uid());

drop policy if exists "schedule_tasks_select_own" on public.schedule_tasks;
create policy "schedule_tasks_select_own"
on public.schedule_tasks
for select
to authenticated
using (user_id = auth.uid());

drop policy if exists "schedule_tasks_insert_own" on public.schedule_tasks;
create policy "schedule_tasks_insert_own"
on public.schedule_tasks
for insert
to authenticated
with check (
  user_id = auth.uid()
  and (
    budget_id is null
    or exists (
      select 1 from public.budgets
      where budgets.id = schedule_tasks.budget_id
        and budgets.user_id = auth.uid()
    )
  )
);

drop policy if exists "schedule_tasks_update_own" on public.schedule_tasks;
create policy "schedule_tasks_update_own"
on public.schedule_tasks
for update
to authenticated
using (user_id = auth.uid())
with check (
  user_id = auth.uid()
  and (
    budget_id is null
    or exists (
      select 1 from public.budgets
      where budgets.id = schedule_tasks.budget_id
        and budgets.user_id = auth.uid()
    )
  )
);

drop policy if exists "schedule_tasks_delete_own" on public.schedule_tasks;
create policy "schedule_tasks_delete_own"
on public.schedule_tasks
for delete
to authenticated
using (user_id = auth.uid());
