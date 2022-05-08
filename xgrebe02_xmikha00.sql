-- DROP TABLE Zakaznik CASCADE CONSTRAINTS;
-- DROP TABLE Objednavka CASCADE CONSTRAINTS;
-- DROP TABLE Faktura CASCADE CONSTRAINTS;
-- DROP TABLE Zamestnanec CASCADE CONSTRAINTS;
-- DROP TABLE Pecivo CASCADE CONSTRAINTS;
-- DROP TABLE Rozvoz CASCADE CONSTRAINTS;
-- DROP TABLE Vyzvednuti CASCADE CONSTRAINTS;
-- DROP TABLE Surovina CASCADE CONSTRAINTS;
-- DROP TABLE Obsahuje CASCADE CONSTRAINTS;
-- DROP TABLE Polozka CASCADE CONSTRAINTS;
-- DROP SEQUENCE id_generator;
-- DROP SEQUENCE cislo_dodani;
-- DROP SEQUENCE cislo_faktury;
-- DROP SEQUENCE cislo_polozky;
-- DROP SEQUENCE cislo_obsahuje;

---------------------------GENERATORY ID PRO ZAKAZNIKA, DODANI A FAKTURY--------------------------------------------
CREATE SEQUENCE id_generator
    START WITH 1000000
    INCREMENT BY 1;

CREATE SEQUENCE cislo_dodani
    START WITH 10000
    INCREMENT BY 2;

CREATE SEQUENCE cislo_faktury
    START WITH 1
    INCREMENT BY 1;

CREATE SEQUENCE cislo_polozky
    START WITH 1
    INCREMENT BY 1;

CREATE SEQUENCE cislo_obsahuje
    START WITH 1
    INCREMENT BY 1;




---------------------------------------------ZAKAZNIK A INSERT---------------------------------------------------------

CREATE TABLE Zakaznik (
    zakaznikID INTEGER DEFAULT id_generator.nextval,
    jmeno VARCHAR2(20) NOT NULL,
    prijmeni VARCHAR2(20) NOT NULL,
    email VARCHAR2(30) NOT NULL,
    telefon CHAR(12) NOT NULL,                             -- povine pole pri registraci. Aby mohli zak. kontaktovat
    ulice VARCHAR2(40),                                    -- bez adresy. app povoli
    mesto VARCHAR2(40),                                    -- cloveku jen samostatne
    psc CHAR(5),                                           -- vyzvednuti objednavky

    PRIMARY KEY(zakaznikID),
    CONSTRAINT email_format_zakaznik                               --   "jdoe@company.co.uk" je platny format
        CHECK ( REGEXP_LIKE(email, '\w+(\.\w*)*@\w+(\.\w+)+') ),   --   "very.common@example.com" je platny format
    CONSTRAINT psc_format
        CHECK ( REGEXP_LIKE(psc, '[0-9]{5}') )                     --    pouze cislice
);

CREATE OR REPLACE TRIGGER non_alphanumeric
    AFTER INSERT OR UPDATE ON ZAKAZNIK
    FOR EACH ROW
    BEGIN
        IF REGEXP_LIKE(:NEW.JMENO, '[0-9](+)') THEN
            RAISE_APPLICATION_ERROR(-20000, 'Incorrect name format!');
        END IF;
    END;


INSERT INTO Zakaznik
VALUES(2564302, 'Egor', 'Greb', 'xgrebe02@stud.fit.vutbr.cz', '420773942374','Uvoz 31', 'Brno', '60200');

INSERT INTO Zakaznik(jmeno, prijmeni, telefon, email, ulice, mesto, psc)             -- pouzivame id_generator
VALUES('Kirill', 'Mikhailov', '420773249612', 'xmikha00@stud.fit.vutbr.cz','Kounicova 1', 'Brno', '60200');

INSERT INTO Zakaznik(zakaznikID,jmeno, prijmeni, telefon, email, ulice, mesto, psc)
VALUES(5132030 ,'Olga', 'Nemcova', '420766448290','onem231@gmail.com','Leitnerova 23', 'Brno', '60300');

INSERT INTO Zakaznik(jmeno, prijmeni, telefon, email, ulice, mesto, psc)             -- pouzivame id_generator
VALUES('Jiri', 'Krasny', '420763845678','jirikrasny@company.co.cz','Pekařská 58', 'Brno', '60200');

INSERT INTO Zakaznik(jmeno, prijmeni, email, telefon)                                -- bez adresy. app povoli
VALUES('Zuzana', 'Horakova', 'zuzkahor@seznam.cz', '420777899321');                  -- cloveku jen samostatne
                                                                                     -- vyzvednuti objednavky

