Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933410Ab2AIWRD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 17:17:03 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:63345 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932601Ab2AIWN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 17:13:58 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL 07/11] New feature development
Date: Mon,  9 Jan 2012 22:12:47 +0000
Message-Id: <1326147171-13752-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1326147171-13752-1-git-send-email-arnd@arndb.de>
References: <1326147171-13752-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:0g9HfbERJsVhDK9fggrma3VMNE4JrwZ81uW2g5jbOQq
 wnpnTIfJEGO/t5S4/kKLGFHvvFJCXki+GgKdZsA5cj23+AupIn
 7WUR7vikVdJAi9iJgLaJ2CYMOoKSFm6GCLCovd9fzLVYkU+mRp
 GHCEZMuGPhuvOrncvdiPbhJNweacVzNKYp14Fth37HtrVXzLjA
 +2NPNzlognI1x1Jwqv+VA30yc0W1waCcWLMa5lC5LBzKF+ZlOX
 WQt4Z2TQysrn8MwZnYPlHaQIi8BGOjX3+BX+/vilihIflQX/M9
 fhdYY4VN+sAH0u4Fe4tE8b7p/tk9GJxUjSva/Ee79j3Chohjpa
 z6vzLT9gDNfMQJOZpJqdO+ug9jWcTHbQh6KO/qvHrkfJnfhHkn
 jqMaK+qFhooqw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for new features, and contains stuff from most
platforms. A number of these patches could have fit into other
branches, too, but were small enough not to cause too much
confusion here.

