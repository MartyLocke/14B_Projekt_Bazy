CREATE SEQUENCE Adresy_sequence
INCREMENT BY 1
START WITH 1
NOCYCLE;

CREATE SEQUENCE Kontakty_sequence
INCREMENT BY 1
START WITH 1
NOCYCLE;

CREATE SEQUENCE Konta_sequence
INCREMENT BY 1
START WITH 2
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
    Nr_Domu NVARCHAR2(5) NOT NULL,
    Nr_Mieszkania NVARCHAR2(5),
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
    
CREATE TABLE Specjalizacja (
    Nr_Specjalizacji NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    Nazwa_Specjalizacji NVARCHAR2(40) NOT NULL,
    Opis NVARCHAR2(500)
);

CREATE TABLE Pacjenci(
    Nr_Karty_Pacjenta NUMBER PRIMARY KEY,
    Osoba_Nr NUMBER NOT NULL,
    CONSTRAINT Osoba_fk FOREIGN KEY(Osoba_Nr) REFERENCES Osoby(Nr_Osoby)
    );
	
        
CREATE TABLE Konta(
    id_Konta NUMBER PRIMARY KEY,
    login NVARCHAR2(30) UNIQUE,
    haslo NVARCHAR2(32),
    typ_konta NVARCHAR2(10),
    Osoba_Nr NUMBER,
    CONSTRAINT check_account_type CHECK( typ_konta IN('admin', 'lekarz', 'pacjent')),
    CONSTRAINT Osoba_fk_Konta FOREIGN KEY(Osoba_Nr) REFERENCES Osoby(Nr_Osoby)
);


CREATE TABLE Sesje(
    Id_Sesji NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    token NVARCHAR2(32) UNIQUE NOT NULL,
    EXPR DATE DEFAULT SYSDATE+1 NOT NULL,
    Osoba_Nr NUMBER,
    CONSTRAINT Osoba_fk_Sesje FOREIGN KEY(Osoba_Nr) REFERENCES Osoby(Nr_Osoby)
);

CREATE OR REPLACE VIEW Pacjenci_view AS
SELECT  Konta.login, Konta.haslo, osoby.imie, osoby.nazwisko, osoby.data_urodzenia, osoby.pesel, kontakty.telefon, 
        kontakty.email, adresy.miasto, adresy.ulica, adresy.nr_domu, adresy.nr_mieszkania, 
        adresy.kod_pocztowy
        FROM Osoby, Adresy, Kontakty, Konta
        WHERE osoby.adres_nr = adresy.nr_adresu AND osoby.kontakt_nr = kontakty.nr_kontaktu AND Osoby.Nr_osoby=Konta.Osoba_Nr;

CREATE OR REPLACE TRIGGER Pacjent_add_trigger
INSTEAD OF INSERT ON Pacjenci_view
FOR EACH ROW
BEGIN
    INSERT INTO Adresy VALUES (ADRESY_SEQUENCE.nextval, :NEW.Miasto, :NEW.Ulica, :NEW.Nr_Domu, :NEW.Nr_Mieszkania, :NEW.Kod_Pocztowy);
    INSERT INTO Kontakty VALUES (KONTAKTY_SEQUENCE.nextval, :NEW.Telefon, :NEW.Email);
    INSERT INTO Osoby VALUES (OSOBY_SEQUENCE.nextval, :NEW.Nazwisko, :NEW.Imie, :NEW.Data_Urodzenia, :NEW.PESEL, ADRESY_SEQUENCE.currval, KONTAKTY_SEQUENCE.currval);
    INSERT INTO Pacjenci VALUES (PACJENCI_SEQUENCE.nextval, OSOBY_SEQUENCE.currval);
    INSERT INTO Konta VALUES (KONTA_SEQUENCE.nextval, :NEW.Login, :NEW.Haslo, 'pacjent', OSOBY_SEQUENCE.currval);
END;
/

INSERT INTO Specjalizacja (Nazwa_Specjalizacji) VALUES ('Kardiolog');
INSERT INTO Specjalizacja (Nazwa_Specjalizacji) VALUES ('Dentysta');

INSERT INTO Konta VALUES(1, 'admin', 'qwerty', 'admin', NULL);

INSERT INTO Pacjenci_view VALUES ('Pac1', 'Dudek', 'Adam', 'Kowalski', sysdate-1000, TO_CHAR(round(dbms_random.value(00000000001,99999999999))), TO_CHAR(round(dbms_random.value(500000000,999999999))), 'kowal@wp.pl', 'Kielce', 'Sandomierska', '74', '10', '25-987');
INSERT INTO Pacjenci_view VALUES ('Pac2', 'Andrzejek','Andrzej', 'Niewulis', sysdate-1200, TO_CHAR(round(dbms_random.value(00000000001,99999999999))), TO_CHAR(round(dbms_random.value(500000000,999999999))), 'andrzejek@onet.pl', 'Częstochowa', 'Limanowskiego', '12', NULL, '71-411');
INSERT INTO Pacjenci_view VALUES ('Pac3', 'luki','Łukasz', 'Źródłdowski', sysdate-2500, TO_CHAR(round(dbms_random.value(00000000001,99999999999))), TO_CHAR(round(dbms_random.value(500000000,999999999))), 'luki2121@wp.pl', 'Kielce', 'Bohaterów Warszawy', '14', '5', '25-200');
--SELECT * FROM Pacjenci_view;
--SELECT * FROM KONTA;

