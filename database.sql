-- 聂氏族谱 数据库结构
-- 生成日期: 2026-07-09

-- 1. 辈分表
CREATE TABLE IF NOT EXISTS beifen (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  generation TEXT NOT NULL,   -- 世系名称 (始祖、二世...)
  char TEXT DEFAULT '',       -- 字辈 (單字、進、登...)
  sort_order INTEGER          -- 排序序号
);

-- 2. 族谱人物表
CREATE TABLE IF NOT EXISTS people (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  generation TEXT NOT NULL,    -- 所属世代
  name TEXT NOT NULL,          -- 姓名 (繁体)
  spouse TEXT DEFAULT '',      -- 配偶
  birth_date TEXT DEFAULT '',  -- 出生日期
  death_date TEXT DEFAULT '',  -- 过世日期
  bio TEXT DEFAULT '',         -- 简介
  sort_order INTEGER           -- 本世代内排序
);

-- 3. 家族关系连线表
CREATE TABLE IF NOT EXISTS connections (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  parent_name TEXT NOT NULL,    -- 父/祖姓名
  child_name TEXT NOT NULL,     -- 子/孙姓名
  relation_type TEXT DEFAULT '父子'  -- 关系类型
);

-- 4. 历史文献记录表
CREATE TABLE IF NOT EXISTS history_records (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,         -- 文献标题
  volume TEXT DEFAULT '',      -- 卷册
  url TEXT DEFAULT '',         -- 链接
  image_file TEXT DEFAULT '',  -- 图片文件名
  sort_order INTEGER           -- 排序
);

-- 5. 图片资源表
CREATE TABLE IF NOT EXISTS images (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  filename TEXT NOT NULL,      -- 文件名
  caption TEXT DEFAULT '',     -- 说明
  record_id INTEGER,           -- 关联文献ID
  display_order INTEGER        -- 展示顺序
);

-- ===== 初始数据 =====

-- 辈分数据
INSERT INTO beifen (generation, char, sort_order) VALUES ('始祖', '', 1);
INSERT INTO beifen (generation, char, sort_order) VALUES ('二世', '单字', 2);
INSERT INTO beifen (generation, char, sort_order) VALUES ('三世', '进', 3);
INSERT INTO beifen (generation, char, sort_order) VALUES ('四世', '登', 4);
INSERT INTO beifen (generation, char, sort_order) VALUES ('五世', '国', 5);
INSERT INTO beifen (generation, char, sort_order) VALUES ('六世', '从', 6);
INSERT INTO beifen (generation, char, sort_order) VALUES ('七世', '单字', 7);
INSERT INTO beifen (generation, char, sort_order) VALUES ('八世', '文', 8);
INSERT INTO beifen (generation, char, sort_order) VALUES ('九世', '清', 9);
INSERT INTO beifen (generation, char, sort_order) VALUES ('十世', '长', 10);
INSERT INTO beifen (generation, char, sort_order) VALUES ('十一世', '德', 11);
INSERT INTO beifen (generation, char, sort_order) VALUES ('十二世', '广', 12);
INSERT INTO beifen (generation, char, sort_order) VALUES ('十三世', '成', 13);
INSERT INTO beifen (generation, char, sort_order) VALUES ('十四世', '先', 14);
INSERT INTO beifen (generation, char, sort_order) VALUES ('十五世', '印', 15);
INSERT INTO beifen (generation, char, sort_order) VALUES ('十六世', '家', 16);
INSERT INTO beifen (generation, char, sort_order) VALUES ('十七世', '吉', 17);
INSERT INTO beifen (generation, char, sort_order) VALUES ('十八世', '永', 18);
INSERT INTO beifen (generation, char, sort_order) VALUES ('十九世', '庆', 19);
INSERT INTO beifen (generation, char, sort_order) VALUES ('二十世', '昌', 20);

