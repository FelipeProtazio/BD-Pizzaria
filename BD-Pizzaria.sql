use p1_pizzaria;
create table cliente (
codigo bigint (20),
nome VARCHAR (255),
documento VARCHAR (255),
telefone VARCHAR (255),
endereco VARCHAR (255)
);
alter table cliente add primary key (codigo);
insert into cliente(codigo, nome, documento, telefone, endereco)
values	(1, 'João Silva', '123.456.789-00', '(11) 98765-4321', 'Rua A, 123, São Paulo, SP'),
		(2, 'Maria Souza', '987.654.321-11', '(21) 99999-8888', 'Av. B, 456, Rio de Janeiro, RJ'),
		(3, 'Pedro Santos', '456.789.123-22', '(47) 3333-7777', 'Rua C, 789, Florianópolis, SC');
        
        
create table produto (
codigo bigint (20),
nome VARCHAR (255),
descritivo VARCHAR (255),
valor DOUBLE,
estoque bigint (20)
);
alter table produto add primary key (codigo);
insert into produto(codigo, nome, descritivo, valor, estoque)
VALUES
    (1, 'Pizza de Calabresa', 'Pizza de Calabresa com queijo, molho de tomate e azeitonas.', 35.00, 10),
    (2, 'Pizza de Frango com Catupiry', 'Pizza de Frango com Catupiry, queijo, molho de tomate e cebola.', 40.00, 15),
    (3, 'Pizza de Mussarela', 'Pizza de Mussarela com molho de tomate e orégano.', 30.00, 20);


create table entregador (
codigo bigint (20),
nome VARCHAR (255),
documento VARCHAR (255),
telefone VARCHAR(255)
);
alter table entregador add primary key (codigo);
insert into entregador(codigo, nome, documento, telefone)
VALUES
    (1, 'João Silva', '123.456.789-00', '(11) 98765-4321'),
    (2, 'Maria Souza', '987.654.321-11', '(21) 99999-8888'),
    (3, 'Pedro Santos', '456.789.123-22', '(47) 3333-7777');



create table pedido(
codigo bigint(20),
data_pedido DATE,
valor_total DOUBLE,
valor_entrega DOUBLE,
entregue BOOLEAN,
cliente_codigo bigint (20),
entregador_codigo bigint (20),
item_codigo_item bigint (20)
);

alter table pedido add primary key (codigo);
alter table pedido add foreign key (codigo) references cliente(codigo);
alter table pedido add foreign key (codigo) references entregador(codigo);
alter table pedido add foreign key (codigo) references item(codigo_item);

insert into pedido(codigo,data_pedido,valor_total,valor_entrega, entregue, cliente_codigo, entregador_codigo, item_codigo_item)
VALUES
    (1, '2023-04-11',70.00, 5.00, false, 1, 1, 1),
    (2, '2023-04-11',115.00, 10.00, false, 2, 2, 2),
    (3, '2023-04-11',90.00, 7.00, false, 3, 3, 3);
    

create table item(
codigo_item bigint(20),
quantidade INT(255),
valor_unitario DOUBLE,
produto_codigo bigint(20)
);
alter table item add primary key (codigo_item);
alter table item add foreign key (codigo_item) references produto(codigo);

insert into item(codigo_item,quantidade,valor_unitario,produto_codigo)
VALUES
    (1, 2, 35.00, 1),
    (2, 3, 40.00, 2),
    (3, 1, 30.00, 3);
    
    -- 3-Altereo estoque da tabela produto somando +20%e de um desconto de 10%em todos os produtos
    UPDATE produto
	SET estoque = ROUND(estoque * 1.2),
	valor = ROUND(valor * 0.9, 2);
    
    -- 4-Exiba o total, media, menor e maior valor_total de todos os pedidos agrupados 
    SELECT 
		SUM(valor_total) AS total,
		AVG(valor_total) AS media,
		MIN(valor_total) AS menor,
		MAX(valor_total) AS maior
	FROM pedido;
    
    -- 5-Agrupe por cliente a quantidadetotal de pedidos feitos, soma dos valores: mostre o nome e telefone dos clientes ordenando por nome (0.5)
    SELECT c.nome, c.telefone, COUNT(p.codigo) AS quantidadetotal_pedidos, SUM(p.valor_total) AS soma_valores
	FROM cliente c
	LEFT JOIN pedido p ON c.codigo = p.cliente_codigo
	GROUP BY c.codigo
	ORDER BY c.nome;


    -- 6-Agrupe por entregadoro valor de entregatotal de pedidos feitos: mostre o nome e telefone dos entregadoresordenando por nome (0.5)
    SELECT e.nome, e.telefone, SUM(p.valor_entrega) AS entregatotal
	FROM entregador e
	JOIN pedido p ON e.codigo = p.entregador_codigo
	GROUP BY e.nome, e.telefone
	ORDER BY e.nome;
    
    
    -- 7-Exiba quais os produtos mais vendidos, mostre o nome do produtoequantidade vendida ordenepor quantidade vendida decrescente(0.5)
    SELECT p.nome AS nome_produto, SUM(i.quantidade) AS quantidade_vendida
	FROM item i
	JOIN produto p ON i.produto_codigo = p.codigo
	GROUP BY i.produto_codigo
	ORDER BY quantidade_vendida DESC;
    
    -- 8-Mostre todos os produtos que ainda não foram vendidos(0.5)
    SELECT *
	FROM produto
	LEFT JOIN item ON produto.codigo = item.produto_codigo
	WHERE item.codigo_item IS NULL;

    
   -- 9-Mostre uma consulta unificada das tabelas cliente e entregador mostrando o nome, documento e telefone ordenados pelo nome (0.5)
  SELECT nome, documento, telefone
	FROM cliente
	UNION ALL
	SELECT nome, documento, telefone
	FROM entregador
	ORDER BY nome;
