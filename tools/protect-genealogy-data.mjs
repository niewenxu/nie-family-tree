import { createCipheriv, pbkdf2Sync, randomBytes } from 'node:crypto';
import { readFile, writeFile } from 'node:fs/promises';

const [sourcePath = 'data.json', publicPath = 'data.json', protectedPath = 'protected-data.json'] = process.argv.slice(2);
const mainPassword = process.env.GENEALOGY_MAIN_PASSWORD;
const pendingPassword = process.env.GENEALOGY_PENDING_PASSWORD;

if (!mainPassword || !pendingPassword) {
  throw new Error('请通过 GENEALOGY_MAIN_PASSWORD 与 GENEALOGY_PENDING_PASSWORD 环境变量提供密码。');
}

const source = JSON.parse(await readFile(sourcePath, 'utf8'));
if (!Array.isArray(source.zupu) || !Array.isArray(source.beifen)) {
  throw new Error('族谱数据结构不完整。');
}

const mainRecords = {};
const publicData = structuredClone(source);

publicData.zupu.forEach((generation, generationIndex) => {
  generation.m = generation.m.map((person, memberIndex) => {
    const protectedRecord = generationIndex >= 11 || Boolean(person.birth);
    if (!protectedRecord) return person;

    const recordKey = `${generationIndex}:${memberIndex}`;
    mainRecords[recordKey] = person;
    const rawName = String(person.n || '');
    const publicName = generationIndex >= 11
      ? `${rawName.slice(0, -1)}＿`
      : rawName;

    return {
      n: publicName,
      protected: true,
      birthKnown: Boolean(person.birth),
      recordKey
    };
  });
});

const pending = Array.isArray(source.pending) ? source.pending : [];
delete publicData.pending;
publicData.pendingCount = pending.length;

function encryptJson(value, password) {
  const salt = randomBytes(16);
  const iv = randomBytes(12);
  const iterations = 310_000;
  const key = pbkdf2Sync(password, salt, iterations, 32, 'sha256');
  const cipher = createCipheriv('aes-256-gcm', key, iv);
  const plaintext = Buffer.from(JSON.stringify(value), 'utf8');
  const encrypted = Buffer.concat([cipher.update(plaintext), cipher.final()]);
  const authTag = cipher.getAuthTag();

  return {
    algorithm: 'AES-256-GCM',
    kdf: 'PBKDF2-SHA-256',
    iterations,
    salt: salt.toString('base64'),
    iv: iv.toString('base64'),
    ciphertext: Buffer.concat([encrypted, authTag]).toString('base64')
  };
}

const protectedData = {
  version: 1,
  main: encryptJson({ records: mainRecords }, mainPassword),
  pending: encryptJson({ people: pending }, pendingPassword)
};

await writeFile(publicPath, `${JSON.stringify(publicData, null, 2)}\n`);
await writeFile(protectedPath, `${JSON.stringify(protectedData, null, 2)}\n`);

console.log(`公开数据已脱敏；主密码保护 ${Object.keys(mainRecords).length} 条，待考人员保护 ${pending.length} 条。`);
