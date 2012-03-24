Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab2CXWEH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 18:04:07 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52357 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445Ab2CXWDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 18:03:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: =?UTF-8?q?=5BGIT=20PULL=2001/09=5D=20ARM=3A=20Non-critical=20bug=20fixes?=
Date: Sat, 24 Mar 2012 22:02:38 +0000
Message-Id: <1332626568-17812-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1332626568-17812-1-git-send-email-arnd@arndb.de>
References: <1332626568-17812-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:iyF7Z9oBxTvIEJKwosdzix1wX1bJnF9o93+vxKgIysL
 1gILbwFwaVXomnxowZBxnCde8ogqdDpsPI8hDJL8w1+3Qe3X04
 qtfWLyE0fmLkaiZJHRSlm/R1bpx0tr8w1PfziKPDpHzY3mKBCW
 qDNDrlVi7l0v+tyRiSOm0ymeE8ZvazPXj69E03Qd3TL3EMpWvz
 Kg/efDR7GVp71YNAHwcO/0qLjksPcGnWWjotHFxmqiSzkgZ5iT
 vo9B9W3ZBsxtky+TJl82oN+Ma209h8KMdCZsQBujcXJEQPVmPW
 vcIru3P9gT7oODblJRnlu87jZLq4nSYl6cKXQBwPf6+PmmWDI/
 uM45pMqK8vRcRXFg8W/Iy2HGfnMKL/RotlpKHZFG8ZDeuHRHr0
 2sXl8vLoU5yxw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple bug fixes that were not considered important enough for inclusion
into 3.3. One bug fix was originally intended for 3.3 but accidentally
got missed, but is not marked stable because it should only get
backported once later fixes also make it into v3.4.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

The following changes since commit "6a3c812 Merge branch
'next/fixes-non-critical' into for-next", leading up to commit " 489e7be
Merge branch 'fixes' into next/fixes-non-critical", are available in

git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-non-critical

Afzal Mohammed (1):
      ARM: OMAP2+: id: Add am33xx SoC type detection

Arnd Bergmann (13):
      Merge branch 'imx-fixes' of git://git.pengutronix.de/git/imx/linux-2.6 into next/fixes-non-critical
      Merge branch 'v3.4/fixes' of git://gitorious.org/linux-davinci/linux-davinci into next/fixes-non-critical
      Merge branch 'lpc32xx/fixes-non-critical' of git://git.antcom.de/linux-2.6 into next/fixes-non-critical
      ARM: ux500: U8500 depends on MMU
      ARM: ux500: add board autoselection
      ARM: ux500: select L2X0 cache on ux500
      ARM: ux500: select CPU_FREQ_TABLE where needed
      Merge branch 'fixes-non-critical' of git://git.kernel.org/.../tmlind/linux-omap into next/fixes-non-critical
      Merge branch 'ux500-fixes-20120301' of git://git.kernel.org/.../linusw/linux-stericsson into next/fixes-non-critical
      Merge tag 'imx25-iomux-ds' of git://git.pengutronix.de/git/imx/linux-2.6 into next/fixes-non-critical
      Merge branch 'fixes' of git://gitorious.org/linux-davinci/linux-davinci into next/fixes-non-critical
      Merge branch 'fixes' into next/fixes-non-critical
      Merge branch 'next/fixes-non-critical' into for-next

Bernhard Walle (1):
      ARM: OMAP2+: GPMC: Export gpmc_enable_hwecc and gpmc_calculate_ecc

Danny Kukawka (3):
      ARM: ux500: included linux/gpio.h twice
      ARM: OMAP: clock.c: included linux/debugfs.h twice
      ARM: OMAP2+: included some headers twice

Fabio Estevam (3):
      ARM: mach-pcm038: Fix field name of regulator_consumer_supply struct
      ARM: imx_v4_v5_defconfig: Fix the selection of 32 bit flash support for iMX21ADS board
      ARM: mach-imx: mx3: Fix section mismatch in imx3_init_l2x0()

Felipe Contreras (1):
      ARM: OMAP: mailbox: trivial whitespace fix

