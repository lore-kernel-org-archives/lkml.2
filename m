Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106Ab2EVFhs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 01:37:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57599 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab2EVFhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 01:37:39 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Olof Johansson <olof@lixom.net>
Subject: =?UTF-8?q?=5BGIT=20PULL=202/8=5D=20arm-soc=3A=20First=20batch=20of=20cleanups?=
Date: Mon, 21 May 2012 22:35:02 -0700
Message-Id: <1337664908-17478-3-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.1.488.g05fbf7a
In-Reply-To: <1337664908-17478-1-git-send-email-olof@lixom.net>
References: <1337664908-17478-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These cleanups are basically all over the place. The idea is to collect
changes with minimal impact but large number of changes so we can avoid
them from distracting in the diffstat in the other series.

A significant number of lines get removed here, in particular because
the ixp2000 and ixp23xx platforms get removed. These have never been
extremely popular and have fallen into disuse over time with no active
maintainer taking care of them. The u5500 soc never made it into a
product, so we are removing it from the ux500 platform.

Many good cleanups also went into the at91 and omap platforms, as has
been the case for a number of releases.

----------------------------------------------------------------

The following changes since commit 61e074fb17836a3661595d7e3a7646aa114a79b7:

  Merge tag 'maintainers' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/cleanup

for you to fetch changes up to 0e896b1ddc1905df904df98c204bacf028219729:

  Merge branch 'clps711x/cleanup' into next/cleanup

----------------------------------------------------------------

Alexander Clouter (4):
      ARM: orion5x: ts78xx whitespace cleanups
      ARM: orion5x: ts78xx fix NAND resource off by one
      ARM: orion5x: remove PM dependency from ts78xx
      ARM: orion5x: ts78xx debugging changes

Alexander Shiyan (8):
      ARM: i.MX51 iomux: add missed definitions for SION-bit and mode for some pads
      ARM: clps711x: Using a single definition for the PHYS and VIRT registers offset
      ARM: clps711x: Combine header files into one for clps711x-targets
      ARM: clps711x: Used own subarch directory for store header file
      ARM: clps711x: Added missing register definitions
      ARM: clps711x: Added note about support EP731x CPU to Kconfig
      ARM clps711x: Removed unused header mach/time.h
      ARM: clps711x: Cleanup IRQ handling

Amit Daniel Kachhap (1):
      ARM: EXYNOS: Adapt to cpuidle core time keeping and irq enable

Andrew Lunn (3):
      Orion5x: Fix warning: struct pci_dev declared inside paramter list
      Orion5x: Fix Section mismatch warnings
      Dove: Fix Section mismatch warnings

Arnd Bergmann (8):
      ARM: tegra: do not hide dma declarations
      Merge tag 'at91-3.5-cleanup' of git://github.com/at91linux/linux-at91 into next/cleanup
      Merge tag 'imx-cleanup' of git://git.pengutronix.de/git/imx/linux-2.6 into next/cleanup
      Merge branch 'ux500-del-u5500-for-arm-soc' of git://git.kernel.org/.../linusw/linux-stericsson into next/cleanup
      Merge branch 'clps711x/cleanup' into next/cleanup
      Merge branch 'clps711x/cleanup' into next/cleanup
      Merge branch 'marvell_cleanup_for_v3.5' of git://git.infradead.org/users/jcooper/linux into next/cleanup
      Merge branch 'clps711x/cleanup' into next/cleanup

Daniel Lezcano (18):
      ARM: OMAP4: cpuidle - Remove unused valid field
      ARM: OMAP4: cpuidle - Declare the states with the driver declaration
      ARM: OMAP4: cpuidle - Remove the cpuidle_params_table table
      ARM: OMAP4: cpuidle - fix static omap4_idle_data declaration
      ARM: OMAP4: cpuidle - Initialize omap4_idle_data at compile time
      ARM: OMAP4: cpuidle - use the omap4_idle_data variable directly
      ARM: OMAP4: cpuidle - remove omap4_idle_data initialization at boot time
      ARM: OMAP3: cpuidle - remove rx51 cpuidle parameters table
      ARM: OMAP3: define cpuidle statically
      ARM: OMAP3: cpuidle - remove errata check in the init function
      ARM: OMAP3: cpuidle - remove the 'valid' field
      ARM: OMAP3: cpuidle - remove cpuidle_params_table
      ARM: OMAP3: define statically the omap3_idle_data
      ARM: OMAP3: cpuidle - use omap3_idle_data directly
      ARM: OMAP3: cpuidle - simplify next_valid_state
      ARM: OMAP3: set omap3_idle_data as static
      ARM: OMAP3: cpuidle - set global variables static
      ARM: OMAP3: cpuidle - check the powerdomain lookup

Danny Kukawka (2):
      ARM: tegra: fix multiple asm/hardware/gic.h inclusion
      arch/arm/mach-msm: linux/gpio.h included twice

H Hartley Sweeten (2):
      arm: ep93xx: use DEFINE_RES_* macros
      arm: ep93xx: use gpio_led_register_device

Hector Oron (1):
      ARM: i.MX: efikamx: match machine descriptions with legacy

Jean-Christophe PLAGNIOL-VILLARD (10):
      ARM: at91: uncompress Store UART address in a variable
      ARM: at91: uncompress: autodetect the uart to use
      ARM: at91: drop at91_set_serial_console
      ARM: at91: do not pin mux the UARTs in init_early
      ARM: at91: move at91_init_leds to board init
      ARM: at91: pm select memory controler at runtime
      ARM: at91: add SOC_AT91SAM9 kconfig option to factorise select
      ARN: at91: introduce SOC_AT91xxx define to allow to compile SoC core support
      ARM: at91/dt: do not specify the board any more
      ARM: at91: add defconfig for device tree

Kukjin Kim (1):
      Merge branch 'next/cleanup-samsung-macro' into next/cleanup-samsung

