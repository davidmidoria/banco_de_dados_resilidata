/* pergunta número um */

-- selecionar todos estudantes 

select *  from tb_estudante

-- saber seu numero total
select count(id_estudante) from tb_estudante

-- saber numero total de estudantes ativos

select count(id_estudante) from tb_estudante where  status_estudante ='ativo'