----------------------------------------OBJEDNAVKA A INSERT------------------------------------------------------------
CREATE TABLE Objednavka (
    objednavkaID INTEGER PRIMARY KEY,
    stav VARCHAR2(6) DEFAULT 'nezapl',                           -- muze dostavat hodnoty "zapl" nebo "nezapl"
    datum DATE NOT NULL,                                         -- format 'dd.mm.yyyy'
    zakaznik INTEGER NOT NULL,                                   -- reference na id zakaznika
    cislo_faktury INTEGER DEFAULT NULL,                          -- reference na odpovidajici cislo faktury
    zodpovedny INTEGER DEFAULT NULL,                             -- reference na zodpovedneho zamestnance

    CONSTRAINT stav_hodnota CHECK ( stav = 'nezapl' OR stav = 'zapl' ),
    CONSTRAINT FK_objednavka_zakaznik FOREIGN KEY (zakaznik) REFERENCES Zakaznik ON DELETE CASCADE
);


INSERT INTO Objednavka(objednavkaID, stav, datum, zakaznik)
VALUES(45743, 'zapl', TO_DATE('01.03.2022', 'dd.mm.yyyy'), 2564302);

INSERT INTO Objednavka(objednavkaID, stav, datum, zakaznik)
VALUES(14321, 'zapl', TO_DATE('02.03.2022', 'dd.mm.yyyy'), 1000001);

INSERT INTO Objednavka(objednavkaID, stav, datum, zakaznik)
VALUES(56348, 'zapl', TO_DATE('02.03.2022', 'dd.mm.yyyy'), 1000002);

INSERT INTO Objednavka(objednavkaID, stav, datum, zakaznik)
VALUES(19362, 'zapl', TO_DATE('02.03.2022', 'dd.mm.yyyy'), 5132030);

INSERT INTO Objednavka(objednavkaID, stav, datum, zakaznik)
VALUES(10308, 'zapl', TO_DATE('03.03.2022', 'dd.mm.yyyy'), 1000001);

----------------------------------------ZAMESTANEC A INSERT------------------------------------------------------------
CREATE TABLE Zamestnanec (
    zamestnanecID INTEGER DEFAULT id_generator.nextval,
    jmeno VARCHAR2(20) NOT NULL,
    prijmeni VARCHAR2(20) NOT NULL,
    pozice VARCHAR2(20) NOT NULL,
    auto VARCHAR2(20) DEFAULT NULL,
    telefon CHAR(12) DEFAULT NULL,
    email VARCHAR2(30) DEFAULT NULL,

    PRIMARY KEY (zamestnanecID),
    CONSTRAINT email_format_zamestnance                            --   "jdoe@company.co.uk" je platny format
        CHECK ( REGEXP_LIKE(email, '\w+(\.\w*)*@\w+(\.\w+)+') )    --   "very.common@example.com" je platny format
);


INSERT INTO Zamestnanec(jmeno, prijmeni, pozice, telefon)
VALUES('Petr', 'Vlk', 'pekar', '420777834977');

INSERT INTO Zamestnanec(jmeno, prijmeni, pozice, telefon)
VALUES('Martha', 'Wayne', 'technicka podpora', '420773226491');

INSERT INTO Zamestnanec(jmeno, prijmeni, pozice, telefon)
VALUES('Gevorg', 'Akopyan', 'zastupce manageru', '420723727821');

INSERT INTO Zamestnanec(jmeno, prijmeni, pozice, telefon, email)
VALUES('Jan', 'Sopor', 'manager personalu', '420767014329', 'sopor89@google.com');

INSERT INTO Zamestnanec(zamestnanecID, jmeno, prijmeni, pozice, auto, telefon)
VALUES(2000001, 'Stepan', 'Podolsky', 'kuryr', 'Skoda Octavia 2013', '420721555421');

INSERT INTO Zamestnanec(zamestnanecID, jmeno, prijmeni, pozice, auto, telefon)
VALUES(2000002, 'Jarovlav', 'Foltynek', 'kuryr', 'Rolls Royce Phantom', '421771934912');

INSERT INTO Zamestnanec(zamestnanecID, jmeno, prijmeni, pozice, auto, telefon)
VALUES(2000003, 'Valeriy', 'Batykov', 'kuryr', 'FIAT Punto 1939', '420773249609');


-----------------------------------GENERALIACE-SPECIALIZACE DODANI-----------------------------------------------------
-----------------Pravidlo transformace gen.-spec. #2. pouze tabulky pro podtypy i s atributy nadtypu-------------------

CREATE TABLE Rozvoz (
    cisloRozvozu INTEGER DEFAULT cislo_dodani.nextval,
    cisloObjednavky INTEGER NOT NULL ,
    stav VARCHAR2(6) DEFAULT 'aktual',
    zodpovedny  INTEGER NOT NULL,                                         -- cislo kuryra
    datum DATE NOT NULL,                                                  -- datum doruceni
    ulice VARCHAR2(40) NOT NULL,                                          -- kuryr musi vedet presnou addresu
    mesto VARCHAR2(40) NOT NULL,                                          -- pro doruceni
    psc CHAR(5) NOT NULL ,

    PRIMARY KEY (cisloRozvozu),
    CONSTRAINT stav_hodnota_eozvoz CHECK ( stav = 'aktual' OR stav = 'dor' or stav = 'zrus')
);



