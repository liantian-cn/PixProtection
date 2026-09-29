<p align="center">
  <img src="docs/assets/hero.png" alt="PixRetribution：金白圣光与烈日惩戒骑" width="100%">
</p>

<h1 align="center">PixRetribution</h1>
<p align="center"><strong>烈日惩戒骑 · 像素读取 · 自动循环</strong></p>
<p align="center">Lua 显示战斗状态，Python 读取像素，按优先级执行技能。</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Windows-555555?style=flat-square" alt="Windows">
  <img src="https://img.shields.io/badge/Python-3.13-3776AB?style=flat-square" alt="Python 3.13">
  <img src="https://img.shields.io/badge/UI-PySide6-41CD52?style=flat-square" alt="PySide6">
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-GPLv3-B32636?style=flat-square" alt="GPLv3"></a>
</p>

## 项目简介

PixRetribution 是运行在 Windows 上的《魔兽世界》烈日惩戒骑像素循环工具，从 PixBlood 迁移而来。游戏内插件显示圣能、技能冷却、审判充能、增益和单位状态；Python 桌面程序截图解码，执行一套手写优先级循环并发送按键。

这是一个项目、一套循环、一套配置，不提供多个循环或配置档案入口。

## 快速开始

### 1. 环境

| 项目 | 要求 |
| --- | --- |
| 系统 | Windows |
| Python | 3.13，使用 uv 管理依赖 |
| 游戏 | 《魔兽世界》正式服，圣骑士惩戒专精，烈日循环所需天赋 |
| 语言 | 当前技能宏使用简体中文名称 |
| 插件声明 | Interface `120100`，版本 `12.1.0.68209`；这是仓库声明，其他版本未验证 |

```powershell
git clone https://github.com/liantian-cn/PixRetribution.git
cd PixRetribution
uv sync --python 3.13
uv run python -m pix.main
```

### 2. 安装插件

1. 启动游戏，等待桌面程序识别进程和游戏目录。
2. 点击 **拷贝插件**，将 `pix/lua/` 全部内容复制到 `Interface/AddOns/PixRetribution/`。
3. 在游戏内执行 `/reload`，启用 PixRetribution，确认控制面板可见。

安装目录结构：

```text
Interface/AddOns/PixRetribution/
├── PixRetribution.toc
├── macro.lua
├── core/
├── cells/
└── ui/
```

手动安装时也要复制全部字体、纹理和子目录，确保 TOC 直接位于上述插件目录中。复制按钮会覆盖同名文件并保留额外文件。原 PixBlood 插件应关闭，避免两者同时绑定同一组按键；本项目使用独立的 `PixRetributionDB`，不迁移血 DK 配置。

插件沿用原项目的 CVar 设置，包括 UI 缩放、抗锯齿、亮度、对比度和镜头设置，详见 [base.lua](pix/lua/core/base.lua)。宏只为圣骑士惩戒专精绑定；切换专精后需要 `/reload`。

### 3. 启动

1. 保持游戏内像素区域在桌面上可见且无遮挡。
2. 点击 **启动截图**，确认定位成功。
3. 确认游戏内插件已启用，再点击 **启动循环**。
4. 进入战斗并选择存活、可攻击的目标。

**停止循环**会保留截图；**停止截图**会先停止循环。重新启动截图后，需要重新启动循环。Lua 插件与 Python 程序必须来自同一版像素布局。

## 配置与控制

### 游戏内设置

| 设置 | 默认值 | 行为 |
| --- | --- | --- |
| 输出模式 | 自动 | 自动按责难范围敌人数选择分支；另一选项为强制单体 |
| 四件套 | 开启 | 启用 JSON 标注的特殊四件套规则；没有四件套时关闭 |
| 爆发药水 | 关闭 | 独立允许圣光潜力，不随爆发倒计时联动 |
| 打断黑名单 | 沿用内置默认列表 | 按法术 ID 升序取前 15 项做图标匹配 |

以上设置保存到 `PixRetributionDB`。启停、爆发和延迟计时是运行时状态。强制单体仍保留已开启的四件套特殊神圣风暴规则，并非绝不使用范围技能。

| 命令 | 作用 |
| --- | --- |
| `/retribtion` | 显示命令帮助 |
| `/retribtion toggle` | 切换插件启停 |
| `/retribtion disable` | 关闭插件 |
| `/retribtion burst` | 开启 15 秒爆发窗口 |
| `/retribtion burst 30` | 开启 30 秒爆发窗口 |
| `/retribtion burst 0` | 结束爆发窗口 |
| `/retribtion delay 0.4` | 暂停全部自动动作 0.4 秒；省略秒数也是 0.4 秒 |

命令按项目约定拼写为 **`/retribtion`**。插件加载时默认启用，初始化 60 秒爆发窗口。复仇之怒受窗口控制；处决宣判和圣洁鸣钟按复仇之怒 buff 判断，其他输出技能不会因窗口关闭而全部停止。

### 桌面端

| 设置 | 默认值 | 行为 |
| --- | --- | --- |
| 截图 FPS | 25 | 15–35 |
| Action 基础 FPS | 10 | 8–16；普通间隔在基础间隔的 ±50% 范围内随机浮动 |
| 游戏进程 | 自动发现 | 使用首个 `wow.exe`，进程退出后重新查找 |
| 设置保存 | 本次运行 | 重启后恢复默认值 |

### 键位

插件通过安全按钮绑定宏，无需手动创建。当前有 16 个循环键位及一个重载键位。

