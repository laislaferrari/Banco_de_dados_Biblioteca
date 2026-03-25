/* Atividade de Banco de Dados Empréstimo de Livros (Pontuação:10)

Desenvolver um banco de dados para empréstimos de livros
Um livro possui um determinado autor e o autor poderá publicar diversos
livros. Um determinado livro (título) poderá ser emprestado para vários
usuários e usuário pode pegar empréstimo de vários livros.
Fazer o uso da integridade referencial:

Quando apagarmos um autor automaticamente deverão ser excluídos todos
os seus livros. 
Quando tentarmos atualizar o id_autor do autor essa
operação não deverá ser permitida caso tenha algum livro cadastrado para
este autor.

Montar o diagrama conceitual, lógico e físico.
Tabelas (modelo físico)
autor
id_autor (serial)
nome
livro
id_livro (serial)
titulo
id_autor (foreign key)
usuario
id_usuario
nome
email (unique)
emprestimo
id_emprestimo
data_emprestimo
data_devolucao
valor_emprestimo
id_usuario (foreign key)
id_livro (foreign key)


*/ 
create database Biblioteca;

drop table emprestimo cascade;
drop table autor cascade;
drop table livro cascade;
drop table usuario cascade;

create table autor (
    id_autor serial primary key,
    nome varchar(100) not null
);

create table livro (
    id_livro serial primary key,
    titulo varchar(150) not null,
   	id_autor int references autor(id_autor)
    on delete cascade
    on update no action  
);

create table usuario (
    id_usuario serial primary key,
    nome varchar(100) not null,
    email varchar(100) unique not null
);

create table  emprestimo (
    id_emprestimo serial primary key,
    data_emprestimo date not null,
    data_devolucao date,
    valor_emprestimo numeric(6,2) not null,
    id_usuario int references usuario(id_usuario),
    id_livro int references livro(id_livro)
);

--Popular as tabelas com informações usando o comando insert.

insert into autor (nome) values
    ('Machado de Assis'),
    ('Clarice Lispector'),
    ('Jorge Amado'),
    ('Graciliano Ramos');

insert into  livro (titulo, id_autor) values
    ('Dom Casmurro', 1),
    ('Memórias Póstumas de Brás Cubas', 1),
    ('A Hora da Estrela', 2),
    ('Capitães da Areia', 3),
    ('São Bernardo', 4);

insert into usuario (nome, email) values
    ('Ana Souza', 'ana.souza@email.com'),
    ('Bruno Lima', 'bruno.lima@email.com'),
    ('Carla Alves', 'carla.alves@email.com');

insert into emprestimo (data_emprestimo, data_devolucao, valor_emprestimo, id_usuario, id_livro) values
    ('2024-05-01', '2024-05-15', 10.00, 1, 1),
    ('2024-05-03', '2024-05-17', 12.50, 2, 2),
    ('2024-05-10', NULL, 9.00, 1, 4),
    ('2024-05-12', NULL, 14.00, 3, 5);

select * from livro;

--DQL

--1) Retornar os livros emprestados.

select l.titulo from livro l
join emprestimo e on l.id_livro = e.id_livro;

--2) Retornar os livros que não foram emprestados.

select titulo from livro l 
left join emprestimo e on l.id_livro = e.id_livro
where e.id_emprestimo is null;

--3) Contar quantos livros foram emprestados.

select count(*) as livros_emprestados from emprestimo;

--4) A quantidade de livros que cada autor tem.

select a.nome, count(l.id_livro) as quantidade_livros
from autor a
left join livro l on a.id_autor = l.id_autor
group by a.nome;

--5) Exibir os livros do mais caro ao mais barato em ordem.

select l.titulo, max(e.valor_emprestimo) as maior_valor_ultimo_emprestimo
from livro l
left join emprestimo e on l.id_livro = e.id_livro
group by l.id_livro, l.titulo
order by maior_valor_ultimo_emprestimo desc nulls last;

--6) Apagar um autor consequentemente seu livro deverá ser automaticamente apagado.

delete from autor where id_autor = 2;
-- adicionado o on delete cascade na fase de DDL

--7) Mostra o total arrecado em empréstimo de um determinado livro

select l.titulo, sum(e.valor_emprestimo) as valor_arrecadado from livro l
join emprestimo e on l.id_livro = e.id_livro
where l.id_livro = 1
group by l.titulo;


