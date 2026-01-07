-- CZYSZCZENIE (dla pewności przy przeładowaniu)
DROP TABLE IF EXISTS przydzialy CASCADE;
DROP TABLE IF EXISTS historia_pensji CASCADE;
DROP TABLE IF EXISTS logi_operacji CASCADE;
DROP TABLE IF EXISTS pracownicy CASCADE;
DROP TABLE IF EXISTS dzialy CASCADE;
DROP TABLE IF EXISTS projekty CASCADE;

-- 1. STRUKTURA
CREATE TABLE dzialy (
    id_dzialu SERIAL PRIMARY KEY,
    nazwa_dzialu VARCHAR(50) NOT NULL,
    lokalizacja VARCHAR(50)
);

CREATE TABLE projekty (
    id_projektu SERIAL PRIMARY KEY,
    nazwa_projektu VARCHAR(100) NOT NULL,
    typ_projektu VARCHAR(50)
);

CREATE TABLE pracownicy (
    id_pracownika SERIAL PRIMARY KEY,
    imie VARCHAR(50) NOT NULL,
    nazwisko VARCHAR(50) NOT NULL,
    pensja NUMERIC(10, 2) CHECK (pensja > 0),
    id_dzialu INTEGER REFERENCES dzialy(id_dzialu),
    id_menedzera INTEGER REFERENCES pracownicy(id_pracownika)
);

CREATE TABLE przydzialy (
    id_pracownika INTEGER REFERENCES pracownicy(id_pracownika),
    id_projektu INTEGER REFERENCES projekty(id_projektu),
    czas_pracy_h INTEGER,
    PRIMARY KEY (id_pracownika, id_projektu)
);

CREATE TABLE logi_operacji (
    id_logu SERIAL PRIMARY KEY,
    uzytkownik VARCHAR(50) DEFAULT current_user,
    czas_operacji TIMESTAMP DEFAULT now(),
    opis_zmiany TEXT
);

CREATE TABLE historia_pensji (
    id_historii SERIAL PRIMARY KEY,
    id_pracownika INTEGER,
    stara_pensja NUMERIC,
    nowa_pensja NUMERIC,
    data_zmiany TIMESTAMP DEFAULT now()
);

-- 2. DANE: DZIAŁY
INSERT INTO dzialy (nazwa_dzialu, lokalizacja) VALUES 
('Zarząd', 'Warszawa'),
('IT', 'Warszawa'), 
('HR', 'Kraków'), 
('Finanse', 'Gdańsk'),
('Marketing', 'Wrocław'),
('R&D', 'Lublin');

-- 3. DANE: PRACOWNICY (Struktura hierarchiczna)
-- Zarząd
INSERT INTO pracownicy (imie, nazwisko, pensja, id_dzialu, id_menedzera) VALUES
('Robert', 'Lewandowski', 25000, 1, NULL); -- ID 1 (Prezes)

-- Menedżerowie
INSERT INTO pracownicy (imie, nazwisko, pensja, id_dzialu, id_menedzera) VALUES
('Anna', 'Programistyczna', 18000, 2, 1), -- ID 2 (Szef IT)
('Piotr', 'Kadrowy', 14000, 3, 1),        -- ID 3 (Szef HR)
('Marta', 'Skarbnik', 15000, 4, 1);       -- ID 4 (Szef Finansów)

-- Zespół IT (podlegają Annie - ID 2)
INSERT INTO pracownicy (imie, nazwisko, pensja, id_dzialu, id_menedzera) VALUES
('Jan', 'Kowalski', 9000, 2, 2),
('Łukasz', 'Webowy', 8500, 2, 2),
('Katarzyna', 'Bazodanowa', 11000, 2, 2),
('Michał', 'Mobilny', 9500, 2, 2),
('Szymon', 'Devops', 12000, 2, 2);

-- Zespół HR (podlegają Piotrowi - ID 3)
INSERT INTO pracownicy (imie, nazwisko, pensja, id_dzialu, id_menedzera) VALUES
('Ewa', 'Rekrutacyjna', 6000, 3, 3),
('Karolina', 'Szkoleniowa', 6500, 3, 3);

-- Zespół Finanse (podlegają Marcie - ID 4)
INSERT INTO pracownicy (imie, nazwisko, pensja, id_dzialu, id_menedzera) VALUES
('Tadeusz', 'Księgowy', 7000, 4, 4),
('Alicja', 'Analityk', 8000, 4, 4);

-- Marketing (brak menedżera bezpośredniego w dziale, podlegają Prezesowi)
INSERT INTO pracownicy (imie, nazwisko, pensja, id_dzialu, id_menedzera) VALUES
('Iga', 'Socialowa', 5500, 5, 1),
('Kamil', 'Grafik', 6000, 5, 1),
('Oliwia', 'Eventowa', 5800, 5, 1);

-- R&D (Dział bez pracowników - dla testów LEFT JOIN)

-- 4. DANE: PROJEKTY
INSERT INTO projekty (nazwa_projektu, typ_projektu) VALUES
('System Cloud', 'Software'),
('Aplikacja Mobilna v2', 'Software'),
('Optymalizacja Podatków', 'Finanse'),
('Nowa Kultura Organizacyjna', 'HR'),
('Kampania Letnia', 'Marketing'),
('Sztuczna Inteligencja', 'R&D'),
('Portal Klienta', 'Software'),
('Restrukturyzacja Działów', 'Zarząd');

-- 5. DANE: PRZYDZIAŁY (Relacja wiele-do-wielu)
INSERT INTO przydzialy (id_pracownika, id_projektu, czas_pracy_h) VALUES
(2, 1, 40), (5, 1, 160), (7, 1, 120), (9, 1, 80),   -- Cloud Team
(2, 2, 20), (6, 2, 140), (8, 2, 100),              -- Mobile Team
(4, 3, 60), (12, 3, 150), (13, 3, 110),            -- Finanse Team
(3, 4, 40), (10, 4, 100), (11, 4, 80),             -- HR Team
(14, 5, 120), (15, 5, 90), (16, 5, 70),            -- Marketing Team
(1, 8, 50), (2, 8, 10), (3, 8, 10), (4, 8, 10);    -- Board Strategy