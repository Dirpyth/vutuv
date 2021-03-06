defmodule Vutuv.Repo.Migrations.CreateAddresses do
  use Ecto.Migration

  def change do
    create table(:addresses) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :description, :string
      add :line_1, :string
      add :line_2, :string
      add :line_3, :string
      add :line_4, :string
      add :zip_code, :string
      add :city, :string
      add :state, :string
      add :country, :string

      timestamps()
    end

    create index(:addresses, [:user_id])
  end
end
