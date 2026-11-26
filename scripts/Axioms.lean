import Lab

/-!
Axiom audit. CI runs `lake env lean scripts/Axioms.lean` and fails if any theorem listed
here depends on anything other than `propext`, `Classical.choice` and `Quot.sound`.
`sorryAx` (an unfinished proof) and `Lean.ofReduceBool` (from `native_decide`) both fail.

Add a `#print axioms` line for every theorem the ledger marks as checked.
-/

#print axioms OpenProblemsLab.E757.upperBound
#print axioms OpenProblemsLab.E757.erdos_757_upperBound
#print axioms OpenProblemsLab.E757.FourSevenths.sSup_le_four_sevenths
#print axioms OpenProblemsLab.E757.LowerBound.isAdmissible_nine_seventeenths
#print axioms OpenProblemsLab.E757.LowerBound.nine_seventeenths_le_sSup
#print axioms OpenProblemsLab.E757.LowerBound.erdos_757_lowerBound_of_henningYeo
#print axioms OpenProblemsLab.E757.LowerBound.apEdges_F7Free
#print axioms OpenProblemsLab.E757.LowerBound.apEdges_linear
#print axioms OpenProblemsLab.E757.FiveNinths.sSup_le_five_ninths
