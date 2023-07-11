-- estrutura das views se encontram junto a tabela
/* questão número um */

-- não foi criada uma view nesse caso por não entender muito bem a pergunta

-- selecionar todos estudantes 

select *  from tb_estudante

-- saber seu numero total
select count(id_estudante) as estudantes from tb_estudante

-- saber numero total de estudantes ativos

select count(id_estudante) as estudantes_ativos from tb_estudante where  status_estudante ='ativo'

-------------------------------------------------------------------------------------
/* questão numero dois */

-- facilitadores que atuam em mais de uma turma atualmente
select * from view_facilitador 

------------------------------------------------------
/* questão numero três*/
-- view com percentual de evasao por turma
select * from percentual_evasao

---------------------------------------------------
/*questão numero quatro*/

/* a questão numero três foi respondida a partir de informações da entidade log estudante que receberão suas entidades atraves de uma trigger*/



/* questão numero cinco */
/*  uma indicação baseada em quais facilitadores estão aptos a dar determinados cursos com base em sua especialidades
frente as especialidades ensinados no curso */

SELECT *  from facilitadores_aptos  

/* questão numero 6 (extra)*/

/*  todas as informações da turma quantidade de alunos curso  e mais .*/
SELECT * from informacoes_turma    

