defmodule Issues.Table do
  def create(entries) do
    find_length(entries)
    |> create_rows(entries)
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

  def create_rows(lengthes, entries) do
    [ head | tail ] = Enum.map(entries, fn entry -> create_row(entry, lengthes) end)
    divider = creat_divider(lengthes)
    [ head | [ divider | tail ] ]
  end

  def create_row(entry, lengthes) do
    Enum.zip(entry, lengthes)
    |> Enum.map(fn { value, length } -> String.pad_trailing(value, length) end)
    |> Enum.join(" | ")
  end

  def creat_divider(lengthes) do
    Enum.map(lengthes, fn length -> String.duplicate("-", length) end)
    |> Enum.join("-+-")
  end
end
