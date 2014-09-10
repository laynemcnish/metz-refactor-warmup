class Score

  def self.score(scoring_dice, game)
    straight = scoring_dice == ['1', '2', '3', '4', '5', '6']

    two_three_of_a_kind = (scoring_dice[0..2] && scoring_dice[0..2].length == 3 && scoring_dice[1..2].all? { |scoring_die| scoring_die == scoring_dice[0] }) &&
      (scoring_dice[3..5] && scoring_dice[3..5].length == 3 && scoring_dice[4..5].all? { |scoring_die| scoring_die == scoring_dice[3] })

    three_pairs = scoring_dice[0] == scoring_dice[1] &&
      scoring_dice[2] == scoring_dice[3] &&
      scoring_dice[4] == scoring_dice[5] &&
      scoring_dice.length == 6 &&
      !scoring_dice.all? { |scoring_die| scoring_dice[0] == scoring_die }

    three_of_a_kind =
      (scoring_dice[0..2] && scoring_dice[0..2].length == 3 && scoring_dice[1..2].all? { |scoring_die| scoring_die == scoring_dice[0] }) ||
        (scoring_dice[1..3] && scoring_dice[1..3].length == 3 && scoring_dice[2..3].all? { |scoring_die| scoring_die == scoring_dice[1] }) ||
        (scoring_dice[2..4] && scoring_dice[2..4].length == 3 && scoring_dice[3..4].all? { |scoring_die| scoring_die == scoring_dice[2] }) ||
        (scoring_dice[3..5] && scoring_dice[3..5].length == 3 && scoring_dice[4..5].all? { |scoring_die| scoring_die == scoring_dice[3] })

    four_of_a_kind =
      (scoring_dice[0..3] && scoring_dice[0..3].length == 4 && scoring_dice[1..3].all? { |scoring_die| scoring_die == scoring_dice[0] }) ||
        (scoring_dice[1..4] && scoring_dice[1..4].length == 4 && scoring_dice[2..4].all? { |scoring_die| scoring_die == scoring_dice[1] }) ||
        (scoring_dice[2..5] && scoring_dice[2..5].length == 4 && scoring_dice[3..5].all? { |scoring_die| scoring_die == scoring_dice[2] })

    five_of_a_kind =
      (scoring_dice[0..4] && scoring_dice[0..4].length == 5 && scoring_dice[1..4].all? { |scoring_die| scoring_die == scoring_dice[0] }) ||
        (scoring_dice[1..5] && scoring_dice[1..5].length == 5 && scoring_dice[2..5].all? { |scoring_die| scoring_die == scoring_dice[1] })

    six_of_a_kind =
      scoring_dice.length == 6 && scoring_dice[1..5].all? { |scoring_die| scoring_die == scoring_dice[0] }

    tally_score = 0

    if straight
      tally_score = 1500
      scoring_dice.clear
    elsif three_pairs
      tally_score = 750
      scoring_dice.clear
    elsif six_of_a_kind
      kind = scoring_dice.find { |dice| scoring_dice.count(dice) == 6 }
      if kind == '1'
        tally_score = 1000 * 4
      else
        tally_score = kind.to_i * 100 * 2 * 2 * 2
      end
      scoring_dice.delete(kind)
    elsif two_three_of_a_kind
      kind_0 = scoring_dice[0]
      kind_1 = scoring_dice[3]
      if kind_0 == '1'
        tally_score = 1000 + kind_1.to_i * 100
      else
        tally_score = kind_0.to_i * 100 + kind_1.to_i * 100
      end
      scoring_dice.clear
    elsif five_of_a_kind
      kind = scoring_dice.find { |dice| scoring_dice.count(dice) == 5 }
      if kind == '1'
        tally_score = 1000 * 3
      else
        tally_score = kind.to_i * 100 * 2 * 2
      end
      scoring_dice.delete(kind)
    elsif four_of_a_kind
      kind = scoring_dice.find { |dice| scoring_dice.count(dice) == 4 }
      if kind == '1'
        tally_score = 1000 * 2
      else
        tally_score = kind.to_i * 100 * 2
      end
      scoring_dice.delete(kind)
    elsif three_of_a_kind
      kind = scoring_dice.find { |dice| scoring_dice.count(dice) == 3 }
      if kind == '1'
        tally_score = 1000
      else
        tally_score = kind.first.to_i * 100
      end
      scoring_dice.delete(kind)
    end

    tally_score += scoring_dice.count('1') * 100 if scoring_dice.count('1') > 0 && scoring_dice.count('1') < 3
    scoring_dice.delete('1')
    tally_score += scoring_dice.count('5') * 50 if scoring_dice.count('5') > 0 && scoring_dice.count('5') < 3
    scoring_dice.delete('5')

    rejected_dice = scoring_dice

    game.available_dice += rejected_dice.length
    tally_score
  end
end