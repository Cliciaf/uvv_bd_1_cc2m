-- 1 Prepare um relatório que mostre a média salarial dos funcionários de cada departamento.

SELECT d.nome_departamento , CAST(AVG(salario) AS DECIMAL (10,2)) AS media_salario  
FROM funcionario AS f
INNER JOIN
departamento AS d ON d.numero_departamento = f.numero_departamento
GROUP BY d.nome_departamento;

-- 2 prepare um relatório que mostre a média salarial dos homens e das mulheres.


SELECT (CASE WHEN(f.sexo = 'M') THEN 'Homens' END) AS sexo, CAST(AVG(salario) AS DECIMAL(10, 2)) AS media_por_sexo
FROM funcionario AS f
WHERE f.sexo = 'M'
GROUP BY f.sexo
UNION
SELECT (CASE WHEN(f.sexo = 'F') THEN 'Mulheres' END) AS sexo, CAST(AVG(salario) AS DECIMAL(10, 2)) AS media_por_sexo
FROM funcionario AS f
WHERE f.sexo = 'F'
GROUP BY f.sexo;

-- 3 prepare um relatório que liste o nome dos departamentos e, para cada departamento, inclua as seguintes informações de seus funcionários: o nome completo, a data de nascimento, a idade em anos completos e o salário.

SELECT d.nome_departamento, (f.primeiro_nome||' '||f.nome_meio||' '||f.ultimo_nome) AS nome_completo, DATE_PART('year', AGE(f.data_nascimento)) AS idade, f.salario
FROM departamento AS d
INNER JOIN funcionario AS f
ON d.numero_departamento = f.numero_departamento;

-- 4 Relatório do nome do departamento e o nome completo, data de nascimento, idade e salário de cada funcionário

SELECT d.nome_departamento, (f.primeiro_nome ||' '|| f.nome_meio ||' '|| f.ultimo_nome) AS nome_completo, f.data_nascimento, DATE_PART('year', AGE(f.data_nascimento)) AS idade, CAST(f.salario AS DECIMAL(10,2))
FROM funcionario AS f 
INNER JOIN
departamento AS d ON (f.numero_departamento = d.numero_departamento);

-- 5 Relatório que apresenta o nome completo dos funcionários, idade, salário atual e o salário reajustado em 20% caso o atual seja inferior à 35 mil ou em 15% caso seja superior a esse valor

SELECT (f.primeiro_nome ||' '|| f.nome_meio ||' '|| f.ultimo_nome) AS nome_completo, DATE_PART('year', AGE(f.data_nascimento)) AS idade, CAST(f.salario AS DECIMAL(10,2)) AS salario_atual, CAST(f.salario*1.2 AS DECIMAL(10,2)) AS salario_reajustado
FROM funcionario AS f, departamento AS d
WHERE salario < 35000 AND f.numero_departamento = d.numero_departamento
UNION
SELECT DISTINCT (f.primeiro_nome ||' '|| f.nome_meio ||' '|| f.ultimo_nome) AS nome_completo, DATE_PART('year', AGE(f.data_nascimento)) AS idade, CAST(f.salario AS DECIMAL(10,2)) AS salario_atual, CAST(f.salario*1.15 AS DECIMAL(10,2)) AS salario_reajustado
FROM funcionario AS f, departamento AS d
WHERE salario >= 35000 AND f.numero_departamento = d.numero_departamento;

-- 6  Relatório com a lista o nome do gerente e dos funcionários de cada departamento e ordena por nome do departamento (em ordem crescente) e pelo salário dos funcionários (em ordem decrescente)
SELECT d.nome_departamento, (CASE WHEN(d.cpf_gerente = '88866555576') THEN 'Jorge E Brito' WHEN(d.cpf_gerente = '98765432168') THEN 'Jennifer S Souza' WHEN(d.cpf_gerente = '33344555587') THEN 'Fernando T Wong' END) AS nome_gerente, (f.primeiro_nome ||' '|| f.nome_meio ||' '|| f.ultimo_nome) AS nome_funcionario, f.salario
FROM departamento AS d, funcionario AS f
WHERE d.numero_departamento = f.numero_departamento
ORDER BY d.nome_departamento ASC, f.salario DESC;

-- 7 Relatório com o nome completo dos funcionários que possuem pelo menos um dependente, o departamento onde trabalham e o nome completo, idade e sexo do(s) dependente(s)
SELECT depar.nome_departamento, (f.primeiro_nome ||' '|| f.nome_meio ||' '|| f.ultimo_nome) AS nome_funcionário, depen.nome_dependente, DATE_PART('year', AGE(depen.data_nascimento)) AS idade_dependente, (CASE WHEN(depen.sexo = 'M') THEN 'Masculino' WHEN (depen.sexo = 'F') THEN 'Feminino' END) AS sexo
FROM funcionario AS f
INNER JOIN
dependente AS depen ON depen.cpf_funcionario = f.cpf
INNER JOIN
departamento AS depar ON depar.numero_departamento = f.numero_departamento;

