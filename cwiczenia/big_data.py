import random
from datetime import date, timedelta

# --- Konfiguracja ---
NUM_RECORDS = 500000
OUTPUT_FILE = "massive_teachers_data.sql"
SCHOOLS = ['F.D. Roosevelt HS', 'Myers Middle School', 'Lincoln High School', 'Jefferson Elementary', 'Kennedy Middle School']
FIRST_NAMES = ['Adam', 'Anna', 'Tomasz', 'Ewa', 'Piotr', 'Kasia', 'Marek', 'Alicja', 'Jan', 'Maria']
LAST_NAMES = ['Kowalski', 'Nowak', 'Wiśniewska', 'Wójcik', 'Kowalczyk', 'Zieliński', 'Szymański', 'Woźniak', 'Dąbrowski', 'Kozłowska']
SALARY_RANGE = (30000, 75000)
START_DATE = date(1990, 1, 1)
END_DATE = date(2023, 12, 31)

def random_date(start, end):
    """Generuje losową datę w zakresie."""
    time_between_dates = end - start
    days_between_dates = time_between_dates.days
    random_number_of_days = random.randrange(days_between_dates)
    return start + timedelta(days=random_number_of_days)

def generate_insert_statements(num_records):
    """Generuje ciąg zapytań INSERT."""
    statements = []
    
    # Przyspieszenie ładowania: Użycie pojedynczego INSERT z wieloma wierszami
    chunk_size = 5000
    
    for i in range(1, num_records + 1):
        first_name = random.choice(FIRST_NAMES)
        last_name = random.choice(LAST_NAMES)
        school = random.choice(SCHOOLS)
        hire_date = random_date(START_DATE, END_DATE)
        salary = random.randrange(SALARY_RANGE[0], SALARY_RANGE[1], 100) # Pensje zaokrąglone do 100

        # Wiersz danych (używamy NULL dla id, ponieważ jest typu bigserial)
        # UWAGA: W PostgreSQL nie trzeba podawać NULL ani domyślnej wartości,
        # wystarczy pominąć kolumnę id, ale poniższy format jest uniwersalny dla CSV/copy
        # Będziemy generować format zbliżony do pojedynczego dużego INSERT.

        values = f"('{first_name}', '{last_name}', '{school}', '{hire_date.isoformat()}', {salary})"
        statements.append(values)
        
        # Jeśli osiągnięto rozmiar chunk_size lub koniec rekordów, zapisz blok INSERT
        if i % chunk_size == 0 or i == num_records:
            insert_block = "INSERT INTO teachers (first_name, last_name, school, hire_date, salary) VALUES\n"
            insert_block += ',\n'.join(statements) + ';\n'
            
            # Wyczyść listę wierszy
            statements = []
            
            yield insert_block
        
def main():
    print(f"Rozpoczęto generowanie {NUM_RECORDS:,} rekordów do pliku {OUTPUT_FILE}...")
    
    # 1. Dodaj polecenie TRUNCATE, aby wyczyścić tabelę przed wstawieniem
    with open(OUTPUT_FILE, 'w') as f:
        f.write("TRUNCATE TABLE teachers RESTART IDENTITY;\n\n")

    # 2. Generuj i zapisuj bloki INSERT
    total_written = 0
    with open(OUTPUT_FILE, 'a') as f:
        for block in generate_insert_statements(NUM_RECORDS):
            f.write(block)
            total_written += block.count('(') # Prosta estymacja liczby wierszy w bloku
            print(f"Zapisano wierszy: {total_written:,}...", end='\r')

    print(f"\nGenerowanie zakończone. Utworzono plik: {OUTPUT_FILE} z {NUM_RECORDS:,} rekordami.")
    print("Możesz teraz załadować plik do PostgreSQL.")

if __name__ == "__main__":
    main()