CREATE TABLE Vyzvednuti (
    cisloVyzvednuti INTEGER DEFAULT cislo_dodani.nextval,
    cisloObjednavky INTEGER NOT NULL,
    stav VARCHAR2(6) DEFAULT 'aktual',
    datum DATE NOT NULL,                                                  -- datum vyzvedbuti

    PRIMARY KEY (cisloVyzvednuti),
    CONSTRAINT stav_hodnota_vyzvednuti CHECK ( stav = 'aktual' OR stav = 'dor' or stav = 'zrus')
);


INSERT INTO Vyzvednuti(cisloObjednavky, stav, datum)
VALUES(14321, 'dor', TO_DATE('03.03.2022', 'dd.mm.yyyy') );

INSERT INTO Rozvoz(cisloObjednavky, stav, datum, zodpovedny, ulice, mesto, psc)
VALUES(45743, 'dor', TO_DATE('05.03.2022', 'dd.mm.yyyy'), 2000001, 'Uvoz 31', 'Brno', '60200');

INSERT INTO Rozvoz(cisloObjednavky, stav, datum, zodpovedny, ulice, mesto, psc)
VALUES(10308, 'dor', TO_DATE('04.03.2022', 'dd.mm.yyyy'), 2000002, 'Kounicova 1', 'Brno', '60200');


INSERT INTO Rozvoz(cisloObjednavky, stav, datum, zodpovedny, ulice, mesto, psc)
VALUES(56348, 'dor', TO_DATE('06.03.2022', 'dd.mm.yyyy'), 2000001, 'Pekarska 58', 'Brno', '60200');


INSERT INTO Rozvoz(cisloObjednavky, stav, datum, zodpovedny, ulice, mesto, psc)
VALUES(19362, 'dor', TO_DATE('05.03.2022', 'dd.mm.yyyy'), 2000003, 'Leitnerova 23', 'Brno', '60300');



-----------------------------------GENERALIACE-SPECIALIZACE PECIVO-----------------------------------------------------
----------------------Pravidlo transformace gen.-spec. #4. všechno v jedné tabulce-------------------------------------
--------------------------Rozlišení specializací podle prázdné hodnoty-------------------------------------------------

CREATE TABLE Pecivo (
    cislo_peciva INTEGER PRIMARY KEY,
    nazev VARCHAR2(30) NOT NULL,
    druh VARCHAR2(20) NOT NULL,
    cena NUMBER(20,2) NOT NULL CONSTRAINT not_negative_cena CHECK ( cena >= 0.0),
    hmotnost NUMBER(10,3) NOT NULL CONSTRAINT not_negative_hmotnost CHECK ( hmotnost >= 0.0),
    obilnina VARCHAR2(20)  DEFAULT NULL
);

INSERT INTO Pecivo(cislo_peciva, nazev, druh, cena, hmotnost, obilnina)
VALUES(1, 'pumpkin muffin', 'muffin', 50, 70, 'psenice');

INSERT INTO Pecivo(cislo_peciva, nazev, druh, cena, hmotnost, obilnina)
VALUES(2, 'cokoladovy muffin', 'muffin', 100, 50, 'psenice');

INSERT INTO Pecivo(cislo_peciva, nazev, druh, cena, hmotnost, obilnina)
VALUES(10, 'moravsky bochnik', 'chleb', 34, 355, 'zito');

INSERT INTO Pecivo(cislo_peciva, nazev, druh, cena, hmotnost, obilnina)
VALUES(11, 'chleb mistru', 'chleb', 30, 275, 'zito');

INSERT INTO Pecivo(cislo_peciva, nazev, druh, cena, hmotnost, obilnina)
VALUES(12, 'just chleb!', 'chleb', 29, 350, 'psenice');

INSERT INTO Pecivo(cislo_peciva, nazev, druh, cena, hmotnost, obilnina)
VALUES(13, 'bageta ou-la-la', 'chleb', 30, 210, 'psenice');

INSERT INTO Pecivo(cislo_peciva, nazev, druh, cena, hmotnost, obilnina)
VALUES(14, 'rohlik', 'chleb', 3, 43, 'psenice');

INSERT INTO Pecivo(cislo_peciva, nazev, druh, cena, hmotnost)
VALUES(20, 'ovocna kobliha', 'kobliha', 17, 75);

INSERT INTO Pecivo(cislo_peciva, nazev, druh, cena, hmotnost)
VALUES(21, 'jahodova kobliha', 'kobliha', 17, 75);

INSERT INTO Pecivo(cislo_peciva, nazev, druh, cena, hmotnost)
VALUES(22, 'cokoladova kobliha', 'kobliha', 17, 75);

INSERT INTO Pecivo(cislo_peciva, nazev, druh, cena, hmotnost)
VALUES(30, 'jahodovy donut', 'donut', 19, 80);

INSERT INTO Pecivo(cislo_peciva, nazev, druh, cena, hmotnost)
VALUES(31, 'orechovy donut', 'donut', 19, 80);

INSERT INTO Pecivo(cislo_peciva, nazev, druh, cena, hmotnost)
VALUES(32, 'lotus donut', 'donut', 15, 75);

INSERT INTO Pecivo(cislo_peciva, nazev, druh, cena, hmotnost)
VALUES(40, 'pizza kapsa', 'kapsicky', 23, 100);

