module coin
export Hmm, emis_seq, state_seq
using StatsBase

type Hmm
  emis_prob
  trans_prob
  init_prob
  emis_dict
  state_dict
end

function make_seqs(hmm, T)
  emis_prob = hmm.emis_prob #coin 1 emission probability: heads and tails respectively
  trans_prob = hmm.trans_prob #transition probability is 1/10 from one to the other
  init_prob = hmm.init_prob #both states are equally likely to start
  emissions = sort(collect(keys(hmm.emis_dict)))
  states = sort(collect(keys(hmm.state_dict)))

  emis_dict = hmm.emis_dict
  state_dict = hmm.state_dict

  #The code to generate the HMM:

  state_seq = [sample(states, Weights(init_prob))]
  cur_state = state_seq[1]
  emis_seq = [sample(emissions, Weights(emis_prob[state_dict[cur_state] , :]))]


  for i in 1:T-1


      push!(emis_seq, sample(emissions, Weights(emis_prob[state_dict[cur_state] , :]))) #grabs an emission based on the current state
      push!(state_seq, cur_state)
      weights = Weights(trans_prob[:, state_dict[cur_state]])
          #println("cur state is $cur_state and the weights are $weights")
      cur_state = sample(states, weights)

  end

  state_seq, emis_seq

end

function viterbi(hmm, sequence)

  emis_prob = log(hmm.emis_prob) #coin 1 emission probability: heads and tails respectively
  trans_prob = log(hmm.trans_prob) #transition probability is 1/10 from one to the other
  init_prob = log(hmm.init_prob) #both states are equally likely to start
  emis_dict = hmm.emis_dict
  state_dict = hmm.state_dict
  emissions = sort(collect(keys(hmm.emis_dict)))
  states = sort(collect(keys(hmm.state_dict)))

  #do viterbi things
  V = ones(length(state_dict), length(sequence))*typemin(Float64)  #matrix that stores probabilities
  P = fill("start", (length(state_dict), length(sequence)))  #matrix that stores the pointers
  viterbi_state_sequence = ""

  #initialization
    for j in states
      V[state_dict[j],1] = init_prob[state_dict[j]] +
                            emis_prob[state_dict[j], emis_dict[sequence[1]]]
    end
    #start the main event

    #multiply the probability of the output for each state by the transition probability
    for i = 2:length(sequence)
      for k in states
        max_prob = typemin(Float64)
        max_prob_pointer = "start"
        for x in states
          cur_prob = trans_prob[state_dict[x], state_dict[k]] +
                     V[state_dict[x], i-1]
          if cur_prob > max_prob
            max_prob = cur_prob
            max_prob_pointer = x
          end

        end
        V[state_dict[k], i] = max_prob + emis_prob[state_dict[k], emis_dict[sequence[i]]]
        P[state_dict[k], i] = max_prob_pointer
      end
    end
#print_matrix(V)
#print_matrix(P)
    #recover the optimal state sequence
    cur_ptr_index = find(x-> x == maximum(V[:,size(V)[2]]), V[:,size(V)[2]])[1]
    cur_ptr = P[:, size(P)[2]][cur_ptr_index]
    i = size(P)[2]
    final_seq=[cur_ptr]
    while cur_ptr != "start"
      push!(final_seq, cur_ptr)
      cur_ptr =P[state_dict[cur_ptr], i-1]
      i = i-1
    end
    reverse(final_seq)

end

function print_matrix(A)
  for i=1:size(A)[1]
    println(A[i,:])
  end
end

end
