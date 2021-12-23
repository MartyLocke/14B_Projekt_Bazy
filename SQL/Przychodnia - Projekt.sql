DROP TABLE Adresy CASCADE CONSTRAINTS;
DROP TABLE Kontakty CASCADE CONSTRAINTS;
DROP TABLE Osoby CASCADE CONSTRAINTS;
DROP TABLE Pacjenci CASCADE CONSTRAINTS;
DROP SEQUENCE Adresy_sequence;
DROP SEQUENCE Kontakty_sequence;
DROP SEQUENCE Osoby_sequence;
DROP SEQUENCE Pacjenci_sequence;


CREATE SEQUENCE Adresy_sequence
INCREMENT BY 1
START WITH 1
NOCYCLE;

CREATE SEQUENCE Kontakty_sequence
INCREMENT BY 1
START WITH 1
NOCYCLE;

CREATE SEQUENCE Osoby_sequence
INCREMENT BY 1
START WITH 1
NOCYCLE;

CREATE SEQUENCE Pacjenci_sequence
INCREMENT BY 1
START WITH 1
NOCYCLE;

CREATE TABLE Adresy(
    Nr_Adresu NUMERIC PRIMARY KEY,
    Miasto NVARCHAR2(30) NOT NULL,
    Ulica NVARCHAR2(30) NOT NULL,
    Nr_Domu NUMBER NOT NULL,
    Nr_Mieszkania NUMBER,
    Kod_Pocztowy NVARCHAR2(6) NOT NULL
);

CREATE TABLE Kontakty(
    Nr_Kontaktu NUMBER PRIMARY KEY,
    Telefon NVARCHAR2(9),
    Email NVARCHAR2(40)
);

CREATE TABLE Osoby(
     Nr_Osoby NUMBER PRIMARY KEY,
     Nazwisko NVARCHAR2(40) NOT NULL,
     Imie NVARCHAR2(30) NOT NULL,
     Data_Urodzenia DATE NOT NULL,
     PESEL NVARCHAR2(11) NOT NULL UNIQUE,
     Adres_Nr NUMBER NOT NULL,
     Kontakt_NR NUMBER NOT NULL, 
     CONSTRAINT Adres_fk FOREIGN KEY(Adres_Nr) REFERENCES Adresy(Nr_Adresu),
     CONSTRAINT Kontakt_fk FOREIGN KEY(Kontakt_Nr) REFERENCES Kontakty(Nr_Kontaktu)
    );
    
CREATE TABLE Pacjenci(
    Nr_Karty_Pacjenta NUMBER PRIMARY KEY,
    Osoba_Nr NUMBER NOT NULL,
    CONSTRAINT Osoba_fk FOREIGN KEY(Osoba_Nr) REFERENCES Osoby(Nr_Osoby)
    );
	

CREATE OR REPLACE VIEW Pacjenci_view AS
SELECT  osoby.imie, osoby.nazwisko, osoby.data_urodzenia, osoby.pesel, kontakty.telefon, 
        kontakty.email, adresy.miasto, adresy.ulica, adresy.nr_domu, adresy.nr_mieszkania, 
        adresy.kod_pocztowy
        FROM Osoby, Adresy, Kontakty
        WHERE osoby.adres_nr = adresy.nr_adresu AND osoby.kontakt_nr = kontakty.nr_kontaktu;

CREATE OR REPLACE TRIGGER Pacjent_add_trigger
INSTEAD OF INSERT ON Pacjenci_view
FOR EACH ROW
BEGIN
    INSERT INTO Adresy VALUES (ADRESY_SEQUENCE.nextval, :NEW.Miasto, :NEW.Ulica, :NEW.Nr_Domu, :NEW.Nr_Mieszkania, :NEW.Kod_Pocztowy);
    INSERT INTO Kontakty VALUES (KONTAKTY_SEQUENCE.nextval, :NEW.Telefon, :NEW.Email);
    INSERT INTO Osoby VALUES (OSOBY_SEQUENCE.nextval, :NEW.Nazwisko, :NEW.Imie, :NEW.Data_Urodzenia, :NEW.PESEL, ADRESY_SEQUENCE.currval, KONTAKTY_SEQUENCE.currval);
    INSERT INTO Pacjenci VALUES (PACJENCI_SEQUENCE.nextval, OSOBY_SEQUENCE.currval);
END;
/

INSERT INTO Pacjenci_view VALUES ('Adam', 'Kowalski', sysdate-1000, TO_CHAR(round(dbms_random.value(00000000001,99999999999))), TO_CHAR(round(dbms_random.value(500000000,999999999))), 'kowal@wp.pl', 'Kielce', 'Sandomierska', 74, 10, '25-987');
INSERT INTO Pacjenci_view VALUES ('Andrzej', 'Niewulis', sysdate-1200, TO_CHAR(round(dbms_random.value(00000000001,99999999999))), TO_CHAR(round(dbms_random.value(500000000,999999999))), 'andrzejek@onet.pl', 'Częstochowa', 'Limanowskiego', 12, NULL, '71-411');
INSERT INTO Pacjenci_view VALUES ('Łukasz', 'Żródowski', sysdate-2500, TO_CHAR(round(dbms_random.value(00000000001,99999999999))), TO_CHAR(round(dbms_random.value(500000000,999999999))), 'luki2121@wp.pl', 'Kielce', 'Bohaterów Warszawy', 14, 5, '25-200');
SELECT * FROM Pacjenci_view;