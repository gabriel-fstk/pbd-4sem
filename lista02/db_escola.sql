-- psql -U postgres

DROP DATABASE IF EXISTS escola;

-- Criar o banco de dados
CREATE DATABASE escola;

-- Conectar ao banco de dados
\c escola;

-- Criar a tabela de alunos
CREATE TABLE alunos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    data_nascimento DATE NOT NULL
);

-- Criar a tabela de professores
CREATE TABLE professores (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    especialidade VARCHAR(100)
);

-- Criar a tabela de cursos
CREATE TABLE cursos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    professor_id INT REFERENCES professores(id)
);

-- Criar a tabela de matrículas
CREATE TABLE matriculas (
    id SERIAL PRIMARY KEY,
    aluno_id INT REFERENCES alunos(id),
    curso_id INT REFERENCES cursos(id),
    data_matricula DATE NOT NULL
);


-- INSERTS (seeds)

-- Inserir alunos
INSERT INTO alunos (nome, data_nascimento) VALUES 
('Ana Silva', '2010-05-15'),
('Pedro Oliveira', '2011-08-20'), 
('Lucas Santos', '2009-12-01'),
('Mariana Costa', '2012-03-25');

-- Inserir professores
INSERT INTO professores (nome, especialidade) VALUES 
('Maria Fernanda', 'Matemática'),
('Carlos Alberto', 'História'),
('Fernanda Lima', 'Ciências'),
('Joaquim Ribeiro', 'Arte');

-- Inserir cursos
INSERT INTO cursos (nome, descricao, professor_id) VALUES 
('Matemática Básica', 'Curso introdutório de matemática', 1),
('História do Brasil', 'Estudo da história do Brasil', 2),
('Ciências Naturais', 'Exploração das ciências da natureza', 3),
('Arte e Criatividade', 'Desenvolvimento de habilidades artísticas', 4);

-- Inserir matrículas
INSERT INTO matriculas (aluno_id, curso_id, data_matricula) VALUES 
(1, 1, '2023-01-15'),
(1, 3, '2023-01-20'),
(2, 2, '2023-01-17'),
(3, 1, '2023-01-22'),
(4, 4, '2023-01-18');
