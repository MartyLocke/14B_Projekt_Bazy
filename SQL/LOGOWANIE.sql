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

INSERT INTO Konta VALUES(1, 'PACJENT1', 'HASLOP1', 'pacjent', 1);
INSERT INTO Konta VALUES(2, 'admin', 'qwerty', 'admin');


CREATE OR REPLACE PROCEDURE add_session(p_login Konta.login%TYPE, p_haslo Konta.haslo%TYPE, p_token sesje.token%TYPE)
IS
    osoba_id osoby.nr_osoby%TYPE;
    count_ac NUMERIC;
BEGIN

    SELECT COUNT(id_konta) INTO count_ac FROM Konta WHERE login=p_login and haslo=p_haslo;

    IF count_ac > 0 THEN
        SELECT Osoba_Nr INTO osoba_id FROM KONTA WHERE login=p_login and haslo=p_haslo;
        INSERT INTO Sesje (token, Osoba_Nr) VALUES (p_token, (SELECT Osoba_Nr FROM KONTA WHERE login=p_login));
    END IF;
    
END;
/

EXECUTE add_session('PACJENT1','HASLOP1', '741258'); 