-- 8 Relatório com o nome completo, departamento e salário de cada funcionário que não possui dependente
SELECT (f.primeiro_nome ||' '|| f.nome_meio ||' '|| f.ultimo_nome) AS nome_funcionário, d.nome_departamento, CAST(salario AS DECIMAL(10,2))
FROM funcionario AS f, departamento AS d
WHERE f.cpf NOT IN (SELECT d.cpf_funcionario FROM dependente AS d) AND d.numero_departamento = f.numero_departamento;

-- 9 Relatório que mostra, para cada departamento, os seus projetos e nome completo de cada funcionário alocado em cada projeto e o número de horas trabalhadas
SELECT d.nome_departamento, p.nome_projeto, (f.primeiro_nome ||' '|| f.nome_meio ||' '|| f.ultimo_nome) AS nome_funcionário, CAST(t.horas AS DECIMAL(3,1)) 
FROM funcionario AS f
INNER JOIN
trabalha_em AS t ON f.cpf = t.cpf_funcionario
INNER JOIN 
projeto AS p ON t.numero_projeto = p.numero_projeto
INNER JOIN
departamento AS d ON d.numero_departamento = p.numero_departamento
ORDER BY d.nome_departamento ASC, p.nome_projeto ASC;

-- 10 Relatório da soma total das horas de cada projeto em cada departamento, o nome do departamento e do projeto
SELECT d.nome_departamento, p.nome_projeto, SUM(t.horas) AS total_horas
FROM trabalha_em AS t
INNER JOIN 
projeto AS p ON p.numero_projeto = t.numero_projeto
INNER JOIN
departamento AS d ON d.numero_departamento = p.numero_departamento
GROUP BY d.nome_departamento, p.nome_projeto
ORDER BY d.nome_departamento ASC;

-- 11 Relatório do nome completo do funcionário, nome do projeto em que ele trabalha e o valor que ele receberá referente às horas trabalhadas neles, considerando 50 reais por hora
SELECT (f.primeiro_nome ||' '|| f.nome_meio ||' '|| f.ultimo_nome) AS nome_completo_f, p.nome_projeto, CAST(t.horas*50 AS DECIMAL (10,2)) AS valor_pagamento
FROM funcionario AS f
INNER JOIN
trabalha_em AS t ON t.cpf_funcionario = f.cpf
INNER JOIN
projeto AS p ON p.numero_projeto = t.numero_projeto;

-- 12 Relatório que exibe o nome do departamento, do projeto e o nome dos funcionários que não registraram nenhuma hora trabalhada
SELECT d.nome_departamento, p.nome_projeto, (f.primeiro_nome ||' '|| f.nome_meio ||' '|| f.ultimo_nome) AS nome_funcionário, (CASE WHEN(t.horas IS NULL) THEN 'Nenhuma' END) AS horas_trabalhadas
FROM funcionario AS f
INNER JOIN
trabalha_em AS t ON t.cpf_funcionario = f.cpf AND t.horas IS NULL
INNER JOIN
projeto AS p ON p.numero_projeto = t.numero_projeto
INNER JOIN
departamento AS d ON d.numero_departamento = p.numero_departamento;

-- 13 Relatório que exibe o nome completo, sexo e idade de todos os funcionários e seus dependentes em ordem decrescente da idade em anos completos
SELECT (f.primeiro_nome ||' '|| f.nome_meio ||' '|| f.ultimo_nome) AS nome_completo, f.sexo, DATE_PART('year', AGE(f.data_nascimento)) AS idade
FROM funcionario AS f
UNION
SELECT depen.nome_dependente AS nome, depen.sexo, DATE_PART('year', AGE(depen.data_nascimento)) AS idade
FROM dependente AS depen
ORDER BY idade DESC;

-- 14 Relatório que exibe a quantidade de funcionários de cada departamento
SELECT d.nome_departamento, COUNT(f.cpf) AS quantidade_funcionarios
FROM funcionario AS f
INNER JOIN
departamento AS d ON d.numero_departamento = f.numero_departamento
GROUP BY d.nome_departamento;

-- 15 Relatório com o nome completo dos funcionários, seu departamento e o nome dos projetos em que cada um está alocado
SELECT (f.primeiro_nome ||' '|| f.nome_meio ||' '|| f.ultimo_nome) AS nome_funcionario, d.nome_departamento, p.nome_projeto
FROM funcionario AS f
INNER JOIN
departamento AS d ON f.numero_departamento = d.numero_departamento
INNER JOIN 
trabalha_em AS t ON t.cpf_funcionario = f.cpf
INNER JOIN
projeto AS p ON p.numero_projeto = t.numero_projeto
ORDER BY nome_funcionario ASC;