INSERT INTO Pecivo(cislo_peciva, nazev, druh, cena, hmotnost)
VALUES(41, 'tvarohova kapsa', 'kapsicky', 18, 80);

INSERT INTO Pecivo(cislo_peciva, nazev, druh, cena, hmotnost)
VALUES(42, 'hot-dog kapsa', 'kapsicky', 25, 95);

INSERT INTO Pecivo(cislo_peciva, nazev, druh, cena, hmotnost)
VALUES(50, 'makovy kolac', 'kolac', 70, 240);

INSERT INTO Pecivo(cislo_peciva, nazev, druh, cena, hmotnost)
VALUES(51, 'cokoladovy kolac', 'kolac', 79, 200);

INSERT INTO Pecivo(cislo_peciva, nazev, druh, cena, hmotnost)
VALUES(60, 'medovnik', 'dort', 120, 350);

INSERT INTO Pecivo(cislo_peciva, nazev, druh, cena, hmotnost)
VALUES(61, 'smetanovy dort', 'dort', 100, 300);

INSERT INTO Pecivo(cislo_peciva, nazev, druh, cena, hmotnost)
VALUES(62, 'babovka mramorova bez lepku', 'babovka', 170, 60);


----------------------------------------SUROVINA A INSERT---------------------------------------------------------------
CREATE TABLE Surovina (
    cislo_suroviny INTEGER PRIMARY KEY,
    nazev VARCHAR2(30) NOT NULL,
    cena NUMBER(20,2) NOT NULL CONSTRAINT not_negative_cena_suroviny CHECK ( cena >= 0.0),
    mnozstvi_na_sklade NUMBER(10, 4) DEFAULT NULL CONSTRAINT not_negative_mnozstvi CHECK ( mnozstvi_na_sklade >= 0.0),
    alergen VARCHAR2(4) NOT NULL,

    CONSTRAINT alergen_hodnota CHECK ( alergen = 'je' OR alergen = 'neni' )
);


CREATE OR REPLACE TRIGGER mnozstvi_suroviny
    AFTER UPDATE OF mnozstvi_na_sklade ON SUROVINA
    FOR EACH ROW
    BEGIN
        IF mnozstvi_na_sklade < 200 THEN
            DBMS_OUTPUT.PUT_LINE('POZOR! Mate prilis malo ' || Surovina.nazev || ' na sklade! Zajistete dodani co nejdriv!');
        END IF;
    END;


INSERT INTO Surovina(cislo_suroviny, nazev, cena, mnozstvi_na_sklade, alergen)
VALUES(1, 'arasidy', 11, 1300, 'je');

INSERT INTO Surovina(cislo_suroviny, nazev, cena, mnozstvi_na_sklade, alergen)
VALUES(2, 'zito', 3, 2650, 'je');

INSERT INTO Surovina(cislo_suroviny, nazev, cena, mnozstvi_na_sklade, alergen)
VALUES(3, 'vejce', 12, 430, 'je');

INSERT INTO Surovina(cislo_suroviny, nazev, cena, mnozstvi_na_sklade, alergen)
VALUES(4, 'smetana', 15, 563, 'je');

INSERT INTO Surovina(cislo_suroviny, nazev, cena, mnozstvi_na_sklade, alergen)
VALUES(5, 'cokolada na vareni', 19, 347, 'je');

INSERT INTO Surovina(cislo_suroviny, nazev, cena, mnozstvi_na_sklade, alergen)
VALUES(6, 'ovoce mix', 23, 934, 'je');

INSERT INTO Surovina(cislo_suroviny, nazev, cena, mnozstvi_na_sklade, alergen)
VALUES(7, 'tvaroh', 21, 368, 'je');

INSERT INTO Surovina(cislo_suroviny, nazev, cena, mnozstvi_na_sklade, alergen)
VALUES(8, 'cukr', 6, 8468, 'je');

INSERT INTO Surovina(cislo_suroviny, nazev, cena, mnozstvi_na_sklade, alergen)
VALUES(9, 'sul', 4, 3429, 'je');

INSERT INTO Surovina(cislo_suroviny, nazev, cena, mnozstvi_na_sklade, alergen)
VALUES(10, 'sunka', 16, 274, 'je');

INSERT INTO Surovina(cislo_suroviny, nazev, cena, mnozstvi_na_sklade, alergen)
VALUES(11, 'parky', 15, 199, 'je');

INSERT INTO Surovina(cislo_suroviny, nazev, cena, mnozstvi_na_sklade, alergen)
VALUES(12, 'kecup', 10, 217, 'je');

INSERT INTO Surovina(cislo_suroviny, nazev, cena, mnozstvi_na_sklade, alergen)
VALUES(13, 'jahodovy dzem', 20, 673, 'je');

INSERT INTO Surovina(cislo_suroviny, nazev, cena, mnozstvi_na_sklade, alergen)
VALUES(14, 'susenky Lotus', 30, 160, 'je');

