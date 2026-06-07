-- Migracion incremental para estructura profesional:
-- Presupuesto > Capitulos > Partidas > APUs.
-- Ejecutar en Supabase > SQL Editor si ya tenias creadas las tablas.
-- No modifica RLS ni politicas existentes.

alter table public.budget_items
  add column if not exists code text,
  add column if not exists chapter text;

alter table public.apus
  add column if not exists performance numeric default 1;

create index if not exists budget_items_chapter_idx on public.budget_items(user_id, chapter);
create index if not exists budget_items_code_idx on public.budget_items(user_id, code);
create index if not exists apus_code_idx on public.apus(user_id, code);