Grazvydas Ignotas (1):
      ARM: omap: pandora: fix usbhs platform data

Heiko Schocher (1):
      ARM: davinci: map default_queue to edma channels

Ilya Yanok (1):
      ARM: OMAP2+: ads7846_init: put gpio_pendown into pdata if it's provided

Jon Hunter (1):
      ARM: OMAP: Remove definition cpu_is_omap4430()

Kevin Hilman (4):
      ARM: OMAP: convert omap_device_build() and callers to __init
      ARM: OMAP2+: PM: fix section mismatch with omap2_init_processor_devices()
      ARM: OMAP2+: PM: fix wakeupgen warning when hotplug disabled
      ARM: OMAP2+: gpmc-smsc911x: only register regulator for first instance

Linus Walleij (2):
      ARM: ux500: delete TPS6105X selection
      ARM: ux500: solve some Kconfig mess

Masanari Iida (1):
      ARM: OMAP1: Fix typo in lcd_dma.c

Mehnert (1):
      iomux-mx25.h slew rate adjusted for LCD __LD pins

Ohad Ben-Cohen (2):
      ARM: OMAP: omap_device: Expose omap_device_{alloc, delete, register}
      ARM: OMAP: don't build hwspinlock in vain

Ola Lilja (3):
      ARM: ux500: Add placeholder for clk_set_parent
      ARM: ux500: Add DMA-channels for MSP
      ARM: ux500: Add audio-regulators

Olof Johansson (4):
      Merge branch 'fixes-non-critical' of git://git.kernel.org/.../tmlind/linux-omap into next/fixes-non-critical
      Merge branch 'fixes-non-critical-part2' of git://git.kernel.org/.../tmlind/linux-omap into next/fixes-non-critical
      Merge branch 'fixes-non-critical-part3' of git://git.kernel.org/.../tmlind/linux-omap into next/fixes-non-critical
      Merge branch 'fix-smsc911x-regulator' of git://git.kernel.org/.../tmlind/linux-omap into fixes

Paul Walmsley (1):
      ARM: OMAP2+: I2C: always compile I2C reset code, even if I2C driver is not built

Peter Ujfalusi (1):
      OMAP4: dma: Correct CPU version check for dma_common_ch_end

Philippe Langlais (2):
      ARM: ux500: set ARCH_NR_GPIO to 355 on U8500 platforms
      ARM: ux500: fix around AB8500 GPIO macro name

Roland Stigge (8):
      ARM: LPC32xx: Added lpc32xx_defconfig
      ARM: LPC32xx: clock.c: warning fix
      ARM: LPC32xx: clock.c: Fix mutex lock issues
      ARM: LPC32XX: Remove broken non-static declaration
      ARM: LPC32xx: clock.c: Missing header file
      ARM: LPC32xx: clock.c: jiffies wrapping
      ARM: LPC32xx: clock.c: Clock registration fixes
      ARM: LPC32xx: Fix missing and bad LPC32XX macros

Santosh Shilimkar (2):
      ARM: OMAP: fix section mismatch warning for omap4_hotplug_cpu()
      ARM: OMAP: Fix section mismatch warning for platform_cpu_die()

Tarun Kanti DebBarma (1):
      ARM: OMAP: dmtimer: fix missing content/correction in low-power mode support

