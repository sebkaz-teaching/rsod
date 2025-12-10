-- ************************************************************
-- ************* ROZWIĄZANIA ĆWICZEŃ SQL - POSTGRESQL ***********
-- ************************************************************

-- 1. PRZYGOTOWANIE BAZY DANYCH (DDL + INSERT)
----------------------------------------------------------------

-- Usuwanie tabel, jeśli istnieją, aby umożliwić ponowne uruchomienie skryptu
DROP TABLE IF EXISTS przydzialy;
DROP TABLE IF EXISTS pracownicy;
DROP TABLE IF EXISTS dzialy;
DROP TABLE IF EXISTS projekty;

-- Tworzenie tabel
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
    id_dzialu INTEGER REFERENCES dzialy(id_dzialu)
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
-- Tabela dzialy
INSERT INTO dzialy (nazwa_dzialu, lokalizacja) VALUES
(1, 'IT', 'Warszawa'),
(2, 'HR', 'Kraków'),
(3, 'Finanse', 'Gdańsk'),
(4, 'Sprzedaż', 'Warszawa'),
(5, 'Badania i Rozwój', NULL);

-- Tabela pracownicy (ID 9 to Natalia Kaczmarek - zostanie usunięta w zadaniu 10)
INSERT INTO pracownicy (id_pracownika, imie, nazwisko, stanowisko, pensja, id_dzialu) VALUES
(1, 'Anna', 'Kowalska', 'Starszy Programista', 80000.00, 1),
(2, 'Piotr', 'Nowak', 'Analityk Finansowy', 55000.00, 3),
(3, 'Ewa', 'Wiśniewska', 'HR Specialist', 45000.00, 2),
(4, 'Tomasz', 'Zieliński', 'Młodszy Programista', 60000.00, 1),
(5, 'Marta', 'Szymańska', 'Kierownik Sprzedaży', 75000.00, 4),
(6, 'Krzysztof', 'Dąbrowski', 'Programista', 70000.00, 1),
(7, 'Magda', 'Lewandowska', 'Analityk Biznesowy', 62000.00, 3),
(8, 'Grzegorz', 'Wójcik', 'Dyrektor HR', 90000.00, 2),
(9, 'Natalia', 'Kaczmarek', 'Asystentka', 40000.00, 4),
(10, 'Rafał', 'Jankowski', 'Specjalista ds. B+R', 65000.00, 5),
(11, 'Olga', 'Lisiecka', 'Stażysta', 30000.00, NULL);

-- Tabela projekty
INSERT INTO projekty (id_projektu, nazwa_projektu, typ_projektu) VALUES
(1, 'Wdrożenie CRM', 'Software'),
(2, 'Szkolenia HR', 'HR'),
(3, 'Audyt Finansowy 2024', 'Finanse'),
(4, 'Kampania Świąteczna', 'Marketing'),
(5, 'Nowy Algorytm Wyszukiwania', 'Software'),
(6, 'Innowacje Produktowe', 'Badania');

-- Tabela przydzialy
INSERT INTO przydzialy (id_pracownika, id_projektu, czas_pracy_h) VALUES
(1, 1, 120), (1, 5, 80),
(2, 3, 160),
(3, 2, 40),
(4, 1, 90), (4, 5, 50),
(5, 4, 100),
(6, 5, 110),
(10, 6, 180);


-- ************************************************************
-- 2. ROZWIĄZANIA - ĆWICZENIA PODSTAWOWE (1-10)
----------------------------------------------------------------

-- 1. Wyświetl wszystkie dane z tabeli pracownicy.
SELECT * FROM pracownicy;

-- 2. Wyświetl tylko imie, nazwisko i pensja wszystkich pracowników.
SELECT imie, nazwisko, pensja FROM pracownicy;

-- 3. Wyświetl wszystkie kolumny dla działów z tabeli dzialy.
SELECT * FROM dzialy;

-- 4. Wyświetl nazwy projektów oraz ich typ z tabeli projekty.
SELECT nazwa_projektu, typ_projektu FROM projekty;

