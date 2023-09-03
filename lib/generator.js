const generateTemplate = (...params) => {
    return `  @doc"""
  Generates a struct, complete with a constructor, getter and setter methods.

  Macro usage example:
      \`\`\`
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
      \`\`\`
  """
  defmacro generate_constructor(module, ${params.reduce((acc, param) => acc += `field_${param}, `, "").slice(0, -2)}) do
    ${params.reduce((acc, param)=> acc += `
    [
        field: field_name_${param},
        type_guard: guard_${param},
        default_value: default_${param},
        nullable: is_nullable_${param},
        struct: struct_module_${param}
    ] = field_${param} |> elem(2)
    `, "")}

    quote do
      defstruct [ ${params.reduce((acc, param) => acc += `
        "#{unquote(field_name_${param})}": unquote(default_${param}),`, "").slice(0, -1)}
      ]

      defp validate_field(field_name, field_value, struct_module, is_nullable, guard) do
        (Code.ensure_compiled(struct_module) |> elem(0) === :module and is_struct(field_value, struct_module))
            or (is_nullable === true and field_value === nil)
            or apply(Kernel, guard, [field_value])
      end

      def constructor(values) do
        is_params_valid = ${params.reduce((acc, param) => acc += `
        validate_field(unquote(field_name_${param}), values[unquote(field_name_${param})], unquote(struct_module_${param}), unquote(is_nullable_${param}), unquote(guard_${param})) and`, 
        "").slice(0, -4)}

        if is_params_valid === false do
          raise "type mismatch for constructor paramater(s) or required parameters are missing"
        end

        result = %{${params.reduce((acc, param) => acc += `
            "#{unquote(field_name_${param})}": values[unquote(field_name_${param})],`, "").slice(0, -1)}
        }
        struct(unquote(module), result)
      end

      ${params.reduce((acc, param) => acc += `
      def unquote(field_name_${param})(struct_instance) when is_struct(struct_instance, unquote(module)) do
        Map.get(struct_instance, unquote(field_name_${param}))
      end

      if is_nil(unquote(struct_module_${param})) === true do
        def unquote(field_name_${param})(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_${param})) or unquote(guard_${param})(value) do
          %{struct_instance | "#{unquote(field_name_${param})}": value}
        end
      else
        def unquote(field_name_${param})(struct_instance, value) when is_struct(struct_instance, unquote(module)) and (is_nil(value) === true and unquote(is_nullable_${param})) or is_struct(value, unquote(struct_module_${param})) do
          %{struct_instance | "#{unquote(field_name_${param})}": value}
        end
      end`, "")}
    end
  end
  

`
}

// Provide the max number of desired struct attributes:
const numberOfAttributes = 30

fs.writeFileSync("./out2.txt", Array.from(Array(numberOfAttributes + 2).keys()).slice(2).reduce((acc, elm) => acc += generateTemplate(...Array.from(Array(elm).keys()).slice(1))+"\n\n", ""))