Tony Lindgren (18):
      ARM: OMAP2+: Split omap2_hsmmc_init() to properly support I2C GPIO pins
      ARM: OMAP2+: Fix Kconfig dependencies for USB_ARCH_HAS_EHCI
      ARM: OMAP2+: Fix OMAP_HDQ_BASE build error
      ARM: OMAP2+: Fix board_mux section type conflict when OMAP_MUX is not set
      ARM: OMAP2+: Fix zoom LCD backlight if TWL_CORE is not selected
      ARM: OMAP2+: Fix devexit for smartreflex when CONFIG_HOTPLUG is not set
      ARM: OMAP: Fix devexit for dma when CONFIG_HOTPLUG is not set
      ARM: OMAP2+: Fix multiple randconfig errors with SOC_OMAP and SOC_OMAP_NOOP
      ARM: OMAP2+: Mark omap_hsmmc_init and omap_mux related functions as __init
      Merge branch 'randconfig' into fixes-non-critical
      Merge branch 'hsmmc' into fixes-non-critical
      Revert "ARM: OMAP2+: Fix multiple randconfig errors with SOC_OMAP and SOC_OMAP_NOOP"
      ARM: OMAP1: Fix section mismatch for omap1_init_early()
      ARM: OMAP2+: Fix omap24xx_io_desc warning if SoC subtypes are not selected
      ARM: OMAP2: Fix section warning for n8x0 when CONFIG_MMC_OMAP is not set
      ARM: OMAP2+: Fix build issues with missing include of linux/bug.h
      ARM: OMAP2+: Fix section warnings for hsmmc_init_one
      ARM: OMAP2+: Fix build for omap4 only builds with missing include of linux/bug.h

Uwe Kleine-König (2):
      ARM: davinci: cpufreq: fix compiler warning
      ARM: davinci: DA850: move da850_register_pm to .init.text

Vaibhav Bedia (1):
      ARM: OMAP: sram: Add am33xx SRAM support (minimal)

Wolfram Sang (1):
      arm: lpc32xx: phy3250: add rtc & touch device

