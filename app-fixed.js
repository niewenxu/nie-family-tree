'use strict';

let familyData = null;
let namesUnlocked = false;
let traditionalMode = false;
let verticalMode = false;

const $ = (selector) => document.querySelector(selector);

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

function displayName(name, generationIndex) {
  if (namesUnlocked || generationIndex < 11) return name;
  return `${name.slice(0, -1)}＿`;
}

function openModal(html) {
  $('#modalContent').innerHTML = html;
  $('#modalOverlay').classList.add('open');
  $('#modalOverlay').setAttribute('aria-hidden', 'false');
  $('#modalClose').focus();
}

function closeModal() {
  $('#modalOverlay').classList.remove('open');
  $('#modalOverlay').setAttribute('aria-hidden', 'true');
}

function personModal(person, generation, generationIndex) {
  const unknown = '不详';
  const char = familyData.beifen[generationIndex]?.char || unknown;
  const spouse = person.spouse || person.s;
  const fields = [
    ['字辈', char === '單字' ? '单名，无固定字辈' : char],
    ['名', formatName(person.name || person.n || unknown)],
    ['字', person.courtesyName || person.zi],
    ['号', person.artName || person.hao],
    ['生卒年月日', person.life || [person.birth, person.d].filter(Boolean).join('—')],
    ['配偶', spouse && spouse !== '未知' ? spouse : unknown],
    ['子女', person.children],
    ['迁徙地', person.migration],
    ['功名事迹', person.achievements || person.bio || person.i],
    ['墓葬', person.burial]
  ];
  openModal(`
    <div class="person-sheet-heading"><span>${generation}</span><strong id="modalTitle">${formatName(person.n)}</strong></div>
    ${fields.map(([label, value]) => `<div class="modal-field"><span class="modal-label">${label}</span><span class="modal-value">${value || unknown}</span></div>`).join('')}
  `);
}

function passwordModal() {
  openModal(`
    <div class="modal-name" id="modalTitle">查看更多后人</div>
    <div class="modal-divider"></div>
    <label for="passwordInput" class="modal-label">请输入密码</label>
    <input id="passwordInput" type="password" class="modal-input" autocomplete="current-password">
    <p id="passwordError" class="form-error" role="alert"></p>
    <button id="passwordSubmit" class="modal-submit">确认</button>
  `);
  const input = $('#passwordInput');
  const submit = $('#passwordSubmit');
  const verify = () => {
    if (input.value !== '9999') {
      $('#passwordError').textContent = '密码错误，请重新输入。';
      input.focus();
      return;
    }
    namesUnlocked = true;
    renderTree($('#searchInput').value);
    closeModal();
  };
  submit.addEventListener('click', verify);
  input.addEventListener('keydown', (event) => event.key === 'Enter' && verify());
  input.focus();
}

function renderGenerationalNames() {
  const track = $('#beifenTrack');
  track.innerHTML = '';
  familyData.beifen.forEach((item, index) => {
    const button = document.createElement('button');
    button.className = 'beifen-item';
    button.type = 'button';
    button.innerHTML = `<span class="beifen-gen">${item.gen}</span><span class="beifen-char">${item.char || '—'}</span>`;
    button.addEventListener('click', () => document.querySelector(`[data-generation="${index}"]`)?.scrollIntoView({ behavior: 'smooth', block: 'start' }));
    track.appendChild(button);
  });
}

function renderTree(query = '') {
  const container = $('#treeContainer');
  const jump = $('#genJump');
  const term = normalizeChinese(query);
  container.innerHTML = '';
  jump.innerHTML = '';
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
      <button class="gen-header" type="button" aria-expanded="${generationIndex < 2 ? 'true' : 'false'}">
        <h3>${generation.g}</h3>
        <div class="gen-info">${char ? `字辈「${char}」 · ` : ''}${generation.m.length}人</div>
        <div class="gen-line"></div>
      </button>
      <div class="gen-members${generationIndex < 2 ? '' : ' mobile-collapsed'}"></div>
      ${generationIndex < familyData.zupu.length - 1 ? '<div class="gen-connector"></div>' : ''}
    `;

    const members = row.querySelector('.gen-members');
    const header = row.querySelector('.gen-header');
    header.addEventListener('click', () => {
      if (window.innerWidth > 700) return;
      const collapsed = members.classList.toggle('mobile-collapsed');
      header.setAttribute('aria-expanded', String(!collapsed));
    });
    people.forEach((person) => {
      const card = document.createElement('button');
      card.className = 'person-card';
      if (/^聶门/.test(person.n.replace(/\s/g, ''))) card.classList.add('in-law-name');
      card.type = 'button';
      card.innerHTML = `<span class="p-name">${formatName(displayName(person.n, generationIndex)).split('').join('<br>')}</span>`;
      card.addEventListener('click', () => {
        if (!namesUnlocked && generationIndex >= 11) passwordModal();
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

  $('#searchStatus').textContent = term ? `找到 ${matches} 位族人` : '';
  if (!matches) container.innerHTML = '<p class="empty-state">未找到匹配的族人，请尝试其他姓名。</p>';
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
    const sources = [
      'data.json?v=20260711-6',
      './data.json?v=20260711-6',
      'https://raw.githubusercontent.com/niewenxu/nie-family-tree/main/data.json?v=20260711-6'
    ];
    let lastError = null;
    for (const source of sources) {
      try {
        const response = await fetch(source, { cache: 'no-store' });
        if (!response.ok) throw new Error(`HTTP ${response.status}`);
        const candidate = await response.json();
        if (!Array.isArray(candidate?.beifen) || !Array.isArray(candidate?.zupu)) throw new Error('族谱数据结构不完整');
        familyData = candidate;
        break;
      } catch (error) {
        lastError = error;
      }
    }
    if (!familyData) throw lastError || new Error('族谱数据无法载入');
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
  $('#pwBtn').addEventListener('click', passwordModal);
  $('#modalClose').addEventListener('click', closeModal);
  $('#modalOverlay').addEventListener('click', (event) => event.target === $('#modalOverlay') && closeModal());
  document.addEventListener('keydown', (event) => event.key === 'Escape' && closeModal());

  $('#navToggle').addEventListener('click', (event) => {
    const links = $('.nav-links');
    const isOpen = links.classList.toggle('open');
    event.currentTarget.setAttribute('aria-expanded', String(isOpen));
  });
  document.querySelectorAll('.nav-links a').forEach((link) => link.addEventListener('click', () => $('.nav-links').classList.remove('open')));
}

document.addEventListener('DOMContentLoaded', init);
