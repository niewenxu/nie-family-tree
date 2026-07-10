'use strict';

let familyData = null;
let namesUnlocked = false;

const $ = (selector) => document.querySelector(selector);

function normalizeChinese(value) {
  const pairs = {
    聂: '聶', 榮: '荣', 進: '进', 鳳: '凤', 龍: '龙', 國: '国', 從: '从',
    廣: '广', 長: '长', 滿: '满', 財: '财', 寶: '宝', 慶: '庆', 愛: '爱',
    傑: '杰', 賢: '贤', 雲: '云', 興: '兴', 順: '顺', 義: '义', 學: '学',
    門: '门', 閆: '闫', 張: '张', 劉: '刘', 楊: '杨', 陳: '陈', 趙: '赵',
    吳: '吴', 顧: '顾', 鄒: '邹', 謝: '谢', 範: '范', 於: '于', 傳: '传'
  };
  return [...String(value).trim().toLowerCase()].map((char) => pairs[char] || char).join('');
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
  const char = familyData.beifen[generationIndex]?.char || '无固定字辈';
  const spouse = person.s && person.s !== '未知' ? person.s : '暂无记录';
  openModal(`
    <div class="modal-field"><span class="modal-label">姓名：</span><span class="modal-value" id="modalTitle">${person.n}</span></div>
    <div class="modal-field"><span class="modal-label">世系：</span><span class="modal-value">${generation}</span></div>
    <div class="modal-field"><span class="modal-label">字辈：</span><span class="modal-value">${char}</span></div>
    <div class="modal-field"><span class="modal-label">配偶：</span><span class="modal-value">${spouse}</span></div>
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
    row.className = 'gen-row visible';
    row.dataset.generation = generationIndex;
    const char = familyData.beifen[generationIndex]?.char || '';
    row.innerHTML = `
      <div class="gen-header">
        <h3>${generation.g}</h3>
        <div class="gen-info">${char ? `字辈「${char}」 · ` : ''}${generation.m.length}人</div>
        <div class="gen-line"></div>
      </div>
      <div class="gen-members"></div>
      ${generationIndex < familyData.zupu.length - 1 ? '<div class="gen-connector"></div>' : ''}
    `;

    const members = row.querySelector('.gen-members');
    people.forEach((person) => {
      const card = document.createElement('button');
      card.className = 'person-card';
      card.type = 'button';
      card.innerHTML = `<span class="p-name">${displayName(person.n, generationIndex).split('').join('<br>')}</span>`;
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
  const generations = familyData.zupu.length;
  const people = familyData.zupu.reduce((sum, generation) => sum + generation.m.length, 0);
  $('#genCount').textContent = generations;
  $('#totalCount').textContent = people;
}

function renderFloatingCharacters() {
  const chars = '天榮進登國從文清長德廣成先印家吉永慶昌';
  const fragment = document.createDocumentFragment();
  [...chars].slice(0, 16).forEach((char, index) => {
    const span = document.createElement('span');
    span.className = 'float-char';
    span.textContent = char;
    span.style.left = `${3 + ((index * 17) % 92)}%`;
    span.style.animationDelay = `${(index % 6) * 0.8}s`;
    fragment.appendChild(span);
  });
  $('#heroFloating').appendChild(fragment);
}

async function init() {
  try {
    const response = await fetch('data.json');
    if (!response.ok) throw new Error(`HTTP ${response.status}`);
    familyData = await response.json();
    renderGenerationalNames();
    renderTree();
    renderStats();
    renderFloatingCharacters();
  } catch (error) {
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
