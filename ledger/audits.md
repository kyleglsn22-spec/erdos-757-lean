# Audit log

Internal audits by the lab's in-house Auditor (Claude, Opus 5.5, in a thread kept separate from the
prover threads). An internal audit is the CONTRIBUTING.md "Auditor who did not write it" check, done
in-house. **Outside review is still welcome**: anyone may re-run `audit/` or challenge a verdict.

Verdicts: **pass** (claim and statement hold), **pass with notes**, **fail**, **not auditable** (no
certificate to check).

---

## 2026-11-25 · Claim 757-1 (Erdős #757 upper bound, PR #4, main 013420f) · **pass with notes**

**Statement fidelity.**
- erdosproblems.com/757: finite A ⊂ ℝ, every 4-subset B has |B − B| ≥ 11, best c with a Sidon subset
  of size ≥ c|A|. Upstream `Erdos757.IsAdmissible` (formal-conjectures 9097e2f) says exactly this,
  quantified over every finite `A : Set ℝ`. |B − B| = 1 + 2·(number of distinct positive differences),
  so `11 ≤ (B - B).ncard` is "at least 5 distinct positive differences". Checked by enumeration too.
- `IsSidon` (FormalConjecturesForMathlib/Combinatorics/Basic.lean) is the sum form
  i₁ + i₂ = j₁ + j₂ → {i₁,i₂} = {j₁,j₂}, including i₁ = i₂. That is the standard Sidon notion.
- Junk values: `sSup` on ℝ returns 0 for empty or unbounded sets. Not an issue here: the set is
  nonempty (c = 0) and bounded (c ≤ 1 via a one-point A), and our proof bounds every element by 7/12
  with `Real.sSup_le`, so it does not exploit junk values.
- "Every n" vs asymptotic reading: the Lean statement takes inf over all finite sets. By Ma–Tang
  (arXiv:2602.23282, Prop. 3.7, subadditivity) inf_n f(n)/n = lim f(n)/n, so the two readings agree
  and a single finite witness is a legitimate upper bound.
- `OpenProblemsLab.E757.erdos_757_upperBound` has the same type as upstream
  `erdos_757.variants.upperBound` (textual copy, same vacuous `{A : Set ℝ}` binder, no local
  shadowing of `IsAdmissible`).

**Proof.** CI on main 013420f: build, no sorry, axioms `[propext, Classical.choice, Quot.sound]` for
both theorems, leanchecker passes (run 45625045247). The witness was rechecked by the Auditor's own
script `audit/erdos757_check.py` (bitmask enumeration, difference-form Sidon test, cross-checked
against the sum form on all 4096 subsets): all 495 four-subsets pass, largest Sidon subset is 7
(e.g. {92, 95, 107, 184, 188, 190, 238}), exactly the 10 listed 3-APs exist.

**Notes (non-blocking).**
1. Tie the wrapper to upstream by type, so a future upstream edit cannot silently diverge:
   `example : type_of% @Erdos757.erdos_757.variants.upperBound := @erdos_757_upperBound`.
2. Stronger target with the same method: Ma–Tang's 14-point set
   {0,136,200,243,246,249,272,286,298,323,400,528,596,1056} has largest Sidon subset 8, giving
   sSup ≤ 4/7, the best known upper bound. A Lean proof of that would match the literature.
3. For the lower bound `1/2 < sSup`: the Lean statement needs a bound for every finite A, not only
   large n. Either use a bound valid for all n (Tao's page 5b quotes h(A) ≥ n − ⌊(8n−6)/17⌋ from Ma–Tang
   Lemma 2.4 + Henning–Yeo, not yet checked by us) or formalise the subadditivity step.
4. CI runs `lake update` even though `lake-manifest.json` is committed; dropping it would make builds
   use the pinned manifest exactly.

---

## 2026-11-25 · Claim 757-2 (Erdős #757 `sSup ≤ 4/7`, PR #7) · **pass**

**Statement.** `OpenProblemsLab.E757.FourSevenths.sSup_le_four_sevenths : sSup {c : ℝ | IsAdmissible c} ≤ 4 / 7`
uses upstream `Erdos757.IsAdmissible` and `IsSidon`, with no local shadowing. Fidelity of those
definitions, and why one finite witness is a legitimate upper bound, are covered in the 757-1 entry.
`≤ 4/7` is exactly Ma–Tang's (arXiv:2602.23282) bound. There is no reliance on `sSup` junk values.

