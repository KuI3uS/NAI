#Tytuł: System prognozowania szansy na opady

#Autorzy: Dagmara Gibas s22620, Jakub Marcinkowski s21021

#Opis problemu:

#Celem jest oszacowanie prawdopodobieństwa wystąpienia opadów deszczu na podstawie parametrów takich jak ciśnienie atmosferyczne, poziom zachmurzenia oraz wilgotność względna.

#Przygotowanie środowiska:

#	1.	Zainstaluj GNU Octave (wersja 3.2.4 lub nowsza).
#	2.	Pobierz narzędzie fuzzy-logic-toolkit ze strony: https://octave.sourceforge.io/fuzzy-logic-toolkit/index.html.
#   3.	Zainstaluj toolkit, wykonując poniższe polecenie w Octave:
#   4. zainstaluj pkg install [ścieżka do pliku]/fuzzy-logic-toolkit-0.4.6.tar.gz
# 	5.	Uruchom skrypt prognozujący, używając komendy: rainfall


# załadowanie biblioteki
pkg load fuzzy-logic-toolkit

# utworzenie struktury danych typu FIS (Fuzzy Inference System)
fis = newfis('Prognoza opadow');

# przyjęty zakres wartości ciśnienia: 980-1030hPa
fis = addvar (fis, 'input', 'Cisnienie', [980 1030]);
fis = addmf (fis, 'input', 1, 'Male', 'trapmf', [979 980 1000 1010]);
fis = addmf (fis, 'input', 1, 'Srednie', 'trapmf', [1000 1010 1020 1030]);
fis = addmf (fis, 'input', 1, 'Duze', 'trapmf', [1020 1025 1030 1031]);

# dodanie do struktury FIS wejścia Zachmurzenie ogolne wraz z funkcjami przynależności
fis = addvar (fis, 'input', 'Zachmurzenie ogolne', [0 8]);
fis = addmf (fis, 'input', 2, 'Male', 'trapmf', [-1 0 2 3]);
fis = addmf (fis, 'input', 2, 'Srednie', 'trapmf', [2 3 5 6]);
fis = addmf (fis, 'input', 2, 'Duze', 'trapmf', [5 6 8 9]);

# dodanie do struktury FIS wejścia Wilgotnosc wzgledna wraz z funkcjami przynależności
fis = addvar (fis, 'input', 'Wilgotnosc wzgledna', [0 100]);
fis = addmf (fis, 'input', 3, 'Mala', 'trapmf', [-1 0 70 75]);
fis = addmf (fis, 'input', 3, 'Srednia', 'trapmf', [70 75 83 85]);
fis = addmf (fis, 'input', 3, 'Duza', 'trapmf', [83 85 100 101]);

# dodanie do struktury FIS wyjścia Szansa na deszcz wraz z funkcjami przynależności
fis = addvar (fis, 'output', 'Szansa na deszcz', [0 100]);
fis = addmf (fis, 'output', 1, 'Mala', 'trapmf', [0 10 30 40]);
fis = addmf (fis, 'output', 1, 'Srednia', 'trapmf', [30 40 60 70]);
fis = addmf (fis, 'output', 1, 'Duza', 'trapmf', [60 80 100 101]);

# wyświetlenie wykresów funkcji przynależności dla wejść oraz dla wyjścia
plotmf (fis, 'input', 1);
plotmf (fis, 'input', 2);
plotmf (fis, 'input', 3);
plotmf (fis, 'output', 1);

	#•	Parametr 1 (ciśnienie):
	#•	0 - dowolne
	#•	1 - małe
	#•	2 - średnie
	#•	3 - duże
	#•	Parametr 2 (zachmurzenie ogólne):
	#•	1 - małe
	#•	2 - średnie
	#•	3 - duże
	#•	Parametr 3 (wilgotność względna):
	#•	1 - mała
	#•	2 - średnia
	#•	3 - duża
	#•	Parametr 4 (szansa na deszcz):
	#•	1 - mała
	#•	2 - średnia
	#•	3 - duża
	#•	Parametr 5: Waga reguły
	#•	Parametr 6:
	#•	1 - AND
	#•	2 - OR
fis = addrule(fis, [0 1 1 1 1 1]);
fis = addrule(fis, [0 3 3 3 1 2]);
fis = addrule(fis, [1 2 2 2 1 1]);
fis = addrule(fis, [3 2 2 1 1 1]);
fis = addrule(fis, [0 1 2 1 1 1]);
fis = addrule(fis, [0 2 1 1 1 2]);

# wyświetlenie reguł w postaci przyjaznej użytkownikowi
showrule(fis);

# obliczenie i wyświetlenie wartości wyjść dla wybranych wartości parametrów wejściowych
puts ("\nSzansa na deszcz dla parametrow: cisnienie=1000 zachmurzenie=3 wilgotnosc=80:\n\n");
evalfis ([1000 3 80], fis)

puts ("\nSzansa na deszcz dla parametrow: cisnienie=980 zachmurzenie=8 wilgotnosc=80:\n\n");
evalfis ([980 8 80], fis)

puts ("\nSzansa na deszcz dla parametrow: cisnienie=1010 zachmurzenie=4 wilgotnosc=60:\n\n");
evalfis ([1010 4 60], fis)

puts ("\nSzansa na deszcz dla parametrow: cisnienie=1000 zachmurzenie=8 wilgotnosc=70:\n\n");
evalfis ([1000 8 70], fis)