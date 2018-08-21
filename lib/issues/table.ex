defmodule Issues.Table do
  def create(entries) do
    find_length(entries)
    |> pad_entries(entries)
  end

  def find_length(entries) do
    [ header | _ ] = entries
    init = List.duplicate(0, length(header))
    Enum.reduce(entries, init, fn entry, lengthes ->
      entry
      |> Enum.zip(lengthes)
      |> Enum.map(fn { current, length } -> max(String.length(current), length) end)
    end)
  end

  def pad_entries(lengthes, entries) do
  end
end
