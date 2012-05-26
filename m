Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715Ab2EZHXT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 03:23:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37603 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab2EZHXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 03:23:06 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 3/8] arm-soc: cleanups, part 2
Date: Sat, 26 May 2012 00:22:33 -0700
Message-Id: <1338016958-7887-4-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.1.488.g05fbf7a
In-Reply-To: <1338016958-7887-1-git-send-email-olof@lixom.net>
References: <1338016958-7887-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More cleanups, continuing an earlier set with omap and samsung specific
cleanups. These could not go into the first set because they have
dependencies on various other series that in turn depend on the first
cleanups.

----------------------------------------------------------------

The following changes since commit 2f31a25ab6ccffb07990e36576fc47f4b6661ccf:

  Merge tag 'drivers' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/cleanup2

for you to fetch changes up to 424663566c43ce87e8b33228860bf882f1ea61bf:

  Merge branch 'next/cleanup-plat-s3c24xx-s5p' of git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung into next/cleanup2

----------------------------------------------------------------

Arnd Bergmann (2):
      Merge branch 'exynos/sysmmu' into next/cleanup2
      Merge branch 'next/cleanup-plat-s3c24xx-s5p' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup2

Heiko Stuebner (4):
      ARM: S3C24XX: move plat-s3c24xx/cpu.c
      ARM: S3C24XX: move plat-s3c24xx/dev-uart.c into common.c
      ARM: S3C24XX: move common power-management code to mach-s3c24xx
      ARM: S3C24XX: move common clock init into common.c

Kevin Hilman (4):
      ARM: OMAP: AM35xx: remove redunant cpu_is checks for AM3505
      ARM: OMAP: AM35xx: convert 3517 detection/flags to AM35xx
      ARM: OMAP2+: Kconfig: convert SOC_OMAPTI81XX to SOC_TI81XX
      ARM: OMAP2+: Kconfig: convert SOC_OMAPAM33XX to SOC_AM33XX

Kukjin Kim (9):
      ARM: SAMSUNG: move clock part for common s5p into plat-samsung
      ARM: SAMSUNG: move interrupt part for common s5p into plat-samsung
      ARM: SAMSUNG: move pm part for common s5p into plat-samsung
      ARM: SAMSUNG: move hr timer for common s5p into plat-samsung
      ARM: SAMSUNG: move platform device for s5p uart into plat-samsung
      ARM: SAMSUNG: move setup code for s5p mfc and mipiphy into plat-samsung
      ARM: SAMSUNG: move options for common s5p into plat-samsung/Kconfig
      ARM: SAMSUNG: merge plat-s5p into plat-samsung
      Merge branch 'next/cleanup-plat-s3c24xx' into next/cleanup-plat-s3c24xx-s5p

Olof Johansson (4):
      Merge tag 'omap-cleanup-for-v3.5' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup2
      Merge tag 'omap-cleanup-renames-for-v3.5' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup2
      Merge tag 'omap-cleanup-devices-for-v3.5' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup2
      Merge tag 'omap-cleanup-timer-for-v3.5' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup2

R Sricharan (1):
      ARM: OMAP2+: dma: Define dma capabilities register bitfields and use them.

Santosh Shilimkar (6):
      ARM: OMAP4: Don't compile cm2xxx_3xxx.c for OMAP4 only builds.
      ARM: OMAP2+: Clean up wrapping multiple objects in Makefile
      ARM: OMAP4: Remove un-used WakeupGen register defines.
      ARM: OMAP: dma: Make use of cpu_class_is_omap2() to avoid future patching.
      ARM: All OMAP2PLUS machines use omap2 directory so just add one entry
      ARM: OMAP4: Reduce the static IO mapping

Tarun Kanti DebBarma (1):
      ARM: OMAP2+: dmtimer: remove redundant sysconfig context restore

Tony Lindgren (10):
      Merge branch 'for_3.5/omap_misc_cleanup' of git://gitorious.org/omap-sw-develoment/linux-omap-dev into cleanup-soc
      Merge branch 'devel-hwmod' into cleanup
      Merge branch 'fixes-non-critical' into cleanup-devices
      ARM: OMAP1: Move omap_init_audio() to keep the devices in alphabetical order
      ARM: OMAP1: Move omap_init_uwire to mach-omap1
      ARM: OMAP2+: Move omap_dsp_reserve_sdram_memblock() to mach-omap2
      ARM: OMAP2: Use hwmod to initialize mmc for 2420
      ARM: OMAP: Move omap_mmc_add() to mach-omap1
      ARM: OMAP1: Pass dma request lines in platform data to MMC driver
      Merge branch 'cleanup-soc' into cleanup

Tushar Behera (1):
      ARM: S3C24XX: Use common macro to define resources on dev-uart.c

Vaibhav Hiremath (3):
      ARM: OMAP1: Add checks for possible error condition in timer_init
      ARM: OMAP2+: Replace space with underscore in the name field of system timers
      ARM: OMAP: Make OMAP clocksource source selection using kernel param

