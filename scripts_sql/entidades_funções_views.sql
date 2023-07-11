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
