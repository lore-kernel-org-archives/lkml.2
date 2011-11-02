Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932922Ab1KBCYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 22:24:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57091 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab1KBCXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 22:23:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL 0/13 (12)] arm-soc updates
Date: Wed, 2 Nov 2011 03:22:46 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-Id: <201111020322.46469.arnd@arndb.de>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:1a7m9I878+D+2+ePQtoMnTfg6ZC5tKNGOuE4Z4ReSIb
 jAyGWVRvwmDv20pAbxAYsdMIFMSugfaaWvDS+xmYf0E+W716qr
 dkVKlxGQWwsAvzOs4izi4Wsd3kOzNNYyfZiBLdSMAsX7g2XVS3
 07arDy7VkaAx9gXUPVVybMkWFPw2QACMYWZ3UA0ob9EDuZ4jgf
 zUAun2D1p5jcq7KLkn3LlxvSfCJ4l0foJ6zJt+vU1fTngaPrZb
 mOOJhCAquKe4bYaWiuRHFS0z3v2I+0ozGqQKSQ+qlWiMvXM+0U
 oufslL9Js8Hc3dBHfHyhC7YYPM/ze5nXsan7rQJ5xqFVNiqwkO
 8cMXYP5w/tjSdgW2Qx5w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I have a series of 12 pull requests for the arm-soc tree, a total of 409
non-merge commits. Feel free to pull either the for-linus branch that contains
the lot with all conflicts resolved or the individual pull requests.
Basically all of this was in linux-next before the merge window, but
I had to wait for some dependencies to go in first and did not get around
to make sure that it still works fine during LinuxCon. While each branch
should be bisectable now you can pull them independently, I sometimes had
to pull in stuff from the earlier series into the later ones to resolve
conflicts between them.

There were also some excessive conflicts with branches that you have already
pulled during the last week, so I pulled in those branches where
applicable. The remaining conflicts that you see are typically ones that
are easy to resolve and are caused by more obscure patches already upstream.

The two last series (next/dt and next/soc) had to be rebased on short notice
because they were originally based on an older version of the arm tree that
was not meant to be used as a base and got changed. You might want to hold
off on those in order to give them slightly more exposure in linux-next.
If you do that, I will resubmit them by the end of this week.

My original plan was to send another big cleanup and feature submission
for the samsung subarchitectures along with the ones in these series,
but it turned out that they depend on other patches in the dmaengine
tree that you have not yet pulled. Consequently, I ended up with only
12 pull requests instead of the 13 I planned earlier. If you want to take
a look, the remaining patches are in the for-next branch of the same tree.
I'll send them as soon as the dmaengine tree shows up in mainline.

	Arnd

