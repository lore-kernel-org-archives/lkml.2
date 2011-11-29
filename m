Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab1K2XYK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 18:24:10 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:50404 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab1K2XYH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 18:24:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        olof@lixom.net, Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [GIT PULL] arm-soc fixes for 3.2, part 2
Date: Wed, 30 Nov 2011 00:23:54 +0100
Message-ID: <6468987.EmUTciWzpi@wuerfel>
User-Agent: KMail/4.7.2 (Linux/3.1.0-rc8nosema+; KDE/4.7.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:mQXBuwEkoIH9RpAkCxP5uZ04wHtdjsyKAgaXaDOoavW
 QCkwcm3V9eLsZFnmLyjdwFRfqQJkfiYnFkyCLZ4wXswL1GuTbn
 cqoY47gxjpc8D/BiHWnrA5NEjPT947FT11sEr6Z6u/oeGp6+/B
 sMesuiAZjCwUfO4HVFJ54HgH7xJTuJnzjvvL9PkaJGBJ5ZxR4O
 ew0ILJxr8DnWQW4kY3FU2e40riG0Bl4rGSl3l0MDQLPPHTDRUa
 iOSaDW3TA5rsP/dBu8Z9mOo0SjCoKb7/HGijD+IdMXuN79sj7u
 vRugX5UF6btsKx61p2+sVCVnuGWzpi4UNfz5r2g2weMRe2GoBc
 5J0bHQ0EUwwDTkHzHvvA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

It took me longer to send this out than I had hoped, resulting in somewhat more
changes than I would like to see here, but they all seem reasonable.

The largest chunk is updates for the TI OMAP DSS from Tomi, the rest is
basically trivial fixes and a few defconfig updates. I've started pushing
harder for people to bug fixes correctly as applicable for stable updates,
so we have a bunch of those now, and some others are not marked as stable
because the committer didn't want to rebase the branch, so we will follow
up with Greg to get them in as well once they are in your tree.

	Arnd

The following changes since commit caca6a03d365883564885f2c1da3e88dcf65d139:

  Linux 3.2-rc3 (2011-11-23 20:20:28 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git fixes

Archit Taneja (1):
      ARM: OMAP2PLUS: DSS: Ensure DSS works correctly if display is enabled in bootloader

Arnd Bergmann (11):
      ARM: imx: export imx_ioremap
      Merge branch 'imx6q/fixes' of git://git.linaro.org/people/shawnguo/linux-2.6 into fixes
      Merge branch 'for-arnd' of git://git.kernel.org/.../will/linux into fixes
      Merge branch 'samsung-fixes' of git://git.kernel.org/.../kgene/linux-samsung into fixes
      Merge branch 'imx-for-arnd' of git://git.pengutronix.de/git/imx/linux-2.6 into fixes
      Merge branch 'fix' of git://github.com/ycmiao/pxa-linux into fixes
      Merge branch 'mxs/for-arnd' of git://git.linaro.org/people/shawnguo/linux-2.6 into fixes
      Merge branch 'at91/defconfig' into fixes
      Merge branch 'fixes' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge branch 'fixes-dss' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge branch 'defconfigs-for-arnd' of git://git.linaro.org/people/triad/linux-stericsson into fixes

Axel Lin (1):
      ARM: SAMSUNG: include linux/types.h at gpio-cfg.h

Eric Miao (1):
      ARM: pxa168/gplugd: add the correct SSP device

Fabio Estevam (2):
      ARM: imx: Remove unused chip revision strings
      ARM: mx5: Fix checkpatch warnings in cpu-imx5.c

Felipe Balbi (1):
      ARM: OMAP: smartreflex: fix IRQ handling bug

Govindraj.R (1):
      ARM: OMAP2+: Fix Compilation error when omap_l3_noc built as module

Haojian Zhuang (2):
      ARM: pxa: fix inconsistent CONFIG_USB_PXA27X
      ARM: mmp: fix build error on gpio

Jean-Christophe PLAGNIOL-VILLARD (3):
      ARM: at91: rename defconfig files appropriately
      ARM: at91: refresh soc defconfig files for 3.2
      ARM: at91: enable additional boards in existing soc defconfig files

Kevin Hilman (2):
      ARM: OMAP3: CPUidle: include <linux/export.h>
      ARM: OMAP: PM: only register TWL with voltage layer when device is present

Kukjin Kim (2):
      ARM: S5P: Fix export.h inclusion
      ARM: SAMSUNG: inclusion export.h instead of module.h

Kyungmin Park (1):
      ARM: EXYNOS: Fix compiler error with THIS_MODULE

Linus Walleij (2):
      ARM: u300: update defconfig
      ARM: ux500: update defconfig

Ming Lei (1):
      ARM: OMAP2: select ARM_AMBA if OMAP3_EMU is defined

Paul Bolle (1):
      ARM: imx: drop 'ARCH_MX31' and 'ARCH_MX35'

Richard Zhao (1):
      ARM: imx6q: move clock register map to machine_desc.map_io

Sascha Hauer (4):
      MAINTAINERS: Add missing directory
      Merge branches 'fixes/imx3-build', 'fixes/imx_ioremap' and 'fixes/maintainer-update' into imx-fixes
      Merge branch 'cleanups/assorted' into imx-fixes-for-arnd
      Merge branch 'cleanups/remove-unused-kconfig' into imx-fixes-for-arnd

Shawn Guo (3):
      MAINTAINERS: add ARM/FREESCALE MXS entry
      arm/imx: remove imx_idle hook and use pm_idle instead
      ARM: Update mach-types to fix mxs build breakage

Thomas Weber (1):
      ARM: OMAP2+: Remove empty io.h

Tomi Valkeinen (9):
      ARM: OMAP2xxx: HWMOD: Fix DSS reset
      ARM: OMAP2xxx: HWMOD: fix DSS clock data
      ARM: OMAP3: HWMOD: Fix DSS reset
      ARM: OMAP3: HWMOD: fix DSS clock data
      ARM: OMAP4: HWMOD: remove extra clocks
      ARM: OMAP4: HWMOD: Add HWMOD_CONTROL_OPT_CLKS_IN_RESET for dss_core
      ARM: OMAP4: HWMOD: fix DSS clock data
      ARM: OMAP2/3: HWMOD: Add SYSS_HAS_RESET_STATUS for dss
      ARM: OMAP: HWMOD: Unify DSS resets for OMAPs

Tony Lindgren (5):
      ARM: OMAP: Fix map_io for Amstrad E3
      ARM: OMAP: Fix dpll_data compile error when omap2 only is selected
      ARM: OMAP: Fix reprogramming of dpll1 rate
      Merge branch 'fixes-v3.2-rc2' into fixes
      Merge branch 'hwmod_dss_fixes_3.2rc' of git://git.pwsan.com/linux-2.6 into fixes-dss

Uwe Kleine-König (1):
      ARM: imx/mm-imx3: conditionally compile i.MX31 and i.MX35 code

Will Deacon (2):
      ARM: highbank: convert logical CPU numbers to physical numbers
      ARM: mach-imx: convert logical CPU numbers to physical numbers

Wolfram Sang (1):
      arm: mx28: fix bit operation in clock setting

sricharan (1):
      ARM: OMAP: hwmod: Fix the addr space, irq, dma count APIs

 MAINTAINERS                                        |    8 +
 .../{at91cap9adk_defconfig => at91cap9_defconfig}  |    7 -
 arch/arm/configs/at91rm9200_defconfig              |   47 ++----
 ...91sam9260ek_defconfig => at91sam9260_defconfig} |   16 ++-
 ...91sam9g20ek_defconfig => at91sam9g20_defconfig} |   23 ++--
 arch/arm/configs/at91sam9g45_defconfig             |    7 +-
 ...at91sam9rlek_defconfig => at91sam9rl_defconfig} |    5 -
 arch/arm/configs/ezx_defconfig                     |    2 +-
 arch/arm/configs/imote2_defconfig                  |    2 +-
 arch/arm/configs/magician_defconfig                |    2 +-
 arch/arm/configs/omap1_defconfig                   |    1 -
 arch/arm/configs/u300_defconfig                    |   13 +-
 arch/arm/configs/u8500_defconfig                   |   14 +-
 arch/arm/configs/zeus_defconfig                    |    2 +-
 arch/arm/mach-exynos/cpuidle.c                     |    2 +
 arch/arm/mach-highbank/highbank.c                  |    4 +
 arch/arm/mach-imx/Kconfig                          |   13 --
 arch/arm/mach-imx/clock-imx6q.c                    |    7 +-
 arch/arm/mach-imx/mach-imx6q.c                     |    1 +
 arch/arm/mach-imx/mm-imx3.c                        |  109 +++++++-------
 arch/arm/mach-imx/src.c                            |    7 +
 arch/arm/mach-mmp/gplugd.c                         |    2 +-
 arch/arm/mach-mmp/include/mach/gpio-pxa.h          |    2 +-
 arch/arm/mach-mx5/cpu.c                            |    5 +-
 arch/arm/mach-mx5/mm.c                             |    6 +-
 arch/arm/mach-mxs/clock-mx28.c                     |    2 +-
 arch/arm/mach-omap1/Kconfig                        |    8 -
 arch/arm/mach-omap1/board-ams-delta.c              |   10 +-
 arch/arm/mach-omap1/clock.h                        |    3 +-
 arch/arm/mach-omap1/clock_data.c                   |   53 ++++---
 arch/arm/mach-omap1/devices.c                      |    3 +
 arch/arm/mach-omap2/Kconfig                        |    1 +
 arch/arm/mach-omap2/Makefile                       |    5 +-
 arch/arm/mach-omap2/cpuidle34xx.c                  |    1 +
 arch/arm/mach-omap2/display.c                      |  159 ++++++++++++++++++++
 arch/arm/mach-omap2/display.h                      |   29 ++++
 arch/arm/mach-omap2/omap_hwmod.c                   |    6 +-
 arch/arm/mach-omap2/omap_hwmod_2420_data.c         |   17 ++-
 arch/arm/mach-omap2/omap_hwmod_2430_data.c         |   17 ++-
 .../mach-omap2/omap_hwmod_2xxx_3xxx_ipblock_data.c |    5 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |   37 ++++-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |   24 ++--
 arch/arm/mach-omap2/omap_hwmod_common_data.c       |    4 +
 arch/arm/mach-omap2/omap_hwmod_common_data.h       |    4 +
 arch/arm/mach-omap2/omap_l3_noc.c                  |    2 +-
 arch/arm/mach-omap2/pm.c                           |    6 +-
 arch/arm/mach-omap2/smartreflex.c                  |    2 +-
 arch/arm/mach-omap2/twl-common.c                   |   11 ++
 arch/arm/mach-omap2/twl-common.h                   |    3 +
 arch/arm/mach-pxa/balloon3.c                       |    2 +-
 arch/arm/mach-pxa/colibri-pxa320.c                 |    2 +-
 arch/arm/mach-pxa/gumstix.c                        |    2 +-
 arch/arm/mach-pxa/include/mach/palm27x.h           |    4 +-
 arch/arm/mach-pxa/palm27x.c                        |    4 +-
 arch/arm/mach-pxa/palmtc.c                         |    2 +-
 arch/arm/mach-pxa/vpac270.c                        |    2 +-
 arch/arm/mach-s3c64xx/mach-crag6410-module.c       |    2 +-
 arch/arm/plat-mxc/include/mach/common.h            |    2 +-
 arch/arm/plat-mxc/include/mach/mxc.h               |   14 --
 arch/arm/plat-mxc/include/mach/system.h            |    7 +-
 arch/arm/plat-mxc/system.c                         |    3 +-
 arch/arm/plat-omap/include/plat/clock.h            |    2 +-
 arch/arm/plat-omap/include/plat/common.h           |    3 +
 arch/arm/plat-s3c24xx/cpu-freq-debugfs.c           |    2 +-
 arch/arm/plat-s5p/sysmmu.c                         |    1 +
 arch/arm/plat-samsung/include/plat/gpio-cfg.h      |    2 +
 arch/arm/plat-samsung/pd.c                         |    2 +-
 arch/arm/plat-samsung/pwm.c                        |    2 +-
 arch/arm/tools/mach-types                          |    1 +
 include/video/omapdss.h                            |    7 -
 70 files changed, 517 insertions(+), 270 deletions(-)
 rename arch/arm/configs/{at91cap9adk_defconfig => at91cap9_defconfig} (93%)
 rename arch/arm/configs/{at91sam9260ek_defconfig => at91sam9260_defconfig} (86%)
 rename arch/arm/configs/{at91sam9g20ek_defconfig => at91sam9g20_defconfig} (90%)
 rename arch/arm/configs/{at91sam9rlek_defconfig => at91sam9rl_defconfig} (94%)
 create mode 100644 arch/arm/mach-omap2/display.h
 delete mode 100644 arch/arm/mach-omap2/io.h
