SELECT p.id, p.name, COUNT(ca.id) AS total_classes
FROM professors p
JOIN course_assignments ca ON p.id = ca.professor_id
GROUP BY p.id, p.name
ORDER BY total_classes DESC
LIMIT 1;
