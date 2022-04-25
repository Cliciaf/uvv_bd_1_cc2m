--Criando a role
CREATE ROLE clicia  WITH 
      SUPERUSER
      CREATEDB 
      CREATEROLE
      INHERIT
      LOGIN
      NOREPLICATION 
      BYPASSRLS
      CONNECTION LIMIT  -1
      PASSWORD '1234';

--Criando o banco de dados uvv
CREATE DATABASE uvv
     WITH
      OWNER  clicia
      TEMPLATE  template0 
      ENCODING  'UTF8'
      LC_COLLATE  'pt_BR.UTF-8' 
      LC_CTYPE  'pt_BR.UTF-8'
      ALLOW_CONNECTIONS  true;
-- Entrando no banco de dados da uvv

\connect uvv
-- Criando o schema uvv.elmasri
CREATE SCHEMA IF NOT EXISTS elmasri
    AUTHORIZATION clicia;

-- trocando para o schema uvv.elmasri
ALTER USER clicia
SET SEARCH_PATH TO elmasri, 'clicia', public;


CREATE TABLE elmasri.funcionario (
                cpf_funcionario VARCHAR(11) NOT NULL,
                primeiro_nome VARCHAR(15) NOT NULL,
                nome_meio CHAR(1),
                ultimo_nome VARCHAR(15) NOT NULL,
                data_nascimento DATE,
                endereco VARCHAR(50),
                sexo CHAR(1) CHECK(sexo = 'M' or sexo = 'F' or sexo = 'm' or sexo = 'f'),
                cpf_supervisor VARCHAR(11) CHECK (cpf_supervisor != cpf_funcionario),
                salario NUMERIC(10,2),
                numero_departamento INTEGER NOT NULL,
                CONSTRAINT cpf_funcionario_pk PRIMARY KEY (cpf_funcionario)
);

-- Comentarios da tabela funcionario
comment on
table funcionario is 'Tabela que armazena as informações dos funcionários.';
-- Coluna de comentarios

comment on
column funcionario.cpf is 'CPF do funcionário. Será a PK da tabela.';

comment on
column funcionario.primeiro_nome is 'Primeiro nome do funcionário.';

comment on
column funcionario.nome_meio is 'Inicial do nome do meio.';

comment on
column funcionario.ultimo_nome is 'Sobrenome do funcionário.';

comment on
column funcionario.endereco is 'Endereço do funcionário.';

comment on
column funcionario.sexo is 'Sexo do funcionário';

comment on
column funcionario.salario is 'Salário do funcionário';

comment on
column funcionario.cpf_supervisor is 'CPF do supervisor. Será uma FK para a própria tabela (um auto-relacionamento).';

comment on
column funcionario.numero_departamento is 'Número do departamento do funcionário.';
-- End Table Funcionario


CREATE TABLE elmasri.dependente (
                nome_dependente VARCHAR(15) NOT NULL,
                cpf_funcionario VARCHAR(11) NOT NULL,
                sexo CHAR(1) CHECK(sexo = 'M' or sexo = 'F' or sexo = 'm' or sexo = 'f'),
                data_nascimento DATE,
                parentesco VARCHAR(15),
                CONSTRAINT cpf_funcionario_dependente_pk PRIMARY KEY (nome_dependente, cpf_funcionario)
);

-- Comentarios da tabela dependentes
comment on
table dependente is 'Tabela que armazena as informações dos dependentes dos funcionários.';
-- Comentario por coluna
comment on
column dependente.cpf_funcionario is 'CPF do funcionário. Faz parte da PK desta tabela e é uma FK para a tabela funcionário.';

comment on
column dependente.nome_dependente is 'Nome do dependente. Faz parte da PK desta tabela.';

comment on
column dependente.sexo is 'Sexo do dependente.';

comment on
column dependente.data_nascimento is 'Data de nascimento do dependente.';

comment on
column dependente.parentesco is 'Descrição do parentesco do dependente com o funcionário.';
-- Fim dos comentarios da tabela dependentes

CREATE TABLE elmasri.departamento (
                numero_departamento INTEGER NOT NULL CHECK (numero_departamento > 0 AND numero_departamento < 21),
                cpf_gerente VARCHAR(11) NOT NULL,
                nome_departamento VARCHAR(15) NOT NULL,
                data_inicio_gerente DATE,
                CONSTRAINT numero_departamento_pk PRIMARY KEY (numero_departamento)
);


CREATE UNIQUE INDEX departamento_idx
 ON elmasri.departamento
 ( nome_departamento );