-- 5. Znajdź wszystkich pracowników, których pensja jest niższa niż 50000.
SELECT * FROM pracownicy WHERE pensja < 50000.00;

-- 6. Znajdź pracownika o nazwisku 'Kowalska'.
SELECT * FROM pracownicy WHERE nazwisko = 'Kowalska';

-- 7. Znajdź wszystkie projekty, których typ_projektu to 'Software'.
SELECT * FROM projekty WHERE typ_projektu = 'Software';

-- 8. Wstaw nowego pracownika: Jan Kowalski, Stanowisko: Tester, Pensja: 48000, Dział: 1 (IT).
INSERT INTO pracownicy (imie, nazwisko, stanowisko, pensja, id_dzialu) 
VALUES ('Jan', 'Kowalski', 'Tester', 48000.00, 1);

-- 9. Zaktualizuj pensję pracownikowi o ID 1 (Anna Kowalska) o 5000 zł (nowa pensja to 85000.00).
UPDATE pracownicy SET pensja = 85000.00 WHERE id_pracownika = 1;

-- 10. Usuń pracownika o imieniu 'Natalia' i nazwisku 'Kaczmarek' (ID: 9).
DELETE FROM pracownicy WHERE id_pracownika = 9;


-- ************************************************************
-- 3. ROZWIĄZANIA - LOGIKA I SORTOWANIE (11-18)
----------------------------------------------------------------

-- 11. Znajdź pracowników, których pensja jest pomiędzy 50000 a 70000 (włącznie).
SELECT * FROM pracownicy WHERE pensja BETWEEN 50000.00 AND 70000.00;

-- 12. Wyświetl pracowników, którzy są 'Programistami' LUB pracują na 'Starszy Programista'.
SELECT * FROM pracownicy WHERE stanowisko = 'Programista' OR stanowisko = 'Starszy Programista';

-- 13. Wyświetl pracowników, którzy są 'Programistami' I mają pensję wyższą niż 65000.
SELECT * FROM pracownicy WHERE stanowisko = 'Programista' AND pensja > 65000.00;

-- 14. Wyświetl działy, których lokalizacja to 'Warszawa' LUB 'Gdańsk'.
SELECT * FROM dzialy WHERE lokalizacja IN ('Warszawa', 'Gdańsk');

-- 15. Wyświetl działy, które NIE znajdują się w lokalizacji 'Kraków'.
SELECT * FROM dzialy WHERE lokalizacja IS NULL OR lokalizacja <> 'Kraków'; 
-- Uwzględniamy również działy z lokalizacją NULL

-- 16. Wyświetl wszystkich pracowników, posortowanych rosnąco według nazwisko.
SELECT * FROM pracownicy ORDER BY nazwisko ASC;

-- 17. Wyświetl wszystkich pracowników, posortowanych malejąco według pensja.
SELECT * FROM pracownicy ORDER BY pensja DESC;

-- 18. Posortuj pracowników najpierw rosnąco według id_dzialu, a następnie malejąco według pensja.
SELECT * FROM pracownicy ORDER BY id_dzialu ASC, pensja DESC;


-- ************************************************************
-- 4. ROZWIĄZANIA - UNIKATOWE WART. I WZORCE (19-24)
----------------------------------------------------------------

-- 19. Wyświetl listę unikatowych stanowisk w firmie.
SELECT DISTINCT stanowisko FROM pracownicy;

-- 20. Wyświetl unikatowe lokalizacje działów.
SELECT DISTINCT lokalizacja FROM dzialy WHERE lokalizacja IS NOT NULL;

-- 21. Znajdź pracowników, których nazwisko zaczyna się na literę 'L'.
SELECT * FROM pracownicy WHERE nazwisko LIKE 'L%';

-- 22. Znajdź działy, których nazwa ma 'Rozwój' w dowolnym miejscu.
SELECT * FROM dzialy WHERE nazwa_dzialu LIKE '%Rozwój%';

-- 23. Znajdź pracowników, których trzecia litera w imie to 'm'.
SELECT * FROM pracownicy WHERE imie LIKE '__m%';

