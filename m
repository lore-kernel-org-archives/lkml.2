Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab1GZXgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 19:36:37 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:49722 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab1GZXgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 19:36:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>
Subject: [GIT PULL] arm-soc new features (part 2/2) for 3.1
Date: Wed, 27 Jul 2011 01:36:18 +0200
Message-ID: <5039974.y3GReu3Vjy@wuerfel>
User-Agent: KMail/4.6.0 (Linux/3.0.0-rc1nosema+; KDE/4.6.90; x86_64; ; )
In-Reply-To: <1698068.Mn9Tmtfmzl@wuerfel>
References: <3057645.NjCAYUXHGt@wuerfel> <5818290.TCY0zMWmbr@wuerfel> <1698068.Mn9Tmtfmzl@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:rzQYMagp6X14ybKRwm545hDWvi7uEajvJbjCIAxsUfB
 9viuV3oiyYxHANeYpR6dS6BsUWmb1sSoI11cJI6ya+DM1qhKWc
 9xeWjT0kpSNEyPHwVyv4HxENYP0htJ4XqG+XDxwWPVFvSRozaW
 0pdQJwlLOY8huOsaIoqFklqvJeHoGzneSZGEgmSEm957SEgMnL
 fr4y40+3qRsSVFK3sdPZw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the final branch I have for now, although I hope to get one more
for actual device tree conversions for a lot of drivers.

This one contains more new development for the omap platform that could
reasonably be split from the other features. There is on the one hand
support for the twl6040 support chip used in some new boards, and then
a series of changes for the 'prcm' code in omap that I don't understand
but trust to be moving in the right direction.

	Arnd

The following changes since commit 6fd4ce886440c7a1b08b6642e606ee19097829df:

  Merge branch 'upstream' of git://git.linux-mips.org/pub/scm/upstream-linus (2011-07-26 14:17:28 -0700)

are available in the git repository at:

  git+ssh://master.kernel.org/pub/scm/linux/kernel/git/arm/linux-arm-soc.git/ next/devel2

Andy Green (6):
      I2C: OMAP2+: Set hwmod flags to only allow 16-bit accesses to i2c
      I2C: OMAP2+: increase omap_i2c_dev_attr flags from u8 to u32
      I2C: OMAP2+:  Introduce I2C IP versioning constants
      I2C: OMAP1/OMAP2+: create omap I2C functionality flags for each cpu_... test
      I2C: OMAP2+: Tag all OMAP2+ hwmod defintions with I2C IP revision
      I2C: OMAP2+: add correct functionality flags to all omap2plus i2c dev_attr

Arnd Bergmann (1):
      Merge branches 'omap/prcm' and 'omap/mfd' of git+ssh://master.kernel.org/.../arm/linux-arm-soc into next/devel-2

Avinash.H.M (1):
      OMAP: hwmod: fix the i2c-reset timeout during bootup

Axel Castaneda Gonzalez (1):
      ASoC: twl6040: Configure ramp step based on platform

Benoit Cousson (14):
      OMAP4: powerdomain data: Fix core mem states and missing cefuse flag
      OMAP: omap_device: Create clkdev entry for hwmod main_clk
      OMAP4: hwmod data: Add clock domain attribute
      OMAP2+: hwmod: Init clkdm field at boot time
      OMAP4: hwmod: Replace CLKCTRL absolute address with offset macros
      OMAP: hwmod: Wait the idle status to be disabled
      OMAP4: hwmod: Replace RSTCTRL absolute address with offset macros
      OMAP4: prm: Replace warm reset API with the offset based version
      OMAP4: prm: Remove deprecated functions
      OMAP4: hwmod data: Add PRM context register offset
      OMAP4: hwmod data: Add modulemode entry in omap_hwmod structure
      OMAP4: cm: Add two new APIs for modulemode control
      OMAP4: hwmod: Introduce the module control in hwmod control
      OMAP2+: clockdomain: Add 2 APIs to control clockdomain from hwmod framework

Jon Hunter (1):
      OMAP: Add debugfs node to show the summary of all clocks