Yegor Yefremov (1):
      GPMC: add ECC control definitions


 arch/arm/Kconfig                                |   1 -
 arch/arm/Makefile                               |   6 +-
 arch/arm/mach-omap1/common.h                    |  11 +-
 arch/arm/mach-omap1/devices.c                   | 121 ++++++++++++--
 arch/arm/mach-omap1/time.c                      |  16 +-
 arch/arm/mach-omap1/timer32k.c                  |  28 +++-
 arch/arm/mach-omap2/Kconfig                     |   8 +-
 arch/arm/mach-omap2/Makefile                    | 167 +++++++++----------
 arch/arm/mach-omap2/common.h                    |   4 +-
 arch/arm/mach-omap2/devices.c                   |  19 ++-
 arch/arm/mach-omap2/dma.c                       |  11 +-
 arch/arm/mach-omap2/dsp.c                       |  27 ++-
 arch/arm/mach-omap2/gpmc.c                      |  30 +++-
 arch/arm/mach-omap2/hsmmc.c                     |   8 +-
 arch/arm/mach-omap2/id.c                        |   7 +-
 .../mach-omap2/include/mach/omap-wakeupgen.h    |   8 -
 arch/arm/mach-omap2/io.c                        |  38 +----
 arch/arm/mach-omap2/iomap.h                     |  28 ----
 arch/arm/mach-omap2/irq.c                       |   2 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c      |   2 +-
 arch/arm/mach-omap2/powerdomains3xxx_data.c     |   2 +-
 arch/arm/mach-omap2/timer.c                     | 118 ++++++++++---
 arch/arm/mach-omap2/usb-musb.c                  |   2 +-
 arch/arm/mach-omap2/voltagedomains3xxx_data.c   |   2 +-
 arch/arm/mach-s3c24xx/Makefile                  |   6 +
 .../cpu.c => mach-s3c24xx/common.c}             |  69 +++++++-
 .../arm/{plat-s3c24xx => mach-s3c24xx}/irq-pm.c |   0
 arch/arm/{plat-s3c24xx => mach-s3c24xx}/pm.c    |   0
 arch/arm/{plat-s3c24xx => mach-s3c24xx}/sleep.S |   0
 arch/arm/plat-omap/counter_32k.c                |  93 +++++------
 arch/arm/plat-omap/devices.c                    | 122 --------------
 arch/arm/plat-omap/dma.c                        |   4 +-
 arch/arm/plat-omap/dmtimer.c                    |   2 -
 arch/arm/plat-omap/include/plat/common.h        |   2 +-
 arch/arm/plat-omap/include/plat/cpu.h           |   8 +
 arch/arm/plat-omap/include/plat/dma.h           |   5 +
 arch/arm/plat-omap/include/plat/dmtimer.h       |   1 -
 arch/arm/plat-omap/include/plat/mmc.h           |   9 -
 arch/arm/plat-s3c24xx/Makefile                  |   6 -
 arch/arm/plat-s3c24xx/clock.c                   |  59 -------
 arch/arm/plat-s3c24xx/dev-uart.c                | 100 -----------
 arch/arm/plat-s5p/Kconfig                       | 132 ---------------
 arch/arm/plat-s5p/Makefile                      |  27 ---
 arch/arm/plat-samsung/Kconfig                   | 140 ++++++++++++++++
 arch/arm/plat-samsung/Makefile                  |  13 ++
 .../clock.c => plat-samsung/s5p-clock.c}        |   3 +-
 .../dev-mfc.c => plat-samsung/s5p-dev-mfc.c}    |   4 +-
 .../dev-uart.c => plat-samsung/s5p-dev-uart.c}  |  78 ++-------
 .../irq-eint.c => plat-samsung/s5p-irq-eint.c}  |   3 +-
 .../s5p-irq-gpioint.c}                          |   3 +-
 .../irq-pm.c => plat-samsung/s5p-irq-pm.c}      |   3 +-
 .../{plat-s5p/irq.c => plat-samsung/s5p-irq.c}  |   3 +-
 .../{plat-s5p/pm.c => plat-samsung/s5p-pm.c}    |   3 +-
 .../sleep.S => plat-samsung/s5p-sleep.S}        |   3 +-
 arch/arm/{plat-s5p => plat-samsung}/s5p-time.c  |   3 +-
 .../{plat-s5p => plat-samsung}/setup-mipiphy.c  |   0
 drivers/net/ethernet/ti/Kconfig                 |   2 +-
 57 files changed, 720 insertions(+), 852 deletions(-)
 rename arch/arm/{plat-s3c24xx/cpu.c => mach-s3c24xx/common.c} (76%)
 rename arch/arm/{plat-s3c24xx => mach-s3c24xx}/irq-pm.c (100%)
 rename arch/arm/{plat-s3c24xx => mach-s3c24xx}/pm.c (100%)
 rename arch/arm/{plat-s3c24xx => mach-s3c24xx}/sleep.S (100%)
 delete mode 100644 arch/arm/plat-s3c24xx/clock.c
 delete mode 100644 arch/arm/plat-s3c24xx/dev-uart.c
 delete mode 100644 arch/arm/plat-s5p/Kconfig
 delete mode 100644 arch/arm/plat-s5p/Makefile
 rename arch/arm/{plat-s5p/clock.c => plat-samsung/s5p-clock.c} (99%)
 rename arch/arm/{plat-s5p/dev-mfc.c => plat-samsung/s5p-dev-mfc.c} (97%)
 rename arch/arm/{plat-s5p/dev-uart.c => plat-samsung/s5p-dev-uart.c} (57%)
 rename arch/arm/{plat-s5p/irq-eint.c => plat-samsung/s5p-irq-eint.c} (99%)
 rename arch/arm/{plat-s5p/irq-gpioint.c => plat-samsung/s5p-irq-gpioint.c} (99%)
 rename arch/arm/{plat-s5p/irq-pm.c => plat-samsung/s5p-irq-pm.c} (98%)
 rename arch/arm/{plat-s5p/irq.c => plat-samsung/s5p-irq.c} (96%)
 rename arch/arm/{plat-s5p/pm.c => plat-samsung/s5p-pm.c} (95%)
 rename arch/arm/{plat-s5p/sleep.S => plat-samsung/s5p-sleep.S} (98%)
 rename arch/arm/{plat-s5p => plat-samsung}/s5p-time.c (99%)
 rename arch/arm/{plat-s5p => plat-samsung}/setup-mipiphy.c (100%)
