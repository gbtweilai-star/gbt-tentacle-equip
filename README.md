# tentacle_equip

**One capability bit from GBT V8, packaged standalone.** No. 304 of 341,
`tentacle` domain (Tentacle).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> 触手**自配装备与账号**（主人令 2026-10-09）：**先有职业再谈装备** —— 职业从「vaults/agency_tentacles/library/zh」现读（272 个职业 / 19 个分域，三件套 count/examined/truncated 不截断），按分域 + 职业名关键词算出「这根触手要什么服务位 + 什么装备」，再走**两道现成的门**配上：装备走能力位 tool_bay（白名单+授权令牌），账号只从环境变量认（未配就如实报缺口，**不编账号、不存明文**）。op=status/professions/plan/report 为读类；equip 为写类（dry_run 默认真·只算不动；真配会消耗 process_execute）。**没立职业 → 空需求，不瞎配**。

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-tentacle-equip.git
cd gbt-tentacle-equip
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_tentacle_equip info                  # capability card
python -m gbt_tentacle_equip spec --json           # machine-readable contract
python -m gbt_tentacle_equip check --payload '{}'
python -m gbt_tentacle_equip run   --payload '{}'
```

Real `info` output from this machine:

```text
tentacle_equip  (tentacle)  v1.0.0
----------------------------------------
触手**自配装备与账号**（主人令 2026-10-09）：**先有职业再谈装备** —— 职业从「vaults/agency_tentacles/library/zh」现读（272 个职业 / 19 个分域，三件套 count/examined/truncated 不截断），按分域 + 职业名关键词算出「这根触手要什么服务位 + 什么装备」，再走**两道现成的门**配上：装备走能力位 tool_bay（白名单+授权令牌），账号只从环境变量认（未配就如实报缺口，**不编账号、不存明文**）。op=status/professions/plan/report 为读类；equip 为写类（dry_run 默认真·只算不动；真配会消耗 process_execute）。**没立职业 → 空需求，不瞎配**。

gated      : True   <- needs explicit consent
external   : False
multi-op   : True
params     : (none)
values     : vaults, agency_tentacles, library, zh
```

Wire a real implementation:

```python
from gbt_tentacle_equip import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| — | no | the registry declares no required parameters |

Registry hint (`params_hint`): (empty)

**注册表登记的取值 / 子动作（4 个）**：`vaults`、`agency_tentacles`、`library`、`zh`

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Gated: this bit is marked `safe: false` in the registry — it can change state that no inverse action restores.
- No external service dependency declared.
- Multi-op (`multi_op: true`): several sub-actions share one name — read `op` before calling.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
20 passed, 3 skipped in 0.14s
```

## Provenance

| field | value |
|---|---|
| capability | `tentacle_equip` |
| domain | `tentacle` |
| handler | `tentacle_equip` |
| safe | `False` (gated = `True`) |
| external | `False` |
| atlas page | [tentacle/tentacle_equip](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/tentacle/tentacle_equip.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.
