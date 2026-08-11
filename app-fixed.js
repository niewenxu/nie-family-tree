'use strict';

let familyData = null;
let protectedData = null;
let namesUnlocked = false;
let pendingUnlocked = false;
let traditionalMode = false;
let verticalMode = false;
let modalReturnFocus = null;
const failedAttempts = { main: 0, pending: 0 };
const lockedUntil = { main: 0, pending: 0 };

const $ = (selector) => document.querySelector(selector);

function escapeHTML(value) {
  return String(value ?? '').replace(/[&<>"']/g, (character) => ({
    '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;'
  })[character]);
}

function fromBase64(value) {
  return Uint8Array.from(atob(value), (character) => character.charCodeAt(0));
}

async function decryptEnvelope(envelope, password) {
  if (!envelope || envelope.algorithm !== 'AES-256-GCM' || envelope.kdf !== 'PBKDF2-SHA-256') {
    throw new Error('加密数据格式无效');
  }
  const keyMaterial = await crypto.subtle.importKey(
    'raw',
    new TextEncoder().encode(password),
    'PBKDF2',
    false,
    ['deriveKey']
  );
  const key = await crypto.subtle.deriveKey(
    { name: 'PBKDF2', salt: fromBase64(envelope.salt), iterations: envelope.iterations, hash: 'SHA-256' },
    keyMaterial,
    { name: 'AES-GCM', length: 256 },
    false,
    ['decrypt']
  );
  const packed = fromBase64(envelope.ciphertext);
  const plaintext = await crypto.subtle.decrypt(
    { name: 'AES-GCM', iv: fromBase64(envelope.iv), tagLength: 128 },
    key,
    packed
  );
  return JSON.parse(new TextDecoder().decode(plaintext));
}

function normalizeChinese(value) {
  const pairs = {
    聂: '聶', 榮: '荣', 進: '进', 鳳: '凤', 龍: '龙', 國: '国', 從: '从',
    廣: '广', 長: '长', 滿: '满', 財: '财', 寶: '宝', 慶: '庆', 愛: '爱',
    璽: '玺', 潤: '润',
    傑: '杰', 賢: '贤', 雲: '云', 興: '兴', 順: '顺', 義: '义', 學: '学',
    門: '门', 閆: '闫', 張: '张', 劉: '刘', 楊: '杨', 陳: '陈', 趙: '赵',
    吳: '吴', 顧: '顾', 鄒: '邹', 謝: '谢', 範: '范', 於: '于', 傳: '传'
  };
  return [...String(value).trim().toLowerCase()].map((char) => pairs[char] || char).join('');
}

function formatName(name) {
  return String(name).replace(/璽/g, '玺').replace(/廣/g, '广').replace(/潤/g, '润');
}

function displayName(person) {
  return person.n;
}

function renderVerticalName(name) {
  const characters = [...formatName(name).replace(/\s/g, '')];
  if (characters.length === 2) characters.splice(1, 0, null);
  return characters.map((character) => character === null
    ? '<span class="name-spacer" aria-hidden="true">　</span>'
    : `<span>${escapeHTML(character)}</span>`).join('');
}

function openModal(html) {
  modalReturnFocus = document.activeElement;
  $('#modalContent').innerHTML = html;
  $('#modalOverlay').classList.add('open');
  $('#modalOverlay').setAttribute('aria-hidden', 'false');
  document.body.classList.add('modal-open');
  $('#modalClose').focus();
}

function closeModal() {
  $('#modalOverlay').classList.remove('open');
  $('#modalOverlay').setAttribute('aria-hidden', 'true');
  document.body.classList.remove('modal-open');
  if (modalReturnFocus instanceof HTMLElement) modalReturnFocus.focus();
  modalReturnFocus = null;
}