INSERT INTO Surovina(cislo_suroviny, nazev, cena, mnozstvi_na_sklade, alergen)
VALUES(15, 'maslo', 24, 764, 'je');

INSERT INTO Surovina(cislo_suroviny, nazev, cena, mnozstvi_na_sklade, alergen)
VALUES(16, 'dyne', 23, 80, 'je');

INSERT INTO Surovina(cislo_suroviny, nazev, cena, mnozstvi_na_sklade, alergen)
VALUES(17, 'psenice', 4, 5634, 'je');

----------------------------------------OBSAHUJE A INSERT---------------------------------------------------------------

CREATE TABLE Obsahuje (
    unikatni_cislo INTEGER DEFAULT cislo_obsahuje.nextval,
    cislo_suroviny INTEGER NOT NULL,
    cislo_peciva INTEGER NOT NULL,
    gramaz NUMBER(10,3) NOT NULL CONSTRAINT not_negative_gramaz CHECK ( gramaz >= 0.0),

    PRIMARY KEY (unikatni_cislo),
    CONSTRAINT FK_obsahuje_pecivo FOREIGN KEY (cislo_peciva) REFERENCES Pecivo ON DELETE CASCADE,
    CONSTRAINT FK_obsahuje_surovinu FOREIGN KEY (cislo_suroviny) REFERENCES Surovina ON DELETE CASCADE
);

INSERT INTO Obsahuje(cislo_suroviny, cislo_peciva, gramaz)
VALUES(17, 1, 70);

INSERT INTO Obsahuje(cislo_suroviny, cislo_peciva, gramaz)
VALUES(17, 2, 50);

INSERT INTO Obsahuje(cislo_suroviny, cislo_peciva, gramaz)
VALUES(17, 12, 350);

INSERT INTO Obsahuje(cislo_suroviny, cislo_peciva, gramaz)
VALUES(17, 13, 210);

INSERT INTO Obsahuje(cislo_suroviny, cislo_peciva, gramaz)
VALUES(17, 14, 43);

INSERT INTO Obsahuje(cislo_suroviny, cislo_peciva, gramaz)
VALUES(17, 20, 50);

INSERT INTO Obsahuje(cislo_suroviny, cislo_peciva, gramaz)
VALUES(6, 20, 25);

INSERT INTO Obsahuje(cislo_suroviny, cislo_peciva, gramaz)
VALUES(17, 21, 50);

INSERT INTO Obsahuje(cislo_suroviny, cislo_peciva, gramaz)
VALUES(13, 21, 25);

INSERT INTO Obsahuje(cislo_suroviny, cislo_peciva, gramaz)
VALUES(17, 22, 50);

INSERT INTO Obsahuje(cislo_suroviny, cislo_peciva, gramaz)
VALUES(5, 22, 25);

INSERT INTO Obsahuje(cislo_suroviny, cislo_peciva, gramaz)
VALUES(17, 30, 50);

INSERT INTO Obsahuje(cislo_suroviny, cislo_peciva, gramaz)
VALUES(13, 30, 30);

INSERT INTO Obsahuje(cislo_suroviny, cislo_peciva, gramaz)
VALUES(17, 31, 53.2);

INSERT INTO Obsahuje(cislo_suroviny, cislo_peciva, gramaz)
VALUES(17, 32, 53.2);

INSERT INTO Obsahuje(cislo_suroviny, cislo_peciva, gramaz)
VALUES(17, 40, 40);

INSERT INTO Obsahuje(cislo_suroviny, cislo_peciva, gramaz)
VALUES(12, 40, 15);

INSERT INTO Obsahuje(cislo_suroviny, cislo_peciva, gramaz)
VALUES(10, 40, 10);

INSERT INTO Obsahuje(cislo_suroviny, cislo_peciva, gramaz)
VALUES(17, 41, 40);

INSERT INTO Obsahuje(cislo_suroviny, cislo_peciva, gramaz)
VALUES(7, 41, 30);

INSERT INTO Obsahuje(cislo_suroviny, cislo_peciva, gramaz)
VALUES(12, 41, 10);

INSERT INTO Obsahuje(cislo_suroviny, cislo_peciva, gramaz)
VALUES(17, 42, 40);

INSERT INTO Obsahuje(cislo_suroviny, cislo_peciva, gramaz)
VALUES(11, 42, 45);

INSERT INTO Obsahuje(cislo_suroviny, cislo_peciva, gramaz)
VALUES(12, 42, 10);

INSERT INTO Obsahuje(cislo_suroviny, cislo_peciva, gramaz)
VALUES(17, 61, 100);

INSERT INTO Obsahuje(cislo_suroviny, cislo_peciva, gramaz)
VALUES(4, 61, 120);

INSERT INTO Obsahuje(cislo_suroviny, cislo_peciva, gramaz)
VALUES(5, 61, 100);

INSERT INTO Obsahuje(cislo_suroviny, cislo_peciva, gramaz)
VALUES(17, 51, 100);

INSERT INTO Obsahuje(cislo_suroviny, cislo_peciva, gramaz)
VALUES(5, 51, 100);

INSERT INTO Obsahuje(cislo_suroviny, cislo_peciva, gramaz)
VALUES(2, 2, 12);

