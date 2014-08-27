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
    ~h{18, 2, 86, 120}x == "12035678"
  """  
  defmacro sigil_h(str, options) do
    quote do
      fun_sigil_h(unquote(str), unquote(options))
    end
  end

  def fun_sigil_h(str, [?l]) do
    str
    |> String.replace(" ", "")
    |> Hexfmt.decode_to_list
  end

  def fun_sigil_h(str, [?x]) do
    convert_to_int = fn (x) ->
      if String.starts_with?(x, "0x") do
        <<"0x", x2::binary>> = x
        :erlang.binary_to_integer(x2, 16)
      else
        :erlang.binary_to_integer(x, 10)
      end
    end

    str
    |> String.replace(" ", "")
    |> String.split(",")
    |> Enum.map(convert_to_int)
    |> Hexfmt.encode
  end
  
  def fun_sigil_h(str, []) do
    str
    |> String.replace(" ", "")
    |> Hexfmt.decode
  end
end
