-- Cria o projeto do Elmasri

-- Faz limpeza geral:
DROP DATABASE IF EXISTS uvv;
DROP USER IF EXISTS clicia;

-- Cria o usuário que será o dono do banco de dados:
CREATE USER clicia WITH
    NOSUPERUSER
    CREATEDB
    CREATEROLE
    LOGIN
    ENCRYPTED PASSWORD '1234'
;

-- Cria o banco de dados UVV:
CREATE DATABASE uvv WITH
    owner      = clicia
    template   = template0
    encoding   = 'UTF-8'
    lc_collate = 'pt_br.UTF-8'
    lc_ctype   = 'pt_BR.UTF-8'
;

-- Conexão ao banco uvv com o usuário yuri:
\c "dbname=uvv user=clicia password=1234"

-- Cria o esquema Elamsri:
CREATE SCHEMA elmasri AUTHORIZATION clicia;

ALTER USER clicia 
SET SEARCH_PATH TO elmasri, "$user", public;

SET SEARCH_PATH TO elmasri, "$user", public;

-- Cria a tabela funcionário:
CREATE TABLE funcionario (
    cpf                 CHAR(11)    CONSTRAINT nn_func_cpf       NOT NULL,
    primeiro_nome       VARCHAR(15) CONSTRAINT nn_func_prim_nome NOT NULL,
    nome_meio           CHAR(1),
    ultimo_nome         VARCHAR(15) CONSTRAINT nn_func_ult_nome  NOT NULL,
    data_nascimento     DATE,
    endereco            VARCHAR(35),
    sexo                CHAR(1),
    salario             DECIMAL (10,2),
    cpf_supervisor      CHAR(11),
    numero_departamento INT
);

-- Cria chaves da tabela funcionário:
ALTER TABLE funcionario ADD CONSTRAINT pk_funcionario 
PRIMARY KEY (cpf);

ALTER TABLE funcionario ADD CONSTRAINT fk_cpf_super_cpf
FOREIGN KEY (cpf_supervisor) REFERENCES funcionario (cpf);

-- Constraints adicionais para a tabela funcionário:
ALTER TABLE funcionario ADD CONSTRAINT ck_func_sexo 
CHECK (sexo IN ('M', 'F'));

ALTER TABLE funcionario ADD CONSTRAINT ck_func_salario
CHECK (salario >= 0);

-- Comentários da tabela funcionário:
COMMENT ON TABLE elmasri.funcionario IS 'Tabela que armazena as informações dos funcionários.';
COMMENT ON COLUMN elmasri.funcionario.cpf IS 'CPF do funcionário. Será a PK da tabela.';
COMMENT ON COLUMN elmasri.funcionario.primeiro_nome IS 'Primeiro nome do funcionário.';
COMMENT ON COLUMN elmasri.funcionario.nome_meio IS 'Letra inicial do nome do meio.';
COMMENT ON COLUMN elmasri.funcionario.ultimo_nome IS 'Sobrenome do funcionário.';
COMMENT ON COLUMN elmasri.funcionario.data_nascimento IS 'Data de nascimento do funcionário.';
COMMENT ON COLUMN elmasri.funcionario.endereco IS 'Endereço do funcionário.';
COMMENT ON COLUMN elmasri.funcionario.sexo IS 'Sexo do funcionário.';
COMMENT ON COLUMN elmasri.funcionario.salario IS 'Salário do funcionário.';
COMMENT ON COLUMN elmasri.funcionario.cpf_supervisor IS 'CPF do supervisor será uma FK para a própria tabela (um auto-relacionamento).';
COMMENT ON COLUMN elmasri.funcionario.numero_departamento IS 'Número do departamento do funcionário.';

-- Cria a tabela dependente:
CREATE TABLE dependente (
    cpf_funcionario CHAR(11)    CONSTRAINT nn_depend_cpf_func NOT NULL,
    nome_dependente VARCHAR(15) CONSTRAINT nn_depend_nome_dep NOT NULL,
    sexo            CHAR(1),
    data_nascimento DATE,
    parentesco      VARCHAR(15)
);

-- Cria chaves da tabela dependente:
ALTER TABLE dependente ADD CONSTRAINT pk_dependente 
PRIMARY KEY (cpf_funcionario, nome_dependente);

ALTER TABLE dependente ADD CONSTRAINT fk_cpf_func_cpf
FOREIGN KEY (cpf_funcionario) REFERENCES funcionario (cpf);

-- Constraints adicionais para a tabela dependente:
ALTER TABLE dependente ADD CONSTRAINT ck_depend_sexo
CHECK (sexo IN ('M', 'F'));

