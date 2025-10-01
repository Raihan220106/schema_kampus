SELECT semester, SUM(amount) AS total_scholarships
FROM scholarships
GROUP BY semester;