function personModal(person, generation, generationIndex) {
  const unknown = '待考证';
  const char = familyData.beifen[generationIndex]?.char || unknown;
  const spouse = person.spouse || person.s;
  const normalizedName = String(person.n || '').replace(/\s/g, '').replace(/^聂/, '聶');
  const rawContact = String(person.contact || '');
  const contact = rawContact
    ? (normalizedName === '聶强' && namesUnlocked ? rawContact : `${rawContact.slice(0, -4)}****`)
    : unknown;
  const isFounder = generationIndex === 0;
  const fields = [
    ['字辈', char === '單字' ? '单名，无固定字辈' : char],
    ['名', formatName(person.name || person.n || unknown)],
    ['字', person.courtesyName || person.zi],
    ['号', person.artName || person.hao],
    ['生卒年月日', person.life || [person.birth, person.d].filter(Boolean).join('—')],
    ['配偶', spouse && spouse !== '未知' ? spouse : unknown],
    ['子女', person.children],
    ['联系方式', contact],
    ['迁徙地', person.migration],
    ['功名事迹', person.achievements],
    ['墓葬', person.burial],
    ['简介', person.bio || person.i]
  ].filter(([label]) => {
    if (isFounder && ['字辈', '子女', '联系方式'].includes(label)) return false;
    if (generationIndex >= 0 && generationIndex <= 10 && label === '联系方式') return false;
    return true;
  });
  openModal(`
    <div class="person-sheet-heading"><span>${escapeHTML(generation)}</span><strong id="modalTitle">${escapeHTML(formatName(person.n))}</strong></div>
    ${fields.map(([label, value]) => `<div class="modal-field"><span class="modal-label">${escapeHTML(label)}</span><span class="modal-value">${escapeHTML(value || unknown)}</span></div>`).join('')}
  `);
}

function mergeMainRecords(records) {
  familyData.zupu.forEach((generation) => {
    generation.m = generation.m.map((person) => person.recordKey && records[person.recordKey]
      ? records[person.recordKey]
      : person);
  });
}

function passwordModal(kind = 'main') {
  const isPending = kind === 'pending';
  const title = isPending ? '验证后查看世系待考' : '验证后查看族人资料';
  const inputId = `${kind}PasswordInput`;
  const errorId = `${kind}PasswordError`;
  openModal(`
    <div class="password-panel">
    <div class="modal-name" id="modalTitle">${title}</div>
    <div class="modal-divider"></div>
    <p class="password-help">资料仅在本次页面停留期间解锁；刷新或关闭页面后需重新验证。</p>
    <label for="${inputId}" class="password-label">${isPending ? '世系待考密码' : '族人资料密码'}</label>
    <div class="password-input-row">
      <input id="${inputId}" type="password" class="modal-input" autocomplete="off" autocapitalize="none" spellcheck="false" ${isPending ? '' : 'inputmode="numeric"'} aria-describedby="${errorId}">
      <button type="button" class="password-visibility" aria-label="显示密码" aria-pressed="false">显示</button>
    </div>
    <p id="${errorId}" class="form-error" role="alert" aria-live="polite"></p>
    <button type="button" class="modal-submit">验证并查看</button>
    </div>
  `);
  const input = $(`#${inputId}`);
  const submit = $('.modal-submit');
  const error = $(`#${errorId}`);
  const visibility = $('.password-visibility');
  const verify = async () => {
    const remainingLock = Math.ceil((lockedUntil[kind] - Date.now()) / 1000);
    if (remainingLock > 0) {
      error.textContent = `尝试次数过多，请 ${remainingLock} 秒后再试。`;
      return;
    }
    if (!input.value) {
      error.textContent = '请输入密码。';
      input.focus();
      return;
    }
    submit.disabled = true;
    input.disabled = true;
    visibility.disabled = true;
    submit.textContent = '验证中…';
    try {
      const payload = await decryptEnvelope(protectedData[kind], input.value);
      failedAttempts[kind] = 0;
      if (isPending) {
        familyData.pending = Array.isArray(payload.people) ? payload.people : [];
        pendingUnlocked = true;
      } else {
        mergeMainRecords(payload.records || {});
        namesUnlocked = true;
      }
      renderTree($('#searchInput').value);
      closeModal();
    } catch {
      failedAttempts[kind] += 1;
      const attemptsLeft = 5 - failedAttempts[kind];
      if (attemptsLeft <= 0) {
        failedAttempts[kind] = 0;
        lockedUntil[kind] = Date.now() + 30_000;
        error.textContent = '尝试次数过多，请 30 秒后再试。';
      } else {
        error.textContent = `密码错误，还可尝试 ${attemptsLeft} 次。`;
      }
      input.value = '';
      input.disabled = false;
      visibility.disabled = false;
      submit.disabled = false;
      submit.textContent = '验证并查看';
      input.focus();
    }
  };
  submit.addEventListener('click', verify);
  visibility.addEventListener('click', () => {
    const visible = input.type === 'text';
    input.type = visible ? 'password' : 'text';
    visibility.textContent = visible ? '显示' : '隐藏';
    visibility.setAttribute('aria-label', visible ? '显示密码' : '隐藏密码');
    visibility.setAttribute('aria-pressed', String(!visible));
    input.focus();
  });
  input.addEventListener('keydown', (event) => {
    if (event.key === 'Enter') verify();
  });
  input.focus();
}

