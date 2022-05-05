/* 
	Exercício para treino de uso de uma trigger junto com um banco mocado para aprendizagem.
*/
-- Criar banco de dados.
CREATE DATABASE supermercado;

-- Utilizar  o banco de dados.
USE supermercado;

-- Criar tabela.
CREATE TABLE Produtos(​
	Referencia VARCHAR(3) PRIMARY KEY,​
	Descricao VARCHAR(50) UNIQUE,​
	Estoque INT NOT NULL DEFAULT 0​
);​

-- Realizar inserções na tabela.
INSERT INTO Produtos VALUES ('001', 'Feijão', 10);​
INSERT INTO Produtos VALUES ('002', 'Arroz', 5);​
INSERT INTO Produtos VALUES ('003', 'Farinha', 15);​

-- Criar tabela.
CREATE TABLE ItensVenda (​
	Venda INT,​
	Produto VARCHAR(3),​
	Quantidade INT​
);​

-- Criar a Trigger
DELIMITER $$

-- Criar Trigger.
CREATE TRIGGER Tgr_ItensVenda_Insert AFTER INSERT
ON ItensVenda
FOR EACH ROW
	BEGIN
		UPDATE Produtos SET Estoque = Estoque - NEW.Quantidade
		WHERE Referencia = NEW.Produto;
	END$$

-- Criar trigger.
CREATE TRIGGER Tgr_ItensVenda_Delete AFTER DELETE
ON ItensVenda
FOR EACH ROW
	BEGIN
		UPDATE Produtos SET Estoque = Estoque + OLD.Quantidade
		WHERE Referencia = OLD.Produto;
	END$$

-- Delimiter padrão.
DELIMITER ;

-- Chamar uma trigger.
SELECT * FROM Tgr_ItensVenda_Insert;

-- Chamar outra trigger,
SELECT * FROM Tgr_ItensVenda_Delete;