The following changes since commit 75a4a1c6776880e6d44ea7613ac8473cdf5606a1:

  Merge branch 'next/boards' into for-next3 (2012-01-09 17:08:02 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git next/devel

Andrew Lunn (4):
      ARM: Orion: Consolidate the address map setup
      ARM: Orion: mbus_dram_info consolidation
      ARM: Orion: Get address map from plat-orion instead of via platform_data
      ARM: Orion: Remove address map info from all platform data structures

Arnaud Patard (1):
      ARM: Kirkwood: Add configuration for MPP12 as GPIO

Arnd Bergmann (2):
      Merge branch 'hwmod' of git://git.kernel.org/.../tmlind/linux-omap into omap/hwmod
      Merge branch 'omap/hwmod' into next/devel

Benoit Cousson (1):
      ARM: OMAP: USB: EHCI and OHCI hwmod structures for OMAP4

Jamie Iles (1):
      ARM: picoxcell: implement watchdog restart

Janusz Krzysztofik (3):
      ARM: OMAP1: Move dpll1 rates selection from config to runtime
      ARM: OMAP1: Update dpll1 default rate reprogramming method
      ARM: OMAP1: Always reprogram dpll1 rate at boot

Keshava Munegowda (1):
      ARM: OMAP: USB: EHCI and OHCI hwmod structures for OMAP3

Kyle Manna (1):
      ARM: OMAP: hwmod data: Add support for AM35xx UART4/ttyO3

Linus Walleij (6):
      ARM: ux500: update the MOP500 GPIO assignments
      ARM: ux500: update ASIC detection for U5500
      ARM: ux500: update register files
      ARM: ux500: remove support for early silicon revisions
      ARM: ux500: fix the smp_twd clock calculation
      mfd/db8500-prcmu: remove support for early silicon revisions

Martin Michlmayr (1):
      ARM: Kirkwood: Recognize A1 revision of 6282 chip

Murali Karicheri (1):
      ARM: davinci: add support for multiple power domains

Olof Johansson (9):
      Merge branch 'omap/omap1' into next/devel
      Merge branch 'ux500/devel' into next/devel
      Merge branch 'for-3.3' of git://sources.calxeda.com/kernel/linux into highbank/devel
      Merge branch 'highbank/devel' into next/devel
      Merge branch 'orion/devel' into next/devel
      Merge branch 'v3.3/features' of git://gitorious.org/linux-davinci/linux-davinci into davinci/features
      Merge branch 'davinci/features' into next/devel
      Merge branch 'picoxcell/devel' into next/devel
      Merge branch 'ux500/devel' into next/devel

Paul Walmsley (1):
      ARM: OMAP3: hwmod data: disable multiblock reads on MMC1/2 on OMAP34xx/35xx <= ES2.1

Rabin Vincent (2):
      ARM: ux500: support DB8520
      ARM: ux500: register DB5500 PMU dynamically

Rob Herring (1):
      ARM: highbank: add xgmac ethernet devices to dts

Shubhrajyoti D (1):
      ARM: OMAP3+: hwmod data: Add the default clockactivity for I2C

Stefan Nilsson XK (2):
      ARM: ux500: support SD cards on HREFv60 boards
      ARM: ux500: add device sdi1 for SDIO

Tony Lindgren (2):
      ARM: OMAP1: Set the omap1623 sram size to 16K
      Merge branch 'hwmod_data_devel_3.3' of git://git.pwsan.com/linux-2.6 into hwmod

 arch/arm/boot/dts/highbank.dts                 |   12 +
 arch/arm/configs/omap1_defconfig               |    1 -
 arch/arm/mach-davinci/clock.c                  |   13 +-
 arch/arm/mach-davinci/clock.h                  |   10 +-
 arch/arm/mach-davinci/dm644x.c                 |    4 +-
 arch/arm/mach-dove/addr-map.c                  |  121 +++-----
 arch/arm/mach-dove/common.c                    |   16 +-
 arch/arm/mach-dove/common.h                    |    1 -
 arch/arm/mach-dove/pcie.c                      |    4 +-
 arch/arm/mach-kirkwood/addr-map.c              |  137 +++-------
 arch/arm/mach-kirkwood/common.c                |   19 +-
 arch/arm/mach-kirkwood/common.h                |    1 -
 arch/arm/mach-kirkwood/include/mach/kirkwood.h |    1 +
 arch/arm/mach-kirkwood/mpp.c                   |    1 -
 arch/arm/mach-kirkwood/mpp.h                   |    1 +
 arch/arm/mach-kirkwood/pcie.c                  |    4 +-
 arch/arm/mach-mv78xx0/addr-map.c               |  102 ++------
 arch/arm/mach-mv78xx0/common.c                 |   22 +-
 arch/arm/mach-mv78xx0/common.h                 |    1 -
 arch/arm/mach-mv78xx0/mpp.c                    |    1 -
 arch/arm/mach-mv78xx0/pcie.c                   |    4 +-
 arch/arm/mach-omap1/Kconfig                    |   64 ----
 arch/arm/mach-omap1/clock.c                    |   14 +-
 arch/arm/mach-omap1/clock.h                    |    3 +
 arch/arm/mach-omap1/clock_data.c               |   19 +-
 arch/arm/mach-omap1/opp.h                      |    1 +
 arch/arm/mach-omap1/opp_data.c                 |   63 ++---
 arch/arm/mach-omap2/clock3xxx_data.c           |   11 +
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c     |  374 +++++++++++++++++++++++-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c     |  217 ++++++++++++++-
 arch/arm/mach-omap2/prcm-common.h              |    2 +
 arch/arm/mach-orion5x/addr-map.c               |  146 +++-------
 arch/arm/mach-orion5x/common.c                 |   23 +-
 arch/arm/mach-orion5x/common.h                 |    3 +-
 arch/arm/mach-orion5x/include/mach/orion5x.h   |    2 +-
 arch/arm/mach-orion5x/mpp.c                    |    1 -
 arch/arm/mach-orion5x/pci.c                    |    5 +-
 arch/arm/mach-picoxcell/common.c               |   37 +++
 arch/arm/mach-ux500/board-mop500-sdi.c         |   88 ++++--
 arch/arm/mach-ux500/board-mop500.c             |    2 +-
 arch/arm/mach-ux500/board-mop500.h             |   63 ++++-
 arch/arm/mach-ux500/clock.c                    |  207 ++++----------
 arch/arm/mach-ux500/cpu-db5500.c               |   41 ++--
 arch/arm/mach-ux500/cpu-db8500.c               |   30 +--
 arch/arm/mach-ux500/devices-db8500.c           |   10 -
 arch/arm/mach-ux500/id.c                       |    6 +-
 arch/arm/mach-ux500/include/mach/db5500-regs.h |    4 +
 arch/arm/mach-ux500/include/mach/db8500-regs.h |   20 +-
 arch/arm/mach-ux500/include/mach/devices.h     |    2 -
 arch/arm/mach-ux500/include/mach/hardware.h    |   10 +-
 arch/arm/mach-ux500/include/mach/id.h          |   24 ++
 arch/arm/plat-omap/include/plat/clkdev_omap.h  |    1 +
 arch/arm/plat-omap/include/plat/irqs.h         |    2 +-
 arch/arm/plat-omap/include/plat/serial.h       |    1 +
 arch/arm/plat-omap/sram.c                      |    9 +-
 arch/arm/plat-orion/Makefile                   |    2 +-
 arch/arm/plat-orion/addr-map.c                 |  174 +++++++++++
 arch/arm/plat-orion/common.c                   |   43 +---
 arch/arm/plat-orion/include/plat/addr-map.h    |   53 ++++
 arch/arm/plat-orion/include/plat/audio.h       |    3 -
 arch/arm/plat-orion/include/plat/common.h      |   17 +-
 arch/arm/plat-orion/include/plat/ehci-orion.h  |    1 -
 arch/arm/plat-orion/include/plat/mv_xor.h      |    6 -
 arch/arm/plat-orion/include/plat/mvsdio.h      |    1 -
 arch/arm/plat-orion/include/plat/pcie.h        |    3 +-
 arch/arm/plat-orion/pcie.c                     |    6 +-
 drivers/ata/sata_mv.c                          |   19 +-
 drivers/dma/mv_xor.c                           |   11 +-
 drivers/mfd/db8500-prcmu.c                     |    7 +-
 drivers/mmc/host/mvsdio.c                      |   13 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c     |   10 +-
 drivers/usb/host/ehci-orion.c                  |   10 +-
 include/linux/ata_platform.h                   |    3 -
 include/linux/mbus.h                           |   13 +-
 sound/soc/kirkwood/kirkwood-dma.c              |   15 +-
 75 files changed, 1430 insertions(+), 961 deletions(-)