const pendingPasswordModal = () => passwordModal('pending');

function renderGenerationalNames() {
  const track = $('#beifenTrack');
  track.replaceChildren();
  familyData.beifen.forEach((item, index) => {
    const button = document.createElement('button');
    button.className = 'beifen-item';
    button.type = 'button';
    button.innerHTML = `<span class="beifen-gen">${escapeHTML(item.gen)}</span><span class="beifen-char">${escapeHTML(item.char || '—')}</span>`;
    button.addEventListener('click', () => document.querySelector(`[data-generation="${index}"]`)?.scrollIntoView({ behavior: 'smooth', block: 'start' }));
    track.appendChild(button);
  });
}

function renderTree(query = '') {
  const container = $('#treeContainer');
  const jump = $('#genJump');
  const term = normalizeChinese(query);
  container.replaceChildren();
  jump.replaceChildren();
  let matches = 0;

  familyData.zupu.forEach((generation, generationIndex) => {
    const people = term ? generation.m.filter((person) => normalizeChinese(person.n).includes(term)) : generation.m;
    if (!people.length) return;
    matches += people.length;

    const row = document.createElement('div');
    row.className = `gen-row visible${generationIndex === 0 ? ' direct-line' : ''}`;
    row.dataset.generation = generationIndex;
    const char = familyData.beifen[generationIndex]?.char || '';
    row.innerHTML = `
      <div class="gen-header">
        <h3>${escapeHTML(generation.g)}</h3>
        <div class="gen-info">${char ? `字辈「${escapeHTML(char)}」 · ` : ''}${generation.m.length}人</div>
        <div class="gen-line"></div>
      </div>
      <div class="gen-members"></div>
      ${generationIndex < familyData.zupu.length - 1 ? '<div class="gen-connector"></div>' : ''}
    `;

    const members = row.querySelector('.gen-members');
    people.forEach((person) => {
      const card = document.createElement('button');
      card.className = 'person-card';
      if (/^聶门/.test(person.n.replace(/\s/g, ''))) card.classList.add('in-law-name');
      if (!person.birth && !person.birthKnown) card.classList.add('unknown-birth');
      card.type = 'button';
      card.innerHTML = `<span class="p-name">${renderVerticalName(displayName(person))}</span>`;
      card.addEventListener('click', () => {
        if (person.protected && !namesUnlocked) passwordModal();
        else personModal(person, generation.g, generationIndex);
      });
      members.appendChild(card);
    });
    container.appendChild(row);

    const jumpButton = document.createElement('button');
    jumpButton.className = 'gen-btn';
    jumpButton.type = 'button';
    jumpButton.textContent = generation.g;
    jumpButton.addEventListener('click', () => row.scrollIntoView({ behavior: 'smooth', block: 'start' }));
    jump.appendChild(jumpButton);
  });

  matches += renderPending(container, term);

  $('#searchStatus').textContent = term ? `找到 ${matches} 位族人` : '';
  if (!matches && (!familyData.pendingCount || term)) container.innerHTML = '<p class="empty-state">未找到匹配的族人，请尝试其他姓名。</p>';
}

