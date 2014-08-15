defmodule Hexfmt do
  @moduledoc """
  A simple module to convert to and from hex encoded strings.
  Encodes / decodes both lists and binaries.
  Based on work by https://github.com/rjsamson/hex
  Changed the name to avoid conflict with https://hex.pm
  Added print helpers for hex formatted string data.
  """

  @doc """
  Returns a hex encoded binary from a list, binary or integer.

  ## Examples

      iex> Hexfmt.encode("12345678")
      "3132333435363738"

      iex> Hexfmt.encode('12345678')
      "3132333435363738"

      iex> Hexfmt.encode(12345678)
      "BC614E"
  """
  def encode(str) when is_binary(str) or is_list(str) do
    encode_do(str, "")
  end

  def encode(int) when is_integer(int) do
    :erlang.integer_to_binary(int, 16)
  end

  defp encode_do(<<>>, acc) do
    acc
  end

  defp encode_do(<<x::size(8), remain::binary>>, acc) do
    encode_do_step(x, remain, acc)
  end

  defp encode_do([], acc) do
    acc
  end

  defp encode_do([x | remain], acc) do
    encode_do_step(x, remain, acc)
  end

  defp encode_do_step(x, remain, acc) do
    x2 = :erlang.integer_to_binary(x, 16)
    encode_do(remain, acc <> x2)
  end

  @doc """
  Returns a hex encoded binary from a list, binary or integer.
  The output is prefixed with 0x to mark hex type data

  ## Examples

      iex> Hexfmt.encodep("12345678")
      "0x3132333435363738"

      iex> Hexfmt.encodep('12345678')
      "0x3132333435363738"

      iex> Hexfmt.encodep(12345678)
      "0xBC614E"
  """
  def encodep(x)  do
    "0x" <> encode(x)
  end

  @doc """
  Returns a hex encoded list from a list, binary or integer.

  ## Examples

      iex> Hexfmt.encode_to_list("12345678")
      '3132333435363738'

      iex> Hexfmt.encode_to_list('12345678')
      '3132333435363738'

      iex> Hexfmt.encode_to_list(12345678)
      'BC614E'
  """
  def encode_to_list(str) when is_binary(str) or is_list(str) do
    encode_to_list_do(str, [])
  end

  def encode_to_list(int) when is_integer(int) do
    :erlang.integer_to_list(int, 16)
  end

  defp encode_to_list_do(<<>>, acc) do
    Enum.reverse(acc)
  end

  defp encode_to_list_do(<<x::size(8), remain::binary>>, acc) do
    encode_to_list_do_step(x, remain, acc)
  end

  defp encode_to_list_do([], acc) do
    Enum.reverse(acc)
  end

  defp encode_to_list_do([x | remain], acc) do
    encode_to_list_do_step(x, remain, acc)
  end

  defp encode_to_list_do_step(x, remain, acc) do
    case :erlang.integer_to_list(x, 16) do
      [a, b] ->
        encode_to_list_do(remain, [b, a | acc])
      [b] ->
        encode_to_list_do(remain, [b, ?0 | acc])
    end
  end

  @doc """
  Returns a decoded binary from a hex string in either list
  or binary form.

  ## Examples

      iex> Hexfmt.decode("3132333435363738")
      "12345678"

      iex> Hexfmt.decode('3132333435363738')
      "12345678"

      iex> Hexfmt.decode("0x3132333435363738")
      "12345678"

      iex> Hexfmt.decode('0x3132333435363738')
      "12345678"
  """
  def decode(hex_str) when is_binary(hex_str) do
    if String.starts_with?(hex_str, "0x") do
      <<"0x", hex_str2::binary>> = hex_str
      decode_do(hex_str2, "")
    else 
      decode_do(hex_str, "")   
    end   
  end

  def decode(hex_str) when is_list(hex_str) do 
    [a, b | hex_str2] = hex_str
    if [a, b] == '0x' do
      decode_do(hex_str2, "")
    else
      decode_do(hex_str, "")
    end
  end

  defp decode_do(<<>>, acc) do
    acc
  end

  defp decode_do(<<x::size(8), y::size(8), remain::binary>>, acc) do
    decode_do_step(x, y, remain, acc)
  end

  defp decode_do([], acc) do
    acc
  end

  defp decode_do([x, y | remain], acc) do
    decode_do_step(x, y, remain, acc)
  end

  defp decode_do_step(x, y, remain, acc) do
    x2 = :erlang.binary_to_integer(<<x, y>>, 16)
    decode_do(remain, acc <> <<x2::size(8)>>)
  end

  @doc """
  Returns a decoded list from a hex string in either list
  or binary form.

  ## Examples

      iex> Hexfmt.decode_to_list("3132333435363738")
      '12345678'

      iex> Hexfmt.decode_to_list('3132333435363738')
      '12345678'
  """
  def decode_to_list(hex_str) when is_binary(hex_str) do
    if String.starts_with?(hex_str, "0x") do
      <<"0x", hex_str2::binary>> = hex_str
      decode_to_list_do(hex_str2, [])
    else 
      decode_to_list_do(hex_str, [])   
    end   
  end

  def decode_to_list(hex_str) when is_list(hex_str) do 
    [a, b | hex_str2] = hex_str
    if [a, b] == '0x' do
      decode_to_list_do(hex_str2, [])
    else
      decode_to_list_do(hex_str, [])
    end
  end

  defp decode_to_list_do(<<>>, acc) do
    Enum.reverse(acc)
  end

  defp decode_to_list_do(<<x::size(8), y::size(8), remain::binary>>, acc) do
    decode_to_list_do_step(x, y, remain, acc)
  end

  defp decode_to_list_do([], acc) do
    Enum.reverse(acc)
  end

  defp decode_to_list_do([x, y | remain], acc) do
    decode_to_list_do_step(x, y, remain, acc)
  end

  defp decode_to_list_do_step(x, y, remain, acc) do
    x2 = :erlang.binary_to_integer(<<x, y>>, 16)
    decode_to_list_do(remain, [x2 | acc])
  end

  @doc """
  Returns an hex string visual representation of a given 
  list or binary.

  ## Examples

      iex> Hexfmt.hexify([0x12, 0x34, 0x56, 0x78])
      "[0x12, 0x34, 0x56, 0x78]"

      iex> Hexfmt.hexify(<<0x12, 0x34, 0x56, 0x78>>)
      "<<0x12, 0x34, 0x56, 0x78>>"

      iex> Hexfmt.hexify([18, 52, 86, 120])
      "[0x12, 0x34, 0x56, 0x78]"

      iex> Hexfmt.hexify(<<18, 52, 86, 120>>)
      "<<0x12, 0x34, 0x56, 0x78>>"

      iex> Hexfmt.hexify('1!')
      "[0x31, 0x21]"
  """
  def hexify(str) when is_list(str) do
    "[" <> hexify_do(str, "") <> "]"
  end

  def hexify(str) when is_binary(str) do
    "<<" <> hexify_do(str, "") <> ">>"
  end

  defp hexify_do(<<x::size(8)>>, acc) do
    hexify_do_step1(x, acc)
  end

  defp hexify_do(<<x::size(8), remain::binary>>, acc) do
    hexify_do_step(x, remain, acc)
  end

  defp hexify_do([x], acc) do
    hexify_do_step1(x, acc)
  end

  defp hexify_do([x | remain], acc) do
    hexify_do_step(x, remain, acc)
  end

  defp hexify_do_step1(x, acc) do
    x2 = :erlang.integer_to_binary(x, 16)
    acc <> <<"0x", x2::binary>>
  end

  defp hexify_do_step(x, remain, acc) do
    x2 = :erlang.integer_to_binary(x, 16)
    hexify_do(remain, acc <> <<"0x", x2::binary, ", ">>)
  end

  @doc """
  Returns an integer representation of a given string of hex,
  taking a list or a binary as an argument.

  ## Examples

      iex> Hexfmt.to_integer('3132333435363738')
      3544952156018063160

      iex> Hexfmt.to_integer("3132333435363738")
      3544952156018063160
  """
  def to_integer(hex_str) when is_list(hex_str) do
    :erlang.list_to_integer(hex_str, 16)
  end

  def to_integer(hex_str) when is_binary(hex_str) do
    :erlang.binary_to_integer(hex_str, 16)
  end
end
