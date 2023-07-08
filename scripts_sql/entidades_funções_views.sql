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
