# Achievements

A plain log of what we have done. One line per win: what we did, when, and where the proof is.
The detailed math lives in [ledger/](ledger/). Times are when the work was merged into the
main branch, in US Eastern time.

Words we use:
- **Lean-checked**: a computer proof checker (Lean) verified every step. No human trust needed for the logic.
- **Internal audit**: our own Auditor, who did not write the work, checked it. Outside review is still welcome.
- **Appears to be first**: we searched and found nobody who did this before, but we can't be certain.

## Log

- **2026-11-25, 8:34 AM ET.** We proved, with a computer-checked Lean proof, that the answer to
  Erdős problem #757 is at most 7/12 (the known bound was "less than 3/5"). This appears to be the
  first complete computer-checked proof of any bound for #757; the math itself uses an example from
  published work. Proof: lab PR #4, [UpperBound.lean](https://github.com/kyleglsn22-spec/erdos-757-lean/blob/main/Lab/Erdos757/UpperBound.lean).

- **2026-11-25, 10:00 AM ET.** Our in-house Auditor checked the 7/12 proof above and the degree-4
  sensitivity result below, and signed off on both (internal audit). Proof: lab PR #6,
  [audits.md](https://github.com/kyleglsn22-spec/erdos-757-lean/blob/main/ledger/audits.md).

- **2026-11-25, 10:01 AM ET.** We found a short, independent proof of a 2026 result by Koshta on
  "degree vs sensitivity" (Tao's problem C37) for degree 4, checked with exact arithmetic.
  **Not a first:** Pinho published a proof in October 2026, before us. Proof: lab PR #5,
  [explorer/c37/](https://github.com/kyleglsn22-spec/erdos-757-lean/blob/main/explorer/c37/).

- **2026-11-25, 10:31 AM ET.** We proved, with a computer-checked Lean proof, that the answer to
  Erdős problem #757 is at most 4/7. At the time we started this was the best published bound
  (a better 5/9 was later found posted online, not by us). This appears to be the first
  computer-checked proof of this bound; the example set comes from Ma and Tang's paper. Our Auditor
  signed off before merge (lab PR #8). Proof: lab PR #7,
  [FourSevenths.lean](https://github.com/kyleglsn22-spec/erdos-757-lean/blob/main/Lab/Erdos757/FourSevenths.lean).

- **2026-11-25, afternoon ET.** We proved in Lean that the answer to Erdős problem #757 is at
  least 9/17 ≈ 0.529 (the best known lower bound, from Ma and Tang), **conditional on one published
  theorem** (Henning–Yeo 2021, a 24-page hypergraph result that we state as an explicit assumption
  rather than prove). Every other step is computer-checked, including a fact Ma and Tang only cite
  from a 1995 paper. We have not checked whether anyone did this before. Our Auditor signed off
  (internal audit). Proof: lab PR #12,
  [LowerBound.lean](https://github.com/kyleglsn22-spec/erdos-757-lean/blob/main/Lab/Erdos757/LowerBound.lean).

- **2026-11-25, 2:10 PM ET.** For the online 5/9 construction, we proved that its largest Sidon
  subset is at most 7 + 5K for every size K. That is the counting half of the 5/9 claim. The other
  half (the copies never interact) is still unchecked by us. We also showed by computer search that
  small building blocks of this kind (12 to 14 points) cannot beat 5/9. Internal audit: pass.
  Proof and code: lab PR #13,
  [explorer/erdos757/gadgets/](https://github.com/kyleglsn22-spec/erdos-757-lean/blob/main/explorer/erdos757/gadgets/).

- **2026-11-25, 4:05 PM ET.** We checked the online 5/9 construction for every size, so the answer to
  Erdős problem #757 is at most 5/9 ≈ 0.556 (previously that rested only on AI referees). The proof
  is an exact computer check that runs in about a second. Not yet in Lean. Internal audit: pass.
  The construction itself is a reader's, not ours. Proof: lab PR #15,
  [five_ninths_all_k.py](https://github.com/kyleglsn22-spec/erdos-757-lean/blob/main/explorer/erdos757/gadgets/five_ninths_all_k.py).
- **2026-11-25, 6:00 PM ET.** We proved in Lean that the answer to Erdős problem #757 is at most
  5/9 ≈ 0.556, for every size of the reader's construction. As far as we know this is the first
  machine-checked proof of the best known upper bound. Standard axioms only, kernel re-check passed.
  Internal audit: pass. The construction itself is a reader's, not ours. Proof:
  lab PR #17,
  [FiveNinths.lean](https://github.com/kyleglsn22-spec/erdos-757-lean/blob/main/Lab/Erdos757/FiveNinths.lean).