function renderPending(container, term = '') {
  const pending = Array.isArray(familyData.pending) ? familyData.pending : [];
  const pendingCount = pendingUnlocked ? pending.length : Number(familyData.pendingCount || 0);
  if (!pendingCount) return 0;
  const section = document.createElement('div');
  section.className = 'gen-row pending-generation visible';
  section.innerHTML = `
    <div class="gen-header pending-header">
      <h3>世系待考</h3>
      <div class="gen-info">世系待考 · ${pendingCount}人</div>
      <div class="gen-line"></div>
    </div>
    <div class="pending-content"></div>
  `;
  const content = section.querySelector('.pending-content');
  if (!pendingUnlocked) {
    const button = document.createElement('button');
    button.type = 'button';
    button.className = 'gen-btn pending-unlock';
    button.textContent = '输入密码查看待考证';
    button.addEventListener('click', pendingPasswordModal);
    content.appendChild(button);
    container.appendChild(section);
    return 0;
  } else {
    const members = document.createElement('div');
    members.className = 'gen-members';
    const people = term ? pending.filter((person) => normalizeChinese(person.n).includes(term)) : pending;
    people.forEach((person) => {
      const card = document.createElement('button');
      card.className = 'person-card pending-person';
      if (!person.birth) card.classList.add('unknown-birth');
      card.type = 'button';
      card.innerHTML = `<span class="p-name">${renderVerticalName(person.n)}</span>`;
      card.addEventListener('click', () => personModal(person, '世系待考', -1));
      members.appendChild(card);
    });
    content.appendChild(members);
    container.appendChild(section);
    return people.length;
  }
}

function renderStats() {
  $('#genCount').textContent = `${familyData.zupu.length}+`;
  $('#totalCount').textContent = `${familyData.zupu.reduce((sum, generation) => sum + generation.m.length, 0)}+`;
}

const traditionalPairs = {聂:'聶',荣:'榮',进:'進',凤:'鳳',龙:'龍',国:'國',从:'從',广:'廣',长:'長',满:'滿',财:'財',宝:'寶',庆:'慶',爱:'愛',玺:'璽',润:'潤',义:'義',县:'縣',谱:'譜',迁:'遷',传:'傳',后:'後',里:'裏',云:'雲',学:'學',礼:'禮',开:'開',发:'發',乡:'鄉',旧:'舊',录:'錄',书:'書',门:'門'};
const scriptOriginals = new WeakMap();

function convertPageScript(toTraditional) {
  document.querySelectorAll('h1,h2,h3,p,span,strong,small,a,button,label').forEach((node) => {
    node.childNodes.forEach((textNode) => {
      if (textNode.nodeType !== Node.TEXT_NODE || !textNode.nodeValue.trim()) return;
      if (!scriptOriginals.has(textNode)) scriptOriginals.set(textNode, textNode.nodeValue);
      const original = scriptOriginals.get(textNode);
      textNode.nodeValue = toTraditional
        ? [...original].map((char) => traditionalPairs[char] || char).join('')
        : original;
    });
  });
}

function bindReadingTools() {
  $('#scriptToggle').addEventListener('click', (event) => {
    traditionalMode = !traditionalMode;
    convertPageScript(traditionalMode);
    event.currentTarget.textContent = traditionalMode ? '简' : '繁';
    event.currentTarget.setAttribute('aria-pressed', String(traditionalMode));
  });
  $('#layoutToggle').addEventListener('click', (event) => {
    verticalMode = !verticalMode;
    document.body.classList.toggle('vertical-reading', verticalMode);
    event.currentTarget.textContent = verticalMode ? '横排' : '竖排';
    event.currentTarget.setAttribute('aria-pressed', String(verticalMode));
  });
}