----------------------------------------FAKTURA A INSERT---------------------------------------------------------------
CREATE TABLE Faktura (
    cislo_faktury INTEGER DEFAULT cislo_faktury.nextval,
    celkova_castka NUMBER DEFAULT 0 CONSTRAINT not_negative_castka CHECK ( celkova_castka >= 0.0 ),
    pocet_polozek INTEGER DEFAULT NULL,
    cislo_objednavky INTEGER NOT NULL,

    PRIMARY KEY (cislo_faktury)
);

INSERT INTO Faktura(celkova_castka, pocet_polozek, cislo_objednavky)
VALUES(122, 3, 14321); -- just chleb, pizza kapsa, makovy kolac

INSERT INTO Faktura(celkova_castka, pocet_polozek, cislo_objednavky)
VALUES(35, 1, 10308); -- chleb mistru

INSERT INTO Faktura(celkova_castka, pocet_polozek, cislo_objednavky)
VALUES(233, 6, 56348); -- 2 jahodove donuty, 3 hot dog kapsy, medovnik

INSERT INTO Faktura(celkova_castka, pocet_polozek, cislo_objednavky)
VALUES(179, 3, 14321); -- smetanovy dort, cokoladovy kolac

INSERT INTO Faktura(celkova_castka, pocet_polozek, cislo_objednavky)
VALUES(84, 1, 19362); -- moravsky bochnik, cokoladovy muffin

----------------------------------------POLOZKA A INSERT---------------------------------------------------------------
CREATE TABLE Polozka (
    unikatni_cislo INTEGER DEFAULT cislo_polozky.nextval,
    cislo_faktury INTEGER NOT NULL,
    cislo_peciva INTEGER NOT NULL,
    pocet_kusu INTEGER DEFAULT 1 CONSTRAINT pocet_kusu_natural_number CHECK ( pocet_kusu >= 1),

    PRIMARY KEY (unikatni_cislo),
    CONSTRAINT FK_polozka_pecivo FOREIGN KEY (cislo_peciva) REFERENCES Pecivo ON DELETE CASCADE,
    CONSTRAINT FK_polozka_faktura FOREIGN KEY (cislo_faktury) REFERENCES Faktura ON DELETE CASCADE
);

INSERT INTO Polozka(cislo_faktury, cislo_peciva, pocet_kusu)
VALUES(1, 12, 1);

INSERT INTO Polozka(cislo_faktury, cislo_peciva, pocet_kusu)
VALUES(1, 40, 1);

INSERT INTO Polozka(cislo_faktury, cislo_peciva, pocet_kusu)
VALUES(1, 50, 1);

INSERT INTO Polozka(cislo_faktury, cislo_peciva, pocet_kusu)
VALUES(2, 11, 1);

INSERT INTO Polozka(cislo_faktury, cislo_peciva, pocet_kusu)
VALUES(3, 30, 2);

INSERT INTO Polozka(cislo_faktury, cislo_peciva, pocet_kusu)
VALUES(3, 42, 3);

INSERT INTO Polozka(cislo_faktury, cislo_peciva, pocet_kusu)
VALUES(3, 60, 1);

INSERT INTO Polozka(cislo_faktury, cislo_peciva, pocet_kusu)
VALUES(4, 61, 1);

INSERT INTO Polozka(cislo_faktury, cislo_peciva, pocet_kusu)
VALUES(4, 51, 1);

INSERT INTO Polozka(cislo_faktury, cislo_peciva, pocet_kusu)
VALUES(5, 10, 1);

INSERT INTO Polozka(cislo_faktury, cislo_peciva, pocet_kusu)
VALUES(5, 2, 1);

-----------------------------------------NASTAVENI CIZICH KLICU--------------------------------------------------------

ALTER TABLE Objednavka ADD CONSTRAINT FK_objednavka_faktura FOREIGN KEY (cislo_faktury)
    REFERENCES Faktura ON DELETE CASCADE;

ALTER TABLE Objednavka ADD CONSTRAINT FK_objednavka_zamestnanec FOREIGN KEY (zodpovedny)
    REFERENCES Zamestnanec ON DELETE CASCADE ;

ALTER TABLE Rozvoz ADD CONSTRAINT FK_rozvoz_zamestnanec FOREIGN KEY (zodpovedny)
    REFERENCES Zamestnanec ON DELETE CASCADE;

ALTER TABLE Rozvoz ADD CONSTRAINT FK_rozvoz_objednavka FOREIGN KEY (cisloObjednavky)
    REFERENCES Objednavka ON DELETE CASCADE;

ALTER TABLE Vyzvednuti ADD CONSTRAINT FK_vyzvednuti_objednavka FOREIGN KEY (cisloObjednavky)
    REFERENCES Objednavka ON DELETE CASCADE;

ALTER TABLE Faktura ADD CONSTRAINT FK_faktura_objednavka FOREIGN KEY (cislo_objednavky)
    REFERENCES Objednavka ON DELETE CASCADE;

------------------------------------------PRIKAZY SELECT---------------------------------------------------------------

