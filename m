Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab2CXWEE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 18:04:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54170 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401Ab2CXWDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 18:03:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: =?UTF-8?q?=5BGIT=20PULL=2005/09=5D=20ARM=3A=20SoC=20specific=20updates?=
Date: Sat, 24 Mar 2012 22:02:44 +0000
Message-Id: <1332626568-17812-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1332626568-17812-1-git-send-email-arnd@arndb.de>
References: <1332626568-17812-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:OwzF1McKrd7LaHtio5GV6ELyID3E5zhco/8zS2DeU99
 0dbPSaVwVEVqkluSuybrPpVNTvS7n/+k0FnQ9QlwxOt8qG3mmL
 hljVuuStIw8oXs6YNm6GOd5gpk0318VAvNmuOtg8nI9/kvRiXE
 PpwPn+5jbJ8zSJw9Fn9mQ/MZsdIZ96cDDkqEw8d386/P/feBhe
 g1tZvoWRTYe0RxJEf1adjkdeGqBxSTq4gOzBhSmmItzCfBT/D2
 /B5TFXOod7RCId+V7DsTYGgVWzcq0CI1MDEBpJfHD8G2v4wdR6
 YYTyWNXrXFWuWK2VQXRL3aeM/0AcbnGeerMf37fZKhG5s9Oi9G
 Ya+1E9CTMuqcVLgHaEoZJzzOxNNDjGZbOAcdsW7gQePBYesNBm
 ZGaqic3ijNKxA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These changes are all specific to an soc family or the code for
one soc. Lots of work for Tegra3 this time, but also a lot of other
platforms. There will be another (smaller) set of soc patches later in
the merge window for stuff that has dependencies on external trees or
that was sent just before the merge window opened.

The asoc tree added a few devices to the i.mx platform, which conflict
with other devices added in the same place here.

The tegra Makefile conflicts between a number of branches, mostly because
of changes regarding localtimer.c, which was removed in the end.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

The following changes since commit "c4acbfb Merge branch 'next/soc'
into for-next", leading up to commit " bde7556 Merge branch
'samsung/cleanup-exynos-clock' into nex", are available in

git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/soc

Amit Daniel Kachhap (5):
      ARM: EXYNOS: Add support AFTR mode on EXYNOS4210
      ARM: S5P: add L2 early resume code
      ARM: EXYNOS: save L2 settings during bootup
      ARM: EXYNOS: remove useless code to save/restore L2
      ARM: EXYNOS: Enable l2 configuration through device tree

Andrzej Pietrasiewicz (1):
      ARM: EXYNOS: add support JPEG

Arnd Bergmann (7):
      Merge branch 'imx/defconfig' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/soc
      Merge branch 'soc' of git://git.kernel.org/.../tmlind/linux-omap into next/soc
      Merge branch 'features/imx3' of git://git.pengutronix.de/git/imx/linux-2.6 into next/soc
      Merge tag 'tegra-soc' of git://git.kernel.org/.../olof/tegra into tegra/soc
      Merge branch 'renesas/soc' into next/soc
      Merge branch 'samsung/cleanup-exynos-clock' into next/soc
      Merge branch 'next/soc' into for-next

Changhwan Youn (1):
      ARM: EXYNOS: fix cycle count for periodic mode of clock event timers

Dan Liang (2):
      ARM: at91/at91sam9x5: overall definition
      ARM: at91/at91sam9x5: SoC basic support

Fabio Estevam (6):
      ARM: mx28: Let audio support be built by default
      ARM: mxs: Use a proper timeout mechanism
      ARM: mx3: Let mx31 and mx35 enter in LPM mode in WFI
      ARM: mx3: Setup AIPS registers
      ARM: mx5: Use common function for configuring AIPS
      ARM: mx35: Setup the AIPS registers

Jingoo Han (1):
      ARM: SAMSUNG: Add a callback 'notify_after' for PWM backlight control

Joonyoung Shim (2):
      ARM: S3C64XX: Add usb otg phy control
      ARM: S5PV210: Add usb otg phy control

Kamil Debski (1):
      ARM: SAMSUNG: add G2D to plat-s5p and mach-exynos

Lothar Waßmann (1):
      arm/mxs: Add support for SSP/MMC ports 2 & 3

Mark Brown (4):
      ARM: S3C64XX: Add basic cpuidle driver
      ARM: S3C64XX: Gate some more clocks by default
      ARM: S3C64XX: Reduce residency requirement for cpuidle WFI mode
      ARM: S3C64XX: Define some additional always off clocks

