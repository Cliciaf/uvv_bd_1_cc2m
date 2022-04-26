-- Cria usuário do SGBD
CREATE USER clicia IDENTIFIED BY '';

-- Cria Banco de dados UVV com suas propriedades e permissões
CREATE DATABASE uvv CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Concede todos privilégios de administrador ao usuário
GRANT ALL PRIVILEGES ON uvv.* TO clicia;
--Conectando ao banco de dados uvv
USE uvv;

CREATE TABLE funcionario (
                cpf_funcionario VARCHAR(11) NOT NULL COMMENT 'CPF do funcionário. Será a PK da tabela.',
                primeiro_nome VARCHAR(15) NOT NULL COMMENT 'Primeiro nome do funcionário.',
                nome_meio CHAR(1) COMMENT 'Inicial do nome do meio.',
                ultimo_nome VARCHAR(15) NOT NULL COMMENT 'Sobrenome do funcionário.',
                data_nascimento DATE COMMENT 'Data de nascimento do funcionário.',
                endereco VARCHAR(50) COMMENT 'Endereço do funcionário.',
                sexo CHAR(1) COMMENT 'Sexo do funcionário'	
                    CHECK(sexo = 'M' or sexo = 'F' or sexo = 'm' or sexo = 'f'),
                cpf_supervisor VARCHAR(11) COMMENT 'CPF do supervisor. Será uma FK para a própria tabela (um auto-relacionamento).'
                    CHECK (cpf_supervisor != cpf_funcionario),
                salario NUMERIC(10,2) COMMENT 'Salário do funcionário',
                numero_departamento INTEGER NOT NULL COMMENT 'Número do departamento do funcionário.',
                CONSTRAINT cpf_funcionario_pk PRIMARY KEY (cpf_funcionario)
);
-- Table comments
ALTER TABLE funcionario COMMENT 'Tabela que armazena as informações dos funcionários. Cpf do funcionario, primeiro nome, segundo nome, ultimo nome, nascimento, endereço, sexo, cpf do supervidor daquele funcionario,salario e numero do departamento';
-- End Table Funcionario

CREATE TABLE dependente (
                nome_dependente VARCHAR(15) NOT NULL COMMENT 'Nome do dependente. É a PK desta tabela,.',
                cpf_funcionario VARCHAR(11) NOT NULL COMMENT 'CPF do funcionário. É a PK desta tabela e é uma FK da tabela funcionário referenciando cpf_funcionario.',
                sexo CHAR(1) COMMENT 'Sexo do dependente. Masculino(M/m)/Feminino(F/f)' 
                    CHECK(sexo = 'M' or sexo = 'F' or sexo = 'm' or sexo = 'f'), 	
                data_nascimento DATE COMMENT 'Data de nascimento do dependente. ANO/MES/DIA',
                parentesco VARCHAR(15) COMMENT 'Descrição do parentesco do dependente com o funcionário.',
                CONSTRAINT cpf_funcionario_dependente_pk PRIMARY KEY (nome_dependente, cpf_funcionario)
);
-- Table comments
ALTER TABLE dependente COMMENT 'Tabela que armazena as informações dos dependentes dos funcionários. Nome, cpf do funcionario, sexo, nascimento e parentesco';
-- End Table dependente


CREATE TABLE departamento (
                numero_departamento INTEGER NOT NULL COMMENT 'Número do departamento. É a PK desta tabela.'
                    CHECK (numero_departamento > 0 AND numero_departamento < 21) ,
                cpf_gerente VARCHAR(11) NOT NULL COMMENT 'CPF do gerente do departamento. É uma FK para a tabela funcionários referenciando o cpf do funcionario.',
                nome_departamento VARCHAR(15) NOT NULL COMMENT 'Nome do departamento. Deve ser único.',
                data_inicio_gerente DATE COMMENT 'Data do início desse gerente nesse departamento.',
                CONSTRAINT numero_departamento_pk PRIMARY KEY (numero_departamento)
);
-- Table comments
ALTER TABLE departamento COMMENT 'Tabela que armazena as informaçoẽs dos departamentos. Numero do departamento, cpf do gerente, nome do departamento e data de inicio do gerente.';
-- End Table Departamento

CREATE UNIQUE INDEX departamento_idx
 ON uvv.departamento
 ( nome_departamento );


