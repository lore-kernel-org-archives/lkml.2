Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521Ab0JYSpA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 14:45:00 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:52416 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759435Ab0JYSoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 14:44:55 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.188.36.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18qC6CZSynEQCJG18B0G9g9
Date: Mon, 25 Oct 2010 11:44:51 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: [GIT PULL] omap updates for 2.6.37
Message-ID: <20101025184451.GB7206@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull omap updates from:

git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-for-linus

There are few minor merge conflicts, but I've left them unmerged as I believe
that's the way you want them nowadays. The merge conflicts are just overlapping
additions, and a OMAP2/OMAP2 vs OMAP24XX/OMAP34XX ifdef issue where the former is
the way to go. Looks like the crypto device platform data got accidentally added
in both the crypto and omap trees.

I've also pushed a omap-for-linus-merged branch in case you don't want to
do the merging of the conflicts.

Regards,

Tony


The following changes since commit 33081adf8b89d5a716d7e1c60171768d39795b39:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6 (2010-10-25 08:32:05 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-for-linus

Anand Gadiyar (3):
      omap: usb: fix build warning
      ASoC: OMAP4: MCPDM: Remove unnecessary include of plat/control.h
      omap: complete removal of machine_desc.io_pg_offst and .phys_io

Benoit Cousson (14):
      OMAP: hwmod: Rename dma_ch to dma_req
      OMAP: hwmod: Do not disable clocks if hwmod already in idle
      OMAP4: prcm: Add temporarily helper functions for rmw and read inside the PRM
      OMAP: hwmod: Force a softreset during _setup
      OMAP: hwmod: Fix softreset status check for some new OMAP4 IPs
      OMAP: hwmod: Fix softreset for modules with optional clocks
      OMAP4: hwmod: Add initial data for OMAP4430 ES1 & ES2
      OMAP4: pm: Change l3_main to l3_main_1 during bus device init
      OMAP4: clock: Fix clock names and align with hwmod names
      OMAP4: clock: Add optional clock nodes
      OMAP4: clocks: Fix ES2 clock issues
      OMAP4: hwmod data: Add watchdog timer
      OMAP4: UART: Add uart1-4 hwmods data for omap4
      omap4 hsmmc: Fix the init if CONFIG_MMC_OMAP_HS is not set

Benoît Cousson (2):
      OMAP4: PRM: add module hard reset support
      OMAP: hwmod: Add hardreset management support

Charulatha V (1):
      OMAP2PLUS: WDT: Fix: Disable WDT after reset during init

Cory Maccarrone (1):
      HTCHERALD: MMC, I2C, HTCPLD, SPI, TSC2046

David Anders (4):
      omap4: Panda: Add DEBUG_LL support
      omap4: pandaboard: remove unused hsmmc definition
      omap4: pandaboard: Fix the init if CONFIG_MMC_OMAP_HS is not set
      omap4: pandaboard: enable the ehci port on pandaboard

Dmitry Kasatkin (1):
      omap: crypto: updates to enable omap aes

Enric Balletbo i Serra (7):
      omap3: Add minimal OMAP3 IGEP module support
      omap3: Add external VBUS power switch and overcurrent detect onIGEP v2 board
      omap3: fix and improve the LED handling on IGEP v2 board
      omap3: Introduce function to detect the IGEP v2 hardwarerevision
      omap3: Fix handling some GPIO's for WLAN-BT combo on IGEP v2
      omap3: Add i2c eeprom driver to read EDID on IGEP v2
      omap3: Remove VMMC2 regulator on IGEP v2

Govindraj.R (8):
      OMAP2: UART: remove set_uart_globals
      OMAP clock: Add uart4_ick/fck definitions for 3630
      OMAP3: PRCM: Consider UART4 for 3630 chip in prcm_setup_regs
      OMAP3: PM: Add prepare idle and resume idle call for uart4
      OMAP3: serial: Fix uart4 handling for 3630
      serial: Add OMAP high-speed UART driver
      OMAP: SERIAL: Enable omap-serial driver in Kconfig
      OMAP3: SERIAL: Initialize all omap-uarts for zoom boards

Grazvydas Ignotas (2):
      omap: pandora: add fixed regulator for wlan
      omap: pandora: enable twl4030 charger

Hema HK (1):
      OMAP: hwmod: Set autoidle after smartidle during _sysc_enable

Igor Grinberg (5):
      omap3: Introduce CompuLab CM-T3517 module
      omap3: cm-t3517: add support for v3020 rtc
      omap3: cm-t3517: add support for usb host
      omap3: cm-t3517: add support for NAND flash
      omap3: cm-t3517: add support for TI HECC

Janusz Krzysztofik (3):
      OMAP1: Add support for SoC camera interface
      OMAP1: Amstrad Delta: add support for camera
      OMAP1: Amstrad Delta: add camera controlled LEDS trigger

Jarkko Nikula (8):
      omap: n8x0: Cleanup i2c1 and menelaus registration
      omap: n8x0: Register i2c2 and add board info with tlv320aic3xfor N810
      omap: n8x0: Mux i2s codec port pins for McBSP block
      omap2: McBSP: Remove mux code for OMAP2420 McBSP2 and do cleanups
      OMAP: McBSP: Fix CLKR and FSR signal muxing
      OMAP: McBSP: Swap CLKS source definition
      OMAP: McBSP: Remove null omap44xx ops comment
      omap: dma: Fix buffering disable bit setting for omap24xx

Jon Hunter (1):
      omap3: Prevent SDRC deadlock when L3 is changing frequency

Kevin Hilman (20):
      OMAP3: PM: whitespace cleanup around IO wakeup enable
      OMAP2+: PM: initial runtime PM core support
      OMAP1: PM: add simple runtime PM layer to manage clocks
      OMAP: hwmod: separate list locking and hwmod hardware locking
      OMAP3: PM: move device-specific special cases from PM core into CPUidle
      Revert "OMAP: omap_device: add omap_device_is_valid()"
      OMAP: omap_device: make all devices a child of a new parent device
      OMAP: GPIO: ensure debounce clocks are disabled during idle/suspend
      OMAP2+: defconfig: modularize bluetooth, audio and WLAN
      OMAP2+: defconfig: disable CPUfreq
      OMAP2/3: UART: add omap_hwmod data for UARTs 1-4
      OMAP: UART: omap_device conversions, remove implicit 8520 assumptions
      OMAP: UART: don't do automatic bus-level suspend/resume
      OMAP: UART: use non-locking versions of hwmod enable/idle functions
      Merge branch 'pm-hwmod-wdog' into pm-hwmods
      manual merge for pm-hwmod-uart due to conflicts
      OMAP3: CPUidle: remove redundant setting of PER next power state
      OMAP2: PM: check UART status before trying to idle
      OMAP3: PM: fix scratchpad memory accesses for off-mode
      omap: UART: fix wakeup registers for OMAP24xx UART2

Kishon Vijay Abraham I (1):
      OMAP: omap_device: Fix to support multiple hwmods for a single device

Lennert Buytenhek (1):
      update OMAP Kconfig help texts for all supported SoC models

Liam Girdwood (1):
      OMAP: hwmod: Fix omap_hwmod_reset wrong state test

Loïc Minier (1):
      OMAP: PM: Fix build when CONFIG_PM_DEBUG isn't set

Madhusudhan Chikkature (1):
      OMAP4 ES2: HSMMC soft reset change

Manjunath Kondaiah G (6):
      OMAP: mach-omap2: Fix incorrect assignment warnings
      OMAP: mach-omap2: Fix static declaration warnings
      OMAP2plus: Fix static function warnings
      OMAP: mach-omap2: Fix miscellaneous sparse warnings
      OMAP: plat-omap: Fix static function warnings
      OMAP3: Keypad: Fix incorrect type initializer

Mathieu J. Poirier (1):
      omap: Adding beagle i2c eeprom driver to read EDID

Nicolas Kaiser (1):
      arm/omap: remove duplicated include

Partha Basak (1):
      OMAP: hwmod: Handle opt clocks node using clk_add_alias

Paul Walmsley (14):
      OMAP2/3: PRM: add module hard reset support
      OMAP: hwmod: add an hardreset API for use by other core code
      OMAP: hwmod: improve documentation, clean up function names
      OMAP clockdomain: initialize clockdomain registers when the clockdomain layer starts
      OMAP2+: Kconfig: disallow builds for boards that don't use the currently-selected SoC
      OMAP2420: CTRL: fix OMAP242X_CTRL_REGADDR macro
      OMAP2420: clock: add MCBSP_CLKS node and clkdev aliases
      OMAP2430: clock: add MCBSP_CLKS node and clkdev aliases
      OMAP3xxx: clock: add clkdev aliases for McBSP fclk source switching
      OMAP: McBSP: implement McBSP CLKR and FSR signal muxing via mach-omap2/mcbsp.c
      OMAP: McBSP: implement functional clock switching via clock framework
      OMAP: split plat-omap/common.c
      OMAP: control: move plat-omap/control.h to mach-omap2/control.h
      OMAP2+: clock: reduce the amount of standard debugging while disabling unused clocks

Peter Ujfalusi (2):
      omap: McBSP: Do not enable SRG in slave mode
      OMAP3: DMA: Errata i541: sDMA FIFO draining does not finish

Rajeev Kulkarni (1):
      OMAP4: prcm: Fix global warm reset bit position

Rajendra Nayak (7):
      OMAP: hwmod: Enable module wakeup if in smartidle
      OMAP4: PM: Declare idle modules as functional too
      OMAP4: clocks: Update clock tree for ES2
      OMAP4: CM & PRM: Update PRCM register bitshifts and masks for ES2
      OMAP4: PM: Define additional registers for ES2
      OMAP4: powerdomain: Update DSS logic state for ES2
      omap: hwmod: Handle modules with 16bit registers

Ricardo Salveti de Araujo (1):
      omap4: board-omap4panda: adding leds status1 and status2

Robert Nelson (3):
      omap: Beagle: revision detection
      omap: Beagle: only Cx boards use pin 23 for write protect
      omap: Beagle: no gpio_wp pin connection on xM

Sanjeev Premi (2):
      omap2: fix assorted compiler warnings
      omap2/3: Update revision identification

Santosh Shilimkar (12):
      omap: Update and rename common defconfig for omap2plus devices
      omap: pm-debug: Move common debug code to pm-debug.c
      omap: pm-debug: Enable wakeup_timer_milliseconds debugfs entry
      omap: pm: Move set_pwrdm_state routine to common pm.c
      omap4: Update id.c and cpu.h for es2.0
      omap4: l2x0: Fix init parameter for es2.0
      omap4: Fix bootup crash observed with higher CPU clocks
      omap4: control: Add ctrl_pad_base to omap_globals
      omap4: control: Add accessor api's for pad control module
      omap4: control: Add the register definition headers
      omap4: control: Fix the control module register accesses
      omap: serial: Fix the boot-up crash/reboot without CONFIG_PM

Shubhrajyoti Datta (2):
      hmc5843: Digital compass board file
      omap: 4430sdp board support for proximity sensor

Subramaniam C.A (1):
      omap: i2c: Avoid compilation error in case the header is included multiple times

Sukumar Ghorai (1):
      omap: mmc: extended to pass host capabilities from board file

Thara Gopinath (2):
      OMAP: PM debugfs removing OMAP3 hardcodings.
      OMAP4: pm.c extensions for OMAP4 support

Tim Nordell (4):
      ARM: OMAP3LOGIC: Adding LogicPD OMAP3 board support
      ARM: OMAP3LOGIC: Adding SDMMC support
      ARM: OMAP3LOGIC: Add generic smsc911x support when connected to GPMC
      ARM: OMAP3LOGIC: Added SMSC Ethernet board support

Tony Lindgren (20):
      omap: Fix CONFIG_LOCAL_TIMERS initialization for multi-omap
      omap: Update omap3_defconfig to work with SMP_ON_UP
      omap: Update omap3_defconfig for omap2
      Merge branch 'hwmod_2.6.37' of git://git.pwsan.com/linux-2.6 into omap-for-linus
      Merge branch 'pm-next' of ssh://master.kernel.org/.../khilman/linux-omap-pm into omap-for-linus
      Merge branch 'pm-runtime' of ssh://master.kernel.org/.../khilman/linux-omap-pm into omap-for-linus
      Merge branch 'omap_for_2.6.37' of git://dev.omapzoom.org/pub/scm/santosh/kernel-omap4-base into omap-for-linus
      Merge branch 'devel-omap-misc' into omap-for-linus
      Merge branch 'misc_2.6.37' of git://git.pwsan.com/linux-2.6 into omap-for-linus
      Merge branch 'devel-boards' into omap-for-linus
      Merge branch 'devel-omap-smp-on-up' into omap-for-linus
      Merge branch 'omap4_and_sdrc_2.6.27' of git://git.pwsan.com/linux-2.6 into omap-for-linus
      omap: Fix omap_mux_init_signal not to trash muxname
      omap: Keep nwires for omap1 and 2420 MMC controller
      Merge branch 'pm-next-2' of ssh://master.kernel.org/.../khilman/linux-omap-pm into omap-for-linus
      Merge branches 'devel-omap1' and 'devel-omap2plus' into omap-for-linus
      Merge branch 'pm-hwmods' of ssh://master.kernel.org/.../khilman/linux-omap-pm into omap-for-linus
      omap: Update omap2plus_defconfig to use ttyO instead ttyS
      Merge branch 'control_mcbsp_fix_2.6.37' of git://git.pwsan.com/linux-2.6 into omap-for-linus
      omap: Fix spotty MMC voltages

Varadarajan, Charulatha (5):
      OMAP3: hwmod data: Add watchdog timer
      OMAP2420: hwmod data: Add watchdog timer
      OMAP2430: hwmod data: Add watchdog timer
      OMAP: WDT: Split OMAP1 and OMAP2PLUS device registration
      OMAP: WDT: Use PM runtime APIs instead of clk FW APIs

Vasiliy Kulikov (1):
      serial: omap-serial: fix signess error

Vikram Pandita (2):
      omap: sram: fix is_sram_locked check
      omap4: sram: Fix start address

kishore kadiyala (2):
      omap4 hsmmc: Register offset handling
      omap4 hsmmc: Update ocr mask for MMC2 for regulator to use

matt mooney (1):
      arm: remove cast from void*

 arch/arm/Kconfig                                   |    2 +-
 arch/arm/configs/n8x0_defconfig                    |   94 --
 .../{omap3_defconfig => omap2plus_defconfig}       |   51 +-
 arch/arm/configs/omap_4430sdp_defconfig            |  125 --
 arch/arm/configs/omap_generic_2420_defconfig       |   37 -
 arch/arm/mach-omap1/Makefile                       |    2 +-
 arch/arm/mach-omap1/board-ams-delta.c              |   69 +
 arch/arm/mach-omap1/board-h2-mmc.c                 |    3 +-
 arch/arm/mach-omap1/board-h3-mmc.c                 |    3 +-
 arch/arm/mach-omap1/board-htcherald.c              |  321 +++++-
 arch/arm/mach-omap1/board-sx1-mmc.c                |    3 +-
 arch/arm/mach-omap1/devices.c                      |   70 +
 arch/arm/mach-omap1/include/mach/camera.h          |   11 +
 arch/arm/mach-omap1/pm_bus.c                       |   98 ++
 arch/arm/mach-omap2/Kconfig                        |   54 +-
 arch/arm/mach-omap2/Makefile                       |   28 +-
 arch/arm/mach-omap2/board-2430sdp.c                |    3 +-
 arch/arm/mach-omap2/board-3430sdp.c                |   12 +-
 arch/arm/mach-omap2/board-3630sdp.c                |    3 +-
 arch/arm/mach-omap2/board-4430sdp.c                |   87 ++-
 arch/arm/mach-omap2/board-am3517evm.c              |    7 +-
 arch/arm/mach-omap2/board-apollon.c                |    2 +-
 arch/arm/mach-omap2/board-cm-t35.c                 |    9 +-
 arch/arm/mach-omap2/board-cm-t3517.c               |  292 ++++
 arch/arm/mach-omap2/board-devkit8000.c             |    7 +-
 arch/arm/mach-omap2/board-flash.c                  |    3 +-
 .../mach-omap2/{include/mach => }/board-flash.h    |    2 +
 arch/arm/mach-omap2/board-generic.c                |   16 +-
 arch/arm/mach-omap2/board-h4.c                     |    2 +-
 arch/arm/mach-omap2/board-igep0020.c               |  369 ++++--
 arch/arm/mach-omap2/board-igep0030.c               |  400 ++++++
 arch/arm/mach-omap2/board-ldp.c                    |    8 +-
 arch/arm/mach-omap2/board-n8x0.c                   |   65 +-
 arch/arm/mach-omap2/board-omap3beagle.c            |  106 ++-
 arch/arm/mach-omap2/board-omap3evm.c               |    9 +-
 arch/arm/mach-omap2/board-omap3logic.c             |  241 ++++
 arch/arm/mach-omap2/board-omap3pandora.c           |   53 +-
 arch/arm/mach-omap2/board-omap3stalker.c           |    9 +-
 arch/arm/mach-omap2/board-omap3touchbook.c         |    7 +-
 arch/arm/mach-omap2/board-omap4panda.c             |  109 ++-
 arch/arm/mach-omap2/board-overo.c                  |    5 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c       |    9 +-
 arch/arm/mach-omap2/board-rx51-sdram.c             |    2 +-
 arch/arm/mach-omap2/board-rx51-video.c             |    2 +
 arch/arm/mach-omap2/board-zoom-debugboard.c        |    2 +
 arch/arm/mach-omap2/board-zoom-peripherals.c       |   10 +-
 arch/arm/mach-omap2/board-zoom2.c                  |    1 +
 arch/arm/mach-omap2/board-zoom3.c                  |    1 +
 arch/arm/mach-omap2/clock.c                        |    2 +-
 arch/arm/mach-omap2/clock2420_data.c               |   42 +-
 arch/arm/mach-omap2/clock2430_data.c               |   66 +-
 arch/arm/mach-omap2/clock3xxx_data.c               |   36 +-
 arch/arm/mach-omap2/clock44xx_data.c               | 1444 ++++++++++++--------
 arch/arm/mach-omap2/clockdomain.c                  |  110 +--
 arch/arm/mach-omap2/cm-regbits-34xx.h              |    2 +
 arch/arm/mach-omap2/cm-regbits-44xx.h              | 1287 +++++++++---------
 arch/arm/mach-omap2/cm44xx.h                       |   90 ++-
 arch/arm/mach-omap2/cm4xxx.c                       |    9 +-
 arch/arm/mach-omap2/common.c                       |  135 ++
 arch/arm/mach-omap2/control.c                      |   33 +-
 .../include/plat => mach-omap2}/control.h          |   49 +-
 arch/arm/mach-omap2/cpuidle34xx.c                  |   58 +-
 arch/arm/mach-omap2/devices.c                      |  198 +++-
 arch/arm/mach-omap2/gpmc-smsc911x.c                |  113 ++
 arch/arm/mach-omap2/hsmmc.c                        |   92 +-
 arch/arm/mach-omap2/hsmmc.h                        |    3 +-
 arch/arm/mach-omap2/id.c                           |  115 ++-
 arch/arm/mach-omap2/include/mach/board-rx51.h      |   11 +
 arch/arm/mach-omap2/include/mach/board-zoom.h      |    4 -
 .../include/mach/ctrl_module_core_44xx.h           |  391 ++++++
 .../include/mach/ctrl_module_pad_core_44xx.h       | 1409 +++++++++++++++++++
 .../include/mach/ctrl_module_pad_wkup_44xx.h       |  236 ++++
 .../include/mach/ctrl_module_wkup_44xx.h           |   92 ++
 arch/arm/mach-omap2/io.c                           |    8 +-
 arch/arm/mach-omap2/io.h                           |    7 +
 arch/arm/mach-omap2/irq.c                          |    1 -
 arch/arm/mach-omap2/mailbox.c                      |    8 +-
 arch/arm/mach-omap2/mcbsp.c                        |  105 +-
 arch/arm/mach-omap2/mux.c                          |   23 +-
 arch/arm/mach-omap2/mux.h                          |    2 +-
 arch/arm/mach-omap2/mux2420.c                      |    2 +-
 arch/arm/mach-omap2/mux2430.c                      |    2 +-
 arch/arm/mach-omap2/mux34xx.c                      |   12 +-
 arch/arm/mach-omap2/omap4-common.c                 |   10 +-
 arch/arm/mach-omap2/omap_hwmod.c                   |  599 +++++++--
 arch/arm/mach-omap2/omap_hwmod_2420_data.c         |  257 ++++
 arch/arm/mach-omap2/omap_hwmod_2430_data.c         |  257 ++++
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |  319 +++++-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |  850 ++++++++++++
 arch/arm/mach-omap2/pm-debug.c                     |   44 +-
 arch/arm/mach-omap2/pm.c                           |   75 +-
 arch/arm/mach-omap2/pm.h                           |   11 +-
 arch/arm/mach-omap2/pm24xx.c                       |    4 +-
 arch/arm/mach-omap2/pm34xx.c                       |  126 +--
 arch/arm/mach-omap2/pm_bus.c                       |   85 ++
 arch/arm/mach-omap2/powerdomains44xx.h             |    2 +-
 arch/arm/mach-omap2/prcm-common.h                  |    5 +
 arch/arm/mach-omap2/prcm.c                         |   33 +-
 arch/arm/mach-omap2/prm-regbits-34xx.h             |    1 +
 arch/arm/mach-omap2/prm-regbits-44xx.h             | 1314 ++++++++++--------
 arch/arm/mach-omap2/prm.h                          |   18 +-
 arch/arm/mach-omap2/prm2xxx_3xxx.c                 |  110 ++
 arch/arm/mach-omap2/prm44xx.c                      |  116 ++
 arch/arm/mach-omap2/prm44xx.h                      |   14 +-
 arch/arm/mach-omap2/serial.c                       |  578 ++++----
 arch/arm/mach-omap2/sleep34xx.S                    |    2 +-
 arch/arm/mach-omap2/sram34xx.S                     |    6 +-
 arch/arm/mach-omap2/timer-gp.c                     |    8 +-
 .../include/plat => mach-omap2}/timer-gp.h         |    3 +-
 arch/arm/mach-omap2/usb-fs.c                       |    6 +-
 arch/arm/plat-omap/Kconfig                         |    2 +-
 arch/arm/plat-omap/Makefile                        |    4 +-
 arch/arm/plat-omap/clock.c                         |    5 +-
 arch/arm/plat-omap/common.c                        |  290 ----
 arch/arm/plat-omap/counter_32k.c                   |  183 +++
 arch/arm/plat-omap/cpu-omap.c                      |    4 +-
 arch/arm/plat-omap/devices.c                       |   42 -
 arch/arm/plat-omap/dma.c                           |   50 +-
 arch/arm/plat-omap/dmtimer.c                       |    2 +-
 arch/arm/plat-omap/fb.c                            |    2 +
 arch/arm/plat-omap/fb.h                            |   10 +
 arch/arm/plat-omap/gpio.c                          |   10 +-
 arch/arm/plat-omap/include/plat/common.h           |    5 +-
 arch/arm/plat-omap/include/plat/cpu.h              |   41 +-
 arch/arm/plat-omap/include/plat/dma.h              |    6 +
 arch/arm/plat-omap/include/plat/dmtimer.h          |    2 +
 arch/arm/plat-omap/include/plat/gpmc-smsc911x.h    |   35 +
 arch/arm/plat-omap/include/plat/i2c.h              |    4 +
 arch/arm/plat-omap/include/plat/irqs.h             |    2 +
 arch/arm/plat-omap/include/plat/mcbsp.h            |   22 +
 arch/arm/plat-omap/include/plat/mmc.h              |   12 +-
 arch/arm/plat-omap/include/plat/omap-serial.h      |  128 ++
 arch/arm/plat-omap/include/plat/omap24xx.h         |    2 +-
 arch/arm/plat-omap/include/plat/omap_device.h      |    4 +-
 arch/arm/plat-omap/include/plat/omap_hwmod.h       |   62 +-
 arch/arm/plat-omap/include/plat/powerdomain.h      |    2 +
 arch/arm/plat-omap/include/plat/prcm.h             |    2 +
 arch/arm/plat-omap/include/plat/sdrc.h             |    1 +
 arch/arm/plat-omap/include/plat/sram.h             |    1 -
 arch/arm/plat-omap/include/plat/uncompress.h       |    5 +
 arch/arm/plat-omap/include/plat/usb.h              |    2 +-
 arch/arm/plat-omap/mcbsp.c                         |   26 +-
 arch/arm/plat-omap/omap_device.c                   |  110 +-
 arch/arm/plat-omap/sram.c                          |   37 +-
 arch/arm/plat-omap/sram.h                          |    6 +
 drivers/mmc/host/omap_hsmmc.c                      |   43 +-
 drivers/serial/Kconfig                             |   27 +
 drivers/serial/Makefile                            |    1 +
 drivers/serial/omap-serial.c                       | 1333 ++++++++++++++++++
 drivers/usb/gadget/omap_udc.c                      |   18 +-
 drivers/watchdog/omap_wdt.c                        |   42 +-
 include/linux/serial_core.h                        |    3 +
 sound/soc/omap/omap-mcbsp.c                        |  119 +--
 sound/soc/omap/omap-mcpdm.c                        |    1 -
 154 files changed, 12794 insertions(+), 3788 deletions(-)
 delete mode 100644 arch/arm/configs/n8x0_defconfig
 rename arch/arm/configs/{omap3_defconfig => omap2plus_defconfig} (90%)
 delete mode 100644 arch/arm/configs/omap_4430sdp_defconfig
 delete mode 100644 arch/arm/configs/omap_generic_2420_defconfig
 create mode 100644 arch/arm/mach-omap1/include/mach/camera.h
 create mode 100644 arch/arm/mach-omap1/pm_bus.c
 create mode 100644 arch/arm/mach-omap2/board-cm-t3517.c
 rename arch/arm/mach-omap2/{include/mach => }/board-flash.h (88%)
 create mode 100644 arch/arm/mach-omap2/board-igep0030.c
 create mode 100644 arch/arm/mach-omap2/board-omap3logic.c
 create mode 100644 arch/arm/mach-omap2/common.c
 rename arch/arm/{plat-omap/include/plat => mach-omap2}/control.h (92%)
 create mode 100644 arch/arm/mach-omap2/gpmc-smsc911x.c
 create mode 100644 arch/arm/mach-omap2/include/mach/board-rx51.h
 create mode 100644 arch/arm/mach-omap2/include/mach/ctrl_module_core_44xx.h
 create mode 100644 arch/arm/mach-omap2/include/mach/ctrl_module_pad_core_44xx.h
 create mode 100644 arch/arm/mach-omap2/include/mach/ctrl_module_pad_wkup_44xx.h
 create mode 100644 arch/arm/mach-omap2/include/mach/ctrl_module_wkup_44xx.h
 create mode 100644 arch/arm/mach-omap2/io.h
 create mode 100644 arch/arm/mach-omap2/omap_hwmod_44xx_data.c
 create mode 100644 arch/arm/mach-omap2/pm_bus.c
 create mode 100644 arch/arm/mach-omap2/prm2xxx_3xxx.c
 create mode 100644 arch/arm/mach-omap2/prm44xx.c
 rename arch/arm/{plat-omap/include/plat => mach-omap2}/timer-gp.h (86%)
 create mode 100644 arch/arm/plat-omap/counter_32k.c
 create mode 100644 arch/arm/plat-omap/fb.h
 create mode 100644 arch/arm/plat-omap/include/plat/gpmc-smsc911x.h
 create mode 100644 arch/arm/plat-omap/include/plat/omap-serial.h
 create mode 100644 arch/arm/plat-omap/sram.h
 create mode 100644 drivers/serial/omap-serial.c
