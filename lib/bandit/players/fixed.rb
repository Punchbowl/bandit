module Bandit
  class FixedPlayer < BasePlayer

    def choose_alternative(experiment)
      experiment.alternatives.first
    end

    # store state variable by name
    def set(name, value)
      true
    end
    
  end
end
