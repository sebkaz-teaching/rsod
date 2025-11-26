-- Tworzenie tabeli adresy
CREATE TABLE adresy (
    adres_id INTEGER PRIMARY KEY AUTOINCREMENT,
    ulica TEXT,
    numer TEXT,
    kod TEXT,
    miasto TEXT
);

-- Przykładowe adresy
INSERT INTO adresy (ulica, numer, kod, miasto) VALUES
('Lipowa', '12', '00-001', 'Warszawa'),
('Długa', '7', '', 'Kraków'),
('Parkowa', '3', '', 'Łódź');

-- Tworzenie tabeli klienci
CREATE TABLE klienci (
    klient_id INTEGER PRIMARY KEY AUTOINCREMENT,
    dane_osobowe TEXT,
    adres_id INTEGER,
    FOREIGN KEY (adres_id) REFERENCES adresy(adres_id)
);

-- Przykładowi klienci
INSERT INTO klienci (dane_osobowe, adres_id) VALUES
('Jan Kowalski', 1),
('Anna Nowak', 2),
('Piotr Wiśniewski', 3);

-- Tworzenie tabeli zakupy
CREATE TABLE zakupy (
    klient_id INTEGER,
    produkt TEXT,
    FOREIGN KEY (klient_id) REFERENCES klienci(klient_id)
);

-- Przykładowe zakupy
INSERT INTO zakupy (klient_id, produkt) VALUES
(1, 'Laptop'),
(1, 'Telefon'),
(2, 'Monitor'),
(3, 'Tablet'),
(3, 'Mysz'),
(3, 'Klawiatura');