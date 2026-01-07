-- ============================================================
-- ROZWIĄZANIA: BLOK 1 (PODSTAWY I ZMIENNE)
-- ============================================================

-- Zadanie 1.1: Kalkulator podatkowy
DO $$ 
DECLARE 
    v_kwota NUMERIC := 1250.50;
    v_podatek_procent NUMERIC := 0.23;
    v_wynik NUMERIC;
BEGIN 
    v_wynik := v_kwota * v_podatek_procent;
    RAISE NOTICE 'Dla kwoty % zł, podatek (23%%) wynosi: % zł', v_kwota, v_wynik;
END $$;

-- Zadanie 1.2: Wizytówka pracownika (ID = 5)
DO $$
DECLARE
    v_imie TEXT;
    v_nazwisko TEXT;
    v_pensja NUMERIC;
BEGIN
    SELECT imie, nazwisko, pensja 
    INTO v_imie, v_nazwisko, v_pensja 
    FROM pracownicy 
    WHERE id_pracownika = 5;

    RAISE NOTICE 'Wizytówka -> Pracownik: % %, zarobki: % zł', v_imie, v_nazwisko, v_pensja;
END $$;

-- Zadanie 1.3: Kontroler budżetu projektu
DO $$
DECLARE
    v_godziny INTEGER;
    v_limit INTEGER := 100;
BEGIN
    -- Sprawdzamy czas pracy Jana Kowalskiego (ID 5) w projekcie Cloud (ID 1)
    SELECT czas_pracy_h INTO v_godziny 
    FROM przydzialy 
    WHERE id_pracownika = 5 AND id_projektu = 1;

    IF v_godziny > v_limit THEN
        RAISE NOTICE 'Czas pracy: %h. Projekt wymaga optymalizacji!', v_godziny;
    ELSE
        RAISE NOTICE 'Czas pracy: %h. Czas pracy w normie.', v_godziny;
    END IF;
END $$;


-- ============================================================
-- ROZWIĄZANIA: BLOK 2 (PĘTLE I PRZETWARZANIE)
-- ============================================================

-- Zadanie 2.1: Lista płac (Podstawy pętli)
DO $$
DECLARE
    v_pracownik RECORD; -- Zmienna rekordowa, która przyjmie cały wiersz
BEGIN
    RAISE NOTICE '--- LISTA PŁAC ---';
    FOR v_pracownik IN SELECT nazwisko, pensja FROM pracownicy LOOP
        RAISE NOTICE 'Pracownik: %, Pensja: % zł', v_pracownik.nazwisko, v_pracownik.pensja;
    END LOOP;
END $$;

-- Zadanie 2.2: Raport projektów IT (Filtrowanie w pętli)
DO $$
DECLARE
    v_proj RECORD;
BEGIN
    RAISE NOTICE '--- RAPORT PROJEKTÓW IT ---';
    -- Filtrujemy dane bezpośrednio w zapytaniu pętli
    FOR v_proj IN SELECT nazwa_projektu FROM projekty WHERE typ_projektu = 'Software' LOOP
        RAISE NOTICE 'Nazwa projektu: %', v_proj.nazwa_projektu;
    END LOOP;
END $$;

-- Zadanie 2.3: Analiza premii (Logika wewnątrz pętli)
DO $$
DECLARE
    v_r RECORD;
BEGIN
    RAISE NOTICE '--- ANALIZA ZAROBKÓW ---';
    FOR v_r IN SELECT nazwisko, pensja FROM pracownicy LOOP
        IF v_r.pensja > 10000 THEN
            RAISE NOTICE 'Pracownik %: Wysokie zarobki (%)', v_r.nazwisko, v_r.pensja;
        ELSE
            RAISE NOTICE 'Pracownik %: Standardowe zarobki (%)', v_r.nazwisko, v_r.pensja;
        END IF;
    END LOOP;
END $$;

-- ============================================================
-- ROZWIĄZANIA: BLOK 3 (FUNKCJE)
-- ============================================================

-- Zadanie 3.1: Pobieranie pensji
CREATE OR REPLACE FUNCTION pobierz_pensje(p_id INT) 
RETURNS NUMERIC AS $$
DECLARE
    v_pensja NUMERIC;
BEGIN
    SELECT pensja INTO v_pensja FROM pracownicy WHERE id_pracownika = p_id;
    RETURN v_pensja;
END;
$$ LANGUAGE plpgsql;

-- Test: SELECT pobierz_pensje(1);


-- Zadanie 3.2: Suma godzin
CREATE OR REPLACE FUNCTION suma_godzin_pracownika(p_id INT) 
RETURNS INTEGER AS $$
DECLARE
    v_suma_h INTEGER;
BEGIN
    SELECT SUM(czas_pracy_h) INTO v_suma_h 
    FROM przydzialy 
    WHERE id_pracownika = p_id;
    
    -- Zwracamy 0 jeśli suma wyjdzie NULL (pracownik nie ma projektów)
    RETURN COALESCE(v_suma_h, 0);
END;
$$ LANGUAGE plpgsql;

-- Test: SELECT imie, nazwisko, suma_godzin_pracownika(id_pracownika) FROM pracownicy;


