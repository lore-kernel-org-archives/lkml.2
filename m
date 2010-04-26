Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab0DZTAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 15:00:10 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:49585 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab0DZTAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 15:00:08 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.160.239.110
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+GHFWIUF4hVzFX5UWJL8nA
Date: Mon, 26 Apr 2010 12:00:06 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: [GIT PULL] omap fixes for v2.6.34-rc5
Message-ID: <20100426190005.GJ7225@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull omap fixes from:

git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

Regards,

Tony


The following changes since commit b91ce4d14a21fc04d165be30319541e0f9204f15:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/net-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

Aaro Koskinen (2):
      omap: fix clocksource_32k to start from zero
      omap: delete unused bootloader tag variables

Abraham Arce (1):
      OMAP4: Clocks: Change SPI Instance Names

Enric Balletbo i Serra (1):
      omap3: Fix EHCI port for IGEP v2 board

Felipe Balbi (1):
      arm: omap1: remove dead code from timer32k.c

Francisco Alecrim (1):
      n8x0_defconfig: remove CONFIG_NILFS2_FS override

Janusz Krzysztofik (1):
      omap: gpio: fix incorrect matching of IRQ_TYPE_EDGE_BOTH

Jarkko Nikula (2):
      omap: rx51_defconfig: Remove duplicate phonet
      omap: rx51_defconfig: Remove CONFIG_SYSFS_DEPRECATED*=y options

Rajendra Nayak (1):
      OMAP4: prcm: Use logical OR instead of bitwise OR

Ranjith Lohithakshan (1):
      OMAP3: clock: fix enable bit used for dpll4_m4x2 clock

Richard Woodruff (1):
      omap4: Fix build break when used with gcc-4.4.1 (2009-q3)

Santosh Shilimkar (2):
      OMAP4: Fix for CONTROL register Base
      omap4: Fix McBSP4 base address

Sergio Aguirre (7):
      OMAP3: serial: Check for zero-based physical addr
      OMAP3: serial: Use dev_* macros instead of printk
      omap2/3/4: serial: Remove condition for getting uart4_phys
      omap3: zoom2/3 / 3630sdp: Don't init always all uarts
      omap3: 3630sdp: Explicitly enable all UARTs
      omap3: zoom 2/3: Change debugboard serial port id
      omap3: zoom2/3: Register only 1 8250 port

Thara Gopinath (2):
      OMAP: HWMOD: Adding clockdomain check
      OMAP: HWMOD: Bug fixes in hwmod structure definitions

Thomas Weber (8):
      omap: Devkit8000: Fix wrong usb port on Devkit8000
      omap: board-sdp-flash.c: Fix typos in debug output
      omap: Devkit8000: Fix typo in supplies
      omap: Devkit8000: Add missing package selection
      omap: Devkit8000: Fix typo in pin name
      omap: Devkit8000: Remove unnecessary include file
      omap: Devkit8000: Change position of init calls
      omap: Devkit8000: Remove unused pins

Tony Lindgren (4):
      Merge branch 'omap-fixes-for-tony' of git://dev.omapzoom.org/pub/scm/saaguirre/linux-omap-camera into omap-fixes-for-linus
      Merge branch 'for_2.6.34rc_a' of git://git.pwsan.com/linux-2.6 into omap-fixes-for-linus
      omap2: Fix ARM processor check for 24xx
      omap: Fix n8x0 mmc_mmc_init compile warnings and typos

kishore kadiyala (1):
      OMAP4-HSMMC: FIX for MMC5 Controller IRQ Base

manjugk manjugk (1):
      omap: DMA: Init CDAC to zero

stanley.miao (4):
      omap: fix the compile error if CONFIG_MTD_NAND_OMAP2 is notenabled
      omap: remove one of the define of INT_34XX_BENCH_MPU_EMUL
      AM3517: initialize i2c subsystem after mux subsystem
      omap: fix a gpmc nand problem

 arch/arm/configs/n8x0_defconfig                |    1 -
 arch/arm/configs/omap_zoom2_defconfig          |    2 +-
 arch/arm/configs/omap_zoom3_defconfig          |    2 +-
 arch/arm/configs/rx51_defconfig                |    3 --
 arch/arm/mach-omap1/timer32k.c                 |   15 ---------
 arch/arm/mach-omap2/Kconfig                    |    6 ++-
 arch/arm/mach-omap2/board-3630sdp.c            |    1 +
 arch/arm/mach-omap2/board-am3517evm.c          |    4 +-
 arch/arm/mach-omap2/board-devkit8000.c         |   39 +++++------------------
 arch/arm/mach-omap2/board-igep0020.c           |    8 ++--
 arch/arm/mach-omap2/board-n8x0.c               |   18 +++++-----
 arch/arm/mach-omap2/board-sdp-flash.c          |    8 ++--
 arch/arm/mach-omap2/board-zoom-debugboard.c    |    2 +-
 arch/arm/mach-omap2/board-zoom-peripherals.c   |    1 -
 arch/arm/mach-omap2/clock3xxx_data.c           |    2 +-
 arch/arm/mach-omap2/clock44xx_data.c           |    8 ++--
 arch/arm/mach-omap2/clockdomain.c              |    6 ++--
 arch/arm/mach-omap2/devices.c                  |    2 +-
 arch/arm/mach-omap2/gpmc-nand.c                |    3 ++
 arch/arm/mach-omap2/include/mach/entry-macro.S |    2 +-
 arch/arm/mach-omap2/omap-headsmp.S             |    6 ++--
 arch/arm/mach-omap2/omap44xx-smc.S             |    2 +-
 arch/arm/mach-omap2/omap_hwmod.c               |    3 ++
 arch/arm/mach-omap2/powerdomain.c              |    2 +-
 arch/arm/mach-omap2/prcm.c                     |    4 +-
 arch/arm/mach-omap2/serial.c                   |   35 +++++++++++----------
 arch/arm/plat-omap/common.c                    |   22 ++++++++-----
 arch/arm/plat-omap/dma.c                       |    9 +++++
 arch/arm/plat-omap/gpio.c                      |    6 ++--
 arch/arm/plat-omap/include/plat/irqs.h         |    2 -
 arch/arm/plat-omap/include/plat/mcbsp.h        |    2 +-
 arch/arm/plat-omap/include/plat/nand.h         |    7 ++++
 arch/arm/plat-omap/include/plat/omap44xx.h     |    2 +-
 arch/arm/plat-omap/include/plat/omap_hwmod.h   |    2 +-
 34 files changed, 113 insertions(+), 124 deletions(-)
