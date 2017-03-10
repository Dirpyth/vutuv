defmodule Vutuv.Address do
  use Vutuv.Web, :model

  schema "addresses" do
    field :description, :string
    field :line_1, :string
    field :line_2, :string
    field :line_3, :string
    field :line_4, :string
    field :zip_code, :string
    field :city, :string
    field :state, :string
    field :country, :string

    belongs_to :user, Vutuv.User
    timestamps
  end

  @required_fields ~w(country)
  @optional_fields ~w(line_2 description line_1 zip_code city state )

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:description, :line_1, :line_2, :line_3, :line_4, :zip_code, :city, :state, :country])
    |> validate_required([:description, :country])
  end
end
