-- SQL Server Managment Stuudio
-- Connect to
-- (localdb)\MSSQLLocalDB
-- Authentification: Windows Auth - admini õigused localhosttis
-- Authentification: SQL Server Auth - varem loodud kasutajad
-- New Query

CREATE DATABASE posnoi;
USE posnoi;

-- tabeli loomine
CREATE TABLE opilane(
opilaneID int Primary Key identity(1,1),
eesnimi varchar(25),
perenimi varchar(30) Unique,
synniaeg date,
aadress TEXT,
opilaskodu bit
);
SELECT * from opilane;

--tabeli kustutamine
DROP TABLE opilane;

--andmete lisamine tabelisse
INSERT INTO opilane(eesnimi, perenimi, synniaeg, aadress, opilaskodu)
VALUES ('Mark', 'Levin', '2000-12-5', 'Tallinn', 1),
('Aleksander', 'Volkov', '2002-02-5', 'Tallinn', 1),
('Sergei', 'Ivanov', '1997-05-15', 'Tallinn', 0),
('Mati', 'Kask', '2001-04-16', 'Tallinn', 1),
('Mark', 'Markov', '2000-11-6', 'Tallinn', 1)