| 组合键 | 动作 |
| --- | --- |
| 右 Ctrl + 小键盘 1 | 目标最终审判 |
| 右 Ctrl + 小键盘 2 | 焦点责难 |
| 右 Ctrl + 小键盘 3 | 目标责难 |
| 右 Ctrl + 小键盘 4 | 复仇之怒 |
| 右 Ctrl + 小键盘 5 | 目标处决宣判 |
| 右 Ctrl + 小键盘 6 | 灰烬觉醒 |
| 右 Ctrl + 小键盘 7 | 目标公正之剑 |
| 右 Ctrl + 小键盘 8 | 圣光潜力 |
| 右 Ctrl + 小键盘 9 | 目标审判 |
| 右 Ctrl + 小键盘 0 | 神圣风暴 |
| 右 Shift + 小键盘 1 | 目标圣洁鸣钟 |
| 右 Shift + 小键盘 2 | 自身圣疗术 |
| 右 Shift + 小键盘 3 | 圣盾术 |
| 右 Shift + 小键盘 4 | 自身荣耀圣令 |
| 右 Shift + 小键盘 5 | 治疗石 item:5512 |
| 右 Shift + 小键盘 6 | 银月城生命药水 item:241304 |
| Ctrl + F12 | `/reload` |

圣光潜力沿用 item:241308 的库存及冷却监控，物品宏保留 241308／241309。调整键位时同时更新 Lua 宏、Python `keymap` 和此表。

## 循环说明

全局门禁包括插件启停、延迟、玩家存活与战斗、载具／聊天／地面选点、施法／引导／蓄力和目标有效性。通过门禁后，先处理双对象打断，再按 JSON 顺序处理自保：

| 优先级 | 条件 | 动作 |
| --- | --- | --- |
| 1 | 血量 ≤20%，冷却就绪 | 自身圣疗术 |
| 2 | 血量 ≤15%，冷却就绪 | 圣盾术 |
| 3 | 血量 ≤60%，圣能 ≥3 | 自身荣耀圣令 |
| 4 | 血量 ≤30%，物品就绪 | 治疗石 |
| 5 | 血量 ≤30%，物品就绪 | 银月城生命药水 |

保留上述顺序，未重新优化保命策略。随后处理独立爆发药水、复仇之怒、处决宣判和 JSON 的资源／增益优先级。源 JSON 的重复规则也保留顺序，代码注释标明对应规则编号。

监控的循环 buff 为 `31884、408458、431522、406086、1306162`，均只需要存在性，不需要层数或剩余时间。敌人数只统计姓名板中责难范围内存活、可攻击且射程可观察的单位，不要求敌人已入战。秘密或 nil 射程不计入；自动模式计数为 0 时，不强行按单体处理。

## 工作原理与开发

```mermaid
flowchart LR
    A[WoW Lua 插件] -->|色块、进度条、图标| B[GDI 截图与定位]
    B --> C[Matrix 像素解码]
    C --> D[Context 状态对象]
    D --> E[Rotation 优先级决策]
    E --> F[Action 顺序执行]
    F -->|按键消息| G[游戏窗口与技能宏]
```

截图线程发布最新帧，Action 线程顺序解码、决策、执行。循环首次命中返回一个动作，没有匹配规则时返回 `Idle`。截图失败或帧龄超过 0.5 秒时，不执行该帧的按键动作。日志表示程序选择了动作，不代表游戏确认施法成功。

| 模块 | 职责 |
| --- | --- |
| `pix/lua/` | 显示状态、配置面板、技能宏 |
| `pix/capture.py` | GDI 截图、定位与截图线程 |
| `pix/matrix.py` | Cell、ValueBar 和 IconTile 解码 |
| `pix/context.py` | 像素状态对应的语义属性 |
| `pix/rotation.py` | 唯一的循环与键位映射 |
| `pix/action.py` | 动作类型及顺序执行线程 |
| `pix/keyboard.py` | 向游戏窗口发送按键 |
| `pix/ui.py` | PySide6 UI、进程发现、插件复制与线程管理 |
| `pix/main.py` | 应用入口 |

当前协议为 4 px Cell、12 px 高基板，详见 [layout.md](layout.md)。修改布局要同步 Lua、Context 和文档；本次迁移复用既有编码方法，未修改 Capture、Matrix、Keyboard 或 Action。

```powershell
uv run pyright pix
uv run python -m compileall pix
git diff --check
```

仓库没有自动化测试框架。修改代码后重启桌面程序；插件显示、技能状态和实际施放需在游戏内验收：

1. `/reload` 后检查无 Lua 错误、圣能 0–5、审判 0/1/2 充能及五个 buff 的状态变化。
2. 检查目标／焦点责难射程、公正之剑和最终审判射程、单个及多个可观察敌人的分支。
3. 验证四件套和输出模式切换、重载后的配置保存，以及普通／黑名单施法的双对象打断。
4. 验证 `delay` 期间没有任何自动动作，计时结束后恢复；爆发窗口和独立药水开关分别生效。
5. 检查自保阈值、物品 ID 与实际库存、宏的施放对象及技能未知／冷却未就绪状态。

这些项目需要实机验证，静态检查不能替代。

## 排查

定位失败时，确认像素区域无遮挡、`base.lua` 中 `debug = false`，可先执行不发送按键的诊断：

```powershell
uv run python -m pix.test_captura
```

没有动作时，查看日志中的 `Idle` 原因，同时确认插件和循环已分别启用、玩家已入战、目标可攻击、延迟已结束。技能有日志但未施放时，检查宏绑定、语言、射程、资源、天赋和冷却。

## 许可证

本项目采用 [GNU General Public License v3.0](LICENSE)。横幅使用内置 imagegen 生成，[提示词与生成说明](docs/assets/hero.prompt.md)随资源保存。
