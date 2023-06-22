defmodule War do

  def deal(deck) do
    {p1, p2} =
      deck
      # Replace all 1's with 14's to account for "ace"
      |> Enum.map(fn x -> if x == 1, do: 14, else: x end)
      |> Enum.reverse()
      |> split_deck()

    winning_pile = war(p1, p2)

    # Replace all 14's with 1's
    Enum.map(winning_pile, fn x -> if x == 14, do: 1, else: x end)
  end

  # Split deck into two alternating piles
  def split_deck(deck) do
    {Enum.take_every(deck, 2), Enum.drop_every(deck, 2)}
  end

  # War logic initialized with pile1, pile2, tied (warchest) defaulted as an empty list
  defp war(p1, p2, tied \\ [])

  # Return sorted tied pile if both piles run out of cards during a war
  defp war([], [], tied), do: Enum.sort(tied, :desc)

  # Handles the case when a pile runs out of cards during war
  defp war([], p2, tied), do: p2 ++ Enum.sort(tied, :desc)
  defp war(p1, [], tied), do: p1 ++ Enum.sort(tied, :desc)

  defp war([p1_first | p1_rest], [p2_first | p2_rest], tied) do

    # Keeps track of warCards
    cards = Enum.sort([p1_first, p2_first] ++ tied, :desc)

    cond do

      # Compare first cards of each pile
      p1_first > p2_first ->
        war(p1_rest ++ cards, p2_rest)

      p1_first < p2_first ->
        war(p1_rest, p2_rest ++ cards)

      # Tie: Add face-down cards to warCards and recursively call itself with face-up cards
      p1_rest != [] and p2_rest != [] ->
        [face_down1 | p1_rest] = p1_rest
        [face_down2 | p2_rest] = p2_rest
        war(p1_rest, p2_rest, cards ++ [face_down1, face_down2])

      # Continue comparing the next two cards of each pile
      true ->
        war(p1_rest, p2_rest, cards)
    end
  end

end
