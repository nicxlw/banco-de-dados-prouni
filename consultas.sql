/*Porcentagem de homens e mulheres por estado*/
SELECT 
    Estado,
    ROUND(SUM(CASE WHEN Sexo = 'M' THEN 1 ELSE 0 END) * 100.0 / COUNT(Num_ID), 2) AS Porcentagem_Homens,
    ROUND(SUM(CASE WHEN Sexo = 'F' THEN 1 ELSE 0 END) * 100.0 / COUNT(Num_ID), 2) AS Porcentagem_Mulheres
FROM 
    Aluno a
WHERE 
    Estado IS NOT NULL
GROUP BY 
    Estado
ORDER BY 
    Porcentagem_Homens DESC;

/*Alunos não brancos em todas as universidades dos estados*/
SELECT 
    a.Estado,
    COUNT(a.Num_ID) AS Total_Alunos_Nao_Brancos,
    (COUNT(a.Num_ID) * 100.0 / 
        (SELECT COUNT(*) 
         FROM Aluno a2
         JOIN Estuda e2 ON a2.Num_ID = e2.fk_Aluno_Num_ID
         JOIN Curso c2 ON e2.fk_Curso_Nome = c2.Nome
         JOIN Universidade u2 ON c2.fk_Universidade_Codigo_EMEC_IES = u2.Codigo_EMEC_IES
         WHERE a2.Estado = a.Estado)) AS Nao_Brancos
FROM 
    Aluno a
JOIN 
    Estuda e ON a.Num_ID = e.fk_Aluno_Num_ID
JOIN 
    Curso c ON e.fk_Curso_Nome = c.Nome
JOIN 
    Universidade u ON c.fk_Universidade_Codigo_EMEC_IES = u.Codigo_EMEC_IES
WHERE 
    a.Raca IN ('Preto', 'Pardo', 'Indígena')
GROUP BY 
    a.Estado
ORDER BY 
    Nao_Brancos DESC;

/*Número de bolsas de cada modalidade por estado*/
SELECT
    a.Estado,
    b.Tipo,
    COUNT(a.Num_ID) AS Num_Alunos_Com_Bolsa
FROM
    Aluno a
JOIN
    Estuda e ON a.Num_ID = e.fk_Aluno_Num_ID
JOIN
    Curso c ON e.fk_Curso_Nome = c.Nome
JOIN
    Bolsa b ON c.fk_Universidade_Codigo_EMEC_IES = b.fk_Universidade_Codigo_EMEC_IES
WHERE
    a.Estado IS NOT NULL
GROUP BY
    a.Estado, b.Tipo;

/*Média das idades dos alunos por curso e modalidade de ensino*/
SELECT
    c.Nome,
    GROUP_CONCAT(DISTINCT c.Modalidade) AS Modalidades, -- Junta as modalidades distintas
    (
        SELECT ROUND(AVG(a1.Idade))
        FROM Aluno a1
        WHERE a1.Num_ID IN (
            SELECT e1.fk_Aluno_Num_ID
            FROM Estuda e1
            WHERE e1.fk_Curso_Nome = c.Nome
        )
    ) AS Media_Idade
FROM 
    Curso c
GROUP BY 
    c.Nome
ORDER BY 
	Media_Idade DESC;

/*Número de idosos por curso e modalidade*/
SELECT
	c.Nome AS Curso,
	c.Modalidade,
	ROUND(COUNT(a.Num_ID) * 100.0 / COUNT(e.fk_Aluno_Num_ID), 2) AS Percentual_Idosos, -- Porcentagem relativa de idosos
	COUNT(a.Num_ID) AS Quantidade_Total_Idosos -- Quantidade absoluta de idosos
FROM
	Curso c
LEFT JOIN
	Estuda e ON c.Nome = e.fk_Curso_Nome
LEFT JOIN
	Aluno a ON e.fk_Aluno_Num_ID = a.Num_ID AND a.Idade > 65
GROUP BY
	c.Nome, c.Modalidade
HAVING
	Quantidade_Total_Idosos >= 10 -- Filtrar apenas cursos com pelo menos 10 idosos
ORDER BY
	Percentual_Idosos DESC, Quantidade_Total_Idosos DESC;