-- zobrazuje ktere pecivo obsahuje psenici a kolik
SELECT P.nazev as nazev_peciva, P.cislo_peciva as id_peciva, O.gramaz as kolik_psenice
FROM Pecivo P, Obsahuje O
WHERE P.cislo_peciva = O.cislo_peciva and O.cislo_suroviny = 17;

-- kolik kazdy kuryr dorucil objednavek
SELECT Z.jmeno as  jmeno_kuryra, Z.prijmeni as prijmeni_kuryra, Z.zamestnanecID as id_kuryra, COUNT(*) as kolik_dorucil
FROM Zamestnanec Z, Rozvoz R
WHERE R.stav = 'dor' and R.zodpovedny = Z.zamestnanecID
GROUP BY Z.zamestnanecID, Z.jmeno, Z.prijmeni;

-- kolik doruceni v starem meste (602 00) probehlo mezi 04.03 a 06.03
SELECT COUNT(*) pocet_doruceni
FROM ROZVOZ R
WHERE R.DATUM BETWEEN TO_DATE('2022-03-04','YYYY-MM-DD')
                      AND TO_DATE('2022-03-06','YYYY-MM-DD')
  AND PSC = 60200
GROUP BY PSC;

-- kolik objednavek bylo doruceno a vyzvednuto za celou dobu a prumer zisku
SELECT COUNT(CISLOOBJEDNAVKY) prodeje, AVG(prumer) prumer_za_celou_dobu
FROM VYZVEDNUTI NATURAL FULL JOIN ROZVOZ DORUCENI, (
    SELECT AVG(CELKOVA_CASTKA) prumer
    FROM FAKTURA
);

-- kolik celkem zakazniki zaplatili za bezlepkove pecivo a ktere pecivo to bylo
SELECT PEC.NAZEV pecivo, POL.POCET_KUSU * PEC.CENA celkem
FROM POLOZKA POL, (SELECT P.NAZEV, P.CISLO_PECIVA, P.CENA FROM PECIVO P) PEC
WHERE POL.CISLO_PECIVA IN (                                         -- vybirame jen bezlepkove pecivo
    SELECT  CISLO_PECIVA                                            -- ty radky, u kterych hodnota
        FROM PECIVO P                                               -- ve sloupci OBILNINA je NULL
        WHERE P.OBILNINA IS NULL
    ) AND POL.CISLO_PECIVA = PEC.CISLO_PECIVA;                      -- cenu peciva svazujeme s cislem peciva v POLOZCE

-- kdo z zakazniku nedelal zadne objednvky mimo 02.03
SELECT ZAKAZNIKID id, JMENO, PRIJMENI, STAV
FROM ZAKAZNIK Z JOIN OBJEDNAVKA O ON Z.ZAKAZNIKID = O.ZAKAZNIK      -- vnitřne spojime tabulky ZAKAZNIK a OBJEDNAVKA
WHERE O.DATUM = TO_DATE('2022-03-02','YYYY-MM-DD')                  -- na zaklade rovnosti
  AND NOT EXISTS (                                                  -- NOT vyraz
      SELECT *
      FROM OBJEDNAVKA O
      WHERE  Z.ZAKAZNIKID = O.ZAKAZNIK                              -- vyraz = kdyz zakaznik mel jeste objednavky
        AND  O.DATUM <> TO_DATE('2022-03-02','YYYY-MM-DD'));      -- v jinych dnech = 1



----------------------------------------------    4 cast ulohy       ---------------------------------------------------

---------------------- EXPLAIN PLAN



-- bez indexů
-- ktera surovina je nejvic "spotrebovana" s ohledem na objednane polozky
EXPLAIN PLAN FOR
    SELECT COUNT(Surovina.cislo_suroviny), Surovina.nazev
    FROM Surovina, Obsahuje, Polozka
    WHERE Polozka.cislo_peciva = Obsahuje.cislo_peciva AND Obsahuje.cislo_suroviny = Surovina.cislo_suroviny
    GROUP BY Surovina.nazev, Surovina.cislo_suroviny
    ORDER BY COUNT(Surovina.cislo_suroviny) DESC;

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());

--------- s indexy

CREATE INDEX i_surovina ON SUROVINA(CISLO_SUROVINY, NAZEV);
CREATE INDEX i_obsahuje ON OBSAHUJE(CISLO_SUROVINY, CISLO_PECIVA);


EXPLAIN PLAN FOR
    SELECT COUNT(Surovina.cislo_suroviny), Surovina.nazev
    FROM Surovina, Obsahuje, Polozka
    WHERE Polozka.cislo_peciva = Obsahuje.cislo_peciva AND Obsahuje.cislo_suroviny = Surovina.cislo_suroviny
    GROUP BY Surovina.nazev, Surovina.cislo_suroviny
    ORDER BY COUNT(Surovina.cislo_suroviny) DESC;

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());

DROP INDEX i_surovina;
DROP INDEX i_obsahuje;

------------------  TRIGGER   ( viz radek 60)

------------------ Procedury

