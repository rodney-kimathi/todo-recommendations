defmodule ExAssignment.RecommendationEngine do
  use Agent

  alias ExAssignment.Todos

  def start_link(_) do
    Agent.start_link(fn -> generate_recommendation() end, name: __MODULE__)
  end

  def get_recommendation do
    Agent.get(__MODULE__, fn recommendation -> recommendation end)
  end

  def update_recommendation do
    Agent.update(__MODULE__, fn _ -> generate_recommendation() end)
  end

  defp generate_recommendation do
    Todos.list_todos(:open)
    |> case do
      [] ->
        nil

      todos ->
        # The weight of each todo is calculated as the inverse of its priority
        # Lower priorities get higher values, which correspond to greater urgency
        weights = Enum.map(todos, fn todo -> 1.0 / todo.priority end)

        # Sum all weights to get the total weight of the dataset
        total_weight = Enum.sum(weights)

        # Generate a random number between 0.0 and 1.0 then multiply that by the total weight
        # This will give us a random weight that is within the range of the total weight
        random_weight = :rand.uniform() * total_weight

        # Iterate through the todos, subtracting their weight from the random weight
        # The current todo is returned when the random weight is less than or equal to the current todo's weight
        Enum.reduce_while(todos, random_weight, fn todo, acc ->
          weight = 1.0 / todo.priority

          if acc <= weight do
            {:halt, todo}
          else
            {:cont, acc - weight}
          end
        end)
    end
  end
end