Liam Girdwood (3):
      ASoC: twl6040: add all ABE DAIs
      ASoC: twl6040: Support other sample rates in constraints.
      ASoC: twl6040: set default constraints.

Misael Lopez Cruz (5):
      mfd: twl6040: Add initial support
      ASoC: twl6040: Convert into TWL6040 MFD child
      input: Add initial support for TWL6040 vibrator
      ASoC: twl6040: Remove pll and headset mode dependency
      OMAP4: SDP4430: Add twl6040 codec platform support

Paul Walmsley (4):
      Merge branches 'powerdomain_fixes_3.1', 'hardware_workarounds_3.1', 'hwmod_dss_fix_3.1' and 'i2c_fixes_3.1' into prcm-fixes-3.1
      OMAP2+: clockdomain: add clkdm_in_hwsup()
      OMAP2+: clock: allow per-SoC clock init code to prevent clockdomain calls from clock code
      Merge branches 'omap4_clockdomain_hwmod_3.1', 'clock_debugfs_a_3.1', 'omap4_clock_auxclk_3.1' and 'omap_device_a_3.1' into 
prcm-devel-3.1

Peter Ujfalusi (17):
      MFD: twl4030-codec: Rename internals from codec to audio
      MFD: twl4030-codec -> twl4030-audio: Rename the driver
      MFD: twl4030-audio: Rename platform data
      MFD: twl6040: Change platform data for soc codec driver
      OMAP4: SDP4430: Add twl6040 vibrator platform support
      MFD: twl6040: Use resource to provide irq number for slaves
      input: twl6040-vibra: Do not use wrapper for irq request
      ASoC: twl6040: Do not use wrapper for irq request
      MFD: twl6040: Demand valid interrupt configuration
      MFD: twl6040: Remove wrapper for threaded irq request
      ASoC: twl6040: Use neutral name for power mode text/enum
      ASoC: twl6040: Move PLL selection to codec driver
      ASoC: twl6040: Simplify sample rate constraint handling
      ASoC: twl6040: Configure PLL only once
      MFD: twl6040: Remove enum for PLL tracking
      ASoC: twl6040: No need to convert the PLL ID
      ASoC: twl6040: Add back support for legacy mode

Rajendra Nayak (5):
      OMAP2+: PM: Initialise sleep_switch to a non-valid value
      OMAP4: clock data: Add missing divider selection for auxclks
      OMAP2+: PM: idle clkdms only if already in idle
      OMAP2+: clockdomain: Add per clkdm lock to prevent concurrent state programming
      OMAP2+: hwmod: Follow the recommended PRCM module enable sequence

Santosh Shilimkar (2):
      OMAP4: clock data: Keep GPMC clocks always enabled and hardware managed
      OMAP4: powerdomain data: Remove unsupported MPU powerdomain state

Tomi Valkeinen (2):
      OMAP4: hwmod data: Modify DSS opt clocks
      OMAP4: hwmod data: Change DSS main_clk scheme

Tony Lindgren (1):
      Merge branch 'peter/topic/for-tony' of git://gitorious.org/omap-audio/linux-audio into twl-asoc