-- Zadanie 3.3: Klasyfikator działu
CREATE OR REPLACE FUNCTION wielkosc_dzialu(p_id_dzialu INT) 
RETURNS TEXT AS $$
DECLARE
    v_liczba_osob INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_liczba_osob 
    FROM pracownicy 
    WHERE id_dzialu = p_id_dzialu;

    IF v_liczba_osob > 5 THEN
        RETURN 'Duży';
    ELSE
        RETURN 'Mały/Średni';
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Test: SELECT nazwa_dzialu, wielkosc_dzialu(id_dzialu) FROM dzialy;


-- ============================================================
-- ROZWIĄZANIA: BLOK 4 (TRIGGERY)
-- ============================================================

-- Zadanie 4.1: Audyt pensji
CREATE OR REPLACE FUNCTION fn_historia_pensji()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.pensja <> NEW.pensja THEN
        INSERT INTO historia_pensji(id_pracownika, stara_pensja, nowa_pensja)
        VALUES (OLD.id_pracownika, OLD.pensja, NEW.pensja);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_pensja_zmiana
AFTER UPDATE ON pracownicy
FOR EACH ROW EXECUTE FUNCTION fn_historia_pensji();

-- Zadanie 4.2: Blokada usuwania szefa
CREATE OR REPLACE FUNCTION fn_blokuj_szefa()
RETURNS TRIGGER AS $$
DECLARE
    v_czy_jest_szefem BOOLEAN;
BEGIN
    SELECT EXISTS(SELECT 1 FROM pracownicy WHERE id_menedzera = OLD.id_pracownika) 
    INTO v_czy_jest_szefem;

    IF v_czy_jest_szefem THEN
        RAISE EXCEPTION 'BŁĄD: Pracownik % % jest menedżerem! Najpierw zmień szefa jego podwładnym.', OLD.imie, OLD.nazwisko;
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_szef_ochrona
BEFORE DELETE ON pracownicy
FOR EACH ROW EXECUTE FUNCTION fn_blokuj_szefa();

-- Zadanie 4.3: Limit zarobków
CREATE OR REPLACE FUNCTION fn_limit_pensji()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.pensja > 30000 THEN
        NEW.pensja := 30000;
        RAISE NOTICE 'Próba wpisania zbyt wysokiej pensji. Skorygowano do 30 000 zł.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_limit_pensji
BEFORE INSERT OR UPDATE ON pracownicy
FOR EACH ROW EXECUTE FUNCTION fn_limit_pensji();


-- ============================================================
-- ROZWIĄZANIE ZADANIA 1: SYSTEM PREMII
-- ============================================================

-- 1. Funkcja pomocnicza
CREATE OR REPLACE FUNCTION czy_pracowity(p_id INT) 
RETURNS BOOLEAN AS $$
DECLARE
    v_suma_h INTEGER;
BEGIN
    SELECT COALESCE(SUM(czas_pracy_h), 0) INTO v_suma_h 
    FROM przydzialy WHERE id_pracownika = p_id;
    
    RETURN v_suma_h > 150;
END;
$$ LANGUAGE plpgsql;

-- 2. Procedura główna
CREATE OR REPLACE PROCEDURE wyplac_premie_roczna()
LANGUAGE plpgsql AS $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN SELECT id_pracownika, nazwisko, pensja FROM pracownicy LOOP
        IF czy_pracowity(r.id_pracownika) THEN
            -- Podwyżka o 10%
            UPDATE pracownicy 
            SET pensja = pensja * 1.10 
            WHERE id_pracownika = r.id_pracownika;
            
            -- Logowanie
            INSERT INTO logi_operacji(opis_zmiany)
            VALUES ('Pracownik ' || r.nazwisko || ' otrzymał premię 10%. Nowa pensja: ' || (r.pensja * 1.10));
            
            RAISE NOTICE 'Przyznano premię pracownikowi: %', r.nazwisko;
        END IF;
    END LOOP;
END;
$$;

-- Test: CALL wyplac_premie_roczna();


-- ============================================================
-- ROZWIĄZANIE ZADANIA 2: ZŁOTY SPADOCHRON
-- ============================================================

CREATE OR REPLACE FUNCTION fn_zloty_spadochron()
RETURNS TRIGGER AS $$
BEGIN
    -- 1. Przepisanie podwładnych pod Prezesa (ID=1)
    UPDATE pracownicy 
    SET id_menedzera = 1 
    WHERE id_menedzera = OLD.id_pracownika;
    
    -- 2. Logowanie likwidacji drogiego stanowiska
    IF OLD.pensja > 20000 THEN
        INSERT INTO logi_operacji(opis_zmiany)
        VALUES ('Likwidacja stanowiska premium: ' || OLD.nazwisko || ' (Pensja: ' || OLD.pensja || ')');
    END IF;

    RETURN OLD; -- Pozwalamy na usunięcie
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_spadochron
BEFORE DELETE ON pracownicy
FOR EACH ROW EXECUTE FUNCTION fn_zloty_spadochron();

-- Test: DELETE FROM pracownicy WHERE id_pracownika = 2; -- Anna (Szef IT) zostanie usunięta, jej zespół trafi do Prezesa.