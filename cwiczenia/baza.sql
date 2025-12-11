-- Tworzenie tabel
-- ----------------------------------------------------

CREATE TABLE dzialy (
    id_dzialu SERIAL PRIMARY KEY,
    nazwa_dzialu VARCHAR(50) NOT NULL,
    lokalizacja VARCHAR(50)
);

CREATE TABLE pracownicy (
    id_pracownika SERIAL PRIMARY KEY,
    imie VARCHAR(50) NOT NULL,
    nazwisko VARCHAR(50) NOT NULL,
    stanowisko VARCHAR(50),
    pensja NUMERIC(10, 2),
    id_dzialu INTEGER REFERENCES dzialy(id_dzialu) -- Może być NULL, dla celów LEFT JOIN
);

CREATE TABLE projekty (
    id_projektu SERIAL PRIMARY KEY,
    nazwa_projektu VARCHAR(100) NOT NULL,
    typ_projektu VARCHAR(50)
);

CREATE TABLE przydzialy (
    id_pracownika INTEGER REFERENCES pracownicy(id_pracownika) NOT NULL,
    id_projektu INTEGER REFERENCES projekty(id_projektu) NOT NULL,
    czas_pracy_h INTEGER,
    PRIMARY KEY (id_pracownika, id_projektu)
);


-- Wypełnianie tabel danymi
-- ----------------------------------------------------

-- Tabela dzialy
INSERT INTO dzialy (nazwa_dzialu, lokalizacja) VALUES
('IT', 'Warszawa'),
('HR', 'Kraków'),
('Finanse', 'Gdańsk'),
('Sprzedaż', 'Warszawa'),
('Badania i Rozwój', NULL); -- Dział bez określonej lokalizacji

-- Tabela pracownicy
INSERT INTO pracownicy (imie, nazwisko, stanowisko, pensja, id_dzialu) VALUES
('Anna', 'Kowalska', 'Starszy Programista', 80000.00, 1),
('Piotr', 'Nowak', 'Analityk Finansowy', 55000.00, 3),
('Ewa', 'Wiśniewska', 'HR Specialist', 45000.00, 2),
('Tomasz', 'Zieliński', 'Młodszy Programista', 60000.00, 1),
('Marta', 'Szymańska', 'Kierownik Sprzedaży', 75000.00, 4),
('Krzysztof', 'Dąbrowski', 'Programista', 70000.00, 1),
('Magda', 'Lewandowska', 'Analityk Biznesowy', 62000.00, 3),
('Grzegorz', 'Wójcik', 'Dyrektor HR', 90000.00, 2),
('Natalia', 'Kaczmarek', 'Asystentka', 40000.00, 4),
('Rafał', 'Jankowski', 'Specjalista ds. B+R', 65000.00, 5),
('Olga', 'Lisiecka', 'Stażysta', 30000.00, NULL); -- Pracownik bez przypisanego działu (dla celów JOIN)

-- Tabela projekty
INSERT INTO projekty (nazwa_projektu, typ_projektu) VALUES
('Wdrożenie CRM', 'Software'),
('Szkolenia HR', 'HR'),
('Audyt Finansowy 2024', 'Finanse'),
('Kampania Świąteczna', 'Marketing'),
('Nowy Algorytm Wyszukiwania', 'Software'),
('Innowacje Produktowe', 'Badania'); -- Projekt bez przypisanego czasu pracy (dla celów JOIN)

-- Tabela przydzialy (Relacja pracownicy <-> projekty)
-- Anna Kowalska (ID: 1)
INSERT INTO przydzialy (id_pracownika, id_projektu, czas_pracy_h) VALUES (1, 1, 120), (1, 5, 80);
-- Piotr Nowak (ID: 2)
INSERT INTO przydzialy (id_pracownika, id_projektu, czas_pracy_h) VALUES (2, 3, 160);
-- Ewa Wiśniewska (ID: 3)
INSERT INTO przydzialy (id_pracownika, id_projektu, czas_pracy_h) VALUES (3, 2, 40);
-- Tomasz Zieliński (ID: 4)
INSERT INTO przydzialy (id_pracownika, id_projektu, czas_pracy_h) VALUES (4, 1, 90), (4, 5, 50);
-- Marta Szymańska (ID: 5)
INSERT INTO przydzialy (id_pracownika, id_projektu, czas_pracy_h) VALUES (5, 4, 100);
-- Krzysztof Dąbrowski (ID: 6)
INSERT INTO przydzialy (id_pracownika, id_projektu, czas_pracy_h) VALUES (6, 5, 110);
-- Rafał Jankowski (ID: 10)
INSERT INTO przydzialy (id_pracownika, id_projektu, czas_pracy_h) VALUES (10, 6, 180);

-- Dział z ID 5 ('Badania i Rozwój') i pracownik ID 11 ('Olga Lisiecka') mają specjalne przypadki dla JOIN.
-- Projekt 'Innowacje Produktowe' (ID: 6) jest przypisany, ale nie wszystkie projekty mają przydziały (np. nie ma projektu 7).