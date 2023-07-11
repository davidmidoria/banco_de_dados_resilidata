-- tabela para armazenar informacoes de estudante 
create Table tb_estudante (
  id_estudante serial primary key,
  nome varchar(100) not null,
  cpf varchar(14) not null,
  data_nascimento date not null,
  endereco varchar(200),
  telefone varchar(20),
  email varchar(100),
  status_estudante varchar(20) default 'ativo',
  data_matricula date,
  data_atualizacao date
);

-- tabela para armazenar informacoes principais da turma

create Table tb_turma (
  id_turma serial primary key,
  nome varchar(100) not null,
  data_inicio date  not null,
  data_termino date not null
);

-- tabela para armazenar de que turma o estudante faz parte foi escolhido uma entidade
-- para armazenar uma ligacao por motivo de que um estudante poder fazer mais de um curso e um curso possuir
--varios estudantes

create table tb_estudante_turma(
id_estudante_turma serial primary key,
id_estudante int,
id_turma int,
unique(id_estudante,id_turma),
foreign key (id_estudante) references tb_estudante(id_estudante),
foreign key (id_turma) references tb_turma(id_turma)
);

-- informacoes facilitadores

create Table tb_facilitadores (
  id_facilitador serial primary key,
  nome varchar(100) not null,
  cpf varchar(14) not null,
  data_nascimento date not null,
  endereco varchar(200) not null,
  telefone varchar(20) not null,
  email varchar(100) not null
  );
-- foi decidido que o facilitador possui as habilidades para dar determinadas aulas e os modulos precisam
-- dar essas aulas, para criar essa ligacao foi feita a tb_especialidade que pode ser tanto o conteudo do modulo
-- quanto o conteudo que o facilitador esta apto a dar aula.  

create Table tb_especialidade (
id_especialidade serial primary key,
nome varchar(100) not null,
skill varchar(10) not null
);

-- criacao da interligacao entre especialidade e facilitador

create table tb_especialidade_facilitador(
id_especialidade_facilitador serial primary key,
id_especialidade int not null,
id_facilitador int not null,
unique (id_especialidade,id_facilitador),
foreign key (id_facilitador) references tb_facilitadores(id_facilitador),
foreign key (id_especialidade) references tb_especialidade(id_especialidade)
);


-- curso possui nome do curso sua descricao e o tempo dele em horas

create Table tb_curso(
  id_curso serial primary key,
  nome varchar(100) not null,
  descricao varchar(200),
  carga_horaria interval
);

-- possui os diversos cursos seu numero de modulos conteudo dado a cada modulo e a sua 
--skill que pode ser soft ou tech 

create Table tb_modulo(
  id_modulo serial primary key,
  numero_modulo int not null,
  id_especialidade int,
  skill varchar(10),
  id_curso int,
  unique(id_especialidade,id_curso),
  unique(numero_modulo,id_curso,skill),
  foreign key (id_especialidade) references tb_especialidade(id_especialidade),
  foreign key (id_curso)references tb_curso(id_curso)
 );

--uniao entre todos os aspectos da entidade foi criada pelo motivo de uma mesma turma poder possuir um ou
-- mais facilitadores, por exemplo o facilitador do modulo nao necessariamente e o do proximo modulo,
-- nessa entidade tambem se une a turma ao seu modulo

create Table tb_facilitador_modulo_turma(
  id_ftm serial primary key,
  id_facilitador int,
  id_turma int,
  id_modulo int,
  status_modulo varchar(10),
  unique(id_facilitador,id_turma,id_modulo),
  foreign key (id_facilitador) references tb_facilitadores(id_facilitador),
  foreign key(id_turma) references tb_turma(id_turma),
  foreign key (id_modulo) references tb_modulo(id_modulo)
);

--  registro do status do estudante e sua turma

create table log_estudante(
    id serial primary key,
    id_estudante int,
    id_turma int,
    data_evasao date,
    foreign key (id_estudante) references tb_estudante(id_estudante),
    foreign key (id_turma) references tb_turma(id_turma)
);

-- criada para o log do estudante no intuito de que certos procedimentos fossem feitos caso houvesse a 
--evasao de estudante, por exemplo caso o estudante se inative de sua turma o registro dele e retirado automaticamente da turma


