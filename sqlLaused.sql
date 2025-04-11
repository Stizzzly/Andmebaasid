-- SQL Server Managment Stuudio
-- Connect to
-- (localdb)\MSSQLLocalDB
-- Authentification: Windows Auth - admini õigused localhosttis
-- Authentification: SQL Server Auth - varem loodud kasutajad
-- New Query

-- 1 tund

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

-- 2 tund
--tabel Rühm
CREATE TABLE ryhm(
ryhmID int not null primary key identity(1,1),
ryhm varchar(10) unique,
osakond varchar(20)
)
INSERT INTO ryhm(ryhm,osakond)
VALUES ('TITpv24', 'IT'),
('KRRpv23','Rätsep')

SELECT * from ryhm;
-- lisame uus veerg RyhmID tabelisse opilane
ALTER TABLE opilane ADD ryhmID int;
--lisame foreign key 
ALTER TABLE opilane 
ADD foreign key (ryhmID) references ryhm(ryhmID)
--foreign key kontroll
INSERT INTO opilane
(eesnimi, perenimi, synniaeg, aadress, opilaskodu, ryhmID)
VALUES ('Mark', 'Sergeev', '2000-12-5', 'Tallinn', 1, 3)
--kasutame seos tabelite vahel - JOIN
SELECT opilane.perenimi, ryhm.ryhm FROM opilane JOIN
ryhm ON opilane.ryhmID=ryhm.ryhmID;
--lihtsaim vaade
SELECT o.perenimi, r.ryhm, o.aadress
FROM opilane o JOIN ryhm r
ON o.ryhmID=r.ryhmID;

CREATE TABLE hinne(
hinneID int Primary Key identity(1,1),
opilaneID int foreign key references opilane(opilaneID),
hinne varchar(30),
oppeaine varchar(30),
); 
SELECT o.eesnimi, o.perenimi,h.hinne, h.oppeaine, h.hinneID, o.opilaneID
FROM opilane o JOIN hinne h
ON o.opilaneID=h.opilaneID;

INSERT INTO hinne(opilaneID, hinne, oppeaine)
VALUES (4, 4, 'Eesti Keel')

SELECT * FROM opilane;
DROP TABLE hinne;

--tabel opetaja
CREATE TABLE opetaja(
opetajaID int Primary Key identity(1,1),
nimi varchar(25),
perenimi varchar(30),
telefon varchar(20)
);

ALTER TABLE ryhm ADD opetajaID int;

ALTER TABLE ryhm
ADD foreign key (opetajaID) references opetaja(opetajaID)

DROP TABLE opetaja;
