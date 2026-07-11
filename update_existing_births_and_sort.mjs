import fs from 'node:fs';

const rows = `
聂德满|1935-04-25
聂广荣|1938-11-16
聂德远|1942-12-29
聂成俭|1946-01-29
聂广忠|1946-07-15
聂德柱|1947-08-21
聂德操|1949-10-06
聂成海|1950-05-02
聂爱忠|1950-06-26
聂广路|1951-01-01
聂广军|1951-01-19
聂广生|1952-05-02
聂广瑞|1952-05-09
聂德绵|1953-01-04
聂立军|1953-08-10
聂成普|1954-05-16
聂成安|1954-11-20
聂德树|1955-01-15
聂成儒|1955-09-15
聂成明|1957-01-02
聂广库|1957-01-27
聂广纯|1957-06-10
聂成绵|1957-08-10
聂爱华|1957-11-08
聂广银|1959-04-19
聂广福|1960-01-05
聂成国（聂立国）|1963-04-15
聂德礼|1963-07-25
聂成柱|1963-09-29
聂广喜|1964-02-16
聂成凤|1964-07-15
聂成荣|1964-08-07
聂广臣|1964-11-30
聂爱军|1965-10-05
聂德权|1965-10-24
聂成品|1966-01-18
聂先明|1966-02-06
聂广波|1966-08-18
聂成库|1967-05-29
聂成洪|1967-10-03
聂广元|1968-03-09
聂爱民|1968-07-02
聂成全|1969-10-29
聂军超|1971-02-05
聂成双|1971-04-15
聂广东|1971-06-27
聂爱国|1973-12-13
聂成喜|1974-04-29
聂军伟|1974-05-04
聂广忠|1974-08-12
聂先德|1974-10-11
聂先达|1975-12-15
聂德刚|1976-05-02
聂君刚|1978-03-03
聂广平|1979-01-18
聂飞|1979-06-27
聂先军|1979-09-06
聂广阔|1980-03-08
聂先伟|1980-03-29
聂日|1981-02-06
聂鹏|1982-02-15
聂健|1982-04-16
聂先奎|1982-09-19
聂成玉|1982-10-07
聂超|1983-07-15
聂成坤|1986-05-11
聂先财|1987-08-22
聂帅|1988-02-12
聂伟|1988-08-21
聂超|1989-10-24
聂爽|1989-12-14
聂靖|1990-02-16
聂强（聂文旭）|1990-05-04
聂磊|1990-05-10
聂成夺|1990-12-25
聂先福|1990-12-28
聂成旭|1991-10-20
聂承财|1991-11-20
聂晨晨|1994-07-01
聂伏雨|1994-07-05
聂印红|1994-08-20
聂成龙|1996-01-17
聂东升|1998-12-27
聂哲|1999-11-16
聂先峰|2002-03-15
聂炜峰|2005-10-01
聂椤沣|2006-03-16
聂子霖|2006-09-01
聂天箭|2008-12-25
聂鹏宇|2009-01-11
聂嘉昊|2010-12-13
聂智博|2012-12-01
聂静宇|2014-09-13
聂宇轩|2015-09-28
聂皓洋|2015-09-30
聂皓阳|2016-05-25
聂先文|2019-02-09
聂先昊|2020-01-30
聂宇|2020-04-09
`.trim().split('\n').map((line) => line.trim().split('|'));

const normalize = (name) => name.replace(/^聂/, '聶').replaceAll(' ', '');
const data = JSON.parse(fs.readFileSync('data.json', 'utf8'));

// Merge former names into the current display names before updating dates.
const gen13 = data.zupu[12].m;
const formerChengGuo = gen13.findIndex((person) => normalize(person.n) === normalize('聂成国'));
const currentLiGuo = gen13.findIndex((person) => normalize(person.n) === normalize('聂立国'));
if (formerChengGuo >= 0 && currentLiGuo >= 0) gen13.splice(formerChengGuo, 1);

const index = new Map();
for (const generation of data.zupu) {
  for (const person of generation.m) {
    const key = normalize(person.n);
    if (!index.has(key)) index.set(key, []);
    index.get(key).push(person);
  }
}

const occurrences = new Map();
const unmatched = [];
let updated = 0;
for (let [rawName, birth] of rows) {
  if (rawName === '聂成国（聂立国）') rawName = '聂立国';
  if (rawName === '聂强（聂文旭）') rawName = '聂强';
  const key = normalize(rawName);
  const occurrence = occurrences.get(key) || 0;
  occurrences.set(key, occurrence + 1);
  const matches = index.get(key) || [];
  if (!matches[occurrence]) {
    unmatched.push(`${rawName} ${birth}`);
    continue;
  }
  matches[occurrence].birth = birth;
  updated += 1;
}

// From the 广 generation onward: unknown records first in their original order,
// followed by known dates oldest-to-youngest.
for (let generationIndex = 11; generationIndex < data.zupu.length; generationIndex += 1) {
  const people = data.zupu[generationIndex].m;
  const dated = people.filter((person) => person.birth).sort((a, b) => a.birth.localeCompare(b.birth));
  const unknown = people.filter((person) => !person.birth);
  data.zupu[generationIndex].m = [...unknown, ...dated];
}

fs.writeFileSync('data.json', `${JSON.stringify(data, null, 2)}\n`);
console.log(JSON.stringify({ updated, unmatched, total: data.zupu.reduce((sum, generation) => sum + generation.m.length, 0) }, null, 2));
