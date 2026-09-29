<p align="center">
  <img src="docs/assets/hero.png" alt="PixProtection：防骑率队以巨盾迎击巨兽" width="100%">
</p>

<h1 align="center">PixProtection</h1>
<p align="center"><strong>铸光防骑 · 像素读取 · 自动循环</strong></p>

PixProtection是运行在Windows上的《魔兽世界》铸光防骑像素循环工具。游戏内Lua插件显示圣能、法力、充能、增益与单位状态；Python桌面程序读取像素，按手写优先级发送按键。使用Python 3.13和PySide6，一个项目、一套循环、一套配置。

## 安装与启动

```powershell
git clone https://github.com/liantian-cn/PixProtection.git
cd PixProtection
uv sync --python 3.13
uv run python -m pix.main
```

1. 启动游戏，选择圣骑士防御专精（GetSpecialization()为2），使用铸光者所需天赋。
2. 桌面程序识别游戏进程后，点击**拷贝插件**。插件安装到`Interface/AddOns/PixProtection/`，TOC为`PixProtection.toc`。
3. 游戏内执行`/reload`，确认面板和像素区域可见。其他Pix插件请关闭，避免相同键位冲突。
4. 点击**启动截图**，确认定位成功，再点击**启动循环**。

技能宏使用简体中文名称。切换专精后需要`/reload`。安装时复制整个`pix/lua/`，包括字体、纹理和所有子目录；复制按钮覆盖同名文件，保留额外文件。

截图区域必须在桌面可见且无遮挡。**停止循环**保留截图；**停止截图**会先停止循环。Lua与Python必须来自同一版布局。

插件声明Interface为120100、版本为12.1.0.68209；该声明不代表已在其他客户端版本验证。插件沿用[base.lua](pix/lua/core/base.lua)内的UI缩放、抗锯齿、亮度、对比度和镜头设置。

## 面板与控制

设置保存到独立的`PixProtectionDB`，不迁移其他插件配置。启停、爆发倒计时和手动延迟为运行时状态。

| 设置           | 默认    | 范围／行为                                         |
| -------------- | ------- | -------------------------------------------------- |
| 输出模式       | 自动    | 853射程内可观察敌人数≥2为AOE；强制单体禁止自动鸣钟 |
| 自动清毒       | 开启    | 对自身清除中毒／疾病，优先级仅在祝福之锤之前       |
| 自动饰品       | 开启    | 爆发窗口内，目标或焦点在853射程，戒卫之前先上后下  |
| 荣耀圣令：双层 | 75%     | 55–95%，步长1                                      |
| 荣耀圣令：单层 | 55%     | 35–75%，步长1                                      |
| 荣耀圣令：叠层 | 90%     | 70–100%，步长1                                     |
| 打断黑名单     | 内置5项 | 按ID升序取前15项做图标匹配；只约束责难             |

| 命令                    | 作用                                     |
| ----------------------- | ---------------------------------------- |
| `/protection`           | 显示帮助                                 |
| `/protection toggle`    | 切换启停                                 |
| `/protection disable`   | 关闭插件                                 |
| `/protection burst`     | 开启15秒爆发窗口                         |
| `/protection burst 30`  | 开启30秒爆发窗口                         |
| `/protection burst 0`   | 结束爆发窗口                             |
| `/protection delay 0.4` | 暂停全部自动动作0.4秒，省略参数也是0.4秒 |

插件加载时默认启用，并初始化60秒爆发窗口。爆发状态控制戒卫、鸣钟、军备和自动饰品；不增加一次性法术插入队列。


## 验证

```powershell
uv run pyright pix
uv run python -m compileall pix
git diff --check
uv run python -m pix.test_captura
```

最后一条为一次性截图定位，不发送按键。游戏内还需验收增益层数与时长、零／满充能、军备形态切换、射程回退、黑名单、三个治疗滑块及清毒／饰品开关。静态检查不等于游戏实测。

横幅提示词保存在[hero.prompt.md](docs/assets/hero.prompt.md)。