Minho Ban (1):
      ARM: SAMSUNG: use spin_lock_irqsave() in clk_{enable,disable}

MyungJoo Ham (1):
      ARM: EXYNOS: Add DMC1, allow PPMU access for DMC

Nicolas Ferre (4):
      ARM: at91/at91sam9x5: PMC header file
      ARM: at91/at91sam9x5: clock management for at91sam9x5 chip family
      ARM: at91/at91sam9x5: Configuration and Makefile
      ARM: at91/at91sam9x5: Device tree definition files

Olof Johansson (8):
      Merge branch 'ux500-timers' of git://git.kernel.org/.../linusw/linux-stericsson into next/soc
      Merge branch 'mxs/clk' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/soc
      Merge branch 'mxs/defconfig' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/soc
      Merge branch 'at91-3.4-base+9x5' of git://github.com/at91linux/linux-at91 into next/soc
      Merge branch 'for-arm-soc' of git://sources.calxeda.com/kernel/linux into next/soc
      Merge tag 'imx35-imx5-aips-setup' of git://git.pengutronix.de/git/imx/linux-2.6 into next/soc
      Merge branch 'next/devel-samsung' of git://git.kernel.org/.../kgene/linux-samsung into next/soc
      Merge branch 'soc' of git://git.kernel.org/.../rafael/renesas into next/soc

Peter De Schrijver (9):
      ARM: tegra: add support for tegra30 interrupts
      ARM: tegra: add support for new clock framework features
      ARM: tegra: implement basic tegra30 clock framework
      ARM: tegra: enable tegra30 clock framework
      ARM: tegra: initialize basic system clocks
      ARM: tegra: definitions for flow controller
      ARM: tegra: assembler code for LP3
      ARM: tegra: cpuidle driver for tegra
      ARM: tegra: Avoid compiling cpuidle code when not configured

Rob Herring (3):
      ARM: timer-sp: add sched_clock support
      ARM: highbank: enable sp804 based sched_clock
      ARM: highbank: remove unused memory.h

Shawn Guo (2):
      ARM: imx: update imx_v6_v7_defconfig
      ARM: defconfig: imx_v6_v7: build in REGULATOR_FIXED_VOLTAGE

Stephen Warren (1):
      ARM: tegra: Demote EMC clock inconsistency BUG to WARN

Sylwester Nawrocki (1):
      ARM: SAMSUNG: Correct MIPI-CSIS io memory resource definition

Tony Lindgren (1):
      Merge branch 'soc-part2' into soc

Tushar Behera (2):
      ARM: SAMSUNG: Add __init attribute to samsung_bl_set()
      ARM: SAMSUNG: fix __init attribute on regarding s3c_set_platdata()

Vaibhav Hiremath (2):
      ARM: OMAP2+: Make cpu_rev static global variable
      ARM: OMAP2+: split omap2/3/4_check_revision function

