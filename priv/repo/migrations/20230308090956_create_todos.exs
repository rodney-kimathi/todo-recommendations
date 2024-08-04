defmodule ExAssignment.Repo.Migrations.CreateTodos do
  use Ecto.Migration

  def change do
    create table(:todos) do
      add(:title, :string, null: false, size: 50)
      add(:priority, :integer, null: false)
      add(:done, :boolean, default: false, null: false)

      timestamps()
    end
  end
end
