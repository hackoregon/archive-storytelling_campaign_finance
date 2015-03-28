select array_to_json(array_agg(row_to_json(t)))
from (
    with intervals as (
        select
            (n)::date as start_date,
            ((n + interval '1 week'))::date as end_date
        from generate_series('2010-01-01'::date, '2015-01-01'::date, '1 week'::interval) n
    )
    select sum(t.amount) as s, t.book_type, i.end_date
    from working_transactions t
    right join intervals i
    on t.tran_date >= i.start_date and t.tran_date < i.end_date
    where book_type = 'Other' and sub_type = 'Cash Contribution'
    group by i.end_date, t.book_type order by end_date
) t;