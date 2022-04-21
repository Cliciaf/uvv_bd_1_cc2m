-- Criando o schema elmasri
CREATE SCHEMA IF NOT EXISTS elmasri
    AUTHORIZATION clicia;

-- trocando para o schema elmasri
ALTER USER clicia
SET SEARCH_PATH TO elmasri, 'clicia', public;