CREATE or replace function funcao_estudante()
    returns  trigger as
        $$
        DECLARE 
            turma int;
            begin
                if old.status_estudante <> new.status_estudante then
                	select id_turma into turma from tb_estudante_turma where id_estudante=old.id_estudante;
                    insert into log_estudante(id_estudante,id_turma,data_evasao)
                    values
                    (old.id_estudante,turma,new.data_atualizacao);
                    DELETE FROM tb_estudante_turma WHERE id_estudante = old.id_estudante;
                end if;
    return null;
    end;
    $$ language 'plpgsql';

-- trigger do log_estudante

create trigger my3_tri
after update on tb_estudante
for each row execute
procedure funcao_estudante();

--  devolve uma string contendo o percentual de evasão do curso

CREATE OR REPLACE FUNCTION percentual(id_tur INT)
  RETURNS TEXT AS $$
DECLARE
  numero_desistentes INT;
  valor_percentual REAL;
BEGIN
  SELECT COUNT(id_estudante) INTO numero_desistentes FROM log_estudante WHERE id_turma = id_tur;
  valor_percentual := numero_desistentes *10 / 3 ;
  RETURN CONCAT(CAST(valor_percentual AS TEXT), '%');
END;
$$ LANGUAGE plpgsql;

-- uma visualização do  codigo  que contém  o percetual de evasão do curso dividido por turma

create or replace view  percentual_evasao as 
select distinct(id_turma),percentual( id_turma) from log_estudante;
create or replace view view_facilitador as 
SELECT tf.nome, count(distinct fmt.id_turma) as numero_de_turmas
FROM tb_facilitadores tf 
JOIN tb_facilitador_modulo_turma fmt
ON tf.id_facilitador = fmt.id_facilitador 
WHERE fmt.status_modulo = 'ABERTO'
GROUP BY tf.nome
having count(distinct fmt.id_turma)>1;

--  uma visualização contendo os facilitadores aptos a dar determinados cursos

create or replace view facilitadores_aptos as 
SELECT f.nome as facilitador,c.nome as curso,m.skill
from tb_especialidade_facilitador ef 
JOIN tb_modulo m 
on m.id_especialidade = ef.id_especialidade
JOIN tb_curso C
ON c.id_curso = m.id_curso
JOIN tb_facilitadores f 
on f.id_facilitador = ef.id_facilitador 
GROUP BY f.nome,c.nome,m.skill 
having count(f.nome)>=6 
ORDER BY c.nome;

-- função criada para concatenar facilitadores soft e tech 

CREATE OR REPLACE FUNCTION facilitadores(id_tur int)
  RETURNS TEXT AS $$
DECLARE
  tech text;
  soft text;
BEGIN
  SELECT nome INTO tech FROM tb_facilitadores WHERE id_facilitador
  in(select distinct(id_facilitador) from tb_facilitador_modulo_turma where id_turma=id_tur and id_modulo in
	 (select id_modulo from tb_modulo where skill='HARD') );
  SELECT nome INTO soft FROM tb_facilitadores WHERE  id_facilitador
  in(select distinct(id_facilitador) from tb_facilitador_modulo_turma where id_turma=id_tur and id_modulo in
	 (select id_modulo from tb_modulo where skill<>'HARD') );
   
   
  RETURN CONCAT(tech,',',soft);
END;
$$ LANGUAGE plpgsql;

-- uma view que contém algumas informações da turma que estavam espalhadas por algumas entidades

create or replace view informacoes_turma as  
select et.id_turma,count(distinct e.id_estudante)
as alunos,c.nome as curso ,t.data_inicio,t.data_termino,facilitadores(et.id_turma)
from tb_estudante e
left join tb_estudante_turma et
on e.id_estudante=et.id_estudante
left join tb_turma t
on et.id_turma = t.id_turma
left join tb_facilitador_modulo_turma fmt
on t.id_turma=fmt.id_turma
left join tb_modulo m
on m.id_modulo=fmt.id_modulo
left join tb_curso c
on c.id_curso= m.id_curso
group by et.id_turma,t.data_inicio,t.data_termino,c.nome;

