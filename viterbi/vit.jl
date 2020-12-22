module vit
export Hmm, emis_seq, state_seq
using StatsBase

type Hmm
  emis_prob
  trans_prob
end

function make_seqs(hmm, T)
  emis_prob = hmm.emis_prob 
  trans_prob = hmm.trans_prob 
  emissions = collect(1:length(emis_prob[1, :]))
  states = collect(1:length(trans_prob[:,1]))

  #The Sstart state emits "start" with a probability of 1:

  state_seq = [1]
  cur_state = 1
  emis_seq = [1]

  for i in 1:T-1
      weights = Weights(trans_prob[cur_state, :])
 
      cur_state = sample(states, weights)
      push!(emis_seq, sample(emissions, Weights(emis_prob[cur_state , :]))) #grabs an emission based on the current state
      push!(state_seq, cur_state)

  end

  state_seq, emis_seq

end

function viterbi(hmm, sequence)

  emis_prob = log(hmm.emis_prob) 
  trans_prob = log(hmm.trans_prob) 
  emissions = collect(1:length(emis_prob[1, :]))
  states = collect(1:length(trans_prob[:,1]))

  #do viterbi things
  V = ones(length(states), length(sequence))*typemin(Float64)  #matrix that stores probabilities
  P = fill(1, (length(states), length(sequence)))  #matrix that stores the pointers
 

  #initialization
  V[1,1] = 0 #log(1) = 0
   

  #start the main event

  #multiply the probability of the output for each state by the transition probability
  for i = 2:length(sequence)
    for k in states
      max_prob = typemin(Float64)
      max_prob_pointer = 1
      for x in states
        cur_prob = trans_prob[x, k] +
                   V[x, i-1]
        if cur_prob > max_prob
          max_prob = cur_prob
          max_prob_pointer = x
        end

      end
      V[k, i] = max_prob + emis_prob[k, sequence[i]]
      P[k, i] = max_prob_pointer
    end
  end

  #recover the optimal state sequence
  cur_ptr_index = find(x-> x == maximum(V[:,size(V)[2]]), V[:,size(V)[2]])[1]
  cur_ptr = P[:, size(P)[2]][cur_ptr_index]
  i = size(P)[2]
  final_seq=[cur_ptr]

  while cur_ptr != 1
    push!(final_seq, cur_ptr)
    cur_ptr =P[cur_ptr, i-1]
    i = i-1
  end
  reverse(final_seq)

end



end