-- 24. Znajdź projekty, których nazwa_projektu kończy się na słowo 'HR' lub '2024'.
SELECT * FROM projekty WHERE nazwa_projektu LIKE '%HR' OR nazwa_projektu LIKE '%2024';


-- ************************************************************
-- 5. ROZWIĄZANIA - AGREGACJA I GRUPOWANIE (25-35)
----------------------------------------------------------------

-- 25. Oblicz średnią pensję dla wszystkich pracowników.
SELECT AVG(pensja) AS srednia_pensja FROM pracownicy;

-- 26. Oblicz najwyższą i najniższą pensję w firmie.
SELECT MAX(pensja) AS max_pensja, MIN(pensja) AS min_pensja FROM pracownicy;

-- 27. Policz całkowitą liczbę pracowników w firmie.
SELECT COUNT(*) AS liczba_pracownikow FROM pracownicy;

-- 28. Oblicz średnią pensję dla każdego unikatowego stanowiska.
SELECT stanowisko, AVG(pensja) AS srednia_pensja FROM pracownicy GROUP BY stanowisko;

-- 29. Policz, ilu pracowników zatrudnionych jest w każdym id_dzialu.
SELECT id_dzialu, COUNT(*) AS liczba_pracownikow FROM pracownicy GROUP BY id_dzialu;

-- 30. Oblicz sumę pensji (SUM) dla każdego działu (z pogrupowaniem według id_dzialu).
SELECT id_dzialu, SUM(pensja) AS calkowity_koszt_pensji FROM pracownicy GROUP BY id_dzialu;

-- 31. Policz, ilu pracowników ma pensję powyżej 60000, pogrupowane według stanowisko.
SELECT stanowisko, COUNT(*) AS liczba_pracownikow FROM pracownicy WHERE pensja > 60000.00 GROUP BY stanowisko;

-- 32. Oblicz maksymalny czas_pracy_h dla każdego projektu (id_projektu).
SELECT id_projektu, MAX(czas_pracy_h) AS max_godziny FROM przydzialy GROUP BY id_projektu;

-- 33. Wyświetl tylko te id_dzialu, w których średnia pensja jest wyższa niż 60000.
SELECT id_dzialu, AVG(pensja) AS srednia_pensja FROM pracownicy GROUP BY id_dzialu HAVING AVG(pensja) > 60000.00;

-- 34. Znajdź stanowiska, na których pracuje więcej niż 1 osoba.
SELECT stanowisko, COUNT(*) AS liczba_osob FROM pracownicy GROUP BY stanowisko HAVING COUNT(*) > 1;

-- 35. Wyświetl id_projektu tylko te, dla których całkowity czas pracy (SUMA) przekracza 200 godzin.
SELECT id_projektu, SUM(czas_pracy_h) AS suma_godzin FROM przydzialy GROUP BY id_projektu HAVING SUM(czas_pracy_h) > 200;


-- ************************************************************
-- 6. ROZWIĄZANIA - ŁĄCZENIE TABEL (JOIN) (36-45)
----------------------------------------------------------------

-- 36. INNER JOIN: Pomiń pracowników bez działu.
SELECT 
    p.imie, p.nazwisko, d.nazwa_dzialu 
FROM 
    pracownicy p
INNER JOIN 
    dzialy d ON p.id_dzialu = d.id_dzialu;

-- 37. LEFT JOIN: Uwzględnij wszystkich pracowników (Olga Lisiecka będzie miała NULL dla nazwa_dzialu).
SELECT 
    p.imie, p.nazwisko, d.nazwa_dzialu 
FROM 
    pracownicy p
LEFT JOIN 
    dzialy d ON p.id_dzialu = d.id_dzialu;

-- 38. RIGHT JOIN: Uwzględnij wszystkie działy (Badania i Rozwój będzie miał NULL dla imie/nazwisko).
SELECT 
    p.imie, p.nazwisko, d.nazwa_dzialu 
FROM 
    pracownicy p
RIGHT JOIN 
    dzialy d ON p.id_dzialu = d.id_dzialu;

-- 39. FULL OUTER JOIN: Uwzględnij Olgę Lisiecką (bez działu) i Badania i Rozwój (bez pracownika).
SELECT 
    p.imie, p.nazwisko, d.nazwa_dzialu 