Linus Walleij (3):
      ARM: ux500: delete U5500 support
      mfd/db5500-prcmu: delete DB5500 PRCMU support
      mfd/ab5500: delete AB5500 support

Lothar Waßmann (1):
      ARM: mx53: fix pad definitions for MX53_PAD_EIM_D28__I2C1_SDA and MX53_PAD_GPIO_8__CAN1_RXCAN

Marc Kleine-Budde (2):
      arm: imx: make various struct sys_timer static
      arm: imx: add missing select IMX_HAVE_PLATFORM for MACH_MX35_3DS in Kconfig

Nicolas Ferre (9):
      ARM: at91: change AT91 Kconfig entry comment
      ARM: at91/Kconfig: change at91sam9g45 entry
      ARM: at91/Kconfig: add comment to at91sam9x5 family entry
      ARM: at91/Kconfig: add clarifications to AT91SAM9M10G45-EK entry
      ARM: at91/Kconfig: add AT91SAM9x5 family to AT91_EARLY_DBGU0 entry
      ARM: at91/Kconfig: website link for AT91SAM9G20-EK
      rtc: Kconfig: remove dependency for AT91 rtc driver
      Input: Kconfig: remove dependency for atmel_tsadcc driver
      hwrng: Kconfig: remove dependency for atmel-rng driver

Olof Johansson (12):
      Merge branch 'ixp2xxx/removal' into next/cleanup
      Merge tag 'arm-imx-cleanup' of git://git.pengutronix.de/git/imx/linux-2.6 into next/cleanup
      Merge tag 'omap-cleanup-sparse-for-v3.5' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup
      Merge tag 'omap-cleanup-hwmod-for-v3.5' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup
      Merge tag 'v3.4-rc6' into next/cleanup
      Merge tag 'omap-cleanup-cpuidle-for-v3.5' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup
      Merge branch 'for-3.5/cleanup' of git://git.kernel.org/.../swarren/linux-tegra into next/cleanup
      Merge tag 'ep93xx-cleanup-for-3.5' of git://github.com/RyanMallon/linux-ep93xx into next/cleanup
      Merge tag 'omap-cleanup-dss-for-v3.5' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup
      Merge branch 'fixes-for-cleanup' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup
      Merge branch 'msm-core' of git://git.kernel.org/.../davidb/linux-msm into next/cleanup
      Merge branch 'next/cleanup-samsung' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup

Paul Walmsley (42):
      ARM: OMAP2+: declare file-local functions as static
      ARM: OMAP: add includes for missing prototypes
      ARM: OMAP1: OCPI: move to mach-omap1/
      ARM: OMAP1: OHCI: use platform_data fn ptr to enable OCPI bus
      ARM: OMAP2+: GPMC: resolve type-conversion warning from sparse
      ARM: OMAP: fix 'using plain integer as NULL pointer' sparse warnings
      ARM: OMAP: OCM RAM: use memset_io() when clearing SRAM
      ARM: OMAP: DMA: use constant array maximum, drop some LCD DMA code
      ARM: OMAP: USB: remove unnecessary sideways include
      ARM: OMAP1: board files: deduplicate and clean some NAND-related code
      ARM: OMAP2+: clean up some cppcheck warnings
      ARM: OMAP2+: hwmod: control all hardreset lines attached to a hwmod
      ARM: OMAP4: hwmod data: remove pseudo-hwmods associated with hardreset lines
      ARM: OMAP2+: hwmod: revise the IP block reset process
      ARM: OMAP2+: hwmod: reorganize and document the initialization process
      ARM: OMAP2+: hwmod: reorganize and document the reset and configuration process
      ARM: OMAP2+: hwmod: revise hardreset behavior
      ARM: OMAP2+: hwmod: provide a function to return the address space of the MPU RT
      ARM: OMAP2+: hwmod: add omap_hwmod_get_resource_byname()
      ARM: OMAP2+: timer: use a proper interface to get hwmod data
      ARM: OMAP2/3: hwmod data: update old names
      ARM: OMAP3: hwmod data: fix interfaces for the MMC hwmods
      ARM: OMAP3: hwmod data: add DSS->L3 interconnect for 3430ES1
      ARM: OMAP3: hwmod data: GPTIMER12 is attached to a separate interconnect
      ARM: OMAP4: hwmod data: remove bandgap hwmod
      ARM: OMAP4: hwmod data: add OCP_USER_DSP; mark omap44xx_dsp__iva appropriately
      ARM: OMAP4: hwmod data: uncomment some "excluded" hwmods
      ARM: OMAP2+: hwmod: extend OCP_* register offsets from 16 to 32 bits
      ARM: OMAP2+: hwmod: add _find_mpu_rt_port()
      ARM: OMAP2+: hwmod: add function to iterate over struct omap_hwmod_ocp_if
      ARM: OMAP2+: hwmod: consolidate finding the MPU port index and storing it
      ARM: OMAP2+: hwmod: add support for link registration
      ARM: OMAP2+: hwmod data: convert to link registration
      ARM: OMAP: hwmod: remove code support for direct hwmod registration
      ARM: OMAP2+: hwmod data: remove forward declarations, reorganize
      ARM: OMAP2xxx: hwmod data: share common hwmods between OMAP2420 and OMAP2430
      ARM: OMAP2xxx: hwmod data: share common interface data
      ARM: OMAP3: hwmod data: fix IVA interface clock
      ARM: OMAP3: hwmod data: add IVA hard reset lines, main clock, clockdomain
      ARM: OMAP2xxx: hwmod data: start to fix the IVA1, IVA2 and DSP
      ARM: OMAP1: USB: fix ocpi_enable compile problem on non-1610 builds
      ARM: OMAP: OTG integration: fix compiler warning

Rob Herring (1):
      ARM: remove ixp23xx and ixp2000 platforms

