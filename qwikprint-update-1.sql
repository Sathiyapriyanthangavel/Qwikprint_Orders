-- QwikPrint update 1: run ONCE in Supabase > SQL Editor. Keeps all your existing orders and logins.

alter table orders
  add column if not exists paid int not null default 50000,
  add column if not exists status text not null default 'Order received',
  add column if not exists incentive text not null default 'Pending',
  add column if not exists install_date date;

-- Move the old checkbox data into the new columns, then remove the checkboxes
do $$ begin
  if exists (select 1 from information_schema.columns
             where table_schema = 'public' and table_name = 'orders' and column_name = 'paid_pre') then
    update orders set
      paid = 50000 + case when paid_pre then pre else 0 end + case when paid_post then post else 0 end,
      status = case when installed then 'Installed' when shipped then 'Shipped' else 'Order received' end;
    alter table orders drop column paid_pre, drop column shipped, drop column installed, drop column paid_post;
  end if;
end $$;

update orders set install_date = booked + 25 where install_date is null;

alter table orders
  drop constraint if exists status_ok,
  drop constraint if exists incentive_ok,
  drop constraint if exists paid_range;
alter table orders
  add constraint status_ok check (status in ('Order received', 'Shipped', 'Installed')),
  add constraint incentive_ok check (incentive in ('Credited', 'Pending')),
  add constraint paid_range check (paid >= 0 and paid <= total);

-- Only an admin can set or change the incentive
create or replace function guard_orders() returns trigger language plpgsql security definer set search_path = public as
$$ begin
  if not is_admin() then
    if tg_op = 'INSERT' and new.incentive <> 'Pending' then
      raise exception 'Only an admin can set the incentive';
    end if;
    if tg_op = 'UPDATE' and new.incentive is distinct from old.incentive then
      raise exception 'Only an admin can change the incentive';
    end if;
  end if;
  return new;
end $$;
drop trigger if exists orders_guard on orders;
create trigger orders_guard before insert or update on orders
  for each row execute function guard_orders();

-- New logins get a readable name instead of the email (both admin emails stay admin)
create or replace function handle_new_user() returns trigger language plpgsql security definer set search_path = public as
$$ begin
  insert into profiles (id, email, name, role)
  values (new.id, new.email,
    coalesce(new.raw_user_meta_data->>'name', initcap(replace(split_part(new.email, '@', 1), '.', ' '))),
    case when lower(new.email) in ('sathiyapriyan.thangavel@gmail.com', 'pranav.s@qwikprint.in') then 'admin' else 'user' end);
  return new;
end $$;

-- Fix names that are currently emails, then set the two admin names
update profiles set name = initcap(replace(split_part(email, '@', 1), '.', ' '))
  where name is null or name = email or name like '%@%';
update profiles set name = 'Sathiyapriyan' where lower(email) = 'sathiyapriyan.thangavel@gmail.com';
update profiles set name = 'Pranav S' where lower(email) = 'pranav.s@qwikprint.in';

-- Check
select email, name, role from profiles order by role, email;