-- Table comments departamento
comment on
table departamento is 'Tabela que armazena as informaçoẽs dos departamentos.';
-- Coluna de comentarios
comment on
column departamento.numero_departamento is 'Número do departamento. É a PK desta tabela.';

comment on
column departamento.nome_departamento is 'Nome do departamento. Deve ser único.';

comment on
column departamento.cpf_gerente is 'CPF do gerente do departamento. É uma FK para a tabela funcionários.';

comment on
column departamento.data_inicio_gerente is 'Data do início do gerente no departamento.';
-- End departamento


CREATE TABLE elmasri.localizacoes_departamento (
                local VARCHAR(50) NOT NULL,
                numero_departamento INTEGER NOT NULL,
                CONSTRAINT numero_departamento_localizacao_pk PRIMARY KEY (local, numero_departamento)
);

-- Comentarios na tabela localizações departamento
comment on
table localizacoes_departamento is 'Tabela que armazena as possíveis localizações dos departamentos.';
-- Coluna de comentarios

comment on
column localizacoes_departamento.numero_departamento is 'Número do departamento. Faz parta da PK desta tabela e também é uma FK para a tabela departamento.';

comment on
column localizacoes_departamento.local is 'Localização do departamento. Faz parte da PK desta tabela.';
-- End Table localizacoes_departamento

CREATE TABLE elmasri.projeto (
                numero_projeto INTEGER NOT NULL,
                numero_departamento INTEGER NOT NULL,
                nome_projeto VARCHAR(15) NOT NULL,
                local_projeto VARCHAR(50),
                CONSTRAINT numero_projeto_pk PRIMARY KEY (numero_projeto)
);


CREATE UNIQUE INDEX projeto_idx
 ON elmasri.projeto
 ( nome_projeto );

 -- Table comment
comment on
table projeto is 'Tabela que armazena as informações sobre os projetos dos departamentos.';
-- Coluna de comentarios

comment on
column projeto.numero_projeto is 'Número do projeto. É a PK desta tabela.';

comment on
column projeto.nome_projeto is 'Nome do projeto. Deve ser único.';

comment on
column projeto.local_projeto is 'Localização do projeto.';

comment on
column projeto.numero_departamento is 'Número do departamento. É uma FK para a tabela departamento.';
-- End Table projeto

CREATE TABLE elmasri.trabalha_em (
                cpf_funcionario VARCHAR(11) NOT NULL,
                numero_projeto INTEGER NOT NULL,
                horas NUMERIC(3,1),
                CONSTRAINT cpf_funcionario_trabalhaem_pk PRIMARY KEY (cpf_funcionario, numero_projeto)
);

-- Table comment
comment on
table trabalha_em is 'Tabela para armazenar quais funcionários trabalham em quais projetos.';
-- Coluna de comentarios

comment on
column trabalha_em.cpf_funcionario is 'CPF do funcionário. Faz parte da PK desta tabela e é uma FK para a tabela funcionário.';

comment on
column trabalha_em.numero_projeto is 'Número do projeto. Faz parte da PK desta tabela e é uma FK para a tabela projeto.';

comment on
column trabalha_em.horas is 'Horas trabalhadas pelo funcionário neste projeto.';
-- End Table trabalha_em



ALTER TABLE elmasri.trabalha_em ADD CONSTRAINT funcionario_trabalha_em_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES elmasri.funcionario (cpf_funcionario)
ON DELETE SET DEFAULT
ON UPDATE CASCADE
;

ALTER TABLE elmasri.funcionario ADD CONSTRAINT funcionario_funcionario_fk
FOREIGN KEY (cpf_supervisor)
REFERENCES elmasri.funcionario (cpf_funcionario)
ON DELETE SET DEFAULT
ON UPDATE CASCADE
;

ALTER TABLE elmasri.departamento ADD CONSTRAINT funcionario_departamento_fk
FOREIGN KEY (cpf_gerente)
REFERENCES elmasri.funcionario (cpf_funcionario)
ON DELETE SET DEFAULT
ON UPDATE CASCADE
;

ALTER TABLE elmasri.departamento ADD CONSTRAINT funcionario_departamento_fk1
FOREIGN KEY (cpf_gerente)
REFERENCES elmasri.funcionario (cpf_funcionario)
ON DELETE SET DEFAULT
ON UPDATE CASCADE
;

ALTER TABLE elmasri.dependente ADD CONSTRAINT funcionario_dependente_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES elmasri.funcionario (cpf_funcionario)
ON DELETE SET DEFAULT
ON UPDATE CASCADE
;

ALTER TABLE elmasri.projeto ADD CONSTRAINT departamento_projeto_fk
FOREIGN KEY (numero_departamento)
REFERENCES elmasri.departamento (numero_departamento)
ON DELETE SET DEFAULT
ON UPDATE CASCADE
;