-- 人物数据
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('始祖', '聶天榮', '曹氏', 1);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('二世', '聶成', '未知', 1);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('二世', '聶德', '杜氏', 2);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('二世', '聶有', '王氏', 3);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('二世', '聶福', '賀氏', 4);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('二世', '聶財', '潘氏', 5);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('二世', '聶牛', '未知', 6);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('三世', '聶進孝', '何、呂氏', 1);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('三世', '聶進悌', '王氏', 2);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('三世', '聶進學', '王氏', 3);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('三世', '聶進龍', '程氏', 4);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('三世', '聶進鳳', '王氏', 5);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('四世', '聶登賢', '呂氏', 1);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('四世', '聶登秀', '海氏', 2);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('四世', '聶登科', '程氏', 3);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('四世', '聶登金', '楊氏', 4);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('四世', '聶登銀', '柳氏', 5);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('四世', '聶登舉', '譚氏', 6);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('四世', '聶登魁', '白、王氏', 7);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('四世', '聶登雲', '王氏', 8);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('四世', '聶登明', '張氏', 9);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('四世', '聶登亮', '金氏', 10);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('四世', '聶登英', '未知', 11);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('四世', '聶登仕', '吳氏', 12);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('五世', '聶國利', '瀋氏', 1);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('五世', '聶國用', '吳氏', 2);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('五世', '聶國太', '未知', 3);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('五世', '聶國昌', '未知', 4);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('五世', '聶國安', '程氏', 5);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('五世', '聶國祥', '金氏', 6);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('五世', '聶國祿', '王氏', 7);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('五世', '聶國惠', '何氏', 8);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('五世', '聶國平', '未知', 9);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('五世', '聶國恆', '閻氏', 10);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('五世', '聶國喜', '張氏', 11);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('五世', '聶國寧', '劉氏', 12);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('五世', '聶國相', '劉氏', 13);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('五世', '聶國棟', '閆氏', 14);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('五世', '聶國治', '王氏', 15);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('五世', '聶國卿', '呂氏', 16);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('五世', '聶國陸', '趙氏', 17);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('五世', '聶國梁', '王氏', 18);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('五世', '聶國寬', '關氏', 19);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('五世', '聶國恒', '冷氏', 20);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('五世', '聶國興', '於氏', 21);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('五世', '聶國順', '高氏', 22);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('五世', '聶國臣', '冉氏', 23);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('六世', '聶從弻', '未知', 1);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('六世', '聶從傑', '張氏', 2);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('六世', '聶從發', '孟氏', 3);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('六世', '聶從富', '金氏', 4);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('六世', '聶從相', '陳氏', 5);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('六世', '聶從寶', '張氏', 6);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('六世', '聶從惠', '吳氏', 7);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('六世', '聶從儒', '於氏', 8);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('六世', '聶從柏', '張氏', 9);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('六世', '聶從宮', '呂氏', 10);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('六世', '聶從和', '嶽氏', 11);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('六世', '聶從江', '金氏', 12);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('六世', '聶從財', '李、劉、王、崔氏', 13);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('六世', '聶從德', '閆氏', 14);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('六世', '聶從美', '顧氏', 15);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('六世', '聶從福', '李氏', 16);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('六世', '聶從祿', '徐氏', 17);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('六世', '聶從壽', '吳氏', 18);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('六世', '聶從周', '鄒氏', 19);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('六世', '聶從銀', '柳氏', 20);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('六世', '聶從明', '嶽氏', 21);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('六世', '聶從金', '金氏', 22);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('六世', '聶從河', '陳氏', 23);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('六世', '聶從亮', '任氏', 24);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('六世', '聶從模', '胡氏', 25);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('六世', '聶從俊', '郭氏', 26);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('六世', '聶從義', '唐氏', 27);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('六世', '聶從任', '王氏', 28);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('六世', '聶從銀', '張氏', 29);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('六世', '聶從有', '閆、於、董氏', 30);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶貴', '未知', 1);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶柱', '魏氏', 2);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶豹', '李氏', 3);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶棟', '白氏', 4);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶會', '陶氏', 5);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶秀', '之氏', 6);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶滿', '之氏', 7);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶雲', '池氏', 8);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶春', '高氏', 9);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶功', '之氏', 10);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶勤', '朱氏', 11);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶喜', '之氏', 12);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶增', '邊氏', 13);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶祥', '夏氏', 14);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶文', '範氏', 15);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶德', '李氏', 16);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶森', '閆氏', 17);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶慶', '之氏', 18);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶全', '郭氏', 19);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶剛', '之氏', 20);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶玉', '李氏', 21);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶君', '宋氏', 22);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶棟', '苑氏', 23);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶楊', '孫氏', 24);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶永', '田氏', 25);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶進', '郭氏', 26);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶財', '宋氏', 27);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶寶', '閆氏', 28);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶升', '宋、王氏', 29);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶成', '楊氏', 30);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶美', '會氏', 31);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶義', '薑氏', 32);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶利', '張氏', 33);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶升', '白氏', 34);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶癸', '金氏', 35);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶仲', '李氏', 36);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶郭', '白氏', 37);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶魁', '劉氏', 38);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶喜', '李氏', 39);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶珍', '趙氏', 40);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶謨', '孫氏', 41);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶林', '海氏', 42);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶盛', '李氏', 43);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶張', '高氏', 44);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶和', '吳氏', 45);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶太', '楊、高氏', 46);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('七世', '聶平', '王氏', 47);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文馬', '趙氏', 1);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文芳', '郭氏', 2);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文印', '金氏', 3);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文質', '高氏', 4);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文迨', '鄒、崔氏', 5);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文增', '鄒氏', 6);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文信', '未知', 7);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文升', '鄒氏', 8);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文惠', '鄒氏', 9);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文照', '未知', 10);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文平', '張氏', 11);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文占', '鄒氏', 12);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文林', '閆氏', 13);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文明', '陳氏', 14);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文德', '吳氏', 15);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文安', '張氏', 16);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文義', '未知', 17);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文有', '未知', 18);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文連', '楊氏', 19);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文福', '敖氏', 20);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文利', '未知', 21);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文同', '未知', 22);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文祿', '趙氏', 23);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文全', '張氏', 24);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文儒', '高氏', 25);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文廷', '鄒氏', 26);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文玉', '趙氏', 27);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文秀', '孟氏', 28);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文炳', '金氏', 29);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文瑞', '謝氏', 30);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文賢', '高氏', 31);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文和', '王氏', 32);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文明', '張氏', 33);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文新', '傳氏', 34);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文森', '張氏', 35);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文煥', '未知', 36);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文恒', '吳氏', 37);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文美', '未知', 38);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文山', '嶽氏', 39);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文盛', '金氏', 40);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文太', '金氏', 41);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文魁', '門氏', 42);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文成', '範氏', 43);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文湖', '未知', 44);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文清', '馬氏', 45);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文癸', '張氏', 46);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文榮', '趙氏', 47);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文璽', '張氏', 48);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文淩', '閆氏', 49);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文明', '高、孟氏', 50);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文亮', '於氏', 51);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文廣', '範氏', 52);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文祥', '楊氏', 53);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文財', '未知', 54);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文學', '敖氏', 55);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文彬', '劉氏', 56);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文仲', '金氏', 57);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('八世', '聶文鳳', '趙氏', 58);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清玉', '未知', 1);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清田', '未知', 2);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清占', '未知', 3);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清璽', '王氏', 4);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清陽', '楊氏', 5);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清有', '未知', 6);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清滿', '張氏', 7);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清克', '趙氏', 8);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清癸', '梁氏', 9);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶門薑氏', '', 10);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶門高氏', '', 11);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶門陳氏', '', 12);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶門李氏', '', 13);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶門王氏', '', 14);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶門金氏', '', 15);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清香', '許、蔡氏', 16);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清全', '藍氏', 17);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清福', '顧氏', 18);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清奎', '未知', 19);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清聚', '門氏', 20);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清君', '吳氏', 21);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清盈', '高氏', 22);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清恩', '張、宋氏', 23);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清昌', '劉氏', 24);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清貴', '高氏', 25);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清恒', '範氏', 26);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清芝', '劉、高氏', 27);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清山', '吳氏', 28);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清平', '張氏', 29);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清廉', '未知', 30);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清武', '張氏', 31);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清祥', '傳氏', 32);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清廣', '未知', 33);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清合', '顧氏', 34);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清和', '柳氏', 35);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清榮', '魏、郭氏', 36);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清國', '張、楊、趙氏', 37);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清元', '王氏', 38);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清順', '未知', 39);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清利', '許、陳氏', 40);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清玉', '苗氏', 41);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清瑞', '未知', 42);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清吉', '張氏', 43);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清安', '未知', 44);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清太', '李氏', 45);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清林', '王氏', 46);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清雲', '未知', 47);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清柏', '未知', 48);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清振', '未知', 49);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清庫', '柳氏', 50);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清惠', '桑氏', 51);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清珍', '李氏', 52);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清周', '李氏', 53);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('九世', '聶清浦', '未知', 54);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長文', '未知', 1);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長坤', '未知', 2);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長義', '柳氏', 3);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長勤', '未知', 4);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長純', '許氏', 5);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長鳳', '張氏', 6);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長久', '張氏', 7);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長如', '常氏', 8);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長有', '宋氏', 9);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長安', '未知', 10);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長舉', '張氏', 11);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長英', '未知', 12);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長來', '宋氏', 13);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長雲', '未知', 14);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長俊', '高氏', 15);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長清', '高氏', 16);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長玉', '童氏', 17);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長和', '顧氏', 18);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長順', '顧氏', 19);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長廷', '王氏', 20);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長於', '桑氏', 21);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長占', '王氏', 22);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長升', '金氏', 23);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長忠', '關氏', 24);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長庫', '未知', 25);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長選', '未知', 26);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長貴', '宋、田氏', 27);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長春', '高氏', 28);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長明', '高氏', 29);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長富', '閆氏', 30);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長盈', '嶽氏', 31);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長勝', '陳氏', 32);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶世榮', '張氏', 33);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶世祿', '寇氏', 34);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶世恩', '張氏', 35);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長瑞', '王氏', 36);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長德', '王氏', 37);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長孫', '何氏', 38);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長太', '柳氏', 39);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長榮', '高氏', 40);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長恩', '李氏', 41);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長廣', '未知', 42);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長寶', '未知', 43);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長魁', '未知', 44);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長癸', '未知', 45);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長文', '未知', 46);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長武', '未知', 47);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長仲', '未知', 48);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長維', '未知', 49);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長儒', '未知', 50);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長武', '未知', 51);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長魁', '未知', 52);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長金', '未知', 53);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶門傳氏', '', 54);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶門閆氏', '', 55);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶門李氏', '', 56);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶門高、李氏', '', 57);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十世', '聶長清', '高氏', 58);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德一', '', 1);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德紅', '', 2);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德張', '', 3);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德勤', '魏氏', 4);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德春', '孫氏', 5);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德清', '鄭氏', 6);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德政', '王氏', 7);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德惠', '', 8);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德恩', '範氏', 9);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德俊', '', 10);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德彬', '', 11);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德申', '何氏', 12);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德賢', '張氏', 13);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德周', '王氏', 14);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德金', '', 15);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德珍', '', 16);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德興', '', 17);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德貞', '', 18);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德寶', '', 19);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德久', '', 20);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德祿', '寇氏', 21);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德廣', '', 22);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德久', '高氏', 23);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德祿', '李氏', 24);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德岩', '', 25);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德春', '', 26);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德榮', '', 27);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德忠', '', 28);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德令', '', 29);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德文', '', 30);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德元', '', 31);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德祥', '王氏', 32);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德義', '', 33);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德厚', '', 34);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德印', '顧氏', 35);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德魁', '謝氏', 36);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德昌', '支氏', 37);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德金', '李氏', 38);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德富', '郭氏', 39);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德庫', '', 40);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德潤', '', 41);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德存', '', 42);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德為', '', 43);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德本', '', 44);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德玉', '高氏', 45);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德山', '', 46);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德林', '宋氏', 47);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德升', '', 48);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德新', '顧氏', 49);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德民', '', 50);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十一世', '聶德滿', '宋氏｜春蘭', 51);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十二世', '聶廣州', '', 1);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十二世', '聶廣春', '', 2);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十二世', '聶廣傑', '', 3);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十二世', '聶廣付', '顧氏', 4);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十二世', '聶廣海', '', 5);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十二世', '聶廣慶', '', 6);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十二世', '聶廣慧', '寇氏', 7);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十二世', '聶廣武', '陳氏', 8);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十二世', '聶廣文', '', 9);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十二世', '聶廣彬', '', 10);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十二世', '聶廣鳳', '', 11);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十二世', '聶廣達', '', 12);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十二世', '聶廣仁', '', 13);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十二世', '聶廣記', '', 14);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十二世', '聶廣紅', '', 15);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十二世', '聶廣田', '', 16);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十二世', '聶廣玉', '張氏', 17);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十二世', '聶廣順', '溫氏', 18);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十二世', '聶廣俊', '張氏', 19);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十二世', '聶廣於', '吳氏', 20);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十二世', '聶廣成', '高氏', 21);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十二世', '聶廣吉', '', 22);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十二世', '聶廣有', '', 23);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十二世', '聶愛軍', '', 24);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十二世', '聶愛民', '', 25);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十二世', '聶愛國', '', 26);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十二世', '聶廣闊', '', 27);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十二世', '聶愛文', '', 28);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十三世', '聶成凡', '', 1);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十三世', '聶成祥', '', 2);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十三世', '聶成勤', '', 3);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十三世', '聶成儉', '', 4);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十三世', '聶成海', '', 5);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十三世', '聶成和', '', 6);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十三世', '聶成全', '', 7);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十三世', '聶成玉', '', 8);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十三世', '聶 日', '', 9);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十三世', '聶 強', '', 10);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十三世', '聶承財', '', 11);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十三世', '聶成龍', '', 12);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十四世', '聶先明', '', 1);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十四世', '聶先財', '', 2);
INSERT INTO people (generation, name, spouse, sort_order) VALUES ('十四世', '聶先福', '', 3);

