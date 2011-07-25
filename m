Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab1GYQ3Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 12:29:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:50407 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab1GYQ3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 12:29:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] arm-soc cleanups for 3.1
Date: Mon, 25 Jul 2011 18:28:55 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <rmk@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <201107251822.10265.arnd@arndb.de>
In-Reply-To: <201107251822.10265.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201107251828.55180.arnd@arndb.de>
X-Provags-ID: V02:K0:ZrpbmIxIs1aTZb1dVTJcs/Phm64TCOur/FaldghXx/v
 3eS8h0iO2g5/Otka/JjCQWHckxgyD/3TYWwEzZ4kTGLDZX2OvG
 mdT8pGjKTVoaBKGSrYY0Xzcvd0KOtxBlc2fFJjF4cxnv6tCfpF
 kB7X4vKY/cvRWaBH040IVJYAsCmiiAT2lKfgmpEh6LQ4nMSXC4
 ZdcZzdp7VamJJ4V2/8CdQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the second branch of the arm-soc tree for the 3.1 merge window.
It depends on the 'fixes' branch I just sent before this, and is a
prerequisite for some of the later branches.

These cleanups are directed at both reducing the amount of duplicated
code within platforms, as well as working towards device tree based probing
and other useful changes by changing the way that certain devices are
registered.

	Arnd

The following changes since commit 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe:

  Linux 3.0 (2011-07-21 19:17:23 -0700)

are available in the git repository at:
  git+ssh://master.kernel.org/pub/scm/linux/kernel/git/arm/linux-arm-soc.git next/cleanup

Ajay Kumar (3):
      ARM: S5PC100: Cleanup mach/regs-fb.h from mach-s5pc100
      ARM: S5PV210: Cleanup mach/regs-fb.h from mach-s5pv210
      ARM: S3C64XX: Cleanup mach/regs-fb.h from mach-s3c64xx

Arnd Bergmann (4):
      omap2+: fix build regression
      Merge branch 'cleanup-part-2' of git+ssh://master.kernel.org/.../tmlind/linux-omap-2.6 into omap/cleanup
      Merge branches 'davinci/cleanup', 'imx/cleanup', 'omap/cleanup' and 'pxa/cleanup' of git+ssh://master.kernel.org/.../arm/linux-arm-soc into next/cleanup
      Merge branch 'next-samsung-cleanup' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup

Axel Lin (1):
      ARM i.MX23/28: platform-mxsfb: Add missing include of linux/dma-mapping.h

Banajit Goswami (15):
      ARM: SAMSUNG: Create a common infrastructure for PWM backlight support
      ARM: EXYNOS4: Add PWM backlight support on SMDKV310
      ARM: EXYNOS4: Add PWM backlight support on SMDKC210
      ARM: S5PV210: Add PWM backlight support on SMDKV210
      ARM: S5PC100: Add PWM backlight support on SMDKC100
      ARM: S5P64X0: Add PWM backlight support on SMDK6440
      ARM: S5P64X0: Add PWM backlight support on SMDK6450
      ARM: S3C64XX: Add PWM backlight support on SMDK6410
      ARM: SAMSUNG: Use generic s3c_set_platdata for TS
      ARM: SAMSUNG: Use generic s3c_set_platdata for FB
      ARM: SAMSUNG: Use generic s3c_set_platdata for HWMON
      ARM: SAMSUNG: Use generic s3c_set_platdata for USB OHCI
      ARM: SAMSUNG: Use generic s3c_set_platdata for NAND
      ARM: S3C64XX: Use generic s3c_set_platdata for OneNAND
      ARM: S3C24XX: Use generic s3c_set_platdata for devices

