include("vit.jl")

"""
type Hmm
  emis_prob
  trans_prob
  #init_prob
  num_emis
  num_state
end
"""

coinHmm = vit.Hmm(
  [1 0 0 ; 0 .5 .5; 0 .2 .8],
  [0 .5 .5 ; 0 .9 .1 ; 0 .1 .9]
)

state_seq, emis_seq = vit.make_seqs(coinHmm, 50)

viterbi_guess = vit.viterbi(coinHmm, emis_seq)
println("vite: $viterbi_guess")
println("real: $state_seq")