defmodule StructHelpers do
  @moduledoc """
  This module provides macros that create structs with type-safe helper functions that would be found in OOP languages
  such as a constructor and getters / setters for each field. If a typing criteria is not followed then and exception
  is raised.

  ## Installation:
  Add to your mix.exs

  ```elixir
    [
      {:struct_helpers, "~> 0.1.0"}
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
  ## Result:

  <img src="https://raw.githubusercontent.com/otboss/struct_helpers/assets/assets/struct_helpers_demo.png"/>

  <br/>

  Supports up to 30 attributes. If more than 30 attributes are needed you may use the generator script file (JavaScript) provided here:
  <a href="https://github.com/otboss/struct_helpers/blob/master/lib/generator.js">https://github.com/otboss/struct_helpers/blob/master/lib/generator.js</a>

  **However** if a struct has greater than 30 attributes chances are that it may need to be broken down to abide by the SOLID principles.
  """

  defmacro __using__(_) do
    quote do
      import AffliatagsBackend.Macros.StructHelper
    end
  end

  @doc"""
  Generates a struct, complete with a constructor, getter and setter methods.

  Macro usage example:
      ```
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
        nullable: false,
        struct: nil
      },
      %{
        field: :hair_details,
        type_guard: :is_struct,
        default_value: %Hair{},
        nullable: true,
        struct: Hair
      })
      ```
  """
  defmacro generate_constructor(module, field_1) do

    [
        field: field_name_1,
        type_guard: guard_1,
        default_value: default_1,
        nullable: is_nullable_1,
        struct: struct_module_1
    ] = field_1 |> elem(2)


    quote do
      defstruct [
        "#{unquote(field_name_1)}": unquote(default_1)
      ]

      defp validate_field(field_name, field_value, struct_module, is_nullable, guard) do
        (Code.ensure_compiled(struct_module) |> elem(0) === :module and is_struct(field_value, struct_module))
            or (is_nullable === true and field_value === nil)
            or apply(Kernel, guard, [field_value])
      end

      def constructor(values) do
        is_params_valid =
        validate_field(unquote(field_name_1), values[unquote(field_name_1)], unquote(struct_module_1), unquote(is_nullable_1), unquote(guard_1))

        if is_params_valid === false do
          raise "type mismatch for constructor paramater(s) or required parameters are missing"
        end

        result = %{
            "#{unquote(field_name_1)}": values[unquote(field_name_1)]
        }
        struct(unquote(module), result)
      end


      def unquote(field_name_1)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_1))
      end

      if is_nil(unquote(struct_module_1)) === true do
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or unquote(guard_1)(value) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      else
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or is_struct(value, unquote(struct_module_1)) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      end
    end
  end




  @doc"""
  Generates a struct, complete with a constructor, getter and setter methods.

  Macro usage example:
      ```
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
        nullable: false,
        struct: nil
      },
      %{
        field: :hair_details,
        type_guard: :is_struct,
        default_value: %Hair{},
        nullable: true,
        struct: Hair
      })
      ```
  """
  defmacro generate_constructor(module, field_1, field_2) do

    [
        field: field_name_1,
        type_guard: guard_1,
        default_value: default_1,
        nullable: is_nullable_1,
        struct: struct_module_1
    ] = field_1 |> elem(2)

    [
        field: field_name_2,
        type_guard: guard_2,
        default_value: default_2,
        nullable: is_nullable_2,
        struct: struct_module_2
    ] = field_2 |> elem(2)


    quote do
      defstruct [
        "#{unquote(field_name_1)}": unquote(default_1),
        "#{unquote(field_name_2)}": unquote(default_2)
      ]

      defp validate_field(field_name, field_value, struct_module, is_nullable, guard) do
        (Code.ensure_compiled(struct_module) |> elem(0) === :module and is_struct(field_value, struct_module))
            or (is_nullable === true and field_value === nil)
            or apply(Kernel, guard, [field_value])
      end

      def constructor(values) do
        is_params_valid =
        validate_field(unquote(field_name_1), values[unquote(field_name_1)], unquote(struct_module_1), unquote(is_nullable_1), unquote(guard_1)) and
        validate_field(unquote(field_name_2), values[unquote(field_name_2)], unquote(struct_module_2), unquote(is_nullable_2), unquote(guard_2))

        if is_params_valid === false do
          raise "type mismatch for constructor paramater(s) or required parameters are missing"
        end

        result = %{
            "#{unquote(field_name_1)}": values[unquote(field_name_1)],
            "#{unquote(field_name_2)}": values[unquote(field_name_2)]
        }
        struct(unquote(module), result)
      end


      def unquote(field_name_1)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_1))
      end

      if is_nil(unquote(struct_module_1)) === true do
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or unquote(guard_1)(value) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      else
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or is_struct(value, unquote(struct_module_1)) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      end
      def unquote(field_name_2)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_2))
      end

      if is_nil(unquote(struct_module_2)) === true do
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or unquote(guard_2)(value) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      else
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or is_struct(value, unquote(struct_module_2)) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      end
    end
  end




  @doc"""
  Generates a struct, complete with a constructor, getter and setter methods.

  Macro usage example:
      ```
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
        nullable: false,
        struct: nil
      },
      %{
        field: :hair_details,
        type_guard: :is_struct,
        default_value: %Hair{},
        nullable: true,
        struct: Hair
      })
      ```
  """
  defmacro generate_constructor(module, field_1, field_2, field_3) do

    [
        field: field_name_1,
        type_guard: guard_1,
        default_value: default_1,
        nullable: is_nullable_1,
        struct: struct_module_1
    ] = field_1 |> elem(2)

    [
        field: field_name_2,
        type_guard: guard_2,
        default_value: default_2,
        nullable: is_nullable_2,
        struct: struct_module_2
    ] = field_2 |> elem(2)

    [
        field: field_name_3,
        type_guard: guard_3,
        default_value: default_3,
        nullable: is_nullable_3,
        struct: struct_module_3
    ] = field_3 |> elem(2)


    quote do
      defstruct [
        "#{unquote(field_name_1)}": unquote(default_1),
        "#{unquote(field_name_2)}": unquote(default_2),
        "#{unquote(field_name_3)}": unquote(default_3)
      ]

      defp validate_field(field_name, field_value, struct_module, is_nullable, guard) do
        (Code.ensure_compiled(struct_module) |> elem(0) === :module and is_struct(field_value, struct_module))
            or (is_nullable === true and field_value === nil)
            or apply(Kernel, guard, [field_value])
      end

      def constructor(values) do
        is_params_valid =
        validate_field(unquote(field_name_1), values[unquote(field_name_1)], unquote(struct_module_1), unquote(is_nullable_1), unquote(guard_1)) and
        validate_field(unquote(field_name_2), values[unquote(field_name_2)], unquote(struct_module_2), unquote(is_nullable_2), unquote(guard_2)) and
        validate_field(unquote(field_name_3), values[unquote(field_name_3)], unquote(struct_module_3), unquote(is_nullable_3), unquote(guard_3))

        if is_params_valid === false do
          raise "type mismatch for constructor paramater(s) or required parameters are missing"
        end

        result = %{
            "#{unquote(field_name_1)}": values[unquote(field_name_1)],
            "#{unquote(field_name_2)}": values[unquote(field_name_2)],
            "#{unquote(field_name_3)}": values[unquote(field_name_3)]
        }
        struct(unquote(module), result)
      end


      def unquote(field_name_1)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_1))
      end

      if is_nil(unquote(struct_module_1)) === true do
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or unquote(guard_1)(value) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      else
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or is_struct(value, unquote(struct_module_1)) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      end
      def unquote(field_name_2)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_2))
      end

      if is_nil(unquote(struct_module_2)) === true do
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or unquote(guard_2)(value) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      else
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or is_struct(value, unquote(struct_module_2)) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      end
      def unquote(field_name_3)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_3))
      end

      if is_nil(unquote(struct_module_3)) === true do
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or unquote(guard_3)(value) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      else
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or is_struct(value, unquote(struct_module_3)) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      end
    end
  end




  @doc"""
  Generates a struct, complete with a constructor, getter and setter methods.

  Macro usage example:
      ```
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
        nullable: false,
        struct: nil
      },
      %{
        field: :hair_details,
        type_guard: :is_struct,
        default_value: %Hair{},
        nullable: true,
        struct: Hair
      })
      ```
  """
  defmacro generate_constructor(module, field_1, field_2, field_3, field_4) do

    [
        field: field_name_1,
        type_guard: guard_1,
        default_value: default_1,
        nullable: is_nullable_1,
        struct: struct_module_1
    ] = field_1 |> elem(2)

    [
        field: field_name_2,
        type_guard: guard_2,
        default_value: default_2,
        nullable: is_nullable_2,
        struct: struct_module_2
    ] = field_2 |> elem(2)

    [
        field: field_name_3,
        type_guard: guard_3,
        default_value: default_3,
        nullable: is_nullable_3,
        struct: struct_module_3
    ] = field_3 |> elem(2)

    [
        field: field_name_4,
        type_guard: guard_4,
        default_value: default_4,
        nullable: is_nullable_4,
        struct: struct_module_4
    ] = field_4 |> elem(2)


    quote do
      defstruct [
        "#{unquote(field_name_1)}": unquote(default_1),
        "#{unquote(field_name_2)}": unquote(default_2),
        "#{unquote(field_name_3)}": unquote(default_3),
        "#{unquote(field_name_4)}": unquote(default_4)
      ]

      defp validate_field(field_name, field_value, struct_module, is_nullable, guard) do
        (Code.ensure_compiled(struct_module) |> elem(0) === :module and is_struct(field_value, struct_module))
            or (is_nullable === true and field_value === nil)
            or apply(Kernel, guard, [field_value])
      end

      def constructor(values) do
        is_params_valid =
        validate_field(unquote(field_name_1), values[unquote(field_name_1)], unquote(struct_module_1), unquote(is_nullable_1), unquote(guard_1)) and
        validate_field(unquote(field_name_2), values[unquote(field_name_2)], unquote(struct_module_2), unquote(is_nullable_2), unquote(guard_2)) and
        validate_field(unquote(field_name_3), values[unquote(field_name_3)], unquote(struct_module_3), unquote(is_nullable_3), unquote(guard_3)) and
        validate_field(unquote(field_name_4), values[unquote(field_name_4)], unquote(struct_module_4), unquote(is_nullable_4), unquote(guard_4))

        if is_params_valid === false do
          raise "type mismatch for constructor paramater(s) or required parameters are missing"
        end

        result = %{
            "#{unquote(field_name_1)}": values[unquote(field_name_1)],
            "#{unquote(field_name_2)}": values[unquote(field_name_2)],
            "#{unquote(field_name_3)}": values[unquote(field_name_3)],
            "#{unquote(field_name_4)}": values[unquote(field_name_4)]
        }
        struct(unquote(module), result)
      end


      def unquote(field_name_1)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_1))
      end

      if is_nil(unquote(struct_module_1)) === true do
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or unquote(guard_1)(value) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      else
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or is_struct(value, unquote(struct_module_1)) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      end
      def unquote(field_name_2)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_2))
      end

      if is_nil(unquote(struct_module_2)) === true do
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or unquote(guard_2)(value) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      else
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or is_struct(value, unquote(struct_module_2)) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      end
      def unquote(field_name_3)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_3))
      end

      if is_nil(unquote(struct_module_3)) === true do
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or unquote(guard_3)(value) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      else
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or is_struct(value, unquote(struct_module_3)) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      end
      def unquote(field_name_4)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_4))
      end

      if is_nil(unquote(struct_module_4)) === true do
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or unquote(guard_4)(value) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      else
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or is_struct(value, unquote(struct_module_4)) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      end
    end
  end




  @doc"""
  Generates a struct, complete with a constructor, getter and setter methods.

  Macro usage example:
      ```
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
        nullable: false,
        struct: nil
      },
      %{
        field: :hair_details,
        type_guard: :is_struct,
        default_value: %Hair{},
        nullable: true,
        struct: Hair
      })
      ```
  """
  defmacro generate_constructor(module, field_1, field_2, field_3, field_4, field_5) do

    [
        field: field_name_1,
        type_guard: guard_1,
        default_value: default_1,
        nullable: is_nullable_1,
        struct: struct_module_1
    ] = field_1 |> elem(2)

    [
        field: field_name_2,
        type_guard: guard_2,
        default_value: default_2,
        nullable: is_nullable_2,
        struct: struct_module_2
    ] = field_2 |> elem(2)

    [
        field: field_name_3,
        type_guard: guard_3,
        default_value: default_3,
        nullable: is_nullable_3,
        struct: struct_module_3
    ] = field_3 |> elem(2)

    [
        field: field_name_4,
        type_guard: guard_4,
        default_value: default_4,
        nullable: is_nullable_4,
        struct: struct_module_4
    ] = field_4 |> elem(2)

    [
        field: field_name_5,
        type_guard: guard_5,
        default_value: default_5,
        nullable: is_nullable_5,
        struct: struct_module_5
    ] = field_5 |> elem(2)


    quote do
      defstruct [
        "#{unquote(field_name_1)}": unquote(default_1),
        "#{unquote(field_name_2)}": unquote(default_2),
        "#{unquote(field_name_3)}": unquote(default_3),
        "#{unquote(field_name_4)}": unquote(default_4),
        "#{unquote(field_name_5)}": unquote(default_5)
      ]

      defp validate_field(field_name, field_value, struct_module, is_nullable, guard) do
        (Code.ensure_compiled(struct_module) |> elem(0) === :module and is_struct(field_value, struct_module))
            or (is_nullable === true and field_value === nil)
            or apply(Kernel, guard, [field_value])
      end

      def constructor(values) do
        is_params_valid =
        validate_field(unquote(field_name_1), values[unquote(field_name_1)], unquote(struct_module_1), unquote(is_nullable_1), unquote(guard_1)) and
        validate_field(unquote(field_name_2), values[unquote(field_name_2)], unquote(struct_module_2), unquote(is_nullable_2), unquote(guard_2)) and
        validate_field(unquote(field_name_3), values[unquote(field_name_3)], unquote(struct_module_3), unquote(is_nullable_3), unquote(guard_3)) and
        validate_field(unquote(field_name_4), values[unquote(field_name_4)], unquote(struct_module_4), unquote(is_nullable_4), unquote(guard_4)) and
        validate_field(unquote(field_name_5), values[unquote(field_name_5)], unquote(struct_module_5), unquote(is_nullable_5), unquote(guard_5))

        if is_params_valid === false do
          raise "type mismatch for constructor paramater(s) or required parameters are missing"
        end

        result = %{
            "#{unquote(field_name_1)}": values[unquote(field_name_1)],
            "#{unquote(field_name_2)}": values[unquote(field_name_2)],
            "#{unquote(field_name_3)}": values[unquote(field_name_3)],
            "#{unquote(field_name_4)}": values[unquote(field_name_4)],
            "#{unquote(field_name_5)}": values[unquote(field_name_5)]
        }
        struct(unquote(module), result)
      end


      def unquote(field_name_1)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_1))
      end

      if is_nil(unquote(struct_module_1)) === true do
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or unquote(guard_1)(value) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      else
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or is_struct(value, unquote(struct_module_1)) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      end
      def unquote(field_name_2)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_2))
      end

      if is_nil(unquote(struct_module_2)) === true do
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or unquote(guard_2)(value) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      else
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or is_struct(value, unquote(struct_module_2)) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      end
      def unquote(field_name_3)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_3))
      end

      if is_nil(unquote(struct_module_3)) === true do
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or unquote(guard_3)(value) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      else
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or is_struct(value, unquote(struct_module_3)) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      end
      def unquote(field_name_4)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_4))
      end

      if is_nil(unquote(struct_module_4)) === true do
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or unquote(guard_4)(value) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      else
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or is_struct(value, unquote(struct_module_4)) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      end
      def unquote(field_name_5)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_5))
      end

      if is_nil(unquote(struct_module_5)) === true do
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or unquote(guard_5)(value) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      else
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or is_struct(value, unquote(struct_module_5)) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      end
    end
  end




  @doc"""
  Generates a struct, complete with a constructor, getter and setter methods.

  Macro usage example:
      ```
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
        nullable: false,
        struct: nil
      },
      %{
        field: :hair_details,
        type_guard: :is_struct,
        default_value: %Hair{},
        nullable: true,
        struct: Hair
      })
      ```
  """
  defmacro generate_constructor(module, field_1, field_2, field_3, field_4, field_5, field_6) do

    [
        field: field_name_1,
        type_guard: guard_1,
        default_value: default_1,
        nullable: is_nullable_1,
        struct: struct_module_1
    ] = field_1 |> elem(2)

    [
        field: field_name_2,
        type_guard: guard_2,
        default_value: default_2,
        nullable: is_nullable_2,
        struct: struct_module_2
    ] = field_2 |> elem(2)

    [
        field: field_name_3,
        type_guard: guard_3,
        default_value: default_3,
        nullable: is_nullable_3,
        struct: struct_module_3
    ] = field_3 |> elem(2)

    [
        field: field_name_4,
        type_guard: guard_4,
        default_value: default_4,
        nullable: is_nullable_4,
        struct: struct_module_4
    ] = field_4 |> elem(2)

    [
        field: field_name_5,
        type_guard: guard_5,
        default_value: default_5,
        nullable: is_nullable_5,
        struct: struct_module_5
    ] = field_5 |> elem(2)

    [
        field: field_name_6,
        type_guard: guard_6,
        default_value: default_6,
        nullable: is_nullable_6,
        struct: struct_module_6
    ] = field_6 |> elem(2)


    quote do
      defstruct [
        "#{unquote(field_name_1)}": unquote(default_1),
        "#{unquote(field_name_2)}": unquote(default_2),
        "#{unquote(field_name_3)}": unquote(default_3),
        "#{unquote(field_name_4)}": unquote(default_4),
        "#{unquote(field_name_5)}": unquote(default_5),
        "#{unquote(field_name_6)}": unquote(default_6)
      ]

      defp validate_field(field_name, field_value, struct_module, is_nullable, guard) do
        (Code.ensure_compiled(struct_module) |> elem(0) === :module and is_struct(field_value, struct_module))
            or (is_nullable === true and field_value === nil)
            or apply(Kernel, guard, [field_value])
      end

      def constructor(values) do
        is_params_valid =
        validate_field(unquote(field_name_1), values[unquote(field_name_1)], unquote(struct_module_1), unquote(is_nullable_1), unquote(guard_1)) and
        validate_field(unquote(field_name_2), values[unquote(field_name_2)], unquote(struct_module_2), unquote(is_nullable_2), unquote(guard_2)) and
        validate_field(unquote(field_name_3), values[unquote(field_name_3)], unquote(struct_module_3), unquote(is_nullable_3), unquote(guard_3)) and
        validate_field(unquote(field_name_4), values[unquote(field_name_4)], unquote(struct_module_4), unquote(is_nullable_4), unquote(guard_4)) and
        validate_field(unquote(field_name_5), values[unquote(field_name_5)], unquote(struct_module_5), unquote(is_nullable_5), unquote(guard_5)) and
        validate_field(unquote(field_name_6), values[unquote(field_name_6)], unquote(struct_module_6), unquote(is_nullable_6), unquote(guard_6))

        if is_params_valid === false do
          raise "type mismatch for constructor paramater(s) or required parameters are missing"
        end

        result = %{
            "#{unquote(field_name_1)}": values[unquote(field_name_1)],
            "#{unquote(field_name_2)}": values[unquote(field_name_2)],
            "#{unquote(field_name_3)}": values[unquote(field_name_3)],
            "#{unquote(field_name_4)}": values[unquote(field_name_4)],
            "#{unquote(field_name_5)}": values[unquote(field_name_5)],
            "#{unquote(field_name_6)}": values[unquote(field_name_6)]
        }
        struct(unquote(module), result)
      end


      def unquote(field_name_1)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_1))
      end

      if is_nil(unquote(struct_module_1)) === true do
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or unquote(guard_1)(value) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      else
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or is_struct(value, unquote(struct_module_1)) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      end
      def unquote(field_name_2)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_2))
      end

      if is_nil(unquote(struct_module_2)) === true do
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or unquote(guard_2)(value) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      else
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or is_struct(value, unquote(struct_module_2)) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      end
      def unquote(field_name_3)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_3))
      end

      if is_nil(unquote(struct_module_3)) === true do
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or unquote(guard_3)(value) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      else
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or is_struct(value, unquote(struct_module_3)) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      end
      def unquote(field_name_4)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_4))
      end

      if is_nil(unquote(struct_module_4)) === true do
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or unquote(guard_4)(value) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      else
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or is_struct(value, unquote(struct_module_4)) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      end
      def unquote(field_name_5)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_5))
      end

      if is_nil(unquote(struct_module_5)) === true do
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or unquote(guard_5)(value) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      else
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or is_struct(value, unquote(struct_module_5)) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      end
      def unquote(field_name_6)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_6))
      end

      if is_nil(unquote(struct_module_6)) === true do
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or unquote(guard_6)(value) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      else
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or is_struct(value, unquote(struct_module_6)) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      end
    end
  end




  @doc"""
  Generates a struct, complete with a constructor, getter and setter methods.

  Macro usage example:
      ```
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
        nullable: false,
        struct: nil
      },
      %{
        field: :hair_details,
        type_guard: :is_struct,
        default_value: %Hair{},
        nullable: true,
        struct: Hair
      })
      ```
  """
  defmacro generate_constructor(module, field_1, field_2, field_3, field_4, field_5, field_6, field_7) do

    [
        field: field_name_1,
        type_guard: guard_1,
        default_value: default_1,
        nullable: is_nullable_1,
        struct: struct_module_1
    ] = field_1 |> elem(2)

    [
        field: field_name_2,
        type_guard: guard_2,
        default_value: default_2,
        nullable: is_nullable_2,
        struct: struct_module_2
    ] = field_2 |> elem(2)

    [
        field: field_name_3,
        type_guard: guard_3,
        default_value: default_3,
        nullable: is_nullable_3,
        struct: struct_module_3
    ] = field_3 |> elem(2)

    [
        field: field_name_4,
        type_guard: guard_4,
        default_value: default_4,
        nullable: is_nullable_4,
        struct: struct_module_4
    ] = field_4 |> elem(2)

    [
        field: field_name_5,
        type_guard: guard_5,
        default_value: default_5,
        nullable: is_nullable_5,
        struct: struct_module_5
    ] = field_5 |> elem(2)

    [
        field: field_name_6,
        type_guard: guard_6,
        default_value: default_6,
        nullable: is_nullable_6,
        struct: struct_module_6
    ] = field_6 |> elem(2)

    [
        field: field_name_7,
        type_guard: guard_7,
        default_value: default_7,
        nullable: is_nullable_7,
        struct: struct_module_7
    ] = field_7 |> elem(2)


    quote do
      defstruct [
        "#{unquote(field_name_1)}": unquote(default_1),
        "#{unquote(field_name_2)}": unquote(default_2),
        "#{unquote(field_name_3)}": unquote(default_3),
        "#{unquote(field_name_4)}": unquote(default_4),
        "#{unquote(field_name_5)}": unquote(default_5),
        "#{unquote(field_name_6)}": unquote(default_6),
        "#{unquote(field_name_7)}": unquote(default_7)
      ]

      defp validate_field(field_name, field_value, struct_module, is_nullable, guard) do
        (Code.ensure_compiled(struct_module) |> elem(0) === :module and is_struct(field_value, struct_module))
            or (is_nullable === true and field_value === nil)
            or apply(Kernel, guard, [field_value])
      end

      def constructor(values) do
        is_params_valid =
        validate_field(unquote(field_name_1), values[unquote(field_name_1)], unquote(struct_module_1), unquote(is_nullable_1), unquote(guard_1)) and
        validate_field(unquote(field_name_2), values[unquote(field_name_2)], unquote(struct_module_2), unquote(is_nullable_2), unquote(guard_2)) and
        validate_field(unquote(field_name_3), values[unquote(field_name_3)], unquote(struct_module_3), unquote(is_nullable_3), unquote(guard_3)) and
        validate_field(unquote(field_name_4), values[unquote(field_name_4)], unquote(struct_module_4), unquote(is_nullable_4), unquote(guard_4)) and
        validate_field(unquote(field_name_5), values[unquote(field_name_5)], unquote(struct_module_5), unquote(is_nullable_5), unquote(guard_5)) and
        validate_field(unquote(field_name_6), values[unquote(field_name_6)], unquote(struct_module_6), unquote(is_nullable_6), unquote(guard_6)) and
        validate_field(unquote(field_name_7), values[unquote(field_name_7)], unquote(struct_module_7), unquote(is_nullable_7), unquote(guard_7))

        if is_params_valid === false do
          raise "type mismatch for constructor paramater(s) or required parameters are missing"
        end

        result = %{
            "#{unquote(field_name_1)}": values[unquote(field_name_1)],
            "#{unquote(field_name_2)}": values[unquote(field_name_2)],
            "#{unquote(field_name_3)}": values[unquote(field_name_3)],
            "#{unquote(field_name_4)}": values[unquote(field_name_4)],
            "#{unquote(field_name_5)}": values[unquote(field_name_5)],
            "#{unquote(field_name_6)}": values[unquote(field_name_6)],
            "#{unquote(field_name_7)}": values[unquote(field_name_7)]
        }
        struct(unquote(module), result)
      end


      def unquote(field_name_1)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_1))
      end

      if is_nil(unquote(struct_module_1)) === true do
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or unquote(guard_1)(value) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      else
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or is_struct(value, unquote(struct_module_1)) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      end
      def unquote(field_name_2)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_2))
      end

      if is_nil(unquote(struct_module_2)) === true do
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or unquote(guard_2)(value) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      else
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or is_struct(value, unquote(struct_module_2)) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      end
      def unquote(field_name_3)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_3))
      end

      if is_nil(unquote(struct_module_3)) === true do
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or unquote(guard_3)(value) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      else
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or is_struct(value, unquote(struct_module_3)) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      end
      def unquote(field_name_4)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_4))
      end

      if is_nil(unquote(struct_module_4)) === true do
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or unquote(guard_4)(value) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      else
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or is_struct(value, unquote(struct_module_4)) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      end
      def unquote(field_name_5)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_5))
      end

      if is_nil(unquote(struct_module_5)) === true do
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or unquote(guard_5)(value) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      else
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or is_struct(value, unquote(struct_module_5)) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      end
      def unquote(field_name_6)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_6))
      end

      if is_nil(unquote(struct_module_6)) === true do
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or unquote(guard_6)(value) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      else
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or is_struct(value, unquote(struct_module_6)) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      end
      def unquote(field_name_7)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_7))
      end

      if is_nil(unquote(struct_module_7)) === true do
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or unquote(guard_7)(value) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      else
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or is_struct(value, unquote(struct_module_7)) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      end
    end
  end




  @doc"""
  Generates a struct, complete with a constructor, getter and setter methods.

  Macro usage example:
      ```
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
        nullable: false,
        struct: nil
      },
      %{
        field: :hair_details,
        type_guard: :is_struct,
        default_value: %Hair{},
        nullable: true,
        struct: Hair
      })
      ```
  """
  defmacro generate_constructor(module, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8) do

    [
        field: field_name_1,
        type_guard: guard_1,
        default_value: default_1,
        nullable: is_nullable_1,
        struct: struct_module_1
    ] = field_1 |> elem(2)

    [
        field: field_name_2,
        type_guard: guard_2,
        default_value: default_2,
        nullable: is_nullable_2,
        struct: struct_module_2
    ] = field_2 |> elem(2)

    [
        field: field_name_3,
        type_guard: guard_3,
        default_value: default_3,
        nullable: is_nullable_3,
        struct: struct_module_3
    ] = field_3 |> elem(2)

    [
        field: field_name_4,
        type_guard: guard_4,
        default_value: default_4,
        nullable: is_nullable_4,
        struct: struct_module_4
    ] = field_4 |> elem(2)

    [
        field: field_name_5,
        type_guard: guard_5,
        default_value: default_5,
        nullable: is_nullable_5,
        struct: struct_module_5
    ] = field_5 |> elem(2)

    [
        field: field_name_6,
        type_guard: guard_6,
        default_value: default_6,
        nullable: is_nullable_6,
        struct: struct_module_6
    ] = field_6 |> elem(2)

    [
        field: field_name_7,
        type_guard: guard_7,
        default_value: default_7,
        nullable: is_nullable_7,
        struct: struct_module_7
    ] = field_7 |> elem(2)

    [
        field: field_name_8,
        type_guard: guard_8,
        default_value: default_8,
        nullable: is_nullable_8,
        struct: struct_module_8
    ] = field_8 |> elem(2)


    quote do
      defstruct [
        "#{unquote(field_name_1)}": unquote(default_1),
        "#{unquote(field_name_2)}": unquote(default_2),
        "#{unquote(field_name_3)}": unquote(default_3),
        "#{unquote(field_name_4)}": unquote(default_4),
        "#{unquote(field_name_5)}": unquote(default_5),
        "#{unquote(field_name_6)}": unquote(default_6),
        "#{unquote(field_name_7)}": unquote(default_7),
        "#{unquote(field_name_8)}": unquote(default_8)
      ]

      defp validate_field(field_name, field_value, struct_module, is_nullable, guard) do
        (Code.ensure_compiled(struct_module) |> elem(0) === :module and is_struct(field_value, struct_module))
            or (is_nullable === true and field_value === nil)
            or apply(Kernel, guard, [field_value])
      end

      def constructor(values) do
        is_params_valid =
        validate_field(unquote(field_name_1), values[unquote(field_name_1)], unquote(struct_module_1), unquote(is_nullable_1), unquote(guard_1)) and
        validate_field(unquote(field_name_2), values[unquote(field_name_2)], unquote(struct_module_2), unquote(is_nullable_2), unquote(guard_2)) and
        validate_field(unquote(field_name_3), values[unquote(field_name_3)], unquote(struct_module_3), unquote(is_nullable_3), unquote(guard_3)) and
        validate_field(unquote(field_name_4), values[unquote(field_name_4)], unquote(struct_module_4), unquote(is_nullable_4), unquote(guard_4)) and
        validate_field(unquote(field_name_5), values[unquote(field_name_5)], unquote(struct_module_5), unquote(is_nullable_5), unquote(guard_5)) and
        validate_field(unquote(field_name_6), values[unquote(field_name_6)], unquote(struct_module_6), unquote(is_nullable_6), unquote(guard_6)) and
        validate_field(unquote(field_name_7), values[unquote(field_name_7)], unquote(struct_module_7), unquote(is_nullable_7), unquote(guard_7)) and
        validate_field(unquote(field_name_8), values[unquote(field_name_8)], unquote(struct_module_8), unquote(is_nullable_8), unquote(guard_8))

        if is_params_valid === false do
          raise "type mismatch for constructor paramater(s) or required parameters are missing"
        end

        result = %{
            "#{unquote(field_name_1)}": values[unquote(field_name_1)],
            "#{unquote(field_name_2)}": values[unquote(field_name_2)],
            "#{unquote(field_name_3)}": values[unquote(field_name_3)],
            "#{unquote(field_name_4)}": values[unquote(field_name_4)],
            "#{unquote(field_name_5)}": values[unquote(field_name_5)],
            "#{unquote(field_name_6)}": values[unquote(field_name_6)],
            "#{unquote(field_name_7)}": values[unquote(field_name_7)],
            "#{unquote(field_name_8)}": values[unquote(field_name_8)]
        }
        struct(unquote(module), result)
      end


      def unquote(field_name_1)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_1))
      end

      if is_nil(unquote(struct_module_1)) === true do
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or unquote(guard_1)(value) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      else
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or is_struct(value, unquote(struct_module_1)) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      end
      def unquote(field_name_2)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_2))
      end

      if is_nil(unquote(struct_module_2)) === true do
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or unquote(guard_2)(value) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      else
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or is_struct(value, unquote(struct_module_2)) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      end
      def unquote(field_name_3)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_3))
      end

      if is_nil(unquote(struct_module_3)) === true do
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or unquote(guard_3)(value) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      else
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or is_struct(value, unquote(struct_module_3)) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      end
      def unquote(field_name_4)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_4))
      end

      if is_nil(unquote(struct_module_4)) === true do
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or unquote(guard_4)(value) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      else
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or is_struct(value, unquote(struct_module_4)) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      end
      def unquote(field_name_5)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_5))
      end

      if is_nil(unquote(struct_module_5)) === true do
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or unquote(guard_5)(value) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      else
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or is_struct(value, unquote(struct_module_5)) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      end
      def unquote(field_name_6)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_6))
      end

      if is_nil(unquote(struct_module_6)) === true do
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or unquote(guard_6)(value) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      else
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or is_struct(value, unquote(struct_module_6)) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      end
      def unquote(field_name_7)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_7))
      end

      if is_nil(unquote(struct_module_7)) === true do
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or unquote(guard_7)(value) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      else
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or is_struct(value, unquote(struct_module_7)) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      end
      def unquote(field_name_8)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_8))
      end

      if is_nil(unquote(struct_module_8)) === true do
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or unquote(guard_8)(value) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      else
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or is_struct(value, unquote(struct_module_8)) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      end
    end
  end




  @doc"""
  Generates a struct, complete with a constructor, getter and setter methods.

  Macro usage example:
      ```
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
        nullable: false,
        struct: nil
      },
      %{
        field: :hair_details,
        type_guard: :is_struct,
        default_value: %Hair{},
        nullable: true,
        struct: Hair
      })
      ```
  """
  defmacro generate_constructor(module, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9) do

    [
        field: field_name_1,
        type_guard: guard_1,
        default_value: default_1,
        nullable: is_nullable_1,
        struct: struct_module_1
    ] = field_1 |> elem(2)

    [
        field: field_name_2,
        type_guard: guard_2,
        default_value: default_2,
        nullable: is_nullable_2,
        struct: struct_module_2
    ] = field_2 |> elem(2)

    [
        field: field_name_3,
        type_guard: guard_3,
        default_value: default_3,
        nullable: is_nullable_3,
        struct: struct_module_3
    ] = field_3 |> elem(2)

    [
        field: field_name_4,
        type_guard: guard_4,
        default_value: default_4,
        nullable: is_nullable_4,
        struct: struct_module_4
    ] = field_4 |> elem(2)

    [
        field: field_name_5,
        type_guard: guard_5,
        default_value: default_5,
        nullable: is_nullable_5,
        struct: struct_module_5
    ] = field_5 |> elem(2)

    [
        field: field_name_6,
        type_guard: guard_6,
        default_value: default_6,
        nullable: is_nullable_6,
        struct: struct_module_6
    ] = field_6 |> elem(2)

    [
        field: field_name_7,
        type_guard: guard_7,
        default_value: default_7,
        nullable: is_nullable_7,
        struct: struct_module_7
    ] = field_7 |> elem(2)

    [
        field: field_name_8,
        type_guard: guard_8,
        default_value: default_8,
        nullable: is_nullable_8,
        struct: struct_module_8
    ] = field_8 |> elem(2)

    [
        field: field_name_9,
        type_guard: guard_9,
        default_value: default_9,
        nullable: is_nullable_9,
        struct: struct_module_9
    ] = field_9 |> elem(2)


    quote do
      defstruct [
        "#{unquote(field_name_1)}": unquote(default_1),
        "#{unquote(field_name_2)}": unquote(default_2),
        "#{unquote(field_name_3)}": unquote(default_3),
        "#{unquote(field_name_4)}": unquote(default_4),
        "#{unquote(field_name_5)}": unquote(default_5),
        "#{unquote(field_name_6)}": unquote(default_6),
        "#{unquote(field_name_7)}": unquote(default_7),
        "#{unquote(field_name_8)}": unquote(default_8),
        "#{unquote(field_name_9)}": unquote(default_9)
      ]

      defp validate_field(field_name, field_value, struct_module, is_nullable, guard) do
        (Code.ensure_compiled(struct_module) |> elem(0) === :module and is_struct(field_value, struct_module))
            or (is_nullable === true and field_value === nil)
            or apply(Kernel, guard, [field_value])
      end

      def constructor(values) do
        is_params_valid =
        validate_field(unquote(field_name_1), values[unquote(field_name_1)], unquote(struct_module_1), unquote(is_nullable_1), unquote(guard_1)) and
        validate_field(unquote(field_name_2), values[unquote(field_name_2)], unquote(struct_module_2), unquote(is_nullable_2), unquote(guard_2)) and
        validate_field(unquote(field_name_3), values[unquote(field_name_3)], unquote(struct_module_3), unquote(is_nullable_3), unquote(guard_3)) and
        validate_field(unquote(field_name_4), values[unquote(field_name_4)], unquote(struct_module_4), unquote(is_nullable_4), unquote(guard_4)) and
        validate_field(unquote(field_name_5), values[unquote(field_name_5)], unquote(struct_module_5), unquote(is_nullable_5), unquote(guard_5)) and
        validate_field(unquote(field_name_6), values[unquote(field_name_6)], unquote(struct_module_6), unquote(is_nullable_6), unquote(guard_6)) and
        validate_field(unquote(field_name_7), values[unquote(field_name_7)], unquote(struct_module_7), unquote(is_nullable_7), unquote(guard_7)) and
        validate_field(unquote(field_name_8), values[unquote(field_name_8)], unquote(struct_module_8), unquote(is_nullable_8), unquote(guard_8)) and
        validate_field(unquote(field_name_9), values[unquote(field_name_9)], unquote(struct_module_9), unquote(is_nullable_9), unquote(guard_9))

        if is_params_valid === false do
          raise "type mismatch for constructor paramater(s) or required parameters are missing"
        end

        result = %{
            "#{unquote(field_name_1)}": values[unquote(field_name_1)],
            "#{unquote(field_name_2)}": values[unquote(field_name_2)],
            "#{unquote(field_name_3)}": values[unquote(field_name_3)],
            "#{unquote(field_name_4)}": values[unquote(field_name_4)],
            "#{unquote(field_name_5)}": values[unquote(field_name_5)],
            "#{unquote(field_name_6)}": values[unquote(field_name_6)],
            "#{unquote(field_name_7)}": values[unquote(field_name_7)],
            "#{unquote(field_name_8)}": values[unquote(field_name_8)],
            "#{unquote(field_name_9)}": values[unquote(field_name_9)]
        }
        struct(unquote(module), result)
      end


      def unquote(field_name_1)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_1))
      end

      if is_nil(unquote(struct_module_1)) === true do
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or unquote(guard_1)(value) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      else
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or is_struct(value, unquote(struct_module_1)) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      end
      def unquote(field_name_2)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_2))
      end

      if is_nil(unquote(struct_module_2)) === true do
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or unquote(guard_2)(value) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      else
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or is_struct(value, unquote(struct_module_2)) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      end
      def unquote(field_name_3)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_3))
      end

      if is_nil(unquote(struct_module_3)) === true do
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or unquote(guard_3)(value) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      else
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or is_struct(value, unquote(struct_module_3)) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      end
      def unquote(field_name_4)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_4))
      end

      if is_nil(unquote(struct_module_4)) === true do
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or unquote(guard_4)(value) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      else
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or is_struct(value, unquote(struct_module_4)) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      end
      def unquote(field_name_5)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_5))
      end

      if is_nil(unquote(struct_module_5)) === true do
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or unquote(guard_5)(value) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      else
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or is_struct(value, unquote(struct_module_5)) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      end
      def unquote(field_name_6)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_6))
      end

      if is_nil(unquote(struct_module_6)) === true do
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or unquote(guard_6)(value) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      else
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or is_struct(value, unquote(struct_module_6)) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      end
      def unquote(field_name_7)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_7))
      end

      if is_nil(unquote(struct_module_7)) === true do
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or unquote(guard_7)(value) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      else
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or is_struct(value, unquote(struct_module_7)) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      end
      def unquote(field_name_8)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_8))
      end

      if is_nil(unquote(struct_module_8)) === true do
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or unquote(guard_8)(value) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      else
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or is_struct(value, unquote(struct_module_8)) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      end
      def unquote(field_name_9)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_9))
      end

      if is_nil(unquote(struct_module_9)) === true do
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or unquote(guard_9)(value) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      else
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or is_struct(value, unquote(struct_module_9)) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      end
    end
  end




  @doc"""
  Generates a struct, complete with a constructor, getter and setter methods.

  Macro usage example:
      ```
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
        nullable: false,
        struct: nil
      },
      %{
        field: :hair_details,
        type_guard: :is_struct,
        default_value: %Hair{},
        nullable: true,
        struct: Hair
      })
      ```
  """
  defmacro generate_constructor(module, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9, field_10) do

    [
        field: field_name_1,
        type_guard: guard_1,
        default_value: default_1,
        nullable: is_nullable_1,
        struct: struct_module_1
    ] = field_1 |> elem(2)

    [
        field: field_name_2,
        type_guard: guard_2,
        default_value: default_2,
        nullable: is_nullable_2,
        struct: struct_module_2
    ] = field_2 |> elem(2)

    [
        field: field_name_3,
        type_guard: guard_3,
        default_value: default_3,
        nullable: is_nullable_3,
        struct: struct_module_3
    ] = field_3 |> elem(2)

    [
        field: field_name_4,
        type_guard: guard_4,
        default_value: default_4,
        nullable: is_nullable_4,
        struct: struct_module_4
    ] = field_4 |> elem(2)

    [
        field: field_name_5,
        type_guard: guard_5,
        default_value: default_5,
        nullable: is_nullable_5,
        struct: struct_module_5
    ] = field_5 |> elem(2)

    [
        field: field_name_6,
        type_guard: guard_6,
        default_value: default_6,
        nullable: is_nullable_6,
        struct: struct_module_6
    ] = field_6 |> elem(2)

    [
        field: field_name_7,
        type_guard: guard_7,
        default_value: default_7,
        nullable: is_nullable_7,
        struct: struct_module_7
    ] = field_7 |> elem(2)

    [
        field: field_name_8,
        type_guard: guard_8,
        default_value: default_8,
        nullable: is_nullable_8,
        struct: struct_module_8
    ] = field_8 |> elem(2)

    [
        field: field_name_9,
        type_guard: guard_9,
        default_value: default_9,
        nullable: is_nullable_9,
        struct: struct_module_9
    ] = field_9 |> elem(2)

    [
        field: field_name_10,
        type_guard: guard_10,
        default_value: default_10,
        nullable: is_nullable_10,
        struct: struct_module_10
    ] = field_10 |> elem(2)


    quote do
      defstruct [
        "#{unquote(field_name_1)}": unquote(default_1),
        "#{unquote(field_name_2)}": unquote(default_2),
        "#{unquote(field_name_3)}": unquote(default_3),
        "#{unquote(field_name_4)}": unquote(default_4),
        "#{unquote(field_name_5)}": unquote(default_5),
        "#{unquote(field_name_6)}": unquote(default_6),
        "#{unquote(field_name_7)}": unquote(default_7),
        "#{unquote(field_name_8)}": unquote(default_8),
        "#{unquote(field_name_9)}": unquote(default_9),
        "#{unquote(field_name_10)}": unquote(default_10)
      ]

      defp validate_field(field_name, field_value, struct_module, is_nullable, guard) do
        (Code.ensure_compiled(struct_module) |> elem(0) === :module and is_struct(field_value, struct_module))
            or (is_nullable === true and field_value === nil)
            or apply(Kernel, guard, [field_value])
      end

      def constructor(values) do
        is_params_valid =
        validate_field(unquote(field_name_1), values[unquote(field_name_1)], unquote(struct_module_1), unquote(is_nullable_1), unquote(guard_1)) and
        validate_field(unquote(field_name_2), values[unquote(field_name_2)], unquote(struct_module_2), unquote(is_nullable_2), unquote(guard_2)) and
        validate_field(unquote(field_name_3), values[unquote(field_name_3)], unquote(struct_module_3), unquote(is_nullable_3), unquote(guard_3)) and
        validate_field(unquote(field_name_4), values[unquote(field_name_4)], unquote(struct_module_4), unquote(is_nullable_4), unquote(guard_4)) and
        validate_field(unquote(field_name_5), values[unquote(field_name_5)], unquote(struct_module_5), unquote(is_nullable_5), unquote(guard_5)) and
        validate_field(unquote(field_name_6), values[unquote(field_name_6)], unquote(struct_module_6), unquote(is_nullable_6), unquote(guard_6)) and
        validate_field(unquote(field_name_7), values[unquote(field_name_7)], unquote(struct_module_7), unquote(is_nullable_7), unquote(guard_7)) and
        validate_field(unquote(field_name_8), values[unquote(field_name_8)], unquote(struct_module_8), unquote(is_nullable_8), unquote(guard_8)) and
        validate_field(unquote(field_name_9), values[unquote(field_name_9)], unquote(struct_module_9), unquote(is_nullable_9), unquote(guard_9)) and
        validate_field(unquote(field_name_10), values[unquote(field_name_10)], unquote(struct_module_10), unquote(is_nullable_10), unquote(guard_10))

        if is_params_valid === false do
          raise "type mismatch for constructor paramater(s) or required parameters are missing"
        end

        result = %{
            "#{unquote(field_name_1)}": values[unquote(field_name_1)],
            "#{unquote(field_name_2)}": values[unquote(field_name_2)],
            "#{unquote(field_name_3)}": values[unquote(field_name_3)],
            "#{unquote(field_name_4)}": values[unquote(field_name_4)],
            "#{unquote(field_name_5)}": values[unquote(field_name_5)],
            "#{unquote(field_name_6)}": values[unquote(field_name_6)],
            "#{unquote(field_name_7)}": values[unquote(field_name_7)],
            "#{unquote(field_name_8)}": values[unquote(field_name_8)],
            "#{unquote(field_name_9)}": values[unquote(field_name_9)],
            "#{unquote(field_name_10)}": values[unquote(field_name_10)]
        }
        struct(unquote(module), result)
      end


      def unquote(field_name_1)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_1))
      end

      if is_nil(unquote(struct_module_1)) === true do
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or unquote(guard_1)(value) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      else
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or is_struct(value, unquote(struct_module_1)) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      end
      def unquote(field_name_2)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_2))
      end

      if is_nil(unquote(struct_module_2)) === true do
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or unquote(guard_2)(value) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      else
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or is_struct(value, unquote(struct_module_2)) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      end
      def unquote(field_name_3)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_3))
      end

      if is_nil(unquote(struct_module_3)) === true do
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or unquote(guard_3)(value) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      else
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or is_struct(value, unquote(struct_module_3)) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      end
      def unquote(field_name_4)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_4))
      end

      if is_nil(unquote(struct_module_4)) === true do
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or unquote(guard_4)(value) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      else
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or is_struct(value, unquote(struct_module_4)) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      end
      def unquote(field_name_5)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_5))
      end

      if is_nil(unquote(struct_module_5)) === true do
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or unquote(guard_5)(value) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      else
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or is_struct(value, unquote(struct_module_5)) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      end
      def unquote(field_name_6)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_6))
      end

      if is_nil(unquote(struct_module_6)) === true do
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or unquote(guard_6)(value) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      else
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or is_struct(value, unquote(struct_module_6)) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      end
      def unquote(field_name_7)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_7))
      end

      if is_nil(unquote(struct_module_7)) === true do
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or unquote(guard_7)(value) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      else
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or is_struct(value, unquote(struct_module_7)) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      end
      def unquote(field_name_8)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_8))
      end

      if is_nil(unquote(struct_module_8)) === true do
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or unquote(guard_8)(value) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      else
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or is_struct(value, unquote(struct_module_8)) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      end
      def unquote(field_name_9)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_9))
      end

      if is_nil(unquote(struct_module_9)) === true do
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or unquote(guard_9)(value) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      else
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or is_struct(value, unquote(struct_module_9)) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      end
      def unquote(field_name_10)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_10))
      end

      if is_nil(unquote(struct_module_10)) === true do
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or unquote(guard_10)(value) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      else
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or is_struct(value, unquote(struct_module_10)) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      end
    end
  end




  @doc"""
  Generates a struct, complete with a constructor, getter and setter methods.

  Macro usage example:
      ```
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
        nullable: false,
        struct: nil
      },
      %{
        field: :hair_details,
        type_guard: :is_struct,
        default_value: %Hair{},
        nullable: true,
        struct: Hair
      })
      ```
  """
  defmacro generate_constructor(module, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9, field_10, field_11) do

    [
        field: field_name_1,
        type_guard: guard_1,
        default_value: default_1,
        nullable: is_nullable_1,
        struct: struct_module_1
    ] = field_1 |> elem(2)

    [
        field: field_name_2,
        type_guard: guard_2,
        default_value: default_2,
        nullable: is_nullable_2,
        struct: struct_module_2
    ] = field_2 |> elem(2)

    [
        field: field_name_3,
        type_guard: guard_3,
        default_value: default_3,
        nullable: is_nullable_3,
        struct: struct_module_3
    ] = field_3 |> elem(2)

    [
        field: field_name_4,
        type_guard: guard_4,
        default_value: default_4,
        nullable: is_nullable_4,
        struct: struct_module_4
    ] = field_4 |> elem(2)

    [
        field: field_name_5,
        type_guard: guard_5,
        default_value: default_5,
        nullable: is_nullable_5,
        struct: struct_module_5
    ] = field_5 |> elem(2)

    [
        field: field_name_6,
        type_guard: guard_6,
        default_value: default_6,
        nullable: is_nullable_6,
        struct: struct_module_6
    ] = field_6 |> elem(2)

    [
        field: field_name_7,
        type_guard: guard_7,
        default_value: default_7,
        nullable: is_nullable_7,
        struct: struct_module_7
    ] = field_7 |> elem(2)

    [
        field: field_name_8,
        type_guard: guard_8,
        default_value: default_8,
        nullable: is_nullable_8,
        struct: struct_module_8
    ] = field_8 |> elem(2)

    [
        field: field_name_9,
        type_guard: guard_9,
        default_value: default_9,
        nullable: is_nullable_9,
        struct: struct_module_9
    ] = field_9 |> elem(2)

    [
        field: field_name_10,
        type_guard: guard_10,
        default_value: default_10,
        nullable: is_nullable_10,
        struct: struct_module_10
    ] = field_10 |> elem(2)

    [
        field: field_name_11,
        type_guard: guard_11,
        default_value: default_11,
        nullable: is_nullable_11,
        struct: struct_module_11
    ] = field_11 |> elem(2)


    quote do
      defstruct [
        "#{unquote(field_name_1)}": unquote(default_1),
        "#{unquote(field_name_2)}": unquote(default_2),
        "#{unquote(field_name_3)}": unquote(default_3),
        "#{unquote(field_name_4)}": unquote(default_4),
        "#{unquote(field_name_5)}": unquote(default_5),
        "#{unquote(field_name_6)}": unquote(default_6),
        "#{unquote(field_name_7)}": unquote(default_7),
        "#{unquote(field_name_8)}": unquote(default_8),
        "#{unquote(field_name_9)}": unquote(default_9),
        "#{unquote(field_name_10)}": unquote(default_10),
        "#{unquote(field_name_11)}": unquote(default_11)
      ]

      defp validate_field(field_name, field_value, struct_module, is_nullable, guard) do
        (Code.ensure_compiled(struct_module) |> elem(0) === :module and is_struct(field_value, struct_module))
            or (is_nullable === true and field_value === nil)
            or apply(Kernel, guard, [field_value])
      end

      def constructor(values) do
        is_params_valid =
        validate_field(unquote(field_name_1), values[unquote(field_name_1)], unquote(struct_module_1), unquote(is_nullable_1), unquote(guard_1)) and
        validate_field(unquote(field_name_2), values[unquote(field_name_2)], unquote(struct_module_2), unquote(is_nullable_2), unquote(guard_2)) and
        validate_field(unquote(field_name_3), values[unquote(field_name_3)], unquote(struct_module_3), unquote(is_nullable_3), unquote(guard_3)) and
        validate_field(unquote(field_name_4), values[unquote(field_name_4)], unquote(struct_module_4), unquote(is_nullable_4), unquote(guard_4)) and
        validate_field(unquote(field_name_5), values[unquote(field_name_5)], unquote(struct_module_5), unquote(is_nullable_5), unquote(guard_5)) and
        validate_field(unquote(field_name_6), values[unquote(field_name_6)], unquote(struct_module_6), unquote(is_nullable_6), unquote(guard_6)) and
        validate_field(unquote(field_name_7), values[unquote(field_name_7)], unquote(struct_module_7), unquote(is_nullable_7), unquote(guard_7)) and
        validate_field(unquote(field_name_8), values[unquote(field_name_8)], unquote(struct_module_8), unquote(is_nullable_8), unquote(guard_8)) and
        validate_field(unquote(field_name_9), values[unquote(field_name_9)], unquote(struct_module_9), unquote(is_nullable_9), unquote(guard_9)) and
        validate_field(unquote(field_name_10), values[unquote(field_name_10)], unquote(struct_module_10), unquote(is_nullable_10), unquote(guard_10)) and
        validate_field(unquote(field_name_11), values[unquote(field_name_11)], unquote(struct_module_11), unquote(is_nullable_11), unquote(guard_11))

        if is_params_valid === false do
          raise "type mismatch for constructor paramater(s) or required parameters are missing"
        end

        result = %{
            "#{unquote(field_name_1)}": values[unquote(field_name_1)],
            "#{unquote(field_name_2)}": values[unquote(field_name_2)],
            "#{unquote(field_name_3)}": values[unquote(field_name_3)],
            "#{unquote(field_name_4)}": values[unquote(field_name_4)],
            "#{unquote(field_name_5)}": values[unquote(field_name_5)],
            "#{unquote(field_name_6)}": values[unquote(field_name_6)],
            "#{unquote(field_name_7)}": values[unquote(field_name_7)],
            "#{unquote(field_name_8)}": values[unquote(field_name_8)],
            "#{unquote(field_name_9)}": values[unquote(field_name_9)],
            "#{unquote(field_name_10)}": values[unquote(field_name_10)],
            "#{unquote(field_name_11)}": values[unquote(field_name_11)]
        }
        struct(unquote(module), result)
      end


      def unquote(field_name_1)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_1))
      end

      if is_nil(unquote(struct_module_1)) === true do
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or unquote(guard_1)(value) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      else
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or is_struct(value, unquote(struct_module_1)) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      end
      def unquote(field_name_2)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_2))
      end

      if is_nil(unquote(struct_module_2)) === true do
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or unquote(guard_2)(value) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      else
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or is_struct(value, unquote(struct_module_2)) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      end
      def unquote(field_name_3)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_3))
      end

      if is_nil(unquote(struct_module_3)) === true do
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or unquote(guard_3)(value) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      else
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or is_struct(value, unquote(struct_module_3)) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      end
      def unquote(field_name_4)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_4))
      end

      if is_nil(unquote(struct_module_4)) === true do
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or unquote(guard_4)(value) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      else
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or is_struct(value, unquote(struct_module_4)) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      end
      def unquote(field_name_5)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_5))
      end

      if is_nil(unquote(struct_module_5)) === true do
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or unquote(guard_5)(value) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      else
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or is_struct(value, unquote(struct_module_5)) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      end
      def unquote(field_name_6)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_6))
      end

      if is_nil(unquote(struct_module_6)) === true do
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or unquote(guard_6)(value) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      else
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or is_struct(value, unquote(struct_module_6)) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      end
      def unquote(field_name_7)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_7))
      end

      if is_nil(unquote(struct_module_7)) === true do
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or unquote(guard_7)(value) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      else
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or is_struct(value, unquote(struct_module_7)) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      end
      def unquote(field_name_8)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_8))
      end

      if is_nil(unquote(struct_module_8)) === true do
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or unquote(guard_8)(value) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      else
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or is_struct(value, unquote(struct_module_8)) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      end
      def unquote(field_name_9)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_9))
      end

      if is_nil(unquote(struct_module_9)) === true do
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or unquote(guard_9)(value) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      else
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or is_struct(value, unquote(struct_module_9)) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      end
      def unquote(field_name_10)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_10))
      end

      if is_nil(unquote(struct_module_10)) === true do
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or unquote(guard_10)(value) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      else
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or is_struct(value, unquote(struct_module_10)) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      end
      def unquote(field_name_11)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_11))
      end

      if is_nil(unquote(struct_module_11)) === true do
        def unquote(field_name_11)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_11)) or unquote(guard_11)(value) do
          %{struct_instance | "#{unquote(field_name_11)}": value}
        end
      else
        def unquote(field_name_11)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_11)) or is_struct(value, unquote(struct_module_11)) do
          %{struct_instance | "#{unquote(field_name_11)}": value}
        end
      end
    end
  end




  @doc"""
  Generates a struct, complete with a constructor, getter and setter methods.

  Macro usage example:
      ```
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
        nullable: false,
        struct: nil
      },
      %{
        field: :hair_details,
        type_guard: :is_struct,
        default_value: %Hair{},
        nullable: true,
        struct: Hair
      })
      ```
  """
  defmacro generate_constructor(module, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9, field_10, field_11, field_12) do

    [
        field: field_name_1,
        type_guard: guard_1,
        default_value: default_1,
        nullable: is_nullable_1,
        struct: struct_module_1
    ] = field_1 |> elem(2)

    [
        field: field_name_2,
        type_guard: guard_2,
        default_value: default_2,
        nullable: is_nullable_2,
        struct: struct_module_2
    ] = field_2 |> elem(2)

    [
        field: field_name_3,
        type_guard: guard_3,
        default_value: default_3,
        nullable: is_nullable_3,
        struct: struct_module_3
    ] = field_3 |> elem(2)

    [
        field: field_name_4,
        type_guard: guard_4,
        default_value: default_4,
        nullable: is_nullable_4,
        struct: struct_module_4
    ] = field_4 |> elem(2)

    [
        field: field_name_5,
        type_guard: guard_5,
        default_value: default_5,
        nullable: is_nullable_5,
        struct: struct_module_5
    ] = field_5 |> elem(2)

    [
        field: field_name_6,
        type_guard: guard_6,
        default_value: default_6,
        nullable: is_nullable_6,
        struct: struct_module_6
    ] = field_6 |> elem(2)

    [
        field: field_name_7,
        type_guard: guard_7,
        default_value: default_7,
        nullable: is_nullable_7,
        struct: struct_module_7
    ] = field_7 |> elem(2)

    [
        field: field_name_8,
        type_guard: guard_8,
        default_value: default_8,
        nullable: is_nullable_8,
        struct: struct_module_8
    ] = field_8 |> elem(2)

    [
        field: field_name_9,
        type_guard: guard_9,
        default_value: default_9,
        nullable: is_nullable_9,
        struct: struct_module_9
    ] = field_9 |> elem(2)

    [
        field: field_name_10,
        type_guard: guard_10,
        default_value: default_10,
        nullable: is_nullable_10,
        struct: struct_module_10
    ] = field_10 |> elem(2)

    [
        field: field_name_11,
        type_guard: guard_11,
        default_value: default_11,
        nullable: is_nullable_11,
        struct: struct_module_11
    ] = field_11 |> elem(2)

    [
        field: field_name_12,
        type_guard: guard_12,
        default_value: default_12,
        nullable: is_nullable_12,
        struct: struct_module_12
    ] = field_12 |> elem(2)


    quote do
      defstruct [
        "#{unquote(field_name_1)}": unquote(default_1),
        "#{unquote(field_name_2)}": unquote(default_2),
        "#{unquote(field_name_3)}": unquote(default_3),
        "#{unquote(field_name_4)}": unquote(default_4),
        "#{unquote(field_name_5)}": unquote(default_5),
        "#{unquote(field_name_6)}": unquote(default_6),
        "#{unquote(field_name_7)}": unquote(default_7),
        "#{unquote(field_name_8)}": unquote(default_8),
        "#{unquote(field_name_9)}": unquote(default_9),
        "#{unquote(field_name_10)}": unquote(default_10),
        "#{unquote(field_name_11)}": unquote(default_11),
        "#{unquote(field_name_12)}": unquote(default_12)
      ]

      defp validate_field(field_name, field_value, struct_module, is_nullable, guard) do
        (Code.ensure_compiled(struct_module) |> elem(0) === :module and is_struct(field_value, struct_module))
            or (is_nullable === true and field_value === nil)
            or apply(Kernel, guard, [field_value])
      end

      def constructor(values) do
        is_params_valid =
        validate_field(unquote(field_name_1), values[unquote(field_name_1)], unquote(struct_module_1), unquote(is_nullable_1), unquote(guard_1)) and
        validate_field(unquote(field_name_2), values[unquote(field_name_2)], unquote(struct_module_2), unquote(is_nullable_2), unquote(guard_2)) and
        validate_field(unquote(field_name_3), values[unquote(field_name_3)], unquote(struct_module_3), unquote(is_nullable_3), unquote(guard_3)) and
        validate_field(unquote(field_name_4), values[unquote(field_name_4)], unquote(struct_module_4), unquote(is_nullable_4), unquote(guard_4)) and
        validate_field(unquote(field_name_5), values[unquote(field_name_5)], unquote(struct_module_5), unquote(is_nullable_5), unquote(guard_5)) and
        validate_field(unquote(field_name_6), values[unquote(field_name_6)], unquote(struct_module_6), unquote(is_nullable_6), unquote(guard_6)) and
        validate_field(unquote(field_name_7), values[unquote(field_name_7)], unquote(struct_module_7), unquote(is_nullable_7), unquote(guard_7)) and
        validate_field(unquote(field_name_8), values[unquote(field_name_8)], unquote(struct_module_8), unquote(is_nullable_8), unquote(guard_8)) and
        validate_field(unquote(field_name_9), values[unquote(field_name_9)], unquote(struct_module_9), unquote(is_nullable_9), unquote(guard_9)) and
        validate_field(unquote(field_name_10), values[unquote(field_name_10)], unquote(struct_module_10), unquote(is_nullable_10), unquote(guard_10)) and
        validate_field(unquote(field_name_11), values[unquote(field_name_11)], unquote(struct_module_11), unquote(is_nullable_11), unquote(guard_11)) and
        validate_field(unquote(field_name_12), values[unquote(field_name_12)], unquote(struct_module_12), unquote(is_nullable_12), unquote(guard_12))

        if is_params_valid === false do
          raise "type mismatch for constructor paramater(s) or required parameters are missing"
        end

        result = %{
            "#{unquote(field_name_1)}": values[unquote(field_name_1)],
            "#{unquote(field_name_2)}": values[unquote(field_name_2)],
            "#{unquote(field_name_3)}": values[unquote(field_name_3)],
            "#{unquote(field_name_4)}": values[unquote(field_name_4)],
            "#{unquote(field_name_5)}": values[unquote(field_name_5)],
            "#{unquote(field_name_6)}": values[unquote(field_name_6)],
            "#{unquote(field_name_7)}": values[unquote(field_name_7)],
            "#{unquote(field_name_8)}": values[unquote(field_name_8)],
            "#{unquote(field_name_9)}": values[unquote(field_name_9)],
            "#{unquote(field_name_10)}": values[unquote(field_name_10)],
            "#{unquote(field_name_11)}": values[unquote(field_name_11)],
            "#{unquote(field_name_12)}": values[unquote(field_name_12)]
        }
        struct(unquote(module), result)
      end


      def unquote(field_name_1)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_1))
      end

      if is_nil(unquote(struct_module_1)) === true do
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or unquote(guard_1)(value) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      else
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or is_struct(value, unquote(struct_module_1)) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      end
      def unquote(field_name_2)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_2))
      end

      if is_nil(unquote(struct_module_2)) === true do
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or unquote(guard_2)(value) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      else
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or is_struct(value, unquote(struct_module_2)) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      end
      def unquote(field_name_3)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_3))
      end

      if is_nil(unquote(struct_module_3)) === true do
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or unquote(guard_3)(value) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      else
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or is_struct(value, unquote(struct_module_3)) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      end
      def unquote(field_name_4)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_4))
      end

      if is_nil(unquote(struct_module_4)) === true do
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or unquote(guard_4)(value) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      else
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or is_struct(value, unquote(struct_module_4)) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      end
      def unquote(field_name_5)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_5))
      end

      if is_nil(unquote(struct_module_5)) === true do
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or unquote(guard_5)(value) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      else
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or is_struct(value, unquote(struct_module_5)) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      end
      def unquote(field_name_6)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_6))
      end

      if is_nil(unquote(struct_module_6)) === true do
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or unquote(guard_6)(value) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      else
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or is_struct(value, unquote(struct_module_6)) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      end
      def unquote(field_name_7)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_7))
      end

      if is_nil(unquote(struct_module_7)) === true do
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or unquote(guard_7)(value) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      else
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or is_struct(value, unquote(struct_module_7)) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      end
      def unquote(field_name_8)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_8))
      end

      if is_nil(unquote(struct_module_8)) === true do
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or unquote(guard_8)(value) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      else
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or is_struct(value, unquote(struct_module_8)) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      end
      def unquote(field_name_9)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_9))
      end

      if is_nil(unquote(struct_module_9)) === true do
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or unquote(guard_9)(value) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      else
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or is_struct(value, unquote(struct_module_9)) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      end
      def unquote(field_name_10)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_10))
      end

      if is_nil(unquote(struct_module_10)) === true do
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or unquote(guard_10)(value) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      else
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or is_struct(value, unquote(struct_module_10)) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      end
      def unquote(field_name_11)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_11))
      end

      if is_nil(unquote(struct_module_11)) === true do
        def unquote(field_name_11)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_11)) or unquote(guard_11)(value) do
          %{struct_instance | "#{unquote(field_name_11)}": value}
        end
      else
        def unquote(field_name_11)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_11)) or is_struct(value, unquote(struct_module_11)) do
          %{struct_instance | "#{unquote(field_name_11)}": value}
        end
      end
      def unquote(field_name_12)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_12))
      end

      if is_nil(unquote(struct_module_12)) === true do
        def unquote(field_name_12)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_12)) or unquote(guard_12)(value) do
          %{struct_instance | "#{unquote(field_name_12)}": value}
        end
      else
        def unquote(field_name_12)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_12)) or is_struct(value, unquote(struct_module_12)) do
          %{struct_instance | "#{unquote(field_name_12)}": value}
        end
      end
    end
  end




  @doc"""
  Generates a struct, complete with a constructor, getter and setter methods.

  Macro usage example:
      ```
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
        nullable: false,
        struct: nil
      },
      %{
        field: :hair_details,
        type_guard: :is_struct,
        default_value: %Hair{},
        nullable: true,
        struct: Hair
      })
      ```
  """
  defmacro generate_constructor(module, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9, field_10, field_11, field_12, field_13) do

    [
        field: field_name_1,
        type_guard: guard_1,
        default_value: default_1,
        nullable: is_nullable_1,
        struct: struct_module_1
    ] = field_1 |> elem(2)

    [
        field: field_name_2,
        type_guard: guard_2,
        default_value: default_2,
        nullable: is_nullable_2,
        struct: struct_module_2
    ] = field_2 |> elem(2)

    [
        field: field_name_3,
        type_guard: guard_3,
        default_value: default_3,
        nullable: is_nullable_3,
        struct: struct_module_3
    ] = field_3 |> elem(2)

    [
        field: field_name_4,
        type_guard: guard_4,
        default_value: default_4,
        nullable: is_nullable_4,
        struct: struct_module_4
    ] = field_4 |> elem(2)

    [
        field: field_name_5,
        type_guard: guard_5,
        default_value: default_5,
        nullable: is_nullable_5,
        struct: struct_module_5
    ] = field_5 |> elem(2)

    [
        field: field_name_6,
        type_guard: guard_6,
        default_value: default_6,
        nullable: is_nullable_6,
        struct: struct_module_6
    ] = field_6 |> elem(2)

    [
        field: field_name_7,
        type_guard: guard_7,
        default_value: default_7,
        nullable: is_nullable_7,
        struct: struct_module_7
    ] = field_7 |> elem(2)

    [
        field: field_name_8,
        type_guard: guard_8,
        default_value: default_8,
        nullable: is_nullable_8,
        struct: struct_module_8
    ] = field_8 |> elem(2)

    [
        field: field_name_9,
        type_guard: guard_9,
        default_value: default_9,
        nullable: is_nullable_9,
        struct: struct_module_9
    ] = field_9 |> elem(2)

    [
        field: field_name_10,
        type_guard: guard_10,
        default_value: default_10,
        nullable: is_nullable_10,
        struct: struct_module_10
    ] = field_10 |> elem(2)

    [
        field: field_name_11,
        type_guard: guard_11,
        default_value: default_11,
        nullable: is_nullable_11,
        struct: struct_module_11
    ] = field_11 |> elem(2)

    [
        field: field_name_12,
        type_guard: guard_12,
        default_value: default_12,
        nullable: is_nullable_12,
        struct: struct_module_12
    ] = field_12 |> elem(2)

    [
        field: field_name_13,
        type_guard: guard_13,
        default_value: default_13,
        nullable: is_nullable_13,
        struct: struct_module_13
    ] = field_13 |> elem(2)


    quote do
      defstruct [
        "#{unquote(field_name_1)}": unquote(default_1),
        "#{unquote(field_name_2)}": unquote(default_2),
        "#{unquote(field_name_3)}": unquote(default_3),
        "#{unquote(field_name_4)}": unquote(default_4),
        "#{unquote(field_name_5)}": unquote(default_5),
        "#{unquote(field_name_6)}": unquote(default_6),
        "#{unquote(field_name_7)}": unquote(default_7),
        "#{unquote(field_name_8)}": unquote(default_8),
        "#{unquote(field_name_9)}": unquote(default_9),
        "#{unquote(field_name_10)}": unquote(default_10),
        "#{unquote(field_name_11)}": unquote(default_11),
        "#{unquote(field_name_12)}": unquote(default_12),
        "#{unquote(field_name_13)}": unquote(default_13)
      ]

      defp validate_field(field_name, field_value, struct_module, is_nullable, guard) do
        (Code.ensure_compiled(struct_module) |> elem(0) === :module and is_struct(field_value, struct_module))
            or (is_nullable === true and field_value === nil)
            or apply(Kernel, guard, [field_value])
      end

      def constructor(values) do
        is_params_valid =
        validate_field(unquote(field_name_1), values[unquote(field_name_1)], unquote(struct_module_1), unquote(is_nullable_1), unquote(guard_1)) and
        validate_field(unquote(field_name_2), values[unquote(field_name_2)], unquote(struct_module_2), unquote(is_nullable_2), unquote(guard_2)) and
        validate_field(unquote(field_name_3), values[unquote(field_name_3)], unquote(struct_module_3), unquote(is_nullable_3), unquote(guard_3)) and
        validate_field(unquote(field_name_4), values[unquote(field_name_4)], unquote(struct_module_4), unquote(is_nullable_4), unquote(guard_4)) and
        validate_field(unquote(field_name_5), values[unquote(field_name_5)], unquote(struct_module_5), unquote(is_nullable_5), unquote(guard_5)) and
        validate_field(unquote(field_name_6), values[unquote(field_name_6)], unquote(struct_module_6), unquote(is_nullable_6), unquote(guard_6)) and
        validate_field(unquote(field_name_7), values[unquote(field_name_7)], unquote(struct_module_7), unquote(is_nullable_7), unquote(guard_7)) and
        validate_field(unquote(field_name_8), values[unquote(field_name_8)], unquote(struct_module_8), unquote(is_nullable_8), unquote(guard_8)) and
        validate_field(unquote(field_name_9), values[unquote(field_name_9)], unquote(struct_module_9), unquote(is_nullable_9), unquote(guard_9)) and
        validate_field(unquote(field_name_10), values[unquote(field_name_10)], unquote(struct_module_10), unquote(is_nullable_10), unquote(guard_10)) and
        validate_field(unquote(field_name_11), values[unquote(field_name_11)], unquote(struct_module_11), unquote(is_nullable_11), unquote(guard_11)) and
        validate_field(unquote(field_name_12), values[unquote(field_name_12)], unquote(struct_module_12), unquote(is_nullable_12), unquote(guard_12)) and
        validate_field(unquote(field_name_13), values[unquote(field_name_13)], unquote(struct_module_13), unquote(is_nullable_13), unquote(guard_13))

        if is_params_valid === false do
          raise "type mismatch for constructor paramater(s) or required parameters are missing"
        end

        result = %{
            "#{unquote(field_name_1)}": values[unquote(field_name_1)],
            "#{unquote(field_name_2)}": values[unquote(field_name_2)],
            "#{unquote(field_name_3)}": values[unquote(field_name_3)],
            "#{unquote(field_name_4)}": values[unquote(field_name_4)],
            "#{unquote(field_name_5)}": values[unquote(field_name_5)],
            "#{unquote(field_name_6)}": values[unquote(field_name_6)],
            "#{unquote(field_name_7)}": values[unquote(field_name_7)],
            "#{unquote(field_name_8)}": values[unquote(field_name_8)],
            "#{unquote(field_name_9)}": values[unquote(field_name_9)],
            "#{unquote(field_name_10)}": values[unquote(field_name_10)],
            "#{unquote(field_name_11)}": values[unquote(field_name_11)],
            "#{unquote(field_name_12)}": values[unquote(field_name_12)],
            "#{unquote(field_name_13)}": values[unquote(field_name_13)]
        }
        struct(unquote(module), result)
      end


      def unquote(field_name_1)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_1))
      end

      if is_nil(unquote(struct_module_1)) === true do
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or unquote(guard_1)(value) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      else
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or is_struct(value, unquote(struct_module_1)) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      end
      def unquote(field_name_2)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_2))
      end

      if is_nil(unquote(struct_module_2)) === true do
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or unquote(guard_2)(value) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      else
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or is_struct(value, unquote(struct_module_2)) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      end
      def unquote(field_name_3)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_3))
      end

      if is_nil(unquote(struct_module_3)) === true do
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or unquote(guard_3)(value) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      else
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or is_struct(value, unquote(struct_module_3)) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      end
      def unquote(field_name_4)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_4))
      end

      if is_nil(unquote(struct_module_4)) === true do
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or unquote(guard_4)(value) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      else
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or is_struct(value, unquote(struct_module_4)) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      end
      def unquote(field_name_5)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_5))
      end

      if is_nil(unquote(struct_module_5)) === true do
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or unquote(guard_5)(value) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      else
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or is_struct(value, unquote(struct_module_5)) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      end
      def unquote(field_name_6)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_6))
      end

      if is_nil(unquote(struct_module_6)) === true do
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or unquote(guard_6)(value) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      else
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or is_struct(value, unquote(struct_module_6)) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      end
      def unquote(field_name_7)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_7))
      end

      if is_nil(unquote(struct_module_7)) === true do
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or unquote(guard_7)(value) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      else
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or is_struct(value, unquote(struct_module_7)) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      end
      def unquote(field_name_8)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_8))
      end

      if is_nil(unquote(struct_module_8)) === true do
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or unquote(guard_8)(value) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      else
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or is_struct(value, unquote(struct_module_8)) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      end
      def unquote(field_name_9)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_9))
      end

      if is_nil(unquote(struct_module_9)) === true do
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or unquote(guard_9)(value) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      else
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or is_struct(value, unquote(struct_module_9)) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      end
      def unquote(field_name_10)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_10))
      end

      if is_nil(unquote(struct_module_10)) === true do
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or unquote(guard_10)(value) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      else
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or is_struct(value, unquote(struct_module_10)) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      end
      def unquote(field_name_11)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_11))
      end

      if is_nil(unquote(struct_module_11)) === true do
        def unquote(field_name_11)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_11)) or unquote(guard_11)(value) do
          %{struct_instance | "#{unquote(field_name_11)}": value}
        end
      else
        def unquote(field_name_11)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_11)) or is_struct(value, unquote(struct_module_11)) do
          %{struct_instance | "#{unquote(field_name_11)}": value}
        end
      end
      def unquote(field_name_12)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_12))
      end

      if is_nil(unquote(struct_module_12)) === true do
        def unquote(field_name_12)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_12)) or unquote(guard_12)(value) do
          %{struct_instance | "#{unquote(field_name_12)}": value}
        end
      else
        def unquote(field_name_12)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_12)) or is_struct(value, unquote(struct_module_12)) do
          %{struct_instance | "#{unquote(field_name_12)}": value}
        end
      end
      def unquote(field_name_13)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_13))
      end

      if is_nil(unquote(struct_module_13)) === true do
        def unquote(field_name_13)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_13)) or unquote(guard_13)(value) do
          %{struct_instance | "#{unquote(field_name_13)}": value}
        end
      else
        def unquote(field_name_13)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_13)) or is_struct(value, unquote(struct_module_13)) do
          %{struct_instance | "#{unquote(field_name_13)}": value}
        end
      end
    end
  end




  @doc"""
  Generates a struct, complete with a constructor, getter and setter methods.

  Macro usage example:
      ```
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
        nullable: false,
        struct: nil
      },
      %{
        field: :hair_details,
        type_guard: :is_struct,
        default_value: %Hair{},
        nullable: true,
        struct: Hair
      })
      ```
  """
  defmacro generate_constructor(module, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9, field_10, field_11, field_12, field_13, field_14) do

    [
        field: field_name_1,
        type_guard: guard_1,
        default_value: default_1,
        nullable: is_nullable_1,
        struct: struct_module_1
    ] = field_1 |> elem(2)

    [
        field: field_name_2,
        type_guard: guard_2,
        default_value: default_2,
        nullable: is_nullable_2,
        struct: struct_module_2
    ] = field_2 |> elem(2)

    [
        field: field_name_3,
        type_guard: guard_3,
        default_value: default_3,
        nullable: is_nullable_3,
        struct: struct_module_3
    ] = field_3 |> elem(2)

    [
        field: field_name_4,
        type_guard: guard_4,
        default_value: default_4,
        nullable: is_nullable_4,
        struct: struct_module_4
    ] = field_4 |> elem(2)

    [
        field: field_name_5,
        type_guard: guard_5,
        default_value: default_5,
        nullable: is_nullable_5,
        struct: struct_module_5
    ] = field_5 |> elem(2)

    [
        field: field_name_6,
        type_guard: guard_6,
        default_value: default_6,
        nullable: is_nullable_6,
        struct: struct_module_6
    ] = field_6 |> elem(2)

    [
        field: field_name_7,
        type_guard: guard_7,
        default_value: default_7,
        nullable: is_nullable_7,
        struct: struct_module_7
    ] = field_7 |> elem(2)

    [
        field: field_name_8,
        type_guard: guard_8,
        default_value: default_8,
        nullable: is_nullable_8,
        struct: struct_module_8
    ] = field_8 |> elem(2)

    [
        field: field_name_9,
        type_guard: guard_9,
        default_value: default_9,
        nullable: is_nullable_9,
        struct: struct_module_9
    ] = field_9 |> elem(2)

    [
        field: field_name_10,
        type_guard: guard_10,
        default_value: default_10,
        nullable: is_nullable_10,
        struct: struct_module_10
    ] = field_10 |> elem(2)

    [
        field: field_name_11,
        type_guard: guard_11,
        default_value: default_11,
        nullable: is_nullable_11,
        struct: struct_module_11
    ] = field_11 |> elem(2)

    [
        field: field_name_12,
        type_guard: guard_12,
        default_value: default_12,
        nullable: is_nullable_12,
        struct: struct_module_12
    ] = field_12 |> elem(2)

    [
        field: field_name_13,
        type_guard: guard_13,
        default_value: default_13,
        nullable: is_nullable_13,
        struct: struct_module_13
    ] = field_13 |> elem(2)

    [
        field: field_name_14,
        type_guard: guard_14,
        default_value: default_14,
        nullable: is_nullable_14,
        struct: struct_module_14
    ] = field_14 |> elem(2)


    quote do
      defstruct [
        "#{unquote(field_name_1)}": unquote(default_1),
        "#{unquote(field_name_2)}": unquote(default_2),
        "#{unquote(field_name_3)}": unquote(default_3),
        "#{unquote(field_name_4)}": unquote(default_4),
        "#{unquote(field_name_5)}": unquote(default_5),
        "#{unquote(field_name_6)}": unquote(default_6),
        "#{unquote(field_name_7)}": unquote(default_7),
        "#{unquote(field_name_8)}": unquote(default_8),
        "#{unquote(field_name_9)}": unquote(default_9),
        "#{unquote(field_name_10)}": unquote(default_10),
        "#{unquote(field_name_11)}": unquote(default_11),
        "#{unquote(field_name_12)}": unquote(default_12),
        "#{unquote(field_name_13)}": unquote(default_13),
        "#{unquote(field_name_14)}": unquote(default_14)
      ]

      defp validate_field(field_name, field_value, struct_module, is_nullable, guard) do
        (Code.ensure_compiled(struct_module) |> elem(0) === :module and is_struct(field_value, struct_module))
            or (is_nullable === true and field_value === nil)
            or apply(Kernel, guard, [field_value])
      end

      def constructor(values) do
        is_params_valid =
        validate_field(unquote(field_name_1), values[unquote(field_name_1)], unquote(struct_module_1), unquote(is_nullable_1), unquote(guard_1)) and
        validate_field(unquote(field_name_2), values[unquote(field_name_2)], unquote(struct_module_2), unquote(is_nullable_2), unquote(guard_2)) and
        validate_field(unquote(field_name_3), values[unquote(field_name_3)], unquote(struct_module_3), unquote(is_nullable_3), unquote(guard_3)) and
        validate_field(unquote(field_name_4), values[unquote(field_name_4)], unquote(struct_module_4), unquote(is_nullable_4), unquote(guard_4)) and
        validate_field(unquote(field_name_5), values[unquote(field_name_5)], unquote(struct_module_5), unquote(is_nullable_5), unquote(guard_5)) and
        validate_field(unquote(field_name_6), values[unquote(field_name_6)], unquote(struct_module_6), unquote(is_nullable_6), unquote(guard_6)) and
        validate_field(unquote(field_name_7), values[unquote(field_name_7)], unquote(struct_module_7), unquote(is_nullable_7), unquote(guard_7)) and
        validate_field(unquote(field_name_8), values[unquote(field_name_8)], unquote(struct_module_8), unquote(is_nullable_8), unquote(guard_8)) and
        validate_field(unquote(field_name_9), values[unquote(field_name_9)], unquote(struct_module_9), unquote(is_nullable_9), unquote(guard_9)) and
        validate_field(unquote(field_name_10), values[unquote(field_name_10)], unquote(struct_module_10), unquote(is_nullable_10), unquote(guard_10)) and
        validate_field(unquote(field_name_11), values[unquote(field_name_11)], unquote(struct_module_11), unquote(is_nullable_11), unquote(guard_11)) and
        validate_field(unquote(field_name_12), values[unquote(field_name_12)], unquote(struct_module_12), unquote(is_nullable_12), unquote(guard_12)) and
        validate_field(unquote(field_name_13), values[unquote(field_name_13)], unquote(struct_module_13), unquote(is_nullable_13), unquote(guard_13)) and
        validate_field(unquote(field_name_14), values[unquote(field_name_14)], unquote(struct_module_14), unquote(is_nullable_14), unquote(guard_14))

        if is_params_valid === false do
          raise "type mismatch for constructor paramater(s) or required parameters are missing"
        end

        result = %{
            "#{unquote(field_name_1)}": values[unquote(field_name_1)],
            "#{unquote(field_name_2)}": values[unquote(field_name_2)],
            "#{unquote(field_name_3)}": values[unquote(field_name_3)],
            "#{unquote(field_name_4)}": values[unquote(field_name_4)],
            "#{unquote(field_name_5)}": values[unquote(field_name_5)],
            "#{unquote(field_name_6)}": values[unquote(field_name_6)],
            "#{unquote(field_name_7)}": values[unquote(field_name_7)],
            "#{unquote(field_name_8)}": values[unquote(field_name_8)],
            "#{unquote(field_name_9)}": values[unquote(field_name_9)],
            "#{unquote(field_name_10)}": values[unquote(field_name_10)],
            "#{unquote(field_name_11)}": values[unquote(field_name_11)],
            "#{unquote(field_name_12)}": values[unquote(field_name_12)],
            "#{unquote(field_name_13)}": values[unquote(field_name_13)],
            "#{unquote(field_name_14)}": values[unquote(field_name_14)]
        }
        struct(unquote(module), result)
      end


      def unquote(field_name_1)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_1))
      end

      if is_nil(unquote(struct_module_1)) === true do
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or unquote(guard_1)(value) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      else
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or is_struct(value, unquote(struct_module_1)) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      end
      def unquote(field_name_2)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_2))
      end

      if is_nil(unquote(struct_module_2)) === true do
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or unquote(guard_2)(value) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      else
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or is_struct(value, unquote(struct_module_2)) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      end
      def unquote(field_name_3)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_3))
      end

      if is_nil(unquote(struct_module_3)) === true do
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or unquote(guard_3)(value) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      else
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or is_struct(value, unquote(struct_module_3)) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      end
      def unquote(field_name_4)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_4))
      end

      if is_nil(unquote(struct_module_4)) === true do
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or unquote(guard_4)(value) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      else
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or is_struct(value, unquote(struct_module_4)) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      end
      def unquote(field_name_5)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_5))
      end

      if is_nil(unquote(struct_module_5)) === true do
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or unquote(guard_5)(value) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      else
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or is_struct(value, unquote(struct_module_5)) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      end
      def unquote(field_name_6)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_6))
      end

      if is_nil(unquote(struct_module_6)) === true do
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or unquote(guard_6)(value) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      else
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or is_struct(value, unquote(struct_module_6)) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      end
      def unquote(field_name_7)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_7))
      end

      if is_nil(unquote(struct_module_7)) === true do
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or unquote(guard_7)(value) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      else
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or is_struct(value, unquote(struct_module_7)) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      end
      def unquote(field_name_8)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_8))
      end

      if is_nil(unquote(struct_module_8)) === true do
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or unquote(guard_8)(value) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      else
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or is_struct(value, unquote(struct_module_8)) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      end
      def unquote(field_name_9)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_9))
      end

      if is_nil(unquote(struct_module_9)) === true do
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or unquote(guard_9)(value) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      else
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or is_struct(value, unquote(struct_module_9)) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      end
      def unquote(field_name_10)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_10))
      end

      if is_nil(unquote(struct_module_10)) === true do
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or unquote(guard_10)(value) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      else
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or is_struct(value, unquote(struct_module_10)) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      end
      def unquote(field_name_11)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_11))
      end

      if is_nil(unquote(struct_module_11)) === true do
        def unquote(field_name_11)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_11)) or unquote(guard_11)(value) do
          %{struct_instance | "#{unquote(field_name_11)}": value}
        end
      else
        def unquote(field_name_11)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_11)) or is_struct(value, unquote(struct_module_11)) do
          %{struct_instance | "#{unquote(field_name_11)}": value}
        end
      end
      def unquote(field_name_12)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_12))
      end

      if is_nil(unquote(struct_module_12)) === true do
        def unquote(field_name_12)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_12)) or unquote(guard_12)(value) do
          %{struct_instance | "#{unquote(field_name_12)}": value}
        end
      else
        def unquote(field_name_12)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_12)) or is_struct(value, unquote(struct_module_12)) do
          %{struct_instance | "#{unquote(field_name_12)}": value}
        end
      end
      def unquote(field_name_13)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_13))
      end

      if is_nil(unquote(struct_module_13)) === true do
        def unquote(field_name_13)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_13)) or unquote(guard_13)(value) do
          %{struct_instance | "#{unquote(field_name_13)}": value}
        end
      else
        def unquote(field_name_13)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_13)) or is_struct(value, unquote(struct_module_13)) do
          %{struct_instance | "#{unquote(field_name_13)}": value}
        end
      end
      def unquote(field_name_14)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_14))
      end

      if is_nil(unquote(struct_module_14)) === true do
        def unquote(field_name_14)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_14)) or unquote(guard_14)(value) do
          %{struct_instance | "#{unquote(field_name_14)}": value}
        end
      else
        def unquote(field_name_14)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_14)) or is_struct(value, unquote(struct_module_14)) do
          %{struct_instance | "#{unquote(field_name_14)}": value}
        end
      end
    end
  end




  @doc"""
  Generates a struct, complete with a constructor, getter and setter methods.

  Macro usage example:
      ```
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
        nullable: false,
        struct: nil
      },
      %{
        field: :hair_details,
        type_guard: :is_struct,
        default_value: %Hair{},
        nullable: true,
        struct: Hair
      })
      ```
  """
  defmacro generate_constructor(module, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9, field_10, field_11, field_12, field_13, field_14, field_15) do

    [
        field: field_name_1,
        type_guard: guard_1,
        default_value: default_1,
        nullable: is_nullable_1,
        struct: struct_module_1
    ] = field_1 |> elem(2)

    [
        field: field_name_2,
        type_guard: guard_2,
        default_value: default_2,
        nullable: is_nullable_2,
        struct: struct_module_2
    ] = field_2 |> elem(2)

    [
        field: field_name_3,
        type_guard: guard_3,
        default_value: default_3,
        nullable: is_nullable_3,
        struct: struct_module_3
    ] = field_3 |> elem(2)

    [
        field: field_name_4,
        type_guard: guard_4,
        default_value: default_4,
        nullable: is_nullable_4,
        struct: struct_module_4
    ] = field_4 |> elem(2)

    [
        field: field_name_5,
        type_guard: guard_5,
        default_value: default_5,
        nullable: is_nullable_5,
        struct: struct_module_5
    ] = field_5 |> elem(2)

    [
        field: field_name_6,
        type_guard: guard_6,
        default_value: default_6,
        nullable: is_nullable_6,
        struct: struct_module_6
    ] = field_6 |> elem(2)

    [
        field: field_name_7,
        type_guard: guard_7,
        default_value: default_7,
        nullable: is_nullable_7,
        struct: struct_module_7
    ] = field_7 |> elem(2)

    [
        field: field_name_8,
        type_guard: guard_8,
        default_value: default_8,
        nullable: is_nullable_8,
        struct: struct_module_8
    ] = field_8 |> elem(2)

    [
        field: field_name_9,
        type_guard: guard_9,
        default_value: default_9,
        nullable: is_nullable_9,
        struct: struct_module_9
    ] = field_9 |> elem(2)

    [
        field: field_name_10,
        type_guard: guard_10,
        default_value: default_10,
        nullable: is_nullable_10,
        struct: struct_module_10
    ] = field_10 |> elem(2)

    [
        field: field_name_11,
        type_guard: guard_11,
        default_value: default_11,
        nullable: is_nullable_11,
        struct: struct_module_11
    ] = field_11 |> elem(2)

    [
        field: field_name_12,
        type_guard: guard_12,
        default_value: default_12,
        nullable: is_nullable_12,
        struct: struct_module_12
    ] = field_12 |> elem(2)

    [
        field: field_name_13,
        type_guard: guard_13,
        default_value: default_13,
        nullable: is_nullable_13,
        struct: struct_module_13
    ] = field_13 |> elem(2)

    [
        field: field_name_14,
        type_guard: guard_14,
        default_value: default_14,
        nullable: is_nullable_14,
        struct: struct_module_14
    ] = field_14 |> elem(2)

    [
        field: field_name_15,
        type_guard: guard_15,
        default_value: default_15,
        nullable: is_nullable_15,
        struct: struct_module_15
    ] = field_15 |> elem(2)


    quote do
      defstruct [
        "#{unquote(field_name_1)}": unquote(default_1),
        "#{unquote(field_name_2)}": unquote(default_2),
        "#{unquote(field_name_3)}": unquote(default_3),
        "#{unquote(field_name_4)}": unquote(default_4),
        "#{unquote(field_name_5)}": unquote(default_5),
        "#{unquote(field_name_6)}": unquote(default_6),
        "#{unquote(field_name_7)}": unquote(default_7),
        "#{unquote(field_name_8)}": unquote(default_8),
        "#{unquote(field_name_9)}": unquote(default_9),
        "#{unquote(field_name_10)}": unquote(default_10),
        "#{unquote(field_name_11)}": unquote(default_11),
        "#{unquote(field_name_12)}": unquote(default_12),
        "#{unquote(field_name_13)}": unquote(default_13),
        "#{unquote(field_name_14)}": unquote(default_14),
        "#{unquote(field_name_15)}": unquote(default_15)
      ]

      defp validate_field(field_name, field_value, struct_module, is_nullable, guard) do
        (Code.ensure_compiled(struct_module) |> elem(0) === :module and is_struct(field_value, struct_module))
            or (is_nullable === true and field_value === nil)
            or apply(Kernel, guard, [field_value])
      end

      def constructor(values) do
        is_params_valid =
        validate_field(unquote(field_name_1), values[unquote(field_name_1)], unquote(struct_module_1), unquote(is_nullable_1), unquote(guard_1)) and
        validate_field(unquote(field_name_2), values[unquote(field_name_2)], unquote(struct_module_2), unquote(is_nullable_2), unquote(guard_2)) and
        validate_field(unquote(field_name_3), values[unquote(field_name_3)], unquote(struct_module_3), unquote(is_nullable_3), unquote(guard_3)) and
        validate_field(unquote(field_name_4), values[unquote(field_name_4)], unquote(struct_module_4), unquote(is_nullable_4), unquote(guard_4)) and
        validate_field(unquote(field_name_5), values[unquote(field_name_5)], unquote(struct_module_5), unquote(is_nullable_5), unquote(guard_5)) and
        validate_field(unquote(field_name_6), values[unquote(field_name_6)], unquote(struct_module_6), unquote(is_nullable_6), unquote(guard_6)) and
        validate_field(unquote(field_name_7), values[unquote(field_name_7)], unquote(struct_module_7), unquote(is_nullable_7), unquote(guard_7)) and
        validate_field(unquote(field_name_8), values[unquote(field_name_8)], unquote(struct_module_8), unquote(is_nullable_8), unquote(guard_8)) and
        validate_field(unquote(field_name_9), values[unquote(field_name_9)], unquote(struct_module_9), unquote(is_nullable_9), unquote(guard_9)) and
        validate_field(unquote(field_name_10), values[unquote(field_name_10)], unquote(struct_module_10), unquote(is_nullable_10), unquote(guard_10)) and
        validate_field(unquote(field_name_11), values[unquote(field_name_11)], unquote(struct_module_11), unquote(is_nullable_11), unquote(guard_11)) and
        validate_field(unquote(field_name_12), values[unquote(field_name_12)], unquote(struct_module_12), unquote(is_nullable_12), unquote(guard_12)) and
        validate_field(unquote(field_name_13), values[unquote(field_name_13)], unquote(struct_module_13), unquote(is_nullable_13), unquote(guard_13)) and
        validate_field(unquote(field_name_14), values[unquote(field_name_14)], unquote(struct_module_14), unquote(is_nullable_14), unquote(guard_14)) and
        validate_field(unquote(field_name_15), values[unquote(field_name_15)], unquote(struct_module_15), unquote(is_nullable_15), unquote(guard_15))

        if is_params_valid === false do
          raise "type mismatch for constructor paramater(s) or required parameters are missing"
        end

        result = %{
            "#{unquote(field_name_1)}": values[unquote(field_name_1)],
            "#{unquote(field_name_2)}": values[unquote(field_name_2)],
            "#{unquote(field_name_3)}": values[unquote(field_name_3)],
            "#{unquote(field_name_4)}": values[unquote(field_name_4)],
            "#{unquote(field_name_5)}": values[unquote(field_name_5)],
            "#{unquote(field_name_6)}": values[unquote(field_name_6)],
            "#{unquote(field_name_7)}": values[unquote(field_name_7)],
            "#{unquote(field_name_8)}": values[unquote(field_name_8)],
            "#{unquote(field_name_9)}": values[unquote(field_name_9)],
            "#{unquote(field_name_10)}": values[unquote(field_name_10)],
            "#{unquote(field_name_11)}": values[unquote(field_name_11)],
            "#{unquote(field_name_12)}": values[unquote(field_name_12)],
            "#{unquote(field_name_13)}": values[unquote(field_name_13)],
            "#{unquote(field_name_14)}": values[unquote(field_name_14)],
            "#{unquote(field_name_15)}": values[unquote(field_name_15)]
        }
        struct(unquote(module), result)
      end


      def unquote(field_name_1)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_1))
      end

      if is_nil(unquote(struct_module_1)) === true do
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or unquote(guard_1)(value) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      else
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or is_struct(value, unquote(struct_module_1)) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      end
      def unquote(field_name_2)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_2))
      end

      if is_nil(unquote(struct_module_2)) === true do
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or unquote(guard_2)(value) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      else
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or is_struct(value, unquote(struct_module_2)) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      end
      def unquote(field_name_3)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_3))
      end

      if is_nil(unquote(struct_module_3)) === true do
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or unquote(guard_3)(value) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      else
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or is_struct(value, unquote(struct_module_3)) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      end
      def unquote(field_name_4)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_4))
      end

      if is_nil(unquote(struct_module_4)) === true do
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or unquote(guard_4)(value) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      else
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or is_struct(value, unquote(struct_module_4)) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      end
      def unquote(field_name_5)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_5))
      end

      if is_nil(unquote(struct_module_5)) === true do
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or unquote(guard_5)(value) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      else
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or is_struct(value, unquote(struct_module_5)) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      end
      def unquote(field_name_6)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_6))
      end

      if is_nil(unquote(struct_module_6)) === true do
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or unquote(guard_6)(value) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      else
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or is_struct(value, unquote(struct_module_6)) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      end
      def unquote(field_name_7)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_7))
      end

      if is_nil(unquote(struct_module_7)) === true do
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or unquote(guard_7)(value) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      else
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or is_struct(value, unquote(struct_module_7)) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      end
      def unquote(field_name_8)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_8))
      end

      if is_nil(unquote(struct_module_8)) === true do
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or unquote(guard_8)(value) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      else
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or is_struct(value, unquote(struct_module_8)) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      end
      def unquote(field_name_9)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_9))
      end

      if is_nil(unquote(struct_module_9)) === true do
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or unquote(guard_9)(value) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      else
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or is_struct(value, unquote(struct_module_9)) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      end
      def unquote(field_name_10)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_10))
      end

      if is_nil(unquote(struct_module_10)) === true do
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or unquote(guard_10)(value) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      else
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or is_struct(value, unquote(struct_module_10)) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      end
      def unquote(field_name_11)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_11))
      end

      if is_nil(unquote(struct_module_11)) === true do
        def unquote(field_name_11)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_11)) or unquote(guard_11)(value) do
          %{struct_instance | "#{unquote(field_name_11)}": value}
        end
      else
        def unquote(field_name_11)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_11)) or is_struct(value, unquote(struct_module_11)) do
          %{struct_instance | "#{unquote(field_name_11)}": value}
        end
      end
      def unquote(field_name_12)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_12))
      end

      if is_nil(unquote(struct_module_12)) === true do
        def unquote(field_name_12)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_12)) or unquote(guard_12)(value) do
          %{struct_instance | "#{unquote(field_name_12)}": value}
        end
      else
        def unquote(field_name_12)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_12)) or is_struct(value, unquote(struct_module_12)) do
          %{struct_instance | "#{unquote(field_name_12)}": value}
        end
      end
      def unquote(field_name_13)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_13))
      end

      if is_nil(unquote(struct_module_13)) === true do
        def unquote(field_name_13)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_13)) or unquote(guard_13)(value) do
          %{struct_instance | "#{unquote(field_name_13)}": value}
        end
      else
        def unquote(field_name_13)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_13)) or is_struct(value, unquote(struct_module_13)) do
          %{struct_instance | "#{unquote(field_name_13)}": value}
        end
      end
      def unquote(field_name_14)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_14))
      end

      if is_nil(unquote(struct_module_14)) === true do
        def unquote(field_name_14)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_14)) or unquote(guard_14)(value) do
          %{struct_instance | "#{unquote(field_name_14)}": value}
        end
      else
        def unquote(field_name_14)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_14)) or is_struct(value, unquote(struct_module_14)) do
          %{struct_instance | "#{unquote(field_name_14)}": value}
        end
      end
      def unquote(field_name_15)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_15))
      end

      if is_nil(unquote(struct_module_15)) === true do
        def unquote(field_name_15)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_15)) or unquote(guard_15)(value) do
          %{struct_instance | "#{unquote(field_name_15)}": value}
        end
      else
        def unquote(field_name_15)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_15)) or is_struct(value, unquote(struct_module_15)) do
          %{struct_instance | "#{unquote(field_name_15)}": value}
        end
      end
    end
  end




  @doc"""
  Generates a struct, complete with a constructor, getter and setter methods.

  Macro usage example:
      ```
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
        nullable: false,
        struct: nil
      },
      %{
        field: :hair_details,
        type_guard: :is_struct,
        default_value: %Hair{},
        nullable: true,
        struct: Hair
      })
      ```
  """
  defmacro generate_constructor(module, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9, field_10, field_11, field_12, field_13, field_14, field_15, field_16) do

    [
        field: field_name_1,
        type_guard: guard_1,
        default_value: default_1,
        nullable: is_nullable_1,
        struct: struct_module_1
    ] = field_1 |> elem(2)

    [
        field: field_name_2,
        type_guard: guard_2,
        default_value: default_2,
        nullable: is_nullable_2,
        struct: struct_module_2
    ] = field_2 |> elem(2)

    [
        field: field_name_3,
        type_guard: guard_3,
        default_value: default_3,
        nullable: is_nullable_3,
        struct: struct_module_3
    ] = field_3 |> elem(2)

    [
        field: field_name_4,
        type_guard: guard_4,
        default_value: default_4,
        nullable: is_nullable_4,
        struct: struct_module_4
    ] = field_4 |> elem(2)

    [
        field: field_name_5,
        type_guard: guard_5,
        default_value: default_5,
        nullable: is_nullable_5,
        struct: struct_module_5
    ] = field_5 |> elem(2)

    [
        field: field_name_6,
        type_guard: guard_6,
        default_value: default_6,
        nullable: is_nullable_6,
        struct: struct_module_6
    ] = field_6 |> elem(2)

    [
        field: field_name_7,
        type_guard: guard_7,
        default_value: default_7,
        nullable: is_nullable_7,
        struct: struct_module_7
    ] = field_7 |> elem(2)

    [
        field: field_name_8,
        type_guard: guard_8,
        default_value: default_8,
        nullable: is_nullable_8,
        struct: struct_module_8
    ] = field_8 |> elem(2)

    [
        field: field_name_9,
        type_guard: guard_9,
        default_value: default_9,
        nullable: is_nullable_9,
        struct: struct_module_9
    ] = field_9 |> elem(2)

    [
        field: field_name_10,
        type_guard: guard_10,
        default_value: default_10,
        nullable: is_nullable_10,
        struct: struct_module_10
    ] = field_10 |> elem(2)

    [
        field: field_name_11,
        type_guard: guard_11,
        default_value: default_11,
        nullable: is_nullable_11,
        struct: struct_module_11
    ] = field_11 |> elem(2)

    [
        field: field_name_12,
        type_guard: guard_12,
        default_value: default_12,
        nullable: is_nullable_12,
        struct: struct_module_12
    ] = field_12 |> elem(2)

    [
        field: field_name_13,
        type_guard: guard_13,
        default_value: default_13,
        nullable: is_nullable_13,
        struct: struct_module_13
    ] = field_13 |> elem(2)

    [
        field: field_name_14,
        type_guard: guard_14,
        default_value: default_14,
        nullable: is_nullable_14,
        struct: struct_module_14
    ] = field_14 |> elem(2)

    [
        field: field_name_15,
        type_guard: guard_15,
        default_value: default_15,
        nullable: is_nullable_15,
        struct: struct_module_15
    ] = field_15 |> elem(2)

    [
        field: field_name_16,
        type_guard: guard_16,
        default_value: default_16,
        nullable: is_nullable_16,
        struct: struct_module_16
    ] = field_16 |> elem(2)


    quote do
      defstruct [
        "#{unquote(field_name_1)}": unquote(default_1),
        "#{unquote(field_name_2)}": unquote(default_2),
        "#{unquote(field_name_3)}": unquote(default_3),
        "#{unquote(field_name_4)}": unquote(default_4),
        "#{unquote(field_name_5)}": unquote(default_5),
        "#{unquote(field_name_6)}": unquote(default_6),
        "#{unquote(field_name_7)}": unquote(default_7),
        "#{unquote(field_name_8)}": unquote(default_8),
        "#{unquote(field_name_9)}": unquote(default_9),
        "#{unquote(field_name_10)}": unquote(default_10),
        "#{unquote(field_name_11)}": unquote(default_11),
        "#{unquote(field_name_12)}": unquote(default_12),
        "#{unquote(field_name_13)}": unquote(default_13),
        "#{unquote(field_name_14)}": unquote(default_14),
        "#{unquote(field_name_15)}": unquote(default_15),
        "#{unquote(field_name_16)}": unquote(default_16)
      ]

      defp validate_field(field_name, field_value, struct_module, is_nullable, guard) do
        (Code.ensure_compiled(struct_module) |> elem(0) === :module and is_struct(field_value, struct_module))
            or (is_nullable === true and field_value === nil)
            or apply(Kernel, guard, [field_value])
      end

      def constructor(values) do
        is_params_valid =
        validate_field(unquote(field_name_1), values[unquote(field_name_1)], unquote(struct_module_1), unquote(is_nullable_1), unquote(guard_1)) and
        validate_field(unquote(field_name_2), values[unquote(field_name_2)], unquote(struct_module_2), unquote(is_nullable_2), unquote(guard_2)) and
        validate_field(unquote(field_name_3), values[unquote(field_name_3)], unquote(struct_module_3), unquote(is_nullable_3), unquote(guard_3)) and
        validate_field(unquote(field_name_4), values[unquote(field_name_4)], unquote(struct_module_4), unquote(is_nullable_4), unquote(guard_4)) and
        validate_field(unquote(field_name_5), values[unquote(field_name_5)], unquote(struct_module_5), unquote(is_nullable_5), unquote(guard_5)) and
        validate_field(unquote(field_name_6), values[unquote(field_name_6)], unquote(struct_module_6), unquote(is_nullable_6), unquote(guard_6)) and
        validate_field(unquote(field_name_7), values[unquote(field_name_7)], unquote(struct_module_7), unquote(is_nullable_7), unquote(guard_7)) and
        validate_field(unquote(field_name_8), values[unquote(field_name_8)], unquote(struct_module_8), unquote(is_nullable_8), unquote(guard_8)) and
        validate_field(unquote(field_name_9), values[unquote(field_name_9)], unquote(struct_module_9), unquote(is_nullable_9), unquote(guard_9)) and
        validate_field(unquote(field_name_10), values[unquote(field_name_10)], unquote(struct_module_10), unquote(is_nullable_10), unquote(guard_10)) and
        validate_field(unquote(field_name_11), values[unquote(field_name_11)], unquote(struct_module_11), unquote(is_nullable_11), unquote(guard_11)) and
        validate_field(unquote(field_name_12), values[unquote(field_name_12)], unquote(struct_module_12), unquote(is_nullable_12), unquote(guard_12)) and
        validate_field(unquote(field_name_13), values[unquote(field_name_13)], unquote(struct_module_13), unquote(is_nullable_13), unquote(guard_13)) and
        validate_field(unquote(field_name_14), values[unquote(field_name_14)], unquote(struct_module_14), unquote(is_nullable_14), unquote(guard_14)) and
        validate_field(unquote(field_name_15), values[unquote(field_name_15)], unquote(struct_module_15), unquote(is_nullable_15), unquote(guard_15)) and
        validate_field(unquote(field_name_16), values[unquote(field_name_16)], unquote(struct_module_16), unquote(is_nullable_16), unquote(guard_16))

        if is_params_valid === false do
          raise "type mismatch for constructor paramater(s) or required parameters are missing"
        end

        result = %{
            "#{unquote(field_name_1)}": values[unquote(field_name_1)],
            "#{unquote(field_name_2)}": values[unquote(field_name_2)],
            "#{unquote(field_name_3)}": values[unquote(field_name_3)],
            "#{unquote(field_name_4)}": values[unquote(field_name_4)],
            "#{unquote(field_name_5)}": values[unquote(field_name_5)],
            "#{unquote(field_name_6)}": values[unquote(field_name_6)],
            "#{unquote(field_name_7)}": values[unquote(field_name_7)],
            "#{unquote(field_name_8)}": values[unquote(field_name_8)],
            "#{unquote(field_name_9)}": values[unquote(field_name_9)],
            "#{unquote(field_name_10)}": values[unquote(field_name_10)],
            "#{unquote(field_name_11)}": values[unquote(field_name_11)],
            "#{unquote(field_name_12)}": values[unquote(field_name_12)],
            "#{unquote(field_name_13)}": values[unquote(field_name_13)],
            "#{unquote(field_name_14)}": values[unquote(field_name_14)],
            "#{unquote(field_name_15)}": values[unquote(field_name_15)],
            "#{unquote(field_name_16)}": values[unquote(field_name_16)]
        }
        struct(unquote(module), result)
      end


      def unquote(field_name_1)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_1))
      end

      if is_nil(unquote(struct_module_1)) === true do
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or unquote(guard_1)(value) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      else
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or is_struct(value, unquote(struct_module_1)) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      end
      def unquote(field_name_2)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_2))
      end

      if is_nil(unquote(struct_module_2)) === true do
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or unquote(guard_2)(value) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      else
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or is_struct(value, unquote(struct_module_2)) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      end
      def unquote(field_name_3)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_3))
      end

      if is_nil(unquote(struct_module_3)) === true do
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or unquote(guard_3)(value) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      else
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or is_struct(value, unquote(struct_module_3)) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      end
      def unquote(field_name_4)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_4))
      end

      if is_nil(unquote(struct_module_4)) === true do
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or unquote(guard_4)(value) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      else
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or is_struct(value, unquote(struct_module_4)) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      end
      def unquote(field_name_5)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_5))
      end

      if is_nil(unquote(struct_module_5)) === true do
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or unquote(guard_5)(value) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      else
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or is_struct(value, unquote(struct_module_5)) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      end
      def unquote(field_name_6)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_6))
      end

      if is_nil(unquote(struct_module_6)) === true do
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or unquote(guard_6)(value) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      else
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or is_struct(value, unquote(struct_module_6)) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      end
      def unquote(field_name_7)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_7))
      end

      if is_nil(unquote(struct_module_7)) === true do
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or unquote(guard_7)(value) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      else
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or is_struct(value, unquote(struct_module_7)) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      end
      def unquote(field_name_8)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_8))
      end

      if is_nil(unquote(struct_module_8)) === true do
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or unquote(guard_8)(value) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      else
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or is_struct(value, unquote(struct_module_8)) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      end
      def unquote(field_name_9)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_9))
      end

      if is_nil(unquote(struct_module_9)) === true do
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or unquote(guard_9)(value) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      else
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or is_struct(value, unquote(struct_module_9)) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      end
      def unquote(field_name_10)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_10))
      end

      if is_nil(unquote(struct_module_10)) === true do
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or unquote(guard_10)(value) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      else
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or is_struct(value, unquote(struct_module_10)) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      end
      def unquote(field_name_11)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_11))
      end

      if is_nil(unquote(struct_module_11)) === true do
        def unquote(field_name_11)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_11)) or unquote(guard_11)(value) do
          %{struct_instance | "#{unquote(field_name_11)}": value}
        end
      else
        def unquote(field_name_11)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_11)) or is_struct(value, unquote(struct_module_11)) do
          %{struct_instance | "#{unquote(field_name_11)}": value}
        end
      end
      def unquote(field_name_12)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_12))
      end

      if is_nil(unquote(struct_module_12)) === true do
        def unquote(field_name_12)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_12)) or unquote(guard_12)(value) do
          %{struct_instance | "#{unquote(field_name_12)}": value}
        end
      else
        def unquote(field_name_12)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_12)) or is_struct(value, unquote(struct_module_12)) do
          %{struct_instance | "#{unquote(field_name_12)}": value}
        end
      end
      def unquote(field_name_13)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_13))
      end

      if is_nil(unquote(struct_module_13)) === true do
        def unquote(field_name_13)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_13)) or unquote(guard_13)(value) do
          %{struct_instance | "#{unquote(field_name_13)}": value}
        end
      else
        def unquote(field_name_13)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_13)) or is_struct(value, unquote(struct_module_13)) do
          %{struct_instance | "#{unquote(field_name_13)}": value}
        end
      end
      def unquote(field_name_14)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_14))
      end

      if is_nil(unquote(struct_module_14)) === true do
        def unquote(field_name_14)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_14)) or unquote(guard_14)(value) do
          %{struct_instance | "#{unquote(field_name_14)}": value}
        end
      else
        def unquote(field_name_14)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_14)) or is_struct(value, unquote(struct_module_14)) do
          %{struct_instance | "#{unquote(field_name_14)}": value}
        end
      end
      def unquote(field_name_15)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_15))
      end

      if is_nil(unquote(struct_module_15)) === true do
        def unquote(field_name_15)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_15)) or unquote(guard_15)(value) do
          %{struct_instance | "#{unquote(field_name_15)}": value}
        end
      else
        def unquote(field_name_15)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_15)) or is_struct(value, unquote(struct_module_15)) do
          %{struct_instance | "#{unquote(field_name_15)}": value}
        end
      end
      def unquote(field_name_16)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_16))
      end

      if is_nil(unquote(struct_module_16)) === true do
        def unquote(field_name_16)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_16)) or unquote(guard_16)(value) do
          %{struct_instance | "#{unquote(field_name_16)}": value}
        end
      else
        def unquote(field_name_16)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_16)) or is_struct(value, unquote(struct_module_16)) do
          %{struct_instance | "#{unquote(field_name_16)}": value}
        end
      end
    end
  end




  @doc"""
  Generates a struct, complete with a constructor, getter and setter methods.

  Macro usage example:
      ```
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
        nullable: false,
        struct: nil
      },
      %{
        field: :hair_details,
        type_guard: :is_struct,
        default_value: %Hair{},
        nullable: true,
        struct: Hair
      })
      ```
  """
  defmacro generate_constructor(module, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9, field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17) do

    [
        field: field_name_1,
        type_guard: guard_1,
        default_value: default_1,
        nullable: is_nullable_1,
        struct: struct_module_1
    ] = field_1 |> elem(2)

    [
        field: field_name_2,
        type_guard: guard_2,
        default_value: default_2,
        nullable: is_nullable_2,
        struct: struct_module_2
    ] = field_2 |> elem(2)

    [
        field: field_name_3,
        type_guard: guard_3,
        default_value: default_3,
        nullable: is_nullable_3,
        struct: struct_module_3
    ] = field_3 |> elem(2)

    [
        field: field_name_4,
        type_guard: guard_4,
        default_value: default_4,
        nullable: is_nullable_4,
        struct: struct_module_4
    ] = field_4 |> elem(2)

    [
        field: field_name_5,
        type_guard: guard_5,
        default_value: default_5,
        nullable: is_nullable_5,
        struct: struct_module_5
    ] = field_5 |> elem(2)

    [
        field: field_name_6,
        type_guard: guard_6,
        default_value: default_6,
        nullable: is_nullable_6,
        struct: struct_module_6
    ] = field_6 |> elem(2)

    [
        field: field_name_7,
        type_guard: guard_7,
        default_value: default_7,
        nullable: is_nullable_7,
        struct: struct_module_7
    ] = field_7 |> elem(2)

    [
        field: field_name_8,
        type_guard: guard_8,
        default_value: default_8,
        nullable: is_nullable_8,
        struct: struct_module_8
    ] = field_8 |> elem(2)

    [
        field: field_name_9,
        type_guard: guard_9,
        default_value: default_9,
        nullable: is_nullable_9,
        struct: struct_module_9
    ] = field_9 |> elem(2)

    [
        field: field_name_10,
        type_guard: guard_10,
        default_value: default_10,
        nullable: is_nullable_10,
        struct: struct_module_10
    ] = field_10 |> elem(2)

    [
        field: field_name_11,
        type_guard: guard_11,
        default_value: default_11,
        nullable: is_nullable_11,
        struct: struct_module_11
    ] = field_11 |> elem(2)

    [
        field: field_name_12,
        type_guard: guard_12,
        default_value: default_12,
        nullable: is_nullable_12,
        struct: struct_module_12
    ] = field_12 |> elem(2)

    [
        field: field_name_13,
        type_guard: guard_13,
        default_value: default_13,
        nullable: is_nullable_13,
        struct: struct_module_13
    ] = field_13 |> elem(2)

    [
        field: field_name_14,
        type_guard: guard_14,
        default_value: default_14,
        nullable: is_nullable_14,
        struct: struct_module_14
    ] = field_14 |> elem(2)

    [
        field: field_name_15,
        type_guard: guard_15,
        default_value: default_15,
        nullable: is_nullable_15,
        struct: struct_module_15
    ] = field_15 |> elem(2)

    [
        field: field_name_16,
        type_guard: guard_16,
        default_value: default_16,
        nullable: is_nullable_16,
        struct: struct_module_16
    ] = field_16 |> elem(2)

    [
        field: field_name_17,
        type_guard: guard_17,
        default_value: default_17,
        nullable: is_nullable_17,
        struct: struct_module_17
    ] = field_17 |> elem(2)


    quote do
      defstruct [
        "#{unquote(field_name_1)}": unquote(default_1),
        "#{unquote(field_name_2)}": unquote(default_2),
        "#{unquote(field_name_3)}": unquote(default_3),
        "#{unquote(field_name_4)}": unquote(default_4),
        "#{unquote(field_name_5)}": unquote(default_5),
        "#{unquote(field_name_6)}": unquote(default_6),
        "#{unquote(field_name_7)}": unquote(default_7),
        "#{unquote(field_name_8)}": unquote(default_8),
        "#{unquote(field_name_9)}": unquote(default_9),
        "#{unquote(field_name_10)}": unquote(default_10),
        "#{unquote(field_name_11)}": unquote(default_11),
        "#{unquote(field_name_12)}": unquote(default_12),
        "#{unquote(field_name_13)}": unquote(default_13),
        "#{unquote(field_name_14)}": unquote(default_14),
        "#{unquote(field_name_15)}": unquote(default_15),
        "#{unquote(field_name_16)}": unquote(default_16),
        "#{unquote(field_name_17)}": unquote(default_17)
      ]

      defp validate_field(field_name, field_value, struct_module, is_nullable, guard) do
        (Code.ensure_compiled(struct_module) |> elem(0) === :module and is_struct(field_value, struct_module))
            or (is_nullable === true and field_value === nil)
            or apply(Kernel, guard, [field_value])
      end

      def constructor(values) do
        is_params_valid =
        validate_field(unquote(field_name_1), values[unquote(field_name_1)], unquote(struct_module_1), unquote(is_nullable_1), unquote(guard_1)) and
        validate_field(unquote(field_name_2), values[unquote(field_name_2)], unquote(struct_module_2), unquote(is_nullable_2), unquote(guard_2)) and
        validate_field(unquote(field_name_3), values[unquote(field_name_3)], unquote(struct_module_3), unquote(is_nullable_3), unquote(guard_3)) and
        validate_field(unquote(field_name_4), values[unquote(field_name_4)], unquote(struct_module_4), unquote(is_nullable_4), unquote(guard_4)) and
        validate_field(unquote(field_name_5), values[unquote(field_name_5)], unquote(struct_module_5), unquote(is_nullable_5), unquote(guard_5)) and
        validate_field(unquote(field_name_6), values[unquote(field_name_6)], unquote(struct_module_6), unquote(is_nullable_6), unquote(guard_6)) and
        validate_field(unquote(field_name_7), values[unquote(field_name_7)], unquote(struct_module_7), unquote(is_nullable_7), unquote(guard_7)) and
        validate_field(unquote(field_name_8), values[unquote(field_name_8)], unquote(struct_module_8), unquote(is_nullable_8), unquote(guard_8)) and
        validate_field(unquote(field_name_9), values[unquote(field_name_9)], unquote(struct_module_9), unquote(is_nullable_9), unquote(guard_9)) and
        validate_field(unquote(field_name_10), values[unquote(field_name_10)], unquote(struct_module_10), unquote(is_nullable_10), unquote(guard_10)) and
        validate_field(unquote(field_name_11), values[unquote(field_name_11)], unquote(struct_module_11), unquote(is_nullable_11), unquote(guard_11)) and
        validate_field(unquote(field_name_12), values[unquote(field_name_12)], unquote(struct_module_12), unquote(is_nullable_12), unquote(guard_12)) and
        validate_field(unquote(field_name_13), values[unquote(field_name_13)], unquote(struct_module_13), unquote(is_nullable_13), unquote(guard_13)) and
        validate_field(unquote(field_name_14), values[unquote(field_name_14)], unquote(struct_module_14), unquote(is_nullable_14), unquote(guard_14)) and
        validate_field(unquote(field_name_15), values[unquote(field_name_15)], unquote(struct_module_15), unquote(is_nullable_15), unquote(guard_15)) and
        validate_field(unquote(field_name_16), values[unquote(field_name_16)], unquote(struct_module_16), unquote(is_nullable_16), unquote(guard_16)) and
        validate_field(unquote(field_name_17), values[unquote(field_name_17)], unquote(struct_module_17), unquote(is_nullable_17), unquote(guard_17))

        if is_params_valid === false do
          raise "type mismatch for constructor paramater(s) or required parameters are missing"
        end

        result = %{
            "#{unquote(field_name_1)}": values[unquote(field_name_1)],
            "#{unquote(field_name_2)}": values[unquote(field_name_2)],
            "#{unquote(field_name_3)}": values[unquote(field_name_3)],
            "#{unquote(field_name_4)}": values[unquote(field_name_4)],
            "#{unquote(field_name_5)}": values[unquote(field_name_5)],
            "#{unquote(field_name_6)}": values[unquote(field_name_6)],
            "#{unquote(field_name_7)}": values[unquote(field_name_7)],
            "#{unquote(field_name_8)}": values[unquote(field_name_8)],
            "#{unquote(field_name_9)}": values[unquote(field_name_9)],
            "#{unquote(field_name_10)}": values[unquote(field_name_10)],
            "#{unquote(field_name_11)}": values[unquote(field_name_11)],
            "#{unquote(field_name_12)}": values[unquote(field_name_12)],
            "#{unquote(field_name_13)}": values[unquote(field_name_13)],
            "#{unquote(field_name_14)}": values[unquote(field_name_14)],
            "#{unquote(field_name_15)}": values[unquote(field_name_15)],
            "#{unquote(field_name_16)}": values[unquote(field_name_16)],
            "#{unquote(field_name_17)}": values[unquote(field_name_17)]
        }
        struct(unquote(module), result)
      end


      def unquote(field_name_1)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_1))
      end

      if is_nil(unquote(struct_module_1)) === true do
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or unquote(guard_1)(value) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      else
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or is_struct(value, unquote(struct_module_1)) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      end
      def unquote(field_name_2)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_2))
      end

      if is_nil(unquote(struct_module_2)) === true do
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or unquote(guard_2)(value) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      else
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or is_struct(value, unquote(struct_module_2)) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      end
      def unquote(field_name_3)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_3))
      end

      if is_nil(unquote(struct_module_3)) === true do
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or unquote(guard_3)(value) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      else
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or is_struct(value, unquote(struct_module_3)) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      end
      def unquote(field_name_4)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_4))
      end

      if is_nil(unquote(struct_module_4)) === true do
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or unquote(guard_4)(value) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      else
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or is_struct(value, unquote(struct_module_4)) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      end
      def unquote(field_name_5)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_5))
      end

      if is_nil(unquote(struct_module_5)) === true do
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or unquote(guard_5)(value) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      else
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or is_struct(value, unquote(struct_module_5)) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      end
      def unquote(field_name_6)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_6))
      end

      if is_nil(unquote(struct_module_6)) === true do
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or unquote(guard_6)(value) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      else
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or is_struct(value, unquote(struct_module_6)) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      end
      def unquote(field_name_7)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_7))
      end

      if is_nil(unquote(struct_module_7)) === true do
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or unquote(guard_7)(value) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      else
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or is_struct(value, unquote(struct_module_7)) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      end
      def unquote(field_name_8)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_8))
      end

      if is_nil(unquote(struct_module_8)) === true do
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or unquote(guard_8)(value) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      else
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or is_struct(value, unquote(struct_module_8)) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      end
      def unquote(field_name_9)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_9))
      end

      if is_nil(unquote(struct_module_9)) === true do
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or unquote(guard_9)(value) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      else
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or is_struct(value, unquote(struct_module_9)) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      end
      def unquote(field_name_10)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_10))
      end

      if is_nil(unquote(struct_module_10)) === true do
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or unquote(guard_10)(value) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      else
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or is_struct(value, unquote(struct_module_10)) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      end
      def unquote(field_name_11)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_11))
      end

      if is_nil(unquote(struct_module_11)) === true do
        def unquote(field_name_11)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_11)) or unquote(guard_11)(value) do
          %{struct_instance | "#{unquote(field_name_11)}": value}
        end
      else
        def unquote(field_name_11)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_11)) or is_struct(value, unquote(struct_module_11)) do
          %{struct_instance | "#{unquote(field_name_11)}": value}
        end
      end
      def unquote(field_name_12)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_12))
      end

      if is_nil(unquote(struct_module_12)) === true do
        def unquote(field_name_12)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_12)) or unquote(guard_12)(value) do
          %{struct_instance | "#{unquote(field_name_12)}": value}
        end
      else
        def unquote(field_name_12)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_12)) or is_struct(value, unquote(struct_module_12)) do
          %{struct_instance | "#{unquote(field_name_12)}": value}
        end
      end
      def unquote(field_name_13)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_13))
      end

      if is_nil(unquote(struct_module_13)) === true do
        def unquote(field_name_13)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_13)) or unquote(guard_13)(value) do
          %{struct_instance | "#{unquote(field_name_13)}": value}
        end
      else
        def unquote(field_name_13)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_13)) or is_struct(value, unquote(struct_module_13)) do
          %{struct_instance | "#{unquote(field_name_13)}": value}
        end
      end
      def unquote(field_name_14)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_14))
      end

      if is_nil(unquote(struct_module_14)) === true do
        def unquote(field_name_14)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_14)) or unquote(guard_14)(value) do
          %{struct_instance | "#{unquote(field_name_14)}": value}
        end
      else
        def unquote(field_name_14)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_14)) or is_struct(value, unquote(struct_module_14)) do
          %{struct_instance | "#{unquote(field_name_14)}": value}
        end
      end
      def unquote(field_name_15)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_15))
      end

      if is_nil(unquote(struct_module_15)) === true do
        def unquote(field_name_15)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_15)) or unquote(guard_15)(value) do
          %{struct_instance | "#{unquote(field_name_15)}": value}
        end
      else
        def unquote(field_name_15)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_15)) or is_struct(value, unquote(struct_module_15)) do
          %{struct_instance | "#{unquote(field_name_15)}": value}
        end
      end
      def unquote(field_name_16)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_16))
      end

      if is_nil(unquote(struct_module_16)) === true do
        def unquote(field_name_16)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_16)) or unquote(guard_16)(value) do
          %{struct_instance | "#{unquote(field_name_16)}": value}
        end
      else
        def unquote(field_name_16)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_16)) or is_struct(value, unquote(struct_module_16)) do
          %{struct_instance | "#{unquote(field_name_16)}": value}
        end
      end
      def unquote(field_name_17)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_17))
      end

      if is_nil(unquote(struct_module_17)) === true do
        def unquote(field_name_17)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_17)) or unquote(guard_17)(value) do
          %{struct_instance | "#{unquote(field_name_17)}": value}
        end
      else
        def unquote(field_name_17)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_17)) or is_struct(value, unquote(struct_module_17)) do
          %{struct_instance | "#{unquote(field_name_17)}": value}
        end
      end
    end
  end




  @doc"""
  Generates a struct, complete with a constructor, getter and setter methods.

  Macro usage example:
      ```
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
        nullable: false,
        struct: nil
      },
      %{
        field: :hair_details,
        type_guard: :is_struct,
        default_value: %Hair{},
        nullable: true,
        struct: Hair
      })
      ```
  """
  defmacro generate_constructor(module, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9, field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18) do

    [
        field: field_name_1,
        type_guard: guard_1,
        default_value: default_1,
        nullable: is_nullable_1,
        struct: struct_module_1
    ] = field_1 |> elem(2)

    [
        field: field_name_2,
        type_guard: guard_2,
        default_value: default_2,
        nullable: is_nullable_2,
        struct: struct_module_2
    ] = field_2 |> elem(2)

    [
        field: field_name_3,
        type_guard: guard_3,
        default_value: default_3,
        nullable: is_nullable_3,
        struct: struct_module_3
    ] = field_3 |> elem(2)

    [
        field: field_name_4,
        type_guard: guard_4,
        default_value: default_4,
        nullable: is_nullable_4,
        struct: struct_module_4
    ] = field_4 |> elem(2)

    [
        field: field_name_5,
        type_guard: guard_5,
        default_value: default_5,
        nullable: is_nullable_5,
        struct: struct_module_5
    ] = field_5 |> elem(2)

    [
        field: field_name_6,
        type_guard: guard_6,
        default_value: default_6,
        nullable: is_nullable_6,
        struct: struct_module_6
    ] = field_6 |> elem(2)

    [
        field: field_name_7,
        type_guard: guard_7,
        default_value: default_7,
        nullable: is_nullable_7,
        struct: struct_module_7
    ] = field_7 |> elem(2)

    [
        field: field_name_8,
        type_guard: guard_8,
        default_value: default_8,
        nullable: is_nullable_8,
        struct: struct_module_8
    ] = field_8 |> elem(2)

    [
        field: field_name_9,
        type_guard: guard_9,
        default_value: default_9,
        nullable: is_nullable_9,
        struct: struct_module_9
    ] = field_9 |> elem(2)

    [
        field: field_name_10,
        type_guard: guard_10,
        default_value: default_10,
        nullable: is_nullable_10,
        struct: struct_module_10
    ] = field_10 |> elem(2)

    [
        field: field_name_11,
        type_guard: guard_11,
        default_value: default_11,
        nullable: is_nullable_11,
        struct: struct_module_11
    ] = field_11 |> elem(2)

    [
        field: field_name_12,
        type_guard: guard_12,
        default_value: default_12,
        nullable: is_nullable_12,
        struct: struct_module_12
    ] = field_12 |> elem(2)

    [
        field: field_name_13,
        type_guard: guard_13,
        default_value: default_13,
        nullable: is_nullable_13,
        struct: struct_module_13
    ] = field_13 |> elem(2)

    [
        field: field_name_14,
        type_guard: guard_14,
        default_value: default_14,
        nullable: is_nullable_14,
        struct: struct_module_14
    ] = field_14 |> elem(2)

    [
        field: field_name_15,
        type_guard: guard_15,
        default_value: default_15,
        nullable: is_nullable_15,
        struct: struct_module_15
    ] = field_15 |> elem(2)

    [
        field: field_name_16,
        type_guard: guard_16,
        default_value: default_16,
        nullable: is_nullable_16,
        struct: struct_module_16
    ] = field_16 |> elem(2)

    [
        field: field_name_17,
        type_guard: guard_17,
        default_value: default_17,
        nullable: is_nullable_17,
        struct: struct_module_17
    ] = field_17 |> elem(2)

    [
        field: field_name_18,
        type_guard: guard_18,
        default_value: default_18,
        nullable: is_nullable_18,
        struct: struct_module_18
    ] = field_18 |> elem(2)


    quote do
      defstruct [
        "#{unquote(field_name_1)}": unquote(default_1),
        "#{unquote(field_name_2)}": unquote(default_2),
        "#{unquote(field_name_3)}": unquote(default_3),
        "#{unquote(field_name_4)}": unquote(default_4),
        "#{unquote(field_name_5)}": unquote(default_5),
        "#{unquote(field_name_6)}": unquote(default_6),
        "#{unquote(field_name_7)}": unquote(default_7),
        "#{unquote(field_name_8)}": unquote(default_8),
        "#{unquote(field_name_9)}": unquote(default_9),
        "#{unquote(field_name_10)}": unquote(default_10),
        "#{unquote(field_name_11)}": unquote(default_11),
        "#{unquote(field_name_12)}": unquote(default_12),
        "#{unquote(field_name_13)}": unquote(default_13),
        "#{unquote(field_name_14)}": unquote(default_14),
        "#{unquote(field_name_15)}": unquote(default_15),
        "#{unquote(field_name_16)}": unquote(default_16),
        "#{unquote(field_name_17)}": unquote(default_17),
        "#{unquote(field_name_18)}": unquote(default_18)
      ]

      defp validate_field(field_name, field_value, struct_module, is_nullable, guard) do
        (Code.ensure_compiled(struct_module) |> elem(0) === :module and is_struct(field_value, struct_module))
            or (is_nullable === true and field_value === nil)
            or apply(Kernel, guard, [field_value])
      end

      def constructor(values) do
        is_params_valid =
        validate_field(unquote(field_name_1), values[unquote(field_name_1)], unquote(struct_module_1), unquote(is_nullable_1), unquote(guard_1)) and
        validate_field(unquote(field_name_2), values[unquote(field_name_2)], unquote(struct_module_2), unquote(is_nullable_2), unquote(guard_2)) and
        validate_field(unquote(field_name_3), values[unquote(field_name_3)], unquote(struct_module_3), unquote(is_nullable_3), unquote(guard_3)) and
        validate_field(unquote(field_name_4), values[unquote(field_name_4)], unquote(struct_module_4), unquote(is_nullable_4), unquote(guard_4)) and
        validate_field(unquote(field_name_5), values[unquote(field_name_5)], unquote(struct_module_5), unquote(is_nullable_5), unquote(guard_5)) and
        validate_field(unquote(field_name_6), values[unquote(field_name_6)], unquote(struct_module_6), unquote(is_nullable_6), unquote(guard_6)) and
        validate_field(unquote(field_name_7), values[unquote(field_name_7)], unquote(struct_module_7), unquote(is_nullable_7), unquote(guard_7)) and
        validate_field(unquote(field_name_8), values[unquote(field_name_8)], unquote(struct_module_8), unquote(is_nullable_8), unquote(guard_8)) and
        validate_field(unquote(field_name_9), values[unquote(field_name_9)], unquote(struct_module_9), unquote(is_nullable_9), unquote(guard_9)) and
        validate_field(unquote(field_name_10), values[unquote(field_name_10)], unquote(struct_module_10), unquote(is_nullable_10), unquote(guard_10)) and
        validate_field(unquote(field_name_11), values[unquote(field_name_11)], unquote(struct_module_11), unquote(is_nullable_11), unquote(guard_11)) and
        validate_field(unquote(field_name_12), values[unquote(field_name_12)], unquote(struct_module_12), unquote(is_nullable_12), unquote(guard_12)) and
        validate_field(unquote(field_name_13), values[unquote(field_name_13)], unquote(struct_module_13), unquote(is_nullable_13), unquote(guard_13)) and
        validate_field(unquote(field_name_14), values[unquote(field_name_14)], unquote(struct_module_14), unquote(is_nullable_14), unquote(guard_14)) and
        validate_field(unquote(field_name_15), values[unquote(field_name_15)], unquote(struct_module_15), unquote(is_nullable_15), unquote(guard_15)) and
        validate_field(unquote(field_name_16), values[unquote(field_name_16)], unquote(struct_module_16), unquote(is_nullable_16), unquote(guard_16)) and
        validate_field(unquote(field_name_17), values[unquote(field_name_17)], unquote(struct_module_17), unquote(is_nullable_17), unquote(guard_17)) and
        validate_field(unquote(field_name_18), values[unquote(field_name_18)], unquote(struct_module_18), unquote(is_nullable_18), unquote(guard_18))

        if is_params_valid === false do
          raise "type mismatch for constructor paramater(s) or required parameters are missing"
        end

        result = %{
            "#{unquote(field_name_1)}": values[unquote(field_name_1)],
            "#{unquote(field_name_2)}": values[unquote(field_name_2)],
            "#{unquote(field_name_3)}": values[unquote(field_name_3)],
            "#{unquote(field_name_4)}": values[unquote(field_name_4)],
            "#{unquote(field_name_5)}": values[unquote(field_name_5)],
            "#{unquote(field_name_6)}": values[unquote(field_name_6)],
            "#{unquote(field_name_7)}": values[unquote(field_name_7)],
            "#{unquote(field_name_8)}": values[unquote(field_name_8)],
            "#{unquote(field_name_9)}": values[unquote(field_name_9)],
            "#{unquote(field_name_10)}": values[unquote(field_name_10)],
            "#{unquote(field_name_11)}": values[unquote(field_name_11)],
            "#{unquote(field_name_12)}": values[unquote(field_name_12)],
            "#{unquote(field_name_13)}": values[unquote(field_name_13)],
            "#{unquote(field_name_14)}": values[unquote(field_name_14)],
            "#{unquote(field_name_15)}": values[unquote(field_name_15)],
            "#{unquote(field_name_16)}": values[unquote(field_name_16)],
            "#{unquote(field_name_17)}": values[unquote(field_name_17)],
            "#{unquote(field_name_18)}": values[unquote(field_name_18)]
        }
        struct(unquote(module), result)
      end


      def unquote(field_name_1)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_1))
      end

      if is_nil(unquote(struct_module_1)) === true do
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or unquote(guard_1)(value) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      else
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or is_struct(value, unquote(struct_module_1)) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      end
      def unquote(field_name_2)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_2))
      end

      if is_nil(unquote(struct_module_2)) === true do
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or unquote(guard_2)(value) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      else
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or is_struct(value, unquote(struct_module_2)) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      end
      def unquote(field_name_3)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_3))
      end

      if is_nil(unquote(struct_module_3)) === true do
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or unquote(guard_3)(value) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      else
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or is_struct(value, unquote(struct_module_3)) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      end
      def unquote(field_name_4)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_4))
      end

      if is_nil(unquote(struct_module_4)) === true do
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or unquote(guard_4)(value) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      else
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or is_struct(value, unquote(struct_module_4)) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      end
      def unquote(field_name_5)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_5))
      end

      if is_nil(unquote(struct_module_5)) === true do
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or unquote(guard_5)(value) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      else
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or is_struct(value, unquote(struct_module_5)) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      end
      def unquote(field_name_6)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_6))
      end

      if is_nil(unquote(struct_module_6)) === true do
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or unquote(guard_6)(value) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      else
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or is_struct(value, unquote(struct_module_6)) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      end
      def unquote(field_name_7)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_7))
      end

      if is_nil(unquote(struct_module_7)) === true do
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or unquote(guard_7)(value) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      else
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or is_struct(value, unquote(struct_module_7)) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      end
      def unquote(field_name_8)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_8))
      end

      if is_nil(unquote(struct_module_8)) === true do
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or unquote(guard_8)(value) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      else
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or is_struct(value, unquote(struct_module_8)) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      end
      def unquote(field_name_9)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_9))
      end

      if is_nil(unquote(struct_module_9)) === true do
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or unquote(guard_9)(value) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      else
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or is_struct(value, unquote(struct_module_9)) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      end
      def unquote(field_name_10)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_10))
      end

      if is_nil(unquote(struct_module_10)) === true do
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or unquote(guard_10)(value) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      else
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or is_struct(value, unquote(struct_module_10)) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      end
      def unquote(field_name_11)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_11))
      end

      if is_nil(unquote(struct_module_11)) === true do
        def unquote(field_name_11)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_11)) or unquote(guard_11)(value) do
          %{struct_instance | "#{unquote(field_name_11)}": value}
        end
      else
        def unquote(field_name_11)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_11)) or is_struct(value, unquote(struct_module_11)) do
          %{struct_instance | "#{unquote(field_name_11)}": value}
        end
      end
      def unquote(field_name_12)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_12))
      end

      if is_nil(unquote(struct_module_12)) === true do
        def unquote(field_name_12)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_12)) or unquote(guard_12)(value) do
          %{struct_instance | "#{unquote(field_name_12)}": value}
        end
      else
        def unquote(field_name_12)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_12)) or is_struct(value, unquote(struct_module_12)) do
          %{struct_instance | "#{unquote(field_name_12)}": value}
        end
      end
      def unquote(field_name_13)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_13))
      end

      if is_nil(unquote(struct_module_13)) === true do
        def unquote(field_name_13)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_13)) or unquote(guard_13)(value) do
          %{struct_instance | "#{unquote(field_name_13)}": value}
        end
      else
        def unquote(field_name_13)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_13)) or is_struct(value, unquote(struct_module_13)) do
          %{struct_instance | "#{unquote(field_name_13)}": value}
        end
      end
      def unquote(field_name_14)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_14))
      end

      if is_nil(unquote(struct_module_14)) === true do
        def unquote(field_name_14)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_14)) or unquote(guard_14)(value) do
          %{struct_instance | "#{unquote(field_name_14)}": value}
        end
      else
        def unquote(field_name_14)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_14)) or is_struct(value, unquote(struct_module_14)) do
          %{struct_instance | "#{unquote(field_name_14)}": value}
        end
      end
      def unquote(field_name_15)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_15))
      end

      if is_nil(unquote(struct_module_15)) === true do
        def unquote(field_name_15)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_15)) or unquote(guard_15)(value) do
          %{struct_instance | "#{unquote(field_name_15)}": value}
        end
      else
        def unquote(field_name_15)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_15)) or is_struct(value, unquote(struct_module_15)) do
          %{struct_instance | "#{unquote(field_name_15)}": value}
        end
      end
      def unquote(field_name_16)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_16))
      end

      if is_nil(unquote(struct_module_16)) === true do
        def unquote(field_name_16)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_16)) or unquote(guard_16)(value) do
          %{struct_instance | "#{unquote(field_name_16)}": value}
        end
      else
        def unquote(field_name_16)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_16)) or is_struct(value, unquote(struct_module_16)) do
          %{struct_instance | "#{unquote(field_name_16)}": value}
        end
      end
      def unquote(field_name_17)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_17))
      end

      if is_nil(unquote(struct_module_17)) === true do
        def unquote(field_name_17)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_17)) or unquote(guard_17)(value) do
          %{struct_instance | "#{unquote(field_name_17)}": value}
        end
      else
        def unquote(field_name_17)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_17)) or is_struct(value, unquote(struct_module_17)) do
          %{struct_instance | "#{unquote(field_name_17)}": value}
        end
      end
      def unquote(field_name_18)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_18))
      end

      if is_nil(unquote(struct_module_18)) === true do
        def unquote(field_name_18)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_18)) or unquote(guard_18)(value) do
          %{struct_instance | "#{unquote(field_name_18)}": value}
        end
      else
        def unquote(field_name_18)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_18)) or is_struct(value, unquote(struct_module_18)) do
          %{struct_instance | "#{unquote(field_name_18)}": value}
        end
      end
    end
  end




  @doc"""
  Generates a struct, complete with a constructor, getter and setter methods.

  Macro usage example:
      ```
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
        nullable: false,
        struct: nil
      },
      %{
        field: :hair_details,
        type_guard: :is_struct,
        default_value: %Hair{},
        nullable: true,
        struct: Hair
      })
      ```
  """
  defmacro generate_constructor(module, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9, field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19) do

    [
        field: field_name_1,
        type_guard: guard_1,
        default_value: default_1,
        nullable: is_nullable_1,
        struct: struct_module_1
    ] = field_1 |> elem(2)

    [
        field: field_name_2,
        type_guard: guard_2,
        default_value: default_2,
        nullable: is_nullable_2,
        struct: struct_module_2
    ] = field_2 |> elem(2)

    [
        field: field_name_3,
        type_guard: guard_3,
        default_value: default_3,
        nullable: is_nullable_3,
        struct: struct_module_3
    ] = field_3 |> elem(2)

    [
        field: field_name_4,
        type_guard: guard_4,
        default_value: default_4,
        nullable: is_nullable_4,
        struct: struct_module_4
    ] = field_4 |> elem(2)

    [
        field: field_name_5,
        type_guard: guard_5,
        default_value: default_5,
        nullable: is_nullable_5,
        struct: struct_module_5
    ] = field_5 |> elem(2)

    [
        field: field_name_6,
        type_guard: guard_6,
        default_value: default_6,
        nullable: is_nullable_6,
        struct: struct_module_6
    ] = field_6 |> elem(2)

    [
        field: field_name_7,
        type_guard: guard_7,
        default_value: default_7,
        nullable: is_nullable_7,
        struct: struct_module_7
    ] = field_7 |> elem(2)

    [
        field: field_name_8,
        type_guard: guard_8,
        default_value: default_8,
        nullable: is_nullable_8,
        struct: struct_module_8
    ] = field_8 |> elem(2)

    [
        field: field_name_9,
        type_guard: guard_9,
        default_value: default_9,
        nullable: is_nullable_9,
        struct: struct_module_9
    ] = field_9 |> elem(2)

    [
        field: field_name_10,
        type_guard: guard_10,
        default_value: default_10,
        nullable: is_nullable_10,
        struct: struct_module_10
    ] = field_10 |> elem(2)

    [
        field: field_name_11,
        type_guard: guard_11,
        default_value: default_11,
        nullable: is_nullable_11,
        struct: struct_module_11
    ] = field_11 |> elem(2)

    [
        field: field_name_12,
        type_guard: guard_12,
        default_value: default_12,
        nullable: is_nullable_12,
        struct: struct_module_12
    ] = field_12 |> elem(2)

    [
        field: field_name_13,
        type_guard: guard_13,
        default_value: default_13,
        nullable: is_nullable_13,
        struct: struct_module_13
    ] = field_13 |> elem(2)

    [
        field: field_name_14,
        type_guard: guard_14,
        default_value: default_14,
        nullable: is_nullable_14,
        struct: struct_module_14
    ] = field_14 |> elem(2)

    [
        field: field_name_15,
        type_guard: guard_15,
        default_value: default_15,
        nullable: is_nullable_15,
        struct: struct_module_15
    ] = field_15 |> elem(2)

    [
        field: field_name_16,
        type_guard: guard_16,
        default_value: default_16,
        nullable: is_nullable_16,
        struct: struct_module_16
    ] = field_16 |> elem(2)

    [
        field: field_name_17,
        type_guard: guard_17,
        default_value: default_17,
        nullable: is_nullable_17,
        struct: struct_module_17
    ] = field_17 |> elem(2)

    [
        field: field_name_18,
        type_guard: guard_18,
        default_value: default_18,
        nullable: is_nullable_18,
        struct: struct_module_18
    ] = field_18 |> elem(2)

    [
        field: field_name_19,
        type_guard: guard_19,
        default_value: default_19,
        nullable: is_nullable_19,
        struct: struct_module_19
    ] = field_19 |> elem(2)


    quote do
      defstruct [
        "#{unquote(field_name_1)}": unquote(default_1),
        "#{unquote(field_name_2)}": unquote(default_2),
        "#{unquote(field_name_3)}": unquote(default_3),
        "#{unquote(field_name_4)}": unquote(default_4),
        "#{unquote(field_name_5)}": unquote(default_5),
        "#{unquote(field_name_6)}": unquote(default_6),
        "#{unquote(field_name_7)}": unquote(default_7),
        "#{unquote(field_name_8)}": unquote(default_8),
        "#{unquote(field_name_9)}": unquote(default_9),
        "#{unquote(field_name_10)}": unquote(default_10),
        "#{unquote(field_name_11)}": unquote(default_11),
        "#{unquote(field_name_12)}": unquote(default_12),
        "#{unquote(field_name_13)}": unquote(default_13),
        "#{unquote(field_name_14)}": unquote(default_14),
        "#{unquote(field_name_15)}": unquote(default_15),
        "#{unquote(field_name_16)}": unquote(default_16),
        "#{unquote(field_name_17)}": unquote(default_17),
        "#{unquote(field_name_18)}": unquote(default_18),
        "#{unquote(field_name_19)}": unquote(default_19)
      ]

      defp validate_field(field_name, field_value, struct_module, is_nullable, guard) do
        (Code.ensure_compiled(struct_module) |> elem(0) === :module and is_struct(field_value, struct_module))
            or (is_nullable === true and field_value === nil)
            or apply(Kernel, guard, [field_value])
      end

      def constructor(values) do
        is_params_valid =
        validate_field(unquote(field_name_1), values[unquote(field_name_1)], unquote(struct_module_1), unquote(is_nullable_1), unquote(guard_1)) and
        validate_field(unquote(field_name_2), values[unquote(field_name_2)], unquote(struct_module_2), unquote(is_nullable_2), unquote(guard_2)) and
        validate_field(unquote(field_name_3), values[unquote(field_name_3)], unquote(struct_module_3), unquote(is_nullable_3), unquote(guard_3)) and
        validate_field(unquote(field_name_4), values[unquote(field_name_4)], unquote(struct_module_4), unquote(is_nullable_4), unquote(guard_4)) and
        validate_field(unquote(field_name_5), values[unquote(field_name_5)], unquote(struct_module_5), unquote(is_nullable_5), unquote(guard_5)) and
        validate_field(unquote(field_name_6), values[unquote(field_name_6)], unquote(struct_module_6), unquote(is_nullable_6), unquote(guard_6)) and
        validate_field(unquote(field_name_7), values[unquote(field_name_7)], unquote(struct_module_7), unquote(is_nullable_7), unquote(guard_7)) and
        validate_field(unquote(field_name_8), values[unquote(field_name_8)], unquote(struct_module_8), unquote(is_nullable_8), unquote(guard_8)) and
        validate_field(unquote(field_name_9), values[unquote(field_name_9)], unquote(struct_module_9), unquote(is_nullable_9), unquote(guard_9)) and
        validate_field(unquote(field_name_10), values[unquote(field_name_10)], unquote(struct_module_10), unquote(is_nullable_10), unquote(guard_10)) and
        validate_field(unquote(field_name_11), values[unquote(field_name_11)], unquote(struct_module_11), unquote(is_nullable_11), unquote(guard_11)) and
        validate_field(unquote(field_name_12), values[unquote(field_name_12)], unquote(struct_module_12), unquote(is_nullable_12), unquote(guard_12)) and
        validate_field(unquote(field_name_13), values[unquote(field_name_13)], unquote(struct_module_13), unquote(is_nullable_13), unquote(guard_13)) and
        validate_field(unquote(field_name_14), values[unquote(field_name_14)], unquote(struct_module_14), unquote(is_nullable_14), unquote(guard_14)) and
        validate_field(unquote(field_name_15), values[unquote(field_name_15)], unquote(struct_module_15), unquote(is_nullable_15), unquote(guard_15)) and
        validate_field(unquote(field_name_16), values[unquote(field_name_16)], unquote(struct_module_16), unquote(is_nullable_16), unquote(guard_16)) and
        validate_field(unquote(field_name_17), values[unquote(field_name_17)], unquote(struct_module_17), unquote(is_nullable_17), unquote(guard_17)) and
        validate_field(unquote(field_name_18), values[unquote(field_name_18)], unquote(struct_module_18), unquote(is_nullable_18), unquote(guard_18)) and
        validate_field(unquote(field_name_19), values[unquote(field_name_19)], unquote(struct_module_19), unquote(is_nullable_19), unquote(guard_19))

        if is_params_valid === false do
          raise "type mismatch for constructor paramater(s) or required parameters are missing"
        end

        result = %{
            "#{unquote(field_name_1)}": values[unquote(field_name_1)],
            "#{unquote(field_name_2)}": values[unquote(field_name_2)],
            "#{unquote(field_name_3)}": values[unquote(field_name_3)],
            "#{unquote(field_name_4)}": values[unquote(field_name_4)],
            "#{unquote(field_name_5)}": values[unquote(field_name_5)],
            "#{unquote(field_name_6)}": values[unquote(field_name_6)],
            "#{unquote(field_name_7)}": values[unquote(field_name_7)],
            "#{unquote(field_name_8)}": values[unquote(field_name_8)],
            "#{unquote(field_name_9)}": values[unquote(field_name_9)],
            "#{unquote(field_name_10)}": values[unquote(field_name_10)],
            "#{unquote(field_name_11)}": values[unquote(field_name_11)],
            "#{unquote(field_name_12)}": values[unquote(field_name_12)],
            "#{unquote(field_name_13)}": values[unquote(field_name_13)],
            "#{unquote(field_name_14)}": values[unquote(field_name_14)],
            "#{unquote(field_name_15)}": values[unquote(field_name_15)],
            "#{unquote(field_name_16)}": values[unquote(field_name_16)],
            "#{unquote(field_name_17)}": values[unquote(field_name_17)],
            "#{unquote(field_name_18)}": values[unquote(field_name_18)],
            "#{unquote(field_name_19)}": values[unquote(field_name_19)]
        }
        struct(unquote(module), result)
      end


      def unquote(field_name_1)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_1))
      end

      if is_nil(unquote(struct_module_1)) === true do
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or unquote(guard_1)(value) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      else
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or is_struct(value, unquote(struct_module_1)) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      end
      def unquote(field_name_2)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_2))
      end

      if is_nil(unquote(struct_module_2)) === true do
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or unquote(guard_2)(value) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      else
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or is_struct(value, unquote(struct_module_2)) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      end
      def unquote(field_name_3)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_3))
      end

      if is_nil(unquote(struct_module_3)) === true do
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or unquote(guard_3)(value) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      else
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or is_struct(value, unquote(struct_module_3)) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      end
      def unquote(field_name_4)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_4))
      end

      if is_nil(unquote(struct_module_4)) === true do
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or unquote(guard_4)(value) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      else
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or is_struct(value, unquote(struct_module_4)) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      end
      def unquote(field_name_5)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_5))
      end

      if is_nil(unquote(struct_module_5)) === true do
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or unquote(guard_5)(value) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      else
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or is_struct(value, unquote(struct_module_5)) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      end
      def unquote(field_name_6)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_6))
      end

      if is_nil(unquote(struct_module_6)) === true do
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or unquote(guard_6)(value) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      else
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or is_struct(value, unquote(struct_module_6)) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      end
      def unquote(field_name_7)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_7))
      end

      if is_nil(unquote(struct_module_7)) === true do
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or unquote(guard_7)(value) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      else
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or is_struct(value, unquote(struct_module_7)) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      end
      def unquote(field_name_8)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_8))
      end

      if is_nil(unquote(struct_module_8)) === true do
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or unquote(guard_8)(value) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      else
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or is_struct(value, unquote(struct_module_8)) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      end
      def unquote(field_name_9)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_9))
      end

      if is_nil(unquote(struct_module_9)) === true do
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or unquote(guard_9)(value) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      else
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or is_struct(value, unquote(struct_module_9)) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      end
      def unquote(field_name_10)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_10))
      end

      if is_nil(unquote(struct_module_10)) === true do
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or unquote(guard_10)(value) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      else
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or is_struct(value, unquote(struct_module_10)) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      end
      def unquote(field_name_11)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_11))
      end

      if is_nil(unquote(struct_module_11)) === true do
        def unquote(field_name_11)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_11)) or unquote(guard_11)(value) do
          %{struct_instance | "#{unquote(field_name_11)}": value}
        end
      else
        def unquote(field_name_11)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_11)) or is_struct(value, unquote(struct_module_11)) do
          %{struct_instance | "#{unquote(field_name_11)}": value}
        end
      end
      def unquote(field_name_12)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_12))
      end

      if is_nil(unquote(struct_module_12)) === true do
        def unquote(field_name_12)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_12)) or unquote(guard_12)(value) do
          %{struct_instance | "#{unquote(field_name_12)}": value}
        end
      else
        def unquote(field_name_12)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_12)) or is_struct(value, unquote(struct_module_12)) do
          %{struct_instance | "#{unquote(field_name_12)}": value}
        end
      end
      def unquote(field_name_13)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_13))
      end

      if is_nil(unquote(struct_module_13)) === true do
        def unquote(field_name_13)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_13)) or unquote(guard_13)(value) do
          %{struct_instance | "#{unquote(field_name_13)}": value}
        end
      else
        def unquote(field_name_13)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_13)) or is_struct(value, unquote(struct_module_13)) do
          %{struct_instance | "#{unquote(field_name_13)}": value}
        end
      end
      def unquote(field_name_14)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_14))
      end

      if is_nil(unquote(struct_module_14)) === true do
        def unquote(field_name_14)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_14)) or unquote(guard_14)(value) do
          %{struct_instance | "#{unquote(field_name_14)}": value}
        end
      else
        def unquote(field_name_14)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_14)) or is_struct(value, unquote(struct_module_14)) do
          %{struct_instance | "#{unquote(field_name_14)}": value}
        end
      end
      def unquote(field_name_15)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_15))
      end

      if is_nil(unquote(struct_module_15)) === true do
        def unquote(field_name_15)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_15)) or unquote(guard_15)(value) do
          %{struct_instance | "#{unquote(field_name_15)}": value}
        end
      else
        def unquote(field_name_15)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_15)) or is_struct(value, unquote(struct_module_15)) do
          %{struct_instance | "#{unquote(field_name_15)}": value}
        end
      end
      def unquote(field_name_16)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_16))
      end

      if is_nil(unquote(struct_module_16)) === true do
        def unquote(field_name_16)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_16)) or unquote(guard_16)(value) do
          %{struct_instance | "#{unquote(field_name_16)}": value}
        end
      else
        def unquote(field_name_16)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_16)) or is_struct(value, unquote(struct_module_16)) do
          %{struct_instance | "#{unquote(field_name_16)}": value}
        end
      end
      def unquote(field_name_17)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_17))
      end

      if is_nil(unquote(struct_module_17)) === true do
        def unquote(field_name_17)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_17)) or unquote(guard_17)(value) do
          %{struct_instance | "#{unquote(field_name_17)}": value}
        end
      else
        def unquote(field_name_17)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_17)) or is_struct(value, unquote(struct_module_17)) do
          %{struct_instance | "#{unquote(field_name_17)}": value}
        end
      end
      def unquote(field_name_18)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_18))
      end

      if is_nil(unquote(struct_module_18)) === true do
        def unquote(field_name_18)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_18)) or unquote(guard_18)(value) do
          %{struct_instance | "#{unquote(field_name_18)}": value}
        end
      else
        def unquote(field_name_18)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_18)) or is_struct(value, unquote(struct_module_18)) do
          %{struct_instance | "#{unquote(field_name_18)}": value}
        end
      end
      def unquote(field_name_19)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_19))
      end

      if is_nil(unquote(struct_module_19)) === true do
        def unquote(field_name_19)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_19)) or unquote(guard_19)(value) do
          %{struct_instance | "#{unquote(field_name_19)}": value}
        end
      else
        def unquote(field_name_19)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_19)) or is_struct(value, unquote(struct_module_19)) do
          %{struct_instance | "#{unquote(field_name_19)}": value}
        end
      end
    end
  end




  @doc"""
  Generates a struct, complete with a constructor, getter and setter methods.

  Macro usage example:
      ```
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
        nullable: false,
        struct: nil
      },
      %{
        field: :hair_details,
        type_guard: :is_struct,
        default_value: %Hair{},
        nullable: true,
        struct: Hair
      })
      ```
  """
  defmacro generate_constructor(module, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9, field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19, field_20) do

    [
        field: field_name_1,
        type_guard: guard_1,
        default_value: default_1,
        nullable: is_nullable_1,
        struct: struct_module_1
    ] = field_1 |> elem(2)

    [
        field: field_name_2,
        type_guard: guard_2,
        default_value: default_2,
        nullable: is_nullable_2,
        struct: struct_module_2
    ] = field_2 |> elem(2)

    [
        field: field_name_3,
        type_guard: guard_3,
        default_value: default_3,
        nullable: is_nullable_3,
        struct: struct_module_3
    ] = field_3 |> elem(2)

    [
        field: field_name_4,
        type_guard: guard_4,
        default_value: default_4,
        nullable: is_nullable_4,
        struct: struct_module_4
    ] = field_4 |> elem(2)

    [
        field: field_name_5,
        type_guard: guard_5,
        default_value: default_5,
        nullable: is_nullable_5,
        struct: struct_module_5
    ] = field_5 |> elem(2)

    [
        field: field_name_6,
        type_guard: guard_6,
        default_value: default_6,
        nullable: is_nullable_6,
        struct: struct_module_6
    ] = field_6 |> elem(2)

    [
        field: field_name_7,
        type_guard: guard_7,
        default_value: default_7,
        nullable: is_nullable_7,
        struct: struct_module_7
    ] = field_7 |> elem(2)

    [
        field: field_name_8,
        type_guard: guard_8,
        default_value: default_8,
        nullable: is_nullable_8,
        struct: struct_module_8
    ] = field_8 |> elem(2)

    [
        field: field_name_9,
        type_guard: guard_9,
        default_value: default_9,
        nullable: is_nullable_9,
        struct: struct_module_9
    ] = field_9 |> elem(2)

    [
        field: field_name_10,
        type_guard: guard_10,
        default_value: default_10,
        nullable: is_nullable_10,
        struct: struct_module_10
    ] = field_10 |> elem(2)

    [
        field: field_name_11,
        type_guard: guard_11,
        default_value: default_11,
        nullable: is_nullable_11,
        struct: struct_module_11
    ] = field_11 |> elem(2)

    [
        field: field_name_12,
        type_guard: guard_12,
        default_value: default_12,
        nullable: is_nullable_12,
        struct: struct_module_12
    ] = field_12 |> elem(2)

    [
        field: field_name_13,
        type_guard: guard_13,
        default_value: default_13,
        nullable: is_nullable_13,
        struct: struct_module_13
    ] = field_13 |> elem(2)

    [
        field: field_name_14,
        type_guard: guard_14,
        default_value: default_14,
        nullable: is_nullable_14,
        struct: struct_module_14
    ] = field_14 |> elem(2)

    [
        field: field_name_15,
        type_guard: guard_15,
        default_value: default_15,
        nullable: is_nullable_15,
        struct: struct_module_15
    ] = field_15 |> elem(2)

    [
        field: field_name_16,
        type_guard: guard_16,
        default_value: default_16,
        nullable: is_nullable_16,
        struct: struct_module_16
    ] = field_16 |> elem(2)

    [
        field: field_name_17,
        type_guard: guard_17,
        default_value: default_17,
        nullable: is_nullable_17,
        struct: struct_module_17
    ] = field_17 |> elem(2)

    [
        field: field_name_18,
        type_guard: guard_18,
        default_value: default_18,
        nullable: is_nullable_18,
        struct: struct_module_18
    ] = field_18 |> elem(2)

    [
        field: field_name_19,
        type_guard: guard_19,
        default_value: default_19,
        nullable: is_nullable_19,
        struct: struct_module_19
    ] = field_19 |> elem(2)

    [
        field: field_name_20,
        type_guard: guard_20,
        default_value: default_20,
        nullable: is_nullable_20,
        struct: struct_module_20
    ] = field_20 |> elem(2)


    quote do
      defstruct [
        "#{unquote(field_name_1)}": unquote(default_1),
        "#{unquote(field_name_2)}": unquote(default_2),
        "#{unquote(field_name_3)}": unquote(default_3),
        "#{unquote(field_name_4)}": unquote(default_4),
        "#{unquote(field_name_5)}": unquote(default_5),
        "#{unquote(field_name_6)}": unquote(default_6),
        "#{unquote(field_name_7)}": unquote(default_7),
        "#{unquote(field_name_8)}": unquote(default_8),
        "#{unquote(field_name_9)}": unquote(default_9),
        "#{unquote(field_name_10)}": unquote(default_10),
        "#{unquote(field_name_11)}": unquote(default_11),
        "#{unquote(field_name_12)}": unquote(default_12),
        "#{unquote(field_name_13)}": unquote(default_13),
        "#{unquote(field_name_14)}": unquote(default_14),
        "#{unquote(field_name_15)}": unquote(default_15),
        "#{unquote(field_name_16)}": unquote(default_16),
        "#{unquote(field_name_17)}": unquote(default_17),
        "#{unquote(field_name_18)}": unquote(default_18),
        "#{unquote(field_name_19)}": unquote(default_19),
        "#{unquote(field_name_20)}": unquote(default_20)
      ]

      defp validate_field(field_name, field_value, struct_module, is_nullable, guard) do
        (Code.ensure_compiled(struct_module) |> elem(0) === :module and is_struct(field_value, struct_module))
            or (is_nullable === true and field_value === nil)
            or apply(Kernel, guard, [field_value])
      end

      def constructor(values) do
        is_params_valid =
        validate_field(unquote(field_name_1), values[unquote(field_name_1)], unquote(struct_module_1), unquote(is_nullable_1), unquote(guard_1)) and
        validate_field(unquote(field_name_2), values[unquote(field_name_2)], unquote(struct_module_2), unquote(is_nullable_2), unquote(guard_2)) and
        validate_field(unquote(field_name_3), values[unquote(field_name_3)], unquote(struct_module_3), unquote(is_nullable_3), unquote(guard_3)) and
        validate_field(unquote(field_name_4), values[unquote(field_name_4)], unquote(struct_module_4), unquote(is_nullable_4), unquote(guard_4)) and
        validate_field(unquote(field_name_5), values[unquote(field_name_5)], unquote(struct_module_5), unquote(is_nullable_5), unquote(guard_5)) and
        validate_field(unquote(field_name_6), values[unquote(field_name_6)], unquote(struct_module_6), unquote(is_nullable_6), unquote(guard_6)) and
        validate_field(unquote(field_name_7), values[unquote(field_name_7)], unquote(struct_module_7), unquote(is_nullable_7), unquote(guard_7)) and
        validate_field(unquote(field_name_8), values[unquote(field_name_8)], unquote(struct_module_8), unquote(is_nullable_8), unquote(guard_8)) and
        validate_field(unquote(field_name_9), values[unquote(field_name_9)], unquote(struct_module_9), unquote(is_nullable_9), unquote(guard_9)) and
        validate_field(unquote(field_name_10), values[unquote(field_name_10)], unquote(struct_module_10), unquote(is_nullable_10), unquote(guard_10)) and
        validate_field(unquote(field_name_11), values[unquote(field_name_11)], unquote(struct_module_11), unquote(is_nullable_11), unquote(guard_11)) and
        validate_field(unquote(field_name_12), values[unquote(field_name_12)], unquote(struct_module_12), unquote(is_nullable_12), unquote(guard_12)) and
        validate_field(unquote(field_name_13), values[unquote(field_name_13)], unquote(struct_module_13), unquote(is_nullable_13), unquote(guard_13)) and
        validate_field(unquote(field_name_14), values[unquote(field_name_14)], unquote(struct_module_14), unquote(is_nullable_14), unquote(guard_14)) and
        validate_field(unquote(field_name_15), values[unquote(field_name_15)], unquote(struct_module_15), unquote(is_nullable_15), unquote(guard_15)) and
        validate_field(unquote(field_name_16), values[unquote(field_name_16)], unquote(struct_module_16), unquote(is_nullable_16), unquote(guard_16)) and
        validate_field(unquote(field_name_17), values[unquote(field_name_17)], unquote(struct_module_17), unquote(is_nullable_17), unquote(guard_17)) and
        validate_field(unquote(field_name_18), values[unquote(field_name_18)], unquote(struct_module_18), unquote(is_nullable_18), unquote(guard_18)) and
        validate_field(unquote(field_name_19), values[unquote(field_name_19)], unquote(struct_module_19), unquote(is_nullable_19), unquote(guard_19)) and
        validate_field(unquote(field_name_20), values[unquote(field_name_20)], unquote(struct_module_20), unquote(is_nullable_20), unquote(guard_20))

        if is_params_valid === false do
          raise "type mismatch for constructor paramater(s) or required parameters are missing"
        end

        result = %{
            "#{unquote(field_name_1)}": values[unquote(field_name_1)],
            "#{unquote(field_name_2)}": values[unquote(field_name_2)],
            "#{unquote(field_name_3)}": values[unquote(field_name_3)],
            "#{unquote(field_name_4)}": values[unquote(field_name_4)],
            "#{unquote(field_name_5)}": values[unquote(field_name_5)],
            "#{unquote(field_name_6)}": values[unquote(field_name_6)],
            "#{unquote(field_name_7)}": values[unquote(field_name_7)],
            "#{unquote(field_name_8)}": values[unquote(field_name_8)],
            "#{unquote(field_name_9)}": values[unquote(field_name_9)],
            "#{unquote(field_name_10)}": values[unquote(field_name_10)],
            "#{unquote(field_name_11)}": values[unquote(field_name_11)],
            "#{unquote(field_name_12)}": values[unquote(field_name_12)],
            "#{unquote(field_name_13)}": values[unquote(field_name_13)],
            "#{unquote(field_name_14)}": values[unquote(field_name_14)],
            "#{unquote(field_name_15)}": values[unquote(field_name_15)],
            "#{unquote(field_name_16)}": values[unquote(field_name_16)],
            "#{unquote(field_name_17)}": values[unquote(field_name_17)],
            "#{unquote(field_name_18)}": values[unquote(field_name_18)],
            "#{unquote(field_name_19)}": values[unquote(field_name_19)],
            "#{unquote(field_name_20)}": values[unquote(field_name_20)]
        }
        struct(unquote(module), result)
      end


      def unquote(field_name_1)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_1))
      end

      if is_nil(unquote(struct_module_1)) === true do
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or unquote(guard_1)(value) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      else
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or is_struct(value, unquote(struct_module_1)) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      end
      def unquote(field_name_2)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_2))
      end

      if is_nil(unquote(struct_module_2)) === true do
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or unquote(guard_2)(value) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      else
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or is_struct(value, unquote(struct_module_2)) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      end
      def unquote(field_name_3)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_3))
      end

      if is_nil(unquote(struct_module_3)) === true do
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or unquote(guard_3)(value) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      else
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or is_struct(value, unquote(struct_module_3)) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      end
      def unquote(field_name_4)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_4))
      end

      if is_nil(unquote(struct_module_4)) === true do
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or unquote(guard_4)(value) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      else
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or is_struct(value, unquote(struct_module_4)) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      end
      def unquote(field_name_5)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_5))
      end

      if is_nil(unquote(struct_module_5)) === true do
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or unquote(guard_5)(value) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      else
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or is_struct(value, unquote(struct_module_5)) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      end
      def unquote(field_name_6)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_6))
      end

      if is_nil(unquote(struct_module_6)) === true do
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or unquote(guard_6)(value) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      else
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or is_struct(value, unquote(struct_module_6)) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      end
      def unquote(field_name_7)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_7))
      end

      if is_nil(unquote(struct_module_7)) === true do
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or unquote(guard_7)(value) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      else
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or is_struct(value, unquote(struct_module_7)) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      end
      def unquote(field_name_8)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_8))
      end

      if is_nil(unquote(struct_module_8)) === true do
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or unquote(guard_8)(value) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      else
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or is_struct(value, unquote(struct_module_8)) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      end
      def unquote(field_name_9)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_9))
      end

      if is_nil(unquote(struct_module_9)) === true do
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or unquote(guard_9)(value) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      else
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or is_struct(value, unquote(struct_module_9)) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      end
      def unquote(field_name_10)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_10))
      end

      if is_nil(unquote(struct_module_10)) === true do
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or unquote(guard_10)(value) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      else
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or is_struct(value, unquote(struct_module_10)) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      end
      def unquote(field_name_11)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_11))
      end

      if is_nil(unquote(struct_module_11)) === true do
        def unquote(field_name_11)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_11)) or unquote(guard_11)(value) do
          %{struct_instance | "#{unquote(field_name_11)}": value}
        end
      else
        def unquote(field_name_11)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_11)) or is_struct(value, unquote(struct_module_11)) do
          %{struct_instance | "#{unquote(field_name_11)}": value}
        end
      end
      def unquote(field_name_12)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_12))
      end

      if is_nil(unquote(struct_module_12)) === true do
        def unquote(field_name_12)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_12)) or unquote(guard_12)(value) do
          %{struct_instance | "#{unquote(field_name_12)}": value}
        end
      else
        def unquote(field_name_12)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_12)) or is_struct(value, unquote(struct_module_12)) do
          %{struct_instance | "#{unquote(field_name_12)}": value}
        end
      end
      def unquote(field_name_13)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_13))
      end

      if is_nil(unquote(struct_module_13)) === true do
        def unquote(field_name_13)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_13)) or unquote(guard_13)(value) do
          %{struct_instance | "#{unquote(field_name_13)}": value}
        end
      else
        def unquote(field_name_13)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_13)) or is_struct(value, unquote(struct_module_13)) do
          %{struct_instance | "#{unquote(field_name_13)}": value}
        end
      end
      def unquote(field_name_14)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_14))
      end

      if is_nil(unquote(struct_module_14)) === true do
        def unquote(field_name_14)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_14)) or unquote(guard_14)(value) do
          %{struct_instance | "#{unquote(field_name_14)}": value}
        end
      else
        def unquote(field_name_14)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_14)) or is_struct(value, unquote(struct_module_14)) do
          %{struct_instance | "#{unquote(field_name_14)}": value}
        end
      end
      def unquote(field_name_15)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_15))
      end

      if is_nil(unquote(struct_module_15)) === true do
        def unquote(field_name_15)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_15)) or unquote(guard_15)(value) do
          %{struct_instance | "#{unquote(field_name_15)}": value}
        end
      else
        def unquote(field_name_15)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_15)) or is_struct(value, unquote(struct_module_15)) do
          %{struct_instance | "#{unquote(field_name_15)}": value}
        end
      end
      def unquote(field_name_16)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_16))
      end

      if is_nil(unquote(struct_module_16)) === true do
        def unquote(field_name_16)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_16)) or unquote(guard_16)(value) do
          %{struct_instance | "#{unquote(field_name_16)}": value}
        end
      else
        def unquote(field_name_16)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_16)) or is_struct(value, unquote(struct_module_16)) do
          %{struct_instance | "#{unquote(field_name_16)}": value}
        end
      end
      def unquote(field_name_17)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_17))
      end

      if is_nil(unquote(struct_module_17)) === true do
        def unquote(field_name_17)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_17)) or unquote(guard_17)(value) do
          %{struct_instance | "#{unquote(field_name_17)}": value}
        end
      else
        def unquote(field_name_17)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_17)) or is_struct(value, unquote(struct_module_17)) do
          %{struct_instance | "#{unquote(field_name_17)}": value}
        end
      end
      def unquote(field_name_18)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_18))
      end

      if is_nil(unquote(struct_module_18)) === true do
        def unquote(field_name_18)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_18)) or unquote(guard_18)(value) do
          %{struct_instance | "#{unquote(field_name_18)}": value}
        end
      else
        def unquote(field_name_18)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_18)) or is_struct(value, unquote(struct_module_18)) do
          %{struct_instance | "#{unquote(field_name_18)}": value}
        end
      end
      def unquote(field_name_19)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_19))
      end

      if is_nil(unquote(struct_module_19)) === true do
        def unquote(field_name_19)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_19)) or unquote(guard_19)(value) do
          %{struct_instance | "#{unquote(field_name_19)}": value}
        end
      else
        def unquote(field_name_19)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_19)) or is_struct(value, unquote(struct_module_19)) do
          %{struct_instance | "#{unquote(field_name_19)}": value}
        end
      end
      def unquote(field_name_20)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_20))
      end

      if is_nil(unquote(struct_module_20)) === true do
        def unquote(field_name_20)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_20)) or unquote(guard_20)(value) do
          %{struct_instance | "#{unquote(field_name_20)}": value}
        end
      else
        def unquote(field_name_20)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_20)) or is_struct(value, unquote(struct_module_20)) do
          %{struct_instance | "#{unquote(field_name_20)}": value}
        end
      end
    end
  end




  @doc"""
  Generates a struct, complete with a constructor, getter and setter methods.

  Macro usage example:
      ```
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
        nullable: false,
        struct: nil
      },
      %{
        field: :hair_details,
        type_guard: :is_struct,
        default_value: %Hair{},
        nullable: true,
        struct: Hair
      })
      ```
  """
  defmacro generate_constructor(module, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9, field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19, field_20, field_21) do

    [
        field: field_name_1,
        type_guard: guard_1,
        default_value: default_1,
        nullable: is_nullable_1,
        struct: struct_module_1
    ] = field_1 |> elem(2)

    [
        field: field_name_2,
        type_guard: guard_2,
        default_value: default_2,
        nullable: is_nullable_2,
        struct: struct_module_2
    ] = field_2 |> elem(2)

    [
        field: field_name_3,
        type_guard: guard_3,
        default_value: default_3,
        nullable: is_nullable_3,
        struct: struct_module_3
    ] = field_3 |> elem(2)

    [
        field: field_name_4,
        type_guard: guard_4,
        default_value: default_4,
        nullable: is_nullable_4,
        struct: struct_module_4
    ] = field_4 |> elem(2)

    [
        field: field_name_5,
        type_guard: guard_5,
        default_value: default_5,
        nullable: is_nullable_5,
        struct: struct_module_5
    ] = field_5 |> elem(2)

    [
        field: field_name_6,
        type_guard: guard_6,
        default_value: default_6,
        nullable: is_nullable_6,
        struct: struct_module_6
    ] = field_6 |> elem(2)

    [
        field: field_name_7,
        type_guard: guard_7,
        default_value: default_7,
        nullable: is_nullable_7,
        struct: struct_module_7
    ] = field_7 |> elem(2)

    [
        field: field_name_8,
        type_guard: guard_8,
        default_value: default_8,
        nullable: is_nullable_8,
        struct: struct_module_8
    ] = field_8 |> elem(2)

    [
        field: field_name_9,
        type_guard: guard_9,
        default_value: default_9,
        nullable: is_nullable_9,
        struct: struct_module_9
    ] = field_9 |> elem(2)

    [
        field: field_name_10,
        type_guard: guard_10,
        default_value: default_10,
        nullable: is_nullable_10,
        struct: struct_module_10
    ] = field_10 |> elem(2)

    [
        field: field_name_11,
        type_guard: guard_11,
        default_value: default_11,
        nullable: is_nullable_11,
        struct: struct_module_11
    ] = field_11 |> elem(2)

    [
        field: field_name_12,
        type_guard: guard_12,
        default_value: default_12,
        nullable: is_nullable_12,
        struct: struct_module_12
    ] = field_12 |> elem(2)

    [
        field: field_name_13,
        type_guard: guard_13,
        default_value: default_13,
        nullable: is_nullable_13,
        struct: struct_module_13
    ] = field_13 |> elem(2)

    [
        field: field_name_14,
        type_guard: guard_14,
        default_value: default_14,
        nullable: is_nullable_14,
        struct: struct_module_14
    ] = field_14 |> elem(2)

    [
        field: field_name_15,
        type_guard: guard_15,
        default_value: default_15,
        nullable: is_nullable_15,
        struct: struct_module_15
    ] = field_15 |> elem(2)

    [
        field: field_name_16,
        type_guard: guard_16,
        default_value: default_16,
        nullable: is_nullable_16,
        struct: struct_module_16
    ] = field_16 |> elem(2)

    [
        field: field_name_17,
        type_guard: guard_17,
        default_value: default_17,
        nullable: is_nullable_17,
        struct: struct_module_17
    ] = field_17 |> elem(2)

    [
        field: field_name_18,
        type_guard: guard_18,
        default_value: default_18,
        nullable: is_nullable_18,
        struct: struct_module_18
    ] = field_18 |> elem(2)

    [
        field: field_name_19,
        type_guard: guard_19,
        default_value: default_19,
        nullable: is_nullable_19,
        struct: struct_module_19
    ] = field_19 |> elem(2)

    [
        field: field_name_20,
        type_guard: guard_20,
        default_value: default_20,
        nullable: is_nullable_20,
        struct: struct_module_20
    ] = field_20 |> elem(2)

    [
        field: field_name_21,
        type_guard: guard_21,
        default_value: default_21,
        nullable: is_nullable_21,
        struct: struct_module_21
    ] = field_21 |> elem(2)


    quote do
      defstruct [
        "#{unquote(field_name_1)}": unquote(default_1),
        "#{unquote(field_name_2)}": unquote(default_2),
        "#{unquote(field_name_3)}": unquote(default_3),
        "#{unquote(field_name_4)}": unquote(default_4),
        "#{unquote(field_name_5)}": unquote(default_5),
        "#{unquote(field_name_6)}": unquote(default_6),
        "#{unquote(field_name_7)}": unquote(default_7),
        "#{unquote(field_name_8)}": unquote(default_8),
        "#{unquote(field_name_9)}": unquote(default_9),
        "#{unquote(field_name_10)}": unquote(default_10),
        "#{unquote(field_name_11)}": unquote(default_11),
        "#{unquote(field_name_12)}": unquote(default_12),
        "#{unquote(field_name_13)}": unquote(default_13),
        "#{unquote(field_name_14)}": unquote(default_14),
        "#{unquote(field_name_15)}": unquote(default_15),
        "#{unquote(field_name_16)}": unquote(default_16),
        "#{unquote(field_name_17)}": unquote(default_17),
        "#{unquote(field_name_18)}": unquote(default_18),
        "#{unquote(field_name_19)}": unquote(default_19),
        "#{unquote(field_name_20)}": unquote(default_20),
        "#{unquote(field_name_21)}": unquote(default_21)
      ]

      defp validate_field(field_name, field_value, struct_module, is_nullable, guard) do
        (Code.ensure_compiled(struct_module) |> elem(0) === :module and is_struct(field_value, struct_module))
            or (is_nullable === true and field_value === nil)
            or apply(Kernel, guard, [field_value])
      end

      def constructor(values) do
        is_params_valid =
        validate_field(unquote(field_name_1), values[unquote(field_name_1)], unquote(struct_module_1), unquote(is_nullable_1), unquote(guard_1)) and
        validate_field(unquote(field_name_2), values[unquote(field_name_2)], unquote(struct_module_2), unquote(is_nullable_2), unquote(guard_2)) and
        validate_field(unquote(field_name_3), values[unquote(field_name_3)], unquote(struct_module_3), unquote(is_nullable_3), unquote(guard_3)) and
        validate_field(unquote(field_name_4), values[unquote(field_name_4)], unquote(struct_module_4), unquote(is_nullable_4), unquote(guard_4)) and
        validate_field(unquote(field_name_5), values[unquote(field_name_5)], unquote(struct_module_5), unquote(is_nullable_5), unquote(guard_5)) and
        validate_field(unquote(field_name_6), values[unquote(field_name_6)], unquote(struct_module_6), unquote(is_nullable_6), unquote(guard_6)) and
        validate_field(unquote(field_name_7), values[unquote(field_name_7)], unquote(struct_module_7), unquote(is_nullable_7), unquote(guard_7)) and
        validate_field(unquote(field_name_8), values[unquote(field_name_8)], unquote(struct_module_8), unquote(is_nullable_8), unquote(guard_8)) and
        validate_field(unquote(field_name_9), values[unquote(field_name_9)], unquote(struct_module_9), unquote(is_nullable_9), unquote(guard_9)) and
        validate_field(unquote(field_name_10), values[unquote(field_name_10)], unquote(struct_module_10), unquote(is_nullable_10), unquote(guard_10)) and
        validate_field(unquote(field_name_11), values[unquote(field_name_11)], unquote(struct_module_11), unquote(is_nullable_11), unquote(guard_11)) and
        validate_field(unquote(field_name_12), values[unquote(field_name_12)], unquote(struct_module_12), unquote(is_nullable_12), unquote(guard_12)) and
        validate_field(unquote(field_name_13), values[unquote(field_name_13)], unquote(struct_module_13), unquote(is_nullable_13), unquote(guard_13)) and
        validate_field(unquote(field_name_14), values[unquote(field_name_14)], unquote(struct_module_14), unquote(is_nullable_14), unquote(guard_14)) and
        validate_field(unquote(field_name_15), values[unquote(field_name_15)], unquote(struct_module_15), unquote(is_nullable_15), unquote(guard_15)) and
        validate_field(unquote(field_name_16), values[unquote(field_name_16)], unquote(struct_module_16), unquote(is_nullable_16), unquote(guard_16)) and
        validate_field(unquote(field_name_17), values[unquote(field_name_17)], unquote(struct_module_17), unquote(is_nullable_17), unquote(guard_17)) and
        validate_field(unquote(field_name_18), values[unquote(field_name_18)], unquote(struct_module_18), unquote(is_nullable_18), unquote(guard_18)) and
        validate_field(unquote(field_name_19), values[unquote(field_name_19)], unquote(struct_module_19), unquote(is_nullable_19), unquote(guard_19)) and
        validate_field(unquote(field_name_20), values[unquote(field_name_20)], unquote(struct_module_20), unquote(is_nullable_20), unquote(guard_20)) and
        validate_field(unquote(field_name_21), values[unquote(field_name_21)], unquote(struct_module_21), unquote(is_nullable_21), unquote(guard_21))

        if is_params_valid === false do
          raise "type mismatch for constructor paramater(s) or required parameters are missing"
        end

        result = %{
            "#{unquote(field_name_1)}": values[unquote(field_name_1)],
            "#{unquote(field_name_2)}": values[unquote(field_name_2)],
            "#{unquote(field_name_3)}": values[unquote(field_name_3)],
            "#{unquote(field_name_4)}": values[unquote(field_name_4)],
            "#{unquote(field_name_5)}": values[unquote(field_name_5)],
            "#{unquote(field_name_6)}": values[unquote(field_name_6)],
            "#{unquote(field_name_7)}": values[unquote(field_name_7)],
            "#{unquote(field_name_8)}": values[unquote(field_name_8)],
            "#{unquote(field_name_9)}": values[unquote(field_name_9)],
            "#{unquote(field_name_10)}": values[unquote(field_name_10)],
            "#{unquote(field_name_11)}": values[unquote(field_name_11)],
            "#{unquote(field_name_12)}": values[unquote(field_name_12)],
            "#{unquote(field_name_13)}": values[unquote(field_name_13)],
            "#{unquote(field_name_14)}": values[unquote(field_name_14)],
            "#{unquote(field_name_15)}": values[unquote(field_name_15)],
            "#{unquote(field_name_16)}": values[unquote(field_name_16)],
            "#{unquote(field_name_17)}": values[unquote(field_name_17)],
            "#{unquote(field_name_18)}": values[unquote(field_name_18)],
            "#{unquote(field_name_19)}": values[unquote(field_name_19)],
            "#{unquote(field_name_20)}": values[unquote(field_name_20)],
            "#{unquote(field_name_21)}": values[unquote(field_name_21)]
        }
        struct(unquote(module), result)
      end


      def unquote(field_name_1)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_1))
      end

      if is_nil(unquote(struct_module_1)) === true do
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or unquote(guard_1)(value) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      else
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or is_struct(value, unquote(struct_module_1)) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      end
      def unquote(field_name_2)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_2))
      end

      if is_nil(unquote(struct_module_2)) === true do
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or unquote(guard_2)(value) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      else
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or is_struct(value, unquote(struct_module_2)) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      end
      def unquote(field_name_3)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_3))
      end

      if is_nil(unquote(struct_module_3)) === true do
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or unquote(guard_3)(value) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      else
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or is_struct(value, unquote(struct_module_3)) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      end
      def unquote(field_name_4)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_4))
      end

      if is_nil(unquote(struct_module_4)) === true do
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or unquote(guard_4)(value) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      else
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or is_struct(value, unquote(struct_module_4)) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      end
      def unquote(field_name_5)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_5))
      end

      if is_nil(unquote(struct_module_5)) === true do
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or unquote(guard_5)(value) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      else
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or is_struct(value, unquote(struct_module_5)) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      end
      def unquote(field_name_6)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_6))
      end

      if is_nil(unquote(struct_module_6)) === true do
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or unquote(guard_6)(value) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      else
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or is_struct(value, unquote(struct_module_6)) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      end
      def unquote(field_name_7)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_7))
      end

      if is_nil(unquote(struct_module_7)) === true do
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or unquote(guard_7)(value) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      else
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or is_struct(value, unquote(struct_module_7)) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      end
      def unquote(field_name_8)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_8))
      end

      if is_nil(unquote(struct_module_8)) === true do
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or unquote(guard_8)(value) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      else
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or is_struct(value, unquote(struct_module_8)) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      end
      def unquote(field_name_9)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_9))
      end

      if is_nil(unquote(struct_module_9)) === true do
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or unquote(guard_9)(value) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      else
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or is_struct(value, unquote(struct_module_9)) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      end
      def unquote(field_name_10)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_10))
      end

      if is_nil(unquote(struct_module_10)) === true do
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or unquote(guard_10)(value) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      else
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or is_struct(value, unquote(struct_module_10)) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      end
      def unquote(field_name_11)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_11))
      end

      if is_nil(unquote(struct_module_11)) === true do
        def unquote(field_name_11)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_11)) or unquote(guard_11)(value) do
          %{struct_instance | "#{unquote(field_name_11)}": value}
        end
      else
        def unquote(field_name_11)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_11)) or is_struct(value, unquote(struct_module_11)) do
          %{struct_instance | "#{unquote(field_name_11)}": value}
        end
      end
      def unquote(field_name_12)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_12))
      end

      if is_nil(unquote(struct_module_12)) === true do
        def unquote(field_name_12)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_12)) or unquote(guard_12)(value) do
          %{struct_instance | "#{unquote(field_name_12)}": value}
        end
      else
        def unquote(field_name_12)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_12)) or is_struct(value, unquote(struct_module_12)) do
          %{struct_instance | "#{unquote(field_name_12)}": value}
        end
      end
      def unquote(field_name_13)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_13))
      end

      if is_nil(unquote(struct_module_13)) === true do
        def unquote(field_name_13)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_13)) or unquote(guard_13)(value) do
          %{struct_instance | "#{unquote(field_name_13)}": value}
        end
      else
        def unquote(field_name_13)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_13)) or is_struct(value, unquote(struct_module_13)) do
          %{struct_instance | "#{unquote(field_name_13)}": value}
        end
      end
      def unquote(field_name_14)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_14))
      end

      if is_nil(unquote(struct_module_14)) === true do
        def unquote(field_name_14)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_14)) or unquote(guard_14)(value) do
          %{struct_instance | "#{unquote(field_name_14)}": value}
        end
      else
        def unquote(field_name_14)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_14)) or is_struct(value, unquote(struct_module_14)) do
          %{struct_instance | "#{unquote(field_name_14)}": value}
        end
      end
      def unquote(field_name_15)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_15))
      end

      if is_nil(unquote(struct_module_15)) === true do
        def unquote(field_name_15)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_15)) or unquote(guard_15)(value) do
          %{struct_instance | "#{unquote(field_name_15)}": value}
        end
      else
        def unquote(field_name_15)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_15)) or is_struct(value, unquote(struct_module_15)) do
          %{struct_instance | "#{unquote(field_name_15)}": value}
        end
      end
      def unquote(field_name_16)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_16))
      end

      if is_nil(unquote(struct_module_16)) === true do
        def unquote(field_name_16)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_16)) or unquote(guard_16)(value) do
          %{struct_instance | "#{unquote(field_name_16)}": value}
        end
      else
        def unquote(field_name_16)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_16)) or is_struct(value, unquote(struct_module_16)) do
          %{struct_instance | "#{unquote(field_name_16)}": value}
        end
      end
      def unquote(field_name_17)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_17))
      end

      if is_nil(unquote(struct_module_17)) === true do
        def unquote(field_name_17)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_17)) or unquote(guard_17)(value) do
          %{struct_instance | "#{unquote(field_name_17)}": value}
        end
      else
        def unquote(field_name_17)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_17)) or is_struct(value, unquote(struct_module_17)) do
          %{struct_instance | "#{unquote(field_name_17)}": value}
        end
      end
      def unquote(field_name_18)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_18))
      end

      if is_nil(unquote(struct_module_18)) === true do
        def unquote(field_name_18)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_18)) or unquote(guard_18)(value) do
          %{struct_instance | "#{unquote(field_name_18)}": value}
        end
      else
        def unquote(field_name_18)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_18)) or is_struct(value, unquote(struct_module_18)) do
          %{struct_instance | "#{unquote(field_name_18)}": value}
        end
      end
      def unquote(field_name_19)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_19))
      end

      if is_nil(unquote(struct_module_19)) === true do
        def unquote(field_name_19)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_19)) or unquote(guard_19)(value) do
          %{struct_instance | "#{unquote(field_name_19)}": value}
        end
      else
        def unquote(field_name_19)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_19)) or is_struct(value, unquote(struct_module_19)) do
          %{struct_instance | "#{unquote(field_name_19)}": value}
        end
      end
      def unquote(field_name_20)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_20))
      end

      if is_nil(unquote(struct_module_20)) === true do
        def unquote(field_name_20)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_20)) or unquote(guard_20)(value) do
          %{struct_instance | "#{unquote(field_name_20)}": value}
        end
      else
        def unquote(field_name_20)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_20)) or is_struct(value, unquote(struct_module_20)) do
          %{struct_instance | "#{unquote(field_name_20)}": value}
        end
      end
      def unquote(field_name_21)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_21))
      end

      if is_nil(unquote(struct_module_21)) === true do
        def unquote(field_name_21)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_21)) or unquote(guard_21)(value) do
          %{struct_instance | "#{unquote(field_name_21)}": value}
        end
      else
        def unquote(field_name_21)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_21)) or is_struct(value, unquote(struct_module_21)) do
          %{struct_instance | "#{unquote(field_name_21)}": value}
        end
      end
    end
  end




  @doc"""
  Generates a struct, complete with a constructor, getter and setter methods.

  Macro usage example:
      ```
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
        nullable: false,
        struct: nil
      },
      %{
        field: :hair_details,
        type_guard: :is_struct,
        default_value: %Hair{},
        nullable: true,
        struct: Hair
      })
      ```
  """
  defmacro generate_constructor(module, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9, field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19, field_20, field_21, field_22) do

    [
        field: field_name_1,
        type_guard: guard_1,
        default_value: default_1,
        nullable: is_nullable_1,
        struct: struct_module_1
    ] = field_1 |> elem(2)

    [
        field: field_name_2,
        type_guard: guard_2,
        default_value: default_2,
        nullable: is_nullable_2,
        struct: struct_module_2
    ] = field_2 |> elem(2)

    [
        field: field_name_3,
        type_guard: guard_3,
        default_value: default_3,
        nullable: is_nullable_3,
        struct: struct_module_3
    ] = field_3 |> elem(2)

    [
        field: field_name_4,
        type_guard: guard_4,
        default_value: default_4,
        nullable: is_nullable_4,
        struct: struct_module_4
    ] = field_4 |> elem(2)

    [
        field: field_name_5,
        type_guard: guard_5,
        default_value: default_5,
        nullable: is_nullable_5,
        struct: struct_module_5
    ] = field_5 |> elem(2)

    [
        field: field_name_6,
        type_guard: guard_6,
        default_value: default_6,
        nullable: is_nullable_6,
        struct: struct_module_6
    ] = field_6 |> elem(2)

    [
        field: field_name_7,
        type_guard: guard_7,
        default_value: default_7,
        nullable: is_nullable_7,
        struct: struct_module_7
    ] = field_7 |> elem(2)

    [
        field: field_name_8,
        type_guard: guard_8,
        default_value: default_8,
        nullable: is_nullable_8,
        struct: struct_module_8
    ] = field_8 |> elem(2)

    [
        field: field_name_9,
        type_guard: guard_9,
        default_value: default_9,
        nullable: is_nullable_9,
        struct: struct_module_9
    ] = field_9 |> elem(2)

    [
        field: field_name_10,
        type_guard: guard_10,
        default_value: default_10,
        nullable: is_nullable_10,
        struct: struct_module_10
    ] = field_10 |> elem(2)

    [
        field: field_name_11,
        type_guard: guard_11,
        default_value: default_11,
        nullable: is_nullable_11,
        struct: struct_module_11
    ] = field_11 |> elem(2)

    [
        field: field_name_12,
        type_guard: guard_12,
        default_value: default_12,
        nullable: is_nullable_12,
        struct: struct_module_12
    ] = field_12 |> elem(2)

    [
        field: field_name_13,
        type_guard: guard_13,
        default_value: default_13,
        nullable: is_nullable_13,
        struct: struct_module_13
    ] = field_13 |> elem(2)

    [
        field: field_name_14,
        type_guard: guard_14,
        default_value: default_14,
        nullable: is_nullable_14,
        struct: struct_module_14
    ] = field_14 |> elem(2)

    [
        field: field_name_15,
        type_guard: guard_15,
        default_value: default_15,
        nullable: is_nullable_15,
        struct: struct_module_15
    ] = field_15 |> elem(2)

    [
        field: field_name_16,
        type_guard: guard_16,
        default_value: default_16,
        nullable: is_nullable_16,
        struct: struct_module_16
    ] = field_16 |> elem(2)

    [
        field: field_name_17,
        type_guard: guard_17,
        default_value: default_17,
        nullable: is_nullable_17,
        struct: struct_module_17
    ] = field_17 |> elem(2)

    [
        field: field_name_18,
        type_guard: guard_18,
        default_value: default_18,
        nullable: is_nullable_18,
        struct: struct_module_18
    ] = field_18 |> elem(2)

    [
        field: field_name_19,
        type_guard: guard_19,
        default_value: default_19,
        nullable: is_nullable_19,
        struct: struct_module_19
    ] = field_19 |> elem(2)

    [
        field: field_name_20,
        type_guard: guard_20,
        default_value: default_20,
        nullable: is_nullable_20,
        struct: struct_module_20
    ] = field_20 |> elem(2)

    [
        field: field_name_21,
        type_guard: guard_21,
        default_value: default_21,
        nullable: is_nullable_21,
        struct: struct_module_21
    ] = field_21 |> elem(2)

    [
        field: field_name_22,
        type_guard: guard_22,
        default_value: default_22,
        nullable: is_nullable_22,
        struct: struct_module_22
    ] = field_22 |> elem(2)


    quote do
      defstruct [
        "#{unquote(field_name_1)}": unquote(default_1),
        "#{unquote(field_name_2)}": unquote(default_2),
        "#{unquote(field_name_3)}": unquote(default_3),
        "#{unquote(field_name_4)}": unquote(default_4),
        "#{unquote(field_name_5)}": unquote(default_5),
        "#{unquote(field_name_6)}": unquote(default_6),
        "#{unquote(field_name_7)}": unquote(default_7),
        "#{unquote(field_name_8)}": unquote(default_8),
        "#{unquote(field_name_9)}": unquote(default_9),
        "#{unquote(field_name_10)}": unquote(default_10),
        "#{unquote(field_name_11)}": unquote(default_11),
        "#{unquote(field_name_12)}": unquote(default_12),
        "#{unquote(field_name_13)}": unquote(default_13),
        "#{unquote(field_name_14)}": unquote(default_14),
        "#{unquote(field_name_15)}": unquote(default_15),
        "#{unquote(field_name_16)}": unquote(default_16),
        "#{unquote(field_name_17)}": unquote(default_17),
        "#{unquote(field_name_18)}": unquote(default_18),
        "#{unquote(field_name_19)}": unquote(default_19),
        "#{unquote(field_name_20)}": unquote(default_20),
        "#{unquote(field_name_21)}": unquote(default_21),
        "#{unquote(field_name_22)}": unquote(default_22)
      ]

      defp validate_field(field_name, field_value, struct_module, is_nullable, guard) do
        (Code.ensure_compiled(struct_module) |> elem(0) === :module and is_struct(field_value, struct_module))
            or (is_nullable === true and field_value === nil)
            or apply(Kernel, guard, [field_value])
      end

      def constructor(values) do
        is_params_valid =
        validate_field(unquote(field_name_1), values[unquote(field_name_1)], unquote(struct_module_1), unquote(is_nullable_1), unquote(guard_1)) and
        validate_field(unquote(field_name_2), values[unquote(field_name_2)], unquote(struct_module_2), unquote(is_nullable_2), unquote(guard_2)) and
        validate_field(unquote(field_name_3), values[unquote(field_name_3)], unquote(struct_module_3), unquote(is_nullable_3), unquote(guard_3)) and
        validate_field(unquote(field_name_4), values[unquote(field_name_4)], unquote(struct_module_4), unquote(is_nullable_4), unquote(guard_4)) and
        validate_field(unquote(field_name_5), values[unquote(field_name_5)], unquote(struct_module_5), unquote(is_nullable_5), unquote(guard_5)) and
        validate_field(unquote(field_name_6), values[unquote(field_name_6)], unquote(struct_module_6), unquote(is_nullable_6), unquote(guard_6)) and
        validate_field(unquote(field_name_7), values[unquote(field_name_7)], unquote(struct_module_7), unquote(is_nullable_7), unquote(guard_7)) and
        validate_field(unquote(field_name_8), values[unquote(field_name_8)], unquote(struct_module_8), unquote(is_nullable_8), unquote(guard_8)) and
        validate_field(unquote(field_name_9), values[unquote(field_name_9)], unquote(struct_module_9), unquote(is_nullable_9), unquote(guard_9)) and
        validate_field(unquote(field_name_10), values[unquote(field_name_10)], unquote(struct_module_10), unquote(is_nullable_10), unquote(guard_10)) and
        validate_field(unquote(field_name_11), values[unquote(field_name_11)], unquote(struct_module_11), unquote(is_nullable_11), unquote(guard_11)) and
        validate_field(unquote(field_name_12), values[unquote(field_name_12)], unquote(struct_module_12), unquote(is_nullable_12), unquote(guard_12)) and
        validate_field(unquote(field_name_13), values[unquote(field_name_13)], unquote(struct_module_13), unquote(is_nullable_13), unquote(guard_13)) and
        validate_field(unquote(field_name_14), values[unquote(field_name_14)], unquote(struct_module_14), unquote(is_nullable_14), unquote(guard_14)) and
        validate_field(unquote(field_name_15), values[unquote(field_name_15)], unquote(struct_module_15), unquote(is_nullable_15), unquote(guard_15)) and
        validate_field(unquote(field_name_16), values[unquote(field_name_16)], unquote(struct_module_16), unquote(is_nullable_16), unquote(guard_16)) and
        validate_field(unquote(field_name_17), values[unquote(field_name_17)], unquote(struct_module_17), unquote(is_nullable_17), unquote(guard_17)) and
        validate_field(unquote(field_name_18), values[unquote(field_name_18)], unquote(struct_module_18), unquote(is_nullable_18), unquote(guard_18)) and
        validate_field(unquote(field_name_19), values[unquote(field_name_19)], unquote(struct_module_19), unquote(is_nullable_19), unquote(guard_19)) and
        validate_field(unquote(field_name_20), values[unquote(field_name_20)], unquote(struct_module_20), unquote(is_nullable_20), unquote(guard_20)) and
        validate_field(unquote(field_name_21), values[unquote(field_name_21)], unquote(struct_module_21), unquote(is_nullable_21), unquote(guard_21)) and
        validate_field(unquote(field_name_22), values[unquote(field_name_22)], unquote(struct_module_22), unquote(is_nullable_22), unquote(guard_22))

        if is_params_valid === false do
          raise "type mismatch for constructor paramater(s) or required parameters are missing"
        end

        result = %{
            "#{unquote(field_name_1)}": values[unquote(field_name_1)],
            "#{unquote(field_name_2)}": values[unquote(field_name_2)],
            "#{unquote(field_name_3)}": values[unquote(field_name_3)],
            "#{unquote(field_name_4)}": values[unquote(field_name_4)],
            "#{unquote(field_name_5)}": values[unquote(field_name_5)],
            "#{unquote(field_name_6)}": values[unquote(field_name_6)],
            "#{unquote(field_name_7)}": values[unquote(field_name_7)],
            "#{unquote(field_name_8)}": values[unquote(field_name_8)],
            "#{unquote(field_name_9)}": values[unquote(field_name_9)],
            "#{unquote(field_name_10)}": values[unquote(field_name_10)],
            "#{unquote(field_name_11)}": values[unquote(field_name_11)],
            "#{unquote(field_name_12)}": values[unquote(field_name_12)],
            "#{unquote(field_name_13)}": values[unquote(field_name_13)],
            "#{unquote(field_name_14)}": values[unquote(field_name_14)],
            "#{unquote(field_name_15)}": values[unquote(field_name_15)],
            "#{unquote(field_name_16)}": values[unquote(field_name_16)],
            "#{unquote(field_name_17)}": values[unquote(field_name_17)],
            "#{unquote(field_name_18)}": values[unquote(field_name_18)],
            "#{unquote(field_name_19)}": values[unquote(field_name_19)],
            "#{unquote(field_name_20)}": values[unquote(field_name_20)],
            "#{unquote(field_name_21)}": values[unquote(field_name_21)],
            "#{unquote(field_name_22)}": values[unquote(field_name_22)]
        }
        struct(unquote(module), result)
      end


      def unquote(field_name_1)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_1))
      end

      if is_nil(unquote(struct_module_1)) === true do
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or unquote(guard_1)(value) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      else
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or is_struct(value, unquote(struct_module_1)) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      end
      def unquote(field_name_2)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_2))
      end

      if is_nil(unquote(struct_module_2)) === true do
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or unquote(guard_2)(value) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      else
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or is_struct(value, unquote(struct_module_2)) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      end
      def unquote(field_name_3)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_3))
      end

      if is_nil(unquote(struct_module_3)) === true do
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or unquote(guard_3)(value) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      else
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or is_struct(value, unquote(struct_module_3)) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      end
      def unquote(field_name_4)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_4))
      end

      if is_nil(unquote(struct_module_4)) === true do
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or unquote(guard_4)(value) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      else
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or is_struct(value, unquote(struct_module_4)) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      end
      def unquote(field_name_5)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_5))
      end

      if is_nil(unquote(struct_module_5)) === true do
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or unquote(guard_5)(value) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      else
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or is_struct(value, unquote(struct_module_5)) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      end
      def unquote(field_name_6)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_6))
      end

      if is_nil(unquote(struct_module_6)) === true do
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or unquote(guard_6)(value) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      else
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or is_struct(value, unquote(struct_module_6)) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      end
      def unquote(field_name_7)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_7))
      end

      if is_nil(unquote(struct_module_7)) === true do
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or unquote(guard_7)(value) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      else
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or is_struct(value, unquote(struct_module_7)) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      end
      def unquote(field_name_8)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_8))
      end

      if is_nil(unquote(struct_module_8)) === true do
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or unquote(guard_8)(value) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      else
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or is_struct(value, unquote(struct_module_8)) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      end
      def unquote(field_name_9)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_9))
      end

      if is_nil(unquote(struct_module_9)) === true do
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or unquote(guard_9)(value) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      else
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or is_struct(value, unquote(struct_module_9)) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      end
      def unquote(field_name_10)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_10))
      end

      if is_nil(unquote(struct_module_10)) === true do
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or unquote(guard_10)(value) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      else
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or is_struct(value, unquote(struct_module_10)) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      end
      def unquote(field_name_11)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_11))
      end

      if is_nil(unquote(struct_module_11)) === true do
        def unquote(field_name_11)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_11)) or unquote(guard_11)(value) do
          %{struct_instance | "#{unquote(field_name_11)}": value}
        end
      else
        def unquote(field_name_11)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_11)) or is_struct(value, unquote(struct_module_11)) do
          %{struct_instance | "#{unquote(field_name_11)}": value}
        end
      end
      def unquote(field_name_12)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_12))
      end

      if is_nil(unquote(struct_module_12)) === true do
        def unquote(field_name_12)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_12)) or unquote(guard_12)(value) do
          %{struct_instance | "#{unquote(field_name_12)}": value}
        end
      else
        def unquote(field_name_12)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_12)) or is_struct(value, unquote(struct_module_12)) do
          %{struct_instance | "#{unquote(field_name_12)}": value}
        end
      end
      def unquote(field_name_13)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_13))
      end

      if is_nil(unquote(struct_module_13)) === true do
        def unquote(field_name_13)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_13)) or unquote(guard_13)(value) do
          %{struct_instance | "#{unquote(field_name_13)}": value}
        end
      else
        def unquote(field_name_13)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_13)) or is_struct(value, unquote(struct_module_13)) do
          %{struct_instance | "#{unquote(field_name_13)}": value}
        end
      end
      def unquote(field_name_14)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_14))
      end

      if is_nil(unquote(struct_module_14)) === true do
        def unquote(field_name_14)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_14)) or unquote(guard_14)(value) do
          %{struct_instance | "#{unquote(field_name_14)}": value}
        end
      else
        def unquote(field_name_14)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_14)) or is_struct(value, unquote(struct_module_14)) do
          %{struct_instance | "#{unquote(field_name_14)}": value}
        end
      end
      def unquote(field_name_15)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_15))
      end

      if is_nil(unquote(struct_module_15)) === true do
        def unquote(field_name_15)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_15)) or unquote(guard_15)(value) do
          %{struct_instance | "#{unquote(field_name_15)}": value}
        end
      else
        def unquote(field_name_15)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_15)) or is_struct(value, unquote(struct_module_15)) do
          %{struct_instance | "#{unquote(field_name_15)}": value}
        end
      end
      def unquote(field_name_16)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_16))
      end

      if is_nil(unquote(struct_module_16)) === true do
        def unquote(field_name_16)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_16)) or unquote(guard_16)(value) do
          %{struct_instance | "#{unquote(field_name_16)}": value}
        end
      else
        def unquote(field_name_16)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_16)) or is_struct(value, unquote(struct_module_16)) do
          %{struct_instance | "#{unquote(field_name_16)}": value}
        end
      end
      def unquote(field_name_17)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_17))
      end

      if is_nil(unquote(struct_module_17)) === true do
        def unquote(field_name_17)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_17)) or unquote(guard_17)(value) do
          %{struct_instance | "#{unquote(field_name_17)}": value}
        end
      else
        def unquote(field_name_17)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_17)) or is_struct(value, unquote(struct_module_17)) do
          %{struct_instance | "#{unquote(field_name_17)}": value}
        end
      end
      def unquote(field_name_18)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_18))
      end

      if is_nil(unquote(struct_module_18)) === true do
        def unquote(field_name_18)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_18)) or unquote(guard_18)(value) do
          %{struct_instance | "#{unquote(field_name_18)}": value}
        end
      else
        def unquote(field_name_18)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_18)) or is_struct(value, unquote(struct_module_18)) do
          %{struct_instance | "#{unquote(field_name_18)}": value}
        end
      end
      def unquote(field_name_19)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_19))
      end

      if is_nil(unquote(struct_module_19)) === true do
        def unquote(field_name_19)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_19)) or unquote(guard_19)(value) do
          %{struct_instance | "#{unquote(field_name_19)}": value}
        end
      else
        def unquote(field_name_19)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_19)) or is_struct(value, unquote(struct_module_19)) do
          %{struct_instance | "#{unquote(field_name_19)}": value}
        end
      end
      def unquote(field_name_20)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_20))
      end

      if is_nil(unquote(struct_module_20)) === true do
        def unquote(field_name_20)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_20)) or unquote(guard_20)(value) do
          %{struct_instance | "#{unquote(field_name_20)}": value}
        end
      else
        def unquote(field_name_20)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_20)) or is_struct(value, unquote(struct_module_20)) do
          %{struct_instance | "#{unquote(field_name_20)}": value}
        end
      end
      def unquote(field_name_21)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_21))
      end

      if is_nil(unquote(struct_module_21)) === true do
        def unquote(field_name_21)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_21)) or unquote(guard_21)(value) do
          %{struct_instance | "#{unquote(field_name_21)}": value}
        end
      else
        def unquote(field_name_21)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_21)) or is_struct(value, unquote(struct_module_21)) do
          %{struct_instance | "#{unquote(field_name_21)}": value}
        end
      end
      def unquote(field_name_22)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_22))
      end

      if is_nil(unquote(struct_module_22)) === true do
        def unquote(field_name_22)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_22)) or unquote(guard_22)(value) do
          %{struct_instance | "#{unquote(field_name_22)}": value}
        end
      else
        def unquote(field_name_22)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_22)) or is_struct(value, unquote(struct_module_22)) do
          %{struct_instance | "#{unquote(field_name_22)}": value}
        end
      end
    end
  end




  @doc"""
  Generates a struct, complete with a constructor, getter and setter methods.

  Macro usage example:
      ```
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
        nullable: false,
        struct: nil
      },
      %{
        field: :hair_details,
        type_guard: :is_struct,
        default_value: %Hair{},
        nullable: true,
        struct: Hair
      })
      ```
  """
  defmacro generate_constructor(module, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9, field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19, field_20, field_21, field_22, field_23) do

    [
        field: field_name_1,
        type_guard: guard_1,
        default_value: default_1,
        nullable: is_nullable_1,
        struct: struct_module_1
    ] = field_1 |> elem(2)

    [
        field: field_name_2,
        type_guard: guard_2,
        default_value: default_2,
        nullable: is_nullable_2,
        struct: struct_module_2
    ] = field_2 |> elem(2)

    [
        field: field_name_3,
        type_guard: guard_3,
        default_value: default_3,
        nullable: is_nullable_3,
        struct: struct_module_3
    ] = field_3 |> elem(2)

    [
        field: field_name_4,
        type_guard: guard_4,
        default_value: default_4,
        nullable: is_nullable_4,
        struct: struct_module_4
    ] = field_4 |> elem(2)

    [
        field: field_name_5,
        type_guard: guard_5,
        default_value: default_5,
        nullable: is_nullable_5,
        struct: struct_module_5
    ] = field_5 |> elem(2)

    [
        field: field_name_6,
        type_guard: guard_6,
        default_value: default_6,
        nullable: is_nullable_6,
        struct: struct_module_6
    ] = field_6 |> elem(2)

    [
        field: field_name_7,
        type_guard: guard_7,
        default_value: default_7,
        nullable: is_nullable_7,
        struct: struct_module_7
    ] = field_7 |> elem(2)

    [
        field: field_name_8,
        type_guard: guard_8,
        default_value: default_8,
        nullable: is_nullable_8,
        struct: struct_module_8
    ] = field_8 |> elem(2)

    [
        field: field_name_9,
        type_guard: guard_9,
        default_value: default_9,
        nullable: is_nullable_9,
        struct: struct_module_9
    ] = field_9 |> elem(2)

    [
        field: field_name_10,
        type_guard: guard_10,
        default_value: default_10,
        nullable: is_nullable_10,
        struct: struct_module_10
    ] = field_10 |> elem(2)

    [
        field: field_name_11,
        type_guard: guard_11,
        default_value: default_11,
        nullable: is_nullable_11,
        struct: struct_module_11
    ] = field_11 |> elem(2)

    [
        field: field_name_12,
        type_guard: guard_12,
        default_value: default_12,
        nullable: is_nullable_12,
        struct: struct_module_12
    ] = field_12 |> elem(2)

    [
        field: field_name_13,
        type_guard: guard_13,
        default_value: default_13,
        nullable: is_nullable_13,
        struct: struct_module_13
    ] = field_13 |> elem(2)

    [
        field: field_name_14,
        type_guard: guard_14,
        default_value: default_14,
        nullable: is_nullable_14,
        struct: struct_module_14
    ] = field_14 |> elem(2)

    [
        field: field_name_15,
        type_guard: guard_15,
        default_value: default_15,
        nullable: is_nullable_15,
        struct: struct_module_15
    ] = field_15 |> elem(2)

    [
        field: field_name_16,
        type_guard: guard_16,
        default_value: default_16,
        nullable: is_nullable_16,
        struct: struct_module_16
    ] = field_16 |> elem(2)

    [
        field: field_name_17,
        type_guard: guard_17,
        default_value: default_17,
        nullable: is_nullable_17,
        struct: struct_module_17
    ] = field_17 |> elem(2)

    [
        field: field_name_18,
        type_guard: guard_18,
        default_value: default_18,
        nullable: is_nullable_18,
        struct: struct_module_18
    ] = field_18 |> elem(2)

    [
        field: field_name_19,
        type_guard: guard_19,
        default_value: default_19,
        nullable: is_nullable_19,
        struct: struct_module_19
    ] = field_19 |> elem(2)

    [
        field: field_name_20,
        type_guard: guard_20,
        default_value: default_20,
        nullable: is_nullable_20,
        struct: struct_module_20
    ] = field_20 |> elem(2)

    [
        field: field_name_21,
        type_guard: guard_21,
        default_value: default_21,
        nullable: is_nullable_21,
        struct: struct_module_21
    ] = field_21 |> elem(2)

    [
        field: field_name_22,
        type_guard: guard_22,
        default_value: default_22,
        nullable: is_nullable_22,
        struct: struct_module_22
    ] = field_22 |> elem(2)

    [
        field: field_name_23,
        type_guard: guard_23,
        default_value: default_23,
        nullable: is_nullable_23,
        struct: struct_module_23
    ] = field_23 |> elem(2)


    quote do
      defstruct [
        "#{unquote(field_name_1)}": unquote(default_1),
        "#{unquote(field_name_2)}": unquote(default_2),
        "#{unquote(field_name_3)}": unquote(default_3),
        "#{unquote(field_name_4)}": unquote(default_4),
        "#{unquote(field_name_5)}": unquote(default_5),
        "#{unquote(field_name_6)}": unquote(default_6),
        "#{unquote(field_name_7)}": unquote(default_7),
        "#{unquote(field_name_8)}": unquote(default_8),
        "#{unquote(field_name_9)}": unquote(default_9),
        "#{unquote(field_name_10)}": unquote(default_10),
        "#{unquote(field_name_11)}": unquote(default_11),
        "#{unquote(field_name_12)}": unquote(default_12),
        "#{unquote(field_name_13)}": unquote(default_13),
        "#{unquote(field_name_14)}": unquote(default_14),
        "#{unquote(field_name_15)}": unquote(default_15),
        "#{unquote(field_name_16)}": unquote(default_16),
        "#{unquote(field_name_17)}": unquote(default_17),
        "#{unquote(field_name_18)}": unquote(default_18),
        "#{unquote(field_name_19)}": unquote(default_19),
        "#{unquote(field_name_20)}": unquote(default_20),
        "#{unquote(field_name_21)}": unquote(default_21),
        "#{unquote(field_name_22)}": unquote(default_22),
        "#{unquote(field_name_23)}": unquote(default_23)
      ]

      defp validate_field(field_name, field_value, struct_module, is_nullable, guard) do
        (Code.ensure_compiled(struct_module) |> elem(0) === :module and is_struct(field_value, struct_module))
            or (is_nullable === true and field_value === nil)
            or apply(Kernel, guard, [field_value])
      end

      def constructor(values) do
        is_params_valid =
        validate_field(unquote(field_name_1), values[unquote(field_name_1)], unquote(struct_module_1), unquote(is_nullable_1), unquote(guard_1)) and
        validate_field(unquote(field_name_2), values[unquote(field_name_2)], unquote(struct_module_2), unquote(is_nullable_2), unquote(guard_2)) and
        validate_field(unquote(field_name_3), values[unquote(field_name_3)], unquote(struct_module_3), unquote(is_nullable_3), unquote(guard_3)) and
        validate_field(unquote(field_name_4), values[unquote(field_name_4)], unquote(struct_module_4), unquote(is_nullable_4), unquote(guard_4)) and
        validate_field(unquote(field_name_5), values[unquote(field_name_5)], unquote(struct_module_5), unquote(is_nullable_5), unquote(guard_5)) and
        validate_field(unquote(field_name_6), values[unquote(field_name_6)], unquote(struct_module_6), unquote(is_nullable_6), unquote(guard_6)) and
        validate_field(unquote(field_name_7), values[unquote(field_name_7)], unquote(struct_module_7), unquote(is_nullable_7), unquote(guard_7)) and
        validate_field(unquote(field_name_8), values[unquote(field_name_8)], unquote(struct_module_8), unquote(is_nullable_8), unquote(guard_8)) and
        validate_field(unquote(field_name_9), values[unquote(field_name_9)], unquote(struct_module_9), unquote(is_nullable_9), unquote(guard_9)) and
        validate_field(unquote(field_name_10), values[unquote(field_name_10)], unquote(struct_module_10), unquote(is_nullable_10), unquote(guard_10)) and
        validate_field(unquote(field_name_11), values[unquote(field_name_11)], unquote(struct_module_11), unquote(is_nullable_11), unquote(guard_11)) and
        validate_field(unquote(field_name_12), values[unquote(field_name_12)], unquote(struct_module_12), unquote(is_nullable_12), unquote(guard_12)) and
        validate_field(unquote(field_name_13), values[unquote(field_name_13)], unquote(struct_module_13), unquote(is_nullable_13), unquote(guard_13)) and
        validate_field(unquote(field_name_14), values[unquote(field_name_14)], unquote(struct_module_14), unquote(is_nullable_14), unquote(guard_14)) and
        validate_field(unquote(field_name_15), values[unquote(field_name_15)], unquote(struct_module_15), unquote(is_nullable_15), unquote(guard_15)) and
        validate_field(unquote(field_name_16), values[unquote(field_name_16)], unquote(struct_module_16), unquote(is_nullable_16), unquote(guard_16)) and
        validate_field(unquote(field_name_17), values[unquote(field_name_17)], unquote(struct_module_17), unquote(is_nullable_17), unquote(guard_17)) and
        validate_field(unquote(field_name_18), values[unquote(field_name_18)], unquote(struct_module_18), unquote(is_nullable_18), unquote(guard_18)) and
        validate_field(unquote(field_name_19), values[unquote(field_name_19)], unquote(struct_module_19), unquote(is_nullable_19), unquote(guard_19)) and
        validate_field(unquote(field_name_20), values[unquote(field_name_20)], unquote(struct_module_20), unquote(is_nullable_20), unquote(guard_20)) and
        validate_field(unquote(field_name_21), values[unquote(field_name_21)], unquote(struct_module_21), unquote(is_nullable_21), unquote(guard_21)) and
        validate_field(unquote(field_name_22), values[unquote(field_name_22)], unquote(struct_module_22), unquote(is_nullable_22), unquote(guard_22)) and
        validate_field(unquote(field_name_23), values[unquote(field_name_23)], unquote(struct_module_23), unquote(is_nullable_23), unquote(guard_23))

        if is_params_valid === false do
          raise "type mismatch for constructor paramater(s) or required parameters are missing"
        end

        result = %{
            "#{unquote(field_name_1)}": values[unquote(field_name_1)],
            "#{unquote(field_name_2)}": values[unquote(field_name_2)],
            "#{unquote(field_name_3)}": values[unquote(field_name_3)],
            "#{unquote(field_name_4)}": values[unquote(field_name_4)],
            "#{unquote(field_name_5)}": values[unquote(field_name_5)],
            "#{unquote(field_name_6)}": values[unquote(field_name_6)],
            "#{unquote(field_name_7)}": values[unquote(field_name_7)],
            "#{unquote(field_name_8)}": values[unquote(field_name_8)],
            "#{unquote(field_name_9)}": values[unquote(field_name_9)],
            "#{unquote(field_name_10)}": values[unquote(field_name_10)],
            "#{unquote(field_name_11)}": values[unquote(field_name_11)],
            "#{unquote(field_name_12)}": values[unquote(field_name_12)],
            "#{unquote(field_name_13)}": values[unquote(field_name_13)],
            "#{unquote(field_name_14)}": values[unquote(field_name_14)],
            "#{unquote(field_name_15)}": values[unquote(field_name_15)],
            "#{unquote(field_name_16)}": values[unquote(field_name_16)],
            "#{unquote(field_name_17)}": values[unquote(field_name_17)],
            "#{unquote(field_name_18)}": values[unquote(field_name_18)],
            "#{unquote(field_name_19)}": values[unquote(field_name_19)],
            "#{unquote(field_name_20)}": values[unquote(field_name_20)],
            "#{unquote(field_name_21)}": values[unquote(field_name_21)],
            "#{unquote(field_name_22)}": values[unquote(field_name_22)],
            "#{unquote(field_name_23)}": values[unquote(field_name_23)]
        }
        struct(unquote(module), result)
      end


      def unquote(field_name_1)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_1))
      end

      if is_nil(unquote(struct_module_1)) === true do
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or unquote(guard_1)(value) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      else
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or is_struct(value, unquote(struct_module_1)) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      end
      def unquote(field_name_2)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_2))
      end

      if is_nil(unquote(struct_module_2)) === true do
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or unquote(guard_2)(value) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      else
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or is_struct(value, unquote(struct_module_2)) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      end
      def unquote(field_name_3)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_3))
      end

      if is_nil(unquote(struct_module_3)) === true do
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or unquote(guard_3)(value) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      else
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or is_struct(value, unquote(struct_module_3)) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      end
      def unquote(field_name_4)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_4))
      end

      if is_nil(unquote(struct_module_4)) === true do
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or unquote(guard_4)(value) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      else
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or is_struct(value, unquote(struct_module_4)) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      end
      def unquote(field_name_5)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_5))
      end

      if is_nil(unquote(struct_module_5)) === true do
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or unquote(guard_5)(value) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      else
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or is_struct(value, unquote(struct_module_5)) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      end
      def unquote(field_name_6)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_6))
      end

      if is_nil(unquote(struct_module_6)) === true do
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or unquote(guard_6)(value) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      else
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or is_struct(value, unquote(struct_module_6)) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      end
      def unquote(field_name_7)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_7))
      end

      if is_nil(unquote(struct_module_7)) === true do
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or unquote(guard_7)(value) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      else
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or is_struct(value, unquote(struct_module_7)) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      end
      def unquote(field_name_8)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_8))
      end

      if is_nil(unquote(struct_module_8)) === true do
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or unquote(guard_8)(value) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      else
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or is_struct(value, unquote(struct_module_8)) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      end
      def unquote(field_name_9)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_9))
      end

      if is_nil(unquote(struct_module_9)) === true do
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or unquote(guard_9)(value) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      else
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or is_struct(value, unquote(struct_module_9)) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      end
      def unquote(field_name_10)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_10))
      end

      if is_nil(unquote(struct_module_10)) === true do
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or unquote(guard_10)(value) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      else
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or is_struct(value, unquote(struct_module_10)) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      end
      def unquote(field_name_11)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_11))
      end

      if is_nil(unquote(struct_module_11)) === true do
        def unquote(field_name_11)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_11)) or unquote(guard_11)(value) do
          %{struct_instance | "#{unquote(field_name_11)}": value}
        end
      else
        def unquote(field_name_11)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_11)) or is_struct(value, unquote(struct_module_11)) do
          %{struct_instance | "#{unquote(field_name_11)}": value}
        end
      end
      def unquote(field_name_12)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_12))
      end

      if is_nil(unquote(struct_module_12)) === true do
        def unquote(field_name_12)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_12)) or unquote(guard_12)(value) do
          %{struct_instance | "#{unquote(field_name_12)}": value}
        end
      else
        def unquote(field_name_12)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_12)) or is_struct(value, unquote(struct_module_12)) do
          %{struct_instance | "#{unquote(field_name_12)}": value}
        end
      end
      def unquote(field_name_13)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_13))
      end

      if is_nil(unquote(struct_module_13)) === true do
        def unquote(field_name_13)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_13)) or unquote(guard_13)(value) do
          %{struct_instance | "#{unquote(field_name_13)}": value}
        end
      else
        def unquote(field_name_13)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_13)) or is_struct(value, unquote(struct_module_13)) do
          %{struct_instance | "#{unquote(field_name_13)}": value}
        end
      end
      def unquote(field_name_14)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_14))
      end

      if is_nil(unquote(struct_module_14)) === true do
        def unquote(field_name_14)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_14)) or unquote(guard_14)(value) do
          %{struct_instance | "#{unquote(field_name_14)}": value}
        end
      else
        def unquote(field_name_14)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_14)) or is_struct(value, unquote(struct_module_14)) do
          %{struct_instance | "#{unquote(field_name_14)}": value}
        end
      end
      def unquote(field_name_15)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_15))
      end

      if is_nil(unquote(struct_module_15)) === true do
        def unquote(field_name_15)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_15)) or unquote(guard_15)(value) do
          %{struct_instance | "#{unquote(field_name_15)}": value}
        end
      else
        def unquote(field_name_15)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_15)) or is_struct(value, unquote(struct_module_15)) do
          %{struct_instance | "#{unquote(field_name_15)}": value}
        end
      end
      def unquote(field_name_16)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_16))
      end

      if is_nil(unquote(struct_module_16)) === true do
        def unquote(field_name_16)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_16)) or unquote(guard_16)(value) do
          %{struct_instance | "#{unquote(field_name_16)}": value}
        end
      else
        def unquote(field_name_16)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_16)) or is_struct(value, unquote(struct_module_16)) do
          %{struct_instance | "#{unquote(field_name_16)}": value}
        end
      end
      def unquote(field_name_17)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_17))
      end

      if is_nil(unquote(struct_module_17)) === true do
        def unquote(field_name_17)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_17)) or unquote(guard_17)(value) do
          %{struct_instance | "#{unquote(field_name_17)}": value}
        end
      else
        def unquote(field_name_17)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_17)) or is_struct(value, unquote(struct_module_17)) do
          %{struct_instance | "#{unquote(field_name_17)}": value}
        end
      end
      def unquote(field_name_18)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_18))
      end

      if is_nil(unquote(struct_module_18)) === true do
        def unquote(field_name_18)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_18)) or unquote(guard_18)(value) do
          %{struct_instance | "#{unquote(field_name_18)}": value}
        end
      else
        def unquote(field_name_18)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_18)) or is_struct(value, unquote(struct_module_18)) do
          %{struct_instance | "#{unquote(field_name_18)}": value}
        end
      end
      def unquote(field_name_19)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_19))
      end

      if is_nil(unquote(struct_module_19)) === true do
        def unquote(field_name_19)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_19)) or unquote(guard_19)(value) do
          %{struct_instance | "#{unquote(field_name_19)}": value}
        end
      else
        def unquote(field_name_19)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_19)) or is_struct(value, unquote(struct_module_19)) do
          %{struct_instance | "#{unquote(field_name_19)}": value}
        end
      end
      def unquote(field_name_20)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_20))
      end

      if is_nil(unquote(struct_module_20)) === true do
        def unquote(field_name_20)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_20)) or unquote(guard_20)(value) do
          %{struct_instance | "#{unquote(field_name_20)}": value}
        end
      else
        def unquote(field_name_20)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_20)) or is_struct(value, unquote(struct_module_20)) do
          %{struct_instance | "#{unquote(field_name_20)}": value}
        end
      end
      def unquote(field_name_21)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_21))
      end

      if is_nil(unquote(struct_module_21)) === true do
        def unquote(field_name_21)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_21)) or unquote(guard_21)(value) do
          %{struct_instance | "#{unquote(field_name_21)}": value}
        end
      else
        def unquote(field_name_21)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_21)) or is_struct(value, unquote(struct_module_21)) do
          %{struct_instance | "#{unquote(field_name_21)}": value}
        end
      end
      def unquote(field_name_22)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_22))
      end

      if is_nil(unquote(struct_module_22)) === true do
        def unquote(field_name_22)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_22)) or unquote(guard_22)(value) do
          %{struct_instance | "#{unquote(field_name_22)}": value}
        end
      else
        def unquote(field_name_22)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_22)) or is_struct(value, unquote(struct_module_22)) do
          %{struct_instance | "#{unquote(field_name_22)}": value}
        end
      end
      def unquote(field_name_23)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_23))
      end

      if is_nil(unquote(struct_module_23)) === true do
        def unquote(field_name_23)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_23)) or unquote(guard_23)(value) do
          %{struct_instance | "#{unquote(field_name_23)}": value}
        end
      else
        def unquote(field_name_23)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_23)) or is_struct(value, unquote(struct_module_23)) do
          %{struct_instance | "#{unquote(field_name_23)}": value}
        end
      end
    end
  end




  @doc"""
  Generates a struct, complete with a constructor, getter and setter methods.

  Macro usage example:
      ```
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
        nullable: false,
        struct: nil
      },
      %{
        field: :hair_details,
        type_guard: :is_struct,
        default_value: %Hair{},
        nullable: true,
        struct: Hair
      })
      ```
  """
  defmacro generate_constructor(module, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9, field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19, field_20, field_21, field_22, field_23, field_24) do

    [
        field: field_name_1,
        type_guard: guard_1,
        default_value: default_1,
        nullable: is_nullable_1,
        struct: struct_module_1
    ] = field_1 |> elem(2)

    [
        field: field_name_2,
        type_guard: guard_2,
        default_value: default_2,
        nullable: is_nullable_2,
        struct: struct_module_2
    ] = field_2 |> elem(2)

    [
        field: field_name_3,
        type_guard: guard_3,
        default_value: default_3,
        nullable: is_nullable_3,
        struct: struct_module_3
    ] = field_3 |> elem(2)

    [
        field: field_name_4,
        type_guard: guard_4,
        default_value: default_4,
        nullable: is_nullable_4,
        struct: struct_module_4
    ] = field_4 |> elem(2)

    [
        field: field_name_5,
        type_guard: guard_5,
        default_value: default_5,
        nullable: is_nullable_5,
        struct: struct_module_5
    ] = field_5 |> elem(2)

    [
        field: field_name_6,
        type_guard: guard_6,
        default_value: default_6,
        nullable: is_nullable_6,
        struct: struct_module_6
    ] = field_6 |> elem(2)

    [
        field: field_name_7,
        type_guard: guard_7,
        default_value: default_7,
        nullable: is_nullable_7,
        struct: struct_module_7
    ] = field_7 |> elem(2)

    [
        field: field_name_8,
        type_guard: guard_8,
        default_value: default_8,
        nullable: is_nullable_8,
        struct: struct_module_8
    ] = field_8 |> elem(2)

    [
        field: field_name_9,
        type_guard: guard_9,
        default_value: default_9,
        nullable: is_nullable_9,
        struct: struct_module_9
    ] = field_9 |> elem(2)

    [
        field: field_name_10,
        type_guard: guard_10,
        default_value: default_10,
        nullable: is_nullable_10,
        struct: struct_module_10
    ] = field_10 |> elem(2)

    [
        field: field_name_11,
        type_guard: guard_11,
        default_value: default_11,
        nullable: is_nullable_11,
        struct: struct_module_11
    ] = field_11 |> elem(2)

    [
        field: field_name_12,
        type_guard: guard_12,
        default_value: default_12,
        nullable: is_nullable_12,
        struct: struct_module_12
    ] = field_12 |> elem(2)

    [
        field: field_name_13,
        type_guard: guard_13,
        default_value: default_13,
        nullable: is_nullable_13,
        struct: struct_module_13
    ] = field_13 |> elem(2)

    [
        field: field_name_14,
        type_guard: guard_14,
        default_value: default_14,
        nullable: is_nullable_14,
        struct: struct_module_14
    ] = field_14 |> elem(2)

    [
        field: field_name_15,
        type_guard: guard_15,
        default_value: default_15,
        nullable: is_nullable_15,
        struct: struct_module_15
    ] = field_15 |> elem(2)

    [
        field: field_name_16,
        type_guard: guard_16,
        default_value: default_16,
        nullable: is_nullable_16,
        struct: struct_module_16
    ] = field_16 |> elem(2)

    [
        field: field_name_17,
        type_guard: guard_17,
        default_value: default_17,
        nullable: is_nullable_17,
        struct: struct_module_17
    ] = field_17 |> elem(2)

    [
        field: field_name_18,
        type_guard: guard_18,
        default_value: default_18,
        nullable: is_nullable_18,
        struct: struct_module_18
    ] = field_18 |> elem(2)

    [
        field: field_name_19,
        type_guard: guard_19,
        default_value: default_19,
        nullable: is_nullable_19,
        struct: struct_module_19
    ] = field_19 |> elem(2)

    [
        field: field_name_20,
        type_guard: guard_20,
        default_value: default_20,
        nullable: is_nullable_20,
        struct: struct_module_20
    ] = field_20 |> elem(2)

    [
        field: field_name_21,
        type_guard: guard_21,
        default_value: default_21,
        nullable: is_nullable_21,
        struct: struct_module_21
    ] = field_21 |> elem(2)

    [
        field: field_name_22,
        type_guard: guard_22,
        default_value: default_22,
        nullable: is_nullable_22,
        struct: struct_module_22
    ] = field_22 |> elem(2)

    [
        field: field_name_23,
        type_guard: guard_23,
        default_value: default_23,
        nullable: is_nullable_23,
        struct: struct_module_23
    ] = field_23 |> elem(2)

    [
        field: field_name_24,
        type_guard: guard_24,
        default_value: default_24,
        nullable: is_nullable_24,
        struct: struct_module_24
    ] = field_24 |> elem(2)


    quote do
      defstruct [
        "#{unquote(field_name_1)}": unquote(default_1),
        "#{unquote(field_name_2)}": unquote(default_2),
        "#{unquote(field_name_3)}": unquote(default_3),
        "#{unquote(field_name_4)}": unquote(default_4),
        "#{unquote(field_name_5)}": unquote(default_5),
        "#{unquote(field_name_6)}": unquote(default_6),
        "#{unquote(field_name_7)}": unquote(default_7),
        "#{unquote(field_name_8)}": unquote(default_8),
        "#{unquote(field_name_9)}": unquote(default_9),
        "#{unquote(field_name_10)}": unquote(default_10),
        "#{unquote(field_name_11)}": unquote(default_11),
        "#{unquote(field_name_12)}": unquote(default_12),
        "#{unquote(field_name_13)}": unquote(default_13),
        "#{unquote(field_name_14)}": unquote(default_14),
        "#{unquote(field_name_15)}": unquote(default_15),
        "#{unquote(field_name_16)}": unquote(default_16),
        "#{unquote(field_name_17)}": unquote(default_17),
        "#{unquote(field_name_18)}": unquote(default_18),
        "#{unquote(field_name_19)}": unquote(default_19),
        "#{unquote(field_name_20)}": unquote(default_20),
        "#{unquote(field_name_21)}": unquote(default_21),
        "#{unquote(field_name_22)}": unquote(default_22),
        "#{unquote(field_name_23)}": unquote(default_23),
        "#{unquote(field_name_24)}": unquote(default_24)
      ]

      defp validate_field(field_name, field_value, struct_module, is_nullable, guard) do
        (Code.ensure_compiled(struct_module) |> elem(0) === :module and is_struct(field_value, struct_module))
            or (is_nullable === true and field_value === nil)
            or apply(Kernel, guard, [field_value])
      end

      def constructor(values) do
        is_params_valid =
        validate_field(unquote(field_name_1), values[unquote(field_name_1)], unquote(struct_module_1), unquote(is_nullable_1), unquote(guard_1)) and
        validate_field(unquote(field_name_2), values[unquote(field_name_2)], unquote(struct_module_2), unquote(is_nullable_2), unquote(guard_2)) and
        validate_field(unquote(field_name_3), values[unquote(field_name_3)], unquote(struct_module_3), unquote(is_nullable_3), unquote(guard_3)) and
        validate_field(unquote(field_name_4), values[unquote(field_name_4)], unquote(struct_module_4), unquote(is_nullable_4), unquote(guard_4)) and
        validate_field(unquote(field_name_5), values[unquote(field_name_5)], unquote(struct_module_5), unquote(is_nullable_5), unquote(guard_5)) and
        validate_field(unquote(field_name_6), values[unquote(field_name_6)], unquote(struct_module_6), unquote(is_nullable_6), unquote(guard_6)) and
        validate_field(unquote(field_name_7), values[unquote(field_name_7)], unquote(struct_module_7), unquote(is_nullable_7), unquote(guard_7)) and
        validate_field(unquote(field_name_8), values[unquote(field_name_8)], unquote(struct_module_8), unquote(is_nullable_8), unquote(guard_8)) and
        validate_field(unquote(field_name_9), values[unquote(field_name_9)], unquote(struct_module_9), unquote(is_nullable_9), unquote(guard_9)) and
        validate_field(unquote(field_name_10), values[unquote(field_name_10)], unquote(struct_module_10), unquote(is_nullable_10), unquote(guard_10)) and
        validate_field(unquote(field_name_11), values[unquote(field_name_11)], unquote(struct_module_11), unquote(is_nullable_11), unquote(guard_11)) and
        validate_field(unquote(field_name_12), values[unquote(field_name_12)], unquote(struct_module_12), unquote(is_nullable_12), unquote(guard_12)) and
        validate_field(unquote(field_name_13), values[unquote(field_name_13)], unquote(struct_module_13), unquote(is_nullable_13), unquote(guard_13)) and
        validate_field(unquote(field_name_14), values[unquote(field_name_14)], unquote(struct_module_14), unquote(is_nullable_14), unquote(guard_14)) and
        validate_field(unquote(field_name_15), values[unquote(field_name_15)], unquote(struct_module_15), unquote(is_nullable_15), unquote(guard_15)) and
        validate_field(unquote(field_name_16), values[unquote(field_name_16)], unquote(struct_module_16), unquote(is_nullable_16), unquote(guard_16)) and
        validate_field(unquote(field_name_17), values[unquote(field_name_17)], unquote(struct_module_17), unquote(is_nullable_17), unquote(guard_17)) and
        validate_field(unquote(field_name_18), values[unquote(field_name_18)], unquote(struct_module_18), unquote(is_nullable_18), unquote(guard_18)) and
        validate_field(unquote(field_name_19), values[unquote(field_name_19)], unquote(struct_module_19), unquote(is_nullable_19), unquote(guard_19)) and
        validate_field(unquote(field_name_20), values[unquote(field_name_20)], unquote(struct_module_20), unquote(is_nullable_20), unquote(guard_20)) and
        validate_field(unquote(field_name_21), values[unquote(field_name_21)], unquote(struct_module_21), unquote(is_nullable_21), unquote(guard_21)) and
        validate_field(unquote(field_name_22), values[unquote(field_name_22)], unquote(struct_module_22), unquote(is_nullable_22), unquote(guard_22)) and
        validate_field(unquote(field_name_23), values[unquote(field_name_23)], unquote(struct_module_23), unquote(is_nullable_23), unquote(guard_23)) and
        validate_field(unquote(field_name_24), values[unquote(field_name_24)], unquote(struct_module_24), unquote(is_nullable_24), unquote(guard_24))

        if is_params_valid === false do
          raise "type mismatch for constructor paramater(s) or required parameters are missing"
        end

        result = %{
            "#{unquote(field_name_1)}": values[unquote(field_name_1)],
            "#{unquote(field_name_2)}": values[unquote(field_name_2)],
            "#{unquote(field_name_3)}": values[unquote(field_name_3)],
            "#{unquote(field_name_4)}": values[unquote(field_name_4)],
            "#{unquote(field_name_5)}": values[unquote(field_name_5)],
            "#{unquote(field_name_6)}": values[unquote(field_name_6)],
            "#{unquote(field_name_7)}": values[unquote(field_name_7)],
            "#{unquote(field_name_8)}": values[unquote(field_name_8)],
            "#{unquote(field_name_9)}": values[unquote(field_name_9)],
            "#{unquote(field_name_10)}": values[unquote(field_name_10)],
            "#{unquote(field_name_11)}": values[unquote(field_name_11)],
            "#{unquote(field_name_12)}": values[unquote(field_name_12)],
            "#{unquote(field_name_13)}": values[unquote(field_name_13)],
            "#{unquote(field_name_14)}": values[unquote(field_name_14)],
            "#{unquote(field_name_15)}": values[unquote(field_name_15)],
            "#{unquote(field_name_16)}": values[unquote(field_name_16)],
            "#{unquote(field_name_17)}": values[unquote(field_name_17)],
            "#{unquote(field_name_18)}": values[unquote(field_name_18)],
            "#{unquote(field_name_19)}": values[unquote(field_name_19)],
            "#{unquote(field_name_20)}": values[unquote(field_name_20)],
            "#{unquote(field_name_21)}": values[unquote(field_name_21)],
            "#{unquote(field_name_22)}": values[unquote(field_name_22)],
            "#{unquote(field_name_23)}": values[unquote(field_name_23)],
            "#{unquote(field_name_24)}": values[unquote(field_name_24)]
        }
        struct(unquote(module), result)
      end


      def unquote(field_name_1)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_1))
      end

      if is_nil(unquote(struct_module_1)) === true do
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or unquote(guard_1)(value) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      else
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or is_struct(value, unquote(struct_module_1)) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      end
      def unquote(field_name_2)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_2))
      end

      if is_nil(unquote(struct_module_2)) === true do
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or unquote(guard_2)(value) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      else
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or is_struct(value, unquote(struct_module_2)) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      end
      def unquote(field_name_3)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_3))
      end

      if is_nil(unquote(struct_module_3)) === true do
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or unquote(guard_3)(value) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      else
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or is_struct(value, unquote(struct_module_3)) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      end
      def unquote(field_name_4)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_4))
      end

      if is_nil(unquote(struct_module_4)) === true do
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or unquote(guard_4)(value) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      else
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or is_struct(value, unquote(struct_module_4)) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      end
      def unquote(field_name_5)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_5))
      end

      if is_nil(unquote(struct_module_5)) === true do
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or unquote(guard_5)(value) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      else
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or is_struct(value, unquote(struct_module_5)) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      end
      def unquote(field_name_6)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_6))
      end

      if is_nil(unquote(struct_module_6)) === true do
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or unquote(guard_6)(value) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      else
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or is_struct(value, unquote(struct_module_6)) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      end
      def unquote(field_name_7)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_7))
      end

      if is_nil(unquote(struct_module_7)) === true do
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or unquote(guard_7)(value) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      else
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or is_struct(value, unquote(struct_module_7)) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      end
      def unquote(field_name_8)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_8))
      end

      if is_nil(unquote(struct_module_8)) === true do
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or unquote(guard_8)(value) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      else
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or is_struct(value, unquote(struct_module_8)) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      end
      def unquote(field_name_9)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_9))
      end

      if is_nil(unquote(struct_module_9)) === true do
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or unquote(guard_9)(value) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      else
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or is_struct(value, unquote(struct_module_9)) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      end
      def unquote(field_name_10)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_10))
      end

      if is_nil(unquote(struct_module_10)) === true do
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or unquote(guard_10)(value) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      else
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or is_struct(value, unquote(struct_module_10)) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      end
      def unquote(field_name_11)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_11))
      end

      if is_nil(unquote(struct_module_11)) === true do
        def unquote(field_name_11)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_11)) or unquote(guard_11)(value) do
          %{struct_instance | "#{unquote(field_name_11)}": value}
        end
      else
        def unquote(field_name_11)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_11)) or is_struct(value, unquote(struct_module_11)) do
          %{struct_instance | "#{unquote(field_name_11)}": value}
        end
      end
      def unquote(field_name_12)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_12))
      end

      if is_nil(unquote(struct_module_12)) === true do
        def unquote(field_name_12)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_12)) or unquote(guard_12)(value) do
          %{struct_instance | "#{unquote(field_name_12)}": value}
        end
      else
        def unquote(field_name_12)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_12)) or is_struct(value, unquote(struct_module_12)) do
          %{struct_instance | "#{unquote(field_name_12)}": value}
        end
      end
      def unquote(field_name_13)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_13))
      end

      if is_nil(unquote(struct_module_13)) === true do
        def unquote(field_name_13)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_13)) or unquote(guard_13)(value) do
          %{struct_instance | "#{unquote(field_name_13)}": value}
        end
      else
        def unquote(field_name_13)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_13)) or is_struct(value, unquote(struct_module_13)) do
          %{struct_instance | "#{unquote(field_name_13)}": value}
        end
      end
      def unquote(field_name_14)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_14))
      end

      if is_nil(unquote(struct_module_14)) === true do
        def unquote(field_name_14)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_14)) or unquote(guard_14)(value) do
          %{struct_instance | "#{unquote(field_name_14)}": value}
        end
      else
        def unquote(field_name_14)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_14)) or is_struct(value, unquote(struct_module_14)) do
          %{struct_instance | "#{unquote(field_name_14)}": value}
        end
      end
      def unquote(field_name_15)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_15))
      end

      if is_nil(unquote(struct_module_15)) === true do
        def unquote(field_name_15)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_15)) or unquote(guard_15)(value) do
          %{struct_instance | "#{unquote(field_name_15)}": value}
        end
      else
        def unquote(field_name_15)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_15)) or is_struct(value, unquote(struct_module_15)) do
          %{struct_instance | "#{unquote(field_name_15)}": value}
        end
      end
      def unquote(field_name_16)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_16))
      end

      if is_nil(unquote(struct_module_16)) === true do
        def unquote(field_name_16)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_16)) or unquote(guard_16)(value) do
          %{struct_instance | "#{unquote(field_name_16)}": value}
        end
      else
        def unquote(field_name_16)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_16)) or is_struct(value, unquote(struct_module_16)) do
          %{struct_instance | "#{unquote(field_name_16)}": value}
        end
      end
      def unquote(field_name_17)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_17))
      end

      if is_nil(unquote(struct_module_17)) === true do
        def unquote(field_name_17)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_17)) or unquote(guard_17)(value) do
          %{struct_instance | "#{unquote(field_name_17)}": value}
        end
      else
        def unquote(field_name_17)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_17)) or is_struct(value, unquote(struct_module_17)) do
          %{struct_instance | "#{unquote(field_name_17)}": value}
        end
      end
      def unquote(field_name_18)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_18))
      end

      if is_nil(unquote(struct_module_18)) === true do
        def unquote(field_name_18)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_18)) or unquote(guard_18)(value) do
          %{struct_instance | "#{unquote(field_name_18)}": value}
        end
      else
        def unquote(field_name_18)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_18)) or is_struct(value, unquote(struct_module_18)) do
          %{struct_instance | "#{unquote(field_name_18)}": value}
        end
      end
      def unquote(field_name_19)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_19))
      end

      if is_nil(unquote(struct_module_19)) === true do
        def unquote(field_name_19)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_19)) or unquote(guard_19)(value) do
          %{struct_instance | "#{unquote(field_name_19)}": value}
        end
      else
        def unquote(field_name_19)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_19)) or is_struct(value, unquote(struct_module_19)) do
          %{struct_instance | "#{unquote(field_name_19)}": value}
        end
      end
      def unquote(field_name_20)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_20))
      end

      if is_nil(unquote(struct_module_20)) === true do
        def unquote(field_name_20)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_20)) or unquote(guard_20)(value) do
          %{struct_instance | "#{unquote(field_name_20)}": value}
        end
      else
        def unquote(field_name_20)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_20)) or is_struct(value, unquote(struct_module_20)) do
          %{struct_instance | "#{unquote(field_name_20)}": value}
        end
      end
      def unquote(field_name_21)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_21))
      end

      if is_nil(unquote(struct_module_21)) === true do
        def unquote(field_name_21)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_21)) or unquote(guard_21)(value) do
          %{struct_instance | "#{unquote(field_name_21)}": value}
        end
      else
        def unquote(field_name_21)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_21)) or is_struct(value, unquote(struct_module_21)) do
          %{struct_instance | "#{unquote(field_name_21)}": value}
        end
      end
      def unquote(field_name_22)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_22))
      end

      if is_nil(unquote(struct_module_22)) === true do
        def unquote(field_name_22)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_22)) or unquote(guard_22)(value) do
          %{struct_instance | "#{unquote(field_name_22)}": value}
        end
      else
        def unquote(field_name_22)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_22)) or is_struct(value, unquote(struct_module_22)) do
          %{struct_instance | "#{unquote(field_name_22)}": value}
        end
      end
      def unquote(field_name_23)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_23))
      end

      if is_nil(unquote(struct_module_23)) === true do
        def unquote(field_name_23)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_23)) or unquote(guard_23)(value) do
          %{struct_instance | "#{unquote(field_name_23)}": value}
        end
      else
        def unquote(field_name_23)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_23)) or is_struct(value, unquote(struct_module_23)) do
          %{struct_instance | "#{unquote(field_name_23)}": value}
        end
      end
      def unquote(field_name_24)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_24))
      end

      if is_nil(unquote(struct_module_24)) === true do
        def unquote(field_name_24)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_24)) or unquote(guard_24)(value) do
          %{struct_instance | "#{unquote(field_name_24)}": value}
        end
      else
        def unquote(field_name_24)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_24)) or is_struct(value, unquote(struct_module_24)) do
          %{struct_instance | "#{unquote(field_name_24)}": value}
        end
      end
    end
  end




  @doc"""
  Generates a struct, complete with a constructor, getter and setter methods.

  Macro usage example:
      ```
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
        nullable: false,
        struct: nil
      },
      %{
        field: :hair_details,
        type_guard: :is_struct,
        default_value: %Hair{},
        nullable: true,
        struct: Hair
      })
      ```
  """
  defmacro generate_constructor(module, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9, field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19, field_20, field_21, field_22, field_23, field_24, field_25) do

    [
        field: field_name_1,
        type_guard: guard_1,
        default_value: default_1,
        nullable: is_nullable_1,
        struct: struct_module_1
    ] = field_1 |> elem(2)

    [
        field: field_name_2,
        type_guard: guard_2,
        default_value: default_2,
        nullable: is_nullable_2,
        struct: struct_module_2
    ] = field_2 |> elem(2)

    [
        field: field_name_3,
        type_guard: guard_3,
        default_value: default_3,
        nullable: is_nullable_3,
        struct: struct_module_3
    ] = field_3 |> elem(2)

    [
        field: field_name_4,
        type_guard: guard_4,
        default_value: default_4,
        nullable: is_nullable_4,
        struct: struct_module_4
    ] = field_4 |> elem(2)

    [
        field: field_name_5,
        type_guard: guard_5,
        default_value: default_5,
        nullable: is_nullable_5,
        struct: struct_module_5
    ] = field_5 |> elem(2)

    [
        field: field_name_6,
        type_guard: guard_6,
        default_value: default_6,
        nullable: is_nullable_6,
        struct: struct_module_6
    ] = field_6 |> elem(2)

    [
        field: field_name_7,
        type_guard: guard_7,
        default_value: default_7,
        nullable: is_nullable_7,
        struct: struct_module_7
    ] = field_7 |> elem(2)

    [
        field: field_name_8,
        type_guard: guard_8,
        default_value: default_8,
        nullable: is_nullable_8,
        struct: struct_module_8
    ] = field_8 |> elem(2)

    [
        field: field_name_9,
        type_guard: guard_9,
        default_value: default_9,
        nullable: is_nullable_9,
        struct: struct_module_9
    ] = field_9 |> elem(2)

    [
        field: field_name_10,
        type_guard: guard_10,
        default_value: default_10,
        nullable: is_nullable_10,
        struct: struct_module_10
    ] = field_10 |> elem(2)

    [
        field: field_name_11,
        type_guard: guard_11,
        default_value: default_11,
        nullable: is_nullable_11,
        struct: struct_module_11
    ] = field_11 |> elem(2)

    [
        field: field_name_12,
        type_guard: guard_12,
        default_value: default_12,
        nullable: is_nullable_12,
        struct: struct_module_12
    ] = field_12 |> elem(2)

    [
        field: field_name_13,
        type_guard: guard_13,
        default_value: default_13,
        nullable: is_nullable_13,
        struct: struct_module_13
    ] = field_13 |> elem(2)

    [
        field: field_name_14,
        type_guard: guard_14,
        default_value: default_14,
        nullable: is_nullable_14,
        struct: struct_module_14
    ] = field_14 |> elem(2)

    [
        field: field_name_15,
        type_guard: guard_15,
        default_value: default_15,
        nullable: is_nullable_15,
        struct: struct_module_15
    ] = field_15 |> elem(2)

    [
        field: field_name_16,
        type_guard: guard_16,
        default_value: default_16,
        nullable: is_nullable_16,
        struct: struct_module_16
    ] = field_16 |> elem(2)

    [
        field: field_name_17,
        type_guard: guard_17,
        default_value: default_17,
        nullable: is_nullable_17,
        struct: struct_module_17
    ] = field_17 |> elem(2)

    [
        field: field_name_18,
        type_guard: guard_18,
        default_value: default_18,
        nullable: is_nullable_18,
        struct: struct_module_18
    ] = field_18 |> elem(2)

    [
        field: field_name_19,
        type_guard: guard_19,
        default_value: default_19,
        nullable: is_nullable_19,
        struct: struct_module_19
    ] = field_19 |> elem(2)

    [
        field: field_name_20,
        type_guard: guard_20,
        default_value: default_20,
        nullable: is_nullable_20,
        struct: struct_module_20
    ] = field_20 |> elem(2)

    [
        field: field_name_21,
        type_guard: guard_21,
        default_value: default_21,
        nullable: is_nullable_21,
        struct: struct_module_21
    ] = field_21 |> elem(2)

    [
        field: field_name_22,
        type_guard: guard_22,
        default_value: default_22,
        nullable: is_nullable_22,
        struct: struct_module_22
    ] = field_22 |> elem(2)

    [
        field: field_name_23,
        type_guard: guard_23,
        default_value: default_23,
        nullable: is_nullable_23,
        struct: struct_module_23
    ] = field_23 |> elem(2)

    [
        field: field_name_24,
        type_guard: guard_24,
        default_value: default_24,
        nullable: is_nullable_24,
        struct: struct_module_24
    ] = field_24 |> elem(2)

    [
        field: field_name_25,
        type_guard: guard_25,
        default_value: default_25,
        nullable: is_nullable_25,
        struct: struct_module_25
    ] = field_25 |> elem(2)


    quote do
      defstruct [
        "#{unquote(field_name_1)}": unquote(default_1),
        "#{unquote(field_name_2)}": unquote(default_2),
        "#{unquote(field_name_3)}": unquote(default_3),
        "#{unquote(field_name_4)}": unquote(default_4),
        "#{unquote(field_name_5)}": unquote(default_5),
        "#{unquote(field_name_6)}": unquote(default_6),
        "#{unquote(field_name_7)}": unquote(default_7),
        "#{unquote(field_name_8)}": unquote(default_8),
        "#{unquote(field_name_9)}": unquote(default_9),
        "#{unquote(field_name_10)}": unquote(default_10),
        "#{unquote(field_name_11)}": unquote(default_11),
        "#{unquote(field_name_12)}": unquote(default_12),
        "#{unquote(field_name_13)}": unquote(default_13),
        "#{unquote(field_name_14)}": unquote(default_14),
        "#{unquote(field_name_15)}": unquote(default_15),
        "#{unquote(field_name_16)}": unquote(default_16),
        "#{unquote(field_name_17)}": unquote(default_17),
        "#{unquote(field_name_18)}": unquote(default_18),
        "#{unquote(field_name_19)}": unquote(default_19),
        "#{unquote(field_name_20)}": unquote(default_20),
        "#{unquote(field_name_21)}": unquote(default_21),
        "#{unquote(field_name_22)}": unquote(default_22),
        "#{unquote(field_name_23)}": unquote(default_23),
        "#{unquote(field_name_24)}": unquote(default_24),
        "#{unquote(field_name_25)}": unquote(default_25)
      ]

      defp validate_field(field_name, field_value, struct_module, is_nullable, guard) do
        (Code.ensure_compiled(struct_module) |> elem(0) === :module and is_struct(field_value, struct_module))
            or (is_nullable === true and field_value === nil)
            or apply(Kernel, guard, [field_value])
      end

      def constructor(values) do
        is_params_valid =
        validate_field(unquote(field_name_1), values[unquote(field_name_1)], unquote(struct_module_1), unquote(is_nullable_1), unquote(guard_1)) and
        validate_field(unquote(field_name_2), values[unquote(field_name_2)], unquote(struct_module_2), unquote(is_nullable_2), unquote(guard_2)) and
        validate_field(unquote(field_name_3), values[unquote(field_name_3)], unquote(struct_module_3), unquote(is_nullable_3), unquote(guard_3)) and
        validate_field(unquote(field_name_4), values[unquote(field_name_4)], unquote(struct_module_4), unquote(is_nullable_4), unquote(guard_4)) and
        validate_field(unquote(field_name_5), values[unquote(field_name_5)], unquote(struct_module_5), unquote(is_nullable_5), unquote(guard_5)) and
        validate_field(unquote(field_name_6), values[unquote(field_name_6)], unquote(struct_module_6), unquote(is_nullable_6), unquote(guard_6)) and
        validate_field(unquote(field_name_7), values[unquote(field_name_7)], unquote(struct_module_7), unquote(is_nullable_7), unquote(guard_7)) and
        validate_field(unquote(field_name_8), values[unquote(field_name_8)], unquote(struct_module_8), unquote(is_nullable_8), unquote(guard_8)) and
        validate_field(unquote(field_name_9), values[unquote(field_name_9)], unquote(struct_module_9), unquote(is_nullable_9), unquote(guard_9)) and
        validate_field(unquote(field_name_10), values[unquote(field_name_10)], unquote(struct_module_10), unquote(is_nullable_10), unquote(guard_10)) and
        validate_field(unquote(field_name_11), values[unquote(field_name_11)], unquote(struct_module_11), unquote(is_nullable_11), unquote(guard_11)) and
        validate_field(unquote(field_name_12), values[unquote(field_name_12)], unquote(struct_module_12), unquote(is_nullable_12), unquote(guard_12)) and
        validate_field(unquote(field_name_13), values[unquote(field_name_13)], unquote(struct_module_13), unquote(is_nullable_13), unquote(guard_13)) and
        validate_field(unquote(field_name_14), values[unquote(field_name_14)], unquote(struct_module_14), unquote(is_nullable_14), unquote(guard_14)) and
        validate_field(unquote(field_name_15), values[unquote(field_name_15)], unquote(struct_module_15), unquote(is_nullable_15), unquote(guard_15)) and
        validate_field(unquote(field_name_16), values[unquote(field_name_16)], unquote(struct_module_16), unquote(is_nullable_16), unquote(guard_16)) and
        validate_field(unquote(field_name_17), values[unquote(field_name_17)], unquote(struct_module_17), unquote(is_nullable_17), unquote(guard_17)) and
        validate_field(unquote(field_name_18), values[unquote(field_name_18)], unquote(struct_module_18), unquote(is_nullable_18), unquote(guard_18)) and
        validate_field(unquote(field_name_19), values[unquote(field_name_19)], unquote(struct_module_19), unquote(is_nullable_19), unquote(guard_19)) and
        validate_field(unquote(field_name_20), values[unquote(field_name_20)], unquote(struct_module_20), unquote(is_nullable_20), unquote(guard_20)) and
        validate_field(unquote(field_name_21), values[unquote(field_name_21)], unquote(struct_module_21), unquote(is_nullable_21), unquote(guard_21)) and
        validate_field(unquote(field_name_22), values[unquote(field_name_22)], unquote(struct_module_22), unquote(is_nullable_22), unquote(guard_22)) and
        validate_field(unquote(field_name_23), values[unquote(field_name_23)], unquote(struct_module_23), unquote(is_nullable_23), unquote(guard_23)) and
        validate_field(unquote(field_name_24), values[unquote(field_name_24)], unquote(struct_module_24), unquote(is_nullable_24), unquote(guard_24)) and
        validate_field(unquote(field_name_25), values[unquote(field_name_25)], unquote(struct_module_25), unquote(is_nullable_25), unquote(guard_25))

        if is_params_valid === false do
          raise "type mismatch for constructor paramater(s) or required parameters are missing"
        end

        result = %{
            "#{unquote(field_name_1)}": values[unquote(field_name_1)],
            "#{unquote(field_name_2)}": values[unquote(field_name_2)],
            "#{unquote(field_name_3)}": values[unquote(field_name_3)],
            "#{unquote(field_name_4)}": values[unquote(field_name_4)],
            "#{unquote(field_name_5)}": values[unquote(field_name_5)],
            "#{unquote(field_name_6)}": values[unquote(field_name_6)],
            "#{unquote(field_name_7)}": values[unquote(field_name_7)],
            "#{unquote(field_name_8)}": values[unquote(field_name_8)],
            "#{unquote(field_name_9)}": values[unquote(field_name_9)],
            "#{unquote(field_name_10)}": values[unquote(field_name_10)],
            "#{unquote(field_name_11)}": values[unquote(field_name_11)],
            "#{unquote(field_name_12)}": values[unquote(field_name_12)],
            "#{unquote(field_name_13)}": values[unquote(field_name_13)],
            "#{unquote(field_name_14)}": values[unquote(field_name_14)],
            "#{unquote(field_name_15)}": values[unquote(field_name_15)],
            "#{unquote(field_name_16)}": values[unquote(field_name_16)],
            "#{unquote(field_name_17)}": values[unquote(field_name_17)],
            "#{unquote(field_name_18)}": values[unquote(field_name_18)],
            "#{unquote(field_name_19)}": values[unquote(field_name_19)],
            "#{unquote(field_name_20)}": values[unquote(field_name_20)],
            "#{unquote(field_name_21)}": values[unquote(field_name_21)],
            "#{unquote(field_name_22)}": values[unquote(field_name_22)],
            "#{unquote(field_name_23)}": values[unquote(field_name_23)],
            "#{unquote(field_name_24)}": values[unquote(field_name_24)],
            "#{unquote(field_name_25)}": values[unquote(field_name_25)]
        }
        struct(unquote(module), result)
      end


      def unquote(field_name_1)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_1))
      end

      if is_nil(unquote(struct_module_1)) === true do
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or unquote(guard_1)(value) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      else
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or is_struct(value, unquote(struct_module_1)) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      end
      def unquote(field_name_2)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_2))
      end

      if is_nil(unquote(struct_module_2)) === true do
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or unquote(guard_2)(value) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      else
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or is_struct(value, unquote(struct_module_2)) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      end
      def unquote(field_name_3)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_3))
      end

      if is_nil(unquote(struct_module_3)) === true do
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or unquote(guard_3)(value) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      else
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or is_struct(value, unquote(struct_module_3)) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      end
      def unquote(field_name_4)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_4))
      end

      if is_nil(unquote(struct_module_4)) === true do
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or unquote(guard_4)(value) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      else
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or is_struct(value, unquote(struct_module_4)) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      end
      def unquote(field_name_5)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_5))
      end

      if is_nil(unquote(struct_module_5)) === true do
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or unquote(guard_5)(value) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      else
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or is_struct(value, unquote(struct_module_5)) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      end
      def unquote(field_name_6)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_6))
      end

      if is_nil(unquote(struct_module_6)) === true do
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or unquote(guard_6)(value) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      else
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or is_struct(value, unquote(struct_module_6)) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      end
      def unquote(field_name_7)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_7))
      end

      if is_nil(unquote(struct_module_7)) === true do
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or unquote(guard_7)(value) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      else
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or is_struct(value, unquote(struct_module_7)) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      end
      def unquote(field_name_8)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_8))
      end

      if is_nil(unquote(struct_module_8)) === true do
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or unquote(guard_8)(value) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      else
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or is_struct(value, unquote(struct_module_8)) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      end
      def unquote(field_name_9)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_9))
      end

      if is_nil(unquote(struct_module_9)) === true do
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or unquote(guard_9)(value) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      else
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or is_struct(value, unquote(struct_module_9)) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      end
      def unquote(field_name_10)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_10))
      end

      if is_nil(unquote(struct_module_10)) === true do
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or unquote(guard_10)(value) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      else
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or is_struct(value, unquote(struct_module_10)) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      end
      def unquote(field_name_11)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_11))
      end

      if is_nil(unquote(struct_module_11)) === true do
        def unquote(field_name_11)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_11)) or unquote(guard_11)(value) do
          %{struct_instance | "#{unquote(field_name_11)}": value}
        end
      else
        def unquote(field_name_11)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_11)) or is_struct(value, unquote(struct_module_11)) do
          %{struct_instance | "#{unquote(field_name_11)}": value}
        end
      end
      def unquote(field_name_12)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_12))
      end

      if is_nil(unquote(struct_module_12)) === true do
        def unquote(field_name_12)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_12)) or unquote(guard_12)(value) do
          %{struct_instance | "#{unquote(field_name_12)}": value}
        end
      else
        def unquote(field_name_12)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_12)) or is_struct(value, unquote(struct_module_12)) do
          %{struct_instance | "#{unquote(field_name_12)}": value}
        end
      end
      def unquote(field_name_13)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_13))
      end

      if is_nil(unquote(struct_module_13)) === true do
        def unquote(field_name_13)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_13)) or unquote(guard_13)(value) do
          %{struct_instance | "#{unquote(field_name_13)}": value}
        end
      else
        def unquote(field_name_13)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_13)) or is_struct(value, unquote(struct_module_13)) do
          %{struct_instance | "#{unquote(field_name_13)}": value}
        end
      end
      def unquote(field_name_14)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_14))
      end

      if is_nil(unquote(struct_module_14)) === true do
        def unquote(field_name_14)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_14)) or unquote(guard_14)(value) do
          %{struct_instance | "#{unquote(field_name_14)}": value}
        end
      else
        def unquote(field_name_14)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_14)) or is_struct(value, unquote(struct_module_14)) do
          %{struct_instance | "#{unquote(field_name_14)}": value}
        end
      end
      def unquote(field_name_15)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_15))
      end

      if is_nil(unquote(struct_module_15)) === true do
        def unquote(field_name_15)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_15)) or unquote(guard_15)(value) do
          %{struct_instance | "#{unquote(field_name_15)}": value}
        end
      else
        def unquote(field_name_15)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_15)) or is_struct(value, unquote(struct_module_15)) do
          %{struct_instance | "#{unquote(field_name_15)}": value}
        end
      end
      def unquote(field_name_16)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_16))
      end

      if is_nil(unquote(struct_module_16)) === true do
        def unquote(field_name_16)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_16)) or unquote(guard_16)(value) do
          %{struct_instance | "#{unquote(field_name_16)}": value}
        end
      else
        def unquote(field_name_16)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_16)) or is_struct(value, unquote(struct_module_16)) do
          %{struct_instance | "#{unquote(field_name_16)}": value}
        end
      end
      def unquote(field_name_17)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_17))
      end

      if is_nil(unquote(struct_module_17)) === true do
        def unquote(field_name_17)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_17)) or unquote(guard_17)(value) do
          %{struct_instance | "#{unquote(field_name_17)}": value}
        end
      else
        def unquote(field_name_17)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_17)) or is_struct(value, unquote(struct_module_17)) do
          %{struct_instance | "#{unquote(field_name_17)}": value}
        end
      end
      def unquote(field_name_18)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_18))
      end

      if is_nil(unquote(struct_module_18)) === true do
        def unquote(field_name_18)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_18)) or unquote(guard_18)(value) do
          %{struct_instance | "#{unquote(field_name_18)}": value}
        end
      else
        def unquote(field_name_18)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_18)) or is_struct(value, unquote(struct_module_18)) do
          %{struct_instance | "#{unquote(field_name_18)}": value}
        end
      end
      def unquote(field_name_19)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_19))
      end

      if is_nil(unquote(struct_module_19)) === true do
        def unquote(field_name_19)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_19)) or unquote(guard_19)(value) do
          %{struct_instance | "#{unquote(field_name_19)}": value}
        end
      else
        def unquote(field_name_19)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_19)) or is_struct(value, unquote(struct_module_19)) do
          %{struct_instance | "#{unquote(field_name_19)}": value}
        end
      end
      def unquote(field_name_20)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_20))
      end

      if is_nil(unquote(struct_module_20)) === true do
        def unquote(field_name_20)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_20)) or unquote(guard_20)(value) do
          %{struct_instance | "#{unquote(field_name_20)}": value}
        end
      else
        def unquote(field_name_20)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_20)) or is_struct(value, unquote(struct_module_20)) do
          %{struct_instance | "#{unquote(field_name_20)}": value}
        end
      end
      def unquote(field_name_21)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_21))
      end

      if is_nil(unquote(struct_module_21)) === true do
        def unquote(field_name_21)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_21)) or unquote(guard_21)(value) do
          %{struct_instance | "#{unquote(field_name_21)}": value}
        end
      else
        def unquote(field_name_21)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_21)) or is_struct(value, unquote(struct_module_21)) do
          %{struct_instance | "#{unquote(field_name_21)}": value}
        end
      end
      def unquote(field_name_22)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_22))
      end

      if is_nil(unquote(struct_module_22)) === true do
        def unquote(field_name_22)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_22)) or unquote(guard_22)(value) do
          %{struct_instance | "#{unquote(field_name_22)}": value}
        end
      else
        def unquote(field_name_22)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_22)) or is_struct(value, unquote(struct_module_22)) do
          %{struct_instance | "#{unquote(field_name_22)}": value}
        end
      end
      def unquote(field_name_23)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_23))
      end

      if is_nil(unquote(struct_module_23)) === true do
        def unquote(field_name_23)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_23)) or unquote(guard_23)(value) do
          %{struct_instance | "#{unquote(field_name_23)}": value}
        end
      else
        def unquote(field_name_23)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_23)) or is_struct(value, unquote(struct_module_23)) do
          %{struct_instance | "#{unquote(field_name_23)}": value}
        end
      end
      def unquote(field_name_24)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_24))
      end

      if is_nil(unquote(struct_module_24)) === true do
        def unquote(field_name_24)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_24)) or unquote(guard_24)(value) do
          %{struct_instance | "#{unquote(field_name_24)}": value}
        end
      else
        def unquote(field_name_24)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_24)) or is_struct(value, unquote(struct_module_24)) do
          %{struct_instance | "#{unquote(field_name_24)}": value}
        end
      end
      def unquote(field_name_25)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_25))
      end

      if is_nil(unquote(struct_module_25)) === true do
        def unquote(field_name_25)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_25)) or unquote(guard_25)(value) do
          %{struct_instance | "#{unquote(field_name_25)}": value}
        end
      else
        def unquote(field_name_25)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_25)) or is_struct(value, unquote(struct_module_25)) do
          %{struct_instance | "#{unquote(field_name_25)}": value}
        end
      end
    end
  end




  @doc"""
  Generates a struct, complete with a constructor, getter and setter methods.

  Macro usage example:
      ```
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
        nullable: false,
        struct: nil
      },
      %{
        field: :hair_details,
        type_guard: :is_struct,
        default_value: %Hair{},
        nullable: true,
        struct: Hair
      })
      ```
  """
  defmacro generate_constructor(module, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9, field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19, field_20, field_21, field_22, field_23, field_24, field_25, field_26) do

    [
        field: field_name_1,
        type_guard: guard_1,
        default_value: default_1,
        nullable: is_nullable_1,
        struct: struct_module_1
    ] = field_1 |> elem(2)

    [
        field: field_name_2,
        type_guard: guard_2,
        default_value: default_2,
        nullable: is_nullable_2,
        struct: struct_module_2
    ] = field_2 |> elem(2)

    [
        field: field_name_3,
        type_guard: guard_3,
        default_value: default_3,
        nullable: is_nullable_3,
        struct: struct_module_3
    ] = field_3 |> elem(2)

    [
        field: field_name_4,
        type_guard: guard_4,
        default_value: default_4,
        nullable: is_nullable_4,
        struct: struct_module_4
    ] = field_4 |> elem(2)

    [
        field: field_name_5,
        type_guard: guard_5,
        default_value: default_5,
        nullable: is_nullable_5,
        struct: struct_module_5
    ] = field_5 |> elem(2)

    [
        field: field_name_6,
        type_guard: guard_6,
        default_value: default_6,
        nullable: is_nullable_6,
        struct: struct_module_6
    ] = field_6 |> elem(2)

    [
        field: field_name_7,
        type_guard: guard_7,
        default_value: default_7,
        nullable: is_nullable_7,
        struct: struct_module_7
    ] = field_7 |> elem(2)

    [
        field: field_name_8,
        type_guard: guard_8,
        default_value: default_8,
        nullable: is_nullable_8,
        struct: struct_module_8
    ] = field_8 |> elem(2)

    [
        field: field_name_9,
        type_guard: guard_9,
        default_value: default_9,
        nullable: is_nullable_9,
        struct: struct_module_9
    ] = field_9 |> elem(2)

    [
        field: field_name_10,
        type_guard: guard_10,
        default_value: default_10,
        nullable: is_nullable_10,
        struct: struct_module_10
    ] = field_10 |> elem(2)

    [
        field: field_name_11,
        type_guard: guard_11,
        default_value: default_11,
        nullable: is_nullable_11,
        struct: struct_module_11
    ] = field_11 |> elem(2)

    [
        field: field_name_12,
        type_guard: guard_12,
        default_value: default_12,
        nullable: is_nullable_12,
        struct: struct_module_12
    ] = field_12 |> elem(2)

    [
        field: field_name_13,
        type_guard: guard_13,
        default_value: default_13,
        nullable: is_nullable_13,
        struct: struct_module_13
    ] = field_13 |> elem(2)

    [
        field: field_name_14,
        type_guard: guard_14,
        default_value: default_14,
        nullable: is_nullable_14,
        struct: struct_module_14
    ] = field_14 |> elem(2)

    [
        field: field_name_15,
        type_guard: guard_15,
        default_value: default_15,
        nullable: is_nullable_15,
        struct: struct_module_15
    ] = field_15 |> elem(2)

    [
        field: field_name_16,
        type_guard: guard_16,
        default_value: default_16,
        nullable: is_nullable_16,
        struct: struct_module_16
    ] = field_16 |> elem(2)

    [
        field: field_name_17,
        type_guard: guard_17,
        default_value: default_17,
        nullable: is_nullable_17,
        struct: struct_module_17
    ] = field_17 |> elem(2)

    [
        field: field_name_18,
        type_guard: guard_18,
        default_value: default_18,
        nullable: is_nullable_18,
        struct: struct_module_18
    ] = field_18 |> elem(2)

    [
        field: field_name_19,
        type_guard: guard_19,
        default_value: default_19,
        nullable: is_nullable_19,
        struct: struct_module_19
    ] = field_19 |> elem(2)

    [
        field: field_name_20,
        type_guard: guard_20,
        default_value: default_20,
        nullable: is_nullable_20,
        struct: struct_module_20
    ] = field_20 |> elem(2)

    [
        field: field_name_21,
        type_guard: guard_21,
        default_value: default_21,
        nullable: is_nullable_21,
        struct: struct_module_21
    ] = field_21 |> elem(2)

    [
        field: field_name_22,
        type_guard: guard_22,
        default_value: default_22,
        nullable: is_nullable_22,
        struct: struct_module_22
    ] = field_22 |> elem(2)

    [
        field: field_name_23,
        type_guard: guard_23,
        default_value: default_23,
        nullable: is_nullable_23,
        struct: struct_module_23
    ] = field_23 |> elem(2)

    [
        field: field_name_24,
        type_guard: guard_24,
        default_value: default_24,
        nullable: is_nullable_24,
        struct: struct_module_24
    ] = field_24 |> elem(2)

    [
        field: field_name_25,
        type_guard: guard_25,
        default_value: default_25,
        nullable: is_nullable_25,
        struct: struct_module_25
    ] = field_25 |> elem(2)

    [
        field: field_name_26,
        type_guard: guard_26,
        default_value: default_26,
        nullable: is_nullable_26,
        struct: struct_module_26
    ] = field_26 |> elem(2)


    quote do
      defstruct [
        "#{unquote(field_name_1)}": unquote(default_1),
        "#{unquote(field_name_2)}": unquote(default_2),
        "#{unquote(field_name_3)}": unquote(default_3),
        "#{unquote(field_name_4)}": unquote(default_4),
        "#{unquote(field_name_5)}": unquote(default_5),
        "#{unquote(field_name_6)}": unquote(default_6),
        "#{unquote(field_name_7)}": unquote(default_7),
        "#{unquote(field_name_8)}": unquote(default_8),
        "#{unquote(field_name_9)}": unquote(default_9),
        "#{unquote(field_name_10)}": unquote(default_10),
        "#{unquote(field_name_11)}": unquote(default_11),
        "#{unquote(field_name_12)}": unquote(default_12),
        "#{unquote(field_name_13)}": unquote(default_13),
        "#{unquote(field_name_14)}": unquote(default_14),
        "#{unquote(field_name_15)}": unquote(default_15),
        "#{unquote(field_name_16)}": unquote(default_16),
        "#{unquote(field_name_17)}": unquote(default_17),
        "#{unquote(field_name_18)}": unquote(default_18),
        "#{unquote(field_name_19)}": unquote(default_19),
        "#{unquote(field_name_20)}": unquote(default_20),
        "#{unquote(field_name_21)}": unquote(default_21),
        "#{unquote(field_name_22)}": unquote(default_22),
        "#{unquote(field_name_23)}": unquote(default_23),
        "#{unquote(field_name_24)}": unquote(default_24),
        "#{unquote(field_name_25)}": unquote(default_25),
        "#{unquote(field_name_26)}": unquote(default_26)
      ]

      defp validate_field(field_name, field_value, struct_module, is_nullable, guard) do
        (Code.ensure_compiled(struct_module) |> elem(0) === :module and is_struct(field_value, struct_module))
            or (is_nullable === true and field_value === nil)
            or apply(Kernel, guard, [field_value])
      end

      def constructor(values) do
        is_params_valid =
        validate_field(unquote(field_name_1), values[unquote(field_name_1)], unquote(struct_module_1), unquote(is_nullable_1), unquote(guard_1)) and
        validate_field(unquote(field_name_2), values[unquote(field_name_2)], unquote(struct_module_2), unquote(is_nullable_2), unquote(guard_2)) and
        validate_field(unquote(field_name_3), values[unquote(field_name_3)], unquote(struct_module_3), unquote(is_nullable_3), unquote(guard_3)) and
        validate_field(unquote(field_name_4), values[unquote(field_name_4)], unquote(struct_module_4), unquote(is_nullable_4), unquote(guard_4)) and
        validate_field(unquote(field_name_5), values[unquote(field_name_5)], unquote(struct_module_5), unquote(is_nullable_5), unquote(guard_5)) and
        validate_field(unquote(field_name_6), values[unquote(field_name_6)], unquote(struct_module_6), unquote(is_nullable_6), unquote(guard_6)) and
        validate_field(unquote(field_name_7), values[unquote(field_name_7)], unquote(struct_module_7), unquote(is_nullable_7), unquote(guard_7)) and
        validate_field(unquote(field_name_8), values[unquote(field_name_8)], unquote(struct_module_8), unquote(is_nullable_8), unquote(guard_8)) and
        validate_field(unquote(field_name_9), values[unquote(field_name_9)], unquote(struct_module_9), unquote(is_nullable_9), unquote(guard_9)) and
        validate_field(unquote(field_name_10), values[unquote(field_name_10)], unquote(struct_module_10), unquote(is_nullable_10), unquote(guard_10)) and
        validate_field(unquote(field_name_11), values[unquote(field_name_11)], unquote(struct_module_11), unquote(is_nullable_11), unquote(guard_11)) and
        validate_field(unquote(field_name_12), values[unquote(field_name_12)], unquote(struct_module_12), unquote(is_nullable_12), unquote(guard_12)) and
        validate_field(unquote(field_name_13), values[unquote(field_name_13)], unquote(struct_module_13), unquote(is_nullable_13), unquote(guard_13)) and
        validate_field(unquote(field_name_14), values[unquote(field_name_14)], unquote(struct_module_14), unquote(is_nullable_14), unquote(guard_14)) and
        validate_field(unquote(field_name_15), values[unquote(field_name_15)], unquote(struct_module_15), unquote(is_nullable_15), unquote(guard_15)) and
        validate_field(unquote(field_name_16), values[unquote(field_name_16)], unquote(struct_module_16), unquote(is_nullable_16), unquote(guard_16)) and
        validate_field(unquote(field_name_17), values[unquote(field_name_17)], unquote(struct_module_17), unquote(is_nullable_17), unquote(guard_17)) and
        validate_field(unquote(field_name_18), values[unquote(field_name_18)], unquote(struct_module_18), unquote(is_nullable_18), unquote(guard_18)) and
        validate_field(unquote(field_name_19), values[unquote(field_name_19)], unquote(struct_module_19), unquote(is_nullable_19), unquote(guard_19)) and
        validate_field(unquote(field_name_20), values[unquote(field_name_20)], unquote(struct_module_20), unquote(is_nullable_20), unquote(guard_20)) and
        validate_field(unquote(field_name_21), values[unquote(field_name_21)], unquote(struct_module_21), unquote(is_nullable_21), unquote(guard_21)) and
        validate_field(unquote(field_name_22), values[unquote(field_name_22)], unquote(struct_module_22), unquote(is_nullable_22), unquote(guard_22)) and
        validate_field(unquote(field_name_23), values[unquote(field_name_23)], unquote(struct_module_23), unquote(is_nullable_23), unquote(guard_23)) and
        validate_field(unquote(field_name_24), values[unquote(field_name_24)], unquote(struct_module_24), unquote(is_nullable_24), unquote(guard_24)) and
        validate_field(unquote(field_name_25), values[unquote(field_name_25)], unquote(struct_module_25), unquote(is_nullable_25), unquote(guard_25)) and
        validate_field(unquote(field_name_26), values[unquote(field_name_26)], unquote(struct_module_26), unquote(is_nullable_26), unquote(guard_26))

        if is_params_valid === false do
          raise "type mismatch for constructor paramater(s) or required parameters are missing"
        end

        result = %{
            "#{unquote(field_name_1)}": values[unquote(field_name_1)],
            "#{unquote(field_name_2)}": values[unquote(field_name_2)],
            "#{unquote(field_name_3)}": values[unquote(field_name_3)],
            "#{unquote(field_name_4)}": values[unquote(field_name_4)],
            "#{unquote(field_name_5)}": values[unquote(field_name_5)],
            "#{unquote(field_name_6)}": values[unquote(field_name_6)],
            "#{unquote(field_name_7)}": values[unquote(field_name_7)],
            "#{unquote(field_name_8)}": values[unquote(field_name_8)],
            "#{unquote(field_name_9)}": values[unquote(field_name_9)],
            "#{unquote(field_name_10)}": values[unquote(field_name_10)],
            "#{unquote(field_name_11)}": values[unquote(field_name_11)],
            "#{unquote(field_name_12)}": values[unquote(field_name_12)],
            "#{unquote(field_name_13)}": values[unquote(field_name_13)],
            "#{unquote(field_name_14)}": values[unquote(field_name_14)],
            "#{unquote(field_name_15)}": values[unquote(field_name_15)],
            "#{unquote(field_name_16)}": values[unquote(field_name_16)],
            "#{unquote(field_name_17)}": values[unquote(field_name_17)],
            "#{unquote(field_name_18)}": values[unquote(field_name_18)],
            "#{unquote(field_name_19)}": values[unquote(field_name_19)],
            "#{unquote(field_name_20)}": values[unquote(field_name_20)],
            "#{unquote(field_name_21)}": values[unquote(field_name_21)],
            "#{unquote(field_name_22)}": values[unquote(field_name_22)],
            "#{unquote(field_name_23)}": values[unquote(field_name_23)],
            "#{unquote(field_name_24)}": values[unquote(field_name_24)],
            "#{unquote(field_name_25)}": values[unquote(field_name_25)],
            "#{unquote(field_name_26)}": values[unquote(field_name_26)]
        }
        struct(unquote(module), result)
      end


      def unquote(field_name_1)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_1))
      end

      if is_nil(unquote(struct_module_1)) === true do
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or unquote(guard_1)(value) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      else
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or is_struct(value, unquote(struct_module_1)) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      end
      def unquote(field_name_2)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_2))
      end

      if is_nil(unquote(struct_module_2)) === true do
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or unquote(guard_2)(value) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      else
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or is_struct(value, unquote(struct_module_2)) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      end
      def unquote(field_name_3)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_3))
      end

      if is_nil(unquote(struct_module_3)) === true do
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or unquote(guard_3)(value) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      else
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or is_struct(value, unquote(struct_module_3)) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      end
      def unquote(field_name_4)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_4))
      end

      if is_nil(unquote(struct_module_4)) === true do
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or unquote(guard_4)(value) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      else
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or is_struct(value, unquote(struct_module_4)) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      end
      def unquote(field_name_5)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_5))
      end

      if is_nil(unquote(struct_module_5)) === true do
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or unquote(guard_5)(value) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      else
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or is_struct(value, unquote(struct_module_5)) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      end
      def unquote(field_name_6)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_6))
      end

      if is_nil(unquote(struct_module_6)) === true do
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or unquote(guard_6)(value) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      else
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or is_struct(value, unquote(struct_module_6)) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      end
      def unquote(field_name_7)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_7))
      end

      if is_nil(unquote(struct_module_7)) === true do
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or unquote(guard_7)(value) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      else
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or is_struct(value, unquote(struct_module_7)) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      end
      def unquote(field_name_8)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_8))
      end

      if is_nil(unquote(struct_module_8)) === true do
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or unquote(guard_8)(value) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      else
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or is_struct(value, unquote(struct_module_8)) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      end
      def unquote(field_name_9)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_9))
      end

      if is_nil(unquote(struct_module_9)) === true do
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or unquote(guard_9)(value) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      else
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or is_struct(value, unquote(struct_module_9)) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      end
      def unquote(field_name_10)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_10))
      end

      if is_nil(unquote(struct_module_10)) === true do
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or unquote(guard_10)(value) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      else
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or is_struct(value, unquote(struct_module_10)) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      end
      def unquote(field_name_11)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_11))
      end

      if is_nil(unquote(struct_module_11)) === true do
        def unquote(field_name_11)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_11)) or unquote(guard_11)(value) do
          %{struct_instance | "#{unquote(field_name_11)}": value}
        end
      else
        def unquote(field_name_11)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_11)) or is_struct(value, unquote(struct_module_11)) do
          %{struct_instance | "#{unquote(field_name_11)}": value}
        end
      end
      def unquote(field_name_12)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_12))
      end

      if is_nil(unquote(struct_module_12)) === true do
        def unquote(field_name_12)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_12)) or unquote(guard_12)(value) do
          %{struct_instance | "#{unquote(field_name_12)}": value}
        end
      else
        def unquote(field_name_12)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_12)) or is_struct(value, unquote(struct_module_12)) do
          %{struct_instance | "#{unquote(field_name_12)}": value}
        end
      end
      def unquote(field_name_13)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_13))
      end

      if is_nil(unquote(struct_module_13)) === true do
        def unquote(field_name_13)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_13)) or unquote(guard_13)(value) do
          %{struct_instance | "#{unquote(field_name_13)}": value}
        end
      else
        def unquote(field_name_13)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_13)) or is_struct(value, unquote(struct_module_13)) do
          %{struct_instance | "#{unquote(field_name_13)}": value}
        end
      end
      def unquote(field_name_14)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_14))
      end

      if is_nil(unquote(struct_module_14)) === true do
        def unquote(field_name_14)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_14)) or unquote(guard_14)(value) do
          %{struct_instance | "#{unquote(field_name_14)}": value}
        end
      else
        def unquote(field_name_14)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_14)) or is_struct(value, unquote(struct_module_14)) do
          %{struct_instance | "#{unquote(field_name_14)}": value}
        end
      end
      def unquote(field_name_15)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_15))
      end

      if is_nil(unquote(struct_module_15)) === true do
        def unquote(field_name_15)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_15)) or unquote(guard_15)(value) do
          %{struct_instance | "#{unquote(field_name_15)}": value}
        end
      else
        def unquote(field_name_15)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_15)) or is_struct(value, unquote(struct_module_15)) do
          %{struct_instance | "#{unquote(field_name_15)}": value}
        end
      end
      def unquote(field_name_16)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_16))
      end

      if is_nil(unquote(struct_module_16)) === true do
        def unquote(field_name_16)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_16)) or unquote(guard_16)(value) do
          %{struct_instance | "#{unquote(field_name_16)}": value}
        end
      else
        def unquote(field_name_16)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_16)) or is_struct(value, unquote(struct_module_16)) do
          %{struct_instance | "#{unquote(field_name_16)}": value}
        end
      end
      def unquote(field_name_17)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_17))
      end

      if is_nil(unquote(struct_module_17)) === true do
        def unquote(field_name_17)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_17)) or unquote(guard_17)(value) do
          %{struct_instance | "#{unquote(field_name_17)}": value}
        end
      else
        def unquote(field_name_17)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_17)) or is_struct(value, unquote(struct_module_17)) do
          %{struct_instance | "#{unquote(field_name_17)}": value}
        end
      end
      def unquote(field_name_18)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_18))
      end

      if is_nil(unquote(struct_module_18)) === true do
        def unquote(field_name_18)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_18)) or unquote(guard_18)(value) do
          %{struct_instance | "#{unquote(field_name_18)}": value}
        end
      else
        def unquote(field_name_18)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_18)) or is_struct(value, unquote(struct_module_18)) do
          %{struct_instance | "#{unquote(field_name_18)}": value}
        end
      end
      def unquote(field_name_19)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_19))
      end

      if is_nil(unquote(struct_module_19)) === true do
        def unquote(field_name_19)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_19)) or unquote(guard_19)(value) do
          %{struct_instance | "#{unquote(field_name_19)}": value}
        end
      else
        def unquote(field_name_19)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_19)) or is_struct(value, unquote(struct_module_19)) do
          %{struct_instance | "#{unquote(field_name_19)}": value}
        end
      end
      def unquote(field_name_20)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_20))
      end

      if is_nil(unquote(struct_module_20)) === true do
        def unquote(field_name_20)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_20)) or unquote(guard_20)(value) do
          %{struct_instance | "#{unquote(field_name_20)}": value}
        end
      else
        def unquote(field_name_20)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_20)) or is_struct(value, unquote(struct_module_20)) do
          %{struct_instance | "#{unquote(field_name_20)}": value}
        end
      end
      def unquote(field_name_21)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_21))
      end

      if is_nil(unquote(struct_module_21)) === true do
        def unquote(field_name_21)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_21)) or unquote(guard_21)(value) do
          %{struct_instance | "#{unquote(field_name_21)}": value}
        end
      else
        def unquote(field_name_21)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_21)) or is_struct(value, unquote(struct_module_21)) do
          %{struct_instance | "#{unquote(field_name_21)}": value}
        end
      end
      def unquote(field_name_22)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_22))
      end

      if is_nil(unquote(struct_module_22)) === true do
        def unquote(field_name_22)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_22)) or unquote(guard_22)(value) do
          %{struct_instance | "#{unquote(field_name_22)}": value}
        end
      else
        def unquote(field_name_22)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_22)) or is_struct(value, unquote(struct_module_22)) do
          %{struct_instance | "#{unquote(field_name_22)}": value}
        end
      end
      def unquote(field_name_23)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_23))
      end

      if is_nil(unquote(struct_module_23)) === true do
        def unquote(field_name_23)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_23)) or unquote(guard_23)(value) do
          %{struct_instance | "#{unquote(field_name_23)}": value}
        end
      else
        def unquote(field_name_23)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_23)) or is_struct(value, unquote(struct_module_23)) do
          %{struct_instance | "#{unquote(field_name_23)}": value}
        end
      end
      def unquote(field_name_24)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_24))
      end

      if is_nil(unquote(struct_module_24)) === true do
        def unquote(field_name_24)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_24)) or unquote(guard_24)(value) do
          %{struct_instance | "#{unquote(field_name_24)}": value}
        end
      else
        def unquote(field_name_24)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_24)) or is_struct(value, unquote(struct_module_24)) do
          %{struct_instance | "#{unquote(field_name_24)}": value}
        end
      end
      def unquote(field_name_25)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_25))
      end

      if is_nil(unquote(struct_module_25)) === true do
        def unquote(field_name_25)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_25)) or unquote(guard_25)(value) do
          %{struct_instance | "#{unquote(field_name_25)}": value}
        end
      else
        def unquote(field_name_25)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_25)) or is_struct(value, unquote(struct_module_25)) do
          %{struct_instance | "#{unquote(field_name_25)}": value}
        end
      end
      def unquote(field_name_26)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_26))
      end

      if is_nil(unquote(struct_module_26)) === true do
        def unquote(field_name_26)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_26)) or unquote(guard_26)(value) do
          %{struct_instance | "#{unquote(field_name_26)}": value}
        end
      else
        def unquote(field_name_26)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_26)) or is_struct(value, unquote(struct_module_26)) do
          %{struct_instance | "#{unquote(field_name_26)}": value}
        end
      end
    end
  end




  @doc"""
  Generates a struct, complete with a constructor, getter and setter methods.

  Macro usage example:
      ```
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
        nullable: false,
        struct: nil
      },
      %{
        field: :hair_details,
        type_guard: :is_struct,
        default_value: %Hair{},
        nullable: true,
        struct: Hair
      })
      ```
  """
  defmacro generate_constructor(module, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9, field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19, field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27) do

    [
        field: field_name_1,
        type_guard: guard_1,
        default_value: default_1,
        nullable: is_nullable_1,
        struct: struct_module_1
    ] = field_1 |> elem(2)

    [
        field: field_name_2,
        type_guard: guard_2,
        default_value: default_2,
        nullable: is_nullable_2,
        struct: struct_module_2
    ] = field_2 |> elem(2)

    [
        field: field_name_3,
        type_guard: guard_3,
        default_value: default_3,
        nullable: is_nullable_3,
        struct: struct_module_3
    ] = field_3 |> elem(2)

    [
        field: field_name_4,
        type_guard: guard_4,
        default_value: default_4,
        nullable: is_nullable_4,
        struct: struct_module_4
    ] = field_4 |> elem(2)

    [
        field: field_name_5,
        type_guard: guard_5,
        default_value: default_5,
        nullable: is_nullable_5,
        struct: struct_module_5
    ] = field_5 |> elem(2)

    [
        field: field_name_6,
        type_guard: guard_6,
        default_value: default_6,
        nullable: is_nullable_6,
        struct: struct_module_6
    ] = field_6 |> elem(2)

    [
        field: field_name_7,
        type_guard: guard_7,
        default_value: default_7,
        nullable: is_nullable_7,
        struct: struct_module_7
    ] = field_7 |> elem(2)

    [
        field: field_name_8,
        type_guard: guard_8,
        default_value: default_8,
        nullable: is_nullable_8,
        struct: struct_module_8
    ] = field_8 |> elem(2)

    [
        field: field_name_9,
        type_guard: guard_9,
        default_value: default_9,
        nullable: is_nullable_9,
        struct: struct_module_9
    ] = field_9 |> elem(2)

    [
        field: field_name_10,
        type_guard: guard_10,
        default_value: default_10,
        nullable: is_nullable_10,
        struct: struct_module_10
    ] = field_10 |> elem(2)

    [
        field: field_name_11,
        type_guard: guard_11,
        default_value: default_11,
        nullable: is_nullable_11,
        struct: struct_module_11
    ] = field_11 |> elem(2)

    [
        field: field_name_12,
        type_guard: guard_12,
        default_value: default_12,
        nullable: is_nullable_12,
        struct: struct_module_12
    ] = field_12 |> elem(2)

    [
        field: field_name_13,
        type_guard: guard_13,
        default_value: default_13,
        nullable: is_nullable_13,
        struct: struct_module_13
    ] = field_13 |> elem(2)

    [
        field: field_name_14,
        type_guard: guard_14,
        default_value: default_14,
        nullable: is_nullable_14,
        struct: struct_module_14
    ] = field_14 |> elem(2)

    [
        field: field_name_15,
        type_guard: guard_15,
        default_value: default_15,
        nullable: is_nullable_15,
        struct: struct_module_15
    ] = field_15 |> elem(2)

    [
        field: field_name_16,
        type_guard: guard_16,
        default_value: default_16,
        nullable: is_nullable_16,
        struct: struct_module_16
    ] = field_16 |> elem(2)

    [
        field: field_name_17,
        type_guard: guard_17,
        default_value: default_17,
        nullable: is_nullable_17,
        struct: struct_module_17
    ] = field_17 |> elem(2)

    [
        field: field_name_18,
        type_guard: guard_18,
        default_value: default_18,
        nullable: is_nullable_18,
        struct: struct_module_18
    ] = field_18 |> elem(2)

    [
        field: field_name_19,
        type_guard: guard_19,
        default_value: default_19,
        nullable: is_nullable_19,
        struct: struct_module_19
    ] = field_19 |> elem(2)

    [
        field: field_name_20,
        type_guard: guard_20,
        default_value: default_20,
        nullable: is_nullable_20,
        struct: struct_module_20
    ] = field_20 |> elem(2)

    [
        field: field_name_21,
        type_guard: guard_21,
        default_value: default_21,
        nullable: is_nullable_21,
        struct: struct_module_21
    ] = field_21 |> elem(2)

    [
        field: field_name_22,
        type_guard: guard_22,
        default_value: default_22,
        nullable: is_nullable_22,
        struct: struct_module_22
    ] = field_22 |> elem(2)

    [
        field: field_name_23,
        type_guard: guard_23,
        default_value: default_23,
        nullable: is_nullable_23,
        struct: struct_module_23
    ] = field_23 |> elem(2)

    [
        field: field_name_24,
        type_guard: guard_24,
        default_value: default_24,
        nullable: is_nullable_24,
        struct: struct_module_24
    ] = field_24 |> elem(2)

    [
        field: field_name_25,
        type_guard: guard_25,
        default_value: default_25,
        nullable: is_nullable_25,
        struct: struct_module_25
    ] = field_25 |> elem(2)

    [
        field: field_name_26,
        type_guard: guard_26,
        default_value: default_26,
        nullable: is_nullable_26,
        struct: struct_module_26
    ] = field_26 |> elem(2)

    [
        field: field_name_27,
        type_guard: guard_27,
        default_value: default_27,
        nullable: is_nullable_27,
        struct: struct_module_27
    ] = field_27 |> elem(2)


    quote do
      defstruct [
        "#{unquote(field_name_1)}": unquote(default_1),
        "#{unquote(field_name_2)}": unquote(default_2),
        "#{unquote(field_name_3)}": unquote(default_3),
        "#{unquote(field_name_4)}": unquote(default_4),
        "#{unquote(field_name_5)}": unquote(default_5),
        "#{unquote(field_name_6)}": unquote(default_6),
        "#{unquote(field_name_7)}": unquote(default_7),
        "#{unquote(field_name_8)}": unquote(default_8),
        "#{unquote(field_name_9)}": unquote(default_9),
        "#{unquote(field_name_10)}": unquote(default_10),
        "#{unquote(field_name_11)}": unquote(default_11),
        "#{unquote(field_name_12)}": unquote(default_12),
        "#{unquote(field_name_13)}": unquote(default_13),
        "#{unquote(field_name_14)}": unquote(default_14),
        "#{unquote(field_name_15)}": unquote(default_15),
        "#{unquote(field_name_16)}": unquote(default_16),
        "#{unquote(field_name_17)}": unquote(default_17),
        "#{unquote(field_name_18)}": unquote(default_18),
        "#{unquote(field_name_19)}": unquote(default_19),
        "#{unquote(field_name_20)}": unquote(default_20),
        "#{unquote(field_name_21)}": unquote(default_21),
        "#{unquote(field_name_22)}": unquote(default_22),
        "#{unquote(field_name_23)}": unquote(default_23),
        "#{unquote(field_name_24)}": unquote(default_24),
        "#{unquote(field_name_25)}": unquote(default_25),
        "#{unquote(field_name_26)}": unquote(default_26),
        "#{unquote(field_name_27)}": unquote(default_27)
      ]

      defp validate_field(field_name, field_value, struct_module, is_nullable, guard) do
        (Code.ensure_compiled(struct_module) |> elem(0) === :module and is_struct(field_value, struct_module))
            or (is_nullable === true and field_value === nil)
            or apply(Kernel, guard, [field_value])
      end

      def constructor(values) do
        is_params_valid =
        validate_field(unquote(field_name_1), values[unquote(field_name_1)], unquote(struct_module_1), unquote(is_nullable_1), unquote(guard_1)) and
        validate_field(unquote(field_name_2), values[unquote(field_name_2)], unquote(struct_module_2), unquote(is_nullable_2), unquote(guard_2)) and
        validate_field(unquote(field_name_3), values[unquote(field_name_3)], unquote(struct_module_3), unquote(is_nullable_3), unquote(guard_3)) and
        validate_field(unquote(field_name_4), values[unquote(field_name_4)], unquote(struct_module_4), unquote(is_nullable_4), unquote(guard_4)) and
        validate_field(unquote(field_name_5), values[unquote(field_name_5)], unquote(struct_module_5), unquote(is_nullable_5), unquote(guard_5)) and
        validate_field(unquote(field_name_6), values[unquote(field_name_6)], unquote(struct_module_6), unquote(is_nullable_6), unquote(guard_6)) and
        validate_field(unquote(field_name_7), values[unquote(field_name_7)], unquote(struct_module_7), unquote(is_nullable_7), unquote(guard_7)) and
        validate_field(unquote(field_name_8), values[unquote(field_name_8)], unquote(struct_module_8), unquote(is_nullable_8), unquote(guard_8)) and
        validate_field(unquote(field_name_9), values[unquote(field_name_9)], unquote(struct_module_9), unquote(is_nullable_9), unquote(guard_9)) and
        validate_field(unquote(field_name_10), values[unquote(field_name_10)], unquote(struct_module_10), unquote(is_nullable_10), unquote(guard_10)) and
        validate_field(unquote(field_name_11), values[unquote(field_name_11)], unquote(struct_module_11), unquote(is_nullable_11), unquote(guard_11)) and
        validate_field(unquote(field_name_12), values[unquote(field_name_12)], unquote(struct_module_12), unquote(is_nullable_12), unquote(guard_12)) and
        validate_field(unquote(field_name_13), values[unquote(field_name_13)], unquote(struct_module_13), unquote(is_nullable_13), unquote(guard_13)) and
        validate_field(unquote(field_name_14), values[unquote(field_name_14)], unquote(struct_module_14), unquote(is_nullable_14), unquote(guard_14)) and
        validate_field(unquote(field_name_15), values[unquote(field_name_15)], unquote(struct_module_15), unquote(is_nullable_15), unquote(guard_15)) and
        validate_field(unquote(field_name_16), values[unquote(field_name_16)], unquote(struct_module_16), unquote(is_nullable_16), unquote(guard_16)) and
        validate_field(unquote(field_name_17), values[unquote(field_name_17)], unquote(struct_module_17), unquote(is_nullable_17), unquote(guard_17)) and
        validate_field(unquote(field_name_18), values[unquote(field_name_18)], unquote(struct_module_18), unquote(is_nullable_18), unquote(guard_18)) and
        validate_field(unquote(field_name_19), values[unquote(field_name_19)], unquote(struct_module_19), unquote(is_nullable_19), unquote(guard_19)) and
        validate_field(unquote(field_name_20), values[unquote(field_name_20)], unquote(struct_module_20), unquote(is_nullable_20), unquote(guard_20)) and
        validate_field(unquote(field_name_21), values[unquote(field_name_21)], unquote(struct_module_21), unquote(is_nullable_21), unquote(guard_21)) and
        validate_field(unquote(field_name_22), values[unquote(field_name_22)], unquote(struct_module_22), unquote(is_nullable_22), unquote(guard_22)) and
        validate_field(unquote(field_name_23), values[unquote(field_name_23)], unquote(struct_module_23), unquote(is_nullable_23), unquote(guard_23)) and
        validate_field(unquote(field_name_24), values[unquote(field_name_24)], unquote(struct_module_24), unquote(is_nullable_24), unquote(guard_24)) and
        validate_field(unquote(field_name_25), values[unquote(field_name_25)], unquote(struct_module_25), unquote(is_nullable_25), unquote(guard_25)) and
        validate_field(unquote(field_name_26), values[unquote(field_name_26)], unquote(struct_module_26), unquote(is_nullable_26), unquote(guard_26)) and
        validate_field(unquote(field_name_27), values[unquote(field_name_27)], unquote(struct_module_27), unquote(is_nullable_27), unquote(guard_27))

        if is_params_valid === false do
          raise "type mismatch for constructor paramater(s) or required parameters are missing"
        end

        result = %{
            "#{unquote(field_name_1)}": values[unquote(field_name_1)],
            "#{unquote(field_name_2)}": values[unquote(field_name_2)],
            "#{unquote(field_name_3)}": values[unquote(field_name_3)],
            "#{unquote(field_name_4)}": values[unquote(field_name_4)],
            "#{unquote(field_name_5)}": values[unquote(field_name_5)],
            "#{unquote(field_name_6)}": values[unquote(field_name_6)],
            "#{unquote(field_name_7)}": values[unquote(field_name_7)],
            "#{unquote(field_name_8)}": values[unquote(field_name_8)],
            "#{unquote(field_name_9)}": values[unquote(field_name_9)],
            "#{unquote(field_name_10)}": values[unquote(field_name_10)],
            "#{unquote(field_name_11)}": values[unquote(field_name_11)],
            "#{unquote(field_name_12)}": values[unquote(field_name_12)],
            "#{unquote(field_name_13)}": values[unquote(field_name_13)],
            "#{unquote(field_name_14)}": values[unquote(field_name_14)],
            "#{unquote(field_name_15)}": values[unquote(field_name_15)],
            "#{unquote(field_name_16)}": values[unquote(field_name_16)],
            "#{unquote(field_name_17)}": values[unquote(field_name_17)],
            "#{unquote(field_name_18)}": values[unquote(field_name_18)],
            "#{unquote(field_name_19)}": values[unquote(field_name_19)],
            "#{unquote(field_name_20)}": values[unquote(field_name_20)],
            "#{unquote(field_name_21)}": values[unquote(field_name_21)],
            "#{unquote(field_name_22)}": values[unquote(field_name_22)],
            "#{unquote(field_name_23)}": values[unquote(field_name_23)],
            "#{unquote(field_name_24)}": values[unquote(field_name_24)],
            "#{unquote(field_name_25)}": values[unquote(field_name_25)],
            "#{unquote(field_name_26)}": values[unquote(field_name_26)],
            "#{unquote(field_name_27)}": values[unquote(field_name_27)]
        }
        struct(unquote(module), result)
      end


      def unquote(field_name_1)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_1))
      end

      if is_nil(unquote(struct_module_1)) === true do
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or unquote(guard_1)(value) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      else
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or is_struct(value, unquote(struct_module_1)) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      end
      def unquote(field_name_2)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_2))
      end

      if is_nil(unquote(struct_module_2)) === true do
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or unquote(guard_2)(value) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      else
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or is_struct(value, unquote(struct_module_2)) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      end
      def unquote(field_name_3)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_3))
      end

      if is_nil(unquote(struct_module_3)) === true do
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or unquote(guard_3)(value) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      else
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or is_struct(value, unquote(struct_module_3)) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      end
      def unquote(field_name_4)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_4))
      end

      if is_nil(unquote(struct_module_4)) === true do
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or unquote(guard_4)(value) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      else
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or is_struct(value, unquote(struct_module_4)) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      end
      def unquote(field_name_5)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_5))
      end

      if is_nil(unquote(struct_module_5)) === true do
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or unquote(guard_5)(value) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      else
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or is_struct(value, unquote(struct_module_5)) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      end
      def unquote(field_name_6)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_6))
      end

      if is_nil(unquote(struct_module_6)) === true do
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or unquote(guard_6)(value) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      else
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or is_struct(value, unquote(struct_module_6)) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      end
      def unquote(field_name_7)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_7))
      end

      if is_nil(unquote(struct_module_7)) === true do
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or unquote(guard_7)(value) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      else
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or is_struct(value, unquote(struct_module_7)) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      end
      def unquote(field_name_8)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_8))
      end

      if is_nil(unquote(struct_module_8)) === true do
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or unquote(guard_8)(value) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      else
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or is_struct(value, unquote(struct_module_8)) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      end
      def unquote(field_name_9)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_9))
      end

      if is_nil(unquote(struct_module_9)) === true do
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or unquote(guard_9)(value) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      else
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or is_struct(value, unquote(struct_module_9)) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      end
      def unquote(field_name_10)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_10))
      end

      if is_nil(unquote(struct_module_10)) === true do
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or unquote(guard_10)(value) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      else
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or is_struct(value, unquote(struct_module_10)) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      end
      def unquote(field_name_11)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_11))
      end

      if is_nil(unquote(struct_module_11)) === true do
        def unquote(field_name_11)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_11)) or unquote(guard_11)(value) do
          %{struct_instance | "#{unquote(field_name_11)}": value}
        end
      else
        def unquote(field_name_11)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_11)) or is_struct(value, unquote(struct_module_11)) do
          %{struct_instance | "#{unquote(field_name_11)}": value}
        end
      end
      def unquote(field_name_12)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_12))
      end

      if is_nil(unquote(struct_module_12)) === true do
        def unquote(field_name_12)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_12)) or unquote(guard_12)(value) do
          %{struct_instance | "#{unquote(field_name_12)}": value}
        end
      else
        def unquote(field_name_12)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_12)) or is_struct(value, unquote(struct_module_12)) do
          %{struct_instance | "#{unquote(field_name_12)}": value}
        end
      end
      def unquote(field_name_13)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_13))
      end

      if is_nil(unquote(struct_module_13)) === true do
        def unquote(field_name_13)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_13)) or unquote(guard_13)(value) do
          %{struct_instance | "#{unquote(field_name_13)}": value}
        end
      else
        def unquote(field_name_13)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_13)) or is_struct(value, unquote(struct_module_13)) do
          %{struct_instance | "#{unquote(field_name_13)}": value}
        end
      end
      def unquote(field_name_14)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_14))
      end

      if is_nil(unquote(struct_module_14)) === true do
        def unquote(field_name_14)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_14)) or unquote(guard_14)(value) do
          %{struct_instance | "#{unquote(field_name_14)}": value}
        end
      else
        def unquote(field_name_14)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_14)) or is_struct(value, unquote(struct_module_14)) do
          %{struct_instance | "#{unquote(field_name_14)}": value}
        end
      end
      def unquote(field_name_15)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_15))
      end

      if is_nil(unquote(struct_module_15)) === true do
        def unquote(field_name_15)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_15)) or unquote(guard_15)(value) do
          %{struct_instance | "#{unquote(field_name_15)}": value}
        end
      else
        def unquote(field_name_15)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_15)) or is_struct(value, unquote(struct_module_15)) do
          %{struct_instance | "#{unquote(field_name_15)}": value}
        end
      end
      def unquote(field_name_16)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_16))
      end

      if is_nil(unquote(struct_module_16)) === true do
        def unquote(field_name_16)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_16)) or unquote(guard_16)(value) do
          %{struct_instance | "#{unquote(field_name_16)}": value}
        end
      else
        def unquote(field_name_16)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_16)) or is_struct(value, unquote(struct_module_16)) do
          %{struct_instance | "#{unquote(field_name_16)}": value}
        end
      end
      def unquote(field_name_17)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_17))
      end

      if is_nil(unquote(struct_module_17)) === true do
        def unquote(field_name_17)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_17)) or unquote(guard_17)(value) do
          %{struct_instance | "#{unquote(field_name_17)}": value}
        end
      else
        def unquote(field_name_17)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_17)) or is_struct(value, unquote(struct_module_17)) do
          %{struct_instance | "#{unquote(field_name_17)}": value}
        end
      end
      def unquote(field_name_18)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_18))
      end

      if is_nil(unquote(struct_module_18)) === true do
        def unquote(field_name_18)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_18)) or unquote(guard_18)(value) do
          %{struct_instance | "#{unquote(field_name_18)}": value}
        end
      else
        def unquote(field_name_18)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_18)) or is_struct(value, unquote(struct_module_18)) do
          %{struct_instance | "#{unquote(field_name_18)}": value}
        end
      end
      def unquote(field_name_19)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_19))
      end

      if is_nil(unquote(struct_module_19)) === true do
        def unquote(field_name_19)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_19)) or unquote(guard_19)(value) do
          %{struct_instance | "#{unquote(field_name_19)}": value}
        end
      else
        def unquote(field_name_19)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_19)) or is_struct(value, unquote(struct_module_19)) do
          %{struct_instance | "#{unquote(field_name_19)}": value}
        end
      end
      def unquote(field_name_20)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_20))
      end

      if is_nil(unquote(struct_module_20)) === true do
        def unquote(field_name_20)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_20)) or unquote(guard_20)(value) do
          %{struct_instance | "#{unquote(field_name_20)}": value}
        end
      else
        def unquote(field_name_20)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_20)) or is_struct(value, unquote(struct_module_20)) do
          %{struct_instance | "#{unquote(field_name_20)}": value}
        end
      end
      def unquote(field_name_21)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_21))
      end

      if is_nil(unquote(struct_module_21)) === true do
        def unquote(field_name_21)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_21)) or unquote(guard_21)(value) do
          %{struct_instance | "#{unquote(field_name_21)}": value}
        end
      else
        def unquote(field_name_21)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_21)) or is_struct(value, unquote(struct_module_21)) do
          %{struct_instance | "#{unquote(field_name_21)}": value}
        end
      end
      def unquote(field_name_22)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_22))
      end

      if is_nil(unquote(struct_module_22)) === true do
        def unquote(field_name_22)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_22)) or unquote(guard_22)(value) do
          %{struct_instance | "#{unquote(field_name_22)}": value}
        end
      else
        def unquote(field_name_22)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_22)) or is_struct(value, unquote(struct_module_22)) do
          %{struct_instance | "#{unquote(field_name_22)}": value}
        end
      end
      def unquote(field_name_23)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_23))
      end

      if is_nil(unquote(struct_module_23)) === true do
        def unquote(field_name_23)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_23)) or unquote(guard_23)(value) do
          %{struct_instance | "#{unquote(field_name_23)}": value}
        end
      else
        def unquote(field_name_23)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_23)) or is_struct(value, unquote(struct_module_23)) do
          %{struct_instance | "#{unquote(field_name_23)}": value}
        end
      end
      def unquote(field_name_24)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_24))
      end

      if is_nil(unquote(struct_module_24)) === true do
        def unquote(field_name_24)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_24)) or unquote(guard_24)(value) do
          %{struct_instance | "#{unquote(field_name_24)}": value}
        end
      else
        def unquote(field_name_24)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_24)) or is_struct(value, unquote(struct_module_24)) do
          %{struct_instance | "#{unquote(field_name_24)}": value}
        end
      end
      def unquote(field_name_25)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_25))
      end

      if is_nil(unquote(struct_module_25)) === true do
        def unquote(field_name_25)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_25)) or unquote(guard_25)(value) do
          %{struct_instance | "#{unquote(field_name_25)}": value}
        end
      else
        def unquote(field_name_25)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_25)) or is_struct(value, unquote(struct_module_25)) do
          %{struct_instance | "#{unquote(field_name_25)}": value}
        end
      end
      def unquote(field_name_26)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_26))
      end

      if is_nil(unquote(struct_module_26)) === true do
        def unquote(field_name_26)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_26)) or unquote(guard_26)(value) do
          %{struct_instance | "#{unquote(field_name_26)}": value}
        end
      else
        def unquote(field_name_26)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_26)) or is_struct(value, unquote(struct_module_26)) do
          %{struct_instance | "#{unquote(field_name_26)}": value}
        end
      end
      def unquote(field_name_27)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_27))
      end

      if is_nil(unquote(struct_module_27)) === true do
        def unquote(field_name_27)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_27)) or unquote(guard_27)(value) do
          %{struct_instance | "#{unquote(field_name_27)}": value}
        end
      else
        def unquote(field_name_27)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_27)) or is_struct(value, unquote(struct_module_27)) do
          %{struct_instance | "#{unquote(field_name_27)}": value}
        end
      end
    end
  end




  @doc"""
  Generates a struct, complete with a constructor, getter and setter methods.

  Macro usage example:
      ```
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
        nullable: false,
        struct: nil
      },
      %{
        field: :hair_details,
        type_guard: :is_struct,
        default_value: %Hair{},
        nullable: true,
        struct: Hair
      })
      ```
  """
  defmacro generate_constructor(module, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9, field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19, field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28) do

    [
        field: field_name_1,
        type_guard: guard_1,
        default_value: default_1,
        nullable: is_nullable_1,
        struct: struct_module_1
    ] = field_1 |> elem(2)

    [
        field: field_name_2,
        type_guard: guard_2,
        default_value: default_2,
        nullable: is_nullable_2,
        struct: struct_module_2
    ] = field_2 |> elem(2)

    [
        field: field_name_3,
        type_guard: guard_3,
        default_value: default_3,
        nullable: is_nullable_3,
        struct: struct_module_3
    ] = field_3 |> elem(2)

    [
        field: field_name_4,
        type_guard: guard_4,
        default_value: default_4,
        nullable: is_nullable_4,
        struct: struct_module_4
    ] = field_4 |> elem(2)

    [
        field: field_name_5,
        type_guard: guard_5,
        default_value: default_5,
        nullable: is_nullable_5,
        struct: struct_module_5
    ] = field_5 |> elem(2)

    [
        field: field_name_6,
        type_guard: guard_6,
        default_value: default_6,
        nullable: is_nullable_6,
        struct: struct_module_6
    ] = field_6 |> elem(2)

    [
        field: field_name_7,
        type_guard: guard_7,
        default_value: default_7,
        nullable: is_nullable_7,
        struct: struct_module_7
    ] = field_7 |> elem(2)

    [
        field: field_name_8,
        type_guard: guard_8,
        default_value: default_8,
        nullable: is_nullable_8,
        struct: struct_module_8
    ] = field_8 |> elem(2)

    [
        field: field_name_9,
        type_guard: guard_9,
        default_value: default_9,
        nullable: is_nullable_9,
        struct: struct_module_9
    ] = field_9 |> elem(2)

    [
        field: field_name_10,
        type_guard: guard_10,
        default_value: default_10,
        nullable: is_nullable_10,
        struct: struct_module_10
    ] = field_10 |> elem(2)

    [
        field: field_name_11,
        type_guard: guard_11,
        default_value: default_11,
        nullable: is_nullable_11,
        struct: struct_module_11
    ] = field_11 |> elem(2)

    [
        field: field_name_12,
        type_guard: guard_12,
        default_value: default_12,
        nullable: is_nullable_12,
        struct: struct_module_12
    ] = field_12 |> elem(2)

    [
        field: field_name_13,
        type_guard: guard_13,
        default_value: default_13,
        nullable: is_nullable_13,
        struct: struct_module_13
    ] = field_13 |> elem(2)

    [
        field: field_name_14,
        type_guard: guard_14,
        default_value: default_14,
        nullable: is_nullable_14,
        struct: struct_module_14
    ] = field_14 |> elem(2)

    [
        field: field_name_15,
        type_guard: guard_15,
        default_value: default_15,
        nullable: is_nullable_15,
        struct: struct_module_15
    ] = field_15 |> elem(2)

    [
        field: field_name_16,
        type_guard: guard_16,
        default_value: default_16,
        nullable: is_nullable_16,
        struct: struct_module_16
    ] = field_16 |> elem(2)

    [
        field: field_name_17,
        type_guard: guard_17,
        default_value: default_17,
        nullable: is_nullable_17,
        struct: struct_module_17
    ] = field_17 |> elem(2)

    [
        field: field_name_18,
        type_guard: guard_18,
        default_value: default_18,
        nullable: is_nullable_18,
        struct: struct_module_18
    ] = field_18 |> elem(2)

    [
        field: field_name_19,
        type_guard: guard_19,
        default_value: default_19,
        nullable: is_nullable_19,
        struct: struct_module_19
    ] = field_19 |> elem(2)

    [
        field: field_name_20,
        type_guard: guard_20,
        default_value: default_20,
        nullable: is_nullable_20,
        struct: struct_module_20
    ] = field_20 |> elem(2)

    [
        field: field_name_21,
        type_guard: guard_21,
        default_value: default_21,
        nullable: is_nullable_21,
        struct: struct_module_21
    ] = field_21 |> elem(2)

    [
        field: field_name_22,
        type_guard: guard_22,
        default_value: default_22,
        nullable: is_nullable_22,
        struct: struct_module_22
    ] = field_22 |> elem(2)

    [
        field: field_name_23,
        type_guard: guard_23,
        default_value: default_23,
        nullable: is_nullable_23,
        struct: struct_module_23
    ] = field_23 |> elem(2)

    [
        field: field_name_24,
        type_guard: guard_24,
        default_value: default_24,
        nullable: is_nullable_24,
        struct: struct_module_24
    ] = field_24 |> elem(2)

    [
        field: field_name_25,
        type_guard: guard_25,
        default_value: default_25,
        nullable: is_nullable_25,
        struct: struct_module_25
    ] = field_25 |> elem(2)

    [
        field: field_name_26,
        type_guard: guard_26,
        default_value: default_26,
        nullable: is_nullable_26,
        struct: struct_module_26
    ] = field_26 |> elem(2)

    [
        field: field_name_27,
        type_guard: guard_27,
        default_value: default_27,
        nullable: is_nullable_27,
        struct: struct_module_27
    ] = field_27 |> elem(2)

    [
        field: field_name_28,
        type_guard: guard_28,
        default_value: default_28,
        nullable: is_nullable_28,
        struct: struct_module_28
    ] = field_28 |> elem(2)


    quote do
      defstruct [
        "#{unquote(field_name_1)}": unquote(default_1),
        "#{unquote(field_name_2)}": unquote(default_2),
        "#{unquote(field_name_3)}": unquote(default_3),
        "#{unquote(field_name_4)}": unquote(default_4),
        "#{unquote(field_name_5)}": unquote(default_5),
        "#{unquote(field_name_6)}": unquote(default_6),
        "#{unquote(field_name_7)}": unquote(default_7),
        "#{unquote(field_name_8)}": unquote(default_8),
        "#{unquote(field_name_9)}": unquote(default_9),
        "#{unquote(field_name_10)}": unquote(default_10),
        "#{unquote(field_name_11)}": unquote(default_11),
        "#{unquote(field_name_12)}": unquote(default_12),
        "#{unquote(field_name_13)}": unquote(default_13),
        "#{unquote(field_name_14)}": unquote(default_14),
        "#{unquote(field_name_15)}": unquote(default_15),
        "#{unquote(field_name_16)}": unquote(default_16),
        "#{unquote(field_name_17)}": unquote(default_17),
        "#{unquote(field_name_18)}": unquote(default_18),
        "#{unquote(field_name_19)}": unquote(default_19),
        "#{unquote(field_name_20)}": unquote(default_20),
        "#{unquote(field_name_21)}": unquote(default_21),
        "#{unquote(field_name_22)}": unquote(default_22),
        "#{unquote(field_name_23)}": unquote(default_23),
        "#{unquote(field_name_24)}": unquote(default_24),
        "#{unquote(field_name_25)}": unquote(default_25),
        "#{unquote(field_name_26)}": unquote(default_26),
        "#{unquote(field_name_27)}": unquote(default_27),
        "#{unquote(field_name_28)}": unquote(default_28)
      ]

      defp validate_field(field_name, field_value, struct_module, is_nullable, guard) do
        (Code.ensure_compiled(struct_module) |> elem(0) === :module and is_struct(field_value, struct_module))
            or (is_nullable === true and field_value === nil)
            or apply(Kernel, guard, [field_value])
      end

      def constructor(values) do
        is_params_valid =
        validate_field(unquote(field_name_1), values[unquote(field_name_1)], unquote(struct_module_1), unquote(is_nullable_1), unquote(guard_1)) and
        validate_field(unquote(field_name_2), values[unquote(field_name_2)], unquote(struct_module_2), unquote(is_nullable_2), unquote(guard_2)) and
        validate_field(unquote(field_name_3), values[unquote(field_name_3)], unquote(struct_module_3), unquote(is_nullable_3), unquote(guard_3)) and
        validate_field(unquote(field_name_4), values[unquote(field_name_4)], unquote(struct_module_4), unquote(is_nullable_4), unquote(guard_4)) and
        validate_field(unquote(field_name_5), values[unquote(field_name_5)], unquote(struct_module_5), unquote(is_nullable_5), unquote(guard_5)) and
        validate_field(unquote(field_name_6), values[unquote(field_name_6)], unquote(struct_module_6), unquote(is_nullable_6), unquote(guard_6)) and
        validate_field(unquote(field_name_7), values[unquote(field_name_7)], unquote(struct_module_7), unquote(is_nullable_7), unquote(guard_7)) and
        validate_field(unquote(field_name_8), values[unquote(field_name_8)], unquote(struct_module_8), unquote(is_nullable_8), unquote(guard_8)) and
        validate_field(unquote(field_name_9), values[unquote(field_name_9)], unquote(struct_module_9), unquote(is_nullable_9), unquote(guard_9)) and
        validate_field(unquote(field_name_10), values[unquote(field_name_10)], unquote(struct_module_10), unquote(is_nullable_10), unquote(guard_10)) and
        validate_field(unquote(field_name_11), values[unquote(field_name_11)], unquote(struct_module_11), unquote(is_nullable_11), unquote(guard_11)) and
        validate_field(unquote(field_name_12), values[unquote(field_name_12)], unquote(struct_module_12), unquote(is_nullable_12), unquote(guard_12)) and
        validate_field(unquote(field_name_13), values[unquote(field_name_13)], unquote(struct_module_13), unquote(is_nullable_13), unquote(guard_13)) and
        validate_field(unquote(field_name_14), values[unquote(field_name_14)], unquote(struct_module_14), unquote(is_nullable_14), unquote(guard_14)) and
        validate_field(unquote(field_name_15), values[unquote(field_name_15)], unquote(struct_module_15), unquote(is_nullable_15), unquote(guard_15)) and
        validate_field(unquote(field_name_16), values[unquote(field_name_16)], unquote(struct_module_16), unquote(is_nullable_16), unquote(guard_16)) and
        validate_field(unquote(field_name_17), values[unquote(field_name_17)], unquote(struct_module_17), unquote(is_nullable_17), unquote(guard_17)) and
        validate_field(unquote(field_name_18), values[unquote(field_name_18)], unquote(struct_module_18), unquote(is_nullable_18), unquote(guard_18)) and
        validate_field(unquote(field_name_19), values[unquote(field_name_19)], unquote(struct_module_19), unquote(is_nullable_19), unquote(guard_19)) and
        validate_field(unquote(field_name_20), values[unquote(field_name_20)], unquote(struct_module_20), unquote(is_nullable_20), unquote(guard_20)) and
        validate_field(unquote(field_name_21), values[unquote(field_name_21)], unquote(struct_module_21), unquote(is_nullable_21), unquote(guard_21)) and
        validate_field(unquote(field_name_22), values[unquote(field_name_22)], unquote(struct_module_22), unquote(is_nullable_22), unquote(guard_22)) and
        validate_field(unquote(field_name_23), values[unquote(field_name_23)], unquote(struct_module_23), unquote(is_nullable_23), unquote(guard_23)) and
        validate_field(unquote(field_name_24), values[unquote(field_name_24)], unquote(struct_module_24), unquote(is_nullable_24), unquote(guard_24)) and
        validate_field(unquote(field_name_25), values[unquote(field_name_25)], unquote(struct_module_25), unquote(is_nullable_25), unquote(guard_25)) and
        validate_field(unquote(field_name_26), values[unquote(field_name_26)], unquote(struct_module_26), unquote(is_nullable_26), unquote(guard_26)) and
        validate_field(unquote(field_name_27), values[unquote(field_name_27)], unquote(struct_module_27), unquote(is_nullable_27), unquote(guard_27)) and
        validate_field(unquote(field_name_28), values[unquote(field_name_28)], unquote(struct_module_28), unquote(is_nullable_28), unquote(guard_28))

        if is_params_valid === false do
          raise "type mismatch for constructor paramater(s) or required parameters are missing"
        end

        result = %{
            "#{unquote(field_name_1)}": values[unquote(field_name_1)],
            "#{unquote(field_name_2)}": values[unquote(field_name_2)],
            "#{unquote(field_name_3)}": values[unquote(field_name_3)],
            "#{unquote(field_name_4)}": values[unquote(field_name_4)],
            "#{unquote(field_name_5)}": values[unquote(field_name_5)],
            "#{unquote(field_name_6)}": values[unquote(field_name_6)],
            "#{unquote(field_name_7)}": values[unquote(field_name_7)],
            "#{unquote(field_name_8)}": values[unquote(field_name_8)],
            "#{unquote(field_name_9)}": values[unquote(field_name_9)],
            "#{unquote(field_name_10)}": values[unquote(field_name_10)],
            "#{unquote(field_name_11)}": values[unquote(field_name_11)],
            "#{unquote(field_name_12)}": values[unquote(field_name_12)],
            "#{unquote(field_name_13)}": values[unquote(field_name_13)],
            "#{unquote(field_name_14)}": values[unquote(field_name_14)],
            "#{unquote(field_name_15)}": values[unquote(field_name_15)],
            "#{unquote(field_name_16)}": values[unquote(field_name_16)],
            "#{unquote(field_name_17)}": values[unquote(field_name_17)],
            "#{unquote(field_name_18)}": values[unquote(field_name_18)],
            "#{unquote(field_name_19)}": values[unquote(field_name_19)],
            "#{unquote(field_name_20)}": values[unquote(field_name_20)],
            "#{unquote(field_name_21)}": values[unquote(field_name_21)],
            "#{unquote(field_name_22)}": values[unquote(field_name_22)],
            "#{unquote(field_name_23)}": values[unquote(field_name_23)],
            "#{unquote(field_name_24)}": values[unquote(field_name_24)],
            "#{unquote(field_name_25)}": values[unquote(field_name_25)],
            "#{unquote(field_name_26)}": values[unquote(field_name_26)],
            "#{unquote(field_name_27)}": values[unquote(field_name_27)],
            "#{unquote(field_name_28)}": values[unquote(field_name_28)]
        }
        struct(unquote(module), result)
      end


      def unquote(field_name_1)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_1))
      end

      if is_nil(unquote(struct_module_1)) === true do
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or unquote(guard_1)(value) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      else
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or is_struct(value, unquote(struct_module_1)) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      end
      def unquote(field_name_2)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_2))
      end

      if is_nil(unquote(struct_module_2)) === true do
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or unquote(guard_2)(value) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      else
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or is_struct(value, unquote(struct_module_2)) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      end
      def unquote(field_name_3)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_3))
      end

      if is_nil(unquote(struct_module_3)) === true do
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or unquote(guard_3)(value) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      else
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or is_struct(value, unquote(struct_module_3)) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      end
      def unquote(field_name_4)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_4))
      end

      if is_nil(unquote(struct_module_4)) === true do
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or unquote(guard_4)(value) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      else
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or is_struct(value, unquote(struct_module_4)) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      end
      def unquote(field_name_5)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_5))
      end

      if is_nil(unquote(struct_module_5)) === true do
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or unquote(guard_5)(value) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      else
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or is_struct(value, unquote(struct_module_5)) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      end
      def unquote(field_name_6)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_6))
      end

      if is_nil(unquote(struct_module_6)) === true do
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or unquote(guard_6)(value) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      else
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or is_struct(value, unquote(struct_module_6)) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      end
      def unquote(field_name_7)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_7))
      end

      if is_nil(unquote(struct_module_7)) === true do
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or unquote(guard_7)(value) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      else
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or is_struct(value, unquote(struct_module_7)) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      end
      def unquote(field_name_8)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_8))
      end

      if is_nil(unquote(struct_module_8)) === true do
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or unquote(guard_8)(value) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      else
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or is_struct(value, unquote(struct_module_8)) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      end
      def unquote(field_name_9)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_9))
      end

      if is_nil(unquote(struct_module_9)) === true do
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or unquote(guard_9)(value) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      else
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or is_struct(value, unquote(struct_module_9)) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      end
      def unquote(field_name_10)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_10))
      end

      if is_nil(unquote(struct_module_10)) === true do
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or unquote(guard_10)(value) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      else
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or is_struct(value, unquote(struct_module_10)) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      end
      def unquote(field_name_11)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_11))
      end

      if is_nil(unquote(struct_module_11)) === true do
        def unquote(field_name_11)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_11)) or unquote(guard_11)(value) do
          %{struct_instance | "#{unquote(field_name_11)}": value}
        end
      else
        def unquote(field_name_11)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_11)) or is_struct(value, unquote(struct_module_11)) do
          %{struct_instance | "#{unquote(field_name_11)}": value}
        end
      end
      def unquote(field_name_12)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_12))
      end

      if is_nil(unquote(struct_module_12)) === true do
        def unquote(field_name_12)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_12)) or unquote(guard_12)(value) do
          %{struct_instance | "#{unquote(field_name_12)}": value}
        end
      else
        def unquote(field_name_12)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_12)) or is_struct(value, unquote(struct_module_12)) do
          %{struct_instance | "#{unquote(field_name_12)}": value}
        end
      end
      def unquote(field_name_13)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_13))
      end

      if is_nil(unquote(struct_module_13)) === true do
        def unquote(field_name_13)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_13)) or unquote(guard_13)(value) do
          %{struct_instance | "#{unquote(field_name_13)}": value}
        end
      else
        def unquote(field_name_13)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_13)) or is_struct(value, unquote(struct_module_13)) do
          %{struct_instance | "#{unquote(field_name_13)}": value}
        end
      end
      def unquote(field_name_14)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_14))
      end

      if is_nil(unquote(struct_module_14)) === true do
        def unquote(field_name_14)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_14)) or unquote(guard_14)(value) do
          %{struct_instance | "#{unquote(field_name_14)}": value}
        end
      else
        def unquote(field_name_14)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_14)) or is_struct(value, unquote(struct_module_14)) do
          %{struct_instance | "#{unquote(field_name_14)}": value}
        end
      end
      def unquote(field_name_15)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_15))
      end

      if is_nil(unquote(struct_module_15)) === true do
        def unquote(field_name_15)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_15)) or unquote(guard_15)(value) do
          %{struct_instance | "#{unquote(field_name_15)}": value}
        end
      else
        def unquote(field_name_15)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_15)) or is_struct(value, unquote(struct_module_15)) do
          %{struct_instance | "#{unquote(field_name_15)}": value}
        end
      end
      def unquote(field_name_16)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_16))
      end

      if is_nil(unquote(struct_module_16)) === true do
        def unquote(field_name_16)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_16)) or unquote(guard_16)(value) do
          %{struct_instance | "#{unquote(field_name_16)}": value}
        end
      else
        def unquote(field_name_16)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_16)) or is_struct(value, unquote(struct_module_16)) do
          %{struct_instance | "#{unquote(field_name_16)}": value}
        end
      end
      def unquote(field_name_17)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_17))
      end

      if is_nil(unquote(struct_module_17)) === true do
        def unquote(field_name_17)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_17)) or unquote(guard_17)(value) do
          %{struct_instance | "#{unquote(field_name_17)}": value}
        end
      else
        def unquote(field_name_17)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_17)) or is_struct(value, unquote(struct_module_17)) do
          %{struct_instance | "#{unquote(field_name_17)}": value}
        end
      end
      def unquote(field_name_18)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_18))
      end

      if is_nil(unquote(struct_module_18)) === true do
        def unquote(field_name_18)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_18)) or unquote(guard_18)(value) do
          %{struct_instance | "#{unquote(field_name_18)}": value}
        end
      else
        def unquote(field_name_18)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_18)) or is_struct(value, unquote(struct_module_18)) do
          %{struct_instance | "#{unquote(field_name_18)}": value}
        end
      end
      def unquote(field_name_19)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_19))
      end

      if is_nil(unquote(struct_module_19)) === true do
        def unquote(field_name_19)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_19)) or unquote(guard_19)(value) do
          %{struct_instance | "#{unquote(field_name_19)}": value}
        end
      else
        def unquote(field_name_19)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_19)) or is_struct(value, unquote(struct_module_19)) do
          %{struct_instance | "#{unquote(field_name_19)}": value}
        end
      end
      def unquote(field_name_20)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_20))
      end

      if is_nil(unquote(struct_module_20)) === true do
        def unquote(field_name_20)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_20)) or unquote(guard_20)(value) do
          %{struct_instance | "#{unquote(field_name_20)}": value}
        end
      else
        def unquote(field_name_20)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_20)) or is_struct(value, unquote(struct_module_20)) do
          %{struct_instance | "#{unquote(field_name_20)}": value}
        end
      end
      def unquote(field_name_21)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_21))
      end

      if is_nil(unquote(struct_module_21)) === true do
        def unquote(field_name_21)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_21)) or unquote(guard_21)(value) do
          %{struct_instance | "#{unquote(field_name_21)}": value}
        end
      else
        def unquote(field_name_21)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_21)) or is_struct(value, unquote(struct_module_21)) do
          %{struct_instance | "#{unquote(field_name_21)}": value}
        end
      end
      def unquote(field_name_22)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_22))
      end

      if is_nil(unquote(struct_module_22)) === true do
        def unquote(field_name_22)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_22)) or unquote(guard_22)(value) do
          %{struct_instance | "#{unquote(field_name_22)}": value}
        end
      else
        def unquote(field_name_22)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_22)) or is_struct(value, unquote(struct_module_22)) do
          %{struct_instance | "#{unquote(field_name_22)}": value}
        end
      end
      def unquote(field_name_23)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_23))
      end

      if is_nil(unquote(struct_module_23)) === true do
        def unquote(field_name_23)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_23)) or unquote(guard_23)(value) do
          %{struct_instance | "#{unquote(field_name_23)}": value}
        end
      else
        def unquote(field_name_23)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_23)) or is_struct(value, unquote(struct_module_23)) do
          %{struct_instance | "#{unquote(field_name_23)}": value}
        end
      end
      def unquote(field_name_24)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_24))
      end

      if is_nil(unquote(struct_module_24)) === true do
        def unquote(field_name_24)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_24)) or unquote(guard_24)(value) do
          %{struct_instance | "#{unquote(field_name_24)}": value}
        end
      else
        def unquote(field_name_24)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_24)) or is_struct(value, unquote(struct_module_24)) do
          %{struct_instance | "#{unquote(field_name_24)}": value}
        end
      end
      def unquote(field_name_25)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_25))
      end

      if is_nil(unquote(struct_module_25)) === true do
        def unquote(field_name_25)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_25)) or unquote(guard_25)(value) do
          %{struct_instance | "#{unquote(field_name_25)}": value}
        end
      else
        def unquote(field_name_25)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_25)) or is_struct(value, unquote(struct_module_25)) do
          %{struct_instance | "#{unquote(field_name_25)}": value}
        end
      end
      def unquote(field_name_26)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_26))
      end

      if is_nil(unquote(struct_module_26)) === true do
        def unquote(field_name_26)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_26)) or unquote(guard_26)(value) do
          %{struct_instance | "#{unquote(field_name_26)}": value}
        end
      else
        def unquote(field_name_26)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_26)) or is_struct(value, unquote(struct_module_26)) do
          %{struct_instance | "#{unquote(field_name_26)}": value}
        end
      end
      def unquote(field_name_27)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_27))
      end

      if is_nil(unquote(struct_module_27)) === true do
        def unquote(field_name_27)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_27)) or unquote(guard_27)(value) do
          %{struct_instance | "#{unquote(field_name_27)}": value}
        end
      else
        def unquote(field_name_27)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_27)) or is_struct(value, unquote(struct_module_27)) do
          %{struct_instance | "#{unquote(field_name_27)}": value}
        end
      end
      def unquote(field_name_28)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_28))
      end

      if is_nil(unquote(struct_module_28)) === true do
        def unquote(field_name_28)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_28)) or unquote(guard_28)(value) do
          %{struct_instance | "#{unquote(field_name_28)}": value}
        end
      else
        def unquote(field_name_28)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_28)) or is_struct(value, unquote(struct_module_28)) do
          %{struct_instance | "#{unquote(field_name_28)}": value}
        end
      end
    end
  end




  @doc"""
  Generates a struct, complete with a constructor, getter and setter methods.

  Macro usage example:
      ```
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
        nullable: false,
        struct: nil
      },
      %{
        field: :hair_details,
        type_guard: :is_struct,
        default_value: %Hair{},
        nullable: true,
        struct: Hair
      })
      ```
  """
  defmacro generate_constructor(module, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9, field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19, field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29) do

    [
        field: field_name_1,
        type_guard: guard_1,
        default_value: default_1,
        nullable: is_nullable_1,
        struct: struct_module_1
    ] = field_1 |> elem(2)

    [
        field: field_name_2,
        type_guard: guard_2,
        default_value: default_2,
        nullable: is_nullable_2,
        struct: struct_module_2
    ] = field_2 |> elem(2)

    [
        field: field_name_3,
        type_guard: guard_3,
        default_value: default_3,
        nullable: is_nullable_3,
        struct: struct_module_3
    ] = field_3 |> elem(2)

    [
        field: field_name_4,
        type_guard: guard_4,
        default_value: default_4,
        nullable: is_nullable_4,
        struct: struct_module_4
    ] = field_4 |> elem(2)

    [
        field: field_name_5,
        type_guard: guard_5,
        default_value: default_5,
        nullable: is_nullable_5,
        struct: struct_module_5
    ] = field_5 |> elem(2)

    [
        field: field_name_6,
        type_guard: guard_6,
        default_value: default_6,
        nullable: is_nullable_6,
        struct: struct_module_6
    ] = field_6 |> elem(2)

    [
        field: field_name_7,
        type_guard: guard_7,
        default_value: default_7,
        nullable: is_nullable_7,
        struct: struct_module_7
    ] = field_7 |> elem(2)

    [
        field: field_name_8,
        type_guard: guard_8,
        default_value: default_8,
        nullable: is_nullable_8,
        struct: struct_module_8
    ] = field_8 |> elem(2)

    [
        field: field_name_9,
        type_guard: guard_9,
        default_value: default_9,
        nullable: is_nullable_9,
        struct: struct_module_9
    ] = field_9 |> elem(2)

    [
        field: field_name_10,
        type_guard: guard_10,
        default_value: default_10,
        nullable: is_nullable_10,
        struct: struct_module_10
    ] = field_10 |> elem(2)

    [
        field: field_name_11,
        type_guard: guard_11,
        default_value: default_11,
        nullable: is_nullable_11,
        struct: struct_module_11
    ] = field_11 |> elem(2)

    [
        field: field_name_12,
        type_guard: guard_12,
        default_value: default_12,
        nullable: is_nullable_12,
        struct: struct_module_12
    ] = field_12 |> elem(2)

    [
        field: field_name_13,
        type_guard: guard_13,
        default_value: default_13,
        nullable: is_nullable_13,
        struct: struct_module_13
    ] = field_13 |> elem(2)

    [
        field: field_name_14,
        type_guard: guard_14,
        default_value: default_14,
        nullable: is_nullable_14,
        struct: struct_module_14
    ] = field_14 |> elem(2)

    [
        field: field_name_15,
        type_guard: guard_15,
        default_value: default_15,
        nullable: is_nullable_15,
        struct: struct_module_15
    ] = field_15 |> elem(2)

    [
        field: field_name_16,
        type_guard: guard_16,
        default_value: default_16,
        nullable: is_nullable_16,
        struct: struct_module_16
    ] = field_16 |> elem(2)

    [
        field: field_name_17,
        type_guard: guard_17,
        default_value: default_17,
        nullable: is_nullable_17,
        struct: struct_module_17
    ] = field_17 |> elem(2)

    [
        field: field_name_18,
        type_guard: guard_18,
        default_value: default_18,
        nullable: is_nullable_18,
        struct: struct_module_18
    ] = field_18 |> elem(2)

    [
        field: field_name_19,
        type_guard: guard_19,
        default_value: default_19,
        nullable: is_nullable_19,
        struct: struct_module_19
    ] = field_19 |> elem(2)

    [
        field: field_name_20,
        type_guard: guard_20,
        default_value: default_20,
        nullable: is_nullable_20,
        struct: struct_module_20
    ] = field_20 |> elem(2)

    [
        field: field_name_21,
        type_guard: guard_21,
        default_value: default_21,
        nullable: is_nullable_21,
        struct: struct_module_21
    ] = field_21 |> elem(2)

    [
        field: field_name_22,
        type_guard: guard_22,
        default_value: default_22,
        nullable: is_nullable_22,
        struct: struct_module_22
    ] = field_22 |> elem(2)

    [
        field: field_name_23,
        type_guard: guard_23,
        default_value: default_23,
        nullable: is_nullable_23,
        struct: struct_module_23
    ] = field_23 |> elem(2)

    [
        field: field_name_24,
        type_guard: guard_24,
        default_value: default_24,
        nullable: is_nullable_24,
        struct: struct_module_24
    ] = field_24 |> elem(2)

    [
        field: field_name_25,
        type_guard: guard_25,
        default_value: default_25,
        nullable: is_nullable_25,
        struct: struct_module_25
    ] = field_25 |> elem(2)

    [
        field: field_name_26,
        type_guard: guard_26,
        default_value: default_26,
        nullable: is_nullable_26,
        struct: struct_module_26
    ] = field_26 |> elem(2)

    [
        field: field_name_27,
        type_guard: guard_27,
        default_value: default_27,
        nullable: is_nullable_27,
        struct: struct_module_27
    ] = field_27 |> elem(2)

    [
        field: field_name_28,
        type_guard: guard_28,
        default_value: default_28,
        nullable: is_nullable_28,
        struct: struct_module_28
    ] = field_28 |> elem(2)

    [
        field: field_name_29,
        type_guard: guard_29,
        default_value: default_29,
        nullable: is_nullable_29,
        struct: struct_module_29
    ] = field_29 |> elem(2)


    quote do
      defstruct [
        "#{unquote(field_name_1)}": unquote(default_1),
        "#{unquote(field_name_2)}": unquote(default_2),
        "#{unquote(field_name_3)}": unquote(default_3),
        "#{unquote(field_name_4)}": unquote(default_4),
        "#{unquote(field_name_5)}": unquote(default_5),
        "#{unquote(field_name_6)}": unquote(default_6),
        "#{unquote(field_name_7)}": unquote(default_7),
        "#{unquote(field_name_8)}": unquote(default_8),
        "#{unquote(field_name_9)}": unquote(default_9),
        "#{unquote(field_name_10)}": unquote(default_10),
        "#{unquote(field_name_11)}": unquote(default_11),
        "#{unquote(field_name_12)}": unquote(default_12),
        "#{unquote(field_name_13)}": unquote(default_13),
        "#{unquote(field_name_14)}": unquote(default_14),
        "#{unquote(field_name_15)}": unquote(default_15),
        "#{unquote(field_name_16)}": unquote(default_16),
        "#{unquote(field_name_17)}": unquote(default_17),
        "#{unquote(field_name_18)}": unquote(default_18),
        "#{unquote(field_name_19)}": unquote(default_19),
        "#{unquote(field_name_20)}": unquote(default_20),
        "#{unquote(field_name_21)}": unquote(default_21),
        "#{unquote(field_name_22)}": unquote(default_22),
        "#{unquote(field_name_23)}": unquote(default_23),
        "#{unquote(field_name_24)}": unquote(default_24),
        "#{unquote(field_name_25)}": unquote(default_25),
        "#{unquote(field_name_26)}": unquote(default_26),
        "#{unquote(field_name_27)}": unquote(default_27),
        "#{unquote(field_name_28)}": unquote(default_28),
        "#{unquote(field_name_29)}": unquote(default_29)
      ]

      defp validate_field(field_name, field_value, struct_module, is_nullable, guard) do
        (Code.ensure_compiled(struct_module) |> elem(0) === :module and is_struct(field_value, struct_module))
            or (is_nullable === true and field_value === nil)
            or apply(Kernel, guard, [field_value])
      end

      def constructor(values) do
        is_params_valid =
        validate_field(unquote(field_name_1), values[unquote(field_name_1)], unquote(struct_module_1), unquote(is_nullable_1), unquote(guard_1)) and
        validate_field(unquote(field_name_2), values[unquote(field_name_2)], unquote(struct_module_2), unquote(is_nullable_2), unquote(guard_2)) and
        validate_field(unquote(field_name_3), values[unquote(field_name_3)], unquote(struct_module_3), unquote(is_nullable_3), unquote(guard_3)) and
        validate_field(unquote(field_name_4), values[unquote(field_name_4)], unquote(struct_module_4), unquote(is_nullable_4), unquote(guard_4)) and
        validate_field(unquote(field_name_5), values[unquote(field_name_5)], unquote(struct_module_5), unquote(is_nullable_5), unquote(guard_5)) and
        validate_field(unquote(field_name_6), values[unquote(field_name_6)], unquote(struct_module_6), unquote(is_nullable_6), unquote(guard_6)) and
        validate_field(unquote(field_name_7), values[unquote(field_name_7)], unquote(struct_module_7), unquote(is_nullable_7), unquote(guard_7)) and
        validate_field(unquote(field_name_8), values[unquote(field_name_8)], unquote(struct_module_8), unquote(is_nullable_8), unquote(guard_8)) and
        validate_field(unquote(field_name_9), values[unquote(field_name_9)], unquote(struct_module_9), unquote(is_nullable_9), unquote(guard_9)) and
        validate_field(unquote(field_name_10), values[unquote(field_name_10)], unquote(struct_module_10), unquote(is_nullable_10), unquote(guard_10)) and
        validate_field(unquote(field_name_11), values[unquote(field_name_11)], unquote(struct_module_11), unquote(is_nullable_11), unquote(guard_11)) and
        validate_field(unquote(field_name_12), values[unquote(field_name_12)], unquote(struct_module_12), unquote(is_nullable_12), unquote(guard_12)) and
        validate_field(unquote(field_name_13), values[unquote(field_name_13)], unquote(struct_module_13), unquote(is_nullable_13), unquote(guard_13)) and
        validate_field(unquote(field_name_14), values[unquote(field_name_14)], unquote(struct_module_14), unquote(is_nullable_14), unquote(guard_14)) and
        validate_field(unquote(field_name_15), values[unquote(field_name_15)], unquote(struct_module_15), unquote(is_nullable_15), unquote(guard_15)) and
        validate_field(unquote(field_name_16), values[unquote(field_name_16)], unquote(struct_module_16), unquote(is_nullable_16), unquote(guard_16)) and
        validate_field(unquote(field_name_17), values[unquote(field_name_17)], unquote(struct_module_17), unquote(is_nullable_17), unquote(guard_17)) and
        validate_field(unquote(field_name_18), values[unquote(field_name_18)], unquote(struct_module_18), unquote(is_nullable_18), unquote(guard_18)) and
        validate_field(unquote(field_name_19), values[unquote(field_name_19)], unquote(struct_module_19), unquote(is_nullable_19), unquote(guard_19)) and
        validate_field(unquote(field_name_20), values[unquote(field_name_20)], unquote(struct_module_20), unquote(is_nullable_20), unquote(guard_20)) and
        validate_field(unquote(field_name_21), values[unquote(field_name_21)], unquote(struct_module_21), unquote(is_nullable_21), unquote(guard_21)) and
        validate_field(unquote(field_name_22), values[unquote(field_name_22)], unquote(struct_module_22), unquote(is_nullable_22), unquote(guard_22)) and
        validate_field(unquote(field_name_23), values[unquote(field_name_23)], unquote(struct_module_23), unquote(is_nullable_23), unquote(guard_23)) and
        validate_field(unquote(field_name_24), values[unquote(field_name_24)], unquote(struct_module_24), unquote(is_nullable_24), unquote(guard_24)) and
        validate_field(unquote(field_name_25), values[unquote(field_name_25)], unquote(struct_module_25), unquote(is_nullable_25), unquote(guard_25)) and
        validate_field(unquote(field_name_26), values[unquote(field_name_26)], unquote(struct_module_26), unquote(is_nullable_26), unquote(guard_26)) and
        validate_field(unquote(field_name_27), values[unquote(field_name_27)], unquote(struct_module_27), unquote(is_nullable_27), unquote(guard_27)) and
        validate_field(unquote(field_name_28), values[unquote(field_name_28)], unquote(struct_module_28), unquote(is_nullable_28), unquote(guard_28)) and
        validate_field(unquote(field_name_29), values[unquote(field_name_29)], unquote(struct_module_29), unquote(is_nullable_29), unquote(guard_29))

        if is_params_valid === false do
          raise "type mismatch for constructor paramater(s) or required parameters are missing"
        end

        result = %{
            "#{unquote(field_name_1)}": values[unquote(field_name_1)],
            "#{unquote(field_name_2)}": values[unquote(field_name_2)],
            "#{unquote(field_name_3)}": values[unquote(field_name_3)],
            "#{unquote(field_name_4)}": values[unquote(field_name_4)],
            "#{unquote(field_name_5)}": values[unquote(field_name_5)],
            "#{unquote(field_name_6)}": values[unquote(field_name_6)],
            "#{unquote(field_name_7)}": values[unquote(field_name_7)],
            "#{unquote(field_name_8)}": values[unquote(field_name_8)],
            "#{unquote(field_name_9)}": values[unquote(field_name_9)],
            "#{unquote(field_name_10)}": values[unquote(field_name_10)],
            "#{unquote(field_name_11)}": values[unquote(field_name_11)],
            "#{unquote(field_name_12)}": values[unquote(field_name_12)],
            "#{unquote(field_name_13)}": values[unquote(field_name_13)],
            "#{unquote(field_name_14)}": values[unquote(field_name_14)],
            "#{unquote(field_name_15)}": values[unquote(field_name_15)],
            "#{unquote(field_name_16)}": values[unquote(field_name_16)],
            "#{unquote(field_name_17)}": values[unquote(field_name_17)],
            "#{unquote(field_name_18)}": values[unquote(field_name_18)],
            "#{unquote(field_name_19)}": values[unquote(field_name_19)],
            "#{unquote(field_name_20)}": values[unquote(field_name_20)],
            "#{unquote(field_name_21)}": values[unquote(field_name_21)],
            "#{unquote(field_name_22)}": values[unquote(field_name_22)],
            "#{unquote(field_name_23)}": values[unquote(field_name_23)],
            "#{unquote(field_name_24)}": values[unquote(field_name_24)],
            "#{unquote(field_name_25)}": values[unquote(field_name_25)],
            "#{unquote(field_name_26)}": values[unquote(field_name_26)],
            "#{unquote(field_name_27)}": values[unquote(field_name_27)],
            "#{unquote(field_name_28)}": values[unquote(field_name_28)],
            "#{unquote(field_name_29)}": values[unquote(field_name_29)]
        }
        struct(unquote(module), result)
      end


      def unquote(field_name_1)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_1))
      end

      if is_nil(unquote(struct_module_1)) === true do
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or unquote(guard_1)(value) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      else
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or is_struct(value, unquote(struct_module_1)) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      end
      def unquote(field_name_2)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_2))
      end

      if is_nil(unquote(struct_module_2)) === true do
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or unquote(guard_2)(value) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      else
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or is_struct(value, unquote(struct_module_2)) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      end
      def unquote(field_name_3)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_3))
      end

      if is_nil(unquote(struct_module_3)) === true do
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or unquote(guard_3)(value) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      else
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or is_struct(value, unquote(struct_module_3)) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      end
      def unquote(field_name_4)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_4))
      end

      if is_nil(unquote(struct_module_4)) === true do
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or unquote(guard_4)(value) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      else
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or is_struct(value, unquote(struct_module_4)) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      end
      def unquote(field_name_5)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_5))
      end

      if is_nil(unquote(struct_module_5)) === true do
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or unquote(guard_5)(value) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      else
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or is_struct(value, unquote(struct_module_5)) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      end
      def unquote(field_name_6)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_6))
      end

      if is_nil(unquote(struct_module_6)) === true do
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or unquote(guard_6)(value) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      else
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or is_struct(value, unquote(struct_module_6)) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      end
      def unquote(field_name_7)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_7))
      end

      if is_nil(unquote(struct_module_7)) === true do
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or unquote(guard_7)(value) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      else
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or is_struct(value, unquote(struct_module_7)) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      end
      def unquote(field_name_8)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_8))
      end

      if is_nil(unquote(struct_module_8)) === true do
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or unquote(guard_8)(value) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      else
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or is_struct(value, unquote(struct_module_8)) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      end
      def unquote(field_name_9)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_9))
      end

      if is_nil(unquote(struct_module_9)) === true do
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or unquote(guard_9)(value) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      else
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or is_struct(value, unquote(struct_module_9)) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      end
      def unquote(field_name_10)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_10))
      end

      if is_nil(unquote(struct_module_10)) === true do
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or unquote(guard_10)(value) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      else
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or is_struct(value, unquote(struct_module_10)) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      end
      def unquote(field_name_11)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_11))
      end

      if is_nil(unquote(struct_module_11)) === true do
        def unquote(field_name_11)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_11)) or unquote(guard_11)(value) do
          %{struct_instance | "#{unquote(field_name_11)}": value}
        end
      else
        def unquote(field_name_11)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_11)) or is_struct(value, unquote(struct_module_11)) do
          %{struct_instance | "#{unquote(field_name_11)}": value}
        end
      end
      def unquote(field_name_12)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_12))
      end

      if is_nil(unquote(struct_module_12)) === true do
        def unquote(field_name_12)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_12)) or unquote(guard_12)(value) do
          %{struct_instance | "#{unquote(field_name_12)}": value}
        end
      else
        def unquote(field_name_12)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_12)) or is_struct(value, unquote(struct_module_12)) do
          %{struct_instance | "#{unquote(field_name_12)}": value}
        end
      end
      def unquote(field_name_13)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_13))
      end

      if is_nil(unquote(struct_module_13)) === true do
        def unquote(field_name_13)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_13)) or unquote(guard_13)(value) do
          %{struct_instance | "#{unquote(field_name_13)}": value}
        end
      else
        def unquote(field_name_13)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_13)) or is_struct(value, unquote(struct_module_13)) do
          %{struct_instance | "#{unquote(field_name_13)}": value}
        end
      end
      def unquote(field_name_14)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_14))
      end

      if is_nil(unquote(struct_module_14)) === true do
        def unquote(field_name_14)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_14)) or unquote(guard_14)(value) do
          %{struct_instance | "#{unquote(field_name_14)}": value}
        end
      else
        def unquote(field_name_14)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_14)) or is_struct(value, unquote(struct_module_14)) do
          %{struct_instance | "#{unquote(field_name_14)}": value}
        end
      end
      def unquote(field_name_15)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_15))
      end

      if is_nil(unquote(struct_module_15)) === true do
        def unquote(field_name_15)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_15)) or unquote(guard_15)(value) do
          %{struct_instance | "#{unquote(field_name_15)}": value}
        end
      else
        def unquote(field_name_15)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_15)) or is_struct(value, unquote(struct_module_15)) do
          %{struct_instance | "#{unquote(field_name_15)}": value}
        end
      end
      def unquote(field_name_16)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_16))
      end

      if is_nil(unquote(struct_module_16)) === true do
        def unquote(field_name_16)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_16)) or unquote(guard_16)(value) do
          %{struct_instance | "#{unquote(field_name_16)}": value}
        end
      else
        def unquote(field_name_16)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_16)) or is_struct(value, unquote(struct_module_16)) do
          %{struct_instance | "#{unquote(field_name_16)}": value}
        end
      end
      def unquote(field_name_17)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_17))
      end

      if is_nil(unquote(struct_module_17)) === true do
        def unquote(field_name_17)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_17)) or unquote(guard_17)(value) do
          %{struct_instance | "#{unquote(field_name_17)}": value}
        end
      else
        def unquote(field_name_17)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_17)) or is_struct(value, unquote(struct_module_17)) do
          %{struct_instance | "#{unquote(field_name_17)}": value}
        end
      end
      def unquote(field_name_18)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_18))
      end

      if is_nil(unquote(struct_module_18)) === true do
        def unquote(field_name_18)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_18)) or unquote(guard_18)(value) do
          %{struct_instance | "#{unquote(field_name_18)}": value}
        end
      else
        def unquote(field_name_18)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_18)) or is_struct(value, unquote(struct_module_18)) do
          %{struct_instance | "#{unquote(field_name_18)}": value}
        end
      end
      def unquote(field_name_19)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_19))
      end

      if is_nil(unquote(struct_module_19)) === true do
        def unquote(field_name_19)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_19)) or unquote(guard_19)(value) do
          %{struct_instance | "#{unquote(field_name_19)}": value}
        end
      else
        def unquote(field_name_19)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_19)) or is_struct(value, unquote(struct_module_19)) do
          %{struct_instance | "#{unquote(field_name_19)}": value}
        end
      end
      def unquote(field_name_20)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_20))
      end

      if is_nil(unquote(struct_module_20)) === true do
        def unquote(field_name_20)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_20)) or unquote(guard_20)(value) do
          %{struct_instance | "#{unquote(field_name_20)}": value}
        end
      else
        def unquote(field_name_20)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_20)) or is_struct(value, unquote(struct_module_20)) do
          %{struct_instance | "#{unquote(field_name_20)}": value}
        end
      end
      def unquote(field_name_21)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_21))
      end

      if is_nil(unquote(struct_module_21)) === true do
        def unquote(field_name_21)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_21)) or unquote(guard_21)(value) do
          %{struct_instance | "#{unquote(field_name_21)}": value}
        end
      else
        def unquote(field_name_21)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_21)) or is_struct(value, unquote(struct_module_21)) do
          %{struct_instance | "#{unquote(field_name_21)}": value}
        end
      end
      def unquote(field_name_22)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_22))
      end

      if is_nil(unquote(struct_module_22)) === true do
        def unquote(field_name_22)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_22)) or unquote(guard_22)(value) do
          %{struct_instance | "#{unquote(field_name_22)}": value}
        end
      else
        def unquote(field_name_22)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_22)) or is_struct(value, unquote(struct_module_22)) do
          %{struct_instance | "#{unquote(field_name_22)}": value}
        end
      end
      def unquote(field_name_23)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_23))
      end

      if is_nil(unquote(struct_module_23)) === true do
        def unquote(field_name_23)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_23)) or unquote(guard_23)(value) do
          %{struct_instance | "#{unquote(field_name_23)}": value}
        end
      else
        def unquote(field_name_23)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_23)) or is_struct(value, unquote(struct_module_23)) do
          %{struct_instance | "#{unquote(field_name_23)}": value}
        end
      end
      def unquote(field_name_24)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_24))
      end

      if is_nil(unquote(struct_module_24)) === true do
        def unquote(field_name_24)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_24)) or unquote(guard_24)(value) do
          %{struct_instance | "#{unquote(field_name_24)}": value}
        end
      else
        def unquote(field_name_24)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_24)) or is_struct(value, unquote(struct_module_24)) do
          %{struct_instance | "#{unquote(field_name_24)}": value}
        end
      end
      def unquote(field_name_25)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_25))
      end

      if is_nil(unquote(struct_module_25)) === true do
        def unquote(field_name_25)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_25)) or unquote(guard_25)(value) do
          %{struct_instance | "#{unquote(field_name_25)}": value}
        end
      else
        def unquote(field_name_25)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_25)) or is_struct(value, unquote(struct_module_25)) do
          %{struct_instance | "#{unquote(field_name_25)}": value}
        end
      end
      def unquote(field_name_26)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_26))
      end

      if is_nil(unquote(struct_module_26)) === true do
        def unquote(field_name_26)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_26)) or unquote(guard_26)(value) do
          %{struct_instance | "#{unquote(field_name_26)}": value}
        end
      else
        def unquote(field_name_26)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_26)) or is_struct(value, unquote(struct_module_26)) do
          %{struct_instance | "#{unquote(field_name_26)}": value}
        end
      end
      def unquote(field_name_27)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_27))
      end

      if is_nil(unquote(struct_module_27)) === true do
        def unquote(field_name_27)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_27)) or unquote(guard_27)(value) do
          %{struct_instance | "#{unquote(field_name_27)}": value}
        end
      else
        def unquote(field_name_27)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_27)) or is_struct(value, unquote(struct_module_27)) do
          %{struct_instance | "#{unquote(field_name_27)}": value}
        end
      end
      def unquote(field_name_28)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_28))
      end

      if is_nil(unquote(struct_module_28)) === true do
        def unquote(field_name_28)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_28)) or unquote(guard_28)(value) do
          %{struct_instance | "#{unquote(field_name_28)}": value}
        end
      else
        def unquote(field_name_28)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_28)) or is_struct(value, unquote(struct_module_28)) do
          %{struct_instance | "#{unquote(field_name_28)}": value}
        end
      end
      def unquote(field_name_29)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_29))
      end

      if is_nil(unquote(struct_module_29)) === true do
        def unquote(field_name_29)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_29)) or unquote(guard_29)(value) do
          %{struct_instance | "#{unquote(field_name_29)}": value}
        end
      else
        def unquote(field_name_29)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_29)) or is_struct(value, unquote(struct_module_29)) do
          %{struct_instance | "#{unquote(field_name_29)}": value}
        end
      end
    end
  end




  @doc"""
  Generates a struct, complete with a constructor, getter and setter methods.

  Macro usage example:
      ```
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
        nullable: false,
        struct: nil
      },
      %{
        field: :hair_details,
        type_guard: :is_struct,
        default_value: %Hair{},
        nullable: true,
        struct: Hair
      })
      ```
  """
  defmacro generate_constructor(module, field_1, field_2, field_3, field_4, field_5, field_6, field_7, field_8, field_9, field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19, field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29, field_30) do

    [
        field: field_name_1,
        type_guard: guard_1,
        default_value: default_1,
        nullable: is_nullable_1,
        struct: struct_module_1
    ] = field_1 |> elem(2)

    [
        field: field_name_2,
        type_guard: guard_2,
        default_value: default_2,
        nullable: is_nullable_2,
        struct: struct_module_2
    ] = field_2 |> elem(2)

    [
        field: field_name_3,
        type_guard: guard_3,
        default_value: default_3,
        nullable: is_nullable_3,
        struct: struct_module_3
    ] = field_3 |> elem(2)

    [
        field: field_name_4,
        type_guard: guard_4,
        default_value: default_4,
        nullable: is_nullable_4,
        struct: struct_module_4
    ] = field_4 |> elem(2)

    [
        field: field_name_5,
        type_guard: guard_5,
        default_value: default_5,
        nullable: is_nullable_5,
        struct: struct_module_5
    ] = field_5 |> elem(2)

    [
        field: field_name_6,
        type_guard: guard_6,
        default_value: default_6,
        nullable: is_nullable_6,
        struct: struct_module_6
    ] = field_6 |> elem(2)

    [
        field: field_name_7,
        type_guard: guard_7,
        default_value: default_7,
        nullable: is_nullable_7,
        struct: struct_module_7
    ] = field_7 |> elem(2)

    [
        field: field_name_8,
        type_guard: guard_8,
        default_value: default_8,
        nullable: is_nullable_8,
        struct: struct_module_8
    ] = field_8 |> elem(2)

    [
        field: field_name_9,
        type_guard: guard_9,
        default_value: default_9,
        nullable: is_nullable_9,
        struct: struct_module_9
    ] = field_9 |> elem(2)

    [
        field: field_name_10,
        type_guard: guard_10,
        default_value: default_10,
        nullable: is_nullable_10,
        struct: struct_module_10
    ] = field_10 |> elem(2)

    [
        field: field_name_11,
        type_guard: guard_11,
        default_value: default_11,
        nullable: is_nullable_11,
        struct: struct_module_11
    ] = field_11 |> elem(2)

    [
        field: field_name_12,
        type_guard: guard_12,
        default_value: default_12,
        nullable: is_nullable_12,
        struct: struct_module_12
    ] = field_12 |> elem(2)

    [
        field: field_name_13,
        type_guard: guard_13,
        default_value: default_13,
        nullable: is_nullable_13,
        struct: struct_module_13
    ] = field_13 |> elem(2)

    [
        field: field_name_14,
        type_guard: guard_14,
        default_value: default_14,
        nullable: is_nullable_14,
        struct: struct_module_14
    ] = field_14 |> elem(2)

    [
        field: field_name_15,
        type_guard: guard_15,
        default_value: default_15,
        nullable: is_nullable_15,
        struct: struct_module_15
    ] = field_15 |> elem(2)

    [
        field: field_name_16,
        type_guard: guard_16,
        default_value: default_16,
        nullable: is_nullable_16,
        struct: struct_module_16
    ] = field_16 |> elem(2)

    [
        field: field_name_17,
        type_guard: guard_17,
        default_value: default_17,
        nullable: is_nullable_17,
        struct: struct_module_17
    ] = field_17 |> elem(2)

    [
        field: field_name_18,
        type_guard: guard_18,
        default_value: default_18,
        nullable: is_nullable_18,
        struct: struct_module_18
    ] = field_18 |> elem(2)

    [
        field: field_name_19,
        type_guard: guard_19,
        default_value: default_19,
        nullable: is_nullable_19,
        struct: struct_module_19
    ] = field_19 |> elem(2)

    [
        field: field_name_20,
        type_guard: guard_20,
        default_value: default_20,
        nullable: is_nullable_20,
        struct: struct_module_20
    ] = field_20 |> elem(2)

    [
        field: field_name_21,
        type_guard: guard_21,
        default_value: default_21,
        nullable: is_nullable_21,
        struct: struct_module_21
    ] = field_21 |> elem(2)

    [
        field: field_name_22,
        type_guard: guard_22,
        default_value: default_22,
        nullable: is_nullable_22,
        struct: struct_module_22
    ] = field_22 |> elem(2)

    [
        field: field_name_23,
        type_guard: guard_23,
        default_value: default_23,
        nullable: is_nullable_23,
        struct: struct_module_23
    ] = field_23 |> elem(2)

    [
        field: field_name_24,
        type_guard: guard_24,
        default_value: default_24,
        nullable: is_nullable_24,
        struct: struct_module_24
    ] = field_24 |> elem(2)

    [
        field: field_name_25,
        type_guard: guard_25,
        default_value: default_25,
        nullable: is_nullable_25,
        struct: struct_module_25
    ] = field_25 |> elem(2)

    [
        field: field_name_26,
        type_guard: guard_26,
        default_value: default_26,
        nullable: is_nullable_26,
        struct: struct_module_26
    ] = field_26 |> elem(2)

    [
        field: field_name_27,
        type_guard: guard_27,
        default_value: default_27,
        nullable: is_nullable_27,
        struct: struct_module_27
    ] = field_27 |> elem(2)

    [
        field: field_name_28,
        type_guard: guard_28,
        default_value: default_28,
        nullable: is_nullable_28,
        struct: struct_module_28
    ] = field_28 |> elem(2)

    [
        field: field_name_29,
        type_guard: guard_29,
        default_value: default_29,
        nullable: is_nullable_29,
        struct: struct_module_29
    ] = field_29 |> elem(2)

    [
        field: field_name_30,
        type_guard: guard_30,
        default_value: default_30,
        nullable: is_nullable_30,
        struct: struct_module_30
    ] = field_30 |> elem(2)


    quote do
      defstruct [
        "#{unquote(field_name_1)}": unquote(default_1),
        "#{unquote(field_name_2)}": unquote(default_2),
        "#{unquote(field_name_3)}": unquote(default_3),
        "#{unquote(field_name_4)}": unquote(default_4),
        "#{unquote(field_name_5)}": unquote(default_5),
        "#{unquote(field_name_6)}": unquote(default_6),
        "#{unquote(field_name_7)}": unquote(default_7),
        "#{unquote(field_name_8)}": unquote(default_8),
        "#{unquote(field_name_9)}": unquote(default_9),
        "#{unquote(field_name_10)}": unquote(default_10),
        "#{unquote(field_name_11)}": unquote(default_11),
        "#{unquote(field_name_12)}": unquote(default_12),
        "#{unquote(field_name_13)}": unquote(default_13),
        "#{unquote(field_name_14)}": unquote(default_14),
        "#{unquote(field_name_15)}": unquote(default_15),
        "#{unquote(field_name_16)}": unquote(default_16),
        "#{unquote(field_name_17)}": unquote(default_17),
        "#{unquote(field_name_18)}": unquote(default_18),
        "#{unquote(field_name_19)}": unquote(default_19),
        "#{unquote(field_name_20)}": unquote(default_20),
        "#{unquote(field_name_21)}": unquote(default_21),
        "#{unquote(field_name_22)}": unquote(default_22),
        "#{unquote(field_name_23)}": unquote(default_23),
        "#{unquote(field_name_24)}": unquote(default_24),
        "#{unquote(field_name_25)}": unquote(default_25),
        "#{unquote(field_name_26)}": unquote(default_26),
        "#{unquote(field_name_27)}": unquote(default_27),
        "#{unquote(field_name_28)}": unquote(default_28),
        "#{unquote(field_name_29)}": unquote(default_29),
        "#{unquote(field_name_30)}": unquote(default_30)
      ]

      defp validate_field(field_name, field_value, struct_module, is_nullable, guard) do
        (Code.ensure_compiled(struct_module) |> elem(0) === :module and is_struct(field_value, struct_module))
            or (is_nullable === true and field_value === nil)
            or apply(Kernel, guard, [field_value])
      end

      def constructor(values) do
        is_params_valid =
        validate_field(unquote(field_name_1), values[unquote(field_name_1)], unquote(struct_module_1), unquote(is_nullable_1), unquote(guard_1)) and
        validate_field(unquote(field_name_2), values[unquote(field_name_2)], unquote(struct_module_2), unquote(is_nullable_2), unquote(guard_2)) and
        validate_field(unquote(field_name_3), values[unquote(field_name_3)], unquote(struct_module_3), unquote(is_nullable_3), unquote(guard_3)) and
        validate_field(unquote(field_name_4), values[unquote(field_name_4)], unquote(struct_module_4), unquote(is_nullable_4), unquote(guard_4)) and
        validate_field(unquote(field_name_5), values[unquote(field_name_5)], unquote(struct_module_5), unquote(is_nullable_5), unquote(guard_5)) and
        validate_field(unquote(field_name_6), values[unquote(field_name_6)], unquote(struct_module_6), unquote(is_nullable_6), unquote(guard_6)) and
        validate_field(unquote(field_name_7), values[unquote(field_name_7)], unquote(struct_module_7), unquote(is_nullable_7), unquote(guard_7)) and
        validate_field(unquote(field_name_8), values[unquote(field_name_8)], unquote(struct_module_8), unquote(is_nullable_8), unquote(guard_8)) and
        validate_field(unquote(field_name_9), values[unquote(field_name_9)], unquote(struct_module_9), unquote(is_nullable_9), unquote(guard_9)) and
        validate_field(unquote(field_name_10), values[unquote(field_name_10)], unquote(struct_module_10), unquote(is_nullable_10), unquote(guard_10)) and
        validate_field(unquote(field_name_11), values[unquote(field_name_11)], unquote(struct_module_11), unquote(is_nullable_11), unquote(guard_11)) and
        validate_field(unquote(field_name_12), values[unquote(field_name_12)], unquote(struct_module_12), unquote(is_nullable_12), unquote(guard_12)) and
        validate_field(unquote(field_name_13), values[unquote(field_name_13)], unquote(struct_module_13), unquote(is_nullable_13), unquote(guard_13)) and
        validate_field(unquote(field_name_14), values[unquote(field_name_14)], unquote(struct_module_14), unquote(is_nullable_14), unquote(guard_14)) and
        validate_field(unquote(field_name_15), values[unquote(field_name_15)], unquote(struct_module_15), unquote(is_nullable_15), unquote(guard_15)) and
        validate_field(unquote(field_name_16), values[unquote(field_name_16)], unquote(struct_module_16), unquote(is_nullable_16), unquote(guard_16)) and
        validate_field(unquote(field_name_17), values[unquote(field_name_17)], unquote(struct_module_17), unquote(is_nullable_17), unquote(guard_17)) and
        validate_field(unquote(field_name_18), values[unquote(field_name_18)], unquote(struct_module_18), unquote(is_nullable_18), unquote(guard_18)) and
        validate_field(unquote(field_name_19), values[unquote(field_name_19)], unquote(struct_module_19), unquote(is_nullable_19), unquote(guard_19)) and
        validate_field(unquote(field_name_20), values[unquote(field_name_20)], unquote(struct_module_20), unquote(is_nullable_20), unquote(guard_20)) and
        validate_field(unquote(field_name_21), values[unquote(field_name_21)], unquote(struct_module_21), unquote(is_nullable_21), unquote(guard_21)) and
        validate_field(unquote(field_name_22), values[unquote(field_name_22)], unquote(struct_module_22), unquote(is_nullable_22), unquote(guard_22)) and
        validate_field(unquote(field_name_23), values[unquote(field_name_23)], unquote(struct_module_23), unquote(is_nullable_23), unquote(guard_23)) and
        validate_field(unquote(field_name_24), values[unquote(field_name_24)], unquote(struct_module_24), unquote(is_nullable_24), unquote(guard_24)) and
        validate_field(unquote(field_name_25), values[unquote(field_name_25)], unquote(struct_module_25), unquote(is_nullable_25), unquote(guard_25)) and
        validate_field(unquote(field_name_26), values[unquote(field_name_26)], unquote(struct_module_26), unquote(is_nullable_26), unquote(guard_26)) and
        validate_field(unquote(field_name_27), values[unquote(field_name_27)], unquote(struct_module_27), unquote(is_nullable_27), unquote(guard_27)) and
        validate_field(unquote(field_name_28), values[unquote(field_name_28)], unquote(struct_module_28), unquote(is_nullable_28), unquote(guard_28)) and
        validate_field(unquote(field_name_29), values[unquote(field_name_29)], unquote(struct_module_29), unquote(is_nullable_29), unquote(guard_29)) and
        validate_field(unquote(field_name_30), values[unquote(field_name_30)], unquote(struct_module_30), unquote(is_nullable_30), unquote(guard_30))

        if is_params_valid === false do
          raise "type mismatch for constructor paramater(s) or required parameters are missing"
        end

        result = %{
            "#{unquote(field_name_1)}": values[unquote(field_name_1)],
            "#{unquote(field_name_2)}": values[unquote(field_name_2)],
            "#{unquote(field_name_3)}": values[unquote(field_name_3)],
            "#{unquote(field_name_4)}": values[unquote(field_name_4)],
            "#{unquote(field_name_5)}": values[unquote(field_name_5)],
            "#{unquote(field_name_6)}": values[unquote(field_name_6)],
            "#{unquote(field_name_7)}": values[unquote(field_name_7)],
            "#{unquote(field_name_8)}": values[unquote(field_name_8)],
            "#{unquote(field_name_9)}": values[unquote(field_name_9)],
            "#{unquote(field_name_10)}": values[unquote(field_name_10)],
            "#{unquote(field_name_11)}": values[unquote(field_name_11)],
            "#{unquote(field_name_12)}": values[unquote(field_name_12)],
            "#{unquote(field_name_13)}": values[unquote(field_name_13)],
            "#{unquote(field_name_14)}": values[unquote(field_name_14)],
            "#{unquote(field_name_15)}": values[unquote(field_name_15)],
            "#{unquote(field_name_16)}": values[unquote(field_name_16)],
            "#{unquote(field_name_17)}": values[unquote(field_name_17)],
            "#{unquote(field_name_18)}": values[unquote(field_name_18)],
            "#{unquote(field_name_19)}": values[unquote(field_name_19)],
            "#{unquote(field_name_20)}": values[unquote(field_name_20)],
            "#{unquote(field_name_21)}": values[unquote(field_name_21)],
            "#{unquote(field_name_22)}": values[unquote(field_name_22)],
            "#{unquote(field_name_23)}": values[unquote(field_name_23)],
            "#{unquote(field_name_24)}": values[unquote(field_name_24)],
            "#{unquote(field_name_25)}": values[unquote(field_name_25)],
            "#{unquote(field_name_26)}": values[unquote(field_name_26)],
            "#{unquote(field_name_27)}": values[unquote(field_name_27)],
            "#{unquote(field_name_28)}": values[unquote(field_name_28)],
            "#{unquote(field_name_29)}": values[unquote(field_name_29)],
            "#{unquote(field_name_30)}": values[unquote(field_name_30)]
        }
        struct(unquote(module), result)
      end


      def unquote(field_name_1)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_1))
      end

      if is_nil(unquote(struct_module_1)) === true do
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or unquote(guard_1)(value) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      else
        def unquote(field_name_1)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_1)) or is_struct(value, unquote(struct_module_1)) do
          %{struct_instance | "#{unquote(field_name_1)}": value}
        end
      end
      def unquote(field_name_2)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_2))
      end

      if is_nil(unquote(struct_module_2)) === true do
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or unquote(guard_2)(value) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      else
        def unquote(field_name_2)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_2)) or is_struct(value, unquote(struct_module_2)) do
          %{struct_instance | "#{unquote(field_name_2)}": value}
        end
      end
      def unquote(field_name_3)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_3))
      end

      if is_nil(unquote(struct_module_3)) === true do
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or unquote(guard_3)(value) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      else
        def unquote(field_name_3)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_3)) or is_struct(value, unquote(struct_module_3)) do
          %{struct_instance | "#{unquote(field_name_3)}": value}
        end
      end
      def unquote(field_name_4)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_4))
      end

      if is_nil(unquote(struct_module_4)) === true do
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or unquote(guard_4)(value) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      else
        def unquote(field_name_4)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_4)) or is_struct(value, unquote(struct_module_4)) do
          %{struct_instance | "#{unquote(field_name_4)}": value}
        end
      end
      def unquote(field_name_5)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_5))
      end

      if is_nil(unquote(struct_module_5)) === true do
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or unquote(guard_5)(value) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      else
        def unquote(field_name_5)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_5)) or is_struct(value, unquote(struct_module_5)) do
          %{struct_instance | "#{unquote(field_name_5)}": value}
        end
      end
      def unquote(field_name_6)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_6))
      end

      if is_nil(unquote(struct_module_6)) === true do
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or unquote(guard_6)(value) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      else
        def unquote(field_name_6)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_6)) or is_struct(value, unquote(struct_module_6)) do
          %{struct_instance | "#{unquote(field_name_6)}": value}
        end
      end
      def unquote(field_name_7)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_7))
      end

      if is_nil(unquote(struct_module_7)) === true do
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or unquote(guard_7)(value) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      else
        def unquote(field_name_7)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_7)) or is_struct(value, unquote(struct_module_7)) do
          %{struct_instance | "#{unquote(field_name_7)}": value}
        end
      end
      def unquote(field_name_8)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_8))
      end

      if is_nil(unquote(struct_module_8)) === true do
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or unquote(guard_8)(value) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      else
        def unquote(field_name_8)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_8)) or is_struct(value, unquote(struct_module_8)) do
          %{struct_instance | "#{unquote(field_name_8)}": value}
        end
      end
      def unquote(field_name_9)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_9))
      end

      if is_nil(unquote(struct_module_9)) === true do
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or unquote(guard_9)(value) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      else
        def unquote(field_name_9)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_9)) or is_struct(value, unquote(struct_module_9)) do
          %{struct_instance | "#{unquote(field_name_9)}": value}
        end
      end
      def unquote(field_name_10)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_10))
      end

      if is_nil(unquote(struct_module_10)) === true do
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or unquote(guard_10)(value) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      else
        def unquote(field_name_10)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_10)) or is_struct(value, unquote(struct_module_10)) do
          %{struct_instance | "#{unquote(field_name_10)}": value}
        end
      end
      def unquote(field_name_11)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_11))
      end

      if is_nil(unquote(struct_module_11)) === true do
        def unquote(field_name_11)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_11)) or unquote(guard_11)(value) do
          %{struct_instance | "#{unquote(field_name_11)}": value}
        end
      else
        def unquote(field_name_11)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_11)) or is_struct(value, unquote(struct_module_11)) do
          %{struct_instance | "#{unquote(field_name_11)}": value}
        end
      end
      def unquote(field_name_12)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_12))
      end

      if is_nil(unquote(struct_module_12)) === true do
        def unquote(field_name_12)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_12)) or unquote(guard_12)(value) do
          %{struct_instance | "#{unquote(field_name_12)}": value}
        end
      else
        def unquote(field_name_12)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_12)) or is_struct(value, unquote(struct_module_12)) do
          %{struct_instance | "#{unquote(field_name_12)}": value}
        end
      end
      def unquote(field_name_13)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_13))
      end

      if is_nil(unquote(struct_module_13)) === true do
        def unquote(field_name_13)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_13)) or unquote(guard_13)(value) do
          %{struct_instance | "#{unquote(field_name_13)}": value}
        end
      else
        def unquote(field_name_13)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_13)) or is_struct(value, unquote(struct_module_13)) do
          %{struct_instance | "#{unquote(field_name_13)}": value}
        end
      end
      def unquote(field_name_14)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_14))
      end

      if is_nil(unquote(struct_module_14)) === true do
        def unquote(field_name_14)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_14)) or unquote(guard_14)(value) do
          %{struct_instance | "#{unquote(field_name_14)}": value}
        end
      else
        def unquote(field_name_14)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_14)) or is_struct(value, unquote(struct_module_14)) do
          %{struct_instance | "#{unquote(field_name_14)}": value}
        end
      end
      def unquote(field_name_15)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_15))
      end

      if is_nil(unquote(struct_module_15)) === true do
        def unquote(field_name_15)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_15)) or unquote(guard_15)(value) do
          %{struct_instance | "#{unquote(field_name_15)}": value}
        end
      else
        def unquote(field_name_15)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_15)) or is_struct(value, unquote(struct_module_15)) do
          %{struct_instance | "#{unquote(field_name_15)}": value}
        end
      end
      def unquote(field_name_16)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_16))
      end

      if is_nil(unquote(struct_module_16)) === true do
        def unquote(field_name_16)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_16)) or unquote(guard_16)(value) do
          %{struct_instance | "#{unquote(field_name_16)}": value}
        end
      else
        def unquote(field_name_16)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_16)) or is_struct(value, unquote(struct_module_16)) do
          %{struct_instance | "#{unquote(field_name_16)}": value}
        end
      end
      def unquote(field_name_17)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_17))
      end

      if is_nil(unquote(struct_module_17)) === true do
        def unquote(field_name_17)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_17)) or unquote(guard_17)(value) do
          %{struct_instance | "#{unquote(field_name_17)}": value}
        end
      else
        def unquote(field_name_17)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_17)) or is_struct(value, unquote(struct_module_17)) do
          %{struct_instance | "#{unquote(field_name_17)}": value}
        end
      end
      def unquote(field_name_18)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_18))
      end

      if is_nil(unquote(struct_module_18)) === true do
        def unquote(field_name_18)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_18)) or unquote(guard_18)(value) do
          %{struct_instance | "#{unquote(field_name_18)}": value}
        end
      else
        def unquote(field_name_18)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_18)) or is_struct(value, unquote(struct_module_18)) do
          %{struct_instance | "#{unquote(field_name_18)}": value}
        end
      end
      def unquote(field_name_19)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_19))
      end

      if is_nil(unquote(struct_module_19)) === true do
        def unquote(field_name_19)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_19)) or unquote(guard_19)(value) do
          %{struct_instance | "#{unquote(field_name_19)}": value}
        end
      else
        def unquote(field_name_19)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_19)) or is_struct(value, unquote(struct_module_19)) do
          %{struct_instance | "#{unquote(field_name_19)}": value}
        end
      end
      def unquote(field_name_20)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_20))
      end

      if is_nil(unquote(struct_module_20)) === true do
        def unquote(field_name_20)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_20)) or unquote(guard_20)(value) do
          %{struct_instance | "#{unquote(field_name_20)}": value}
        end
      else
        def unquote(field_name_20)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_20)) or is_struct(value, unquote(struct_module_20)) do
          %{struct_instance | "#{unquote(field_name_20)}": value}
        end
      end
      def unquote(field_name_21)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_21))
      end

      if is_nil(unquote(struct_module_21)) === true do
        def unquote(field_name_21)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_21)) or unquote(guard_21)(value) do
          %{struct_instance | "#{unquote(field_name_21)}": value}
        end
      else
        def unquote(field_name_21)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_21)) or is_struct(value, unquote(struct_module_21)) do
          %{struct_instance | "#{unquote(field_name_21)}": value}
        end
      end
      def unquote(field_name_22)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_22))
      end

      if is_nil(unquote(struct_module_22)) === true do
        def unquote(field_name_22)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_22)) or unquote(guard_22)(value) do
          %{struct_instance | "#{unquote(field_name_22)}": value}
        end
      else
        def unquote(field_name_22)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_22)) or is_struct(value, unquote(struct_module_22)) do
          %{struct_instance | "#{unquote(field_name_22)}": value}
        end
      end
      def unquote(field_name_23)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_23))
      end

      if is_nil(unquote(struct_module_23)) === true do
        def unquote(field_name_23)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_23)) or unquote(guard_23)(value) do
          %{struct_instance | "#{unquote(field_name_23)}": value}
        end
      else
        def unquote(field_name_23)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_23)) or is_struct(value, unquote(struct_module_23)) do
          %{struct_instance | "#{unquote(field_name_23)}": value}
        end
      end
      def unquote(field_name_24)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_24))
      end

      if is_nil(unquote(struct_module_24)) === true do
        def unquote(field_name_24)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_24)) or unquote(guard_24)(value) do
          %{struct_instance | "#{unquote(field_name_24)}": value}
        end
      else
        def unquote(field_name_24)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_24)) or is_struct(value, unquote(struct_module_24)) do
          %{struct_instance | "#{unquote(field_name_24)}": value}
        end
      end
      def unquote(field_name_25)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_25))
      end

      if is_nil(unquote(struct_module_25)) === true do
        def unquote(field_name_25)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_25)) or unquote(guard_25)(value) do
          %{struct_instance | "#{unquote(field_name_25)}": value}
        end
      else
        def unquote(field_name_25)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_25)) or is_struct(value, unquote(struct_module_25)) do
          %{struct_instance | "#{unquote(field_name_25)}": value}
        end
      end
      def unquote(field_name_26)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_26))
      end

      if is_nil(unquote(struct_module_26)) === true do
        def unquote(field_name_26)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_26)) or unquote(guard_26)(value) do
          %{struct_instance | "#{unquote(field_name_26)}": value}
        end
      else
        def unquote(field_name_26)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_26)) or is_struct(value, unquote(struct_module_26)) do
          %{struct_instance | "#{unquote(field_name_26)}": value}
        end
      end
      def unquote(field_name_27)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_27))
      end

      if is_nil(unquote(struct_module_27)) === true do
        def unquote(field_name_27)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_27)) or unquote(guard_27)(value) do
          %{struct_instance | "#{unquote(field_name_27)}": value}
        end
      else
        def unquote(field_name_27)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_27)) or is_struct(value, unquote(struct_module_27)) do
          %{struct_instance | "#{unquote(field_name_27)}": value}
        end
      end
      def unquote(field_name_28)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_28))
      end

      if is_nil(unquote(struct_module_28)) === true do
        def unquote(field_name_28)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_28)) or unquote(guard_28)(value) do
          %{struct_instance | "#{unquote(field_name_28)}": value}
        end
      else
        def unquote(field_name_28)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_28)) or is_struct(value, unquote(struct_module_28)) do
          %{struct_instance | "#{unquote(field_name_28)}": value}
        end
      end
      def unquote(field_name_29)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_29))
      end

      if is_nil(unquote(struct_module_29)) === true do
        def unquote(field_name_29)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_29)) or unquote(guard_29)(value) do
          %{struct_instance | "#{unquote(field_name_29)}": value}
        end
      else
        def unquote(field_name_29)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_29)) or is_struct(value, unquote(struct_module_29)) do
          %{struct_instance | "#{unquote(field_name_29)}": value}
        end
      end
      def unquote(field_name_30)(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_30))
      end

      if is_nil(unquote(struct_module_30)) === true do
        def unquote(field_name_30)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_30)) or unquote(guard_30)(value) do
          %{struct_instance | "#{unquote(field_name_30)}": value}
        end
      else
        def unquote(field_name_30)(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_30)) or is_struct(value, unquote(struct_module_30)) do
          %{struct_instance | "#{unquote(field_name_30)}": value}
        end
      end
    end
  end




end
