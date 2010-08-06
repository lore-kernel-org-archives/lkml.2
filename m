Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760855Ab0HFI77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 04:59:59 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:54415 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756476Ab0HFI7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 04:59:53 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/OXyoQwmZA58201sqzyCpM
Date: Fri, 6 Aug 2010 12:00:19 +0300
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: [GIT PULL] omap updates for 2.6.36 merge window
Message-ID: <20100806090018.GC23778@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull omap updates from:

  git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-for-linus

Regards,

Tony


The following changes since commit be82ae0238b0453afcf4a76f0512b7dde34ba500:

  Merge branch 'devel' of master.kernel.org:/home/rmk/linux-2.6-arm (2010-08-03 14:31:24 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-for-linus

Anand Gadiyar (3):
      OMAP3: wait on IDLEST after enabling USBTLL fclk
      OMAP3630: Add ES1.1 and ES1.2 detection
      omap: 3630: disable TLL SAR on 3630 ES1

Artem Bityutskiy (1):
      omap: device: improve errors handling

Benoit Cousson (1):
      OMAP2&3: hwmod: Remove _hwmod prefix in name string

Christoph Egger (8):
      Replace dead OMAP_MUX_ERRORS with OMAP_MUX_WARNINGS
      Removing dead OMAP_IR
      Removing dead OMAP_DSP
      Removing dead OMAP_STI
      Replacing LEDS_OMAP_DEBUG with OMAP_DEBUG_LEDS
      Removing dead APM
      Removing dead MACH_OMAP_H4_OTG
      Removing dead MACH_OMAP2_H4_USB1

Cory Maccarrone (1):
      omap1: omap7xx clocks, mux, serial fixes

David Anders (1):
      omap4: Add OMAP4 Panda Support

Deepak K (1):
      omap2/3/4: serial: errata i202: fix for MDR1 access

Felipe Contreras (13):
      omap: mailbox: trivial cleanups
      omap: mailbox: reorganize structures
      omap: mailbox: 2420 should be detected at run-time
      omap: mailbox: use correct config for omap1
      omap: mailbox: update omap1 probing
      omap: mailbox: don't export unecessary symbols
      omap: mailbox: remove unecessary fields
      omap: mailbox: add IRQ names
      omap: mailbox: reorganize registering
      omap: mailbox: simplify omap_mbox_register()
      omap: mailbox: only compile for configured archs
      omap: mailbox: standarize on 'omap-mailbox'
      omap: mailbox: reorganize headers

Fernando Guzman Lugo (4):
      Mailbox: free mailbox interrupt before freeing blk queue
      Mailbox: flush pending deferred works before freeing blk queue
      Mailbox: Check valid registered callback before calling
      Mailbox: disable mailbox interrupt when request queue

Govindraj R (1):
      omap3: serial: Add context save and restore for mcr

Grazvydas Ignotas (3):
      omap3: pandora: update gpio-keys data
      omap3: pandora: add NAND and wifi support
      omap: mux: fix multipath gpio handling

Hemanth V (1):
      OMAP4: Add GPIO LED support for SDP board

Hiroshi DOYU (6):
      omap iommu: Introduce iopgd_is_table MACRO
      omap iommu: Rename iopte_[p,v]addr -> iopte_page_[p,v]addr
      omap iommu: move iommu_disable at fault to the above layer
      omap iommu: Make omap-iommu.o built-in
      Mailbox: new mutext lock for h/w mailbox configuration
      omap mailbox: Set a device in logical mbox instance for traceability

Jarkko Nikula (4):
      omap: rx51: Set regulator V28 always on
      omap: rx51: Add platform_data for tlv320aic3x with reset gpionumber
      omap: rx51: Use REGULATOR_SUPPLY macro when initializingregulator consumers
      omap: rx51: Add supply and data for the tpa6130a2 headphoneamplifier

Jason Wang (1):
      omap: Fix DEBUG_LL uart to access phys addr when MMU isn't enable

Kan-Ru Chen (5):
      OMAP2: Devkit8000: Enable DVI-D output
      OMAP2: Devkit8000: Setup LCD reset
      omap: Add new interface omap_get_die_id
      omap: Use omap_get_die_id() to get the DIE ids
      omap: Devkit8000: Use DIE id to initialize dm9000 MAC address

Kanigeri, Hari (3):
      omap iommu: update irq mask to be specific about twl and tlb
      omap iommu: add functionality to get TLB miss interrupt
      omap iommu: update ducati mmu irq define name

Kevin Hilman (8):
      OMAP24xx: CM: fix mask used for checking IDLEST status
      OMAP2/3: hwmod: L3 and L4 CORE/PER/WKUP hwmods don't have IDLEST
      OMAP: hwmod: add non-locking versions of enable and idle functions
      OMAP: omap_device: ensure hwmod tracks attached omap_device pointer
      OMAP: PM: create omap_devices for MPU, DSP, L3
      OMAP: hwmod data: add class for IVA hwmods
      OMAP2&3: hwmod: Replace l3 -> l3_main
      OMAP3: hwmod data: add data for OMAP3 IVA2

Mathias Nyman (1):
      omap: tsl2563 ALS support for Nokia N900

Mike Rapoport (1):
      omap3: introduce omap3_map_io

Nishanth Menon (4):
      omap2/3/4: serial: remove initialization sparse warnings
      omap2/3/4: serial: kill dev_attr_sleep_timeout sparse warn
      omap2/3/4: serial: introduce errata handling
      omap2/3: id: fix sparse warning

Ohad Ben-Cohen (6):
      omap: zoom2: wlan board muxing
      omap: zoom3: wlan board muxing
      omap: mailbox: convert rwlocks to spinlock
      omap: mailbox cleanup: split MODULE_AUTHOR line
      omap: mailbox: remove (un)likely macros from cold paths
      omap: mailbox: convert block api to kfifo

Paul Walmsley (9):
      OMAP: clock: add kerneldoc for structures; move flags closer to structs
      OMAP1: OPP: add KConfig entry for 96MHz ARM rate (using a 12MHz oscillator)
      OMAP1: clock: some cleanup
      OMAP: hwmod: allow omap_hwmod_late_init() caller to skip module idle in _setup()
      OMAP2: hwmod data: add IVA1 (2420), IVA2 (2430) hwmods
      OMAP: hwmod/device: add omap_{device,hwmod}_get_mpu_rt_va
      OMAP2+: hwmod/device: update documentation and copyright
      OMAP: PM constraints: add return values; add requesting device param to omap_pm_set_max_dev_wakeup_lat()
      OMAP: PM constraints: add omap_pm_set_min_clk_rate()

Rajendra Nayak (2):
      OMAP4: hwmod: Enable omap_device build for OMAP4
      omap4: suspend: Add basic system suspend support

Samu Onkalo (1):
      omap: dma: Support for prefetch in destination synchronizedtransfer

Santosh Shilimkar (3):
      omap4: mmc: Fix the regulator resource for MMC2 on 4430sdp
      omap4: Add smc API to read AuxCoreBoot0 register
      omap4: hotplug: Add basic CPU hotplug support

Sergio Aguirre (1):
      omap3: Unify omap2_set_globals_3[43,6x]x functions

Shubhrajyoti Datta (1):
      omap4: Board changes for 4430sdp tmp105 temperature sensor

Steve Sakoman (1):
      omap: Overo: Fix support for second ethernet port

Sukumar Ghorai (8):
      omap3 gpmc: functionality enhancement
      omap3 nand: cleanup virtual address usages
      omap3 nand: fix issue in board file to detect nand
      omap3 flash: rename board-sdp-flash.c to be use by other boards
      omap3: add support for NAND on zoom2 board
      omap3: add support for NAND on zoom3 board
      omap-3630-sdp : Add support for Flash
      omap3: add support for NAND on LDP board

Thomas Weber (10):
      OMAP2: Devkit8000: Cleanup for power supplies
      OMAP2: Devkit8000: change panel to generic panel
      OMAP2: Devkit8000: Remove unneeded VDVI supply
      OMAP2: Devkit8000: Remove non existing vsim supply
      OMAP2: Devkit8000: Remove en-/disable for tv panel
      OMAP2: Devkit8000: Using the REGULATOR_SUPPLY macro
      OMAP2: Devkit8000: Using gpio_is_valid macro
      OMAP2: Devkit8000: Remove unused omap_board_config
      OMAP2: Devkit8000: Fix regulator for power supply
      OMAP2: powerdomain: Add break in switch statement

Tony Lindgren (33):
      Merge branch 'v2.6.35-rc3-iommu-for-next' of git://gitorious.org/~doyu/lk/mainline into omap-for-linus
      omap: Separate out omap2 FS USB platform init functions
      omap: Move omap2 FS USB platform init code into mach-omap2/usb-fs.c
      omap: Enable interface clock for omap2 FS USB
      omap: Move omap1 USB platform init code into mach-omap1/usb.c
      omap: mux: Fix omap_mux_init_gpio for omap24xx
      omap: mux: Renumber package defines to make room for older 24xx packages
      omap: mux: Allow compiling in new mux code on all mach-omap2 systems
      omap: mux: Remove unncessary parens from mux34xx.c
      omap: mux: Add data for 2420
      omap: mux: Add data for 2430
      omap: mux: Select SIP package for H4
      omap: mux: Select POP package for Apollon
      omap: mux: Select POP package for N8X0
      omap: mux: Select POP package for 2430SDP
      omap: mux: Make omap2 FS USB code use new mux functions
      omap: mux: Do keypad muxing in board-*.c files
      omap: mux: Mux Apollon LCD power in board-apollon.c
      omap: mux: Mux 2430 USB0HS_STP in board-2430.c
      omap: mux: Convert 2420 platform init code to use new mux code
      omap: mux: Remove old mux code
      ARM: Disable VGA console for ARM in most cases
      omap: Use 32KiHZ timer by default
      omap: Make omap specific features appear under Kconfig menu
      omap2/3/4: Move Kconfig options to mach-omap2/Kconfig
      omap2/3/4: Select all omaps and boards by default
      omap2/3/4: Add Kconfig option to compile in typical omap features
      omap: Add back UART MDR1 check into uncompress.h
      omap2: Fix GPIO numbers and smc91x for 2430sdp
      Merge branch 'devel-misc' into omap-for-linus
      Merge branch 'for_2.6.36' of git://git.pwsan.com/linux-2.6 into omap-for-linus
      Merge branch 'devel-map-io' into omap-for-linus
      Merge branch 'v2.6.35-omap-mailbox-for-next' of git://gitorious.org/~doyu/lk/mainline into omap-for-linus

Vincent Sanders (1):
      Remove ARM default configurations which duplicate omap3_defconfig

stanley.miao (1):
      OMAP3: AM3505/3517 do not have IO wakeup capability

 arch/arm/configs/am3517_evm_defconfig              |  127 ----
 arch/arm/configs/cm_t35_defconfig                  |  157 ----
 arch/arm/configs/devkit8000_defconfig              |  184 -----
 arch/arm/configs/igep0020_defconfig                |  179 -----
 arch/arm/configs/omap3_beagle_defconfig            |  134 ----
 arch/arm/configs/omap3_evm_defconfig               |  160 ----
 arch/arm/configs/omap3_pandora_defconfig           |  158 ----
 arch/arm/configs/omap3_stalker_lks_defconfig       |  150 ----
 arch/arm/configs/omap3_touchbook_defconfig         |  621 ---------------
 arch/arm/configs/omap_2430sdp_defconfig            |  136 ----
 arch/arm/configs/omap_3430sdp_defconfig            |  178 -----
 arch/arm/configs/omap_3630sdp_defconfig            |  154 ----
 arch/arm/configs/omap_apollon_2420_defconfig       |   92 ---
 arch/arm/configs/omap_h4_2420_defconfig            |  107 ---
 arch/arm/configs/omap_ldp_defconfig                |  135 ----
 arch/arm/configs/omap_zoom2_defconfig              |  143 ----
 arch/arm/configs/omap_zoom3_defconfig              |  155 ----
 arch/arm/configs/overo_defconfig                   |  275 -------
 arch/arm/configs/rx51_defconfig                    |  222 ------
 arch/arm/mach-omap1/Kconfig                        |   13 +
 arch/arm/mach-omap1/Makefile                       |    3 +
 arch/arm/mach-omap1/board-ams-delta.c              |    2 +-
 arch/arm/mach-omap1/board-fsample.c                |   12 +
 arch/arm/mach-omap1/board-generic.c                |    4 +-
 arch/arm/mach-omap1/board-h2.c                     |   31 +-
 arch/arm/mach-omap1/board-h3.c                     |   15 +-
 arch/arm/mach-omap1/board-htcherald.c              |    2 +-
 arch/arm/mach-omap1/board-innovator.c              |    4 +-
 arch/arm/mach-omap1/board-nokia770.c               |  136 +----
 arch/arm/mach-omap1/board-osk.c                    |    2 +-
 arch/arm/mach-omap1/board-palmte.c                 |   86 +---
 arch/arm/mach-omap1/board-palmtt.c                 |    2 +-
 arch/arm/mach-omap1/board-palmz71.c                |    2 +-
 arch/arm/mach-omap1/board-perseus2.c               |   12 +
 arch/arm/mach-omap1/board-sx1.c                    |    2 +-
 arch/arm/mach-omap1/board-voiceblue.c              |    2 +-
 arch/arm/mach-omap1/clock.c                        |   22 +-
 arch/arm/mach-omap1/clock.h                        |    2 +-
 arch/arm/mach-omap1/clock_data.c                   |  149 +++-
 arch/arm/mach-omap1/devices.c                      |   72 --
 arch/arm/mach-omap1/include/mach/debug-macro.S     |   10 +-
 arch/arm/mach-omap1/mailbox.c                      |   55 +-
 arch/arm/mach-omap1/mcbsp.c                        |    3 -
 arch/arm/mach-omap1/mux.c                          |    6 +-
 arch/arm/mach-omap1/serial.c                       |    7 +
 arch/arm/mach-omap1/usb.c                          |  530 +++++++++++++
 arch/arm/mach-omap2/Kconfig                        |   89 +++
 arch/arm/mach-omap2/Makefile                       |   23 +-
 arch/arm/mach-omap2/board-2430sdp.c                |   23 +-
 arch/arm/mach-omap2/board-3430sdp.c                |   24 +-
 arch/arm/mach-omap2/board-3630sdp.c                |  129 +++-
 arch/arm/mach-omap2/board-4430sdp.c                |   70 ++-
 arch/arm/mach-omap2/board-am3517evm.c              |    8 +-
 arch/arm/mach-omap2/board-apollon.c                |   30 +-
 arch/arm/mach-omap2/board-cm-t35.c                 |   28 +-
 arch/arm/mach-omap2/board-devkit8000.c             |  169 ++---
 .../{board-sdp-flash.c => board-flash.c}           |   93 +--
 arch/arm/mach-omap2/board-generic.c                |    1 -
 arch/arm/mach-omap2/board-h4.c                     |   60 +-
 arch/arm/mach-omap2/board-igep0020.c               |    8 +-
 arch/arm/mach-omap2/board-ldp.c                    |   43 +-
 arch/arm/mach-omap2/board-n8x0.c                   |   11 +
 arch/arm/mach-omap2/board-omap3beagle.c            |   32 +-
 arch/arm/mach-omap2/board-omap3evm.c               |    8 +-
 arch/arm/mach-omap2/board-omap3pandora.c           |  156 ++++-
 arch/arm/mach-omap2/board-omap3stalker.c           |    8 +-
 arch/arm/mach-omap2/board-omap3touchbook.c         |   33 +-
 arch/arm/mach-omap2/board-omap4panda.c             |  304 ++++++++
 arch/arm/mach-omap2/board-overo.c                  |   74 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c       |   78 ++-
 arch/arm/mach-omap2/board-rx51-video.c             |    1 -
 arch/arm/mach-omap2/board-rx51.c                   |    2 +-
 arch/arm/mach-omap2/board-zoom2.c                  |   64 ++-
 arch/arm/mach-omap2/board-zoom3.c                  |   64 ++-
 arch/arm/mach-omap2/clock3xxx_data.c               |    2 +-
 arch/arm/mach-omap2/cm.c                           |    6 +-
 arch/arm/mach-omap2/devices.c                      |   88 +--
 arch/arm/mach-omap2/gpmc-nand.c                    |   37 +-
 arch/arm/mach-omap2/gpmc.c                         |  284 +++++++-
 arch/arm/mach-omap2/i2c.c                          |   27 +-
 arch/arm/mach-omap2/id.c                           |   64 ++-
 .../include/mach/{board-sdp.h => board-flash.h}    |    9 +-
 arch/arm/mach-omap2/include/mach/board-zoom.h      |    6 +
 arch/arm/mach-omap2/include/mach/debug-macro.S     |   29 +-
 arch/arm/mach-omap2/include/mach/id.h              |   22 +
 arch/arm/mach-omap2/include/mach/omap4-common.h    |    7 +
 arch/arm/mach-omap2/io.c                           |   13 +-
 arch/arm/mach-omap2/iommu2.c                       |   44 +-
 arch/arm/mach-omap2/mailbox.c                      |  182 ++---
 arch/arm/mach-omap2/mcbsp.c                        |   13 +-
 arch/arm/mach-omap2/mux.c                          |  338 +--------
 arch/arm/mach-omap2/mux.h                          |   28 +-
 arch/arm/mach-omap2/mux2420.c                      |  688 +++++++++++++++++
 arch/arm/mach-omap2/mux2420.h                      |  282 +++++++
 arch/arm/mach-omap2/mux2430.c                      |  791 ++++++++++++++++++++
 arch/arm/mach-omap2/mux2430.h                      |  370 +++++++++
 arch/arm/mach-omap2/mux34xx.c                      |    8 +-
 arch/arm/mach-omap2/omap-headsmp.S                 |   16 -
 arch/arm/mach-omap2/omap-hotplug.c                 |   79 ++
 arch/arm/mach-omap2/omap-iommu.c                   |    2 +-
 arch/arm/mach-omap2/omap-smp.c                     |    3 +-
 arch/arm/mach-omap2/omap44xx-smc.S                 |   25 +
 arch/arm/mach-omap2/omap_hwmod.c                   |  106 ++-
 arch/arm/mach-omap2/omap_hwmod_2420_data.c         |   79 ++-
 arch/arm/mach-omap2/omap_hwmod_2430_data.c         |   81 ++-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |   92 ++-
 arch/arm/mach-omap2/omap_hwmod_common_data.c       |    3 +
 arch/arm/mach-omap2/omap_hwmod_common_data.h       |    1 +
 arch/arm/mach-omap2/pm.c                           |   84 ++
 arch/arm/mach-omap2/pm24xx.c                       |    1 -
 arch/arm/mach-omap2/pm34xx.c                       |    7 +-
 arch/arm/mach-omap2/pm44xx.c                       |  135 ++++
 arch/arm/mach-omap2/powerdomain.c                  |    1 +
 arch/arm/mach-omap2/powerdomains34xx.h             |   12 +-
 arch/arm/mach-omap2/serial.c                       |   80 ++-
 arch/arm/mach-omap2/usb-ehci.c                     |    1 -
 arch/arm/mach-omap2/usb-fs.c                       |  359 +++++++++
 arch/arm/mach-omap2/usb-musb.c                     |    1 -
 arch/arm/mach-omap2/usb-tusb6010.c                 |   14 +-
 arch/arm/plat-omap/Kconfig                         |   33 +-
 arch/arm/plat-omap/Makefile                        |    1 +
 arch/arm/plat-omap/common.c                        |   10 +-
 arch/arm/plat-omap/debug-leds.c                    |    2 +-
 arch/arm/plat-omap/devices.c                       |  124 ---
 arch/arm/plat-omap/dma.c                           |   11 +-
 arch/arm/plat-omap/gpio.c                          |    4 +-
 arch/arm/plat-omap/i2c.c                           |   12 +-
 arch/arm/plat-omap/include/plat/board.h            |    8 +
 arch/arm/plat-omap/include/plat/clock.h            |  130 +++-
 arch/arm/plat-omap/include/plat/common.h           |    9 +-
 arch/arm/plat-omap/include/plat/cpu.h              |   17 +-
 arch/arm/plat-omap/include/plat/dma.h              |    1 +
 arch/arm/plat-omap/include/plat/dsp_common.h       |   40 -
 arch/arm/plat-omap/include/plat/gpmc.h             |   42 +-
 arch/arm/plat-omap/include/plat/iommu.h            |    2 +
 arch/arm/plat-omap/include/plat/mailbox.h          |   20 +-
 arch/arm/plat-omap/include/plat/mux.h              |  224 +------
 arch/arm/plat-omap/include/plat/nand.h             |    6 +-
 arch/arm/plat-omap/include/plat/omap-pm.h          |  130 +++-
 arch/arm/plat-omap/include/plat/omap_device.h      |    2 +
 arch/arm/plat-omap/include/plat/omap_hwmod.h       |   14 +-
 arch/arm/plat-omap/include/plat/smp.h              |    1 +
 arch/arm/plat-omap/include/plat/uncompress.h       |    6 +
 arch/arm/plat-omap/include/plat/usb.h              |   49 ++-
 arch/arm/plat-omap/iommu.c                         |   27 +-
 arch/arm/plat-omap/iopgtable.h                     |    8 +-
 arch/arm/plat-omap/mailbox.c                       |  248 +++----
 arch/arm/plat-omap/mux.c                           |    2 +-
 arch/arm/plat-omap/omap-pm-noop.c                  |   61 ++-
 arch/arm/plat-omap/omap_device.c                   |   37 +-
 arch/arm/plat-omap/usb.c                           |  644 +----------------
 drivers/mtd/nand/omap2.c                           |  218 ++----
 drivers/video/console/Kconfig                      |    2 +-
 drivers/video/omap/lcd_apollon.c                   |    3 -
 154 files changed, 6420 insertions(+), 6534 deletions(-)
 delete mode 100644 arch/arm/configs/am3517_evm_defconfig
 delete mode 100644 arch/arm/configs/cm_t35_defconfig
 delete mode 100644 arch/arm/configs/devkit8000_defconfig
 delete mode 100644 arch/arm/configs/igep0020_defconfig
 delete mode 100644 arch/arm/configs/omap3_beagle_defconfig
 delete mode 100644 arch/arm/configs/omap3_evm_defconfig
 delete mode 100644 arch/arm/configs/omap3_pandora_defconfig
 delete mode 100644 arch/arm/configs/omap3_stalker_lks_defconfig
 delete mode 100644 arch/arm/configs/omap3_touchbook_defconfig
 delete mode 100644 arch/arm/configs/omap_2430sdp_defconfig
 delete mode 100644 arch/arm/configs/omap_3430sdp_defconfig
 delete mode 100644 arch/arm/configs/omap_3630sdp_defconfig
 delete mode 100644 arch/arm/configs/omap_apollon_2420_defconfig
 delete mode 100644 arch/arm/configs/omap_h4_2420_defconfig
 delete mode 100644 arch/arm/configs/omap_ldp_defconfig
 delete mode 100644 arch/arm/configs/omap_zoom2_defconfig
 delete mode 100644 arch/arm/configs/omap_zoom3_defconfig
 delete mode 100644 arch/arm/configs/overo_defconfig
 delete mode 100644 arch/arm/configs/rx51_defconfig
 create mode 100644 arch/arm/mach-omap1/usb.c
 rename arch/arm/mach-omap2/{board-sdp-flash.c => board-flash.c} (66%)
 create mode 100644 arch/arm/mach-omap2/board-omap4panda.c
 rename arch/arm/mach-omap2/include/mach/{board-sdp.h => board-flash.h} (71%)
 create mode 100644 arch/arm/mach-omap2/include/mach/id.h
 create mode 100644 arch/arm/mach-omap2/mux2420.c
 create mode 100644 arch/arm/mach-omap2/mux2420.h
 create mode 100644 arch/arm/mach-omap2/mux2430.c
 create mode 100644 arch/arm/mach-omap2/mux2430.h
 create mode 100644 arch/arm/mach-omap2/omap-hotplug.c
 create mode 100644 arch/arm/mach-omap2/pm.c
 create mode 100644 arch/arm/mach-omap2/pm44xx.c
 create mode 100644 arch/arm/mach-omap2/usb-fs.c
 delete mode 100644 arch/arm/plat-omap/include/plat/dsp_common.h
