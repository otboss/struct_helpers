# StructHelpers

  This module provides macros that create structs with type-safe helper functions that would be found in OOP languages
  such as a constructor and getters / setters for each field. If a typing criteria is not followed then an exception
  is raised.

## Installation:

  Add to your mix.exs

  ```elixir
    [
      {:struct_helpers, "~> 0.1.3"}
    ]
  ```

## Setup:

  ```elixir
  defmodule MyModule do
    use StructHelpers

    generate_constructor(__MODULE__, %{
      field: :year,
      type_guard: :is_integer,
      default_value: 2,
      nullable: false,
      struct: nil
    },
    %{
      field: :age,
      type_guard: :is_integer,
      default_value: 10,
      nullable: true,
      struct: nil
    },
    %{
      field: :hair_details,
      type_guard: :is_struct,
      default_value: nil,
      nullable: true,
      struct: Hair
    })

  end
  ```

## Usage / Application:

  ```elixir
  MyModule.constructor(
    year: 10,
    age: 20,
    hair: Hair.constructor(
      color: "brown",
      type: "wavy"
    )
  )
  ```
  ## Result:

  <img src="https://raw.githubusercontent.com/otboss/struct_helpers/assets/assets/struct_helpers_demo.png"/>

  <br/>

Supports up to 30 attributes. If more than 30 attributes are needed you may use the generator script file (JavaScript) provided here:
<a href="https://github.com/otboss/struct_helpers/blob/master/lib/generator.js">https://github.com/otboss/struct_helpers/blob/master/lib/generator.js</a>

**However** if a struct has greater than 30 attributes chances are that it may need to be broken down to abide by the SOLID principles.