FROM 
    pracownicy p
FULL OUTER JOIN 
    dzialy d ON p.id_dzialu = d.id_dzialu;

-- 40. JOIN z WHERE: Pracownicy z Krakowa.
SELECT 
    p.imie, p.nazwisko, d.nazwa_dzialu
FROM 
    pracownicy p
INNER JOIN 
    dzialy d ON p.id_dzialu = d.id_dzialu
WHERE
    d.lokalizacja = 'Kraków';

-- 41. JOIN 3 Tabel (Lista Projektów).
SELECT 
    p.imie, p.nazwisko, pr.nazwa_projektu
FROM 
    pracownicy p
INNER JOIN 
    przydzialy prz ON p.id_pracownika = prz.id_pracownika
INNER JOIN 
    projekty pr ON prz.id_projektu = pr.id_projektu;

-- 42. LEFT JOIN (Projekty po lewej): Pokaż wszystkie projekty, nawet bez przydziału (jeśli byłyby).
-- W naszym zbiorze danych wszystkie projekty mają przydziały, ale struktura zapytania jest kluczowa.
SELECT 
    pr.nazwa_projektu, p.imie, p.nazwisko
FROM 
    projekty pr
LEFT JOIN 
    przydzialy prz ON pr.id_projektu = prz.id_projektu
LEFT JOIN 
    pracownicy p ON prz.id_pracownika = p.id_pracownika;

-- 43. JOIN z ORDER BY: Sortowanie według pensji.
SELECT 
    p.imie, p.nazwisko, p.pensja, d.nazwa_dzialu 
FROM 
    pracownicy p
INNER JOIN 
    dzialy d ON p.id_dzialu = d.id_dzialu
ORDER BY 
    p.pensja DESC;

-- 44. JOIN z Agregacją (4 Tabele): Całkowita liczba godzin na projektach dla każdego działu.
SELECT 
    d.nazwa_dzialu, SUM(prz.czas_pracy_h) AS suma_godzin_projektowych
FROM 
    dzialy d
INNER JOIN 
    pracownicy p ON d.id_dzialu = p.id_dzialu
INNER JOIN 
    przydzialy prz ON p.id_pracownika = prz.id_pracownika
GROUP BY 
    d.nazwa_dzialu;

-- 45. JOIN i DISTINCT: Unikatowe nazwy projektów dla działu 'IT'.
SELECT DISTINCT
    pr.nazwa_projektu
FROM 
    projekty pr
INNER JOIN 
    przydzialy prz ON pr.id_projektu = prz.id_projektu
INNER JOIN 
    pracownicy p ON prz.id_pracownika = p.id_pracownika
INNER JOIN 
    dzialy d ON p.id_dzialu = d.id_dzialu
WHERE
    d.nazwa_dzialu = 'IT';


-- ************************************************************
-- 7. ROZWIĄZANIA - PL/pgSQL (46-50)
----------------------------------------------------------------

-- 46. BLOK ANONIMOWY (DO)
DO $$
DECLARE
    a INTEGER := 10;
    b INTEGER := 5;
    wynik INTEGER;
BEGIN
    wynik := a * b;
    RAISE NOTICE 'Wynik mnożenia % * % wynosi: %', a, b, wynik;
END $$;

-- 47. PROSTA FUNKCJA (Obliczanie)
CREATE OR REPLACE FUNCTION oblicz_roczny_koszt(pensja_m NUMERIC)
RETURNS NUMERIC AS $$
BEGIN
    RETURN pensja_m * 12;
END;
$$ LANGUAGE plpgsql;

-- Test:
SELECT oblicz_roczny_koszt(80000.00);

-- 48. FUNKCJA Z KWERENDĄ (SELECT INTO)
CREATE OR REPLACE FUNCTION pobierz_pensje_pracownika(pracownik_id INTEGER)
RETURNS NUMERIC AS $$
DECLARE
    pensja_result NUMERIC;
BEGIN
    SELECT pensja INTO pensja_result FROM pracownicy WHERE id_pracownika = pracownik_id;
    RETURN