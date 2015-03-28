#\o /Users/john.cohoon/Sites/storytelling/storytelling_campaign_finance/json/committee_dots_month.json
select array_to_json(array_agg(row_to_json(t)))
from (
    with intervals as (
        select
            (n)::date as start_date,
            ((n + interval '1 month'))::date as end_date
        from generate_series('2010-01-01'::date, '2015-01-01'::date, '1 month'::interval) n
    )

    select sum(t.amount) as s, t.contributor_payee as committee, t.direction, i.end_date
    from working_transactions t
    right join intervals i
    on t.tran_date >= i.start_date and t.tran_date < i.end_date
    where
    ( ( ( book_type = 'Individual' and sub_type = 'Cash Contribution' and amount > 1000)
    or (book_type = 'Business Entity' and sub_type = 'Cash Contribution'))
    and t.direction = 'in')
    or
    ( ( ( (book_type = 'Political Committee' or book_type = 'Political Party Committee') and sub_type = 'Cash Expenditure' and amount > 1000)
    or ( (book_type = 'Political Committee' or book_type = 'Political Party Committee') and sub_type = 'Cash Expenditure'))
    and t.direction = 'out')

    group by i.end_date, committee, direction order by end_date

) t;