-- 关系连线数据
INSERT INTO connections (parent_name, child_name) VALUES ('聶清庫', '聶長久');
INSERT INTO connections (parent_name, child_name) VALUES ('聶長久', '聶德滿');
INSERT INTO connections (parent_name, child_name) VALUES ('聶德滿', '聶愛軍');
INSERT INTO connections (parent_name, child_name) VALUES ('聶德滿', '聶愛國');
INSERT INTO connections (parent_name, child_name) VALUES ('聶德滿', '聶愛民');
INSERT INTO connections (parent_name, child_name) VALUES ('聶愛軍', '聶 強');
INSERT INTO connections (parent_name, child_name) VALUES ('聶愛國', '聶成龍');
INSERT INTO connections (parent_name, child_name) VALUES ('聶愛民', '聶承財');

-- 历史文献数据
INSERT INTO history_records (title, volume, url, image_file, sort_order) VALUES ('義縣志', '第十四册 人物志', 'http://read.nlc.cn/OutOpenBook/OpenTwoObjectBook?aid=403&bid=67566.0&cid=87509', '義縣志 · 第十四册 人物志_01.png', 1);
INSERT INTO history_records (title, volume, url, image_file, sort_order) VALUES ('義縣志', '第十四册 人物志', 'http://read.nlc.cn/OutOpenBook/OpenTwoObjectBook?aid=403&bid=67566.0&cid=87509', '義縣志 · 第十四册 人物志_02.png', 2);
INSERT INTO history_records (title, volume, url, image_file, sort_order) VALUES ('欽定盛京通志', '卷九十四 三十一', 'http://read.nlc.cn/OutOpenBook/OpenObjectBook?aid=403&bid=10623.0', '欽定盛京通志 · 卷九十四 三十一.png', 3);