Ryan Mallon (1):
      Fix build breakage in ep93xx-core

Stephen Boyd (2):
      ARM: msm: Drop useless teq from DEBUG_LL support
      ARM: msm: fix compilation flags for MSM_SCM (part 2)

Thomas Abraham (1):
      ARM: SAMSUNG: remove all uses of clk_type member in sdhci platform data

Tomi Valkeinen (6):
      OMAPDSS: panel-dvi: add PD gpio handling
      OMAP: board-files: remove custom PD GPIO handling for DVI output
      OMAPDSS: TFP410: rename dvi -> tfp410
      OMAPDSS: TFP410: rename dvi files to tfp410
      OMAPDSS: Taal: move reset gpio handling to taal driver
      OMAPDSS: DSI: implement generic DSI pin config

Tony Lindgren (4):
      Merge tag 'omap-cleanup-a2-for-3.5' of git://git.kernel.org/.../pjw/omap-pending into cleanup-sparse
      Merge tag 'omap-cleanup-b-for-3.5' of git://git.kernel.org/.../pjw/omap-pending into cleanup-hwmod
      Merge branch 'for_3.5/cleanup/omap-cpuidle' of git://git.kernel.org/.../khilman/linux-omap-pm into cleanup-cpuidle
      Merge branch 'for-l-o-3.5' of git://gitorious.org/linux-omap-dss2/linux into cleanup-dss

Tushar Behera (32):
      ARM: SAMSUNG: Use common macro to define resources on devs.c
      ARM: EXYNOS: Use common macro to define resources on dev-ahci.c
      ARM: EXYNOS: Use common macro to define resources on dev-audio.c
      ARM: EXYNOS: Use common macro to define resources on mach-armlex4210.c
      ARM: EXYNOS: Use common macro to define resources on mach-smdkv310.c
      ARM: S3C24XX: Use common macro to define resources on bast-ide.c
      ARM: S3C24XX: Use common macro to define resources on mach-amlm5900.c
      ARM: S3C24XX: Use common macro to define resources on mach-anubis.c
      ARM: S3C24XX: Use common macro to define resources on mach-at2440evb.c
      ARM: S3C24XX: Use common macro to define resources on mach-bast.c
      ARM: S3C24XX: Use common macro to define resources on mach-gta02.c
      ARM: S3C24XX: Use common macro to define resources on mach-h1940.c
      ARM: S3C24XX: Use common macro to define resources on mach-mini2440.c
      ARM: S3C24XX: Use common macro to define resources on mach-nexcoder.c
      ARM: S3C24XX: Use common macro to define resources on mach-otom.c
      ARM: S3C24XX: Use common macro to define resources on mach-rx1950.c
      ARM: S3C24XX: Use common macro to define resources on mach-tct_hammer.c
      ARM: S3C24XX: Use common macro to define resources on mach-vr1000.c
      ARM: S3C24XX: Use common macro to define resources on simtec-nor.c
      ARM: S3C64XX: Use common macro to define resources on dev-audio.c
      ARM: S3C64XX: Use common macro to define resources on dev-uart.c
      ARM: S3C64XX: Use common macro to define resources on mach-anw6410.c
      ARM: S3C64XX: Use common macro to define resources on mach-crag6410.c
      ARM: S3C64XX: Use common macro to define resources on mach-mini6410.c
      ARM: S3C64XX: Use common macro to define resources on mach-real6410.c
      ARM: S3C64XX: Use common macro to define resources on mach-smdk6410.c
      ARM: S5P64X0: Use common macro to define resources on dev-audio.c
      ARM: S5PC100: Use common macro to define resources on dev-audio.c
      ARM: S5PV210: Use common macro to define resources on dev-audio.c
      ARM: S5PV210: Use common macro to define resources on mach-smdkv210.c
      ARM: S3C24XX: Use common macro to define resources on mach-osiris.c
      ARM: S3C24XX: Use common macro to define resources on mach-qt2410.c