function renderFloatingCharacters() {
  const pools = familyData.beifen.map((generation, index) => {
    const names = familyData.zupu[index]?.m || [];
    const givenNameChars = names.flatMap((person) => [...formatName(person.n).replace(/^[聂聶]/, '').replace(/\s/g, '')]);
    const generationChars = generation.char && generation.char !== '單字' ? [...formatName(generation.char)] : [];
    return [...new Set([...generationChars, ...givenNameChars])];
  });
  const fragment = document.createDocumentFragment();
  for (let index = 0; index < 20; index += 1) {
    const pool = pools[index] || [];
    const fallback = formatName(familyData.beifen[index]?.char || '聶');
    const char = pool.length ? pool[Math.floor(Math.random() * pool.length)] : fallback;
    const span = document.createElement('span');
    span.className = 'float-char';
    span.textContent = char;
    span.style.left = `${2 + ((index * 19) % 94)}%`;
    span.style.animationDelay = `${-((index % 8) * 0.65)}s`;
    span.style.animationDuration = `${6.7 + (index % 4) * 0.55}s`;
    fragment.appendChild(span);
  }
  $('#heroFloating').appendChild(fragment);
}

async function init() {
  try {
    const [publicResponse, protectedResponse] = await Promise.all([
      fetch('data.json?v=20260811-4', { cache: 'no-store' }),
      fetch('protected-data.json?v=20260811-4', { cache: 'no-store' })
    ]);
    if (!publicResponse.ok || !protectedResponse.ok) throw new Error('族谱数据无法载入');
    familyData = await publicResponse.json();
    protectedData = await protectedResponse.json();
    if (!Array.isArray(familyData?.beifen) || !Array.isArray(familyData?.zupu) || !protectedData?.main || !protectedData?.pending) {
      throw new Error('族谱数据结构不完整');
    }
    renderGenerationalNames();
    renderTree();
    renderStats();
    bindReadingTools();
    try {
      renderFloatingCharacters();
    } catch (animationError) {
      console.warn('Background animation skipped:', animationError);
    }
  } catch (error) {
    $('#beifenTrack').innerHTML = '<span class="data-error">辈分数据加载失败，请刷新页面重试。</span>';
    $('#treeContainer').innerHTML = '<p class="empty-state">族谱数据加载失败，请通过本地服务器打开页面。</p>';
    console.error('Failed to load family data:', error);
  }

  $('#searchInput').addEventListener('input', (event) => renderTree(event.target.value));
  $('#pwBtn').addEventListener('click', () => passwordModal('main'));
  $('#modalClose').addEventListener('click', closeModal);
  $('#modalOverlay').addEventListener('click', (event) => event.target === $('#modalOverlay') && closeModal());
  document.addEventListener('keydown', (event) => {
    const overlay = $('#modalOverlay');
    if (!overlay.classList.contains('open')) return;
    if (event.key === 'Escape') {
      closeModal();
      return;
    }
    if (event.key !== 'Tab') return;
    const focusable = [...overlay.querySelectorAll('button:not([disabled]), input:not([disabled]), [href]')];
    if (!focusable.length) return;
    const first = focusable[0];
    const last = focusable[focusable.length - 1];
    if (event.shiftKey && document.activeElement === first) {
      event.preventDefault();
      last.focus();
    } else if (!event.shiftKey && document.activeElement === last) {
      event.preventDefault();
      first.focus();
    }
  });

  $('#navToggle').addEventListener('click', (event) => {
    const links = $('.nav-links');
    const isOpen = links.classList.toggle('open');
    event.currentTarget.setAttribute('aria-expanded', String(isOpen));
  });
  document.querySelectorAll('.nav-links a').forEach((link) => link.addEventListener('click', () => $('.nav-links').classList.remove('open')));
}

document.addEventListener('DOMContentLoaded', init);