CREATE OR REPLACE PROCEDURE INCOME_FROM_TO (datum_od OBJEDNAVKA.datum%TYPE, datum_do OBJEDNAVKA.datum%TYPE) AS
    BEGIN
        DECLARE CURSOR income_cursor IS
            SELECT FAKTURA.celkova_castka, Objednavka.datum
            FROM FAKTURA, OBJEDNAVKA
            WHERE Faktura.cislo_faktury = Objednavka.cislo_faktury;
                celkem NUMBER;
                datum_objednani OBJEDNAVKA.datum%type;
                castka_objednavka FAKTURA.celkova_castka%type;
                BEGIN
                    celkem := 0;
                    open income_cursor;
                    LOOP
                        <<START>>
                        FETCH income_cursor INTO castka_objednavka, datum_objednani;
                        EXIT WHEN income_cursor%NOTFOUND;
                        IF datum_objednani < TO_DATE(datum_od, 'dd.mm.yyyy') THEN CONTINUE;
                        ELSIF datum_objednani > TO_DATE(datum_do, 'dd.mm.yyyy') THEN EXIT;
                        end if;
                        celkem := celkem + castka_objednavka;
                    end loop;
                    DBMS_OUTPUT.PUT_LINE('Zisk za dobu od ' || datum_od || ' do ' || datum_do || ' je ' || celkem);
                    close income_cursor;
                end;
    end;

-- zjistuje jake mnozstvi dane suroviny bylo spotrebovano na objednavky od urciteho data
CREATE OR REPLACE PROCEDURE INGREDIENT_CONSUMPTION(surovina_ID Surovina.cislo_suroviny%TYPE, datum_od OBJEDNAVKA.datum%TYPE) AS
    BEGIN
        DECLARE CURSOR obsahuje_cursor is
            SELECT Obsahuje.cislo_suroviny, Obsahuje.gramaz
            FROM Polozka, Faktura, Objednavka, Obsahuje
            WHERE Faktura.cislo_objednavky = Objednavka.objednavkaID and Polozka.cislo_faktury = Faktura.cislo_faktury and Objednavka.datum > datum_od;
            celkem_suroviny NUMBER;
            surovina_ID_fetched Surovina.cislo_suroviny%TYPE;
            gramaz Obsahuje.gramaz%TYPE;
            BEGIN
                celkem_suroviny := 0;
                gramaz := 0;
                OPEN obsahuje_cursor;
                LOOP
                    FETCH obsahuje_cursor INTO surovina_ID_fetched, gramaz;
                    EXIT WHEN obsahuje_cursor%NOTFOUND;
                    IF NOT surovina_ID_fetched = surovina_ID THEN CONTINUE;
                    ELSE celkem_suroviny := celkem_suroviny + gramaz;
                    END IF;
                END LOOP;
                DBMS_OUTPUT.PUT_LINE('Od '|| datum_od || ' bylo spotrebeno ' || celkem_suroviny || ' gramu suroviny c.'|| surovina_ID);
                CLOSE obsahuje_cursor;
            END;
    END;


------------------ Materializovane pohledy

CREATE MATERIALIZED VIEW LOG ON Zamestnanec WITH PRIMARY KEY, ROWID;
CREATE MATERIALIZED VIEW LOG ON Rozvoz WITH PRIMARY KEY, ROWID;

DROP MATERIALIZED VIEW PECIVO_NEJVIC_DRUHU_SUROVIN;

-- kolik druhu surovin je protreba na kazdy druh peciva
CREATE MATERIALIZED VIEW PECIVO_NEJVIC_DRUHU_SUROVIN
NOLOGGING
CACHE
BUILD IMMEDIATE
AS SELECT Obsahuje.cislo_peciva as pecivo_ID, COUNT(*)
   FROM Obsahuje JOIN Pecivo on Obsahuje.cislo_peciva = Pecivo.cislo_peciva
   GROUP BY Obsahuje.cislo_peciva;


SELECT * FROM PECIVO_NEJVIC_DRUHU_SUROVIN;

------------------ PRISTUPOVA PRAVA


GRANT ALL ON FAKTURA TO XGREBE02;
GRANT ALL ON OBJEDNAVKA TO XGREBE02;
GRANT ALL ON OBSAHUJE TO XGREBE02;
GRANT ALL ON PECIVO TO XGREBE02;
GRANT ALL ON POLOZKA TO XGREBE02;
GRANT ALL ON ROZVOZ TO XGREBE02;
GRANT ALL ON SUROVINA TO XGREBE02;
GRANT ALL ON VYZVEDNUTI TO XGREBE02;
GRANT ALL ON ZAKAZNIK TO XGREBE02;
GRANT ALL ON ZAMESTNANEC TO XGREBE02;

GRANT ALL ON PECIVO_NEJVIC_DRUHU_SUROVIN TO XGREBE02;
GRANT EXECUTE ON INGREDIENT_CONSUMPTION TO XGREBE02;
GRANT EXECUTE ON INCOME_FROM_TO TO XGREBE02;
------------------------------------------------------------------------------------------------------------------------
-----------------------xgrebe02---------------------------------xmikha00------------------------------------------------

