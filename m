Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514Ab1AGDld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 22:41:33 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:32805 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab1AGDlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 22:41:32 -0500
Date: Fri, 7 Jan 2011 12:39:32 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] rmobile updates for 2.6.38-rc1
Message-ID: <20110107033931.GK22477@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git rmobile-latest

Which contains:

Guennadi Liakhovetski (7):
      mmc: sh_mmcif: switch to completion, fix flags
      ARM: mach-shmobile: add DMA defines for MMCIF on sh7372
      mmc: sh_mmcif: cosmetic clean up
      mmc: sh_mmcif: add DMA support
      ARM: mach-shmobile: enable MMCIF DMA on ap4evb
      mmc: sh_mmcif: make DMA support by the driver unconditional
      dma: shdma: don't register the global die notifier multiple times

Kuninori Morimoto (17):
      ARM: mach-shmobile: ag5evm: remove unused define
      ARM: mach-shmobile: clock-sh73a0: modify MSTP order
      ARM: mach-shmobile: ag5evm: Add FSI resources
      ARM: mach-shmobile: Add mackerel board support
      ARM: mach-shmobile: mackerel: Add SMSC support
      ARM: mach-shmobile: mackerel: Add LCDC support
      ARM: mach-shmobile: mackerel: document switch and pin modes.
      ARM: mach-shmobile: mackerel: Add mackerel defconfig
      ARM: mach-shmobile: mackerel: Add lost GPIO_FN_LCDD 18 - 23
      ARM: mach-shmobile: mackerel: Add USB1(Host) support
      ARM: mach-shmobile: mackerel: Add LEDs support
      ARM: mach-shmobile: mackerel: Add FSI-AK4643 support
      ARM: mach-shmobile: mackerel: fixup default memory size
      ARM: mach-shmobile: ap4/mackerel: modify wrong comment out of USB
      ARM: mach-shmobile: ap4evb: fixup clk_put timing of fsib_clk
      ARM: mach-shmobile: mackerel: add HDMI video support
      ARM: mach-shmobile: mackerel: Add HDMI sound support

Magnus Damm (17):
      ARM: mach-shmobile: Initial AG5 and AG5EVM support
      ARM: mach-shmobile: AG5 clock framework improvements
      ARM: mach-shmobile: Fix up pinmux entries in Makefile
      ARM: mach-shmobile: SMP base support
      ARM: mach-shmobile: Enable SMP support
      ARM: mach-shmobile: sh73a0 SMP support
      ARM: mach-shmobile: Clean up headsmp.S
      ARM: mach-shmobile: Bump up NR_IRQS to 1024
      ARM: mach-shmobile: sh73a0 INTCS support
      ARM: mach-shmobile: sh73a0 TMU support
      ARM: mach-shmobile: sh73a0 CPGA fix for KEYSC
      ARM: mach-shmobile: Mackerel VGA camera support
      ARM: mach-shmobile: Use shared GIC entry macros
      ARM: mach-shmobile: Enable CONFIG_MULTI_IRQ_HANDLER
      ARM: mach-shmobile: Run-time IRQ handler for INTCA
      ARM: mach-shmobile: Run-time IRQ handler for GIC
      ARM: mach-shmobile: Rely on run-time IRQ handlers

Paul Mundt (7):
      ARM: mach-shmobile: Tidy up the Kconfig bits.
      ARM: mach-shmobile: Split out entry-macros in to GIC and INTC variants.
      ARM: mach-shmobile: Add ag5evm defconfig.
      mailmap: Fix up Takashi YOSHII's attribution.
      ARM: mach-shmobile: Fix up clkdev fallout for SH73A0.
      ARM: mach-shmobile: update for GIC changes.
      ARM: mach-shmobile: update for SMP changes.

Simon Horman (5):
      mmc, sh: Move constants to sh_mmcif.h
      sh, mmc: Make mmcif_update_progress static inline
      mmc, sh: Correct value for reset
      sh, mmc: Use defines when setting CE_CLK_CTRL
      ARM: mach-shmobile: mackerel: Add zboot support

Takashi YOSHII (9):
      ARM: mach-shmobile: Add sh73a0 pinmux support
      ARM: mach-shmobile: ag5evm: use gpio.
      ARM: mach-shmobile: ag5evm: scan keyboard support
      ARM: mach-shmobile: sh73a0 i2c_shmobile support.
      ARM: mach-shmobile: ag5evm i2c_shmobile support.
      ARM: mach-shmobile: sh73a0 GPIO pullup improvement
      ARM: mach-shmobile: Use pullups for AG5EVM KEYSC pins
      ARM: mach-shmobile: Add eMMC support through MMCIF on AG5EVM
      ARM: mach-shmobile: sh73a0: fix div4 table

Tony SIM (2):
      ARM: mach-shmobile: mackerel: Add Accelerometer sensor support
      ARM: mach-shmobile: mackerel: Add keypad tca6408a support