Benoit Cousson (21):
      OMAP2+: hwmod: Fix smart-standby + wakeup support
      OMAP4: hwmod data: Add MSTANDBY_SMART_WKUP flag
      OMAP2+: hwmod: Do not write the enawakeup bit if SYSC_HAS_ENAWAKEUP is not set
      OMAP2+: hwmod: Remove _populate_mpu_rt_base warning
      OMAP2+: hwmod: Fix the HW reset management
      OMAP: hwmod: Add warnings if enable failed
      OMAP: hwmod: Move pr_debug to improve the readability
      OMAP4: hwmod data: Fix L3 interconnect data order and alignement
      OMAP4: hwmod data: Remove un-needed parens
      OMAP4: hwmod data: Fix bad alignement
      OMAP4: hwmod data: Align interconnect format with regular modules
      OMAP4: clock data: Add sddiv to USB DPLL
      OMAP4: clock data: Remove usb_host_fs clkdev with NULL dev
      OMAP4: clock data: Re-order some clock nodes and structure fields
      OMAP4: clock data: Fix max mult and div for USB DPLL
      OMAP4: prcm: Fix errors in few defines name
      OMAP4: prm: Remove wrong clockdomain offsets
      OMAP4: powerdomain data: Fix indentation
      OMAP4: cm: Remove RESTORE macros to avoid access from SW
      OMAP4: prcm_mpu: Fix indent in few macros
      OMAP4: clockdomain data: Fix data order and wrong name

Chanwoo Choi (1):
      clocksource: convert 32-bit down counting clocksource on S5PV210/S5P64X0

Dmitry Eremin-Solenikov (1):
      ARM: scoop: drop pcmcia_init callback

Eric Miao (1):
      ARM: pxa/saarb: make use of pxa3xx_map_io()

Fabio Estevam (16):
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
      ARM: mx5/mx51_babbage: Move GPIO initialization for USB PHY Reset line to common place
      ARM: mx5/mx51_babbage: Use gpio_request_array for USBH1 pins
      ARM: imx/mach-apf9328: Simplify UART0 registration
      ARM: mach-imx/scb9328: Make the UART gpio setup simpler
      ARM: mach-imx/mx27_3ds: Use the standard gpio_to_irq function
      ARM: mach-imx/mx27_3ds: Do not annotate the chip select as internal

Grazvydas Ignotas (1):
      omap: cleanup NAND platform data

H Hartley Sweeten (1):
      plat-mxc/pwm.c: use resource_size()

Igor Grinberg (4):
      ARM: pxa/cm-x300: fix V3020 RTC functionality
      ARM: pxa/cm-x300: GPIO cleanup
      ARM: pxa/cm-x300: minor style cleanup
      ARM: pxa/cm-x300: update cm_x300_defconfig

Jarkko Nikula (4):
      omap: mcbsp: Drop SPI mode support
      omap: mcbsp: Drop in-driver transfer support
      omap: mcbsp: Remove rx_/tx_word_length variables
      omap: mcbsp: Remove port number enums

Jean Pihet (1):
      OMAP PM: remove OMAP_PM_NONE config option

Jingoo Han (1):
      ARM: EXYNOS4: Change devname for FIMD clkdev

Jon Hunter (2):
      OMAP4: clock data: Remove McASP2, McASP3 and MMC6 clocks
      OMAP4: clock data: Remove UNIPRO clock nodes

Jonathan Cameron (1):
      pcmcia: pxa2xx/trizeps4: remove unnecessary ifdefs

Kevin Hilman (4):
      OMAP3: PM debug: remove sleep_while_idle feature
      OMAP2: PM debug: remove register dumping
      OMAP3: PM debug: remove register dumping
      OMAP: omap_device: replace _find_by_pdev() with to_omap_device()

Kukjin Kim (1):
      Merge branch 'next-samsung-clkdev-fix' into next-samsung-cleanup

Linus Walleij (1):
      mach-integrator: delete bits.h include file

Lothar Waßmann (1):
      mach-mx5: fix the I2C clock parents

Marc Kleine-Budde (1):
      ARM: mx53: Fix the base addresses for the DDR memory regions

Mark Brown (1):
      ARM: S3C64XX: Convert to using REGULATOR_SUPPLY() on SMDK6410

Miguel Vadillo (1):
      OMAP2+: hwmod: Enable module in shutdown to access sysconfig

Naveen Krishna Chatradhi (3):
      ARM: SAMSUNG: Use generic set_plat_data function
      ARM: SAMSUNG: Cleanup I2C code in plat-samsung
      ARM: SAMSUNG: Move duplicate code for SPDIF ops

Nishanth Menon (4):
      OMAP3+: SR: make notify independent of class
      OMAP3+: SR: disable interrupt by default
      OMAP3+: SR: enable/disable SR only on need
      OMAP3+: SR: fix cosmetic indentation

Oleg Drokin (2):
      cleanup regulator supply definitions in mach-omap2
      Remove old-style supply.dev assignments common in hsmmc init

