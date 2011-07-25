Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab1GYQXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 12:23:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53001 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab1GYQXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 12:23:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <rmk@arm.linux.org.uk>
Subject: [GIT PULL] arm-soc fixes for 3.1
Date: Mon, 25 Jul 2011 18:22:10 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
MIME-Version: 1.0
Message-Id: <201107251822.10265.arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:qSsKNq++4PvXOtxyFlGhDPpG9sKpjDVqGeZ+y9xCu7p
 o6RgTf5Gu60CRfOo0zmNySw2mGSEaJuSNAK6IYed1X3NauwBD/
 erkFvxa9m1gWGuTrCD70qNqUcc7o/isFbB+CPlFJK6bH5vcpjT
 um0GiGWhn6IPStZAifNiwOkA4iPHbtLPRzcVs/ehmhw1E6tHPp
 Vv2lU7IPl/X1mqw+N7gmQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the first out of about ten pull requests for the arm-soc tree
in this merge window, consisting of low-priority bug fixes that
have no other dependencies. 

These should all be uncontroversial, and are a prerequisite for
patches in the cleanup branch that a number of other branches
are depending on.

You can see the bigger picture in the for-next branch of the
same tree if you are interested in what else is coming for this
tree. Please tell me if you are unhappy about the split between
the branches and would rather see smaller or larger pull requests.

	Arnd

[resent with mailing lists on Cc]

The following changes since commit 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe:

  Linux 3.0 (2011-07-21 19:17:23 -0700)

are available in the git repository at:
  git+ssh://master.kernel.org/pub/scm/linux/kernel/git/arm/linux-arm-soc.git next/fixes

Arnd Bergmann (4):
      Merge branch 'fixes-for-arnd' of git://git.pengutronix.de/git/imx/linux-2.6 into imx/fixes
      Merge branches 'at91/fixes', 'imx/fixes' and 'pxa/fixes' of git+ssh://master.kernel.org/.../arm/linux-arm-soc into next/fixes
      Merge branch 'msm/fixes' into next/fixes
      Merge branch 'tegra/fixes' of git+ssh://master.kernel.org/.../arm/linux-arm-soc into next/fixes

Axel Lin (1):
      ARM i.MX23/28: platform-mxsfb: Add missing include of linux/dma-mapping.h

Barry Song (3):
      ARM: CNS3XXX: add UL suffix to VMALLOC_END to ensure it is properly typed
      ARM: LPC32XXX: add UL suffix to VMALLOC_END to ensure it is properly typed
      ARM: NUC93X: add UL suffix to VMALLOC_END to ensure it is properly typed

Dong Aisheng (1):
      ARM: mxs-dma: include <linux/dmaengine.h>

Fabio Estevam (11):
      mx51: Let USB Storage be built by default
      ARM: mx53: Fix alternate modes for MX53_PAD_PATA_DATA6
      ARM: mx53: Fix the chip select addresses
      ARM: mach-imx/mx27_3ds: Use the standard i.MX macro for GPIO numbering
      ARM: mach-imx/mx31_3ds: Fix IOMUX for SPI1 signals
      mxc: iomuxv1: Do not use gpio_request when setting the pin as GPIO
      ARM: mach-imx/mx27_3ds: Fix regulator support
      ARM: mxc: iomux-v1: Fix build warning
      ARM: mx51: Fix the address space length for SSI
      ARM: mx53: Fix some interrupts marked as reserved.
      ARM: mx25: Fix typo on CAN1_RX pad setting

Imre Kaloz (1):
      ARM: orion5x: fixup 5181 MPP mask check

Jeff Ohlstein (1):
      ARM: msm: platsmp: determine number of CPU cores at boot time

Lothar Waßmann (2):
      mach-mx5: fix the I2C clock parents
      iomux-mx53: add missing 'IOMUX_CONFIG_SION' for some I2C pad definitions

Marc Kleine-Budde (1):
      ARM: mx53: Fix the base addresses for the DDR memory regions

Sascha Hauer (1):
      ARM i.MX dma: Fix burstsize settings

Shawn Guo (5):
      ARM: mxs_defconfig: Change CONFIG_RTC_CLASS 'm' to 'y'
      ARM: mxc: imx-sdma device gets 16K iosize than 4K
      ARM: mxc: sdma on imx25 is a V2 block
      ARM: mxc: change imx-dma default to_version to 1
      ARM: mxc: imx-dma on imx25 has no other TO version but TO1

Stephen Warren (2):
      ARM: Tegra: Trimslice: Tri-state DAP3 pinmux
      ARM: Tegra: Seaboard: Fix I2C bus numbering for ADT7461

Troy Kisky (5):
      MXC: iomux-v3: correct NO_PAD_CTRL definition
      ARM: i.MX53: Fix IOMUX type o's
      ARM: i.MX53: UARTn_TXD pin should not change RXD input select
      ARM: i.MX53: UARTn_CTS pin should not change RTS input select
      ARM: i.MX53: consistently use MX53_UART_PAD_CTRL for uart txd/rxd/rts/cts

Uwe Kleine-König (1):
      ARM: mxs/tx28: according to the TX28's datasheet D4-D7 are not used for MMC0

 arch/arm/configs/mx51_defconfig              |    3 +-
 arch/arm/configs/mxs_defconfig               |    2 +-
 arch/arm/mach-cns3xxx/include/mach/vmalloc.h |    2 +-
 arch/arm/mach-imx/mach-mx27_3ds.c            |   29 +++++-
 arch/arm/mach-imx/mach-mx31_3ds.c            |   10 +-
 arch/arm/mach-lpc32xx/include/mach/vmalloc.h |    2 +-
 arch/arm/mach-mmp/pxa168.c                   |    2 +-
 arch/arm/mach-mmp/pxa910.c                   |    2 +-
 arch/arm/mach-msm/platsmp.c                  |   11 ++-
 arch/arm/mach-mx5/clock-mx51-mx53.c          |    4 +-
 arch/arm/mach-mxs/devices/platform-mxsfb.c   |    1 +
 arch/arm/mach-mxs/include/mach/dma.h         |    2 +
 arch/arm/mach-mxs/mach-tx28.c                |    8 --
 arch/arm/mach-nuc93x/include/mach/vmalloc.h  |    2 +-
 arch/arm/mach-orion5x/mpp.c                  |    2 +-
 arch/arm/mach-pxa/mfp-pxa2xx.c               |    4 +-
 arch/arm/mach-tegra/board-seaboard.c         |    2 +-
 arch/arm/mach-tegra/board-trimslice-pinmux.c |    2 +-
 arch/arm/plat-mxc/devices/platform-imx-dma.c |   14 ++--
 arch/arm/plat-mxc/devices/platform-imx-ssi.c |    2 +-
 arch/arm/plat-mxc/include/mach/iomux-mx25.h  |    2 +-
 arch/arm/plat-mxc/include/mach/iomux-mx53.h  |  128 +++++++++++++-------------
 arch/arm/plat-mxc/include/mach/iomux-v1.h    |    1 -
 arch/arm/plat-mxc/include/mach/iomux-v3.h    |    2 +-
 arch/arm/plat-mxc/include/mach/mx53.h        |   26 +++---
 arch/arm/plat-mxc/iomux-v1.c                 |   34 +-------
 drivers/dma/imx-dma.c                        |    3 +-
 drivers/mmc/host/mxcmmc.c                    |    8 +-
 sound/soc/imx/imx-pcm-dma-mx2.c              |    4 +-
 29 files changed, 152 insertions(+), 162 deletions(-)