COMMENT ON TABLE elmasri.dependente IS 'Tabela que armazena as informações dos dependentes dos funcionários.';
COMMENT ON COLUMN elmasri.dependente.cpf_funcionario IS 'CPF do funcionário faz parte da PK desta tabela e é uma FK para a tabela funcionário.';
COMMENT ON COLUMN elmasri.dependente.nome_dependente IS 'Nome do dependente faz parte da PK desta tabela.';
COMMENT ON COLUMN elmasri.dependente.sexo IS 'Sexo do dependente.';
COMMENT ON COLUMN elmasri.dependente.data_nascimento IS 'Data de nascimento do dependente.';
COMMENT ON COLUMN elmasri.dependente.parentesco IS 'Descrição do parentesco do dependente com o funcionário.';

-- Cria a tabela departamento:
CREATE TABLE departamento (
    numero_departamento INT         CONSTRAINT nn_dept_num_dept   NOT NULL,
    nome_departamento   VARCHAR(15) CONSTRAINT nn_dept_nome_dept  NOT NULL,
    cpf_gerente         CHAR(11)    CONSTRAINT nn_dept_cpf_gerent NOT NULL,
    data_inicio         DATE
);

COMMENT ON TABLE elmasri.departamento IS 'Tabela que armazena as informaçoẽs dos departamentos.';
COMMENT ON COLUMN elmasri.departamento.numero_departamento IS 'Número do departamento é a PK desta tabela.';
COMMENT ON COLUMN elmasri.departamento.nome_departamento IS 'Nome do departamento deve ser único.';
COMMENT ON COLUMN elmasri.departamento.cpf_gerente IS 'CPF do gerente do departamento é uma FK para a tabela funcionários.';
COMMENT ON COLUMN elmasri.departamento.data_inicio_gerente IS 'Data do início do gerente no departamento.';

-- Cria chaves da tabela departamento:
ALTER TABLE departamento ADD CONSTRAINT pk_departamento
PRIMARY KEY (numero_departamento);

ALTER TABLE departamento ADD CONSTRAINT fk_cpf_ger_cpf
FOREIGN KEY (cpf_gerente) REFERENCES funcionario (cpf);

-- ALTER TABLE departamento ADD CONSTRAINT un_dept_nome_dept
-- UNIQUE (nome_departamento);

CREATE UNIQUE INDEX uidx_dept_nome_dept ON departamento (nome_departamento);

-- Constraints adicionais para a tabela departamento:
ALTER TABLE departamento ADD CONSTRAINT ck_dept_num_dept
CHECK (numero_departamento >= 0);


-- Cria a tabela localizações do departamento:
CREATE TABLE localizacoes_departamento (
    numero_departamento INT         CONSTRAINT nn_loc_dept_num_dept NOT NULL,
    local               VARCHAR(15) CONSTRAINT nn_loc_dept_local    NOT NULL
);

-- Cria chaves da tabela localizações do departamento:
ALTER TABLE localizacoes_departamento ADD CONSTRAINT pk_localizacoes_dept
PRIMARY KEY (numero_departamento, local);

ALTER TABLE localizacoes_departamento ADD CONSTRAINT fk_num_dept_num_dept
FOREIGN KEY (numero_departamento) REFERENCES departamento (numero_departamento);

-- Cria a tabela projeto:
CREATE TABLE projeto (
    numero_projeto      INT         CONSTRAINT nn_proj_num_proj  NOT NULL,
    nome_projeto        VARCHAR(15) CONSTRAINT nn_proj_nome_proj NOT NULL,
    local_projeto       VARCHAR(15),
    numero_departamento INT         CONSTRAINT nn_proj_num_dept  NOT NULL
);

COMMENT ON TABLE elmasri.projeto IS 'Tabela que armazena as informações sobre os projetos dos departamentos.';
COMMENT ON COLUMN elmasri.projeto.numero_projeto IS 'Número do projeto é a PK desta tabela.';
COMMENT ON COLUMN elmasri.projeto.nome_projeto IS 'Nome do projeto deve ser único.';
COMMENT ON COLUMN elmasri.projeto.local_projeto IS 'Localização do projeto.';
COMMENT ON COLUMN elmasri.projeto.numero_departamento IS 'Número do departamento é uma FK para a tabela departamento.';
-- Cria chaves da tabela projeto:
ALTER TABLE projeto ADD CONSTRAINT pk_projeto
PRIMARY KEY (numero_projeto);

ALTER TABLE projeto ADD CONSTRAINT fk_proj_num_dept_num_dept
FOREIGN KEY (numero_departamento) REFERENCES departamento (numero_departamento);

CREATE UNIQUE INDEX uidx_proj_nome_proj ON projeto (nome_projeto);

-- Cria a tabela trabalha em:
CREATE TABLE trabalha_em (
    cpf_funcionario CHAR(11) CONSTRAINT nn_trab_em_cpf      NOT NULL,
    numero_projeto  INT      CONSTRAINT nn_trab_em_num_proj NOT NULL,
    horas           DECIMAL(3,1)
);

