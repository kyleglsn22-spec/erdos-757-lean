---
problem: Degree vs sensitivity exponent (Tao constant C37)
source: https://teorth.github.io/optimizationproblems/constants/37a.html
lean_statement: none yet
status: active
budget_usd: 150
spent_usd: 0
owner: Kyle
---

# C37: the degree–sensitivity exponent

## Statement
C37 is the supremum of log s(f) / log deg(f) over Boolean functions f with deg(f) > 1.
Known: log3 6 ≈ 1.63093 ≤ C37 ≤ 2.

## The target
Composition powers of a base function f give exponent log s(f) / log deg(f). Beating log3 6
at degree 5 needs s(f) ≥ 14 (since 5^1.63093 ≈ 13.8). Upper bound at degree 5: s ≤ 25/(√10 − 2),
so s ≤ 21.

Question: is there q : {0,1}^14 → {0,1} with deg(q) ≤ 5, q(0) = 0 and q(e_i) = 1 for all i?
- Yes: a new record exponent log5 14 ≈ 1.6397.
- No: an impossibility certificate extending Koshta 2026 (degree 4, sensitivity 10) to degree 5.

Scout answer (2026-11-25): (14, 5) is open. Stepanovs (2012 MSc thesis, Latvia) excluded (15, 5)
by computer, so at degree 5 the maximum sensitivity is 13 or 14; his program did not finish (14, 5).
Towell (Oct 2026, with OpenAI Codex, github.com/queelius/boolean-degree-sensitivity) has conditional
partial exclusions for (14, 5) but no full answer. Symmetrisation alone does not decide it.

## Known results
| Bound or result | Reference | Checked by us? |
| --- | --- | --- |
| C37 ≥ log3 6 (Kushilevitz function: 6 bits, s = 6, degree 3) | Hatami–Kulkarni–Pankratov 2011 | No |
| No degree-4 function has sensitivity 10 | Koshta 2026 (with Claude) | No |
| s(f) ≤ deg(f)^2 / (√10 − 2) | Proskurin 2021 | No |
| No degree-5 function on 15 inputs is fully sensitive at 0 | Stepanovs 2012, MSc thesis, https://igors.org/theses/2012-boolean-deg-sens-gap-msc.pdf (computer search, uncertified) | Partly: we reproduce his 8 starting profiles and the 8 → 2 first-level cut; his level-4 kill not yet reproduced |
| (14, 5): 247 integer symmetrisation profiles | Stepanovs 2012, Table 4.1 | Yes, reproduced exactly (`explorer/c37/lvl1.py`) |
| Conditional exclusions for (14, 5) inside one Fourier geometry | Towell 2026, Zenodo 10.5281/zenodo.23539867 | No |

## Claims
| ID | Claim | Author (person + AI/model) | Status | Evidence |
| --- | --- | --- | --- | --- |
| C37-1 | Short proof of Koshta's degree-4 theorem: for any q on 10 bits, deg ≤ 4, q(0)=0, q(e_i)=1, the LP over (8,2)-block orbit sums forces Σ_k c_{9,10,k} = 14/3, which is not an integer | Kyle + Claude (Opus 5.5) | audited (internal; PR 5 review), outside review pending | `explorer/c37/results/cert_n10_d4_split8_2.json`, our two exact checkers, plus the in-house Auditor's own rebuild and second certificate (`audit/` in PR 6). Not the first short proof: Pinho 2026 (hexagonmath 2610.00694) also reproves B4 ≤ 9 by a Fourier-lattice functional |
| C37-2 | (Auditor: not auditable until exact certificates are exported) No (14, 5) function is invariant under PGL(2,13), PSL(2,13), PGL(2,7) (Heawood), PSL(3,2) (Fano points+lines), S7×C2, AGL(1,7)×C2, AGL(1,7), F21×C2, AGL(1,13) fixing a point, or D14 | Kyle + Claude (Opus 5.5) | draft | CP-SAT verdicts (`explorer/c37/groups14.py`); no exported certificates yet |

## Log
- 2026-11-25: Explorer round 1 (`explorer/c37/`). Built integer orbit-sum relaxations for every
  block partition of the coordinates. Degree 4: the (8,2) split alone is infeasible, giving claim C37-1.
  Degree 5, n = 14: every split into ≤ 3 blocks and all 4-block splits tried are feasible (no kill).
  Cross-coordinate counting (Stepanovs §6.2) cuts 247 profiles to 202 at level 1. Level 2 cuts
  n = 15 from 8 to 1 profile; level 3 timed out under CP-SAT (symmetry). Symmetric ansatz: no
  (14, 5) example for 10 groups (claim C37-2); smaller groups (C14, C7 diagonal, C13) running.
- 2026-11-25: Picked for the first round as the computational problem.

- 2026-11-25: Novelty check (`ledger/novelty-check.md`): C37-1 is an independent short proof by a
  different method, not the first alternative proof (Koshta's certificate, Pinho 2610.00694 v2).
  No Lean proof of the degree-4 result exists, so formalizing it would be a first.

## Dead ends
- Block (Young-subgroup) relaxations alone at (14, 5): feasible for every partition with ≤ 4 blocks
  tried, so they cannot settle the case without extra constraints.
- Plain CP-SAT on the level-3 cross-coordinate model: stalls on the coordinate symmetry (n = 15, 10 min).
  Needs type enumeration or orbital branching instead.