Wolfram Sang (1):
      ARM: mx28: check for gated clocks when setting saif divider


 arch/arm/Kconfig                                   |    1 +
 arch/arm/boot/dts/at91sam9g25ek.dts                |   37 +
 arch/arm/boot/dts/at91sam9x5.dtsi                  |  172 ++
 arch/arm/boot/dts/at91sam9x5cm.dtsi                |   14 +
 arch/arm/common/timer-sp.c                         |   17 +-
 arch/arm/configs/imx_v6_v7_defconfig               |    5 +-
 arch/arm/configs/mxs_defconfig                     |   20 +-
 arch/arm/include/asm/hardware/timer-sp.h           |   15 +-
 arch/arm/mach-at91/Kconfig                         |    9 +
 arch/arm/mach-at91/Makefile                        |    1 +
 arch/arm/mach-at91/at91sam9x5.c                    |  373 +++
 arch/arm/mach-at91/board-dt.c                      |    1 +
 arch/arm/mach-at91/clock.c                         |   83 +-
 arch/arm/mach-at91/include/mach/at91_pmc.h         |   60 +-
 arch/arm/mach-at91/include/mach/at91sam9x5.h       |   80 +
 .../arm/mach-at91/include/mach/at91sam9x5_matrix.h |   53 +
 arch/arm/mach-at91/include/mach/hardware.h         |    2 +
 arch/arm/mach-exynos/clock-exynos4.c               |    5 +
 arch/arm/mach-exynos/common.c                      |   60 +-
 arch/arm/mach-exynos/cpuidle.c                     |  151 +-
 arch/arm/mach-exynos/include/mach/map.h            |    7 +
 arch/arm/mach-exynos/include/mach/pmu.h            |    2 +
 arch/arm/mach-exynos/mct.c                         |   21 +-
 arch/arm/mach-exynos/pm.c                          |   15 -
 arch/arm/mach-highbank/highbank.c                  |    2 +-
 arch/arm/mach-highbank/include/mach/memory.h       |    1 -
 arch/arm/mach-imx/Makefile                         |    4 +-
 arch/arm/mach-imx/cpu-imx5.c                       |   36 -
 arch/arm/mach-imx/crmregs-imx3.h                   |    1 +
 arch/arm/mach-imx/mm-imx3.c                        |   10 +
 arch/arm/mach-imx/mm-imx5.c                        |   10 +
 arch/arm/mach-imx/pm-imx3.c                        |   37 +
 arch/arm/mach-mxs/clock-mx23.c                     |   34 +-
 arch/arm/mach-mxs/clock-mx28.c                     |   57 +-
 arch/arm/mach-mxs/devices/platform-mxs-mmc.c       |    2 +
 arch/arm/mach-mxs/include/mach/common.h            |    2 +
 arch/arm/mach-mxs/system.c                         |   16 +
 arch/arm/mach-omap2/id.c                           |  186 +-
 arch/arm/mach-omap2/io.c                           |    9 +-
 arch/arm/mach-s3c64xx/Kconfig                      |    8 +
 arch/arm/mach-s3c64xx/Makefile                     |    2 +
 arch/arm/mach-s3c64xx/clock.c                      |  121 +-
 arch/arm/mach-s3c64xx/cpuidle.c                    |   91 +
 arch/arm/mach-s3c64xx/mach-crag6410.c              |    4 +
 arch/arm/mach-s3c64xx/mach-smartq.c                |    3 +
 arch/arm/mach-s3c64xx/mach-smdk6410.c              |    4 +
 arch/arm/mach-s3c64xx/setup-usb-phy.c              |   90 +
 arch/arm/mach-s5pv210/Kconfig                      |    6 +
 arch/arm/mach-s5pv210/Makefile                     |    1 +
 arch/arm/mach-s5pv210/include/mach/regs-sys.h      |    4 -
 arch/arm/mach-s5pv210/setup-usb-phy.c              |   90 +
 arch/arm/mach-tegra/Makefile                       |    5 +-
 arch/arm/mach-tegra/board-dt-tegra30.c             |   24 +-
 arch/arm/mach-tegra/clock.c                        |   22 +
 arch/arm/mach-tegra/clock.h                        |   15 +
 arch/arm/mach-tegra/common.c                       |    1 +
 arch/arm/mach-tegra/cpuidle.c                      |  107 +
 arch/arm/mach-tegra/flowctrl.h                     |   37 +
 arch/arm/mach-tegra/include/mach/clk.h             |   10 +
 arch/arm/mach-tegra/include/mach/iomap.h           |    3 +
 arch/arm/mach-tegra/include/mach/irqs.h            |    7 +-
 arch/arm/mach-tegra/irq.c                          |   20 +-
 arch/arm/mach-tegra/sleep.S                        |   91 +
 arch/arm/mach-tegra/tegra2_clocks.c                |   30 +-
 arch/arm/mach-tegra/tegra30_clocks.c               | 3099 ++++++++++++++++++++
 arch/arm/plat-mxc/cpu.c                            |   24 +
 arch/arm/plat-mxc/include/mach/common.h            |    9 +
 arch/arm/plat-omap/include/plat/cpu.h              |    7 +-
 arch/arm/plat-s5p/Kconfig                          |   10 +
 arch/arm/plat-s5p/sleep.S                          |   44 +-
 arch/arm/plat-samsung/clock.c                      |   12 +-
 arch/arm/plat-samsung/dev-backlight.c              |    4 +-
 arch/arm/plat-samsung/devs.c                       |   68 +-
 arch/arm/plat-samsung/include/plat/devs.h          |    2 +
 .../plat-samsung/include/plat/regs-usb-hsotg-phy.h |    7 +-
 arch/arm/plat-samsung/include/plat/udc-hs.h        |    5 +
 76 files changed, 5351 insertions(+), 347 deletions(-)
