# StructHelpers

  This module provides macros that create structs with type safe the helper functions woud find in OOP languages
  such as a constructor, and getter / setter for each attribute. If typing criteria is not followed then and exception
  is raised.

  Installation:
  Add to your mix.exs

  ```elixir
    [
      {:struct_helpers, "~> 0.1.0"}
    ]
  ```

  Setup:
  ```elixir
  defmodule MyModule do
    use StructHelper

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

  Usage / Application:

  ```
  MyModule.constructor(
    year: 10,
    age: 20,
    hair: Hair.constructor(
      color: "brown",
      type: "wavy"
    )
  )
  ```

  Supports up to 30 attributes. If more than 30 attributes are needed you may use the generator script file (JavaScript) provided here:
  <a href="https://github.com/otboss/struct_helpers/blob/master/lib/generator.js">https://github.com/otboss/struct_helpers/blob/master/lib/generator.js</a>

  **However** if a struct has greater than 30 attributes chances are that it may need to be broken down to abide by the SOLID principles.