Yuan Jiangli (1):
      ARM: OMAP3+: PM: VP: fix integer truncation error


 arch/arm/Kconfig                              |    3 +-
 arch/arm/configs/imx_v4_v5_defconfig          |    1 +
 arch/arm/configs/lpc32xx_defconfig            |  145 +++++++++++++++++++++++++
 arch/arm/mach-davinci/cpufreq.c               |    2 +-
 arch/arm/mach-davinci/da850.c                 |    2 +-
 arch/arm/mach-davinci/dma.c                   |    6 +-
 arch/arm/mach-davinci/include/mach/edma.h     |    5 +
 arch/arm/mach-imx/mach-pcm038.c               |    2 +-
 arch/arm/mach-imx/mm-imx3.c                   |    2 +-
 arch/arm/mach-lpc32xx/clock.c                 |   62 ++++-------
 arch/arm/mach-lpc32xx/common.h                |    1 -
 arch/arm/mach-lpc32xx/include/mach/platform.h |   51 +++++----
 arch/arm/mach-lpc32xx/phy3250.c               |    2 +
 arch/arm/mach-lpc32xx/pm.c                    |    2 +-
 arch/arm/mach-lpc32xx/timer.c                 |   48 ++++----
 arch/arm/mach-omap1/io.c                      |    2 +-
 arch/arm/mach-omap2/Kconfig                   |    4 +-
 arch/arm/mach-omap2/Makefile                  |    9 +-
 arch/arm/mach-omap2/board-2430sdp.c           |    2 +-
 arch/arm/mach-omap2/board-3430sdp.c           |    5 +-
 arch/arm/mach-omap2/board-4430sdp.c           |    4 +-
 arch/arm/mach-omap2/board-am3517evm.c         |    2 +-
 arch/arm/mach-omap2/board-cm-t35.c            |    5 +-
 arch/arm/mach-omap2/board-devkit8000.c        |    4 +-
 arch/arm/mach-omap2/board-flash.c             |    2 +-
 arch/arm/mach-omap2/board-igep0020.c          |    6 +-
 arch/arm/mach-omap2/board-ldp.c               |    3 +-
 arch/arm/mach-omap2/board-n8x0.c              |    8 +-
 arch/arm/mach-omap2/board-omap3beagle.c       |   10 ++-
 arch/arm/mach-omap2/board-omap3evm.c          |    7 +-
 arch/arm/mach-omap2/board-omap3logic.c        |    2 +-
 arch/arm/mach-omap2/board-omap3pandora.c      |   15 ++-
 arch/arm/mach-omap2/board-omap3stalker.c      |   15 ++-
 arch/arm/mach-omap2/board-omap3touchbook.c    |   17 ++--
 arch/arm/mach-omap2/board-omap4panda.c        |    6 +-
 arch/arm/mach-omap2/board-overo.c             |    3 +-
 arch/arm/mach-omap2/board-rm680.c             |    2 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c  |    2 +-
 arch/arm/mach-omap2/board-zoom-display.c      |    4 +
 arch/arm/mach-omap2/board-zoom-peripherals.c  |    4 +-
 arch/arm/mach-omap2/clkt_clksel.c             |    1 +
 arch/arm/mach-omap2/common-board-devices.c    |    8 +-
 arch/arm/mach-omap2/control.h                 |    5 +
 arch/arm/mach-omap2/devices.c                 |   15 ++--
 arch/arm/mach-omap2/display.c                 |    8 +-
 arch/arm/mach-omap2/dma.c                     |    2 +-
 arch/arm/mach-omap2/gpio.c                    |    2 +-
 arch/arm/mach-omap2/gpmc-smsc911x.c           |   11 ++-
 arch/arm/mach-omap2/gpmc.c                    |    2 +
 arch/arm/mach-omap2/hsmmc.c                   |  123 ++++++++++++++++-----
 arch/arm/mach-omap2/hsmmc.h                   |   12 ++-
 arch/arm/mach-omap2/id.c                      |    2 +
 arch/arm/mach-omap2/io.c                      |    3 +-
 arch/arm/mach-omap2/mcbsp.c                   |    2 +-
 arch/arm/mach-omap2/mux.c                     |   16 ++--
 arch/arm/mach-omap2/mux.h                     |    2 +-
 arch/arm/mach-omap2/omap-hotplug.c            |    2 +-
 arch/arm/mach-omap2/omap-mpuss-lowpower.c     |    2 +-
 arch/arm/mach-omap2/omap-wakeupgen.c          |   53 +++++-----
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c    |    1 -
 arch/arm/mach-omap2/pm.c                      |    4 +-
 arch/arm/mach-omap2/powerdomain-common.c      |    1 +
 arch/arm/mach-omap2/powerdomain2xxx_3xxx.c    |    1 +
 arch/arm/mach-omap2/powerdomain44xx.c         |    1 +
 arch/arm/mach-omap2/powerdomains3xxx_data.c   |    1 +
 arch/arm/mach-omap2/smartreflex.c             |    2 +-
 arch/arm/mach-omap2/sr_device.c               |    2 +-
 arch/arm/mach-omap2/vc.c                      |    1 +
 arch/arm/mach-omap2/vp.c                      |    4 +-
 arch/arm/mach-ux500/Kconfig                   |   44 +++++---
 arch/arm/mach-ux500/Makefile                  |    2 +-
 arch/arm/mach-ux500/board-mop500-regulators.c |   28 +++++
 arch/arm/mach-ux500/board-mop500-u8500uib.c   |    1 -
 arch/arm/mach-ux500/board-mop500.c            |    2 +-
 arch/arm/mach-ux500/board-mop500.h            |    2 +-
 arch/arm/mach-ux500/clock.c                   |    7 ++
 arch/arm/mach-ux500/clock.h                   |    1 +
 arch/arm/mach-ux500/devices-db8500.c          |    6 +
 arch/arm/mach-ux500/include/mach/hardware.h   |    2 +
 arch/arm/mach-ux500/include/mach/irqs.h       |    2 +-
 arch/arm/plat-mxc/include/mach/iomux-mx25.h   |   42 ++++----
 arch/arm/plat-omap/clock.c                    |    1 -
 arch/arm/plat-omap/dma.c                      |    2 +-
 arch/arm/plat-omap/dmtimer.c                  |   19 +++-
 arch/arm/plat-omap/include/plat/cpu.h         |    2 -
 arch/arm/plat-omap/include/plat/omap_device.h |    7 ++
 arch/arm/plat-omap/include/plat/sram.h        |    1 +
 arch/arm/plat-omap/mailbox.c                  |    2 +-
 arch/arm/plat-omap/omap_device.c              |   20 ++---
 arch/arm/plat-omap/sram.c                     |   14 ++-
 90 files changed, 650 insertions(+), 323 deletions(-)