**Witness.** `audit/erdos757_check_n14.py` (Auditor's own, independent of `check_n14.py`): all 1001
four-subsets pass, largest Sidon subset is 8 (e.g. {0, 136, 200, 243, 246, 298, 323, 528}), exactly
the 12 listed 3-APs.

**Proof.** Read in full. The `powersetCard_succ_insert` split (A₀ = insert 0 (insert 136 A₂)) covers all
4- and 9-subsets. The rest is the 757-1 argument. The new theorem is in `scripts/Axioms.lean`. Pass
conditional on green CI for PR #7 (build, no sorry, standard axioms, leanchecker).

Nit raised on the PR: the ledger's "upper side fully formalized" should read "best known upper bound formalized".

---

## 2026-11-25 · PR #10 (novelty check, reader's 5/9 family for #757) · **pass, conditional on one rewording**

**5/9 family (erdosproblemaday.com reader submission 7bkzb8).** I rechecked it independently with
`audit/erdos757_five_ninths.py`. The test uses the literal |B − B| ≥ 11 on every 4-subset and sum-form Sidon,
on sets scaled to integers. The largest Sidon subset comes from HiGHS MILP, a different solver from the PR's CP-SAT.
Results: S_K is a (4,5)-set with |S_K| = 11 + 9K and h = 7 + 5K for K = 0..8. K = 6 gives 37/65 < 4/7 and
K = 8 gives 47/83 ≈ 0.5663. **Verified by us: c ≤ 47/83.** The limit c ≤ 5/9 needs the claim for every K,
which rests on the site's all-depth argument (level/fixed-point lemma plus transfer matrix). AI referees
reviewed that argument and we have not checked it. Required rewording: say "5/9 claimed, 47/83 verified" in place of "the open window is 9/17 ≤ c ≤ 5/9".

**Novelty.** Fair. The 757-1/757-2 "very likely first complete Lean proofs" claim is supported by my spot checks:
formal-conjectures main still has `sorry`, and teorth `problems.yaml` lists #757 as `unformalized`. The upstream PR states
are on the novelty thread's word. "C37-1 not a first" is also fair (nit: Koshta's certificate is the original proof, not an alternative one).

**Planning note.** A Lean proof of ≤ 37/65 cannot use the enumeration method of 757-1/757-2 (C(65,38) ≈ 10^18
subsets). It needs the structured argument.

---

## 2026-11-25 · PR #13 (5/9 transfer certificate, gadget search) · **pass, conditional on two rewordings**

**Transfer certificate (`explorer/erdos757/gadgets/transfer_certificate.py`).** The telescoping is correct, and
the state conventions match, because φ is increasing with φ(a)=p and φ(b)=q. I reproduced it independently with
`audit/erdos757_five_ninths_transfer.py`: W = [[5,6,6,6],[4,5,5,5],[4,5,5,5],[4,5,5,5]], first-copy vector
[6,7,7,7], and π = (0,1,1,1), g = 5 is a valid potential. **h(S_K) ≤ 7 + 5K for every K, unconditionally:** the
upper bound is a union bound over the traces and needs no geometric assumption. Combined with the exact values
for K ≤ 8, it is tight there. For an all-K proof of c ≤ 5/9, only the geometric half is still unchecked by us:
|S_K| = 11 + 9K, no cross-copy relations, and the (4,5) property for every K.

**Negative search (no 2-point chain gadget below 5/9 with 12–14 points).** Spot-check: `ord.py 12 11 2` gives
50/50 UNSAT, as logged. The solver bounds potentials by PM (default 4), but a valid potential can need a span up
to 3·(den·t − num), which is 27, 15 and 33 for n = 12, 13 and 14. I reran n = 12 with PM = 27: still 50/50 UNSAT, so n = 12 is
complete within the class (not proof-logged). Required: rerun n = 13 and n = 14 with a sufficient PM, or label them
"bounded potentials". Also, the ledger log line must carry the class restrictions and the "not proof-logged" caveat.

---

## 2026-11-25 · PR #15 (all-K proof that the 5/9 family works, so c ≤ 5/9) · **pass**

Computer-assisted, exact, unrefereed by humans. I read the reduction step by step and found it sound:
- **Counting:** copies meet only in the glued pair, and non-adjacent copies are disjoint because O ∩ I_2 = ∅.
- **Depth normalisation:** both templates have coefficient sum 0, and φ^{−d} lowers every depth by exactly d.
- **Slot refinement:** the split into "depth exactly L+1" or "depth ≥ L+2" is complete, the intervals are closed, and ignoring distinctness of unknown slots only over-approximates.
- **Step 4:** every relation lies in some φ^d(S_1). Copy APs from copies ≥ 2 apart are disjoint, and adjacent ones lie in a common S_1 image.

Nit raised: the docstring's "copy k+1 / k+2" case and the 0/269 check are redundant.