Vaibhav Bedia (1):
      OMAP: clockdomain: Remove redundant call to pwrdm_wait_transition()

 arch/arm/mach-omap2/board-4430sdp.c                |   56 ++
 arch/arm/mach-omap2/board-rx51-peripherals.c       |    6 +-
 arch/arm/mach-omap2/board-zoom-peripherals.c       |   10 +-
 arch/arm/mach-omap2/clock.c                        |   27 +-
 arch/arm/mach-omap2/clock.h                        |    3 +
 arch/arm/mach-omap2/clock2420_data.c               |   22 +-
 arch/arm/mach-omap2/clock2430_data.c               |   32 +-
 arch/arm/mach-omap2/clock3xxx_data.c               |   44 +-
 arch/arm/mach-omap2/clock44xx_data.c               |  224 +++++--
 arch/arm/mach-omap2/clockdomain.c                  |  210 +++++--
 arch/arm/mach-omap2/clockdomain.h                  |   11 +
 arch/arm/mach-omap2/clockdomain2xxx_3xxx.c         |    6 +-
 arch/arm/mach-omap2/clockdomain44xx.c              |   13 +-
 arch/arm/mach-omap2/clockdomains44xx_data.c        |    2 +-
 arch/arm/mach-omap2/cm44xx.h                       |    8 +-
 arch/arm/mach-omap2/cminst44xx.c                   |  150 ++++-
 arch/arm/mach-omap2/cminst44xx.h                   |   10 +-
 arch/arm/mach-omap2/i2c.c                          |   68 ++
 arch/arm/mach-omap2/omap_hwmod.c                   |  261 ++++++-
 arch/arm/mach-omap2/omap_hwmod_2420_data.c         |    9 +-
 arch/arm/mach-omap2/omap_hwmod_2430_data.c         |    7 +
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |   18 +-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |  491 +++++++++++---
 arch/arm/mach-omap2/pm.c                           |    6 +-
 arch/arm/mach-omap2/powerdomains44xx_data.c        |    9 +-
 arch/arm/mach-omap2/prcm.c                         |    2 +-
 arch/arm/mach-omap2/prm44xx.c                      |  145 +----
 arch/arm/mach-omap2/prm44xx.h                      |   10 -
 arch/arm/mach-omap2/prminst44xx.c                  |  112 +++-
 arch/arm/mach-omap2/prminst44xx.h                  |   12 +-
 arch/arm/mach-omap2/twl-common.c                   |   10 +-
 arch/arm/plat-omap/clock.c                         |   39 +
 arch/arm/plat-omap/include/plat/i2c.h              |    6 +-
 arch/arm/plat-omap/include/plat/irqs.h             |   12 +-
 arch/arm/plat-omap/include/plat/omap_hwmod.h       |   15 +-
 arch/arm/plat-omap/omap_device.c                   |   85 ++-
 drivers/input/misc/Kconfig                         |   13 +-
 drivers/input/misc/Makefile                        |    1 +
 drivers/input/misc/twl4030-vibra.c                 |   12 +-
 drivers/input/misc/twl6040-vibra.c                 |  423 +++++++++++
 drivers/mfd/Kconfig                                |    8 +-
 drivers/mfd/Makefile                               |    3 +-
 drivers/mfd/twl-core.c                             |   13 +-
 drivers/mfd/twl4030-audio.c                        |  277 ++++++++
 drivers/mfd/twl4030-codec.c                        |  277 --------
 drivers/mfd/twl6040-core.c                         |  620 +++++++++++++++++
 drivers/mfd/twl6040-irq.c                          |  191 +++++
 include/linux/i2c-omap.h                           |   27 +
 include/linux/i2c/twl.h                            |   25 +-
 .../linux/mfd/{twl4030-codec.h => twl4030-audio.h} |   16 +-
 include/linux/mfd/twl6040.h                        |  228 ++++++
 sound/soc/codecs/Kconfig                           |    3 +-
 sound/soc/codecs/twl4030.c                         |   22 +-
 sound/soc/codecs/twl6040.c                         |  733 +++++++++-----------
 sound/soc/codecs/twl6040.h                         |  119 +----
 sound/soc/omap/sdp3430.c                           |    2 +-
 sound/soc/omap/sdp4430.c                           |   52 +--
 sound/soc/omap/zoom2.c                             |    2 +-
 58 files changed, 3808 insertions(+), 1410 deletions(-)
 create mode 100644 drivers/input/misc/twl6040-vibra.c
 create mode 100644 drivers/mfd/twl4030-audio.c
 delete mode 100644 drivers/mfd/twl4030-codec.c
 create mode 100644 drivers/mfd/twl6040-core.c
 create mode 100644 drivers/mfd/twl6040-irq.c
 rename include/linux/mfd/{twl4030-codec.h => twl4030-audio.h} (96%)
 create mode 100644 include/linux/mfd/twl6040.h
