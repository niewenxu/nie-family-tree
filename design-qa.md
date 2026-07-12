# Design QA — 历史背景资料

- Source visual truth: `/Users/niewenxu/.codex/generated_images/019f4cd3-932b-71c3-a341-ffd603a16401/exec-46b33d1a-df6a-437a-a355-a1d471c62331.png`
- Implementation screenshot: `/Users/niewenxu/Desktop/Linux Mac ChromeOs/nie-family-tree/qa-history-sources-final.png`
- Viewport: desktop default; mobile additionally checked at 390 × 844
- State: `new-page.html#references`, default and hover-ready states

## Full-view comparison evidence

The implementation follows the selected archival plate direction while preserving the existing site structure. The regional evidence uses the requested 2 + 3 + 3 rhythm: two wide lead records, three supporting origin records, and three place-name extension records. The earlier gazetteer scans and the road-repair feature use the same square-cornered borders, image treatment, captions, and restrained interaction language.

## Focused-region evidence

Focused browser checks covered the document-scan row, the first two-wide regional row, the three-column rows, and the road-repair feature. Images fill fixed apertures with `object-fit: cover`; no letterboxing or image distortion is present. Caption areas align within each row. Mobile width was 390px with `scrollWidth === clientWidth`, confirming no horizontal overflow.

## Findings

- No P0/P1/P2 mismatch remains.
- Typography: existing Song/Kai families and hierarchy are retained; captions remain readable without oversized display text.
- Spacing/layout: 2 + 3 + 3 geometry, 18px gutters, and stronger inter-group spacing match the selected direction without overfilling the section.
- Colors/tokens: warm paper, ink, ochre, and hairline borders remain consistent with the site.
- Image quality: supplied historical scans are used directly, with restrained sepia/contrast and hover zoom; no fake or substitute assets.
- Copy/content: existing captions, sources, links, and ordering are preserved.

## Comparison history

- Earlier issue: irregular column spans and variable card bottoms produced a crowded, ragged layout.
- Fix: replaced the free-form mosaic with fixed 2 + 3 + 3 tracks, fixed image apertures, aligned caption regions, and a unified system for all image-bearing references.
- Post-fix evidence: desktop browser capture shows aligned outer edges and consistent image fill; mobile check shows a single-column layout without overflow; console errors: 0.

## Follow-up polish

- P3: individual `object-position` values can be tuned later if a specific historical name or map label needs to remain centered.

final result: passed