The following changes since commit 094803e0aab3fe75bbf8202a8f4b5280eaade375:

  Merge branch 'akpm' (Andrew's incoming) (2011-10-31 17:46:07 -0700)

are available in the git repository at:

  git://git.linaro.org/people/arnd/arm-soc.git for-linus

Abhilash Kesavan (1):
      ARM: S5PV210: Remove unnecessary symbol for PM

Ajay Kumar (1):
      ARM: SAMSUNG: Fix mask value for S5P64X0 CPU IDs

Arnaud Patard (8):
      imx51: add pata device
      imx51: add pata clock
      imx: efika: Enable pata.
      MX5: fix clock usage
      Fix pata imx resource
      efika: Configure esdhc cd/wp on efika mx/sb
      ARM: mx5: fix clock usage for suspend
      ARM: mx5: fix clock usage for suspend

Arnd Bergmann (85):
      Merge branches 'imx/cleanup' and 'stericsson/cleanup' of git+ssh://master.kernel.org/.../arm/linux-arm-soc into next/cleanup
      Merge branches 'tegra/board' and 'at91/board' into next/board
      Merge branch 'omap/cleanup' into next/cleanup
      Merge branch 'samsung/cleanup' into next/cleanup
      Merge branch 'samsung/board' into next/board
      Merge branch 'stericsson/cleanup' into next/cleanup
      Merge branch 'davinci/cleanup' into next/cleanup
      Merge branch 'tegra/fixes' into next/fixes
      Merge branch 'for_3.2/voltage-cleanup' of git://gitorious.org/khilman/linux-omap-pm into omap/voltage
      Merge branch 'ixp/board' into next/board
      Merge branch 'omap/cleanup' into next/cleanup
      ARM: omap: use __devexit_p in dmtimer driver
      Merge branch 'samsung/board' into next/board
      Merge branch 'omap/fixes' into fixes
      Merge branch 'imx/cleanup' into next/cleanup
      Merge branch 'imx/cleanup' into imx/devel
      Merge branches 'sirf/devel', 'at91/devel', 'imx/devel' and 'davinci/devel' into next/devel
      Merge branch 'sirf/cleanup' into next/cleanup
      ARM: pxa: make zylonite_pxa*_init declaration match code
      ARM: pxa: export symbols from pxa3xx-ulpi
      ARM: pxa: allow selecting just one of TREO680/CENTRO
      ARM: pxa: CPU_FREQ_TABLE is needed for CPU_FREQ
      ARM: pxa: pxa95x is incompatible with earlier pxa
      ARM: pxa: select POWER_SUPPLY on raumfeld
      ARM: pxa: centro and treo680 need palm27x
      ARM: pxa: sharpsl pm needs SPI
      ARM: pxa: use correct __iomem annotations
      Merge branch 'depends/rmk/devel-stable' into next/cleanup
      Merge branch 'imx/fixes' into next/fixes
      Merge branch 'stericsson/fixes' into next/cleanup
      Merge branch 'fixes' into next/fixes
      Merge branch 'ep93xx/board' into next/board
      Merge branch 'tegra/cleanup' into next/cleanup
      Merge branch 'imx-features-for-arnd' of git://git.pengutronix.de/git/imx/linux-2.6 into imx/devel
      Merge branches 'imx/pata' and 'imx/sata' into next/driver
      Merge branch 'imx/board' into next/board
      Merge branch 'imx/devel' into next/devel
      Merge branches 'cross-platform/debug_ll' and 'cross-platform/cpu-mapping' into next/cross-platform
      Merge branch 'depends/rmk/debug' into tmp
      Merge branch 'depends/rmk/smp' into tmp
      Merge branch 'tegra/devel' into next/devel
      Merge branch 'at91/trng' into next/driver
      Merge branch 'imx-cleanups-for-arnd' of git://git.pengutronix.de/git/imx/linux-2.6 into imx/cleanup
      Merge branch 'imx/cleanup' into next/cleanup
      Merge branch 'depends/rmk/gpio' into next/board
      Merge branch 'imx/fixes' into next/fixes
      Merge branch 'pxa/fixes' into next/fixes
      Merge branches 'msm/dt', 'imx/dt' and 'at91/dt' into next/dt
      Merge branches 'depends/rmk/io', 'depends/rmk/l2x0' and 'depends/rmk/gpio' into highbank/soc
      Merge branch 'omap/voltage' into next/pm
      Merge branches 'stericsson/timer' and 'omap/dmtimer' into next/timer
      Merge branch 'omap/dt' into next/dt
      Merge branch 'dt/gic' into next/dt
      Merge branch 'depends/rmk/debug' into highbank/soc
      Merge branch 'dt/gic' into highbank/soc
      Merge branch 'depends/rmk/devel-stable' into imx/imx6q
      Merge branch 'dt/gic' into imx/imx6q
      Merge branch 'imx/devel' into imx/imx6q
      Merge branch 'cross-platform/debug_ll' into imx/imx6q
      Merge branch 'depends/rmk/gpio' into next/fixes
      Merge branch 'depends/rmk/memory_h' into next/fixes
      Merge branch 'depends/omap2_dss' into next/cleanup
      Merge branch 'next/fixes' into next/cleanup
      Merge branch 'stericsson/cleanup' into next/timer
      Merge branch 'depends/rmk/gpio' into next/devel
      Merge branch 'depends/rmk/devel-stable' into next/board
      Merge branch 'depends/rmk/memory_h' into next/fixes
      ARM: gic: use module.h instead of export.h
      Merge branch 'next/fixes' into for-next
      Merge branch 'next/cleanup' into for-next
      Merge branch 'next/driver' into for-next
      Merge branch 'next/timer' into for-next
      Merge branch 'next/pm' into for-next
      Merge branch 'next/deletion' into for-next
      Merge branch 'next/devel' into for-next
      Merge branch 'next/board' into for-next
      Merge branch 'next/cross-platform' into for-next
      Merge branch 'depends/rmk/memory_h' into next/cleanup2
      Merge branch 'next/cleanup2' into for-linus
      Merge branch 'imx/devel' into next/dt
      Merge branch 'next/dt' into for-linus
      Merge branch 'highbank/soc' into next/soc
      Merge branch 'picoxcell/soc' into next/soc
      Merge branch 'imx/imx6q' into next/soc
      Merge branch 'next/soc' into for-linus

Axel Lin (1):
      ARM: pxa/cm-x300: properly set bt_reset pin

Banajit Goswami (1):
      ARM: SAMSUNG: Consolidate common function to set SDHCI plat data

Barry Song (13):
      ARM: mach-ux500: add explicit cpu_relax() for busy wait loop
      ARM: CSR: add lost Resource Sharing Control(RSC) node in dts
      ARM: CSR: extend the compatibility of gpio controller to pinmux in dts
      ARM: CSR: IRQ: add simple irq_domain so that hw irq can map to Linux
      ARM: CSR: PM: save/restore timer status in suspend cycle
      ARM: CSR: PM: save/restore irq status in suspend cycle
      ARM: CSR: timer: do not initialise statics to 0 or NULL
      ARM: CSR: timer: space required before the open parenthesis '('
      ARM: CSR: prima2: fix trailing whitespace
      ARM: CSR: clock: Fix indentation
      Merge branch 'l2x0' of rmk tree into prima2-l2x0
      ARM: CSR: call l2x0_of_init to init L2 cache of SiRFprimaII
      ARM: CSR: PM: use outer_resume to resume L2 cache

Benoit Cousson (20):
      OMAP4: powerdomain data: add voltage domains
      ARM: OMAP2+: Add SoC specific map_io functions
      ARM: OMAP3: beagle-board: Use the omap_hwmod_name_get_dev API
      ARM: OMAP2+: pm: Use hwmod name instead of dev pointer
      ARM: OMAP2+: pm: Remove static devices variable for mpu, dsp, iva and l3 PM
      ARM: OMAP: omap_device: Create a default omap_device_pm_latency
      ARM: OMAP2+: devices: Remove all omap_device_pm_latency structures
      of: Add helpers to get one string in multiple strings property
      ARM: OMAP: omap_device: Add omap_device_[alloc|delete] for DT integration
      ARM: OMAP: omap_device: Add a method to build an omap_device from a DT node
      arm/dts: Add initial device tree support for OMAP4 SoC
      arm/dts: Add support for OMAP4 PandaBoard
      arm/dts: Add support for OMAP4 SDP board
      arm/dts: Add initial device tree support for OMAP3 SoC
      arm/dts: Add support for OMAP3 Beagle board
      ARM: OMAP2+: board-generic: Add DT support to generic board
      ARM: OMAP2+: board-generic: Add i2c static init
      ARM: OMAP2+: l3-noc: Add support for device-tree
      arm/dts: OMAP4: Add a main ocp entry bound to l3-noc driver
      arm/dts: OMAP3+: Add mpu, dsp and iva nodes

Bjarne Steinsbo (1):
      ARM: OMAP4: Keyboard: Fix section mismatch in the board file

Changhwan Youn (7):
      ARM: EXYNOS4: Add support PPI in external GIC
      ARM: EXYNOS4: Add support MCT PPI for EXYNOS4212
      ARM: EXYNOS4: Add support new EXYNOS4412 SoC
      ARM: EXYNOS4: Add support clock for EXYNOS4412
      ARM: EXYNOS4: Add functions for gic interrupt handling
      ARM: EXYNOS4: Add MCT support for EXYNOS4412
      ARM: EXYNOS4: Add support SMDK4412 Board

David Brown (3):
      msm_serial: Use relative resources for iomem
      msm_serial: Add devicetree support
      ARM: msm: Add devicetree support for msm8660-surf

Dong Aisheng (5):
      ARM: mxs: add saif clock
      ARM: mxs: add saif device
      ARM: mxs: add sgtl5000 i2c device
      ARM: mxs: add mxs-sgtl5000 device
      ARM: mxs: correct the using of frac div for saif

Eric Miao (5):
      ARM: pxa: fix building error by palm27x_lcd_init() when FB_PXA not defined
      ARM: pxa/z2: fix building error of pxa27x_cpu_suspend() no longer available
      ARM: pxa: pxa95x/saarb depends on pxa3xx code
      ARM: pxa: make pxafb_smart_*() empty when not enabled
      ARM: mmp: rename SHEEVAD to GPLUGD

Fabio Estevam (13):
      ARM: mx50: Select IMX_HAVE_PLATFORM_FEC as done on other i.MX devices
      ARM: mxs: Remove unused header file
      ARM: imx: pwm: Add support for MX53
      ARM: imx: Add PATA resources for other i.MX processors
      ARM: imx: Add PATA clock support
      ARM: imx: Define functions for registering PATA
      ARM: mx53_loco: Add support for the accelerometer
      ARM: imx: Introduce generic function for displaying silicon revision
      ARM: mach-imx/mx25_3ds: Add FlexCAN support
      ARM: mx31pdk: Fix build by passing IMX_HAVE_PLATFORM_MXC_MMC
      ARM: mach-qong: Add watchdog support
      ARM: mach-mxs/mx28evk: Only register devices if their GPIO requests succeeded
      ARM: mxs: Consolidate mm-mx23.c and mm-mx28.c into a single file

Fredrik Svensson (1):
      mach-ux500: remove pull-pinconfig and add SPI2

Grazvydas Ignotas (1):
      OMAP: omap_device: make latency autoadjust messages debug

Hartley Sweeten (1):
      ep93xx: add support Vision EP9307 SoM

Heiko Stuebner (2):
      ARM: S3C24XX: Remove hw_addr from s3c24xx dma channel declarations
      ARM: S3C24XX: Remove s3c24xx_dma_addr definition

Hui Wang (1):
      ARM i.MX avic: convert to use generic irq chip

Ido Yariv (5):
      ARM: davinci: DA850: Add MMC/SD1 pinmux configuration
      ARM: davinci: DA850: Add GPIO pinmux configuration for wl1271
      mmc: davinci: Add support for set_power callback
      ARM: davinci: AM18x: Add wl1271/wlan support
      ARM: davinci: Explicitly set channel controllers' default queues

Jamie Iles (5):
      picoxcell: support for Picochip picoxcell devices
      picoxcell: add the DTS for pc3x2 and pc3x3 devices
      picoxcell: add the DTS for the PC7302 board
      picoxcell: remove custom ioremap implementation
      picoxcell: add a definition of VMALLOC_END

Jarkko Nikula (14):
      omap: mcbsp: Remove omap device API
      ARM: OMAP: mcbsp: Remove unused variables from platform data
      ARM: OMAP: mcbsp: Move out omap_mcbsp_register_board_cfg from plat-omap/devices.c
      ARM: OMAP: mcbsp: Implement generic register access
      ARM: OMAP: mcbsp: Make wakeup control generic
      ARM: OMAP: mcbsp: Make tranceiver configuration control register access generic
      ARM: OMAP: mcbsp: Make threshold based transfer code generic
      ARM: OMAP: mcbsp: Use per instance register cache size
      ARM: OMAP: mcbsp: Move sidetone clock management to mach-omap2/mcbsp.c
      ARM: OMAP: mcbsp: Cleanup sidetone control initialization and make it generic
      ARM: OMAP: mcbsp: Update mcbsp.h include dependencies
      ARM: OMAP: mcbsp: Move address definitions to arch/arm/mach-omap1/mcbsp.c
      ARM: OMAP: mcbsp: Start generalize omap2_mcbsp_set_clks_src
      ARM: OMAP: mcbsp: Start generalize signal muxing functions

Jason Liu (11):
      imx5: not include the unused head file
      ARM: mx25: Print silicon revision on boot
      ARM: mx27: Print silicon revision on boot
      ARM: mx31: use generic function for displaying silicon revision
      ARM: mx35: use generic function for displaying silicon revision
      ARM: mx5: use generic function for displaying silicon revision
      ARM: i.MX: initialize l2x0 at early_init time
      ARM: mx5/mm: move i.MX50 mm stuff into mm.c
      ARM: mx5/mm: Remove MX51_DEBUG related mapping
      ARM: mx5/mm: consolidate TZIC map code
      ARM: mx25: Add the missing IIM base definition

Jean-Christophe PLAGNIOL-VILLARD (3):
      at91: USB-A9G20 C01 & C11 board support
      at91: ohci-at91: always provide all the clocks
      ARM: at91: add at91sam9g20 and Calao USB A9G20 DT support

JeongHyeon Kim (1):
      ARM: EXYNOS4: Add support for ORIGEN board

Johan Hovold (2):
      OMAP2+: PM: fix typos in misc. comment and error messages
      OMAP2+: PM: clean up error messages: replace printk with pr_err.

Jonas Aaberg (4):
      ARM: ux500: Move timer code to separate file
      ARM: plat-nomadik: timer: Add support for periodic timers
      ARM: plat-nomadik: timer: Export reset functions
      ARM: ux500: Reprogram timers upon resume

Jonghwan Choi (2):
      ARM: S5P: Remove duplicate kdiv calculation
      ARM: EXYNOS4: Add support PM for EXYNOS4212

Josef Holzmayr (1):
      at91: add support for RSIs EWS board

Kevin Hilman (57):
      OMAP2+: hwmod: remove unused voltagedomain pointer
      OMAP2+: voltage: move PRCM mod offets into VC/VP structures
      OMAP2+: voltage: move prm_irqst_reg from VP into voltage domain
      OMAP2+: voltage: start towards a new voltagedomain layer
      OMAP3: voltage: rename "mpu" voltagedomain to "mpu_iva"
      OMAP3: voltagedomain data: add wakeup domain
      OMAP3+: voltage: add scalable flag to voltagedomain
      OMAP2+: powerdomain: add voltagedomain to struct powerdomain
      OMAP2: add voltage domains and connect to powerdomains
      OMAP3: powerdomain data: add voltage domains
      OMAP2+: powerdomain: add voltage domain lookup during register
      OMAP2+: voltage: keep track of powerdomains in each voltagedomain
      OMAP2+: voltage: split voltage controller (VC) code into dedicated layer
      OMAP2+: voltage: move VC into struct voltagedomain, misc. renames
      OMAP2+: voltage: enable VC bypass scale method when VC is initialized
      OMAP2+: voltage: split out voltage processor (VP) code into new layer
      OMAP2+: VC: support PMICs with separate voltage and command registers
      OMAP2+: add PRM VP functions for checking/clearing VP TX done status
      OMAP3+ VP: replace transaction done check/clear with VP ops
      OMAP2+: PRM: add register access functions for VC/VP
      OMAP3+: voltage: convert to PRM register access functions
      OMAP3+: VC: cleanup i2c slave address configuration
      OMAP3+: VC: cleanup PMIC register address configuration
      OMAP3+: VC bypass: use fields from VC struct instead of PMIC info
      OMAP3+: VC: cleanup voltage setup time configuration
      OMAP3+: VC: move on/onlp/ret/off command configuration into common init
      OMAP3+: VC: abstract out channel configuration
      OMAP3+: voltage domain: move PMIC struct from vdd_info into struct voltagedomain
      OMAP3+: VC: make I2C config programmable with PMIC-specific settings
      OMAP3+: PM: VC: handle mutant channel config for OMAP4 MPU channel
      OMAP3+: VC: use last nominal voltage setting to get current_vsel
      OMAP3+: VP: cleanup: move VP instance into voltdm, misc. renames
      OMAP3+: voltage: remove unneeded debugfs interface
      OMAP3+: VP: struct omap_vp_common: replace shift with __ffs(mask)
      OMAP3+: VP: move SoC-specific sys clock rate retreival late init
      OMAP3+: VP: move timing calculation/config into VP init
      OMAP3+: VP: create VP helper function for updating error gain
      OMAP3+: VP: remove omap_vp_runtime_data
      OMAP3+: VP: move voltage scale function pointer into struct voltagedomain
      OMAP3+: VP: update_errorgain(): return error if VP
      OMAP3+: VP: remove unused omap_vp_get_curr_volt()
      OMAP3+: VP: combine setting init voltage into common function
      OMAP3+: voltage: rename scale and reset functions using voltdm_ prefix
      OMAP3+: voltage: move/rename curr_volt from vdd_info into struct voltagedomain
      OMAP3+: voltdm: final removal of omap_vdd_info
      OMAP3+: voltage: rename omap_voltage_get_nom_volt -> voltdm_get_voltage
      OMAP3+: voltage: update nominal voltage in voltdm_scale() not VC post-scale
      OMAP2+: VC: more registers are per-channel starting with OMAP5
      OMAP: omap_device: replace debug/warning/error prints with dev_* macros
      OMAP: omap_device: remove internal functions from omap_device.h
      OMAP: omap_device: when building return platform_device instead of omap_device
      OMAP: omap_device: device register functions now take platform_device pointer
      OMAP: omap_device: _disable_idle_on_suspend() takes platform_device pointer
      OMAP: omap_device: decouple platform_device from omap_device
      OMAP3: PM: fix UART handling when using no_console_suspend
      ARM: OMAP: voltage: voltage layer present, even when CONFIG_PM=n
      ARM: 7082/1: platform_device: pdev_archdata: add omap_device pointer

Kukjin Kim (16):
      ARM: EXYNOS4: Turn the mach-smdkc210.c into mach-smdv310.c
      ARM: SAMSUNG: Add support for detecting CPU at runtime
      ARM: S5P64X0: Use soc_is_s5p64x0() to distinguish cpu at runtime
      ARM: SAMSUNG: Add support for handling of cpu revision
      ARM: EXYNOS4: Use samsung_rev() to distinguish silicon revision
      Merge branch 'next/topic-cleanup-dma' into next-samsung-cleanup
      ARM: S3C24XX: remove unused gpio codes
      Merge branch 'next/topic-cleanup-smdkv310' into next-samsung-cleanup
      Merge branch 'next/topic-cpuid-rev' into next/topic-add-exynos4212
      Merge branch 'next/topic-cleanup-smdkv310' into next/topic-add-exynos4212
      ARM: EXYNOS4: Add support new EXYNOS4212 SoC
      ARM: EXYNOS4: Add support clock for EXYNOS4212
      ARM: EXYNOS4: Add support SMDK4212 Board
      Merge branch 'next-samsung-board-v3.1' into next-samsung-board
      ARM: SAMSUNG: Move map header file into plat-samsung
      Merge branch 'next/topic-plat-samsung-1' into next-samsung-cleanup

Lauri Hintsala (1):
      ARM: mach-mxs: fix machines' initializers order

Lee Jones (1):
      mach-ux500: remove most of the ugly machine_is_*() calls

Linus Walleij (8):
      mach-u300: retire odd singlemem variant
      mach-u300: drop SEMI config option
      mach-u300: patch physoffset by default
      mach-u300: delete bogus memory mappings
      mach-u300: retire AVE device
      mach-ux500: factor out l2x0 handling code
      ARM: mach-ux500: unlock I&D l2x0 caches before init
      clocksource: fixup ux500 build problems

Marc Dietrich (5):
      ARM: tegra: paz00: add support serial port on JP1
      ARM: tegra: paz00: enable rfkill for internal wifi card
      ARM: tegra: paz00: enable wifi led
      ARM: tegra: paz00: reorder the SDHCI channel init
      ARM: tegra: paz00: add clocks required for usb operation

Mark Brown (2):
      ARM: SAMSUNG: Fix mask for S3C64xx CPU IDs
      ARM: S3C64XX: Remove unused CPU devices for Cragganmore

Martin Bogomolni (1):
      ARM: highbank: Add cpu hotplug support

Matt Burtch (1):
      ARM: i.MX28: shift frac value in _CLK_SET_RATE

Mattias Wallin (3):
      ARM: plat-nomadik: MTU sched_clock as an option
      clocksource: add DBX500 PRCMU Timer support
      ARM: ux500: add support for clocksource DBX500 PRCMU

Michael Jones (1):
      OMAP2: PM debug: remove leftover debug code

Naveen Krishna Chatradhi (1):
      ARM: SAMSUNG: Remove unnecessary duplication of plat_data on TSADC

Nico Erfurth (1):
      at91: merge board USB-A9260 and USB-A9263 together

Nicolas Ferre (3):
      ARM: at91: remove dependency for Atmel PWM driver selector in Kconfig
      ARM: at91: add defconfig for at91sam9g45 family
      ARM: at91: dt: at91sam9g45 family and board device tree files

Nicolas Pitre (1):
      ARM: mach-nuc93x: delete

Nishanth Menon (4):
      OMAP4: PM: TWL6030: fix uv to voltage for >0x39
      OMAP4: PM: TWL6030: address 0V conversions
      OMAP4: PM: TWL6030: add cmd register
      ARM: OMAP: omap_device: Add omap_device_get_by_hwmod_name

Olof Johansson (16):
      ARM: tegra: annotate IO_*_VIRT pointers
      ARM: tegra: timer: don't cast __iomem pointers
      ARM: tegra: tegra2_clocks: don't cast __iomem pointers
      ARM: tegra: tegra2_clocks: 0 -> NULL changes
      ARM: tegra: pcie: don't cast __iomem pointers
      ARM: tegra: pcie: include board.h
      ARM: tegra: pcie: 0 -> NULL changes
      ARM: tegra: tegra_init_cache should be static
      ARM: tegra: tegra_rtc_read_ms should be static
      ARM: tegra: tegra_powergate_is_powered should be static
      ARM: tegra: tegra2_clocks: don't export some tables
      ARM: tegra: dma: staticify some tables and functions
      ARM: tegra: cpu-tegra: sparse type fix
      ARM: tegra: cpu-tegra: unexport two functions
      ARM: tegra: devices.c should include devices.h
      ARM: tegra: update defconfig

Patrick Titiano (2):
      OMAP4: PM: TWL6030: fix voltage conversion formula
      OMAP4: PM: TWL6030: fix ON/RET/OFF voltages

Paul Bolle (1):
      ARM: imx: Fix typo 'MACH_MX31_3DS_MXC_NAND_USE_BBT'

Paul Fertser (1):
      plat-mxc: iomux-v3.h: implicitly enable pull-up/down when that's desired

Paul Walmsley (12):
      OMAP3: id: remove identification codes that only correspond to marketing names
      OMAP3: id: remove useless strcpy()s
      OMAP3: id: use explicit omap_revision codes for 3505/3517 ES levels
      OMAP3: id: add fallthrough warning; fix some CodingStyle issues
      OMAP3: id: remove duplicate code for testing SoC ES level
      OMAP2+: id: remove OMAP_REVBITS_* macros
      OMAP: clockdomain: split clkdm_init()
      OMAP: clockdomain code/data: remove omap_chip bitmask from struct clockdomain
      OMAP: powerdomain: split pwrdm_init() into two functions
      OMAP: powerdomain: remove omap_chip bitmasks
      OMAP2+: hwmod: remove OMAP_CHIP*
      OMAP: id: remove OMAP_CHIP declarations, code

Peter De Schrijver (3):
      arm/tegra: prepare Seaboard pinmux code for derived boards
      arm/tegra: add support for ventana pinmuxing
      arm/tegra: device tree support for ventana board

Peter Korsgaard (2):
      ARM: at91: at91sam9g45: add trng clock and platform device
      hw_random: add driver for atmel true hardware random number generator

Philippe Rétornaz (1):
      mx31moboard: Add poweroff support

Richard Cochran (1):
      ixp4xx: support omicron ixp425 based boards

Richard Zhu (4):
      AHCI Add the AHCI SATA feature on the MX53 platforms
      MX53 Enable the AHCI SATA on MX53 ARD board
      MX53 Enable the AHCI SATA on MX53 LOCO board
      MX53 Enable the AHCI SATA on MX53 SMD board

Rob Herring (12):
      Merge remote-tracking branch 'rmk/devel-stable' into HEAD
      of/irq: introduce of_irq_init
      irq: support domains with non-zero hwirq base
      ARM: gic: add irq_domain support
      ARM: gic: add OF based initialization
      ARM: gic: fix irq_alloc_descs handling for sparse irq
      ARM: l2x0: add empty l2x0_of_init
      ARM: highbank: add devicetree source
      ARM: add Highbank core platform support
      MAINTAINERS: add Calxeda Highbank ARM platform
      ARM: highbank: add SMP support
      ARM: highbank: add suspend support

Rongjun Ying (1):
      ARM: CSR: PM: add sleep entry for SiRFprimaII

Santosh Shilimkar (1):
      OMAP4: Fix the emif and dmm virtual mapping

Sascha Hauer (20):
      Merge branch 'imx-cleanup' of git://git.pengutronix.de/git/ukl/linux-2.6 into imx-cleanup
      ARM i.MX: allow to compile together ARMv4 and ARMv5 based SoCs
      ARM i.MX: allow to compile together all i.MX5 based SoCs
      ARM i.MX5: update defconfig
      ARM i.MX defconfigs: use one defconfig for all ARMv4/v5 SoCs
      ARM i.MX audmux v2: remove unnecessary ifdefs
      ARM i.MX: remove ARCH_MX* macros from Makefile
      Merge branches 'cleanups/assorted', 'cleanups/shawn-cleanup-mxc-gpio', 'cleanups/troy-cleanup-iomux-v3' and 'cleanups/ukl-mx5-dynamically-allocate-devices' into imx-cleanups-for-arnd
      Merge branches 'features/assorted', 'features/imx-cpurev', 'features/imx-pata', 'features/multisoc' and 'features/mxs' into imx-features-for-arnd
      Merge branches 'cleanups/assorted' and 'cleanups/mm-tzic' into imx-cleanup
      ARM i.MX avic: add handle_irq function
      ARM i.MX tzic: add handle_irq function
      ARM i.MX boards: use CONFIG_MULTI_IRQ_HANDLER
      ARM i.MX entry-macro.S: remove now unused code
      Merge branches 'features/assorted', 'features/imx-pata' and 'features/imx-multi-irq-v2' into imx-features
      Merge branches 'cleanups/mx3-mm-v2' and 'cleanups/mxs' into imx-cleanup
      Merge branch 'features/ahci' into for-arnd-features
      Merge branch 'features/denx-mx28' into for-arnd-features
      Merge branches 'cleanups/mxs', 'cleanups/mx3-defconfig' and 'cleanups/includes' into imx-cleanups-for-arnd
      arm/imx: merge i.MX3 and i.MX6

Shawn Guo (28):
      arm/mxc: do not use gpio_to_irq() for static initializers
      gpio/mxc: add .to_irq for gpio chip
      arm/mxc: use gpiolib helper for gpio_to_irq
      gpio/mxc: move irq_to_gpio() into gpio-mxc driver
      arm/mxc: move IMX_GPIO_NR into mach/hardware.h
      gpio/mxs: move irq_to_gpio() into gpio-mxs driver
      arm/mxs: move MXS_GPIO_NR into mach/mxs.h
      arm/imx: merge mm-imx35.c into mm-imx31.c
      arm/imx: rename mm-imx31.c to mm-imx3.c
      arm/imx: change mxc_init_l2x0() to an imx31/35 specific call
      arm/imx: remove cpu_is_xxx() from arch_idle()
      arm/imx: remove cpu_is_xxx() check from __imx_ioremap()
      arm/imx: use Kconfig choice for low-level debug UART selection
      arm/imx: remove mx31_setup_weimcs() from mx31.h
      arm/imx: explicitly includes mach/hardware.h in mach-kzm_arm11_01.c
      arm/imx: remove mx27_setup_weimcs() from mx27.h
      arm/imx: explicitly includes mach/hardware.h in pm-imx27.c
      mmc: mxcmmc: explicitly includes mach/hardware.h
      arm/mx5: add device tree support for imx53 boards
      arm/mx5: add device tree support for imx51 babbage
      arm/imx6q: add device tree source
      arm/imx6q: add core definitions and low-level debug uart
      arm/imx: add gic_handle_irq function
      arm/imx6q: add core drivers clock, gpc, mmdc and src
      arm/imx6q: add smp and cpu hotplug support
      arm/imx6q: add device tree machine support
      arm/imx6q: add suspend/resume support
      MAINTAINERS: add ARM/FREESCALE IMX6 entry

Stefano Babic (1):
      ARM: mxs: Add initial support for DENX MX28

Stephen Warren (11):
      ARM: Tegra: Harmony: Add USB device
      ARM: Tegra: Seaboard board updates for audio
      ARM: Tegra: Seaboard: Add USB devices
      ARM: Tegra: Force PORT_TEGRA as the UART type
      arm/dt: Tegra: Add support-8bit to SDHCI nodes
      arm/tegra: Prep boards for gpio/pinmux conversion to pdevs
      arm/dt: Tegra: Add pinmux node to tegra20.dtsi
      arm/tegra: Convert pinmux driver to a platform device
      gpio/tegra: Convert to a platform device
      arm/tegra: pinmux: ioremap registers
      arm/tegra: Harmony: Configure PMC for low-level interrupts

Tapani Utriainen (1):
      ARM: OMAP: irq: loop counter fix in omap_init_irq()

Tarun Kanti DebBarma (8):
      ARM: OMAP2+: dmtimer: add device names to flck nodes
      ARM: OMAP1: dmtimer: conversion to platform devices
      ARM: OMAP2+: dmtimer: convert to platform devices
      ARM: OMAP: dmtimer: platform driver
      ARM: OMAP: dmtimer: switch-over to platform device driver
      ARM: OMAP: dmtimer: pm_runtime support
      ARM: OMAP: dmtimer: low-power mode support
      ARM: OMAP: dmtimer: add error handling to export APIs

Tero Kristo (1):
      omap: voltage: add a stub header file for external/regulator use

Thomas Meyer (1):
      ARM: davinci: edma: use kzalloc()

Thomas Petazzoni (3):
      at91: ohci-at91: add vbus_pin_inverted platform attribute
      at91: at91-ohci: support overcurrent notification
      at91: at91-ohci: configure overcurrent pins as input GPIOs

Todd Poynor (3):
      OMAP: VP: Explicitly mask VPVOLTAGE field
      OMAP: Improve register access in L3 Error handler.
      OMAP: Fix a BUG in l3 error handler.

Tony Lindgren (22):
      omap2+: Use Kconfig symbol in Makefile instead of obj-y
      ARM: OMAP: Move omap2_init_common_devices out of init_early
      ARM: OMAP: Introduce SoC specific early_init
      Merge branch 'omap_chip_remove_cleanup_3.2' of git://git.pwsan.com/linux-2.6 into cleanup
      Merge branch 'for_3.2/voltage-cleanup' of git://gitorious.org/khilman/linux-omap-pm into voltage
      ARM: OMAP: Add support for dmtimer v2 ip
      ARM: OMAP2+: Fix missing inline functions for Makefile cleanup
      ARM: OMAP: dmtimer: skip reserved timers
      Merge branch 'for_3.2/omap_device' of git://gitorious.org/khilman/linux-omap-pm into cleanup
      Merge branch 'for_3.2/pm-cleanup' of git://gitorious.org/khilman/linux-omap-pm into cleanup
      Merge branch 'for_3.2/voltage-cleanup' of git://gitorious.org/khilman/linux-omap-pm into voltage
      ARM: OMAP2+: Use SoC specifc map_io
      ARM: OMAP2+: Remove custom init_irq for remaining boards
      Merge branch 'for_3_2/omap_misc' of git://gitorious.org/omap-sw-develoment/linux-omap-dev into l3
      Merge branches 'cleanup-part3', 'voltage', 'dmtimer' and 'l3' into dt-base
      Merge branch 'for_3.2/3_omap_devicetree' of git://gitorious.org/omap-pm/linux into dt
      ARM: OMAP1: Use generic map_io, init_early and init_irq
      ARM: OMAP: Avoid cpu_is_omapxxxx usage until map_io is done
      ARM: OMAP: Remove calls to SRAM allocations for framebuffer
      ARM: OMAP: Map SRAM later on with ioremap_exec()
      ARM: OMAP: Move set_globals initialization to happen in init_early
      ARM: OMAP: Warn if omap_ioremap is called before SoC detection

Troy Kisky (3):
      ARM: i.MX51: Remove _MX51_PAD_xxx references
      ARM: i.MX51: clean up iomux-mx51.h
      ARM: i.MX53: clean up iomux-mx53.h

Tushar Behera (1):
      ARM: EXYNOS4: convert boot_params to atag_offset

Uwe Kleine-König (8):
      ARM: mx5: fix remaining inconsistent names for irqs
      ARM: mx5: remove unused #includes of devices.h
      ARM: mx5: dynamically allocate mxc-ehci devices
      ARM: mx5: dynamically allocate fsl-usb2-udc devices
      ARM: mx5: dynamically allocate high speed i2c (imx-i2c actually)
      ARM: imx/mx1ads: dynamically allocate physmap-flash device
      ARM: imx/armadillo5x0: dynamically allocate physmap-flash device
      ARM: mxc: drop now unused function mxc_register_device

Will Deacon (7):
      ARM: exynos4: convert logical CPU numbers to physical numbers
      ARM: msm: convert logical CPU numbers to physical numbers
      ARM: shmobile: convert logical CPU numbers to physical numbers
      ARM: ux500: convert logical CPU numbers to physical numbers
      ARM: versatile: convert logical CPU numbers to physical numbers
      ARM: plat-samsung: use Kconfig choice for debug UART selection
      ARM: realview: use Kconfig choice for debug UART selection

Wolfram Sang (4):
      arm: mxs: mx28evk: add fixed regulators for audio
      arm: mach-mxs: add device for rtc
      arm: mach-mxs: add rtc to all boards
      arm: mx3: update defconfig

Zhiwu Song (1):
      ARM: CSR: add rtc i/o bridge interface for SiRFprimaII

sricharan (3):
      OMAP: Fix indentation issues in l3 error handler.
      OMAP: Fix sparse warnings in l3 error handler.
      OMAP: Print Initiator name for l3 custom error.

srinidhi kasagar (1):
      ARM: mach-ux500: enable fix for ARM errata 754322

 Documentation/devicetree/bindings/arm/calxeda.txt  |    8 +
 Documentation/devicetree/bindings/arm/fsl.txt      |   26 +
 Documentation/devicetree/bindings/arm/gic.txt      |   55 +
 Documentation/devicetree/bindings/arm/omap/dsp.txt |   14 +
 Documentation/devicetree/bindings/arm/omap/iva.txt |   19 +
 .../devicetree/bindings/arm/omap/l3-noc.txt        |   19 +
 Documentation/devicetree/bindings/arm/omap/mpu.txt |   27 +
 .../devicetree/bindings/arm/omap/omap.txt          |   43 +
 .../devicetree/bindings/arm/picoxcell.txt          |   24 +
 .../devicetree/bindings/pinmux/pinmux_nvidia.txt   |    5 +
 .../devicetree/bindings/tty/serial/msm_serial.txt  |   27 +
 MAINTAINERS                                        |   13 +
 arch/arm/Kconfig                                   |   49 +-
 arch/arm/Kconfig.debug                             |  131 +-
 arch/arm/Makefile                                  |    9 +-
 arch/arm/boot/dts/at91sam9g20.dtsi                 |  119 +
 arch/arm/boot/dts/at91sam9g45.dtsi                 |  106 +
 arch/arm/boot/dts/at91sam9m10g45ek.dts             |   35 +
 arch/arm/boot/dts/highbank.dts                     |  198 ++
 arch/arm/boot/dts/imx51-babbage.dts                |  135 +
 arch/arm/boot/dts/imx51.dtsi                       |  246 ++
 arch/arm/boot/dts/imx53-ard.dts                    |  113 +
 arch/arm/boot/dts/imx53-evk.dts                    |  120 +
 arch/arm/boot/dts/imx53-qsb.dts                    |  125 +
 arch/arm/boot/dts/imx53-smd.dts                    |  169 +
 arch/arm/boot/dts/imx53.dtsi                       |  301 ++
 arch/arm/boot/dts/imx6q-sabreauto.dts              |   62 +
 arch/arm/boot/dts/imx6q.dtsi                       |  575 ++++
 arch/arm/boot/dts/msm8660-surf.dts                 |   24 +
 arch/arm/boot/dts/omap3-beagle.dts                 |   29 +
 arch/arm/boot/dts/omap3.dtsi                       |   63 +
 arch/arm/boot/dts/omap4-panda.dts                  |   29 +
 arch/arm/boot/dts/omap4-sdp.dts                    |   29 +
 arch/arm/boot/dts/omap4.dtsi                       |  103 +
 arch/arm/boot/dts/picoxcell-pc3x2.dtsi             |  249 ++
 arch/arm/boot/dts/picoxcell-pc3x3.dtsi             |  365 ++
 arch/arm/boot/dts/picoxcell-pc7302-pc3x2.dts       |   86 +
 arch/arm/boot/dts/picoxcell-pc7302-pc3x3.dts       |   92 +
 arch/arm/boot/dts/prima2-cb.dts                    |   14 +-
 arch/arm/boot/dts/tegra-harmony.dts                |    1 +
 arch/arm/boot/dts/tegra-seaboard.dts               |    4 +
 arch/arm/boot/dts/tegra-ventana.dts                |   32 +
 arch/arm/boot/dts/tegra20.dtsi                     |    8 +
 arch/arm/boot/dts/usb_a9g20.dts                    |   30 +
 arch/arm/common/Kconfig                            |    1 +
 arch/arm/common/gic.c                              |  188 +-
 arch/arm/configs/at91sam9g45_defconfig             |  214 ++
 arch/arm/configs/exynos4_defconfig                 |    1 +
 .../{mx27_defconfig => imx_v4_v5_defconfig}        |   68 +-
 arch/arm/configs/mx1_defconfig                     |   91 -
 arch/arm/configs/mx21_defconfig                    |   97 -
 arch/arm/configs/mx3_defconfig                     |   46 +-
 arch/arm/configs/{mx51_defconfig => mx5_defconfig} |   60 +-
 arch/arm/configs/mxs_defconfig                     |    1 +
 arch/arm/configs/tegra_defconfig                   |   39 +-
 arch/arm/include/asm/device.h                      |    5 +
 arch/arm/include/asm/hardware/cache-l2x0.h         |    9 +-
 arch/arm/include/asm/hardware/gic.h                |   10 +-
 arch/arm/include/asm/hardware/it8152.h             |    2 +-
 arch/arm/mach-at91/Kconfig                         |   24 +
 arch/arm/mach-at91/Makefile                        |    9 +-
 arch/arm/mach-at91/Makefile.boot                   |    2 +
 arch/arm/mach-at91/at91cap9.c                      |    2 +
 arch/arm/mach-at91/at91cap9_devices.c              |    6 +
 arch/arm/mach-at91/at91rm9200.c                    |    2 +
 arch/arm/mach-at91/at91rm9200_devices.c            |    8 +
 arch/arm/mach-at91/at91sam9260.c                   |   10 +
 arch/arm/mach-at91/at91sam9260_devices.c           |    8 +
 arch/arm/mach-at91/at91sam9261.c                   |   29 +-
 arch/arm/mach-at91/at91sam9261_devices.c           |    8 +
 arch/arm/mach-at91/at91sam9263.c                   |    2 +
 arch/arm/mach-at91/at91sam9263_devices.c           |    6 +
 arch/arm/mach-at91/at91sam9g45.c                   |   15 +
 arch/arm/mach-at91/at91sam9g45_devices.c           |   35 +
 arch/arm/mach-at91/board-dt.c                      |  123 +
 arch/arm/mach-at91/board-rsi-ews.c                 |  233 ++
 arch/arm/mach-at91/board-usb-a9260.c               |  230 --
 arch/arm/mach-at91/board-usb-a9263.c               |  246 --
 arch/arm/mach-at91/board-usb-a926x.c               |  383 +++
 arch/arm/mach-at91/include/mach/board.h            |    5 +
 arch/arm/mach-at91/include/mach/timex.h            |    5 +
 arch/arm/mach-davinci/Kconfig                      |   10 +
 arch/arm/mach-davinci/board-da850-evm.c            |  114 +
 arch/arm/mach-davinci/da850.c                      |    9 +
 arch/arm/mach-davinci/devices-da8xx.c              |    3 +
 arch/arm/mach-davinci/devices-tnetv107x.c          |    1 +
 arch/arm/mach-davinci/dm355.c                      |    1 +
 arch/arm/mach-davinci/dm644x.c                     |    1 +
 arch/arm/mach-davinci/dm646x.c                     |    1 +
 arch/arm/mach-davinci/dma.c                        |    5 +-
 arch/arm/mach-davinci/include/mach/mmc.h           |    3 +
 arch/arm/mach-davinci/include/mach/mux.h           |   10 +
 arch/arm/mach-ep93xx/Kconfig                       |    7 +
 arch/arm/mach-ep93xx/Makefile                      |    1 +
 arch/arm/mach-ep93xx/vision_ep9307.c               |  364 ++
 arch/arm/mach-exynos4/Kconfig                      |   71 +-
 arch/arm/mach-exynos4/Makefile                     |   12 +-
 arch/arm/mach-exynos4/clock-exynos4210.c           |  139 +
 arch/arm/mach-exynos4/clock-exynos4212.c           |  118 +
 arch/arm/mach-exynos4/clock.c                      |  218 +-
 arch/arm/mach-exynos4/cpu.c                        |   57 +-
 arch/arm/mach-exynos4/hotplug.c                    |    2 +-
 arch/arm/mach-exynos4/include/mach/entry-macro.S   |   23 +-
 arch/arm/mach-exynos4/include/mach/exynos4-clock.h |   43 +
 arch/arm/mach-exynos4/include/mach/irqs.h          |    2 +
 arch/arm/mach-exynos4/include/mach/map.h           |    4 +-
 arch/arm/mach-exynos4/include/mach/regs-clock.h    |   54 +-
 arch/arm/mach-exynos4/include/mach/regs-mct.h      |    5 +-
 arch/arm/mach-exynos4/mach-origen.c                |  108 +
 arch/arm/mach-exynos4/mach-smdk4x12.c              |  302 ++
 arch/arm/mach-exynos4/mach-smdkc210.c              |  309 --
 arch/arm/mach-exynos4/mach-smdkv310.c              |   78 +
 arch/arm/mach-exynos4/mct.c                        |  165 +-
 arch/arm/mach-exynos4/platsmp.c                    |   15 +-
 arch/arm/mach-exynos4/pm.c                         |   79 +-
 arch/arm/mach-highbank/Makefile                    |    6 +
 arch/arm/mach-highbank/Makefile.boot               |    1 +
 arch/arm/mach-highbank/clock.c                     |   62 +
 arch/arm/mach-highbank/core.h                      |    9 +
 arch/arm/mach-highbank/highbank.c                  |  145 +
 arch/arm/mach-highbank/hotplug.c                   |   56 +
 arch/arm/mach-highbank/include/mach/debug-macro.S  |   19 +
 arch/arm/mach-highbank/include/mach/entry-macro.S  |    7 +
 arch/arm/mach-highbank/include/mach/gpio.h         |    1 +
 arch/arm/mach-highbank/include/mach/io.h           |    7 +
 arch/arm/mach-highbank/include/mach/irqs.h         |    6 +
 arch/arm/mach-highbank/include/mach/memory.h       |    1 +
 arch/arm/mach-highbank/include/mach/system.h       |   26 +
 arch/arm/mach-highbank/include/mach/timex.h        |    6 +
 arch/arm/mach-highbank/include/mach/uncompress.h   |    9 +
 arch/arm/mach-highbank/include/mach/vmalloc.h      |    1 +
 arch/arm/mach-highbank/lluart.c                    |   34 +
 arch/arm/mach-highbank/localtimer.c                |   40 +
 arch/arm/mach-highbank/platsmp.c                   |   78 +
 arch/arm/mach-highbank/pm.c                        |   55 +
 arch/arm/mach-highbank/sysregs.h                   |   52 +
 arch/arm/mach-highbank/system.c                    |   33 +
 arch/arm/mach-imx/Kconfig                          |   83 +-
 arch/arm/mach-imx/Makefile                         |   26 +-
 arch/arm/mach-imx/Makefile.boot                    |    4 +
 arch/arm/mach-imx/cache-l2x0.c                     |   56 -
 arch/arm/mach-imx/clock-imx25.c                    |    6 +
 arch/arm/mach-imx/clock-imx27.c                    |    6 +-
 arch/arm/mach-imx/clock-imx31.c                    |    8 +-
 arch/arm/mach-imx/clock-imx35.c                    |    7 +-
 arch/arm/mach-imx/clock-imx6q.c                    | 2012 +++++++++++
 arch/arm/mach-imx/cpu-imx25.c                      |   41 +
 arch/arm/mach-imx/cpu-imx27.c                      |   28 +-
 arch/arm/mach-imx/cpu-imx31.c                      |   49 +-
 arch/arm/mach-imx/cpu-imx35.c                      |   30 +-
 arch/arm/mach-imx/devices-imx27.h                  |    4 +
 arch/arm/mach-imx/devices-imx31.h                  |    4 +
 arch/arm/mach-imx/devices-imx35.h                  |    4 +
 arch/arm/mach-imx/gpc.c                            |  113 +
 arch/arm/mach-imx/head-v7.S                        |   99 +
 arch/arm/mach-imx/hotplug.c                        |   44 +
 arch/arm/mach-imx/lluart.c                         |   32 +
 arch/arm/mach-imx/localtimer.c                     |   35 +
 arch/arm/mach-imx/mach-apf9328.c                   |    1 +
 arch/arm/mach-imx/mach-armadillo5x0.c              |   19 +-
 arch/arm/mach-imx/mach-bug.c                       |    1 +
 arch/arm/mach-imx/mach-cpuimx27.c                  |    1 +
 arch/arm/mach-imx/mach-cpuimx35.c                  |    3 +-
 arch/arm/mach-imx/mach-eukrea_cpuimx25.c           |    1 +
 arch/arm/mach-imx/mach-imx27_visstrim_m10.c        |    1 +
 arch/arm/mach-imx/mach-imx27ipcam.c                |    1 +
 arch/arm/mach-imx/mach-imx27lite.c                 |    1 +
 arch/arm/mach-imx/mach-imx6q.c                     |   84 +
 arch/arm/mach-imx/mach-kzm_arm11_01.c              |    2 +
 arch/arm/mach-imx/mach-mx1ads.c                    |   17 +-
 arch/arm/mach-imx/mach-mx21ads.c                   |    1 +
 arch/arm/mach-imx/mach-mx25_3ds.c                  |   11 +
 arch/arm/mach-imx/mach-mx27_3ds.c                  |    3 +-
 arch/arm/mach-imx/mach-mx27ads.c                   |    1 +
 arch/arm/mach-imx/mach-mx31_3ds.c                  |    3 +-
 arch/arm/mach-imx/mach-mx31ads.c                   |    1 +
 arch/arm/mach-imx/mach-mx31lilly.c                 |    1 +
 arch/arm/mach-imx/mach-mx31lite.c                  |    1 +
 arch/arm/mach-imx/mach-mx31moboard.c               |   18 +
 arch/arm/mach-imx/mach-mx35_3ds.c                  |    1 +
 arch/arm/mach-imx/mach-mxt_td60.c                  |    1 +
 arch/arm/mach-imx/mach-pca100.c                    |    1 +
 arch/arm/mach-imx/mach-pcm037.c                    |    1 +
 arch/arm/mach-imx/mach-pcm038.c                    |    5 +-
 arch/arm/mach-imx/mach-pcm043.c                    |    1 +
 arch/arm/mach-imx/mach-qong.c                      |    7 +-
 arch/arm/mach-imx/mach-scb9328.c                   |    1 +
 arch/arm/mach-imx/mach-vpr200.c                    |    3 +-
 arch/arm/mach-imx/mm-imx3.c                        |  256 ++
 arch/arm/mach-imx/mm-imx31.c                       |   91 -
 arch/arm/mach-imx/mm-imx35.c                       |  109 -
 arch/arm/mach-imx/mmdc.c                           |   72 +
 arch/arm/mach-imx/platsmp.c                        |   85 +
 arch/arm/mach-imx/pm-imx27.c                       |    2 +-
 arch/arm/mach-imx/pm-imx6q.c                       |   70 +
 arch/arm/mach-imx/src.c                            |   49 +
 arch/arm/mach-ixp4xx/Kconfig                       |   19 +
 arch/arm/mach-ixp4xx/Makefile                      |    4 +
 arch/arm/mach-ixp4xx/include/mach/uncompress.h     |    3 +-
 arch/arm/mach-ixp4xx/miccpt-pci.c                  |   78 +
 arch/arm/mach-ixp4xx/omixp-setup.c                 |  273 ++
 arch/arm/mach-mmp/Kconfig                          |    2 +-
 arch/arm/mach-mmp/Makefile                         |    2 +-
 arch/arm/mach-mmp/clock.h                          |    8 +-
 arch/arm/mach-mmp/common.c                         |    4 +-
 arch/arm/mach-mmp/gplugd.c                         |    2 +-
 arch/arm/mach-mmp/include/mach/addr-map.h          |   10 +-
 arch/arm/mach-mmp/include/mach/gpio-pxa.h          |    2 +-
 arch/arm/mach-mmp/mmp2.c                           |    3 +-
 arch/arm/mach-msm/board-msm8x60.c                  |   58 +-
 arch/arm/mach-msm/hotplug.c                        |    2 +-
 arch/arm/mach-msm/platsmp.c                        |    2 +-
 arch/arm/mach-mx5/Kconfig                          |   50 +-
 arch/arm/mach-mx5/Makefile                         |    6 +-
 arch/arm/mach-mx5/board-cpuimx51.c                 |   28 +-
 arch/arm/mach-mx5/board-cpuimx51sd.c               |   26 +-
 arch/arm/mach-mx5/board-mx50_rdp.c                 |    1 +
 arch/arm/mach-mx5/board-mx51_3ds.c                 |    2 +-
 arch/arm/mach-mx5/board-mx51_babbage.c             |   36 +-
 arch/arm/mach-mx5/board-mx51_efikamx.c             |   14 +-
 arch/arm/mach-mx5/board-mx51_efikasb.c             |   25 +-
 arch/arm/mach-mx5/board-mx53_ard.c                 |   18 +-
 arch/arm/mach-mx5/board-mx53_evk.c                 |   10 +-
 arch/arm/mach-mx5/board-mx53_loco.c                |   31 +-
 arch/arm/mach-mx5/board-mx53_smd.c                 |   26 +-
 arch/arm/mach-mx5/clock-mx51-mx53.c                |   72 +-
 arch/arm/mach-mx5/cpu.c                            |   74 +-
 arch/arm/mach-mx5/devices-imx51.h                  |   17 +
 arch/arm/mach-mx5/devices-imx53.h                  |    6 +
 arch/arm/mach-mx5/devices.c                        |  120 -
 arch/arm/mach-mx5/devices.h                        |    5 -
 arch/arm/mach-mx5/ehci.c                           |    2 +-
 arch/arm/mach-mx5/eukrea_mbimx51-baseboard.c       |    3 +-
 arch/arm/mach-mx5/eukrea_mbimxsd-baseboard.c       |    6 +-
 arch/arm/mach-mx5/imx51-dt.c                       |  116 +
 arch/arm/mach-mx5/imx53-dt.c                       |  126 +
 arch/arm/mach-mx5/mm-mx50.c                        |   72 -
 arch/arm/mach-mx5/mm.c                             |   90 +-
 arch/arm/mach-mx5/mx51_efika.c                     |   20 +-
 arch/arm/mach-mx5/pm-imx5.c                        |   18 +-
 arch/arm/mach-mx5/system.c                         |    1 +
 arch/arm/mach-mxs/Kconfig                          |   23 +
 arch/arm/mach-mxs/Makefile                         |    7 +-
 arch/arm/mach-mxs/clock-mx28.c                     |   26 +-
 arch/arm/mach-mxs/devices-mx23.h                   |    2 +
 arch/arm/mach-mxs/devices-mx28.h                   |    5 +
 arch/arm/mach-mxs/devices/Kconfig                  |    6 +
 arch/arm/mach-mxs/devices/Makefile                 |    2 +
 arch/arm/mach-mxs/devices/platform-mxs-saif.c      |   60 +
 arch/arm/mach-mxs/devices/platform-rtc-stmp3xxx.c  |   51 +
 arch/arm/mach-mxs/include/mach/debug-macro.S       |   12 +-
 arch/arm/mach-mxs/include/mach/devices-common.h    |   12 +
 arch/arm/mach-mxs/include/mach/gpio.h              |   28 +-
 arch/arm/mach-mxs/include/mach/mxs.h               |    3 +
 arch/arm/mach-mxs/include/mach/uncompress.h        |    1 +
 arch/arm/mach-mxs/mach-m28evk.c                    |  366 ++
 arch/arm/mach-mxs/mach-mx23evk.c                   |    4 +-
 arch/arm/mach-mxs/mach-mx28evk.c                   |  100 +-
 arch/arm/mach-mxs/mach-stmp378x_devb.c             |    2 +-
 arch/arm/mach-mxs/mach-tx28.c                      |    3 +-
 arch/arm/mach-mxs/mm-mx28.c                        |   44 -
 arch/arm/mach-mxs/{mm-mx23.c => mm.c}              |   19 +
 arch/arm/mach-nuc93x/Kconfig                       |   19 -
 arch/arm/mach-nuc93x/Makefile                      |   14 -
 arch/arm/mach-nuc93x/Makefile.boot                 |    3 -
 arch/arm/mach-nuc93x/clock.c                       |   83 -
 arch/arm/mach-nuc93x/clock.h                       |   36 -
 arch/arm/mach-nuc93x/cpu.c                         |  135 -
 arch/arm/mach-nuc93x/cpu.h                         |   48 -
 arch/arm/mach-nuc93x/dev.c                         |   42 -
 arch/arm/mach-nuc93x/include/mach/entry-macro.S    |   32 -
 arch/arm/mach-nuc93x/include/mach/hardware.h       |   22 -
 arch/arm/mach-nuc93x/include/mach/io.h             |   28 -
 arch/arm/mach-nuc93x/include/mach/irqs.h           |   59 -
 arch/arm/mach-nuc93x/include/mach/map.h            |  139 -
 arch/arm/mach-nuc93x/include/mach/regs-clock.h     |   53 -
 arch/arm/mach-nuc93x/include/mach/regs-ebi.h       |   33 -
 arch/arm/mach-nuc93x/include/mach/regs-irq.h       |   42 -
 arch/arm/mach-nuc93x/include/mach/regs-serial.h    |   52 -
 arch/arm/mach-nuc93x/include/mach/regs-timer.h     |   28 -
 arch/arm/mach-nuc93x/include/mach/system.h         |   28 -
 arch/arm/mach-nuc93x/include/mach/timex.h          |   25 -
 arch/arm/mach-nuc93x/include/mach/uncompress.h     |   50 -
 arch/arm/mach-nuc93x/include/mach/vmalloc.h        |   23 -
 arch/arm/mach-nuc93x/irq.c                         |   66 -
 arch/arm/mach-nuc93x/mach-nuc932evb.c              |   42 -
 arch/arm/mach-nuc93x/nuc932.c                      |   65 -
 arch/arm/mach-nuc93x/nuc932.h                      |   29 -
 arch/arm/mach-nuc93x/time.c                        |  100 -
 arch/arm/mach-omap1/Makefile                       |    2 +-
 arch/arm/mach-omap1/board-ams-delta.c              |   16 +-
 arch/arm/mach-omap1/board-fsample.c                |   76 +-
 arch/arm/mach-omap1/board-generic.c                |   16 +-
 arch/arm/mach-omap1/board-h2.c                     |   16 +-
 arch/arm/mach-omap1/board-h3.c                     |   16 +-
 arch/arm/mach-omap1/board-htcherald.c              |   12 +-
 arch/arm/mach-omap1/board-innovator.c              |   36 +-
 arch/arm/mach-omap1/board-nokia770.c               |   34 +-
 arch/arm/mach-omap1/board-osk.c                    |   16 +-
 arch/arm/mach-omap1/board-palmte.c                 |   16 +-
 arch/arm/mach-omap1/board-palmtt.c                 |   16 +-
 arch/arm/mach-omap1/board-palmz71.c                |   18 +-
 arch/arm/mach-omap1/board-perseus2.c               |   75 +-
 arch/arm/mach-omap1/board-sx1.c                    |   17 +-
 arch/arm/mach-omap1/board-voiceblue.c              |   16 +-
 arch/arm/mach-omap1/devices.c                      |    3 +
 arch/arm/mach-omap1/io.c                           |   59 +-
 arch/arm/mach-omap1/mcbsp.c                        |   45 +
 arch/arm/mach-omap1/timer.c                        |  173 +
 arch/arm/mach-omap2/Kconfig                        |    8 +-
 arch/arm/mach-omap2/Makefile                       |   92 +-
 arch/arm/mach-omap2/board-2430sdp.c                |   17 +-
 arch/arm/mach-omap2/board-3430sdp.c                |    9 +-
 arch/arm/mach-omap2/board-3630sdp.c                |   11 +-
 arch/arm/mach-omap2/board-4430sdp.c                |   19 +-
 arch/arm/mach-omap2/board-am3517crane.c            |    9 +-
 arch/arm/mach-omap2/board-am3517evm.c              |    8 +-
 arch/arm/mach-omap2/board-apollon.c                |   18 +-
 arch/arm/mach-omap2/board-cm-t35.c                 |   13 +-
 arch/arm/mach-omap2/board-cm-t3517.c               |    9 +-
 arch/arm/mach-omap2/board-devkit8000.c             |   19 +-
 arch/arm/mach-omap2/board-flash.c                  |    5 -
 arch/arm/mach-omap2/board-flash.h                  |   19 +
 arch/arm/mach-omap2/board-generic.c                |  153 +-
 arch/arm/mach-omap2/board-h4.c                     |   24 +-
 arch/arm/mach-omap2/board-igep0020.c               |   13 +-
 arch/arm/mach-omap2/board-ldp.c                    |    9 +-
 arch/arm/mach-omap2/board-n8x0.c                   |   25 +-
 arch/arm/mach-omap2/board-omap3beagle.c            |   22 +-
 arch/arm/mach-omap2/board-omap3evm.c               |    9 +-
 arch/arm/mach-omap2/board-omap3logic.c             |   11 +-
 arch/arm/mach-omap2/board-omap3pandora.c           |   11 +-
 arch/arm/mach-omap2/board-omap3stalker.c           |   16 +-
 arch/arm/mach-omap2/board-omap3touchbook.c         |   18 +-
 arch/arm/mach-omap2/board-omap4panda.c             |   17 +-
 arch/arm/mach-omap2/board-overo.c                  |   11 +-
 arch/arm/mach-omap2/board-rm680.c                  |   25 +-
 arch/arm/mach-omap2/board-rx51.c                   |   25 +-
 arch/arm/mach-omap2/board-ti8168evm.c              |   10 +-
 arch/arm/mach-omap2/board-zoom.c                   |   23 +-
 arch/arm/mach-omap2/clock2420_data.c               |   48 +
 arch/arm/mach-omap2/clock2430_data.c               |   48 +
 arch/arm/mach-omap2/clock3xxx_data.c               |   47 +-
 arch/arm/mach-omap2/clock44xx_data.c               |   33 +
 arch/arm/mach-omap2/clockdomain.c                  |  147 +-
 arch/arm/mach-omap2/clockdomain.h                  |   22 +-
 arch/arm/mach-omap2/clockdomain2xxx_3xxx.c         |    4 -
 arch/arm/mach-omap2/clockdomain44xx.c              |    2 -
 arch/arm/mach-omap2/clockdomains2420_data.c        |  154 +
 arch/arm/mach-omap2/clockdomains2430_data.c        |  181 +
 arch/arm/mach-omap2/clockdomains2xxx_3xxx_data.c   |  803 +-----
 arch/arm/mach-omap2/clockdomains3xxx_data.c        |  398 +++
 arch/arm/mach-omap2/clockdomains44xx_data.c        |  409 +--
 arch/arm/mach-omap2/common.c                       |   62 +-
 arch/arm/mach-omap2/control.c                      |   16 +-
 arch/arm/mach-omap2/devices.c                      |   91 +-
 arch/arm/mach-omap2/display.c                      |   17 +-
 arch/arm/mach-omap2/dma.c                          |   25 +-
 arch/arm/mach-omap2/gpio.c                         |   22 +-
 arch/arm/mach-omap2/hsmmc.c                        |   26 +-
 arch/arm/mach-omap2/hwspinlock.c                   |   18 +-
 arch/arm/mach-omap2/id.c                           |  191 +-
 arch/arm/mach-omap2/io.c                           |  152 +-
 arch/arm/mach-omap2/io.h                           |    7 -
 arch/arm/mach-omap2/irq.c                          |    4 +-
 arch/arm/mach-omap2/mcbsp.c                        |  120 +-
 arch/arm/mach-omap2/omap-smp.c                     |    7 +-
 arch/arm/mach-omap2/omap_hwmod.c                   |    3 -
 arch/arm/mach-omap2/omap_hwmod_2420_data.c         |   59 +-
 arch/arm/mach-omap2/omap_hwmod_2430_data.c         |   67 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |  200 +-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |  104 +-
 arch/arm/mach-omap2/omap_l3_noc.c                  |  147 +-
 arch/arm/mach-omap2/omap_l3_noc.h                  |  224 +-
 arch/arm/mach-omap2/omap_l3_smx.c                  |   91 +-
 arch/arm/mach-omap2/omap_l3_smx.h                  |  164 +-
 arch/arm/mach-omap2/omap_twl.c                     |  107 +-
 arch/arm/mach-omap2/opp.c                          |    2 +-
 arch/arm/mach-omap2/pm.c                           |  104 +-
 arch/arm/mach-omap2/pm24xx.c                       |   27 -
 arch/arm/mach-omap2/pm34xx.c                       |    2 +-
 arch/arm/mach-omap2/powerdomain-common.c           |    7 +-
 arch/arm/mach-omap2/powerdomain.c                  |  110 +-
 arch/arm/mach-omap2/powerdomain.h                  |   19 +-
 arch/arm/mach-omap2/powerdomain2xxx_3xxx.c         |    2 +-
 arch/arm/mach-omap2/powerdomains2xxx_3xxx_data.c   |   21 +-
 arch/arm/mach-omap2/powerdomains2xxx_data.c        |   48 +-
 arch/arm/mach-omap2/powerdomains3xxx_data.c        |   97 +-
 arch/arm/mach-omap2/powerdomains44xx_data.c        |   36 +-
 arch/arm/mach-omap2/prcm.c                         |   19 +-
 arch/arm/mach-omap2/prm2xxx_3xxx.c                 |   56 +
 arch/arm/mach-omap2/prm2xxx_3xxx.h                 |   12 +
 arch/arm/mach-omap2/prm44xx.c                      |   71 +
 arch/arm/mach-omap2/prm44xx.h                      |   12 +
 arch/arm/mach-omap2/sdrc.c                         |   13 +-
 arch/arm/mach-omap2/serial.c                       |   39 +-
 arch/arm/mach-omap2/smartreflex-class3.c           |    4 +-
 arch/arm/mach-omap2/smartreflex.c                  |   29 +-
 arch/arm/mach-omap2/sr_device.c                    |   19 +-
 arch/arm/mach-omap2/timer.c                        |  194 +-
 arch/arm/mach-omap2/usb-musb.c                     |   26 +-
 arch/arm/mach-omap2/vc.c                           |  367 ++
 arch/arm/mach-omap2/vc.h                           |   88 +-
 arch/arm/mach-omap2/vc3xxx_data.c                  |   31 +-
 arch/arm/mach-omap2/vc44xx_data.c                  |   44 +-
 arch/arm/mach-omap2/voltage.c                      | 1088 ++-----
 arch/arm/mach-omap2/voltage.h                      |  150 +-
 arch/arm/mach-omap2/voltagedomains2xxx_data.c      |   32 +
 arch/arm/mach-omap2/voltagedomains3xxx_data.c      |   83 +-
 arch/arm/mach-omap2/voltagedomains44xx_data.c      |   99 +-
 arch/arm/mach-omap2/vp.c                           |  278 ++
 arch/arm/mach-omap2/vp.h                           |  133 +-
 arch/arm/mach-omap2/vp3xxx_data.c                  |   35 +-
 arch/arm/mach-omap2/vp44xx_data.c                  |   47 +-
 arch/arm/mach-picoxcell/Makefile                   |    3 +
 arch/arm/mach-picoxcell/Makefile.boot              |    1 +
 arch/arm/mach-picoxcell/common.c                   |   55 +
 arch/arm/mach-picoxcell/common.h                   |   18 +
 arch/arm/mach-picoxcell/include/mach/debug-macro.S |   35 +
 arch/arm/mach-picoxcell/include/mach/entry-macro.S |   19 +
 arch/arm/mach-picoxcell/include/mach/gpio.h        |    1 +
 arch/arm/mach-picoxcell/include/mach/hardware.h    |   21 +
 arch/arm/mach-picoxcell/include/mach/io.h          |   22 +
 arch/arm/mach-picoxcell/include/mach/irqs.h        |   25 +
 arch/arm/mach-picoxcell/include/mach/map.h         |   25 +
 arch/arm/mach-picoxcell/include/mach/memory.h      |    1 +
 .../mach-picoxcell/include/mach/picoxcell_soc.h    |   25 +
 arch/arm/mach-picoxcell/include/mach/system.h      |   31 +
 arch/arm/mach-picoxcell/include/mach/timex.h       |   25 +
 arch/arm/mach-picoxcell/include/mach/uncompress.h  |   21 +
 arch/arm/mach-picoxcell/include/mach/vmalloc.h     |   14 +
 arch/arm/mach-picoxcell/io.c                       |   32 +
 arch/arm/mach-picoxcell/time.c                     |  132 +
 arch/arm/mach-prima2/Makefile                      |    2 +
 arch/arm/mach-prima2/clock.c                       |    4 +-
 arch/arm/mach-prima2/irq.c                         |   43 +
 arch/arm/mach-prima2/l2x0.c                        |   45 +-
 arch/arm/mach-prima2/pm.c                          |  150 +
 arch/arm/mach-prima2/pm.h                          |   29 +
 arch/arm/mach-prima2/prima2.c                      |    2 +-
 arch/arm/mach-prima2/rtciobrg.c                    |  139 +
 arch/arm/mach-prima2/sleep.S                       |   64 +
 arch/arm/mach-prima2/timer.c                       |   38 +-
 arch/arm/mach-pxa/Kconfig                          |   38 +-
 arch/arm/mach-pxa/Makefile                         |    2 +-
 arch/arm/mach-pxa/balloon3.c                       |   10 +-
 arch/arm/mach-pxa/cm-x2xx-pci.c                    |    2 +-
 arch/arm/mach-pxa/cm-x2xx.c                        |    4 +-
 arch/arm/mach-pxa/cm-x300.c                        |    8 +-
 arch/arm/mach-pxa/include/mach/addr-map.h          |    8 +-
 arch/arm/mach-pxa/include/mach/balloon3.h          |    2 +-
 arch/arm/mach-pxa/include/mach/gpio-pxa.h          |    2 +-
 arch/arm/mach-pxa/include/mach/hardware.h          |    9 +-
 arch/arm/mach-pxa/include/mach/lpd270.h            |    4 +-
 arch/arm/mach-pxa/include/mach/mtd-xip.h           |    1 -
 arch/arm/mach-pxa/include/mach/palm27x.h           |    2 +-
 arch/arm/mach-pxa/include/mach/palmtx.h            |    6 +-
 arch/arm/mach-pxa/include/mach/pxa27x.h            |    2 +
 arch/arm/mach-pxa/include/mach/pxa95x.h            |    7 +
 arch/arm/mach-pxa/include/mach/pxafb.h             |   13 +
 arch/arm/mach-pxa/include/mach/smemc.h             |    2 +-
 arch/arm/mach-pxa/include/mach/zeus.h              |    4 +-
 arch/arm/mach-pxa/include/mach/zylonite.h          |    4 +-
 arch/arm/mach-pxa/irq.c                            |    4 +-
 arch/arm/mach-pxa/lpd270.c                         |    2 +-
 arch/arm/mach-pxa/palmtreo.c                       |    8 +
 arch/arm/mach-pxa/palmtx.c                         |    8 +-
 arch/arm/mach-pxa/pxa25x.c                         |    2 +-
 arch/arm/mach-pxa/pxa27x.c                         |    2 +-
 arch/arm/mach-pxa/pxa3xx-ulpi.c                    |    2 +
 arch/arm/mach-pxa/pxa3xx.c                         |    2 +-
 arch/arm/mach-pxa/saarb.c                          |    1 +
 arch/arm/mach-pxa/z2.c                             |    3 +-
 arch/arm/mach-pxa/zeus.c                           |    8 +-
 arch/arm/mach-realview/hotplug.c                   |    2 +-
 arch/arm/mach-realview/include/mach/debug-macro.S  |   17 +-
 arch/arm/mach-s3c2410/Kconfig                      |    6 -
 arch/arm/mach-s3c2410/Makefile                     |    1 -
 arch/arm/mach-s3c2410/dma.c                        |   14 -
 arch/arm/mach-s3c2410/gpio.c                       |   72 -
 arch/arm/mach-s3c2410/include/mach/map.h           |   52 +-
 arch/arm/mach-s3c2412/Kconfig                      |    1 -
 arch/arm/mach-s3c2412/Makefile                     |    1 -
 arch/arm/mach-s3c2412/dma.c                        |   18 -
 arch/arm/mach-s3c2412/gpio.c                       |   62 -
 arch/arm/mach-s3c2440/Kconfig                      |    2 -
 arch/arm/mach-s3c2440/dma.c                        |   17 -
 arch/arm/mach-s3c2443/dma.c                        |   27 -
 arch/arm/mach-s3c64xx/cpu.c                        |   22 +-
 arch/arm/mach-s3c64xx/include/mach/map.h           |    9 +-
 arch/arm/mach-s3c64xx/mach-crag6410.c              |    3 -
 arch/arm/mach-s3c64xx/mach-mini6410.c              |    8 +-
 arch/arm/mach-s3c64xx/mach-real6410.c              |    8 +-
 arch/arm/mach-s3c64xx/mach-smdk6410.c              |    8 +-
 arch/arm/mach-s5p64x0/dev-spi.c                    |    8 +-
 arch/arm/mach-s5p64x0/dma.c                        |    7 +-
 arch/arm/mach-s5p64x0/gpiolib.c                    |    7 +-
 arch/arm/mach-s5p64x0/irq-eint.c                   |    3 +-
 arch/arm/mach-s5p64x0/mach-smdk6440.c              |    8 +-
 arch/arm/mach-s5p64x0/mach-smdk6450.c              |    8 +-
 arch/arm/mach-s5pc100/mach-smdkc100.c              |    8 +-
 arch/arm/mach-s5pv210/Kconfig                      |    6 -
 arch/arm/mach-s5pv210/Makefile                     |    2 +-
 arch/arm/mach-s5pv210/mach-smdkv210.c              |    8 +-
 arch/arm/mach-shmobile/smp-sh73a0.c                |    6 +-
 arch/arm/mach-tegra/Kconfig                        |    6 +
 arch/arm/mach-tegra/Makefile                       |    1 +
 arch/arm/mach-tegra/Makefile.boot                  |    1 +
 arch/arm/mach-tegra/board-dt.c                     |   26 +-
 arch/arm/mach-tegra/board-harmony-pinmux.c         |    8 +
 arch/arm/mach-tegra/board-harmony-power.c          |   13 +-
 arch/arm/mach-tegra/board-harmony.c                |    5 +-
 arch/arm/mach-tegra/board-paz00-pinmux.c           |   11 +
 arch/arm/mach-tegra/board-paz00.c                  |   64 +-
 arch/arm/mach-tegra/board-paz00.h                  |    8 +
 arch/arm/mach-tegra/board-seaboard-pinmux.c        |   75 +-
 arch/arm/mach-tegra/board-seaboard.c               |   81 +-
 arch/arm/mach-tegra/board-seaboard.h               |   12 +-
 arch/arm/mach-tegra/board-trimslice-pinmux.c       |    7 +
 arch/arm/mach-tegra/board-trimslice.c              |    4 +-
 arch/arm/mach-tegra/common.c                       |    2 +-
 arch/arm/mach-tegra/cpu-tegra.c                    |    6 +-
 arch/arm/mach-tegra/devices.c                      |   86 +
 arch/arm/mach-tegra/devices.h                      |    2 +
 arch/arm/mach-tegra/dma.c                          |   14 +-
 arch/arm/mach-tegra/include/mach/io.h              |   18 +-
 arch/arm/mach-tegra/include/mach/pinmux.h          |    4 +
 arch/arm/mach-tegra/include/mach/powergate.h       |    1 -
 arch/arm/mach-tegra/io.c                           |    8 +-
 arch/arm/mach-tegra/pcie.c                         |    8 +-
 arch/arm/mach-tegra/pinmux-t2-tables.c             |   76 +-
 arch/arm/mach-tegra/pinmux.c                       |  163 +-
 arch/arm/mach-tegra/powergate.c                    |    5 +-
 arch/arm/mach-tegra/tegra2_clocks.c                |   50 +-
 arch/arm/mach-tegra/timer.c                        |    6 +-
 arch/arm/mach-u300/Kconfig                         |   46 -
 arch/arm/mach-u300/Makefile.boot                   |   17 +-
 arch/arm/mach-u300/core.c                          |   81 +-
 arch/arm/mach-u300/include/mach/memory.h           |   22 +-
 arch/arm/mach-u300/u300.c                          |   16 -
 arch/arm/mach-ux500/Makefile                       |    3 +-
 arch/arm/mach-ux500/board-mop500-pins.c            |   34 +-
 arch/arm/mach-ux500/board-mop500-sdi.c             |   52 +-
 arch/arm/mach-ux500/board-mop500.c                 |   78 +-
 arch/arm/mach-ux500/board-mop500.h                 |    3 +
 arch/arm/mach-ux500/cache-l2x0.c                   |   95 +
 arch/arm/mach-ux500/cpu.c                          |   98 +-
 arch/arm/mach-ux500/hotplug.c                      |    2 +-
 arch/arm/mach-ux500/include/mach/db5500-regs.h     |    2 +
 arch/arm/mach-ux500/include/mach/db8500-regs.h     |    3 +
 arch/arm/mach-ux500/include/mach/uncompress.h      |   10 +-
 arch/arm/mach-ux500/pins-db8500.h                  |  142 +-
 arch/arm/mach-ux500/platsmp.c                      |    2 +-
 arch/arm/mach-ux500/timer.c                        |   68 +
 arch/arm/mach-vexpress/hotplug.c                   |    2 +-
 arch/arm/mm/Kconfig                                |    4 +-
 arch/arm/plat-mxc/Kconfig                          |   50 +-
 arch/arm/plat-mxc/Makefile                         |    2 +-
 arch/arm/plat-mxc/audmux-v2.c                      |   18 +-
 arch/arm/plat-mxc/avic.c                           |   91 +-
 arch/arm/plat-mxc/cpu.c                            |    9 +
 arch/arm/plat-mxc/devices.c                        |   14 -
 arch/arm/plat-mxc/devices/Kconfig                  |    9 +-
 arch/arm/plat-mxc/devices/Makefile                 |    2 +
 arch/arm/plat-mxc/devices/platform-ahci-imx.c      |  156 +
 arch/arm/plat-mxc/devices/platform-fsl-usb2-udc.c  |    5 +
 arch/arm/plat-mxc/devices/platform-imx-i2c.c       |    6 +
 arch/arm/plat-mxc/devices/platform-mxc-ehci.c      |    9 +
 arch/arm/plat-mxc/devices/platform-pata_imx.c      |   59 +
 arch/arm/plat-mxc/gic.c                            |   48 +
 arch/arm/plat-mxc/include/mach/common.h            |   63 +-
 arch/arm/plat-mxc/include/mach/debug-macro.S       |   40 +-
 arch/arm/plat-mxc/include/mach/devices-common.h    |   18 +
 arch/arm/plat-mxc/include/mach/entry-macro.S       |   64 +-
 arch/arm/plat-mxc/include/mach/gpio.h              |   34 +-
 arch/arm/plat-mxc/include/mach/hardware.h          |   19 +-
 arch/arm/plat-mxc/include/mach/io.h                |   22 +-
 arch/arm/plat-mxc/include/mach/iomux-mx3.h         |    1 +
 arch/arm/plat-mxc/include/mach/iomux-mx51.h        | 2270 +++++---------
 arch/arm/plat-mxc/include/mach/iomux-mx53.h        | 3530 +++++++-------------
 arch/arm/plat-mxc/include/mach/iomux-v3.h          |   11 +-
 arch/arm/plat-mxc/include/mach/irqs.h              |   10 +-
 arch/arm/plat-mxc/include/mach/mx25.h              |    5 +
 arch/arm/plat-mxc/include/mach/mx27.h              |   14 -
 arch/arm/plat-mxc/include/mach/mx31.h              |   14 -
 arch/arm/plat-mxc/include/mach/mx35.h              |    2 +-
 arch/arm/plat-mxc/include/mach/mx3x.h              |   18 +-
 arch/arm/plat-mxc/include/mach/mx51.h              |  183 +-
 arch/arm/plat-mxc/include/mach/mx53.h              |    1 +
 arch/arm/plat-mxc/include/mach/mx6q.h              |   33 +
 arch/arm/plat-mxc/include/mach/mxc.h               |    7 -
 arch/arm/plat-mxc/include/mach/system.h            |   35 +-
 arch/arm/plat-mxc/irq-common.c                     |   21 +-
 arch/arm/plat-mxc/irq-common.h                     |    3 +-
 arch/arm/plat-mxc/pwm.c                            |    2 +-
 arch/arm/plat-mxc/system.c                         |    3 +
 arch/arm/plat-mxc/tzic.c                           |   32 +-
 arch/arm/plat-nomadik/Kconfig                      |    8 +-
 arch/arm/plat-nomadik/include/plat/mtu.h           |   47 +-
 arch/arm/plat-nomadik/include/plat/pincfg.h        |    5 -
 arch/arm/plat-nomadik/timer.c                      |  138 +-
 arch/arm/plat-omap/devices.c                       |   44 -
 arch/arm/plat-omap/dmtimer.c                       |  713 +++--
 arch/arm/plat-omap/i2c.c                           |   18 +-
 arch/arm/plat-omap/include/plat/clock.h            |    2 -
 arch/arm/plat-omap/include/plat/common.h           |   30 +-
 arch/arm/plat-omap/include/plat/cpu.h              |  108 +-
 arch/arm/plat-omap/include/plat/dmtimer.h          |  233 +-
 arch/arm/plat-omap/include/plat/io.h               |   35 +-
 arch/arm/plat-omap/include/plat/mcbsp.h            |  208 +-
 arch/arm/plat-omap/include/plat/omap_device.h      |   31 +-
 arch/arm/plat-omap/include/plat/omap_hwmod.h       |    3 -
 arch/arm/plat-omap/include/plat/voltage.h          |   20 +
 arch/arm/plat-omap/io.c                            |   10 +
 arch/arm/plat-omap/mcbsp.c                         |  385 +--
 arch/arm/plat-omap/omap_device.c                   |  450 ++-
 arch/arm/plat-omap/sram.c                          |   85 +-
 arch/arm/plat-pxa/include/plat/mfp.h               |    2 +-
 arch/arm/plat-pxa/mfp.c                            |    4 +-
 arch/arm/plat-s3c24xx/cpu.c                        |    9 +-
 arch/arm/plat-s3c24xx/include/plat/map.h           |  100 -
 arch/arm/plat-s5p/cpu.c                            |   46 +-
 arch/arm/plat-s5p/include/plat/exynos4.h           |    5 +-
 arch/arm/plat-s5p/include/plat/pll.h               |   56 +-
 arch/arm/plat-samsung/Kconfig                      |    7 +
 arch/arm/plat-samsung/Makefile                     |    2 +-
 arch/arm/plat-samsung/cpu.c                        |   58 +
 arch/arm/plat-samsung/dev-hsmmc.c                  |   19 +-
 arch/arm/plat-samsung/dev-hsmmc1.c                 |   19 +-
 arch/arm/plat-samsung/dev-hsmmc2.c                 |   19 +-
 arch/arm/plat-samsung/dev-hsmmc3.c                 |   19 +-
 arch/arm/plat-samsung/dev-ts.c                     |    9 +
 arch/arm/plat-samsung/include/plat/cpu.h           |  113 +-
 arch/arm/plat-samsung/include/plat/dma-s3c24xx.h   |    6 -
 arch/arm/plat-samsung/include/plat/map-s3c.h       |   84 +
 .../include/plat/map-s5p.h                         |    6 +-
 arch/arm/plat-samsung/include/plat/sdhci.h         |    7 +
 arch/arm/plat-samsung/platformdata.c               |   22 +
 arch/arm/plat-versatile/platsmp.c                  |    2 +-
 drivers/char/hw_random/Kconfig                     |   13 +
 drivers/char/hw_random/Makefile                    |    1 +
 drivers/char/hw_random/atmel-rng.c                 |  158 +
 drivers/clocksource/Kconfig                        |   15 +
 drivers/clocksource/Makefile                       |    1 +
 drivers/clocksource/clksrc-dbx500-prcmu.c          |  106 +
 drivers/gpio/gpio-mxc.c                            |   12 +
 drivers/gpio/gpio-mxs.c                            |    2 +
 drivers/gpio/gpio-pxa.c                            |    2 +-
 drivers/gpio/gpio-tegra.c                          |  143 +-
 drivers/misc/Kconfig                               |    2 +-
 drivers/mmc/host/davinci_mmc.c                     |   13 +
 drivers/mmc/host/mxcmmc.c                          |    1 +
 drivers/of/base.c                                  |   84 +
 drivers/of/irq.c                                   |  107 +
 drivers/pcmcia/pxa2xx_balloon3.c                   |    2 +-
 drivers/tty/serial/msm_serial.c                    |   30 +-
 drivers/usb/host/ohci-at91.c                       |  239 ++-
 drivers/video/mbx/mbxfb.c                          |    6 +-
 drivers/video/pxafb.c                              |   10 -
 include/linux/clksrc-dbx500-prcmu.h                |   20 +
 include/linux/irqdomain.h                          |   16 +-
 include/linux/of.h                                 |   18 +
 include/linux/of_irq.h                             |    3 +
 include/linux/rtc/sirfsoc_rtciobrg.h               |   18 +
 kernel/irq/irqdomain.c                             |   12 +-
 665 files changed, 24804 insertions(+), 14861 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/calxeda.txt
 create mode 100644 Documentation/devicetree/bindings/arm/fsl.txt
 create mode 100644 Documentation/devicetree/bindings/arm/gic.txt
 create mode 100644 Documentation/devicetree/bindings/arm/omap/dsp.txt
 create mode 100644 Documentation/devicetree/bindings/arm/omap/iva.txt
 create mode 100644 Documentation/devicetree/bindings/arm/omap/l3-noc.txt
 create mode 100644 Documentation/devicetree/bindings/arm/omap/mpu.txt
 create mode 100644 Documentation/devicetree/bindings/arm/omap/omap.txt
 create mode 100644 Documentation/devicetree/bindings/arm/picoxcell.txt
 create mode 100644 Documentation/devicetree/bindings/pinmux/pinmux_nvidia.txt
 create mode 100644 Documentation/devicetree/bindings/tty/serial/msm_serial.txt
 create mode 100644 arch/arm/boot/dts/at91sam9g20.dtsi
 create mode 100644 arch/arm/boot/dts/at91sam9g45.dtsi
 create mode 100644 arch/arm/boot/dts/at91sam9m10g45ek.dts
 create mode 100644 arch/arm/boot/dts/highbank.dts
 create mode 100644 arch/arm/boot/dts/imx51-babbage.dts
 create mode 100644 arch/arm/boot/dts/imx51.dtsi
 create mode 100644 arch/arm/boot/dts/imx53-ard.dts
 create mode 100644 arch/arm/boot/dts/imx53-evk.dts
 create mode 100644 arch/arm/boot/dts/imx53-qsb.dts
 create mode 100644 arch/arm/boot/dts/imx53-smd.dts
 create mode 100644 arch/arm/boot/dts/imx53.dtsi
 create mode 100644 arch/arm/boot/dts/imx6q-sabreauto.dts
 create mode 100644 arch/arm/boot/dts/imx6q.dtsi
 create mode 100644 arch/arm/boot/dts/msm8660-surf.dts
 create mode 100644 arch/arm/boot/dts/omap3-beagle.dts
 create mode 100644 arch/arm/boot/dts/omap3.dtsi
 create mode 100644 arch/arm/boot/dts/omap4-panda.dts
 create mode 100644 arch/arm/boot/dts/omap4-sdp.dts
 create mode 100644 arch/arm/boot/dts/omap4.dtsi
 create mode 100644 arch/arm/boot/dts/picoxcell-pc3x2.dtsi
 create mode 100644 arch/arm/boot/dts/picoxcell-pc3x3.dtsi
 create mode 100644 arch/arm/boot/dts/picoxcell-pc7302-pc3x2.dts
 create mode 100644 arch/arm/boot/dts/picoxcell-pc7302-pc3x3.dts
 create mode 100644 arch/arm/boot/dts/tegra-ventana.dts
 create mode 100644 arch/arm/boot/dts/usb_a9g20.dts
 create mode 100644 arch/arm/configs/at91sam9g45_defconfig
 rename arch/arm/configs/{mx27_defconfig => imx_v4_v5_defconfig} (69%)
 delete mode 100644 arch/arm/configs/mx1_defconfig
 delete mode 100644 arch/arm/configs/mx21_defconfig
 rename arch/arm/configs/{mx51_defconfig => mx5_defconfig} (82%)
 create mode 100644 arch/arm/mach-at91/board-dt.c
 create mode 100644 arch/arm/mach-at91/board-rsi-ews.c
 delete mode 100644 arch/arm/mach-at91/board-usb-a9260.c
 delete mode 100644 arch/arm/mach-at91/board-usb-a9263.c
 create mode 100644 arch/arm/mach-at91/board-usb-a926x.c
 create mode 100644 arch/arm/mach-ep93xx/vision_ep9307.c
 create mode 100644 arch/arm/mach-exynos4/clock-exynos4210.c
 create mode 100644 arch/arm/mach-exynos4/clock-exynos4212.c
 create mode 100644 arch/arm/mach-exynos4/include/mach/exynos4-clock.h
 create mode 100644 arch/arm/mach-exynos4/mach-origen.c
 create mode 100644 arch/arm/mach-exynos4/mach-smdk4x12.c
 delete mode 100644 arch/arm/mach-exynos4/mach-smdkc210.c
 create mode 100644 arch/arm/mach-highbank/Makefile
 create mode 100644 arch/arm/mach-highbank/Makefile.boot
 create mode 100644 arch/arm/mach-highbank/clock.c
 create mode 100644 arch/arm/mach-highbank/core.h
 create mode 100644 arch/arm/mach-highbank/highbank.c
 create mode 100644 arch/arm/mach-highbank/hotplug.c
 create mode 100644 arch/arm/mach-highbank/include/mach/debug-macro.S
 create mode 100644 arch/arm/mach-highbank/include/mach/entry-macro.S
 create mode 100644 arch/arm/mach-highbank/include/mach/gpio.h
 create mode 100644 arch/arm/mach-highbank/include/mach/io.h
 create mode 100644 arch/arm/mach-highbank/include/mach/irqs.h
 create mode 100644 arch/arm/mach-highbank/include/mach/memory.h
 create mode 100644 arch/arm/mach-highbank/include/mach/system.h
 create mode 100644 arch/arm/mach-highbank/include/mach/timex.h
 create mode 100644 arch/arm/mach-highbank/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-highbank/include/mach/vmalloc.h
 create mode 100644 arch/arm/mach-highbank/lluart.c
 create mode 100644 arch/arm/mach-highbank/localtimer.c
 create mode 100644 arch/arm/mach-highbank/platsmp.c
 create mode 100644 arch/arm/mach-highbank/pm.c
 create mode 100644 arch/arm/mach-highbank/sysregs.h
 create mode 100644 arch/arm/mach-highbank/system.c
 delete mode 100644 arch/arm/mach-imx/cache-l2x0.c
 create mode 100644 arch/arm/mach-imx/clock-imx6q.c
 create mode 100644 arch/arm/mach-imx/cpu-imx25.c
 create mode 100644 arch/arm/mach-imx/gpc.c
 create mode 100644 arch/arm/mach-imx/head-v7.S
 create mode 100644 arch/arm/mach-imx/hotplug.c
 create mode 100644 arch/arm/mach-imx/lluart.c
 create mode 100644 arch/arm/mach-imx/localtimer.c
 create mode 100644 arch/arm/mach-imx/mach-imx6q.c
 create mode 100644 arch/arm/mach-imx/mm-imx3.c
 delete mode 100644 arch/arm/mach-imx/mm-imx31.c
 delete mode 100644 arch/arm/mach-imx/mm-imx35.c
 create mode 100644 arch/arm/mach-imx/mmdc.c
 create mode 100644 arch/arm/mach-imx/platsmp.c
 create mode 100644 arch/arm/mach-imx/pm-imx6q.c
 create mode 100644 arch/arm/mach-imx/src.c
 create mode 100644 arch/arm/mach-ixp4xx/miccpt-pci.c
 create mode 100644 arch/arm/mach-ixp4xx/omixp-setup.c
 delete mode 100644 arch/arm/mach-mx5/devices.c
 delete mode 100644 arch/arm/mach-mx5/devices.h
 create mode 100644 arch/arm/mach-mx5/imx51-dt.c
 create mode 100644 arch/arm/mach-mx5/imx53-dt.c
 delete mode 100644 arch/arm/mach-mx5/mm-mx50.c
 create mode 100644 arch/arm/mach-mxs/devices/platform-mxs-saif.c
 create mode 100644 arch/arm/mach-mxs/devices/platform-rtc-stmp3xxx.c
 create mode 100644 arch/arm/mach-mxs/mach-m28evk.c
 delete mode 100644 arch/arm/mach-mxs/mm-mx28.c
 rename arch/arm/mach-mxs/{mm-mx23.c => mm.c} (75%)
 delete mode 100644 arch/arm/mach-nuc93x/Kconfig
 delete mode 100644 arch/arm/mach-nuc93x/Makefile
 delete mode 100644 arch/arm/mach-nuc93x/Makefile.boot
 delete mode 100644 arch/arm/mach-nuc93x/clock.c
 delete mode 100644 arch/arm/mach-nuc93x/clock.h
 delete mode 100644 arch/arm/mach-nuc93x/cpu.c
 delete mode 100644 arch/arm/mach-nuc93x/cpu.h
 delete mode 100644 arch/arm/mach-nuc93x/dev.c
 delete mode 100644 arch/arm/mach-nuc93x/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-nuc93x/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-nuc93x/include/mach/io.h
 delete mode 100644 arch/arm/mach-nuc93x/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-nuc93x/include/mach/map.h
 delete mode 100644 arch/arm/mach-nuc93x/include/mach/regs-clock.h
 delete mode 100644 arch/arm/mach-nuc93x/include/mach/regs-ebi.h
 delete mode 100644 arch/arm/mach-nuc93x/include/mach/regs-irq.h
 delete mode 100644 arch/arm/mach-nuc93x/include/mach/regs-serial.h
 delete mode 100644 arch/arm/mach-nuc93x/include/mach/regs-timer.h
 delete mode 100644 arch/arm/mach-nuc93x/include/mach/system.h
 delete mode 100644 arch/arm/mach-nuc93x/include/mach/timex.h
 delete mode 100644 arch/arm/mach-nuc93x/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-nuc93x/include/mach/vmalloc.h
 delete mode 100644 arch/arm/mach-nuc93x/irq.c
 delete mode 100644 arch/arm/mach-nuc93x/mach-nuc932evb.c
 delete mode 100644 arch/arm/mach-nuc93x/nuc932.c
 delete mode 100644 arch/arm/mach-nuc93x/nuc932.h
 delete mode 100644 arch/arm/mach-nuc93x/time.c
 create mode 100644 arch/arm/mach-omap1/timer.c
 create mode 100644 arch/arm/mach-omap2/clockdomains2420_data.c
 create mode 100644 arch/arm/mach-omap2/clockdomains2430_data.c
 create mode 100644 arch/arm/mach-omap2/clockdomains3xxx_data.c
 create mode 100644 arch/arm/mach-omap2/vc.c
 create mode 100644 arch/arm/mach-omap2/voltagedomains2xxx_data.c
 create mode 100644 arch/arm/mach-omap2/vp.c
 create mode 100644 arch/arm/mach-picoxcell/Makefile
 create mode 100644 arch/arm/mach-picoxcell/Makefile.boot
 create mode 100644 arch/arm/mach-picoxcell/common.c
 create mode 100644 arch/arm/mach-picoxcell/common.h
 create mode 100644 arch/arm/mach-picoxcell/include/mach/debug-macro.S
 create mode 100644 arch/arm/mach-picoxcell/include/mach/entry-macro.S
 create mode 100644 arch/arm/mach-picoxcell/include/mach/gpio.h
 create mode 100644 arch/arm/mach-picoxcell/include/mach/hardware.h
 create mode 100644 arch/arm/mach-picoxcell/include/mach/io.h
 create mode 100644 arch/arm/mach-picoxcell/include/mach/irqs.h
 create mode 100644 arch/arm/mach-picoxcell/include/mach/map.h
 create mode 100644 arch/arm/mach-picoxcell/include/mach/memory.h
 create mode 100644 arch/arm/mach-picoxcell/include/mach/picoxcell_soc.h
 create mode 100644 arch/arm/mach-picoxcell/include/mach/system.h
 create mode 100644 arch/arm/mach-picoxcell/include/mach/timex.h
 create mode 100644 arch/arm/mach-picoxcell/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-picoxcell/include/mach/vmalloc.h
 create mode 100644 arch/arm/mach-picoxcell/io.c
 create mode 100644 arch/arm/mach-picoxcell/time.c
 create mode 100644 arch/arm/mach-prima2/pm.c
 create mode 100644 arch/arm/mach-prima2/pm.h
 create mode 100644 arch/arm/mach-prima2/rtciobrg.c
 create mode 100644 arch/arm/mach-prima2/sleep.S
 create mode 100644 arch/arm/mach-pxa/include/mach/pxa95x.h
 delete mode 100644 arch/arm/mach-s3c2410/gpio.c
 delete mode 100644 arch/arm/mach-s3c2412/gpio.c
 create mode 100644 arch/arm/mach-ux500/cache-l2x0.c
 create mode 100644 arch/arm/mach-ux500/timer.c
 create mode 100644 arch/arm/plat-mxc/devices/platform-ahci-imx.c
 create mode 100644 arch/arm/plat-mxc/devices/platform-pata_imx.c
 create mode 100644 arch/arm/plat-mxc/gic.c
 create mode 100644 arch/arm/plat-mxc/include/mach/mx6q.h
 create mode 100644 arch/arm/plat-omap/include/plat/voltage.h
 delete mode 100644 arch/arm/plat-s3c24xx/include/plat/map.h
 create mode 100644 arch/arm/plat-samsung/cpu.c
 create mode 100644 arch/arm/plat-samsung/include/plat/map-s3c.h
 rename arch/arm/{plat-s5p => plat-samsung}/include/plat/map-s5p.h (94%)
 create mode 100644 drivers/char/hw_random/atmel-rng.c
 create mode 100644 drivers/clocksource/clksrc-dbx500-prcmu.c
 create mode 100644 include/linux/clksrc-dbx500-prcmu.h
 create mode 100644 include/linux/rtc/sirfsoc_rtciobrg.h
