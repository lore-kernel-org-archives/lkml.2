Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759266Ab2J0QBo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 12:01:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60742 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759157Ab2J0QBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 12:01:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] arm-soc fixes for 3.7-rc3
Date: Sat, 27 Oct 2012 16:01:27 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        arm@kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Tony Lindgren <tony@atomide.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210271601.28121.arnd@arndb.de>
X-Provags-ID: V02:K0:ghKdmP44kia0EbGqDZ8MkdTTDf0dxSHnEqDiJWnXS7j
 s+bjUyZnMuzblodn0LaH9tW5Ap3gvrynQZteiOLiS0IgrzLEPx
 b2aqjF8dqpFArbbajxggIQBXLnJvj++Ylh1hEi15czcsZgDU7q
 +5j6xPjBhpbmLP1SAsVpm3PoMNOxbGmcdsbSPTGj5hqqBANtds
 j7nBbpX/dOU3rnwrEq4LXJgtdIVFwaOp80li1ZLHCYlusMk3wW
 tLRuWTJaxw6IUgzRn63sXNXRaOuf2qWHEyRbs03VQSGkEPjKuL
 EWwIqUKsh+heBeIYlg5Hk1cnnGDBGxN+ah4YIp4JQ75X+J+Fzg
 qwgvuIrQhUZoeNqVnbPs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6f0c0580b70c89094b3422ba81118c7b959c7556:

  Linux 3.7-rc2 (2012-10-20 12:11:32 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-3.7

for you to fetch changes up to 943bb48755a7f70ee36e029904ed8b679bb1da58:

  Revert "ARM i.MX25: Fix PWM per clock lookups" (2012-10-27 17:46:56 +0200)

----------------------------------------------------------------
arm-soc: fixes for v3.7-rc3

Bug fixes for a number of ARM platforms, mostly OMAP, imx and at91.
These come a little later than I had hoped but unfortunately we
had a few of these patches cause regressions themselves and had to
work out how to deal with those in the meantime.

----------------------------------------------------------------
Arnd Bergmann (9):
      Merge tag 'at91-fixes' of git://github.com/at91linux/linux-at91 into fixes
      Merge branch 'for-rcs-3.7' of git://git.linaro.org/people/ljones/linux-3.0-ux500 into fixes
      Merge tag 'imx-fixes' of git://git.pengutronix.de/git/imx/linux-2.6 into fixes
      Merge tag 'omap-for-v3.7-rc2/fixes-signed' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge branch 'v3.7-samsung-fixes-2' of git://git.kernel.org/.../kgene/linux-samsung into fixes
      Merge branch 'fixes' of git://git.kernel.org/.../horms/renesas into fixes
      ARM: at91: fix at91x40 build
      ARM: versatile: fix versatile_defconfig
      Revert "ARM i.MX25: Fix PWM per clock lookups"

Bo Shen (2):
      ARM: at91/i2c: change id to let i2c-gpio work
      ARM: at91/i2c: change id to let i2c-at91 work

Fabio Estevam (3):
      ARM: imx_v6_v7_defconfig: Enable CONFIG_GPIO_MC9S08DZ60
      ARM: imx: clk-imx27: Fix divider width field
      ARM: mxc: platform-mxc-mmc: Fix register region size

Heiko Stuebner (1):
      ARM: SAMSUNG: Add naming of s3c64xx-spi devices

Huang Shijie (1):
      ARM: dts: mxs: add the "clock-names" for gpmi-nand

Ivan Shugov (1):
      ARM: at91: at91sam9g10: fix SOC type detection

Jean-Christophe PLAGNIOL-VILLARD (1):
      ARM: at91: drop duplicated config SOC_AT91SAM9 entry

Josh Wu (1):
      ARM: at91/tc: fix typo in the DT document

Kevin Hilman (2):
      ARM: OMAP2: UART: fix console UART mismatched runtime PM status
      ARM: OMAP3: Beagle: fix OPP customization and initcall ordering

Kuninori Morimoto (1):
      ARM: shmobile: r8a7779: I/O address abuse cleanup

Lee Jones (3):
      ARM: ux500: Fix build error relating to IRQCHIP_SKIP_SET_WAKE
      ARM: ux500: Specify AMBA Primecell IDs for Nomadik I2C in DT
      ARM: ux500: Correct SDI5 address and add some format changes

Marek Belisko (1):
      ARM: at91/dts: at91sam9g20ek_common: Fix typos in buttons labels.

Nicolas Ferre (2):
      ARM: at91: fix external interrupts in non-DT case
      ARM: at91: fix external interrupt specification in board code

Paul Walmsley (1):
      ARM: OMAP3: PM: apply part of the erratum i582 workaround

Pavel Machek (1):
      ARM: socfpga: Fix socfpga compilation with early_printk() enabled

Peter Ujfalusi (1):
      ARM/dts: omap3: Fix mcbsp2/3 hwmods to be able to probe the drivers for audio

Sascha Hauer (3):
      ARM i.MX25: Fix lcdc_ipg_per parent clock
      ARM i.MX25 clk: Fix nfc_ipg_per parent
      ARM i.MX25: Fix PWM per clock lookups

Stephen Boyd (1):
      MAINTAINERS: Add arm-soc tree entry

Thomas Petazzoni (1):
      ARM: mvebu: update defconfig with 3.7 changes

Tomasz Figa (2):
      ARM: dts: Split memory into 4 sections for exynos4210-trats
      ARM: EXYNOS: Set .smp field of machine descriptor for exynos4-dt

Tony Lindgren (3):
      ARM: OMAP2+: Fix location of select PINCTRL
      ARM: OMAP3: Fix 3430 legacy mux names for ssi1 signals.
      Merge tag 'for_3.7-rc3-fixes-pm' of git://git.kernel.org/.../khilman/linux-omap-pm into omap-for-v3.7-rc2/fixes

Vaibhav Hiremath (1):
      ARM: AM33XX: Fix configuration of dmtimer parent clock by dmtimer driverDate:Wed, 17 Oct 2012 13:55:55 -0500

Viresh Kumar (1):
      ARM: SPEAr: Remove unused empty files

Wei Yongjun (2):
      ARM: imx: fix return value check in imx3_init_l2x0()
      ARM: imx: fix the return value check in imx_clk_busy_divider()

 .../devicetree/bindings/arm/atmel-at91.txt         |    2 +-
 MAINTAINERS                                        |    7 +++++
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi        |    4 +--
 arch/arm/boot/dts/dbx5x0.dtsi                      |   17 ++++++++++-
 arch/arm/boot/dts/exynos4210-trats.dts             |    6 ++--
 arch/arm/boot/dts/imx23.dtsi                       |    1 +
 arch/arm/boot/dts/imx28.dtsi                       |    1 +
 arch/arm/boot/dts/omap3.dtsi                       |    4 +--
 arch/arm/configs/imx_v6_v7_defconfig               |    2 ++
 arch/arm/configs/mvebu_defconfig                   |   10 +++++--
 arch/arm/configs/versatile_defconfig               |    1 +
 arch/arm/include/debug/8250_32.S                   |   27 ++++++++++++++++++
 arch/arm/include/debug/picoxcell.S                 |   18 +-----------
 arch/arm/include/debug/socfpga.S                   |    5 ++++
 arch/arm/mach-at91/Kconfig                         |   10 ++-----
 arch/arm/mach-at91/at91rm9200.c                    |    2 +-
 arch/arm/mach-at91/at91rm9200_devices.c            |    4 +--
 arch/arm/mach-at91/at91sam9260.c                   |    4 +--
 arch/arm/mach-at91/at91sam9260_devices.c           |    4 +--
 arch/arm/mach-at91/at91sam9261.c                   |    4 +--
 arch/arm/mach-at91/at91sam9261_devices.c           |    4 +--
 arch/arm/mach-at91/at91sam9263.c                   |    2 +-
 arch/arm/mach-at91/at91sam9263_devices.c           |    4 +--
 arch/arm/mach-at91/at91sam9rl_devices.c            |    4 +--
 arch/arm/mach-at91/at91x40.c                       |    2 +-
 arch/arm/mach-at91/board-neocore926.c              |    2 +-
 arch/arm/mach-at91/board-sam9261ek.c               |    2 +-
 arch/arm/mach-at91/board-sam9263ek.c               |    2 +-
 arch/arm/mach-at91/generic.h                       |    3 +-
 arch/arm/mach-at91/irq.c                           |    9 ++++--
 arch/arm/mach-at91/setup.c                         |    4 +--
 arch/arm/mach-exynos/common.c                      |    5 ++++
 arch/arm/mach-exynos/mach-exynos4-dt.c             |    1 +
 arch/arm/mach-imx/clk-busy.c                       |    2 +-
 arch/arm/mach-imx/clk-imx25.c                      |    4 +--
 arch/arm/mach-imx/clk-imx27.c                      |    4 +--
 arch/arm/mach-imx/mm-imx3.c                        |    5 ++--
 arch/arm/mach-omap2/Kconfig                        |    1 -
 arch/arm/mach-omap2/board-omap3beagle.c            |   22 ++++++++------
 arch/arm/mach-omap2/clock33xx_data.c               |    2 ++
 arch/arm/mach-omap2/mux34xx.c                      |    8 +++---
 arch/arm/mach-omap2/pm.h                           |    1 +
 arch/arm/mach-omap2/pm34xx.c                       |   30 ++++++++++++++++++--
 arch/arm/mach-omap2/serial.c                       |    5 ++++
 arch/arm/mach-s3c24xx/s3c2416.c                    |    2 ++
 arch/arm/mach-s3c24xx/s3c2443.c                    |    4 +++
 arch/arm/mach-s5p64x0/common.c                     |    3 ++
 arch/arm/mach-s5pc100/common.c                     |    3 ++
 arch/arm/mach-s5pv210/common.c                     |    3 ++
 arch/arm/mach-shmobile/setup-r8a7779.c             |    2 +-
 arch/arm/mach-ux500/cpu.c                          |    1 +
 arch/arm/plat-mxc/devices/platform-mxc-mmc.c       |    2 +-
 arch/arm/plat-omap/Kconfig                         |    1 +
 arch/arm/plat-samsung/include/plat/spi-core.h      |   30 ++++++++++++++++++++
 54 files changed, 225 insertions(+), 87 deletions(-)
 create mode 100644 arch/arm/include/debug/8250_32.S
 delete mode 100644 arch/arm/mach-spear13xx/include/mach/spear1310_misc_regs.h
 delete mode 100644 arch/arm/mach-spear13xx/include/mach/spear1340_misc_regs.h
 create mode 100644 arch/arm/plat-samsung/include/plat/spi-core.h
