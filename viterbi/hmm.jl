include("coin.jl")

"""
type Hmm
  emis_prob
  trans_prob
  init_prob
  emis_dict
  state_dict
end
"""

coinHmm = coin.Hmm(
  [.5 .5; .2 .8],
  [.99 .01 ; .01 .99],
  [.5, .5],
  Dict("HEADS" => 1, "TAILS" => 2),
  Dict("FAIR" => 1, "LOAD" => 2)

)

diceHmm = coin.Hmm(
  [ (1/6) (1/6) (1/6) (1/6) (1/6) (1/6);
      .05   .05   .05   .05   .05  .750 ],
    [.99 .01 ; .01 .99],
    [.9, .1],
    Dict("1" =>1, "2" => 2, "3" =>3, "4"=>4, "5"=>5, "6"=>6),
    Dict("FAIR" => 1, "LOAD" => 2)
)

start_state = coin.Hmm(

  )

curHmm = diceHmm
len = 10000
b_ground = sample(collect(keys(curHmm.emis_dict)), len)

state_seq, emis_seq = coin.make_seqs(curHmm, len)
P = coin.viterbi(curHmm, b_ground)
#println("The actual state sequence is $state_seq")
#println("The guessed state sequence is $P")
#println(emis_seq)

#test it
same = 0
diff = 0
for i=1:length(emis_seq)
  if P[i] == state_seq[i]
    same = same + 1
  else
    diff = diff + 1
  end
end

#make a background sequ3ence of randomly generated emissions


#println("actual: $state_seq")
#println("viterbi: $P")
#println("seq: $emis_seq")

println("same: $same ; diff: $diff")