Uwe Kleine-König (2):
      ARM: imx/mx21ads: remove unneeded cast
      ARM: imx/eukrea_mbimx27-baseboard: fix typo in error message


 Documentation/arm/00-INDEX                      |    2 -
 Documentation/arm/IXP2000                       |   69 -
 MAINTAINERS                                     |   17 -
 arch/arm/Kconfig                                |   34 +-
 arch/arm/Makefile                               |    2 -
 arch/arm/boot/compressed/head-xscale.S          |    7 -
 arch/arm/common/Makefile                        |    2 -
 arch/arm/common/uengine.c                       |  507 --
 arch/arm/configs/at91_dt_defconfig              |  196 +
 arch/arm/configs/at91rm9200_defconfig           |    1 +
 arch/arm/configs/ixp2000_defconfig              |   99 -
 arch/arm/configs/ixp23xx_defconfig              |  105 -
 arch/arm/include/asm/hardware/cs89712.h         |   49 -
 arch/arm/include/asm/hardware/ep7211.h          |   40 -
 arch/arm/include/asm/hardware/ep7212.h          |   83 -
 arch/arm/include/asm/hardware/uengine.h         |   62 -
 arch/arm/mach-at91/Kconfig                      |  186 +-
 arch/arm/mach-at91/Makefile                     |   26 +-
 arch/arm/mach-at91/at91rm9200.c                 |   12 -
 arch/arm/mach-at91/at91rm9200_devices.c         |   12 -
 arch/arm/mach-at91/at91sam9260.c                |   12 -
 arch/arm/mach-at91/at91sam9260_devices.c        |   12 -
 arch/arm/mach-at91/at91sam9261.c                |   12 -
 arch/arm/mach-at91/at91sam9261_devices.c        |   12 -
 arch/arm/mach-at91/at91sam9263.c                |   12 -
 arch/arm/mach-at91/at91sam9263_devices.c        |   12 -
 arch/arm/mach-at91/at91sam9g45.c                |   12 -
 arch/arm/mach-at91/at91sam9g45_devices.c        |   12 -
 arch/arm/mach-at91/at91sam9rl.c                 |   12 -
 arch/arm/mach-at91/at91sam9rl_devices.c         |   12 -
 arch/arm/mach-at91/board-1arm.c                 |   24 +-
 arch/arm/mach-at91/board-afeb-9260v1.c          |   28 +-
 arch/arm/mach-at91/board-cam60.c                |    8 +-
 arch/arm/mach-at91/board-carmeva.c              |   18 +-
 arch/arm/mach-at91/board-cpu9krea.c             |   52 +-
 arch/arm/mach-at91/board-cpuat91.c              |   40 +-
 arch/arm/mach-at91/board-csb337.c               |   13 +-
 arch/arm/mach-at91/board-csb637.c               |    8 +-
 arch/arm/mach-at91/board-dt.c                   |    8 +-
 arch/arm/mach-at91/board-eb9200.c               |   24 +-
 arch/arm/mach-at91/board-ecbat91.c              |   20 +-
 arch/arm/mach-at91/board-eco920.c               |   13 +-
 arch/arm/mach-at91/board-flexibity.c            |    8 +-
 arch/arm/mach-at91/board-foxg20.c               |   71 +-
 arch/arm/mach-at91/board-gsia18s.c              |   63 +-
 arch/arm/mach-at91/board-kafa.c                 |   20 +-
 arch/arm/mach-at91/board-kb9202.c               |   32 +-
 arch/arm/mach-at91/board-neocore926.c           |   14 +-
 arch/arm/mach-at91/board-pcontrol-g20.c         |   21 +-
 arch/arm/mach-at91/board-picotux200.c           |   18 +-
 arch/arm/mach-at91/board-qil-a9260.c            |   31 +-
 arch/arm/mach-at91/board-rm9200dk.c             |   24 +-
 arch/arm/mach-at91/board-rm9200ek.c             |   24 +-
 arch/arm/mach-at91/board-rsi-ews.c              |   36 +-
 arch/arm/mach-at91/board-sam9-l9260.c           |   30 +-
 arch/arm/mach-at91/board-sam9260ek.c            |   24 +-
 arch/arm/mach-at91/board-sam9261ek.c            |   14 +-
 arch/arm/mach-at91/board-sam9263ek.c            |   14 +-
 arch/arm/mach-at91/board-sam9g20ek.c            |   24 +-
 arch/arm/mach-at91/board-sam9m10g45ek.c         |   16 +-
 arch/arm/mach-at91/board-sam9rlek.c             |   14 +-
 arch/arm/mach-at91/board-snapper9260.c          |   18 +-
 arch/arm/mach-at91/board-stamp9g20.c            |   64 +-
 arch/arm/mach-at91/board-usb-a926x.c            |    8 +-
 arch/arm/mach-at91/board-yl-9200.c              |   36 +-
 arch/arm/mach-at91/cpuidle.c                    |    8 +-
 arch/arm/mach-at91/generic.h                    |   11 -
 arch/arm/mach-at91/include/mach/at91rm9200.h    |    5 -
 arch/arm/mach-at91/include/mach/at91sam9260.h   |    7 -
 arch/arm/mach-at91/include/mach/at91sam9261.h   |    4 -
 arch/arm/mach-at91/include/mach/at91sam9263.h   |    4 -
 arch/arm/mach-at91/include/mach/at91sam9g45.h   |    5 -
 arch/arm/mach-at91/include/mach/at91sam9rl.h    |    5 -
 arch/arm/mach-at91/include/mach/at91sam9x5.h    |    8 -
 arch/arm/mach-at91/include/mach/board.h         |    1 -
 arch/arm/mach-at91/include/mach/cpu.h           |   28 +-
 arch/arm/mach-at91/include/mach/hardware.h      |   16 +-
 arch/arm/mach-at91/include/mach/uncompress.h    |  178 +-
 arch/arm/mach-at91/pm.c                         |   12 +-
 arch/arm/mach-at91/pm.h                         |   15 +-
 arch/arm/mach-at91/pm_slowclock.S               |    2 +-
 arch/arm/mach-at91/soc.h                        |   14 +-
 arch/arm/mach-clps711x/Kconfig                  |   21 +-
 arch/arm/mach-clps711x/common.c                 |   17 +-
 .../include/mach/clps711x.h}                    |  130 +-
 .../mach-clps711x/include/mach/debug-macro.S    |    5 +-
 .../mach-clps711x/include/mach/entry-macro.S    |    3 +-
 arch/arm/mach-clps711x/include/mach/hardware.h  |   59 +-
 arch/arm/mach-clps711x/include/mach/irqs.h      |    5 +-
 arch/arm/mach-clps711x/include/mach/time.h      |   49 -
 .../arm/mach-clps711x/include/mach/uncompress.h |   21 +-
 arch/arm/mach-clps711x/p720t-leds.c             |    3 -
 arch/arm/mach-dove/common.c                     |    2 +-
 arch/arm/mach-dove/mpp.c                        |    8 +-
 arch/arm/mach-ep93xx/Kconfig                    |    5 +
 arch/arm/mach-ep93xx/core.c                     |  110 +-
 arch/arm/mach-exynos/cpuidle.c                  |   53 +-
 arch/arm/mach-exynos/dev-ahci.c                 |   12 +-
 arch/arm/mach-exynos/dev-audio.c                |  156 +-
 arch/arm/mach-exynos/mach-armlex4210.c          |   16 +-
 arch/arm/mach-exynos/mach-nuri.c                |    3 -
 arch/arm/mach-exynos/mach-origen.c              |    2 -
 arch/arm/mach-exynos/mach-smdk4x12.c            |    2 -
 arch/arm/mach-exynos/mach-smdkv310.c            |   17 +-
 arch/arm/mach-exynos/mach-universal_c210.c      |    2 -
 arch/arm/mach-imx/Kconfig                       |    2 +
 arch/arm/mach-imx/eukrea_mbimx27-baseboard.c    |    2 +-
 arch/arm/mach-imx/mach-cpuimx35.c               |    2 +-
 arch/arm/mach-imx/mach-mx1ads.c                 |    2 +-
 arch/arm/mach-imx/mach-mx21ads.c                |    3 +-
 arch/arm/mach-imx/mach-mx31lite.c               |    2 +-
 arch/arm/mach-imx/mach-mx31moboard.c            |    2 +-
 arch/arm/mach-imx/mach-mx35_3ds.c               |    2 +-
 arch/arm/mach-imx/mach-mx51_efikamx.c           |    3 +-
 arch/arm/mach-imx/mach-mx51_efikasb.c           |    2 +-
 arch/arm/mach-imx/mach-pcm037.c                 |    2 +-
 arch/arm/mach-imx/mach-pcm043.c                 |    2 +-
 arch/arm/mach-imx/mach-vpr200.c                 |    2 +-
 arch/arm/mach-ixp2000/Kconfig                   |   72 -
 arch/arm/mach-ixp2000/Makefile                  |   14 -
 arch/arm/mach-ixp2000/Makefile.boot             |    3 -
 arch/arm/mach-ixp2000/core.c                    |  520 --
 arch/arm/mach-ixp2000/enp2611.c                 |  258 -
 .../arm/mach-ixp2000/include/mach/debug-macro.S |   25 -
 arch/arm/mach-ixp2000/include/mach/enp2611.h    |   46 -
 .../arm/mach-ixp2000/include/mach/entry-macro.S |   54 -
 .../mach-ixp2000/include/mach/gpio-ixp2000.h    |   48 -
 arch/arm/mach-ixp2000/include/mach/hardware.h   |   36 -
 arch/arm/mach-ixp2000/include/mach/io.h         |  133 -
 arch/arm/mach-ixp2000/include/mach/irqs.h       |  207 -
 arch/arm/mach-ixp2000/include/mach/ixdp2x00.h   |   92 -
 arch/arm/mach-ixp2000/include/mach/ixdp2x01.h   |   57 -
 .../mach-ixp2000/include/mach/ixp2000-regs.h    |  451 --
 arch/arm/mach-ixp2000/include/mach/memory.h     |   31 -
 arch/arm/mach-ixp2000/include/mach/platform.h   |  153 -
 arch/arm/mach-ixp2000/include/mach/timex.h      |   13 -
 arch/arm/mach-ixp2000/include/mach/uncompress.h |   47 -
 arch/arm/mach-ixp2000/ixdp2400.c                |  180 -
 arch/arm/mach-ixp2000/ixdp2800.c                |  295 -
 arch/arm/mach-ixp2000/ixdp2x00.c                |  306 --
 arch/arm/mach-ixp2000/ixdp2x01.c                |  483 --
 arch/arm/mach-ixp2000/pci.c                     |  246 -
 arch/arm/mach-ixp23xx/Kconfig                   |   25 -
 arch/arm/mach-ixp23xx/Makefile                  |   11 -
 arch/arm/mach-ixp23xx/Makefile.boot             |    2 -
 arch/arm/mach-ixp23xx/core.c                    |  455 --
 arch/arm/mach-ixp23xx/espresso.c                |   93 -
 .../arm/mach-ixp23xx/include/mach/debug-macro.S |   25 -
 .../arm/mach-ixp23xx/include/mach/entry-macro.S |   31 -
 arch/arm/mach-ixp23xx/include/mach/hardware.h   |   32 -
 arch/arm/mach-ixp23xx/include/mach/io.h         |   22 -
 arch/arm/mach-ixp23xx/include/mach/irqs.h       |  223 -
 arch/arm/mach-ixp23xx/include/mach/ixdp2351.h   |   89 -
 arch/arm/mach-ixp23xx/include/mach/ixp23xx.h    |  298 -
 arch/arm/mach-ixp23xx/include/mach/memory.h     |   34 -
 arch/arm/mach-ixp23xx/include/mach/platform.h   |   58 -
 arch/arm/mach-ixp23xx/include/mach/time.h       |    3 -
 arch/arm/mach-ixp23xx/include/mach/timex.h      |    7 -
 arch/arm/mach-ixp23xx/include/mach/uncompress.h |   40 -
 arch/arm/mach-ixp23xx/ixdp2351.c                |  347 --
 arch/arm/mach-ixp23xx/pci.c                     |  288 -
 arch/arm/mach-ixp23xx/roadrunner.c              |  180 -
 arch/arm/mach-msm/board-msm7x30.c               |    1 -
 arch/arm/mach-msm/board-qsd8x50.c               |    1 -
 arch/arm/mach-msm/include/mach/debug-macro.S    |    3 +-
 arch/arm/mach-msm/scm.c                         |    3 +
 arch/arm/mach-omap1/Makefile                    |   13 +-
 arch/arm/mach-omap1/ams-delta-fiq.c             |    2 +-
 arch/arm/mach-omap1/board-fsample.c             |   16 +-
 arch/arm/mach-omap1/board-h2.c                  |   17 +-
 arch/arm/mach-omap1/board-h3.c                  |   16 +-
 arch/arm/mach-omap1/board-nand.c                |   37 +
 arch/arm/mach-omap1/board-palmz71.c             |    4 +-
 arch/arm/mach-omap1/board-perseus2.c            |   16 +-
 arch/arm/mach-omap1/clock.c                     |    3 +-
 arch/arm/mach-omap1/common.h                    |   15 +-
 arch/arm/mach-omap1/fpga.c                      |    2 +-
 arch/arm/mach-omap1/id.c                        |    2 +
 arch/arm/mach-omap1/io.c                        |    3 +-
 arch/arm/mach-omap1/irq.c                       |    2 +
 arch/arm/mach-omap1/lcd_dma.c                   |    7 +-
 arch/arm/{plat-omap => mach-omap1}/ocpi.c       |    7 +-
 arch/arm/mach-omap1/pm.c                        |    9 +-
 arch/arm/mach-omap1/reset.c                     |    2 +
 arch/arm/mach-omap1/timer.c                     |    3 +-
 arch/arm/mach-omap1/usb.c                       |    3 +
 arch/arm/mach-omap2/am35xx-emac.c               |   37 +-
 arch/arm/mach-omap2/board-3430sdp.c             |   38 +-
 arch/arm/mach-omap2/board-4430sdp.c             |   37 +-
 arch/arm/mach-omap2/board-am3517evm.c           |   25 +-
 arch/arm/mach-omap2/board-cm-t35.c              |   30 +-
 arch/arm/mach-omap2/board-devkit8000.c          |   30 +-
 arch/arm/mach-omap2/board-igep0020.c            |   32 +-
 arch/arm/mach-omap2/board-omap3beagle.c         |   37 +-
 arch/arm/mach-omap2/board-omap3evm.c            |   37 +-
 arch/arm/mach-omap2/board-omap3stalker.c        |   29 +-
 arch/arm/mach-omap2/board-omap4panda.c          |   46 +-
 arch/arm/mach-omap2/board-overo.c               |   25 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c    |    4 +-
 arch/arm/mach-omap2/board-rx51.c                |   38 +-
 arch/arm/mach-omap2/board-zoom-display.c        |    1 +
 arch/arm/mach-omap2/common.h                    |    2 -
 arch/arm/mach-omap2/cpuidle34xx.c               |  298 +-
 arch/arm/mach-omap2/cpuidle44xx.c               |  126 +-
 arch/arm/mach-omap2/devices.c                   |    7 +-
 arch/arm/mach-omap2/gpio.c                      |    2 +-
 arch/arm/mach-omap2/gpmc-onenand.c              |    3 +-
 arch/arm/mach-omap2/gpmc.c                      |    3 +-
 arch/arm/mach-omap2/hwspinlock.c                |    2 +-
 arch/arm/mach-omap2/io.c                        |    1 +
 arch/arm/mach-omap2/irq.c                       |    3 +-
 arch/arm/mach-omap2/mux.c                       |    2 +-
 arch/arm/mach-omap2/omap-secure.c               |    1 +
 arch/arm/mach-omap2/omap-wakeupgen.c            |    2 +-
 arch/arm/mach-omap2/omap_hwmod.c                | 1143 +++-
 arch/arm/mach-omap2/omap_hwmod_2420_data.c      | 1562 +-----
 arch/arm/mach-omap2/omap_hwmod_2430_data.c      | 2315 ++------
 .../omap_hwmod_2xxx_interconnect_data.c         |  266 +-
 .../mach-omap2/omap_hwmod_2xxx_ipblock_data.c   |  562 ++
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c      | 4999 ++++++++---------
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c      | 5087 ++++++++----------
 arch/arm/mach-omap2/omap_hwmod_common_data.h    |   71 +-
 arch/arm/mach-omap2/pm.h                        |   21 -
 arch/arm/mach-omap2/pm24xx.c                    |    3 -
 arch/arm/mach-omap2/pm34xx.c                    |   10 +-
 arch/arm/mach-omap2/prm_common.c                |    4 +-
 arch/arm/mach-omap2/serial.c                    |    2 +-
 arch/arm/mach-omap2/timer.c                     |   15 +-
 arch/arm/mach-omap2/usb-tusb6010.c              |    2 +-
 arch/arm/mach-orion5x/Kconfig                   |    1 -
 arch/arm/mach-orion5x/addr-map.c                |    2 +-
 arch/arm/mach-orion5x/common.c                  |    2 +-
 arch/arm/mach-orion5x/common.h                  |    1 +
 arch/arm/mach-orion5x/ts78xx-fpga.h             |    6 +-
 arch/arm/mach-orion5x/ts78xx-setup.c            |   52 +-
 arch/arm/mach-s3c24xx/bast-ide.c                |   36 +-
 arch/arm/mach-s3c24xx/mach-amlm5900.c           |    9 +-
 arch/arm/mach-s3c24xx/mach-anubis.c             |   62 +-
 arch/arm/mach-s3c24xx/mach-at2440evb.c          |   19 +-
 arch/arm/mach-s3c24xx/mach-bast.c               |   45 +-
 arch/arm/mach-s3c24xx/mach-gta02.c              |    7 +-
 arch/arm/mach-s3c24xx/mach-h1940.c              |    9 +-
 arch/arm/mach-s3c24xx/mach-mini2440.c           |   19 +-
 arch/arm/mach-s3c24xx/mach-nexcoder.c           |    6 +-
 arch/arm/mach-s3c24xx/mach-osiris.c             |   12 +-
 arch/arm/mach-s3c24xx/mach-otom.c               |    6 +-
 arch/arm/mach-s3c24xx/mach-qt2410.c             |   12 +-
 arch/arm/mach-s3c24xx/mach-rx1950.c             |    9 +-
 arch/arm/mach-s3c24xx/mach-tct_hammer.c         |    7 +-
 arch/arm/mach-s3c24xx/mach-vr1000.c             |   39 +-
 arch/arm/mach-s3c24xx/simtec-nor.c              |    6 +-
 arch/arm/mach-s3c64xx/dev-audio.c               |  120 +-
 arch/arm/mach-s3c64xx/dev-uart.c                |   48 +-
 arch/arm/mach-s3c64xx/mach-anw6410.c            |   19 +-
 arch/arm/mach-s3c64xx/mach-crag6410.c           |   26 +-
 arch/arm/mach-s3c64xx/mach-mini6410.c           |   19 +-
 arch/arm/mach-s3c64xx/mach-real6410.c           |   19 +-
 arch/arm/mach-s3c64xx/mach-smdk6410.c           |   13 +-
 arch/arm/mach-s5p64x0/dev-audio.c               |   72 +-
 arch/arm/mach-s5pc100/dev-audio.c               |  138 +-
 arch/arm/mach-s5pv210/dev-audio.c               |  156 +-
 arch/arm/mach-s5pv210/mach-smdkv210.c           |   19 +-
 arch/arm/mach-tegra/board-dt-tegra20.c          |    1 -
 arch/arm/mach-tegra/include/mach/dma.h          |    4 -
 arch/arm/mach-ux500/Kconfig                     |   25 -
 arch/arm/mach-ux500/Makefile                    |    5 -
 arch/arm/mach-ux500/board-u5500-sdi.c           |   74 -
 arch/arm/mach-ux500/board-u5500.c               |  162 -
 arch/arm/mach-ux500/cache-l2x0.c                |    4 +-
 arch/arm/mach-ux500/clock.c                     |   12 +-
 arch/arm/mach-ux500/cpu-db5500.c                |  247 -
 arch/arm/mach-ux500/cpu.c                       |    8 +-
 arch/arm/mach-ux500/devices-db5500.h            |   99 -
 arch/arm/mach-ux500/dma-db5500.c                |  137 -
 arch/arm/mach-ux500/include/mach/db5500-regs.h  |  143 -
 arch/arm/mach-ux500/include/mach/debug-macro.S  |    4 -
 arch/arm/mach-ux500/include/mach/devices.h      |    1 -
 arch/arm/mach-ux500/include/mach/hardware.h     |    1 -
 .../mach-ux500/include/mach/irqs-board-u5500.h  |   21 -
 arch/arm/mach-ux500/include/mach/irqs-db5500.h  |  113 -
 arch/arm/mach-ux500/include/mach/irqs.h         |    5 -
 arch/arm/mach-ux500/include/mach/mbox-db5500.h  |   88 -
 arch/arm/mach-ux500/include/mach/setup.h        |    6 -
 arch/arm/mach-ux500/include/mach/uncompress.h   |    7 +-
 arch/arm/mach-ux500/mbox-db5500.c               |  565 --
 arch/arm/mach-ux500/modem-irq-db5500.c          |  143 -
 arch/arm/mach-ux500/pins-db5500.h               |  620 ---
 arch/arm/mach-ux500/platsmp.c                   |    8 +-
 arch/arm/mach-ux500/ste-dma40-db5500.h          |  135 -
 arch/arm/mach-ux500/timer.c                     |   13 +-
 arch/arm/plat-mxc/include/mach/iomux-mx51.h     |   48 +-
 arch/arm/plat-mxc/include/mach/iomux-mx53.h     |    4 +-
 arch/arm/plat-omap/Makefile                     |    3 -
 arch/arm/plat-omap/common.c                     |    1 +
 arch/arm/plat-omap/dma.c                        |   13 +-
 arch/arm/plat-omap/dmtimer.c                    |    3 +-
 arch/arm/plat-omap/include/plat/board.h         |    2 +
 arch/arm/plat-omap/include/plat/common.h        |    2 +
 arch/arm/plat-omap/include/plat/dma.h           |    1 +
 arch/arm/plat-omap/include/plat/dmtimer.h       |    4 +-
 arch/arm/plat-omap/include/plat/omap_hwmod.h    |   40 +-
 arch/arm/plat-omap/omap_device.c                |    2 -
 arch/arm/plat-omap/sram.c                       |    4 +-
 arch/arm/plat-omap/usb.c                        |    8 +-
 arch/arm/plat-samsung/devs.c                    |   16 +-
 arch/arm/plat-samsung/include/plat/sdhci.h      |    7 -
 arch/arm/plat-samsung/platformdata.c            |    2 -
 drivers/char/hw_random/Kconfig                  |    2 +-
 drivers/clocksource/Kconfig                     |    2 +-
 drivers/input/touchscreen/Kconfig               |    4 +-
 drivers/mfd/Kconfig                             |   27 -
 drivers/mfd/Makefile                            |    3 -
 drivers/mfd/ab5500-core.c                       | 1439 -----
 drivers/mfd/ab5500-debugfs.c                    |  807 ---
 drivers/mfd/ab5500-debugfs.h                    |   22 -
 drivers/mfd/db5500-prcmu.c                      |  451 --
 drivers/mtd/nand/autcpu12.c                     |   10 +-
 drivers/mtd/nand/h1910.c                        |    2 +-
 drivers/net/irda/Kconfig                        |    4 +-
 drivers/rtc/Kconfig                             |    2 +-
 drivers/tty/serial/clps711x.c                   |    1 -
 drivers/usb/host/ohci-omap.c                    |    5 +-
 drivers/video/clps711xfb.c                      |    1 -
 drivers/video/omap2/displays/Kconfig            |    8 +-
 drivers/video/omap2/displays/Makefile           |    2 +-
 drivers/video/omap2/displays/panel-taal.c       |   22 +
 .../displays/{panel-dvi.c => panel-tfp410.c}    |  134 +-
 drivers/video/omap2/dss/dsi.c                   |  133 +-
 include/linux/mfd/abx500.h                      |    5 +-
 include/linux/mfd/abx500/ab5500.h               |  140 -
 include/linux/mfd/db5500-prcmu.h                |  105 -
 include/linux/mfd/dbx500-prcmu.h                |  242 +-
 include/video/omap-panel-nokia-dsi.h            |    3 +
 .../{omap-panel-dvi.h => omap-panel-tfp410.h}   |   18 +-
 include/video/omapdss.h                         |   28 +-
 335 files changed, 8951 insertions(+), 25241 deletions(-)
 delete mode 100644 Documentation/arm/IXP2000
 delete mode 100644 arch/arm/common/uengine.c
 create mode 100644 arch/arm/configs/at91_dt_defconfig
 delete mode 100644 arch/arm/configs/ixp2000_defconfig
 delete mode 100644 arch/arm/configs/ixp23xx_defconfig
 delete mode 100644 arch/arm/include/asm/hardware/cs89712.h
 delete mode 100644 arch/arm/include/asm/hardware/ep7211.h
 delete mode 100644 arch/arm/include/asm/hardware/ep7212.h
 delete mode 100644 arch/arm/include/asm/hardware/uengine.h
 rename arch/arm/{include/asm/hardware/clps7111.h => mach-clps711x/include/mach/clps711x.h} (59%)
 delete mode 100644 arch/arm/mach-clps711x/include/mach/time.h
 delete mode 100644 arch/arm/mach-ixp2000/Kconfig
 delete mode 100644 arch/arm/mach-ixp2000/Makefile
 delete mode 100644 arch/arm/mach-ixp2000/Makefile.boot
 delete mode 100644 arch/arm/mach-ixp2000/core.c
 delete mode 100644 arch/arm/mach-ixp2000/enp2611.c
 delete mode 100644 arch/arm/mach-ixp2000/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-ixp2000/include/mach/enp2611.h
 delete mode 100644 arch/arm/mach-ixp2000/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-ixp2000/include/mach/gpio-ixp2000.h
 delete mode 100644 arch/arm/mach-ixp2000/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-ixp2000/include/mach/io.h
 delete mode 100644 arch/arm/mach-ixp2000/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-ixp2000/include/mach/ixdp2x00.h
 delete mode 100644 arch/arm/mach-ixp2000/include/mach/ixdp2x01.h
 delete mode 100644 arch/arm/mach-ixp2000/include/mach/ixp2000-regs.h
 delete mode 100644 arch/arm/mach-ixp2000/include/mach/memory.h
 delete mode 100644 arch/arm/mach-ixp2000/include/mach/platform.h
 delete mode 100644 arch/arm/mach-ixp2000/include/mach/timex.h
 delete mode 100644 arch/arm/mach-ixp2000/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-ixp2000/ixdp2400.c
 delete mode 100644 arch/arm/mach-ixp2000/ixdp2800.c
 delete mode 100644 arch/arm/mach-ixp2000/ixdp2x00.c
 delete mode 100644 arch/arm/mach-ixp2000/ixdp2x01.c
 delete mode 100644 arch/arm/mach-ixp2000/pci.c
 delete mode 100644 arch/arm/mach-ixp23xx/Kconfig
 delete mode 100644 arch/arm/mach-ixp23xx/Makefile
 delete mode 100644 arch/arm/mach-ixp23xx/Makefile.boot
 delete mode 100644 arch/arm/mach-ixp23xx/core.c
 delete mode 100644 arch/arm/mach-ixp23xx/espresso.c
 delete mode 100644 arch/arm/mach-ixp23xx/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-ixp23xx/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-ixp23xx/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-ixp23xx/include/mach/io.h
 delete mode 100644 arch/arm/mach-ixp23xx/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-ixp23xx/include/mach/ixdp2351.h
 delete mode 100644 arch/arm/mach-ixp23xx/include/mach/ixp23xx.h
 delete mode 100644 arch/arm/mach-ixp23xx/include/mach/memory.h
 delete mode 100644 arch/arm/mach-ixp23xx/include/mach/platform.h
 delete mode 100644 arch/arm/mach-ixp23xx/include/mach/time.h
 delete mode 100644 arch/arm/mach-ixp23xx/include/mach/timex.h
 delete mode 100644 arch/arm/mach-ixp23xx/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-ixp23xx/ixdp2351.c
 delete mode 100644 arch/arm/mach-ixp23xx/pci.c
 delete mode 100644 arch/arm/mach-ixp23xx/roadrunner.c
 create mode 100644 arch/arm/mach-omap1/board-nand.c
 rename arch/arm/{plat-omap => mach-omap1}/ocpi.c (93%)
 delete mode 100644 arch/arm/mach-ux500/board-u5500-sdi.c
 delete mode 100644 arch/arm/mach-ux500/board-u5500.c
 delete mode 100644 arch/arm/mach-ux500/cpu-db5500.c
 delete mode 100644 arch/arm/mach-ux500/devices-db5500.h
 delete mode 100644 arch/arm/mach-ux500/dma-db5500.c
 delete mode 100644 arch/arm/mach-ux500/include/mach/db5500-regs.h
 delete mode 100644 arch/arm/mach-ux500/include/mach/irqs-board-u5500.h
 delete mode 100644 arch/arm/mach-ux500/include/mach/irqs-db5500.h
 delete mode 100644 arch/arm/mach-ux500/include/mach/mbox-db5500.h
 delete mode 100644 arch/arm/mach-ux500/mbox-db5500.c
 delete mode 100644 arch/arm/mach-ux500/modem-irq-db5500.c
 delete mode 100644 arch/arm/mach-ux500/pins-db5500.h
 delete mode 100644 arch/arm/mach-ux500/ste-dma40-db5500.h
 delete mode 100644 drivers/mfd/ab5500-core.c
 delete mode 100644 drivers/mfd/ab5500-debugfs.c
 delete mode 100644 drivers/mfd/ab5500-debugfs.h
 delete mode 100644 drivers/mfd/db5500-prcmu.c
 rename drivers/video/omap2/displays/{panel-dvi.c => panel-tfp410.c} (63%)
 delete mode 100644 include/linux/mfd/abx500/ab5500.h
 delete mode 100644 include/linux/mfd/db5500-prcmu.h
 rename include/video/{omap-panel-dvi.h => omap-panel-tfp410.h} (63%)