ALTER TABLE elmasri.localizacoes_departamento ADD CONSTRAINT departamento_localizacoes_departamento_fk
FOREIGN KEY (numero_departamento)
REFERENCES elmasri.departamento (numero_departamento)
ON DELETE SET DEFAULT
ON UPDATE CASCADE
;

ALTER TABLE elmasri.trabalha_em ADD CONSTRAINT projeto_trabalha_em_fk
FOREIGN KEY (numero_projeto)
REFERENCES elmasri.projeto (numero_projeto)
ON DELETE SET DEFAULT
ON UPDATE CASCADE
;

-- Inserindo objetos
--Inserindo objetos na tabela funcionario
INSERT INTO elmasri.funcionario
    (primeiro_nome, nome_meio, ultimo_nome, cpf_funcionario, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento) 
        VALUES
        ('Jorge'    , 'E'   , 'Brito'    , '88866555576'    , '10-11-1937'  , 'R.do Horto,35,São Paulo,SP'            , 'M' , 55000 , NULL          , 1),
        ('Fernando' , 'T'   , 'Wong'     , '33344555587'    , '1955-12-08'  , 'R.da Lapa,34,São Paulo,SP'             , 'M' , 40000 , '88866555576' , 5),
        ('João'     , 'B'   , 'Silva'    , '12345678966'    , '1965-01-09'  , 'R.das Flores,751,São Paulo,SP'         , 'M' , 30000 , '33344555587' , 5),
        ('Jennifer' , 'S'   , 'Souza'    , '98765432168'    , '1941-06-20'  , 'Av. Arthur de Lima,54,Santo André,SP'  , 'F' , 43000 , '88866555576' , 4),
        ('Ronaldo'  , 'K'   , 'Lima'     , '66688444476'    , '1962-09-15'  , 'R.Rebouças,65,Piracicaba,SP'           , 'M' , 38000 , '33344555587' , 5),
        ('Joice'    , 'A'   , 'Leite'    , '45345345376'    , '1972-07-31'  , 'Av.Lucas Obes,74,São Paulo,SP'         , 'F' , 25000 , '33344555587' , 5),
        ('André'    , 'V'   , 'Perreira' , '98798798733'    , '1969-03-29'  , 'R.Timbira,35,São Paulo,SP'             , 'M' , 25000 , '98765432168' , 4),
        ('Alice'    , 'J'   , 'Zelaya'   , '99988777767'    , '1968-01-19'  , 'R.Souza Lima,35,Curitiba,PR'           , 'F' , 25000 , '98765432168' , 4)
;

--Inserindo objetos na tabela departamento
INSERT INTO elmasri.departamento
(numero_departamento, cpf_gerente, nome_departamento, data_inicio_gerente)
	VALUES  
    (5, '33344555587', 'Pesquisa', '1988-05-22'),
	(4,'98765432168', 'Administração', '1995-01-01'),
	(1,'88866555576', 'Matriz', '1981-06-19')
	;
--Inserindo objetos na tabela localizacoes departamento
    INSERT INTO elmasri.localizacoes_departamento
    (local, numero_departamento)
	VALUES 
    ('São Paulo', 1),
	('Mauá', 4),
	('Santo André', 5),
	('Itu', 5),
	('São Paulo', 5);
-- Inserindo objetos na tabela projeto
INSERT INTO elmasri.projeto
(numero_projeto, numero_departamento, nome_projeto, local_projeto)
	VALUES 	
    (1, 5, 'ProdutoX', 'Santo André'),
	(2, 5, 'ProdutoY', 'Itu'),
	(3, 5, 'ProdutoZ', 'São Paulo'),
	(10, 4, 'Informatização', 'Mauá'),
	(20, 1,'Reorganização' , 'São Paulo'),
	(30, 4, 'Novosbeneficios', 'Mauá');

INSERT INTO elmasri.dependente(
	nome_dependente, cpf_funcionario, sexo, data_nascimento, parentesco)
	VALUES
    ('Alicia','33344555587','F','1986-04-05','Filha'),
    ('Tiago','33344555587','M','1983-10-25','Filho'),
    ('Janaia','33344555587','F','1958-05-03','Esposa'),
    ('Antonio','98765432168','M','1942-02-28','Marido'),
    ('Michel','12345678966','M', '1988-01-04','Filho'),
    ('Alicia','12345678966','F', '1988-12-30','Filha'),
    ('Elizabeth','12345678966','F', '1967-05-05','Esposa');

INSERT INTO elmasri.trabalha_em(
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