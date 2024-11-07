#Gra ScoreLine
#Autorzy: Dagmara Gibas s22620, Jakub Marcinkowski s21021
#
#Plansza gry:
#Gra toczy się na planszy o wymiarach 5x7 (5 rzędów i 7 kolumn).
#Celem gry jest ułożenie swojego symbolu (O lub X) w jednej linii – poziomej, pionowej lub ukośnej.
#Za każde 3-4 symbole w jednej linii gracz otrzymuje 1 punkt.
#Zakończenie gry:
#Gra toczy się do momentu, aż jeden z graczy zdobędzie 3 punkty.
#
#Upewnij się, że masz zainstalowanego Pythona w wersji 3.0 lub nowszej
#pip to menedżer pakietów dla Pythona. Upewni sie ze masz go zainstalowanego.
#Biblioteka easyAI jest wymagana do działania gry. pip install easyAI lub pip install -upgrate pip
#uruchom gre i milej zabawy
from easyAI import TwoPlayerGame
from easyAI.Player import Human_Player

class ScoreLine(TwoPlayerGame):
    """Plansza jest numerowana w ten sposób:
     1  2  3  4  5  6  7
     8  9 10 11 12 13 14
     15 16 17 18 19 20 21
     22 23 24 25 26 27 28
     29 30 31 32 33 34 35
    """

    def __init__(self, players):
        """Inicjalizuje grę."""
        self.rows = 5  # liczba rzędów
        self.columns = 7  # liczba kolumn
        self.players = players  # lista graczy
        self.board = [0] * (self.rows * self.columns)  # plansza początkowo pusta
        self.current_player = 1  # zaczyna gracz 1

    def possible_moves(self):
        """Zwraca listę dostępnych ruchów."""
        return [i + 1 for i, e in enumerate(self.board) if e == 0]

    def make_move(self, move):
        """Wykonuje ruch, umieszczając symbol gracza na wybranym polu."""
        self.board[int(move) - 1] = self.current_player

    def unmake_move(self, move):
        """Cofa ruch."""
        self.board[int(move) - 1] = 0

    def lose(self):
        """Sprawdza, czy przeciwnik zdobył 3 punkty."""
        return self.get_score_for_symbol(self.opponent_index) >= 3

    def get_score_for_symbol(self, symbol):
        """Oblicza liczbę punktów zdobytych przez gracza."""
        score = 0
        for i in range(1, self.rows * self.columns):
            if self.is_in_center_of_score(i, symbol):
                score += 1
        return score

    def is_over(self):
        """Sprawdza, czy gra się skończyła."""
        return not self.possible_moves() or self.lose()

    def show(self):
        """Wyświetla planszę i wynik."""
        print("\n" + "\n".join([" ".join([[".", "O", "X"][self.board[self.columns * j + i]] for i in range(self.columns)]) for j in range(self.rows)]))
        print("\n" + str(self.get_score_for_symbol(1)) + ":" + str(self.get_score_for_symbol(2)))

    def is_position_valid(self, i):
        """Sprawdza, czy pozycja na planszy jest poprawna."""
        return 0 <= i < (self.rows * self.columns)

    def are_positions_in_row(self, pos1, pos2, pos3):
        """Sprawdza, czy podane pozycje są w jednym rzędzie."""
        return (pos1 - 1) // self.columns == (pos2 - 1) // self.columns == (pos3 - 1) // self.columns

    def make_three(self, pos1, pos2, pos3):
        """Sprawdza, czy na podanych pozycjach są takie same symbole."""
        return self.is_position_valid(pos1 - 1) and self.is_position_valid(pos2 - 1) and self.is_position_valid(pos3 - 1) and self.board[pos1 - 1] == self.board[pos2 - 1] == self.board[pos3 - 1]

    def is_not_side_border(self, pos):
        """Sprawdza, czy pozycja nie jest na bocznym brzegu planszy."""
        return (pos - 1) % self.columns != 0 and (pos - 1) % self.columns != self.columns - 1

    def is_in_center_of_score(self, pos, symbol):
        """Sprawdza, czy pozycja jest częścią zwycięskiej kombinacji."""
        return self.board[pos - 1] == symbol and (
            self.make_three(pos, pos - self.columns, pos + self.columns)
            or (self.make_three(pos, pos - 1, pos + 1) and self.are_positions_in_row(pos, pos - 1, pos + 1))
            or (self.is_not_side_border(pos) and self.make_three(pos, pos - self.columns - 1, pos + self.columns + 1))
            or (self.is_not_side_border(pos) and self.make_three(pos, pos - self.columns + 1, pos + self.columns - 1))
        )

    def scoring(self):
        """Zwraca wynik aktualnego gracza."""
        return -100 if self.lose() else 0


if __name__ == "__main__":
    from easyAI import AI_Player, Negamax

    ai_algo = Negamax(7)
    ScoreLine([Human_Player(), AI_Player(ai_algo)]).play()