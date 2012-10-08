module Bandit
  class FixedPlayer < BasePlayer

    def choose_alternative(experiment)
      experiment.alternatives.first
    end
    
  end
end