Independent cross-check: `audit/erdos757_five_ninths_nomix.py`, separate code using depth-first refinement on the
shallowest deep slot. It finds 0 mixing relations (33,572 nodes, refined to level 3). A positive control finds the
expected adjacent-depth APs, and brute force on S_10 (101 points) finds no relation spanning non-adjacent depths.
Combined with the transfer certificate (PR #13 entry): **c ≤ 5/9 is checked by us for all K.** Not yet in Lean.

---

## 2026-11-25 · PR #17 (Lean: `sSup {c | IsAdmissible c} ≤ 5/9`, head 6f1e264) · **pass**

**Statement.** `OpenProblemsLab.E757.FiveNinths.sSup_le_five_ninths` uses upstream `IsAdmissible` and `IsSidon` only, with no local
shadowing. Every local definition (`S`, `Good`, `Rep`, `slots`, …) stays out of the final statement, so their
correctness rests on the kernel.

**Trust base.** I grepped for `sorry`/`admit`/`native_decide`/`axiom`/`implemented_by`/`extern`/`unsafe`/`opaque`, custom
syntax, and `debug`/`skipKernelTC`. There are none. The only option set is `set_option Elab.async false`, which is harmless.
CI run 45715173845 is green: axioms are [propext, Classical.choice, Quot.sound], and leanchecker replayed FiveNinths.

**Glue (read for intent).** `Rep`/`exists_rep` split every point into a known S_3 point or the interval φ^[4][0,269].
`nmA`/`nmB1`/`nmB2`/`nmT` are no-mixing through a point of O. `good_S` runs the induction, with a finite check of S_2 (`good_S2`)
and `comp_pull`. `sidon_bound` is the transfer certificate. This matches the Python proof passed under PR #15.
**c ≤ 5/9 for Erdős #757 is now Lean-checked.**

---

## 2026-11-25 · PR #19 (negative results: multi-point gluing, 16-point search) · **pass at cb059ba**

Wording check only. The 16-point run is described accurately: the first SAT call timed out on the 18 port choices tried.
The multiglue ratio is the within-copy transfer value. It is an upper bound on the Sidon growth, because cross-copy
progressions could only lower the true h. After the fix, the PR says this and notes that (4,5) validity was not checked.
"Nothing below 5/9" therefore holds only under no cross-copy progressions, and the PR now states it that way.

---

## 2026-11-25 · Claim C37-1 (short proof of Koshta's degree-4 theorem, draft PR #5, 2186ff5) · **pass with notes**

**Statement fidelity.** Koshta 2026 as listed on Tao's optimisation-constants page (37a): there is no
q : {0,1}^10 → {0,1} with deg q ≤ 4, q(0) = 0, q(e_i) = 1. C37-1 claims exactly this. This implies every
degree-≤4 Boolean f has s(f) ≤ 9: shift a maximally sensitive point to 0, negate if needed, and restrict
to 10 sensitive coordinates (restriction keeps the function Boolean and does not raise degree).

**Certificate.** Rebuilt from the definitions without PR 5's code:
- Own LP (`audit/c37_find_own_cert.py`, scipy): with the (8,2) split the feasible region of the
  orbit-sum LP is a single point; every orbit sum is pinned, including C[1,2] = 14/3 (also
  C[3,0] = 98/3). The 9+1, 7+3, 6+4, 5+5 splits are feasible, so the (8,2) split is what does the work.
- Own exact certificate (`audit/c37_own_cert.py`, standard library, exact fractions): 8 multipliers
  for C[1,2] ≥ 14/3 and 9 for C[1,2] ≤ 14/3 (17 in total, different multipliers from PR 5). Changing
  one multiplier makes it fail.
- PR 5's file `results/cert_n10_d4_split8_2.json` re-verified with the Auditor's own forms
  (`audit/c37_verify_pr5_cert.py`): lower and upper combinations each reduce to ±C[1,2] + 14/3 ≥ 0.

**Notes (non-blocking).**
1. Novelty: Pinho (hexagonmath 2610.00694, Oct 2026) says his rational lattice packet "reproves"
   B4 ≤ 9. Before calling ours new, compare with his certificate and with Wellens 2022.
2. The certificate is written in terms of class counts N(i,j); a two-line derivation of why the
   orbit sums C[a,b] are integers and why N(i,j) is affine in them would help outside readers.

## 2026-11-25 · Claim C37-2 (symmetric (14,5) exclusions, PR #5) · **not auditable yet**

CP-SAT "infeasible" verdicts only, with no exported certificate. Stays draft until each group comes
with an exact certificate (e.g. an LP/ILP infeasibility proof or a DRAT/VIPR proof) the Auditor can
recheck.

---

## 2026-11-25 · Claim 757-3 (Erdős #757 `9/17 ≤ sSup`, conditional on Henning–Yeo, 514abb3) · **pass with notes**

*Internal audit, outside review welcome.* Reviewed `Lab/Erdos757/LowerBound.lean`. Every type below
was checked with `#check`/`#print`, not taken from docstrings.

**Statement fidelity.**
- `isAdmissible_nine_seventeenths : HenningYeoBound → Erdos757.IsAdmissible (9 / 17)`
- `nine_seventeenths_le_sSup : HenningYeoBound → 9 / 17 ≤ sSup {c | Erdos757.IsAdmissible c}`
- `erdos_757_lowerBound_of_henningYeo : HenningYeoBound → ∀ {_A : Set ℝ}, 1 / 2 < sSup {c | Erdos757.IsAdmissible c}`

All three use upstream `Erdos757.IsAdmissible` and `IsSidon` without shadowing. The third has the
upstream type of `erdos_757.variants.lowerBound` (including the unused `{A}` binder), with
`HenningYeoBound` added as a hypothesis. `Is45 A` is literally the upstream condition
`∀ B ⊆ A, B.ncard = 4 → 11 ≤ (B - B).ncard`; the Auditor checked this by `rfl`. Boundedness for
`le_csSup` comes from 757-2 (`FourSevenths.admissible_le`), so there is no junk-`sSup` issue.

**`HenningYeoBound` is no stronger than the published theorem.** The source is Henning–Yeo, Graphs
Combin. 37 (2021) 867–890. The abstract says: no subhypergraph isomorphic to AG(2,3) minus two
vertices ⇒ 17τ ≤ 5n + 3m. Ma–Tang Thm 5.3 restates it as "3-uniform linear, no subhypergraph
isomorphic to F₇". The Auditor read the abstract and Ma–Tang's restatement, but not the paywalled full
text of HY Thm 7. The Lean hypothesis asks for:
- 3-element edges, which is 3-uniform;
- pairwise intersection ≤ 1, which is linear;
- `F7Free`.

It allows isolated vertices (V ⊇ ⋃E). Those only add 5 per vertex to the right-hand side, so this is
implied. Multi-edges cannot occur (`Finset`), and linearity forbids them anyway.

Induced vs non-induced: Lean excludes every not-necessarily-induced copy, which is the narrower
hypergraph class, so the result is implied under either reading. In fact the two readings coincide
for linear hypergraphs. The 6 pairs of {0..6} that F₇ leaves uncovered (14, 16, 23, 25, 36, 45)
contain no triangle, so no linear hypergraph can add an edge inside a copy of F₇.

**`HenningYeoBound` is not false or vacuous (brute force, `audit/erdos757_lower/hy.c`).** The search
covered every labeled linear `F7Free` 3-uniform hypergraph on exactly n vertices, n = 3..9, with exact
τ computed by subset bitmasks:

| n | hypergraphs | violations | min slack 5n+3m−17τ |
|---|---|---|---|
| 7 | 5,176 | 0 | 2 |
| 8 | 190,417 | 0 | 4 |
| 9 | 15,663,980 | 0 | 1 |

Smaller n also gives 0 violations.

Control run with the F₇ filter switched off:
- n = 7: exactly 420 violations, which are the 420 labeled copies of F₇ (slack −1).
- n = 8: 840 violations (AG(2,3) minus a point, slack −4).

So the filter removes exactly the known extremal obstructions and nothing else. A second, independent
Python implementation (`audit/erdos757_lower/rand.py`) ran 4,917 random greedy linear F₇-free
hypergraphs on 9–14 vertices: 0 violations, min slack 1. The same script confirms that AG(2,3) minus
two points has 5 edges and is a copy of F₇.

**`F7Free`.** Injective `g : Fin 7 → α` with edges 012, 034, 056, 135, 246 all in E is exactly
"contains a (non-induced) copy of F₇". The edge list matches Ma–Tang Fig. 1, and AG(2,3) minus two
points gives this structure (see the check above).

**Proof hygiene.** `scripts/check_no_sorry.sh`: "No sorry found." `scripts/check_axioms.sh`: "Axiom
audit passed". All three theorems, `apEdges_F7Free` and `apEdges_linear` use only
[propext, Classical.choice, Quot.sound]. `HenningYeoBound` is a `def … : Prop` used only as a
hypothesis, not an `axiom`/`opaque`. The file is imported by `Lab.lean`.

**Notes (non-blocking).**
1. Wording elsewhere should always say "conditional on Henning–Yeo". Upstream's docstring credits
   `1/2 < sSup` to [GyLe95] unconditionally, but this file does not formalize that proof. It reaches
   `1/2 < sSup` only through HY.
2. Tie the wrapper to upstream by type:
   `example : HenningYeoBound → type_of% @Erdos757.erdos_757.variants.lowerBound := @erdos_757_lowerBound_of_henningYeo`.
3. The docstring citation "(Gyárfás–Lehel, Prop. 2.6)" for F₇-freeness was not checked against
   GyLe95. Ma–Tang cite it as their Lemma 5.2 from [5]. Either way the Lean proof of `apEdges_F7Free`
   does not depend on it.
4. The brute-force check is evidence, not proof. The hypothesis rests on the published,
   peer-reviewed HY theorem, whose full text the Auditor did not read.
