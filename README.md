# Open Problems Lab

This repository is a small, serious attempt at lesser-known open problems in mathematics, run by one person
with AI agents. It is the public copy of the lab, made to accompany our write-up on
[Erdős Problem #757](https://www.erdosproblems.com/757).

**Main results (all machine-checked in Lean 4, see `Lab/Erdos757/`):** the known upper bound,
the Ma–Tang bound c ≤ 4/7, the 9/17 lower bound (conditional on Henning–Yeo), and the bound
c ≤ 5/9 for all K. Run `lake build` to check them yourself; CI does the same on every push.

Note: mentions of "PR #n" in the ledgers refer to pull requests in the lab's original private
working repository. The files they produced are all included here.

## Rules

1. **Lean is the only judge.** A result counts as checked only when it builds here with no
   `sorry`, and `scripts/Axioms.lean` shows only `propext`, `Classical.choice` and
   `Quot.sound`. CI enforces this on every pull request.
2. **Statements come from formal-conjectures** (pinned in `lakefile.toml`) whenever they
   exist there, so we prove exactly the reviewed statement.
3. **The author never audits their own claim.** The Auditor (a fresh session, ideally the
   collaborator's AI) checks that each Lean statement says what the problem says, and
   re-runs every computation with independently written code.
4. **Dead ends are results too.** Every refuted claim or abandoned approach goes in the
   ledger with the reason.
5. **Record which AI produced what**, with model and version.

## Layout

| Path | What it holds |
| --- | --- |
| `ledger/` | One Markdown file per problem: statement, status, claims, attempts, dead ends. `shortlist.md` is the candidate list. |
| `Lab/` | Lean proofs, one folder per problem. |
| `explorer/` | Search code and certificates. Every certificate has its own checker. |
| `scripts/` | CI checks: no `sorry`, axiom audit. CI runs from `.github/workflows/open-problems-lab-lean.yml` at the repo root. |

## Roles

Lead (Kyle), Scout, Explorer, Prover, Formalizer, Auditor. See `CONTRIBUTING.md`.

## Local build

```
cd open-problems-lab
curl -sSfL https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh | sh -s -- -y --default-toolchain none
lake update
lake exe cache get
lake build
scripts/check_no_sorry.sh && scripts/check_axioms.sh
```
