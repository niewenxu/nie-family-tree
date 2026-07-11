import fs from 'node:fs';

const rows = `
聂广荣|1938-11-16
聂广忠|1946-07-15
聂广路|1951-01-01
聂广军|1951-01-19
聂广生|1952-05-02
聂广瑞|1952-05-09
聂广库|1957-01-27
聂广纯|1957-06-10
聂广银|1959-04-19
聂广福|1960-01-05
聂广喜|1964-02-16
聂广臣|1964-11-30
聂广波|1966-08-18
聂广元|1968-03-09
聂广东|1971-06-27
聂广忠|1974-08-12
聂广平|1979-01-18
聂成俭|1946-01-29
聂成海|1950-05-02
聂成普|1954-05-16
聂成安|1954-11-20
聂成儒|1955-09-15
聂成明|1957-01-02
聂成绵|1957-08-10
聂成国|1963-04-15
聂成柱|1963-09-29
聂成凤|1964-07-15
聂成荣|1964-08-07
聂成品|1966-01-18
聂成库|1967-05-29
聂成洪|1967-10-03
聂成全|1969-10-29
聂成双|1971-04-15
聂成喜|1974-04-29
聂日|1981-02-06
聂成玉|1982-10-07
聂成坤|1986-05-11
聂成夺|1990-12-25
聂成旭|1991-10-20
聂承财|1991-11-20
聂晨晨|1994-07-01
聂成龙|1996-01-17
聂先明|1966-02-06
聂先德|1974-10-11
聂先达|1975-12-15
聂先军|1979-09-06
聂先伟|1980-03-29
聂先奎|1982-09-19
聂先财|1987-08-22
聂先福|1990-12-28
聂先峰|2002-03-15
聂先文|2019-02-09
聂先昊|2020-01-30
聂印红|1994-08-20
聂德满|1935-04-25
聂德远|1942-12-29
聂德柱|1947-08-21
聂德操|1949-10-06
聂德绵|1953-01-04
聂德树|1955-01-15
聂德礼|1963-07-25
聂德权|1965-10-24
聂德刚|1976-05-02
`.trim().split('\n').map((line) => line.split('|'));

const generationByName = (name) => {
  if (name.startsWith('聂德')) return 10;
  if (name.startsWith('聂广')) return 11;
  if (name.startsWith('聂成') || name === '聂日' || name.startsWith('聂承') || name.startsWith('聂晨')) return 12;
  if (name.startsWith('聂先')) return 13;
  if (name.startsWith('聂印')) return 14;
  throw new Error(`无法判断世系：${name}`);
};

const normalize = (name) => name.replace(/^聂/, '聶').replaceAll(' ', '');
const data = JSON.parse(fs.readFileSync('data.json', 'utf8'));
const seenIncoming = new Map();
const skipped = [];
let updated = 0;
let added = 0;

for (const [name, birth] of rows) {
  const normalized = normalize(name);
  const occurrence = seenIncoming.get(normalized) || 0;
  seenIncoming.set(normalized, occurrence + 1);
  if (occurrence > 0 && name !== '聂广忠') {
    skipped.push(`${name} ${birth}`);
    continue;
  }
  const generation = data.zupu[generationByName(name)];
  const existing = generation.m.filter((person) => normalize(person.n) === normalized);
  if (existing.length && occurrence === 0) {
    existing[0].birth = birth;
    updated += 1;
    continue;
  }
  if (existing.length && name !== '聂广忠') {
    skipped.push(`${name} ${birth}`);
    continue;
  }
  generation.m.push({ n: normalized, s: '', birth });
  added += 1;
}

fs.writeFileSync('data.json', `${JSON.stringify(data, null, 2)}\n`);
console.log(JSON.stringify({ updated, added, skipped }, null, 2));