CREATE TABLE localizacoes_departamento (
                local VARCHAR(50) NOT NULL COMMENT 'Localização do departamento. Faz parte da PK desta tabela. ',
                numero_departamento INTEGER NOT NULL COMMENT 'Número do departamento. Faz parta da PK desta tabela e também é uma FK para a tabela departamento.',
                CONSTRAINT numero_departamento_localizacao_pk PRIMARY KEY (local, numero_departamento)
);

-- Table comments
ALTER TABLE localizacoes_departamento COMMENT 'Tabela que armazena as possíveis localizações dos departamentos. Localização e numero do departamento';
-- End Table localizacoes_departamento




CREATE TABLE projeto (
                numero_projeto INTEGER NOT NULL COMMENT 'Número do projeto. É a PK desta tabela.',
                numero_departamento INTEGER NOT NULL,
                nome_projeto VARCHAR(15) NOT NULL COMMENT 'Nome do projeto. Deve ser único.',
                local_projeto VARCHAR(50) COMMENT 'Localização do projeto.',
                CONSTRAINT numero_projeto_pk PRIMARY KEY (numero_projeto)
);
-- Table comments
ALTER TABLE projeto COMMENT 'Tabela que armazena as informações sobre os projetos dos departamentos.';
-- End Table Projeto

CREATE UNIQUE INDEX projeto_idx
 ON uvv.projeto
 ( nome_projeto );


CREATE TABLE trabalha_em (
                cpf_funcionario VARCHAR(11) NOT NULL COMMENT 'CPF do funcionário. Faz parte da PK desta tabela e é uma FK para a tabela funcionário.',
                numero_projeto INTEGER NOT NULL COMMENT 'Número do projeto. Faz parte da PK desta tabela e é uma FK para a tabela projeto.',
                horas NUMERIC(3,1) COMMENT 'Horas trabalhadas pelo funcionário neste projeto.',
                CONSTRAINT cpf_funcionario_trabalhaem_pk PRIMARY KEY (cpf_funcionario, numero_projeto)
);

-- Table comments
ALTER TABLE trabalha_em COMMENT 'Tabela para armazenar quais funcionários trabalham em quais projetos.';
-- End Table trabalha_em
ALTER TABLE uvv.trabalha_em ADD CONSTRAINT funcionario_trabalha_em_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES uvv.funcionario (cpf_funcionario)
ON DELETE SET DEFAULT
ON UPDATE CASCADE
;

ALTER TABLE uvv.funcionario ADD CONSTRAINT funcionario_funcionario_fk
FOREIGN KEY (cpf_supervisor)
REFERENCES uvv.funcionario (cpf_funcionario)
ON DELETE SET DEFAULT
ON UPDATE CASCADE
;

ALTER TABLE uvv.departamento ADD CONSTRAINT funcionario_departamento_fk 
FOREIGN KEY (cpf_gerente)
REFERENCES uvv.funcionario (cpf_funcionario)
ON DELETE SET DEFAULT
ON UPDATE CASCADE
;

ALTER TABLE uvv.departamento ADD CONSTRAINT funcionario_departamento_fk1
FOREIGN KEY (cpf_gerente)
REFERENCES uvv.funcionario (cpf_funcionario)
ON DELETE SET DEFAULT
ON UPDATE CASCADE
;

ALTER TABLE uvv.dependente ADD CONSTRAINT funcionario_dependente_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES uvv.funcionario (cpf_funcionario)
ON DELETE SET DEFAULT
ON UPDATE CASCADE
;

ALTER TABLE uvv.projeto ADD CONSTRAINT departamento_projeto_fk
FOREIGN KEY (numero_departamento)
REFERENCES uvv.departamento (numero_departamento)
ON DELETE SET DEFAULT
ON UPDATE CASCADE
;

ALTER TABLE uvv.localizacoes_departamento ADD CONSTRAINT departamento_localizacoes_departamento_fk
FOREIGN KEY (numero_departamento)
REFERENCES uvv.departamento (numero_departamento)
ON DELETE SET DEFAULT
ON UPDATE CASCADE
;

ALTER TABLE uvv.trabalha_em ADD CONSTRAINT projeto_trabalha_em_fk
FOREIGN KEY (numero_projeto)
REFERENCES uvv.projeto (numero_projeto)
ON DELETE SET DEFAULT
ON UPDATE CASCADE
;