Paul Walmsley (9):
      OMAP: dmtimer: add missing include
      omap_hwmod: use a null structure record to terminate omap_hwmod_addr_space arrays
      omap_hwmod: share identical omap_hwmod_addr_space arrays
      omap_hwmod: use a terminator record with omap_hwmod_mpu_irqs arrays
      omap_hwmod: share identical omap_hwmod_mpu_irqs arrays
      omap_hwmod: use a terminator record with omap_hwmod_dma_info arrays
      omap_hwmod: share identical omap_hwmod_dma_info arrays
      omap_hwmod: share identical omap_hwmod_class, omap_hwmod_class_sysconfig arrays
      Merge branches 'dmtimer_precleanup_3.1', 'hwmod_core_cleanup_a_3.1', 'combine_common_hwmod_3.1', 'omap4_hwmod_data_cleanup_a_3.1', 'clock_cleanup_a_3.1', 'prcm_cleanup_a_3.1', 'omap_pm_cleanup_3.1' and 'omap_device_cleanup_3.1' into prcm-cleanup-3.1

Peter Ujfalusi (5):
      omap: board-omap3evm: Fix compilation error
      OMAP: New twl-common for common TWL configuration
      OMAP4: Move common twl6030 configuration to twl-common
      OMAP3: Move common twl configuration to twl-common
      OMAP3: Move common regulator configuration to twl-common

Philipp Zabel (4):
      ARM: pxa/magician: fix MAGICIAN_EGPIO_BASE, align with NR_BUILTIN_GPIO
      ARM: pxa/magician: use gpio arrays for backlight and global gpios
      ARM: pxa/hx4700: use gpio arrays for global gpios
      ARM: pxa/mioa701: use gpio arrays for global and gsm gpios

Russell King - ARM Linux (1):
      Convert OMAPs 32kHz clocksource implementation to use the generic MMIO     clocksource support.  This achieves several things:

Sanjeev Premi (1):
      OMAP2+: PM: fix section mismatch in pm_dbg_init()

Sascha Hauer (10):
      ARM i.MX dma: Fix burstsize settings
      ARM i.MX: fix last user of iomux.h and remove it
      ARM i.MX: define CLOCK_TICK_RATE to bogus value
      ARM i.MX: remove SoC defines around header includes
      ARM i.MX: dmav1: kill SoC ifdefs
      ARM i.MX mxc.h: use CONFIG_SOC_* instead of CONFIG_ARCH_*
      ARM i.MX tzic: do not depend on MXC_INTERNAL_IRQS
      ARM i.MX avic: do not depend on MXC_INTERNAL_IRQS
      ARM i.MX: get rid of wrong MXC_INTERNAL_IRQ usage
      ARM i.MX debug macro: use CONFIG_SOC_* instead of CONFIG_ARCH_*

Sekhar Nori (2):
      davinci: psc.h: clean up indentation done using spaces
      davinci: dm6467/T EVM: fix setting up of reference clock rate

Shawn Guo (5):
      ARM: mxs_defconfig: Change CONFIG_RTC_CLASS 'm' to 'y'
      ARM: mxc: imx-sdma device gets 16K iosize than 4K
      ARM: mxc: sdma on imx25 is a V2 block
      ARM: mxc: change imx-dma default to_version to 1
      ARM: mxc: imx-dma on imx25 has no other TO version but TO1

Thomas Abraham (10):
      serial: samsung: Fix unintended usage of uart port 0 as console
      serial: Remove redundant console_initcall from s3c and s5p console drivers
      ARM: SAMSUNG: Add clkdev infrastructure
      ARM: S3C24XX: Add clkdev support
      ARM: S3C64XX: Add clkdev support
      ARM: S5P64X0: Add clkdev support
      ARM: S5PC100: Add clkdev support
      ARM: S5PV210: Add clkdev support
      ARM: EXYNOS4: Add clkdev support
      ARM: SAMSUNG: Added mach/clkdev.h

