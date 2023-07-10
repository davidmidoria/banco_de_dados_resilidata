/* pergunta número um */

-- selecionar todos estudantes 

select *  from tb_estudante

-- saber seu numero total
select count(id_estudante) from tb_estudante

-- saber numero total de estudantes ativos

select count(id_estudante) from tb_estudante where  status_estudante ='ativo'

/* pergunta numero dois */

-- facilitadores que atuam em mais de uma turma atualmente

SELECT tf.nome, count(distinct fmt.id_turma) as numero_de_turmas
FROM tb_facilitadores tf 
JOIN tb_facilitador_modulo_turma fmt
ON tf.id_facilitador = fmt.id_facilitador 
WHERE fmt.status_modulo = 'ABERTO'
GROUP BY tf.nome
having count(distinct fmt.id_turma)>1; 