Yusuke Goda (3):
      ARM: mach-shmobile: mackerel: Add sdhi support
      ARM: mach-shmobile: mackerel: Add mmcif support
      ARM: mach-shmobile: mackerel: Add GPS support

 .mailmap                                           |    1 +
 arch/arm/Kconfig                                   |   12 +-
 arch/arm/configs/ag5evm_defconfig                  |   83 +
 arch/arm/configs/mackerel_defconfig                |  138 +
 arch/arm/mach-shmobile/Kconfig                     |   35 +-
 arch/arm/mach-shmobile/Makefile                    |   28 +-
 arch/arm/mach-shmobile/board-ag5evm.c              |  315 +++
 arch/arm/mach-shmobile/board-ap4evb.c              |   24 +-
 arch/arm/mach-shmobile/board-g3evm.c               |    1 +
 arch/arm/mach-shmobile/board-g4evm.c               |    1 +
 arch/arm/mach-shmobile/board-mackerel.c            | 1200 +++++++++
 arch/arm/mach-shmobile/clock-sh73a0.c              |  356 +++
 arch/arm/mach-shmobile/entry-gic.S                 |   18 +
 arch/arm/mach-shmobile/entry-intc.S                |   57 +
 arch/arm/mach-shmobile/headsmp.S                   |   27 +
 arch/arm/mach-shmobile/hotplug.c                   |   41 +
 arch/arm/mach-shmobile/include/mach/common.h       |   16 +
 arch/arm/mach-shmobile/include/mach/entry-macro.S  |   41 +-
 arch/arm/mach-shmobile/include/mach/hardware.h     |    3 -
 .../mach-shmobile/include/mach/head-mackerel.txt   |   87 +
 arch/arm/mach-shmobile/include/mach/irqs.h         |    5 +-
 arch/arm/mach-shmobile/include/mach/sh7372.h       |    2 +
 arch/arm/mach-shmobile/include/mach/sh73a0.h       |  467 ++++
 arch/arm/mach-shmobile/include/mach/smp.h          |   16 +
 arch/arm/mach-shmobile/include/mach/zboot.h        |    3 +
 arch/arm/mach-shmobile/intc-sh73a0.c               |  267 ++
 arch/arm/mach-shmobile/localtimer.c                |   25 +
 arch/arm/mach-shmobile/pfc-sh73a0.c                | 2746 ++++++++++++++++++++
 arch/arm/mach-shmobile/platsmp.c                   |   70 +
 arch/arm/mach-shmobile/setup-sh7372.c              |   10 +
 arch/arm/mach-shmobile/setup-sh73a0.c              |  412 +++
 arch/arm/mach-shmobile/smp-sh73a0.c                |   97 +
 arch/arm/mm/Kconfig                                |    2 +-
 arch/sh/include/mach-common/mach/romimage.h        |    2 +-
 arch/sh/include/mach-ecovec24/mach/romimage.h      |    2 +-
 arch/sh/include/mach-kfr2r09/mach/romimage.h       |    2 +-
 drivers/dma/shdma.c                                |   16 +-
 drivers/mmc/host/sh_mmcif.c                        |  429 +++-
 drivers/serial/sh-sci.h                            |    7 +
 include/linux/mmc/sh_mmcif.h                       |   60 +-
 40 files changed, 6904 insertions(+), 220 deletions(-)
 create mode 100644 arch/arm/configs/ag5evm_defconfig
 create mode 100644 arch/arm/configs/mackerel_defconfig
 create mode 100644 arch/arm/mach-shmobile/board-ag5evm.c
 create mode 100644 arch/arm/mach-shmobile/board-mackerel.c
 create mode 100644 arch/arm/mach-shmobile/clock-sh73a0.c
 create mode 100644 arch/arm/mach-shmobile/entry-gic.S
 create mode 100644 arch/arm/mach-shmobile/entry-intc.S
 create mode 100644 arch/arm/mach-shmobile/headsmp.S
 create mode 100644 arch/arm/mach-shmobile/hotplug.c
 create mode 100644 arch/arm/mach-shmobile/include/mach/head-mackerel.txt
 create mode 100644 arch/arm/mach-shmobile/include/mach/sh73a0.h
 create mode 100644 arch/arm/mach-shmobile/include/mach/smp.h
 create mode 100644 arch/arm/mach-shmobile/intc-sh73a0.c
 create mode 100644 arch/arm/mach-shmobile/localtimer.c
 create mode 100644 arch/arm/mach-shmobile/pfc-sh73a0.c
 create mode 100644 arch/arm/mach-shmobile/platsmp.c
 create mode 100644 arch/arm/mach-shmobile/setup-sh73a0.c
 create mode 100644 arch/arm/mach-shmobile/smp-sh73a0.c
