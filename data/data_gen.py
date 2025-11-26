import csv
import random

# Dane podstawowe
imiona = [
    "Jan", "Anna", "Piotr", "Katarzyna", "Tomasz", "Karolina", "Adam", "Ewa", "Michał", "Dorota",
    "Olga", "Marek", "Zofia", "Paweł", "Monika", "Kamil", "Agnieszka", "Andrzej", "Natalia", "Rafał"
]

nazwiska = [
    "Kowalski", "Nowak", "Wiśniewski", "Krawczyk", "Lis", "Wójcik", "Zając", "Kamińska", "Król", "Walczak",
    "Lewandowska", "Pawlak", "Baran", "Maj", "Szymański", "Grabowska", "Wieczorek", "Kubiak", "Czerwińska", "Malinowski"
]

ulice = ["Lipowa", "Długa", "Spacerowa", "Orla", "Szkolna", "Parkowa", "Różana", "Mickiewicza", "Polna", "Słoneczna"]
miasta = ["Warszawa", "Kraków", "Poznań", "Lublin", "Łódź", "Tychy", "Gdańsk", "Szczecin", "Katowice", "Rzeszów"]
kody = ["00-001", "30-400", "60-100", "20-001", "90-001", "43-100", "80-001", "70-100", "40-001", "35-100"]

produkty = [
    "Laptop", "Telefon", "Tablet", "Monitor", "Drukarka", "Mysz", "Klawiatura", "Słuchawki", "Router", "Kamera internetowa"
]

# Funkcje pomocnicze
def losowy_klient():
    return f"{random.choice(imiona)} {random.choice(nazwiska)}"

def losowy_adres():
    ulica = random.choice(ulice)
    numer = random.choice([str(random.randint(1, 50)), "", " "])
    kod = random.choice([random.choice(kody), "", " "])
    miasto = random.choice([random.choice(miasta), "", " "])
    return f"ul. {ulica} {numer}, {kod} {miasto}".strip()

def losowe_produkty():
    n = random.randint(1, 4)
    return ", ".join(random.sample(produkty, n))

# Generowanie danych
rows = []
for _ in range(123):
    rows.append({
        "dane_osobowe": losowy_klient(),
        "adres": losowy_adres(),
        "produkty": losowe_produkty()
    })

# Zapis do CSV
with open("klienci_produkty_v2.csv", "w", newline="", encoding="utf-8") as csvfile:
    writer = csv.DictWriter(csvfile, fieldnames=["dane_osobowe", "adres", "produkty"])
    writer.writeheader()
    writer.writerows(rows)

# Zapis do SQL
with open("klienci_produkty_v2.sql", "w", encoding="utf-8") as sqlfile:
    sqlfile.write("CREATE TABLE klienci (\n")
    sqlfile.write("    id INTEGER PRIMARY KEY AUTOINCREMENT,\n")
    sqlfile.write("    dane_osobowe TEXT,\n")
    sqlfile.write("    adres TEXT,\n")
    sqlfile.write("    produkty TEXT\n")
    sqlfile.write(");\n\n")

    for row in rows:
        dane_osobowe = row['dane_osobowe'].replace("'", "''")
        adres = row['adres'].replace("'", "''")
        produkty_txt = row['produkty'].replace("'", "''")
        sqlfile.write(f"INSERT INTO klienci (dane_osobowe, adres, produkty) VALUES ('{dane_osobowe}', '{adres}', '{produkty_txt}');\n")

print("✅ Pliki 'klienci_produkty_v2.csv' i 'klienci_produkty_v2.sql' zostały utworzone.")