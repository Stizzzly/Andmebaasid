create database aleksandrTIT;
use aleksandrTIT;
--tabel, mida automaatselt täidab triger
CREATE TABLE logi(
id int primary key identity(1,1),
tegevus varchar(25),
kasutaja varchar(25),
aeg datetime,
andmed TEXT
)
--tabel, millega töötab kasutaja
CREATE TABLE puud(
puuID int primary key identity(1,1),
puuNimi varchar(25),
pikkus int,
aasta int,
)
INSERT INTO puud(puuNimi, pikkus, aasta)
VALUES ('Tamm', 200, 100);
SELECT * FROM puud;
--Triger, mis jälgib tabeli puud täitmine(lisamine)
CREATE TRIGGER puuLisamine
ON puud
FOR INSERT 
AS
INSERT INTO logi(kasutaja, tegevus, aeg, andmed)
SELECT 
SYSTEM_USER,
'puu on lisatud',
GETDATE(),
CONCAT (inserted.puuNimi, ',' ,inserted.pikkus, ',' ,inserted.aasta)
FROM inserted;
--kontroll
INSERT INTO puud(puuNimi, pikkus, aasta)
VALUES ('vaher', 222, 200);
SELECT * FROM puud;
SELECT * FROM logi;
DROP TRIGGER puuLisamine;

--triger,mis jälgib tabelis kustutamine
CREATE TRIGGER puuKustutamine
ON puud
FOR DELETE 
AS
INSERT INTO logi(kasutaja, tegevus, aeg, andmed)
SELECT 
SYSTEM_USER,
'puu on kustutatud',
GETDATE(),
CONCAT (deleted.puuNimi, ',' ,deleted.pikkus, ',' ,deleted.aasta)
FROM deleted;
DELETE FROM puud WHERE puuID = 5;
SELECT * FROM puud;
SELECT * FROM logi;

--triger, mis jälgib tabelis uuendamine
CREATE TRIGGER puuUuendamine
ON puud
FOR UPDATE 
AS
INSERT INTO logi(kasutaja, tegevus, aeg, andmed)
SELECT 
SYSTEM_USER,
'puu on uuendatud',
GETDATE(),
CONCAT (
'vana puu info - ', deleted.puuNimi, ',' ,deleted.pikkus, ',' ,deleted.aasta,
'uus puu info - ', inserted.puuNimi, ',' ,inserted.pikkus, ',' ,inserted.aasta)
FROM deleted INNER JOIN inserted
ON deleted.puuID=inserted.puuID;

--kontroll
UPDATE puud SET pikkus=5555, aasta=1890
WHERE puuID=4;
SELECT * FROM puud;
SELECT * FROM logi;


--ülessane
CREATE TABLE products(
product_id int primary key identity(1,1),
product_name varchar(50),
brand_id int,
category_id int,
model_year int,
list_price int
)

CREATE TABLE product_audits(
    change_id INT IDENTITY PRIMARY KEY,
    product_id INT NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    brand_id INT NOT NULL,
    category_id INT NOT NULL,
    model_year SMALLINT NOT NULL,
    list_price DEC(10,2) NOT NULL,
    updated_at DATETIME NOT NULL,
    operation CHAR(3) NOT NULL,
    CHECK(operation = 'INS' or operation='DEL')
);

CREATE TRIGGER trg_product_audit
ON products
AFTER INSERT, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO product_audits(
        product_id, 
        product_name,
        brand_id,
        category_id,
        model_year,
        list_price, 
        updated_at, 
        operation
    )
    SELECT
        i.product_id,
        product_name,
        brand_id,
        category_id,
        model_year,
        i.list_price,
        GETDATE(),
        'INS'
    FROM
        inserted i
    UNION ALL
    SELECT
        d.product_id,
        product_name,
        brand_id,
        category_id,
        model_year,
        d.list_price,
        GETDATE(),
        'DEL'
    FROM
        deleted d;
END

INSERT INTO products(
    product_name, 
    brand_id, 
    category_id, 
    model_year, 
    list_price
)
VALUES (
    'Test product',
    1,
    1,
    2018,
    599
);
SELECT 
    * 
FROM 
    product_audits;

DELETE FROM 
    products
WHERE 
    product_id = 1;
