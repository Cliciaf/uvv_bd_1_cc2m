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

      