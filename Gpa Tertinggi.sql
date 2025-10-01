SELECT s.id, s.name, s.gpa
FROM students s
JOIN departments d ON s.department_id = d.id
WHERE d.name = 'Computer Science'
ORDER BY s.gpa DESC
LIMIT 1;
