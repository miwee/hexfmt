# Hexfmt
Hex formatter and ~h sigil for Elixir

Based on work by https://github.com/rjsamson/hex

Changed the name to avoid conflict with https://hex.pm

### Hex Formatter

Returns a hex encoded binary from a list, binary or integer.

```elixir 
iex> Hexfmt.encode("12345678")
"3132333435363738"

iex> Hexfmt.encode(12345678)
"BC614E"
```

Returns a decoded binary from a hex string

```elixir 
iex> Hexfmt.decode("3132333435363738")
"12345678"
```

Returns a hex string visual representation of a given list or binary. No need to insert leading '0', just to see the contents of a list. 

```elixir 
iex> Hexfmt.hexify('ABcd')
"[0x41, 0x42, 0x63, 0x64]"

iex> Hexfmt.hexify("ABcd")
"<<0x41, 0x42, 0x63, 0x64>>"
```

Returns a decimal string visual representation of a given list or binary. No need to insert leading '0', just to see the contents of a list. 

```elixir 
iex> Hexfmt.decify('ABcd')
"[65, 66, 99, 100]"

iex> Hexfmt.decify("ABcd")
"<<65, 66, 99, 100>>"
```

### `~h` Sigil

```elixir 
iex> import HexSigil
nil
```

takes a String containing hex characters [0..9, A..F], 
and converts it into an Elixir binary of 8-bit hex numbers

```elixir 
iex> ~h{12345678}
<<18, 52, 86, 120>>
```

takes a String in form of comma separated values, and converts it into an String containing hex characters [0..9, A..F] 

```elixir 
iex> ~h{18, 52, 86, 120}x
"12345678"
```



