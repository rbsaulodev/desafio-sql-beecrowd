SELECT
    cat.name,
    SUM(p.amount) AS sum
FROM categories cat
INNER JOIN products p ON cat.id = p.id_categories
GROUP BY cat.name
ORDER BY cat.name;
