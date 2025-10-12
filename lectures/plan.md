
📙 WYKŁAD 3 – NORMALIZACJA I PROJEKTOWANIE BAZ DANYCH
Temat: Jak uniknąć błędów w projektowaniu?
Cele:
nauczenie zasad normalizacji,
zrozumienie zależności funkcjonalnych,
wprowadzenie do diagramów ERD.
Zakres treści:
Problemy złego projektu: redundancja, anomalie aktualizacji, usuwania.
Pojęcie zależności funkcjonalnych.
Formy normalne (1NF–3NF, BCNF): przykłady i zastosowania.
Diagramy ERD (Entity–Relationship Diagram):
encje, atrybuty, relacje, kardynalności, identyfikatory.
Proces projektowania bazy:
analiza wymagań → model konceptualny → model logiczny → model fizyczny.
Akcent praktyczny: ćwiczenie – model bazy danych dla systemu uczelnianego.
Efekty uczenia się: potrafi projektować relacyjną bazę danych zgodnie z zasadami normalizacji.
📒 WYKŁAD 4 – TRANSAKCJE, WSPÓŁBIEŻNOŚĆ I WIDOKI
Temat: Mechanizmy zapewniania spójności danych
Cele:
poznanie zasad transakcyjności,
zrozumienie współbieżności i izolacji,
wprowadzenie do widoków i ich zastosowań.
Zakres treści:
Pojęcie transakcji i właściwości ACID:
atomicity, consistency, isolation, durability.
Problemy współbieżności:
utracone aktualizacje, odczyty brudnych danych, blokady.
Poziomy izolacji transakcji.
Widoki (Views):
definicja, zalety (abstrakcja, bezpieczeństwo),
przykłady CREATE VIEW, WITH CHECK OPTION.
Przykład – transakcje w PostgreSQL (BEGIN/COMMIT/ROLLBACK).
Akcent praktyczny: analiza równoczesnych transakcji na tej samej tabeli.
Efekty uczenia się: rozumie zasady transakcyjności i umie zastosować widoki.
📕 WYKŁAD 5 – ADMINISTRACJA, BEZPIECZEŃSTWO I KOPIE ZAPASOWE
Temat: Utrzymanie i ochrona baz danych
Cele:
poznanie zasad administrowania bazami danych,
zrozumienie bezpieczeństwa i odporności systemów bazodanowych.
Zakres treści:
Role i uprawnienia użytkowników:
GRANT, REVOKE, zarządzanie kontami.
Bezpieczeństwo danych:
szyfrowanie, kontrola dostępu, logowanie zdarzeń.
Backup i odzyskiwanie:
kopie pełne, przyrostowe, różnicowe,
replikacja i wysokie dostępności (HA).
Monitorowanie i optymalizacja:
indeksy, analiza planów zapytań.
Przegląd systemów bazodanowych:
PostgreSQL, MySQL, SQLite, MS SQL, Oracle.
Efekty uczenia się: zna metody ochrony i zarządzania bazami danych, potrafi wskazać strategie kopii zapasowych.
💡 PROJEKT ZALICZENIOWY (do realizacji na ćwiczeniach)
Temat:
Projekt i implementacja relacyjnej bazy danych wspierającej wybrany proces organizacyjny.
Etapy projektu:
Analiza problemu i identyfikacja wymagań.
(np. system rezerwacji sal, ewidencja sprzętu, biblioteka, wypożyczalnia, rejestr studentów)
Model konceptualny (ERD) i logiczny bazy danych.
Implementacja bazy w wybranym systemie (np. PostgreSQL).
Wypełnienie przykładowymi danymi, przygotowanie zapytań SQL.
Demonstracja transakcji, widoków i podstawowych mechanizmów bezpieczeństwa.
Efekty projektu:
integracja wiedzy z zakresu modelowania, SQL i zarządzania,
praktyczne umiejętności tworzenia bazy danych od podstaw,
doświadczenie w pracy zespołowej i prezentacji wyników.
📈 POWIĄZANIE Z EFEKTAMI UCZENIA SIĘ
Efekt uczenia się	Odniesienie do wykładów / projektu
Zna i rozumie algorytmy i metody w systemach BD	Wykłady 2–5
Ma wiedzę z zakresu przetwarzania danych	Wykład 1, 2
Zna standardy stosowane w BD	Wykłady 2, 5
Potrafi przygotować prezentację i prowadzić dyskusję	Projekt zespołowy
Umie wykorzystać modele w realizacji projektów BD	Wykład 3 + projekt
Integruje wiedzę techniczną i pozatechniczną	Projekt (analiza potrzeb użytkownika)
Określa priorytety w realizacji zadań	Projekt – planowanie etapów