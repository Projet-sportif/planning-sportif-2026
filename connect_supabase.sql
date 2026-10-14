-- À exécuter une seule fois dans Supabase > SQL Editor après avoir créé les tables.
-- Le mode public permet à toute personne disposant de l'URL de consulter/modifier les données.
alter table public.sorties add column if not exists organisateur text;

grant usage on schema public to anon, authenticated;
grant select, insert, update, delete on table public.sorties to anon, authenticated;
grant select, insert, update, delete on table public.participations to anon, authenticated;
grant usage, select on all sequences in schema public to anon, authenticated;

-- Active les notifications temps réel utilisées par l'application.
do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'sorties'
  ) then
    alter publication supabase_realtime add table public.sorties;
  end if;
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'participations'
  ) then
    alter publication supabase_realtime add table public.participations;
  end if;
end $$;
