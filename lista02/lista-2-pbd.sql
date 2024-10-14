
-- EXTRA: 1 20 8
-- 1. Listar todos os alunos
CREATE OR REPLACE FUNCTION listar_alunos() RETURNS TABLE(id INT, nome VARCHAR, data_nascimento DATE) AS $$
BEGIN
    RETURN QUERY SELECT * FROM alunos;
END;
$$ LANGUAGE 'plpgsql';

-- 2. Listar todos os cursos
CREATE OR REPLACE FUNCTION listar_cursos() RETURNS TABLE(id INT, nome VARCHAR, descricao TEXT, professor_id INT) AS $$
BEGIN
    RETURN QUERY SELECT * FROM cursos;
END;
$$ LANGUAGE 'plpgsql';

-- 3.  Listar todas as matrículas de um aluno
CREATE OR REPLACE FUNCTION listar_matriculas_aluno(aluno_id_aux INT) RETURNS TABLE(matricula_id_aux INT, nome_aluno_aux VARCHAR, data_matricula_aux DATE) AS $$
BEGIN
    RETURN QUERY SELECT
                    matriculas.id AS matricula_id_aux,
                    alunos.nome AS nome_aluno_aux,
                    matriculas.data_matricula AS data_matricula_aux
                 FROM matriculas
                 LEFT JOIN alunos ON   
                 matriculas.aluno_id = alunos.id 
                 WHERE matriculas.aluno_id = aluno_id_aux;
END;
$$ LANGUAGE 'plpgsql';

-- 4. Listar todos os professores
CREATE OR REPLACE FUNCTION listar_professores() RETURNS TABLE(id INT, nome VARCHAR, especialidade VARCHAR) AS $$
BEGIN
    RETURN QUERY SELECT * FROM professores;
END;
$$ LANGUAGE 'plpgsql';

-- 5. Atualizar a especilidade de um professor
CREATE OR REPLACE FUNCTION atualizar_especialidade_professor(professor_id INT, nova_especialidade VARCHAR) RETURNS VOID AS $$
BEGIN 
    UPDATE professor SET especialidade = nova_especialidade WHERE id = professor_id;
END;
$$ LANGUAGE 'plpgsql';

-- 6. Deletar um curso pelo ID
CREATE OR REPLACE FUNCTION deletar_curso(curso_id INT) RETURNS VOID $$
BEGIN  
    DELETE FROM cursos WHERE id = curso_id;
END;
$$ LANGUAGE 'plpgsql';

-- 7. Listar todos os alunos matriculados em um curso
CREATE OR REPLACE FUNCTION listar_alunos_curso(curso_id INT) RETURNS TABLE(id INT, nome VARCHAR, descricao VARCHAR) AS $$
BEGIN
    RETURN QUERY SELECT * FROM alunos
                 LEFT JOIN matriculas ON
                    alunos.id = matriculas_aluno_id
                 LEFT JOIN cursos ON
                    matriculas.curso_id = cursos.id
                WHERE matriculas.curso_id = curso_id;
$$ LANGUAGE 'plpgsql';


-- 8. Contar o número de alunos em um curso
CREATE OR REPLACE FUNCTION contar_alunos_curso(curso_id_aux INT) RETURNS INT AS $$
DECLARE
    total_alunos INT;
BEGIN
    SELECT COUNT(*) INTO total_alunos FROM matriculas WHERE curso_id = curso_id_aux;
    RETURN total_alunos;
END;
$$ LANGUAGE 'plpgsql';

-- 9. Listar todos os cursos de um professor
CREATE OR REPLACE FUNCTION listar_cursos_professor() RETURNS TABLE(id_professor_aux INT, professor_nome_aux VARCHAR, curso_nome_aux VARCHAR, curso_descricao_aux TEXT) AS $$
BEGIN
    RETURN QUERY SELECT
                 cursos.professor_id AS id_professor_aux,
                 professores.nome AS professor_nome_aux,
                 cursos.nome AS curso_nome_aux,
                 cursos.descricao AS curso_descricao_aux
                 FROM cursos 
                 LEFT JOIN professores ON
                    cursos.professor_id = professores.id;
END;
$$ LANGUAGE plpgsql;

-- 10. Calcular a idade média dos alunos
CREATE OR REPLACE FUNCTION idade_media_alunos() RETURNS FLOAT AS $$
DECLARE
    media_idade FLOAT;
BEGIN
    SELECT AVG(EXTRACT(YEAR FROM AGE(data_nascimento))) INTO media_idade FROM alunos;
    RETURN media_idade;
END;
$$ LANGUAGE 'plpgsql';

-- 11. Listar todos os cursos com mais de um determinado número de alunos matriculados
CREATE OR REPLACE FUNCTION listar_cursos_com_mais_de(alunos_min INT) RETURNS TABLE(id INT, nome VARCHAR, descricao TEXT) AS $$
BEGIN
 RETURN QUERY SELECT 
                cursos.id,
                cursos.nome,
                cursos.descricao 
            FROM cursos
            JOIN (
                    SELECT curso_id, COUNT(*) AS total
                    FROM matriculas
                    GROUP BY curso_id
                    HAVING COUNT(*) > alunos_min
                 ) matriculas ON 
                    cursos.id = matriculas.curso_id;
END;
$$ LANGUAGE 'plpgsql';

-- 11.1 using RAISE NOTICE

CREATE OR REPLACE FUNCTION listar_cursos_com_mais_de_x_alunos(alunos_min INT) AS $$
DECLARE 
    rec RECORD;
BEGIN
 FOR rec IN SELECT 
                cursos.id,
                cursos.nome,
                cursos.descricao 
            FROM cursos
            JOIN (
                    SELECT curso_id, COUNT(*) AS total
                    FROM matriculas
                    GROUP BY curso_id
                    HAVING COUNT(*) > alunos_min
                 ) matriculas ON 
                    cursos.id = matriculas.curso_id
                LOOP
        RAISE NOTICE '[%] - % | %', rec.id, rec.nome, rec.descricao;
 END LOOP;
END;
$$ LANGUAGE 'plpgsql';

-- 20. Listar todos os cursos ministrados por um professor específico
CREATE OR REPLACE FUNCTION listar_cursos_por_professor(professor_id_aux INT) RETURNS TABLE(id_professor_aux INT, professor_nome_aux VARCHAR, curso_nome_aux VARCHAR, curso_descricao_aux TEXT) AS $$
BEGIN
    RETURN QUERY SELECT
                 cursos.professor_id AS id_professor_aux,
                 professores.nome AS professor_nome_aux,
                 cursos.nome AS curso_nome_aux,
                 cursos.descricao AS curso_descricao_aux
                 FROM cursos 
                 LEFT JOIN professores ON
                    cursos.professor_id = professores.id
                 WHERE cursos.professor_id = professor_id_aux;
END;
$$ LANGUAGE 'plpgsql';