defmodule StructHelpers.MixProject do
  use Mix.Project

  @version "0.1.0"
  @repo_url "https://github.com/otboss/struct_helpers"

  def project do
    [
      app: :struct_helpers,
      version: @version,
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "Struct Helpers",
      source_url: "https://github.com/otboss/struct_helpers",
      description: "A library that provides structs with constructor, getter and setter methods",
      docs: [
        main: "StructHelpers",
        extras: ["README.md"]
      ],
      package: [
        licenses: ["MIT"],
        links: %{
          "Changelog" => "https://hexdocs.pm/typed_struct/changelog.html",
          "GitHub" => @repo_url
        }
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.27", only: :docs, runtime: false},
    ]
  end
end
