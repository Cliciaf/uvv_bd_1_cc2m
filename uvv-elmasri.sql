--Criando a role
CREATE ROLE clicia  WITH 
      SUPERUSER
      CREATEDB 
      CREATEROLE
      INHERIT
      LOGIN
      NOREPLICATION 
      BYPASSRLS
      ALLOW_CONNECTIONS  true
      PASSWORD '1234' 

--Criando o banco de dados uvv
CREATE DATABASE uvv2
     WITH
      OWNER  clicia 
      TEMPLATE  template0 
      ENCODING  'UTF8'
      LC_COLLATE  'pt_BR.UTF-8' 
      LC_CTYPE  'pt_BR.UTF-8' 
      ALLOW_CONNECTIONS  true;
-- Criando o schema elmasri
CREATE SCHEMA IF NOT EXISTS elmasri
    AUTHORIZATION clicia;
    -- trocando para o schema elmasri
ALTER USER clicia
SET SEARCH_PATH TO elmasri, 'clicia', public;

-- Criando as relações do schema
CREATE TABLE uvv2.elmasri.funcionario (
                cpf CHAR(11) NOT NULL,
                primeiro_nome VARCHAR(15) NOT NULL,
                nome_meio CHAR(1),
                ultimo_nome VARCHAR(15) NOT NULL,
                data_nascimento DATE,
                endereco VARCHAR(30),
                sexo CHAR(1),
                salario NUMERIC(10,2),
                cpf_supervisor CHAR(11) NOT NULL,
                numero_departamento INTEGER NOT NULL,
                CONSTRAINT funcionario_pk PRIMARY KEY (cpf)
);


CREATE TABLE uvv2.elmasri.departamento (
                numero_departamento INTEGER NOT NULL,
                nome_departamento VARCHAR(15) NOT NULL,
                cpf_gerente CHAR(11) NOT NULL,
                data_inicio_gerente DATE,
                CONSTRAINT departamento_pk PRIMARY KEY (numero_departamento)
);


CREATE UNIQUE INDEX departamento_idx
 ON uvv2.elmasri.departamento
 ( nome_departamento );

CREATE TABLE uvv2.elmasri.projeto (
                numero_projeto INTEGER NOT NULL,
                nome_projeto VARCHAR(15) NOT NULL,
                local_projeto VARCHAR(15),
                numero_departamento INTEGER NOT NULL,
                CONSTRAINT projeto_pk PRIMARY KEY (numero_projeto)
);


CREATE UNIQUE INDEX projeto_idx
 ON uvv2.elmasri.projeto
 ( nome_projeto );

CREATE TABLE uvv2.elmasri.localizacoes_departamento (
                numero_departamento INTEGER NOT NULL,
                local VARCHAR(15) NOT NULL,
                CONSTRAINT localizacoes_departamento_pk PRIMARY KEY (numero_departamento, local)
);


CREATE TABLE uvv2.elmasri.dependente (
                cpf_funcionario CHAR(11) NOT NULL,
                nome_dependente VARCHAR(15) NOT NULL,
                sexo CHAR(1),
                data_nascimento DATE,
                parentesco VARCHAR(15),
                CONSTRAINT dependente_pk PRIMARY KEY (cpf_funcionario, nome_dependente)
);
CREATE TABLE uvv2.elmasri.trabalha_em (
                cpf_funcionario CHAR(11) NOT NULL,
                numero_projeto INTEGER NOT NULL,
                horas NUMERIC(3,1) NOT NULL,
                CONSTRAINT trabalha_em_pk PRIMARY KEY (cpf_funcionario, numero_projeto)
);

-- Adicionando pk, fk e constraint
ALTER TABLE uvv2.elmasri.trabalha_em ADD CONSTRAINT funcionario_trabalha_em_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES uvv2.elmasri.funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE uvv2.elmasri.dependente ADD CONSTRAINT funcionario_dependente_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES uvv2.elmasri.funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE uvv2.elmasri.funcionario ADD CONSTRAINT funcionario_funcionario_fk
FOREIGN KEY (cpf_supervisor)
REFERENCES uvv2.elmasri.funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE uvv2.elmasri.departamento ADD CONSTRAINT funcionario_departamento_fk
FOREIGN KEY (cpf_gerente)
REFERENCES uvv2.elmasri.funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE uvv2.elmasri.localizacoes_departamento ADD CONSTRAINT departamento_localizacoes_departamento_fk
FOREIGN KEY (numero_departamento)
REFERENCES uvv2.elmasri.departamento (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE uvv2.elmasri.projeto ADD CONSTRAINT departamento_projeto_fk
FOREIGN KEY (numero_departamento)
REFERENCES uvv2.elmasri.departamento (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE uvv2.elmasri.trabalha_em ADD CONSTRAINT projeto_trabalha_em_fk
FOREIGN KEY (numero_projeto)
REFERENCES uvv2.elmasri.projeto (numero_projeto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;