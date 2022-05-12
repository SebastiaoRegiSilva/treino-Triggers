-- Criar banco de dados.
CREATE DATABASE minhaloja;

-- Usar o banco de dados.
USE minhaloja;

-- Criar tabela cliente.
CREATE TABLE CLIENTE(
    codcliente int,
    nome varchar(60),
    datanascimento date,
    cpf varchar(11),
    PRIMARY KEY(codcliente)
);

-- Criar tabela pedido.
CREATE TABLE PEDIDO(
    codpedido int,
    codcliente int,
    datapedido date,
    nf varchar(12),
    valortotal decimal(10, 2),
    PRIMARY KEY(codpedido),
    FOREIGN KEY(codcliente) REFERENCES CLIENTE(codcliente)
);

-- Criar tabela produto.
CREATE TABLE PRODUTO(
    codproduto int,
    descricao varchar(100),
    quantidade int,
    PRIMARY KEY(codproduto)
);

-- Criar tabela item pedido.
CREATE TABLE ITEMPEDIDO(
    codpedido int,
    numeroitem int,
    valorunitario decimal(10, 2),
    quantidade int,
    codproduto int,
    PRIMARY KEY(codpedido, numeroitem),
    FOREIGN KEY(codpedido) REFERENCES PEDIDO(codpedido),
    FOREIGN KEY(codproduto) REFERENCES PRODUTO(codproduto)
);

-- Criar a tabela log.
CREATE TABLE LOG(
    codlog INT auto_increment,
    data date,
    descricao varchar(255),
    PRIMARY KEY(codlog)
);

-- Criar tabela requisição compra.
CREATE TABLE REQUISICAO_COMPRA(
    codrequisicaocompra int,
    codproduto int,
    data date,
    quantidade int,
    PRIMARY KEY(codrequisicaocompra),
    FOREIGN KEY(codproduto) REFERENCES PRODUTO(codproduto)
);

-- Inserir dados na tabela cliente
INSERT INTO CLIENTE VALUES(1, 'Patrícia Marques', '1944-02-01', '77715541212');
INSERT INTO CLIENTE VALUES(2, 'Antonio Carlos da Silva', '1970-11-01', '12313345512');
INSERT INTO CLIENTE VALUES(3, 'Thiago Ribeiro', '1964-11-15', '12315544411');
INSERT INTO CLIENTE VALUES(4, 'Carlos Eduardo', '1924-10-25', '42515541212');
INSERT INTO CLIENTE VALUES(5, 'Maria Cristina Goes', '1981-11-03', '67715541212');
INSERT INTO CLIENTE VALUES(6, 'Ruan Manoel Fanjo', '1983-12-06', '32415541212');
INSERT INTO CLIENTE VALUES(7, 'Sylvio Barbon', '1984-12-05', '12315541212');

-- Inserir dados na tabela produto.
INSERT INTO PRODUTO VALUES(1, 'Mouse', 10);
INSERT INTO PRODUTO VALUES(2, 'Teclado', 10);
INSERT INTO PRODUTO VALUES(3, 'Monitor LCD', 10);
INSERT INTO PRODUTO VALUES(4, 'Caixas Acústicas', 10);
INSERT INTO PRODUTO VALUES(5, 'Scanner de Mesa', 10);

-- Inserir dados na tabela pedido.
INSERT INTO PEDIDO VALUES(1, 1, '2012-04-01', '00001', 400.00);
INSERT INTO PEDIDO VALUES(2, 2, '2012-04-01', '00002', 10.90);
INSERT INTO PEDIDO VALUES(3, 2, '2012-04-01', '00003', 21.80);
INSERT INTO PEDIDO VALUES(4, 3, '2012-05-01', '00004', 169.10);
INSERT INTO PEDIDO VALUES(5, 4, '2012-05-01', '00005', 100.90);
INSERT INTO PEDIDO VALUES(6, 6, '2012-05-02', '00006', 51.35);

-- Inserir dados na tabela item pedido.
INSERT INTO ITEMPEDIDO VALUES(1, 1, 10.90, 1, 1);
INSERT INTO ITEMPEDIDO VALUES(1, 2, 389.10, 1, 3);
INSERT INTO ITEMPEDIDO VALUES(2, 1, 10.90, 1, 1);
INSERT INTO ITEMPEDIDO VALUES(3, 1, 10.90, 1, 1);
INSERT INTO ITEMPEDIDO VALUES(4, 1, 10.90, 1, 1);
INSERT INTO ITEMPEDIDO VALUES(4, 2, 15.90, 2, 2);
INSERT INTO ITEMPEDIDO VALUES(4, 3, 25.50, 1, 4);
INSERT INTO ITEMPEDIDO VALUES(4, 4, 100.90, 1, 5);
INSERT INTO ITEMPEDIDO VALUES(5, 1, 100.90, 1, 5);
INSERT INTO ITEMPEDIDO VALUES(6, 1, 25.50, 2, 4);

/* 1) Crie  um  TRIGGER  para  baixar  o  estoque  de  um  PRODUTO  quando  ele  for vendido.*/

-- Criar a trigger.
-- Substituir o delimitador.
DELIMITER $$

CREATE TRIGGER Tgr_ItemPedido_Insert AFTER INSERT
ON ITEMPEDIDO
FOR EACH ROW
	BEGIN
		UPDATE PRODUTO p SET p.quantidade = p.quantidade - NEW.Quantidade WHERE codproduto = NEW.codproduto;
	END$$
 
 DELIMITER ;   

-- Verificando quantidade de produtos.
SELECT * FROM PRODUTO;

-- Testando a trigger.
INSERT INTO PEDIDO VALUES (7, 1, '1998-01-23', '00001', '6000.00');
-- Duas caixas acústicas.
INSERT INTO ITEMPEDIDO VALUES(7, 2, 11.25, 2, 4);
-- Dois scanners de mesa.
INSERT INTO ITEMPEDIDO VALUES(7, 3, 741.24, 2, 5);

/* 2) Crie um TRIGGER para criar um log dos CLIENTES modificados.*/

-- Criar a trigger.
-- Substituir o delimitador.
DELIMITER $$

CREATE TRIGGER Tgr_Cliente_Log_Modific_Insert AFTER INSERT
ON CLIENTE
FOR EACH ROW
	BEGIN
		-- Corrigir
        INSERT INTO LOG VALUES(LOG_SEQ.nextval, TO_DATE(SYSDATE), 'INSERINDO NOVO CLIENTE -', NEW.CPF);
	END$$
 
 DELIMITER ;   

-- Verificando tabela de logs.
SELECT * FROM LOG;

-- Dropar a trigger.
-- drop Trigger Tgr_Cliente_Log_Modific_Insert;

-- Cadastrar novo cliente.
INSERT INTO CLIENTE VALUES(8, 'Marcelo Barbosa', '1993-09-05', '12315542424');


/* 3) Crie um TRIGGER para criar um log dos PRODUTOS atualizados.*/

/* 4) Crie um TRIGGER para criar um log quando um ITEMPEDIDO for removido.*/

/* 5) Crie um TRIGGER para criar um LOG quando o valor total do pedido for maior que R$1000.*/
