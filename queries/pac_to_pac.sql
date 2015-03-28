select array_to_json(array_agg(row_to_json(t)))
from (
    with intervals as (
        select
            (n)::date as start_date,
            ((n + interval '1 week'))::date as end_date
        from generate_series('2010-01-01'::date, '2015-01-01'::date, '1 week'::interval) n
    )
    select sum(t.amount) as s,count(tran_id) as volume, i.end_date
    from working_transactions t
    right join intervals i
    on t.tran_date >= i.start_date and t.tran_date < i.end_date
    where contributor_payee in (select distinct committee_name from working_transactions, working_committees where contributor_payee=committee_name and committee_type = 'PAC')
    group by  i.end_date order by end_date
) t;