--Inserindo objetos na tabela funcionario
INSERT INTO uvv.funcionario
    (primeiro_nome, nome_meio, ultimo_nome, cpf_funcionario, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento) 
        VALUES
        ('Jorge'    , 'E'   , 'Brito'    , '88866555576'    , '1937-11-10'  , 'R.do Horto,35,São Paulo,SP'            , 'M' , 55000 , NULL          , 1),
        ('Fernando' , 'T'   , 'Wong'     , '33344555587'    , '1955-12-08'  , 'R.da Lapa,34,São Paulo,SP'             , 'M' , 40000 , '88866555576' , 5),
        ('João'     , 'B'   , 'Silva'    , '12345678966'    , '1965-01-09'  , 'R.das Flores,751,São Paulo,SP'         , 'M' , 30000 , '33344555587' , 5),
        ('Jennifer' , 'S'   , 'Souza'    , '98765432168'    , '1941-06-20'  , 'Av. Arthur de Lima,54,Santo André,SP'  , 'F' , 43000 , '88866555576' , 4),
        ('Ronaldo'  , 'K'   , 'Lima'     , '66688444476'    , '1962-09-15'  , 'R.Rebouças,65,Piracicaba,SP'           , 'M' , 38000 , '33344555587' , 5),
        ('Joice'    , 'A'   , 'Leite'    , '45345345376'    , '1972-07-31'  , 'Av.Lucas Obes,74,São Paulo,SP'         , 'F' , 25000 , '33344555587' , 5),
        ('André'    , 'V'   , 'Perreira' , '98798798733'    , '1969-03-29'  , 'R.Timbira,35,São Paulo,SP'             , 'M' , 25000 , '98765432168' , 4),
        ('Alice'    , 'J'   , 'Zelaya'   , '99988777767'    , '1968-01-19'  , 'R.Souza Lima,35,Curitiba,PR'           , 'F' , 25000 , '98765432168' , 4)
;

--Inserindo objetos na tabela departamento
INSERT INTO uvv.departamento
(numero_departamento, cpf_gerente, nome_departamento, data_inicio_gerente)
	VALUES  
    (5, '33344555587', 'Pesquisa', '1988-05-22'),
	(4,'98765432168', 'Administração', '1995-01-01'),
	(1,'88866555576', 'Matriz', '1981-06-19')
	;
--Inserindo objetos na tabela localizacoes departamento
    INSERT INTO uvv.localizacoes_departamento
    (local, numero_departamento)
	VALUES 
    ('São Paulo', 1),
	('Mauá', 4),
	('Santo André', 5),
	('Itu', 5),
	('São Paulo', 5);
-- Inserindo objetos na tabela projeto
INSERT INTO uvv.projeto
(numero_projeto, numero_departamento, nome_projeto, local_projeto)
	VALUES 	
    (1, 5, 'ProdutoX', 'Santo André'),
	(2, 5, 'ProdutoY', 'Itu'),
	(3, 5, 'ProdutoZ', 'São Paulo'),
	(10, 4, 'Informatização', 'Mauá'),
	(20, 1,'Reorganização' , 'São Paulo'),
	(30, 4, 'Novosbeneficios', 'Mauá');

INSERT INTO uvv.dependente(
	nome_dependente, cpf_funcionario, sexo, data_nascimento, parentesco)
	VALUES
    ('Alicia','33344555587','F','1986-04-05','Filha'),
    ('Tiago','33344555587','M','1983-10-25','Filho'),
    ('Janaia','33344555587','F','1958-05-03','Esposa'),
    ('Antonio','98765432168','M','1942-02-28','Marido'),
    ('Michel','12345678966','M', '1988-01-04','Filho'),
    ('Alicia','12345678966','F', '1988-12-30','Filha'),
    ('Elizabeth','12345678966','F', '1967-05-05','Esposa');

INSERT INTO uvv.trabalha_em(
	cpf_funcionario, numero_projeto, horas)
	VALUES 
    ('12345678966',1,32.5),
    ('12345678966',2,7.5),
    ('66688444476',3,40.0),
    ('45345345376',1,20.0),
    ('45345345376',2,20.0),
    ('33344555587',2,10.0),
    ('33344555587',3,10.0),
    ('33344555587',10,10.0),
    ('33344555587',20,10.0),
    ('99988777767',30,30.0),
    ('99988777767',10,10.0),
    ('98798798733',10,35.0),
    ('98798798733',30,5.0),
    ('98765432168',30,20.0),
    ('98765432168',20,15.0),
    ('88866555576',20,NULL);