SELECT DISTINCT s.id, s.name
FROM students s
JOIN scholarships sc ON s.id = sc.student_id
JOIN financial_aid fa ON s.id = fa.student_id;