-- Cria chaves da tabela trabalha_em:
ALTER TABLE trabalha_em ADD CONSTRAINT pk_trabalha_em
PRIMARY KEY (cpf_funcionario, numero_projeto);

ALTER TABLE trabalha_em ADD CONSTRAINT fk_trab_em_cpf_func_cpf
FOREIGN KEY (cpf_funcionario) REFERENCES funcionario (cpf);

ALTER TABLE trabalha_em ADD CONSTRAINT fk_trab_em_num_proj_num_proj
FOREIGN KEY (numero_projeto) REFERENCES projeto (numero_departamento)

-- Constraints adicionais para a tabela trabalha em:
ALTER TABLE trabalha_em ADD CONSTRAINT ck_trab_em_horas
CHECK (horas >= 0);


-- Inserção de dados
INSERT INTO elmasri.funcionario (primeiro_nome, nome_meio, ultimo_nome, cpf, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento) 
	VALUES 
	('Jorge', 'E', 'Brito', '88866555576', '1937-11-10', 'Rua do Horto,35,São Paulo,SP', 'M', 55000, null, 1),
	('Fernando', 'T', 'Wong', '33344555587', '1955-12-08', 'Rua da Lapa,34,São Paulo,SP', 'M', 40000, '88866555576', 5),
	('João', 'B', 'Silva', '12345678966', '1965-01-09', 'Rua das Flores, 751, São Paulo,SP', 'M', 30000, '33344555587', 5),
	('Jennifer', 'S', 'Souza', '98765432168', '1941-06-20', 'Av. Arthur de Lima,54,SantoAndré,SP', 'F', 43000, '88866555576', 4),
	('Ronaldo', 'K', 'Lima', '66688444476', '1962-09-15', 'Rua Rebouças,65,Piracicaba,SP', 'M', 38000, '33344555587', 5),
	('Joice', 'A', 'Leite', '45345345376', '1972-07-31', 'Av. Lucas Obes,74,São Paulo,SP', 'F', 25000, '33344555587', 5),
	('André', 'V', 'Pereira', '98798798733', '1969-03-29', 'Rua Timbira,35,São Paulo,SP', 'M', 25000, '98765432168', 4),
	('Alice', 'J', 'Zelaya', '99988777767', '1968-01-19', 'Rua Souza Lima,35,Curitiba,PR', 'F', 25000, '98765432168', 4);

INSERT INTO elmasri.departamento (nome_departamento, numero_departamento, cpf_gerente, data_inicio) 
	VALUES
	('Pesquisa', 5, '33344555587', '1988-05-22'),
	('Administração', 4, '98765432168', '1995-01-01'),
	('Matriz', 1, '88866555576', '1981-06-19');
	
INSERT INTO  elmasri.localizacoes_departamento (numero_departamento, local) 
	VALUES
	(1, 'São Paulo'),
	(4, 'Mauá'),
	(5, 'Santo André'),
	(5, 'Itu'),
	(5, 'São Paulo');
	
INSERT INTO elmasri.projeto (nome_projeto, numero_projeto, local_projeto, numero_departamento)
	VALUES
	('ProdutoX', 1, 'Santo André', 5),
	('ProdutoY', 2, 'Itu', 5),
	('ProdutoZ', 3, 'São Paulo', 5),
	('Informatização', 10, 'Maué', 4),
	('Reorganização', 20, 'São Paulo', 1),
	('Novosbenefícios', 30, 'Mauá', 4);
	
INSERT INTO elmasri.dependente (cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
	VALUES
	('33344555587', 'Alicia', 'F', '1986-04-05', 'Filha'),
	('33344555587', 'Tiago', 'M', '1983-10-25', 'Filho'),
	('33344555587', 'Janaína', 'F', '1958-05-03', 'Esposa'),
	('98765432168', 'Antonio', 'M', '1942-02-28', 'Marido'),
	('12345678966', 'Michael', 'M', '1988-01-04', 'Filho'),
	('12345678966', 'Alicia', 'F', '1988-12-30', 'Filha'),
	('12345678966', 'Elizabeth', 'F', '1967-05-05', 'Esposa');
	
INSERT INTO elmasri.trabalha_em (cpf_funcionario, numero_projeto, horas)
	VALUES
	('12345678966', 1, 32.5),
	('12345678966', 2, 7.5),
	('66688444476', 3, 40.0),
	('45345345376', 1, 20.0),
	('45345345376', 2, 20.0),
	('33344555587', 2, 10.0),
	('33344555587', 3, 10.0),
	('33344555587', 10, 10.0),
	('33344555587', 20, 10.0),
	('99988777767', 30, 30.0),
	('99988777767', 10, 10.0),
	('98798798733', 10, 35.0),
	('98798798733', 30, 5.0),
	('98765432168', 30, 20.0),
	('98765432168', 20, 15.0),
	('88866555576', 20, null);
