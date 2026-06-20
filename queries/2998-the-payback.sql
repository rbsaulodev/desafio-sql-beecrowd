WITH acumulado AS (
    SELECT
        o.client_id,
        o.month,
        SUM(o.profit) OVER (
            PARTITION BY o.client_id
            ORDER BY o.month
        ) AS lucro_acumulado
    FROM operations o
),
payback AS (
    SELECT
        a.client_id,
        MIN(a.month) AS month_of_payback
    FROM acumulado a
    INNER JOIN clients c ON a.client_id = c.id
    WHERE a.lucro_acumulado >= c.investment
    GROUP BY a.client_id
)
SELECT
    c.name,
    c.investment,
    pb.month_of_payback,
    (
        SELECT SUM(o2.profit)
        FROM operations o2
        WHERE o2.client_id = c.id
    ) - c.investment AS return
FROM clients c
INNER JOIN payback pb ON c.id = pb.client_id
ORDER BY return DESC;