Tony Lindgren (14):
      omap: Use separate init_irq functions to avoid cpu_is_omap tests early
      omap: Set separate timer init functions to avoid cpu_is_omap tests
      omap: Move dmtimer defines to dmtimer.h
      omap: Make a subset of dmtimer functions into inline functions
      omap2+: Use dmtimer macros for clockevent
      omap2+: Remove gptimer_wakeup for now
      omap2+: Reserve clocksource and timesource and initialize dmtimer later
      omap2+: Use dmtimer macros for clocksource
      omap2+: Remove omap2_gp_clockevent_set_gptimer
      omap2+: Rename timer-gp.c into timer.c to combine timer init functions
      Merge branch 'devel-timer' into devel-cleanup
      Merge branch 'for_3.1/pm-misc' of git://git.kernel.org/.../khilman/linux-omap-pm into devel-cleanup
      Merge branch 'peter/topic/for-tony_mach-cleanup' of git://gitorious.org/omap-audio/linux-audio into cleanup-part-2
      Merge branch 'prcm-cleanup-3.1' of git://git.pwsan.com/linux-2.6 into cleanup-part-3

Troy Kisky (2):
      MXC: iomux-v3: correct NO_PAD_CTRL definition
      ARM: i.MX53: Fix IOMUX type o's

