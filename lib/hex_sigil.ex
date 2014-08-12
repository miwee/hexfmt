defmodule HexSigil do

  @doc """
  The `~h` sigil, does following
  1> takes a String containing hex characters [0..9, A..F], 
  and converts it into an Elixir binary of 8-bit hex numbers
  Example: 
    ~h{12345678} == <<0x12, 0x34, 0x56, 0x78>>
    ~h{12 34 56 78} == <<0x12, 0x34, 0x56, 0x78>>

  1> takes a String containing hex characters [0..9, A..F], 
  and converts it into an Elixir list of 8-bit hex numbers
  Example: 
    ~h{12345678}l = [0x12, 0x34, 0x56, 0x78]
    ~h{12 34 56 78}l == [0x12, 0x34, 0x56, 0x78]

  3> takes a String in form of comma seperated values, 
  and converts it into an String containing hex characters [0..9, A..F] 
  Example: 
    ~h{0x12, 0x34, 0x56, 0x78}x == "12345678"
    ~h{18, 52, 86, 120}x == "12345678"
  """  
  def sigil_h(str, [?l]) do
    str
    |> String.replace(" ", "")
    |> HexFmt.decode_to_list
  end
  def sigil_h(str, [?x]) do
    convert_to_int = fn (x) ->
      x = String.strip(x)
      if String.starts_with?(x, "0x") do
        x = String.slice(x, 2, String.length(x)-2)
        :erlang.binary_to_integer(x, 16)
      else
        :erlang.binary_to_integer(x, 10)
      end
    end

    str
    |> String.downcase
    |> String.split(",")
    |> Enum.map(convert_to_int)
    |> HexFmt.encode
  end
  def sigil_h(str, []) do
    str
    |> String.replace(" ", "")
    |> HexFmt.decode
  end
end
