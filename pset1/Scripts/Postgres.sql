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
    owner      = abrantes
    template   = template0
    encoding   = 'UTF-8'
    lc_collate = 'pt_br.UTF-8'
    lc_ctype   = 'pt_BR.UTF-8'
;

-- Conexão ao banco uvv com o usuário yuri:
\c "dbname=uvv user=clicia password=1234"

-- Cria o esquema Elamsri:
CREATE SCHEMA elmasri AUTHORIZATION clicia;

ALTER USER yuri 
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
COMMENT ON TABLE funcionario IS 'Tabela que armazena informações dos funcionários.';
COMMENT ON COLUMN funcionario.cpf IS '';
COMMENT ON COLUMN funcionario. IS '';
COMMENT ON COLUMN funcionario. IS '';
COMMENT ON COLUMN funcionario. IS '';
COMMENT ON COLUMN funcionario. IS '';
COMMENT ON COLUMN funcionario. IS '';

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


-- Cria a tabela departamento:
CREATE TABLE departamento (
    numero_departamento INT         CONSTRAINT nn_dept_num_dept   NOT NULL,
    nome_departamento   VARCHAR(15) CONSTRAINT nn_dept_nome_dept  NOT NULL,
    cpf_gerente         CHAR(11)    CONSTRAINT nn_dept_cpf_gerent NOT NULL,
    data_inicio         DATE
);

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


-- Inserção de dados
-- Tabela funcionário
INSERT INTO funcionario (primeiro_nome, nome_meio, ultimo_nome, cpf, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento) VALUES (
    'Jorge', 'E', 'Brito', '88866555576', '1937-11-10', 'Rua do Horto, 35, São Paulo, SP', 'M', 55000, null, null);