Uwe Kleine-König (4):
      ARM: mxs/tx28: according to the TX28's datasheet D4-D7 are not used for MMC0
      ARM: imx: convert to new leds-gpio registration helper
      ARM: mx5: convert to new leds-gpio registration helper
      ARM: mxs/tx28: convert to new leds-gpio registration helper

 arch/arm/Kconfig                                   |    9 +
 arch/arm/configs/cm_x300_defconfig                 |   18 +-
 arch/arm/configs/mx51_defconfig                    |    3 +-
 arch/arm/configs/mxs_defconfig                     |    2 +-
 arch/arm/include/asm/hardware/scoop.h              |    1 -
 arch/arm/mach-davinci/board-dm646x-evm.c           |   17 +-
 arch/arm/mach-davinci/clock.c                      |   38 +
 arch/arm/mach-davinci/clock.h                      |    2 +
 arch/arm/mach-davinci/dm646x.c                     |    4 +-
 arch/arm/mach-davinci/include/mach/dm646x.h        |    2 -
 arch/arm/mach-davinci/include/mach/psc.h           |  148 ++--
 arch/arm/mach-exynos4/Kconfig                      |    4 +
 arch/arm/mach-exynos4/clock.c                      |  177 ++---
 arch/arm/mach-exynos4/include/mach/clkdev.h        |    7 +
 arch/arm/mach-exynos4/mach-smdkc210.c              |   16 +
 arch/arm/mach-exynos4/mach-smdkv310.c              |   16 +
 arch/arm/mach-imx/Kconfig                          |    5 +
 arch/arm/mach-imx/dma-v1.c                         |   25 +-
 arch/arm/mach-imx/eukrea_mbimx27-baseboard.c       |   23 +-
 arch/arm/mach-imx/eukrea_mbimxsd25-baseboard.c     |   15 +-
 arch/arm/mach-imx/eukrea_mbimxsd35-baseboard.c     |   13 +-
 arch/arm/mach-imx/mach-apf9328.c                   |    7 +-
 arch/arm/mach-imx/mach-imx27_visstrim_m10.c        |    2 +-
 arch/arm/mach-imx/mach-mx27_3ds.c                  |   44 +-
 arch/arm/mach-imx/mach-mx31_3ds.c                  |   10 +-
 arch/arm/mach-imx/mach-mx31moboard.c               |   14 +-
 arch/arm/mach-imx/mach-mx35_3ds.c                  |    2 +-
 arch/arm/mach-imx/mach-scb9328.c                   |   17 +-
 arch/arm/mach-imx/mx31lite-db.c                    |   15 +-
 arch/arm/mach-integrator/include/mach/bits.h       |   61 --
 arch/arm/mach-mx5/Kconfig                          |    4 +
 arch/arm/mach-mx5/board-cpuimx51.c                 |   12 +-
 arch/arm/mach-mx5/board-mx51_3ds.c                 |    3 +-
 arch/arm/mach-mx5/board-mx51_babbage.c             |   34 +-
 arch/arm/mach-mx5/board-mx51_efikamx.c             |   15 +-
 arch/arm/mach-mx5/board-mx51_efikasb.c             |   16 +-
 arch/arm/mach-mx5/clock-mx51-mx53.c                |    4 +-
 arch/arm/mach-mx5/eukrea_mbimx51-baseboard.c       |   24 +-
 arch/arm/mach-mx5/eukrea_mbimxsd-baseboard.c       |   19 +-
 arch/arm/mach-mxs/Kconfig                          |    1 +
 arch/arm/mach-mxs/devices/platform-mxsfb.c         |    1 +
 arch/arm/mach-mxs/mach-tx28.c                      |   13 +-
 arch/arm/mach-omap1/board-ams-delta.c              |    4 +-
 arch/arm/mach-omap1/board-fsample.c                |    4 +-
 arch/arm/mach-omap1/board-generic.c                |    4 +-
 arch/arm/mach-omap1/board-h2.c                     |    4 +-
 arch/arm/mach-omap1/board-h3.c                     |    4 +-
 arch/arm/mach-omap1/board-htcherald.c              |    4 +-
 arch/arm/mach-omap1/board-innovator.c              |    4 +-
 arch/arm/mach-omap1/board-nokia770.c               |    4 +-
 arch/arm/mach-omap1/board-osk.c                    |    4 +-
 arch/arm/mach-omap1/board-palmte.c                 |    4 +-
 arch/arm/mach-omap1/board-palmtt.c                 |    4 +-
 arch/arm/mach-omap1/board-palmz71.c                |    4 +-
 arch/arm/mach-omap1/board-perseus2.c               |    4 +-
 arch/arm/mach-omap1/board-sx1.c                    |    4 +-
 arch/arm/mach-omap1/board-voiceblue.c              |    4 +-
 arch/arm/mach-omap1/irq.c                          |    2 +-
 arch/arm/mach-omap1/mcbsp.c                        |    4 +-
 arch/arm/mach-omap1/time.c                         |    6 +-
 arch/arm/mach-omap1/timer32k.c                     |    4 -
 arch/arm/mach-omap2/Makefile                       |   20 +-
 arch/arm/mach-omap2/board-2430sdp.c                |    4 +-
 arch/arm/mach-omap2/board-3430sdp.c                |   93 +--
 arch/arm/mach-omap2/board-3630sdp.c                |    4 +-
 arch/arm/mach-omap2/board-4430sdp.c                |  156 +---
 arch/arm/mach-omap2/board-am3517crane.c            |    4 +-
 arch/arm/mach-omap2/board-am3517evm.c              |    4 +-
 arch/arm/mach-omap2/board-apollon.c                |    4 +-
 arch/arm/mach-omap2/board-cm-t35.c                 |   81 +--
 arch/arm/mach-omap2/board-cm-t3517.c               |    5 +-
 arch/arm/mach-omap2/board-devkit8000.c             |   64 +--
 arch/arm/mach-omap2/board-flash.c                  |    4 -
 arch/arm/mach-omap2/board-generic.c                |    4 +-
 arch/arm/mach-omap2/board-h4.c                     |    4 +-
 arch/arm/mach-omap2/board-igep0020.c               |   79 +--
 arch/arm/mach-omap2/board-ldp.c                    |   29 +-
 arch/arm/mach-omap2/board-n8x0.c                   |   12 +-
 arch/arm/mach-omap2/board-omap3beagle.c            |   89 +--
 arch/arm/mach-omap2/board-omap3evm.c               |  111 +--
 arch/arm/mach-omap2/board-omap3logic.c             |   19 +-
 arch/arm/mach-omap2/board-omap3pandora.c           |  119 +--
 arch/arm/mach-omap2/board-omap3stalker.c           |   99 +--
 arch/arm/mach-omap2/board-omap3touchbook.c         |   97 +--
 arch/arm/mach-omap2/board-omap4panda.c             |  161 +---
 arch/arm/mach-omap2/board-overo.c                  |   83 +--
 arch/arm/mach-omap2/board-rm680.c                  |   12 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c       |   67 +-
 arch/arm/mach-omap2/board-rx51.c                   |    4 +-
 arch/arm/mach-omap2/board-ti8168evm.c              |    9 +-
 arch/arm/mach-omap2/board-zoom-peripherals.c       |  128 +---
 arch/arm/mach-omap2/board-zoom.c                   |    8 +-
 arch/arm/mach-omap2/clock44xx.h                    |    7 -
 arch/arm/mach-omap2/clock44xx_data.c               |  237 ++----
 arch/arm/mach-omap2/clockdomains44xx_data.c        |  124 ++--
 arch/arm/mach-omap2/cm-regbits-44xx.h              |  623 ++++++--------
 arch/arm/mach-omap2/cm1_44xx.h                     |   64 +--
 arch/arm/mach-omap2/cm2_44xx.h                     |   73 +--
 arch/arm/mach-omap2/common-board-devices.c         |   27 +-
 arch/arm/mach-omap2/common-board-devices.h         |   26 +-
 arch/arm/mach-omap2/gpmc-nand.c                    |   10 +-
 arch/arm/mach-omap2/io.c                           |   17 +-
 arch/arm/mach-omap2/irq.c                          |   32 +-
 arch/arm/mach-omap2/omap4-common.c                 |   10 +-
 arch/arm/mach-omap2/omap_hwmod.c                   |  223 ++++--
 arch/arm/mach-omap2/omap_hwmod_2420_data.c         |  832 +++----------------
 arch/arm/mach-omap2/omap_hwmod_2430_data.c         |  910 +++-----------------
 .../omap_hwmod_2xxx_3xxx_interconnect_data.c       |  173 ++++
 .../mach-omap2/omap_hwmod_2xxx_3xxx_ipblock_data.c |  322 +++++++
 .../mach-omap2/omap_hwmod_2xxx_interconnect_data.c |  130 +++
 arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c |  150 ++++
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |  654 +++-----------
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |  472 +++++-----
 arch/arm/mach-omap2/omap_hwmod_common_data.c       |   20 -
 arch/arm/mach-omap2/omap_hwmod_common_data.h       |   93 ++-
 arch/arm/mach-omap2/pm-debug.c                     |  372 +--------
 arch/arm/mach-omap2/pm.h                           |   16 -
 arch/arm/mach-omap2/pm24xx.c                       |    6 +-
 arch/arm/mach-omap2/pm34xx.c                       |    6 -
 arch/arm/mach-omap2/powerdomains44xx_data.c        |   18 +-
 arch/arm/mach-omap2/prcm_mpu44xx.h                 |   69 +-
 arch/arm/mach-omap2/prm44xx.h                      |   34 +-
 arch/arm/mach-omap2/smartreflex.c                  |   38 +-
 arch/arm/mach-omap2/timer-gp.c                     |  266 ------
 arch/arm/mach-omap2/timer-gp.h                     |   16 -
 arch/arm/mach-omap2/timer.c                        |  342 ++++++++
 arch/arm/mach-omap2/twl-common.c                   |  304 +++++++
 arch/arm/mach-omap2/twl-common.h                   |   59 ++
 arch/arm/mach-pxa/cm-x300.c                        |   58 +-
 arch/arm/mach-pxa/hx4700.c                         |   70 +--
 arch/arm/mach-pxa/include/mach/magician.h          |    3 +-
 arch/arm/mach-pxa/magician.c                       |   57 +-
 arch/arm/mach-pxa/mioa701.c                        |   70 +--
 arch/arm/mach-pxa/saarb.c                          |    2 +-
 arch/arm/mach-s3c2412/clock.c                      |   36 +-
 arch/arm/mach-s3c2416/clock.c                      |   10 +-
 arch/arm/mach-s3c2440/clock.c                      |    3 -
 arch/arm/mach-s3c2443/clock.c                      |   16 +-
 arch/arm/mach-s3c64xx/Kconfig                      |    1 +
 arch/arm/mach-s3c64xx/clock.c                      |   86 +--
 arch/arm/mach-s3c64xx/dev-onenand1.c               |   10 +-
 arch/arm/mach-s3c64xx/include/mach/clkdev.h        |    7 +
 arch/arm/mach-s3c64xx/include/mach/regs-fb.h       |   21 -
 arch/arm/mach-s3c64xx/mach-anw6410.c               |    2 +-
 arch/arm/mach-s3c64xx/mach-hmt.c                   |    2 +-
 arch/arm/mach-s3c64xx/mach-mini6410.c              |    2 +-
 arch/arm/mach-s3c64xx/mach-ncp.c                   |    2 +-
 arch/arm/mach-s3c64xx/mach-real6410.c              |    2 +-
 arch/arm/mach-s3c64xx/mach-smartq5.c               |    2 +-
 arch/arm/mach-s3c64xx/mach-smartq7.c               |    2 +-
 arch/arm/mach-s3c64xx/mach-smdk6410.c              |   43 +-
 arch/arm/mach-s3c64xx/setup-fb-24bpp.c             |    1 -
 arch/arm/mach-s5p64x0/Kconfig                      |    2 +
 arch/arm/mach-s5p64x0/clock-s5p6440.c              |   74 +--
 arch/arm/mach-s5p64x0/clock-s5p6450.c              |   68 +--
 arch/arm/mach-s5p64x0/include/mach/clkdev.h        |    7 +
 arch/arm/mach-s5p64x0/mach-smdk6440.c              |   54 +-
 arch/arm/mach-s5p64x0/mach-smdk6450.c              |   54 +-
 arch/arm/mach-s5pc100/Kconfig                      |    1 +
 arch/arm/mach-s5pc100/clock.c                      |  200 +----
 arch/arm/mach-s5pc100/include/mach/clkdev.h        |    7 +
 arch/arm/mach-s5pc100/include/mach/regs-fb.h       |  105 ---
 arch/arm/mach-s5pc100/mach-smdkc100.c              |   57 +-
 arch/arm/mach-s5pc100/setup-fb-24bpp.c             |    1 -
 arch/arm/mach-s5pv210/Kconfig                      |    1 +
 arch/arm/mach-s5pv210/clock.c                      |  167 +---
 arch/arm/mach-s5pv210/include/mach/clkdev.h        |    7 +
 arch/arm/mach-s5pv210/include/mach/regs-fb.h       |   21 -
 arch/arm/mach-s5pv210/mach-aquila.c                |    2 +-
 arch/arm/mach-s5pv210/mach-goni.c                  |    2 +-
 arch/arm/mach-s5pv210/mach-smdkv210.c              |   56 +-
 arch/arm/mach-s5pv210/setup-fb-24bpp.c             |    1 -
 arch/arm/plat-mxc/avic.c                           |   12 +-
 arch/arm/plat-mxc/devices/platform-imx-dma.c       |   14 +-
 arch/arm/plat-mxc/devices/platform-imx-ssi.c       |    2 +-
 arch/arm/plat-mxc/include/mach/debug-macro.S       |   10 +-
 arch/arm/plat-mxc/include/mach/hardware.h          |   28 +-
 arch/arm/plat-mxc/include/mach/iomux-mx53.h        |   14 +-
 arch/arm/plat-mxc/include/mach/iomux-v1.h          |    4 -
 arch/arm/plat-mxc/include/mach/iomux-v3.h          |    2 +-
 arch/arm/plat-mxc/include/mach/iomux.h             |   26 -
 arch/arm/plat-mxc/include/mach/mx53.h              |   26 +-
 arch/arm/plat-mxc/include/mach/mxc.h               |    8 +-
 arch/arm/plat-mxc/include/mach/timex.h             |   13 +-
 arch/arm/plat-mxc/iomux-v1.c                       |   34 +-
 arch/arm/plat-mxc/pwm.c                            |    8 +-
 arch/arm/plat-mxc/tzic.c                           |    4 +-
 arch/arm/plat-omap/Kconfig                         |    3 -
 arch/arm/plat-omap/counter_32k.c                   |  123 +--
 arch/arm/plat-omap/dmtimer.c                       |  209 +----
 arch/arm/plat-omap/include/plat/clock.h            |    2 +-
 arch/arm/plat-omap/include/plat/common.h           |    6 +-
 arch/arm/plat-omap/include/plat/dmtimer.h          |  251 ++++++-
 arch/arm/plat-omap/include/plat/irqs.h             |    6 +-
 arch/arm/plat-omap/include/plat/mcbsp.h            |   74 +--
 arch/arm/plat-omap/include/plat/nand.h             |    6 +-
 arch/arm/plat-omap/include/plat/omap-pm.h          |    8 -
 arch/arm/plat-omap/include/plat/omap_hwmod.h       |   20 +-
 arch/arm/plat-omap/mcbsp.c                         |  599 +-------------
 arch/arm/plat-omap/omap_device.c                   |   15 +-
 arch/arm/plat-s3c24xx/clock-dclk.c                 |    4 -
 arch/arm/plat-s3c24xx/devs.c                       |   38 +-
 arch/arm/plat-s3c24xx/include/mach/clkdev.h        |    7 +
 arch/arm/plat-s3c24xx/s3c2410-clock.c              |   21 +-
 arch/arm/plat-s3c24xx/s3c2443-clock.c              |   39 +-
 arch/arm/plat-s5p/clock.c                          |   35 +
 arch/arm/plat-s5p/include/plat/s5p-clock.h         |    5 +
 arch/arm/plat-s5p/s5p-time.c                       |   29 +-
 arch/arm/plat-samsung/Kconfig                      |    6 +
 arch/arm/plat-samsung/Makefile                     |    1 +
 arch/arm/plat-samsung/clock.c                      |   98 +--
 arch/arm/plat-samsung/dev-backlight.c              |  149 ++++
 arch/arm/plat-samsung/dev-fb.c                     |   14 +-
 arch/arm/plat-samsung/dev-hwmon.c                  |   14 +-
 arch/arm/plat-samsung/dev-i2c0.c                   |   14 +-
 arch/arm/plat-samsung/dev-i2c1.c                   |   24 +-
 arch/arm/plat-samsung/dev-i2c2.c                   |   24 +-
 arch/arm/plat-samsung/dev-i2c3.c                   |   24 +-
 arch/arm/plat-samsung/dev-i2c4.c                   |   24 +-
 arch/arm/plat-samsung/dev-i2c5.c                   |   24 +-
 arch/arm/plat-samsung/dev-i2c6.c                   |   24 +-
 arch/arm/plat-samsung/dev-i2c7.c                   |   24 +-
 arch/arm/plat-samsung/dev-nand.c                   |    9 +-
 arch/arm/plat-samsung/dev-ts.c                     |   14 +-
 arch/arm/plat-samsung/dev-usb.c                    |    9 +-
 arch/arm/plat-samsung/include/plat/backlight.h     |   26 +
 arch/arm/plat-samsung/include/plat/clock.h         |    3 +
 arch/arm/plat-samsung/include/plat/iic.h           |    2 +
 arch/arm/plat-samsung/pwm-clock.c                  |   10 +
 arch/arm/plat-samsung/time.c                       |    2 +
 drivers/dma/imx-dma.c                              |    3 +-
 drivers/mmc/host/mxcmmc.c                          |    8 +-
 drivers/pcmcia/pxa2xx_sharpsl.c                    |    3 -
 drivers/pcmcia/pxa2xx_trizeps4.c                   |    4 -
 drivers/tty/serial/s3c2410.c                       |    2 -
 drivers/tty/serial/s3c2412.c                       |    2 -
 drivers/tty/serial/s3c2440.c                       |    2 -
 drivers/tty/serial/s3c6400.c                       |    2 -
 drivers/tty/serial/s5pv210.c                       |    7 -
 drivers/tty/serial/samsung.c                       |    9 +-
 drivers/tty/serial/samsung.h                       |   19 -
 sound/soc/imx/imx-pcm-dma-mx2.c                    |    4 +-
 242 files changed, 4758 insertions(+), 8237 deletions(-)
 create mode 100644 arch/arm/mach-exynos4/include/mach/clkdev.h
 delete mode 100644 arch/arm/mach-integrator/include/mach/bits.h
 create mode 100644 arch/arm/mach-omap2/omap_hwmod_2xxx_3xxx_interconnect_data.c
 create mode 100644 arch/arm/mach-omap2/omap_hwmod_2xxx_3xxx_ipblock_data.c
 create mode 100644 arch/arm/mach-omap2/omap_hwmod_2xxx_interconnect_data.c
 create mode 100644 arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c
 delete mode 100644 arch/arm/mach-omap2/timer-gp.c
 delete mode 100644 arch/arm/mach-omap2/timer-gp.h
 create mode 100644 arch/arm/mach-omap2/timer.c
 create mode 100644 arch/arm/mach-omap2/twl-common.c
 create mode 100644 arch/arm/mach-omap2/twl-common.h
 create mode 100644 arch/arm/mach-s3c64xx/include/mach/clkdev.h
 delete mode 100644 arch/arm/mach-s3c64xx/include/mach/regs-fb.h
 create mode 100644 arch/arm/mach-s5p64x0/include/mach/clkdev.h
 create mode 100644 arch/arm/mach-s5pc100/include/mach/clkdev.h
 delete mode 100644 arch/arm/mach-s5pc100/include/mach/regs-fb.h
 create mode 100644 arch/arm/mach-s5pv210/include/mach/clkdev.h
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/regs-fb.h
 delete mode 100644 arch/arm/plat-mxc/include/mach/iomux.h
 create mode 100644 arch/arm/plat-s3c24xx/include/mach/clkdev.h
 create mode 100644 arch/arm/plat-samsung/dev-backlight.c
 create mode 100644 arch/arm/plat-samsung/include/plat/backlight.h
