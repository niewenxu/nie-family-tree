import json
import re
from collections import Counter
from pathlib import Path

from openpyxl import load_workbook

ROOT = Path(__file__).parent
SOURCE = Path('/Users/niewenxu/Desktop/新增.xlsx')
DATA_PATH = ROOT / 'data.json'

data = json.loads(DATA_PATH.read_text(encoding='utf-8'))
rows = list(load_workbook(SOURCE, read_only=True, data_only=True).active.iter_rows(min_row=2, values_only=True))

def normalize(value):
    return re.sub(r'\s+', '', str(value or '').replace('聂', '聶'))

existing = {normalize(person['n']) for generation in data['zupu'] for person in generation['m']}
pending_existing = {normalize(person['n']) for person in data.get('pending', [])}

known_special = {
    '聶爱忠': 11,
    '聶爱华': 11,
    '聶伏雨': 12,
    '聶东升': 13,
    '聶磊': 13,
}
alias_only = {'聶文旭'}
generation_prefixes = {'德': 10, '广': 11, '成': 12, '先': 13, '印': 14}

added_generations = []
added_pending = []
skipped_existing = []
skipped_duplicate_input = []
seen = Counter()

for raw_name, raw_birth in rows:
    name = normalize(raw_name)
    birth = str(raw_birth).strip() if raw_birth else None
    seen[name] += 1
    if seen[name] > 1:
        skipped_duplicate_input.append((raw_name, birth))
        continue
    if name in alias_only or name in existing or name in pending_existing:
        skipped_existing.append((raw_name, birth))
        continue

    generation_index = known_special.get(name)
    if generation_index is None and len(name) >= 2:
        generation_index = generation_prefixes.get(name[1])

    record = {'n': name, 's': ''}
    if birth:
        record['birth'] = birth

    if generation_index is not None and generation_index >= 10:
        data['zupu'][generation_index]['m'].append(record)
        existing.add(name)
        added_generations.append((raw_name, data['zupu'][generation_index]['g'], birth))
    else:
        data.setdefault('pending', []).append(record)
        pending_existing.add(name)
        added_pending.append((raw_name, birth))

# From 广 generation onward: undated records first in stable order, then dated oldest-to-youngest.
for generation_index in range(11, len(data['zupu'])):
    people = data['zupu'][generation_index]['m']
    unknown = [person for person in people if not person.get('birth')]
    dated = sorted((person for person in people if person.get('birth')), key=lambda person: person['birth'])
    data['zupu'][generation_index]['m'] = unknown + dated

pending_people = data.get('pending', [])
pending_dated = sorted((person for person in pending_people if person.get('birth')), key=lambda person: person['birth'])
pending_unknown = [person for person in pending_people if not person.get('birth')]
data['pending'] = pending_dated + pending_unknown

DATA_PATH.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print(json.dumps({
    'added_generations': added_generations,
    'added_pending': added_pending,
    'skipped_existing_count': len(skipped_existing),
    'skipped_duplicate_input': skipped_duplicate_input,
    'total_people': sum(len(g['m']) for g in data['zupu']),
    'pending_count': len(data.get('pending', [])),
}, ensure_ascii=False, indent=2))
