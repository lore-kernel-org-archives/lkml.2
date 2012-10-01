Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933Ab2JAX70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:59:26 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:57381 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758785Ab2JAX5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:57:39 -0400
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: =?UTF-8?q?=5BGIT=20PULL=205/12=5D=20ARM=3A=20soc=3A=20device=20tree=20updates?=
Date: Mon,  1 Oct 2012 16:57:00 -0700
Message-Id: <1349135827-24790-6-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.1.488.g05fbf7a
In-Reply-To: <1349135827-24790-1-git-send-email-olof@lixom.net>
References: <1349135827-24790-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device tree conversion and enablement branch. Mostly a bunch of new
bindings and setup for various platforms, but the Via/Winchip VT8500
platform is also converted over from being 100% legacy to now use
device tree for probing. More of that will come for 3.8.

Conflicts:
* Looks like Tony merged his bindings patch both through USB and our
  tree. Our version is a little cleaner, so keep that one.

* Lots of conflicts with removed files in vt8500, that should all be deleted.

----------------------------------------------------------------

The following changes since commit 6d55d5968a8622f3ea20ec40737aea1cfba6438c:

  Merge branch 'next/soc' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/dt

for you to fetch changes up to 99261fbad0a16f105b262d7525801697588ba526:

  Merge branch 'lpc32xx/dts' of git://git.antcom.de/linux-2.6 into next/dt

----------------------------------------------------------------

Aneesh V (3):
      Documentation: dt: device tree bindings for LPDDR2 memories
      Documentation: dt: emif: device tree bindings for TI's EMIF sdram controller
      ARM: dts: EMIF and LPDDR2 device tree data for OMAP4 boards

AnilKumar Ch (5):
      arm/dts: regulator: Add tps65910 device tree data
      arm/dts: regulator: Add tps65217 device tree data
      arm/dts: Add tps65910 regulator DT data to am335x-evm.dts
      arm/dts: Add tps65217 regulator DT data to am335x-bone.dts
      ARM: OMAP2+: select PINCTRL in Kconfig

Arnd Bergmann (2):
      Merge branch 'dt' of git://github.com/hzhuang1/linux into next/dt
      Merge branch 'dt' of git://github.com/hzhuang1/linux into next/dt

Balaji T K (1):
      arm/dts: omap5: Add mmc controller nodes and board data

Barry Song (3):
      ARM: PRIMA2: add missing interrupts property for pinctrl node
      ARM: PRIMA2: rename prima2-cb.dts to prima2.dtsi as it only has SoC features
      pinctrl: sirf: add DT-binding pinmux mapping support

Benoit Cousson (3):
      ARM: dts: OMAP4: Cleanup and move GIC outside of the OCP
      ARM: dts: omap3-beagle: Add heartbeat and mmc LEDs support
      ARM: dts: OMAP4: Add reg and interrupts for every nodes

Chao Xie (7):
      ARM: pxa: support CKENC in clk_enable
      gpio: pxa: add chain_eneter and chain_exit for irq handler
      ARM: cache: fix uninitialized ptr in tauros2_init
      ARM: cache: add cputype.h for tauros2
      ARM: cache: add extra feature enable for tauros2
      ARM: mmp&dove: modify tauros2_init call
      ARM: cache: add dt support for tauros2 cache

Daniel Mack (7):
      RTC: add DT bindings to pxa-rtc
      MTD: pxa3xx-nand: add devicetree bindings
      GPIO: gpio-pxa: simplify pxa_gpio_to_irq() and pxa_irq_to_chip()
      ARM: pxa: add devicetree code for irq handling
      ARM: pxa3xx: skip default device initialization when booting via DT
      ARM: pxa3xx: add generic DT machine code
      ARM: pxa: add .dtsi files

Dong Aisheng (1):
      ARM: mx28evk: add missed clkmux select for saif

Fabio Estevam (14):
      ARM: imx23-olinuxino.dts: Add AUART0 support
      ARM: mach-mxs: Remove board entries in dt_board_compat
      ARM: mxs: Rename 'hog-gpios'
      ARM: mxs: Let mmc0 pin detect be generic
      ARM: olinuxino: Add gpio-led support
      ARM: dts: imx: Always enable the watchdog
      ARM: dts: imx: Move SDMA firmware to SoC dtsi file
      ARM: mach-imx: Remove board entries in dt_board_compat
      ARM: mx28evk: Add SPI flash support
      ARM: mx28evk: Add LRADC support
      ARM: mx28evk: Add I2C EEPROM support
      ARM: imx6q-sabrelite: Rename 'pinctrl_gpio_hog'
      ARM: dts: mx23: Add USB resources
      ARM: dts: imx23-olinuxino: Add USB host support

Florian Vaussard (5):
      gpio/twl4030: get platform data from device tree
      ARM: dts: omap3: Add gpio-twl4030 properties for BeagleBoard and omap3-EVM
      ARM: dts: OMAP3: Add support for Gumstix Overo with Tobi expansion board
      Documentation: dt: Update the OMAP documentation with Overo/Toby
      ARM: dts: omap3-overo: Add support for the blue LED

Haojian Zhuang (5):
      ARM: mmp: enable tauros2 cache in pxa910
      ARM: mmp: enable tauros2 cache in mmp2 dt
      ARM: pxa: append the definition of CKENC
      mtd: nand: append missing parameter and value
      ARM: pxa: fix build issue while CONFIG_OF is disabled

Heiko Stuebner (1):
      gpio: samsung: add devicetree init for s3c24xx arches

Huang Shijie (1):
      ARM: imx6q: use pll2_pfd2_396m as the enfc_sel's parent

Laxman Dewangan (3):
      ARM: dt: tegra: cardhu: add entry for PMIC TPS65911.
      ARM: dt: tegra: cardhu: split dts file for support multiple board versions
      ARM: tegra: cardhu: add dt entry for fixed regulators

Lee Jones (39):
      ASoC: Ux500: Move MSP pinctrl setup into the MSP driver
      ASoC: Ux500: Enable MOP500 driver for Device Tree
      ASoC: Ux500: Enable ux500 MSP driver for Device Tree
      ASoC: codecs: Enable AB8500 CODEC for Device Tree
      ASoC: Ux500: Minor coding layout changes
      Documentation: Define the MOP500 Audio Machine Driver Device Tree bindings
      Documentation: Define the MSP Driver Device Tree bindings
      ARM: ux500: Rename db8500.dtsi to dbx5x0.dtsi to encompass the u9500, u8540 and u9540
      ARM: ux500: Clean-up temporary Device Tree enablement helpers
      ARM: ux500: Pass PMU platform data due for Perf though AUXDATA
      Documentation: Add the AB8500 CODEC device to the MFD AB8500 doc
      of/irq: Create stub for of_irq_find_parent when !CONFIG_OF
      ARM: ux500: Identify the PRCMU as an interrupt controller
      ARM: ux500: Force AB8500 to use the GIC as its interrupt controller
      Revert "input: ab8500-ponkey: Create AB8500 domain IRQ mapping"
      ARM: ux500: Remove unused snowball_of_platform_devs struct
      ARM: ux500: Match Power-On-Key MFD and DTS compatible strings
      drivers/rtc/rtc-ab8500.c: Revoke Device Tree enablement
      ARM: ux500: Add i2c configurations to the Device Tree for DB8500 based devices
      ARM: ux500: Add skeleton Device Tree for the HREF reference board
      ARM: ux500: Add UART support to the HREF Device Tree
      ARM: ux500: Pass SDI DMA information though AUX_DATA to MMCI
      ARM: ux500: Clean-up MSP platform code
      ARM: ux500: Add AB8500 CODEC node to DB8500 Device Tree
      ARM: ux500: Fork MSP platform registration for step-by-step DT enablement
      ARM: ux500: Pass MSP DMA platform data though AUXDATA
      ARM: ux500: Stop registering the MOP500 Audio driver from platform code
      ARM: ux500: Remove platform registration of MSP devices
      ARM: ux500: Rename MSP board file to something more meaningful
      ARM: ux500: Add nodes for the MSP into Device Tree
      ARM: ux500: Add all encompassing sound node to the Snowball Device Tree
      ARM: ux500: Stop registering Audio devices for HREF when DT is enabled
      ARM: ux500: Stop registering I2C sub-devices for HREF when DT is enabled
      ARM: ux500: Add all known I2C sub-device nodes to the HREF DT
      ARM: ux500: Add nodes for the MSP into the HREF Device Tree
      ARM: ux500: Add all encompassing sound node to the HREF Device Tree
      ARM: ux500: Remove redundant #gpio-cell properties from Snowball DT
      ARM: ux500: Apply tc3589x's GPIO/IRQ properties to HREF's DT
      ARM: ux500: Fix SSP register address format

Marek Vasut (7):
      ARM: dts: imx28: Add compatible and interrupt for LRADC
      ARM: mx28: Add SPI 2 pinmux into imx28.dtsi
      ARM: mx28: Add USB PHY overcurrent pinmux
      ARM: mxs: Update DENX M28 machine and dts file
      ARM: dts: m28evk: Fix MMC WP pin being inverted
      ARM: dts: mxs: Add ethernetX to macX aliases
      ARM: mxs: m28evk: Disable OCOTP OUI loading

Matt Sealey (3):
      ARM: efikamx: remove support for Genesi Efika MX from the build
      ARM: efikamx: remove Genesi Efika MX from the i.MX v6/v7 defconfig
      ARM: efikamx: remove Genesi Efika MX platform files from the tree

Maxime Ripard (8):
      ARM: dts: mxs: Add alternative I2C muxing options for imx28
      ARM: dts: mxs: Add pwm4 muxing options for imx28
      ARM: dts: mxs: Add I2C1 muxing options for imx28
      ARM: dts: mxs: Add the second I2C adapter to the CFA10049 expansion board
      ARM: dts: mxs: Enable USB1 Host on the CFA-10049 expansion board
      ARM: dts: mxs: Add missing address and size cells in SSP nodes
      ARM: dts: cfa10049: Add SSP3 to the 10049 board
      ARM: dts: cfa10049: Add the 74HC595 gpio expanders

Michael Grzeschik (1):
      ARM: dts: imx: add imx5x usb entries

Olof Johansson (23):
      ARM: omap: add dtb targets
      Merge branch 'soc-core' of git://git.kernel.org/.../horms/renesas into next/dt
      Merge branch 'pinmux-dt' of git://gitorious.org/sirfprima2-kernel/sirfprima2-kernel into next/dt
      Merge branch 'lpc32xx/dts' of git://git.antcom.de/linux-2.6 into next/dt
      Merge tag 'mxs-dt-3.7' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/dt
      Merge branch 'clk-3.7' of git://git.linaro.org/people/mturquette/linux into next/dt
      Merge tag 'mxs-clk-dt-lookup' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/dt
      Merge tag 'imx-dt-3.7' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/dt
      Merge tag 'imx-clk-dt-lookup' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/dt
      Merge branches 'msm/fixes-non-critical' and 'msm/cleanup' into next/dt
      Merge tag 'msm-dt-for-3.7' of git://git.kernel.org/.../davidb/linux-msm into next/dt
      Merge tag 'tegra-for-3.7-dt' of git://git.kernel.org/.../swarren/linux-tegra into next/dt
      Merge tag 'omap-devel-dt-merged-for-v3.7' of git://git.kernel.org/.../tmlind/linux-omap into next/dt
      Merge branch 'next/gpio-samsung' of git://git.kernel.org/.../kgene/linux-samsung into next/dt
      Merge tag 'tegra-for-3.7-dt2' of git://git.kernel.org/.../swarren/linux-tegra into next/dt
      Merge tag 'mxs-dt-3.7-2' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/dt
      Merge tag 'imx-dt-3.7-2' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/dt
      Merge branch 'for-arm-soc-next' of git://git.linaro.org/people/ljones/linux-3.0-ux500 into next/dt
      Merge tag 'vt8500-for-next' of git://git.code.sf.net/p/linuxwmt/code into next/dt
      Merge branch 'dt2' of git://github.com/hzhuang1/linux into next/dt
      Merge tag 'devel-dt-arch-timer-for-v3.7' of git://git.kernel.org/.../tmlind/linux-omap into next/dt
      Merge branch 'vt8500/devel' into next/dt
      Merge branch 'lpc32xx/dts' of git://git.antcom.de/linux-2.6 into next/dt

Peter Ujfalusi (9):
      ARM: OMAP: omap_device: Fix up resource names when booted with devicetree
      ARM: dts: omap2: Add McBSP entries for OMAP2420 and OMAP2430 SoC
      ARM: dts: omap2420-h4: Include omap2420.dtsi file instead the common omap2
      ARM: dts: omap3: Add McBSP entries
      ARM: dts: omap4: Add McBSP entries
      ARM: dts: omap4: Add reg-names for McPDM and DMIC
      ARM: dts: omap5: Add McBSP entries
      ARM: dts: omap5: Add McPDM and DMIC section to the dtsi file
      ARM: dts: omap3-beagle: Enable audio support

Rajendra Nayak (1):
      arm/dts: Cleanup regulator naming and remove @0,1

Richard Zhao (2):
      ARM: dts: imx6q-sabrelite: add usbmisc device
      ARM: dts: imx6q-sabrelite: add usbotg pinctrl support

Roland Stigge (3):
      ARM: LPC32xx: Adjust device tree node to new standard num-cs
      ARM: LPC32xx: Extend dts for EA3250 board
      ARM: LPC32xx: LED fix in PHY3250 DTS file

Santosh Shilimkar (4):
      ARM: OMAP4: Add L2 Cache Controller in Device Tree
      ARM: OMAP4: Add local timer support for Device Tree
      ARM: OMAP: Add initialisation for the real-time counter.
      ARM: OMAP5: Enable arch timer support

Shawn Guo (34):
      ARM: mxs: tx28: reset fec phy for device tree boot
      ARM: mxs: use auxdata to pass flexcan_switch function hook
      ARM: mxs: remove board files
      ARM: mxs: remove non-DT core functions
      ARM: mxs: remove platform device codes
      ARM: mxs: remove iomux driver
      Merge tag 'mxs-dt-3.7' into mxs/clk-dt-lookup
      clk: mxs: replace imx28 clk_register_clkdev with clock DT lookup
      clk: mxs: replace imx23 clk_register_clkdev with clock DT lookup
      ARM: dts: imx6q: improve indentation for fsl,pins
      ARM: dts: imx6q: name iomuxc sub-nodes following pin function
      ARM: dts: imx6q: sort iomuxc sub-nodes in name
      ARM: dts: imx6q-sabrelite: add pinctrl for usdhc and enet
      ARM: dts: imx6q-arm2: add pinctrl for uart and enet
      ARM: dts: imx6q-sabresd: add pinctrl settings
      ARM: imx6q: remove dummy pinctrl state
      ARM: dts: imx53-qsb: add pinctrl settings
      ARM: dts: imx53-ard: add pinctrl settings
      ARM: dts: imx53-evk: add pinctrl settings
      ARM: dts: imx53-smd: add pinctrl settings
      ARM: imx53: build in pinctrl support
      ARM: imx53: decouple device tree boot from board files
      ARM: imx53: support device tree boot only
      ARM: imx53: remove unneeded files and functions
      ARM: dts: imx51-babbage: add pinctrl settings
      ARM: imx51: build in pinctrl support
      ARM: imx51: decouple device tree boot from board files
      ARM: imx6q: replace clk_register_clkdev with clock DT lookup
      Merge tag 'mxs-dt-3.7' into mxs/dt-for-3.7-2
      Merge remote-tracking branch 'mturquette/clk-3.7' into mxs/dt-for-3.7-2
      Merge tag 'mxs-clk-dt-lookup' into mxs/dt-for-3.7-2
      Merge tag 'imx-dt-3.7' into imx/dt-for-3.7-2
      Merge remote-tracking branch 'mturquette/clk-3.7' into imx/dt-for-3.7-2
      Merge tag 'imx-clk-dt-lookup' into imx/dt-for-3.7-2

Sourav Poddar (6):
      ARM: dts: omap5-evm: Add I2C support
      ARM: dts: omap5-evm: Add tmp102 sensor support
      ARM: dts: omap5-evm: Add keypad data
      ARM: dts: omap5-evm: Add bmp085 sensor support
      ARM: dts: omap4-sdp: Add keypad data
      Documentation: dt: i2c: trivial-devices: Update for tmp102

Steffen Trumtrar (1):
      ARM i.MX53: dts: add flexcan to imx53

Stephen Boyd (11):
      ARM: msm: Add handle_irq handler for 8660 DT machine
      ARM: msm: Add msm8660-surf.dts to Makefile.boot
      ARM: msm: Don't touch GIC registers outside of GIC code
      ARM: msm: Allow timer.c to compile on multiple targets
      ARM: msm: Add DT support to msm_timer
      ARM: msm: Move 8660 to DT timer
      ARM: msm: Make 8660 a DT only target
      ARM: msm: Rename board-msm8x60 to signify its DT only status
      ARM: msm: Move io mapping prototypes to common.h
      ARM: msm: Add DT support for 8960
      ARM: msm: Remove non-DT targets from 8960

Stephen Warren (6):
      ARM: dt: tegra: seaboard: add regulators
      ARM: dt: tegra: ventana: add regulators
      ARM: dt: tegra: paz00: add regulators
      ARM: dt: tegra: whistler: add regulators
      ARM: dt: tegra: configure power off for some boards
      ARM: dt: tegra: whistler: configure power off

Tetsuyuki Kobayashi (1):
      ARM: mach-shmobile: Add compilation support for dtbs using 'make dtbs'

Thierry Reding (5):
      ARM: tegra: dts: Add pwm label
      ARM: tegra: Add Avionic Design Tamonten support
      ARM: tegra: Add Avionic Design Plutux support
      ARM: tegra: Add Avionic Design Medcom-Wide support
      ARM: tegra: Add Avionic Design Tamonten Evaluation Carrier support

Tony Lindgren (9):
      Merge branch 'devel-dt-regulator' into devel-dt
      Merge branch 'for_3.7/dts' of git://git.kernel.org/.../bcousson/linux-omap-dt into devel-dt
      arm/dts: Add omap36xx.dtsi file and rename omap3-beagle to omap3-beagle-xm
      arm/dts: Add pinctrl driver entries for omap2/3/4
      arm/dts: Mux uart pins for omap4-sdp
      Merge tag 'omap-cleanup-sparseirq-for-v3.7' into devel-dt
      Merge branch 'for_3.7/omap5_arch_timer' of git://github.com/SantoshShilimkar/linux into devel-dt-arch-timer
      Merge tag 'v3.6-rc6' into devel-dt
      Merge branch 'devel-dt-arch-timer' into devel-dt

Tony Prisk (9):
      arm: vt8500: Add device tree files for VIA/Wondermedia SoC's
      rtc: vt8500: Add devicetree support for vt8500-rtc
      serial: vt8500: Add devicetree support for vt8500-serial
      video: vt8500: Add devicetree support for vt8500-fb and wm8505-fb
      arm: vt8500: clk: Add Common Clock Framework support
      arm: vt8500: doc: Add device tree bindings for arch-vt8500 devices
      arm: vt8500: gpio: Devicetree support for arch-vt8500
      arm: vt8500: Update arch-vt8500 to devicetree support.
      arm: vt8500: Fixup for missing gpio.h

Uwe Kleine-König (1):
      ARM: imx/imx31-dt: drop selecting USE_OF

Vaibhav Hiremath (4):
      arm/dts: AM33XX: Set the default status of module to "disabled" state
      ARM: OMAP: omap_device: Do not overwrite resources allocated by OF layer
      ARM: dts: AM33XX: Convert all hex numbers to lower-case
      ARM: dts: AM33XX: Specify reg and interrupt property for all nodes

Zhangfei Gao (1):
      ARM: dt: mmp-dma: add binding file


 .../devicetree/bindings/arm/mrvl/tauros2.txt    |   17 +
 .../devicetree/bindings/arm/msm/timer.txt       |   38 +
 .../devicetree/bindings/arm/omap/omap.txt       |    3 +
 .../devicetree/bindings/arm/vt8500.txt          |   14 +
 .../bindings/arm/vt8500/via,vt8500-intc.txt     |   16 +
 .../bindings/arm/vt8500/via,vt8500-pmc.txt      |   13 +
 .../bindings/arm/vt8500/via,vt8500-timer.txt    |   15 +
 .../devicetree/bindings/clock/imx23-clock.txt   |   76 ++
 .../devicetree/bindings/clock/imx28-clock.txt   |   99 ++
 .../devicetree/bindings/clock/imx6q-clock.txt   |  222 ++++
 .../devicetree/bindings/clock/vt8500.txt        |   72 ++
 .../devicetree/bindings/dma/mmp-dma.txt         |   74 ++
 .../devicetree/bindings/gpio/gpio-samsung.txt   |   43 +
 .../devicetree/bindings/gpio/gpio-twl4030.txt   |    6 +
 .../devicetree/bindings/gpio/gpio-vt8500.txt    |   24 +
 .../devicetree/bindings/i2c/trivial-devices.txt |    1 +
 .../bindings/lpddr2/lpddr2-timings.txt          |   52 +
 .../devicetree/bindings/lpddr2/lpddr2.txt       |  102 ++
 .../bindings/memory-controllers/ti/emif.txt     |   55 +
 .../devicetree/bindings/mfd/ab8500.txt          |   15 +
 .../devicetree/bindings/mtd/pxa3xx-nand.txt     |   31 +
 .../devicetree/bindings/rtc/pxa-rtc.txt         |   14 +
 .../devicetree/bindings/rtc/via,vt8500-rtc.txt  |   15 +
 .../devicetree/bindings/sound/ux500-mop500.txt  |   39 +
 .../devicetree/bindings/sound/ux500-msp.txt     |   43 +
 .../bindings/tty/serial/via,vt8500-uart.txt     |   17 +
 .../devicetree/bindings/usb/platform-uhci.txt   |   21 +-
 .../devicetree/bindings/usb/via,vt8500-ehci.txt |   15 +
 .../devicetree/bindings/vendor-prefixes.txt     |    2 +
 .../devicetree/bindings/video/via,vt8500-fb.txt |   62 +
 .../bindings/video/wm,prizm-ge-rops.txt         |   13 +
 .../devicetree/bindings/video/wm,wm8505-fb.txt  |   23 +
 arch/arm/Kconfig                                |    7 +-
 arch/arm/boot/dts/am335x-bone.dts               |   60 +
 arch/arm/boot/dts/am335x-evm.dts                |  100 ++
 arch/arm/boot/dts/am33xx.dtsi                   |   71 +-
 arch/arm/boot/dts/{db8500.dtsi => dbx5x0.dtsi}  |   71 +-
 arch/arm/boot/dts/ea3250.dts                    |  109 +-
 arch/arm/boot/dts/elpida_ecb240abacn.dtsi       |   67 +
 arch/arm/boot/dts/hrefv60plus.dts               |   95 ++
 arch/arm/boot/dts/imx23-evk.dts                 |    3 +-
 arch/arm/boot/dts/imx23-olinuxino.dts           |   57 +
 arch/arm/boot/dts/imx23-stmp378x_devb.dts       |    2 +-
 arch/arm/boot/dts/imx23.dtsi                    |   38 +-
 arch/arm/boot/dts/imx27-phytec-phycore.dts      |    4 -
 arch/arm/boot/dts/imx27.dtsi                    |    1 -
 arch/arm/boot/dts/imx28-apx4devkit.dts          |    2 +-
 arch/arm/boot/dts/imx28-cfa10049.dts            |   99 ++
 arch/arm/boot/dts/imx28-evk.dts                 |   29 +-
 arch/arm/boot/dts/imx28-m28evk.dts              |   83 +-
 arch/arm/boot/dts/imx28-tx28.dts                |   23 +-
 arch/arm/boot/dts/imx28.dtsi                    |  123 +-
 arch/arm/boot/dts/imx51-babbage.dts             |   44 +-
 arch/arm/boot/dts/imx51.dtsi                    |  146 ++-
 arch/arm/boot/dts/imx53-ard.dts                 |   59 +-
 arch/arm/boot/dts/imx53-evk.dts                 |   39 +-
 arch/arm/boot/dts/imx53-qsb.dts                 |   42 +-
 arch/arm/boot/dts/imx53-smd.dts                 |   46 +-
 arch/arm/boot/dts/imx53.dtsi                    |  199 ++-
 arch/arm/boot/dts/imx6q-arm2.dts                |   21 +
 arch/arm/boot/dts/imx6q-sabrelite.dts           |   31 +-
 arch/arm/boot/dts/imx6q-sabresd.dts             |   25 +-
 arch/arm/boot/dts/imx6q.dtsi                    |  316 ++++-
 arch/arm/boot/dts/mmp2.dtsi                     |    5 +
 arch/arm/boot/dts/msm8660-surf.dts              |   19 +-
 arch/arm/boot/dts/msm8960-cdp.dts               |   41 +
 arch/arm/boot/dts/omap2420-h4.dts               |    2 +-
 arch/arm/boot/dts/omap2420.dtsi                 |   48 +
 arch/arm/boot/dts/omap2430.dtsi                 |   92 ++
 .../{omap3-beagle.dts => omap3-beagle-xm.dts}   |   54 +-
 arch/arm/boot/dts/omap3-evm.dts                 |   13 +
 arch/arm/boot/dts/omap3-overo.dtsi              |   57 +
 arch/arm/boot/dts/omap3-tobi.dts                |   35 +
 arch/arm/boot/dts/omap3.dtsi                    |   94 +-
 arch/arm/boot/dts/omap36xx.dtsi                 |   25 +
 arch/arm/boot/dts/omap4-panda.dts               |   11 +
 arch/arm/boot/dts/omap4-sdp.dts                 |  127 +-
 arch/arm/boot/dts/omap4.dtsi                    |  195 ++-
 arch/arm/boot/dts/omap5-evm.dts                 |   64 +
 arch/arm/boot/dts/omap5.dtsi                    |  139 ++
 arch/arm/boot/dts/phy3250.dts                   |   16 +-
 arch/arm/boot/dts/prima2-cb.dts                 |  424 ------
 arch/arm/boot/dts/prima2-evb.dts                |   37 +
 arch/arm/boot/dts/prima2.dtsi                   |  640 +++++++++
 arch/arm/boot/dts/pxa27x.dtsi                   |   14 +
 arch/arm/boot/dts/pxa2xx.dtsi                   |  132 ++
 arch/arm/boot/dts/pxa3xx.dtsi                   |   32 +
 arch/arm/boot/dts/pxa910.dtsi                   |    5 +
 arch/arm/boot/dts/snowball.dts                  |   19 +-
 arch/arm/boot/dts/tegra20-medcom-wide.dts       |   58 +
 arch/arm/boot/dts/tegra20-paz00.dts             |  173 +++
 arch/arm/boot/dts/tegra20-plutux.dts            |   50 +
 arch/arm/boot/dts/tegra20-seaboard.dts          |  186 +++
 arch/arm/boot/dts/tegra20-tamonten.dtsi         |  449 +++++++
 arch/arm/boot/dts/tegra20-tec.dts               |   53 +
 arch/arm/boot/dts/tegra20-ventana.dts           |  206 +++
 arch/arm/boot/dts/tegra20-whistler.dts          |  295 +++++
 arch/arm/boot/dts/tegra20.dtsi                  |    2 +-
 arch/arm/boot/dts/tegra30-cardhu-a02.dts        |   87 ++
 arch/arm/boot/dts/tegra30-cardhu-a04.dts        |   98 ++
 arch/arm/boot/dts/tegra30-cardhu.dts            |  171 ---
 arch/arm/boot/dts/tegra30-cardhu.dtsi           |  475 +++++++
 arch/arm/boot/dts/tegra30.dtsi                  |    2 +-
 arch/arm/boot/dts/tps65217.dtsi                 |   56 +
 arch/arm/boot/dts/tps65910.dtsi                 |   86 ++
 arch/arm/boot/dts/twl4030.dtsi                  |    6 +-
 arch/arm/boot/dts/twl6030.dtsi                  |   26 +-
 arch/arm/boot/dts/vt8500-bv07.dts               |   36 +
 arch/arm/boot/dts/vt8500.dtsi                   |  116 ++
 arch/arm/boot/dts/wm8505-ref.dts                |   36 +
 arch/arm/boot/dts/wm8505.dtsi                   |  143 ++
 arch/arm/boot/dts/wm8650-mid.dts                |   36 +
 arch/arm/boot/dts/wm8650.dtsi                   |  147 +++
 arch/arm/configs/imx_v6_v7_defconfig            |    4 +-
 arch/arm/configs/mxs_defconfig                  |    6 -
 arch/arm/configs/omap2plus_defconfig            |    1 +
 arch/arm/include/asm/hardware/cache-tauros2.h   |    5 +-
 arch/arm/mach-dove/common.c                     |    2 +-
 arch/arm/mach-imx/Kconfig                       |  106 +-
 arch/arm/mach-imx/Makefile                      |    9 +-
 arch/arm/mach-imx/Makefile.boot                 |    8 +-
 arch/arm/mach-imx/clk-imx6q.c                   |   51 +-
 arch/arm/mach-imx/devices-imx53.h               |   48 -
 arch/arm/mach-imx/efika.h                       |   10 -
 arch/arm/mach-imx/imx51-dt.c                    |   21 -
 arch/arm/mach-imx/{imx53-dt.c => mach-imx53.c}  |   27 -
 arch/arm/mach-imx/mach-imx6q.c                  |   11 -
 arch/arm/mach-imx/mach-mx51_efikamx.c           |  300 -----
 arch/arm/mach-imx/mach-mx51_efikasb.c           |  296 -----
 arch/arm/mach-imx/mach-mx53_ard.c               |  272 ----
 arch/arm/mach-imx/mach-mx53_evk.c               |  179 ---
 arch/arm/mach-imx/mach-mx53_loco.c              |  321 -----
 arch/arm/mach-imx/mach-mx53_smd.c               |  168 ---
 arch/arm/mach-imx/mm-imx5.c                     |   47 -
 arch/arm/mach-imx/mx51_efika.c                  |  633 ---------
 arch/arm/mach-mmp/mmp2.c                        |    2 +-
 arch/arm/mach-mmp/pxa910.c                      |    4 +
 arch/arm/mach-msm/Kconfig                       |   41 +-
 arch/arm/mach-msm/Makefile                      |    4 +-
 arch/arm/mach-msm/Makefile.boot                 |    3 +
 arch/arm/mach-msm/board-dt-8660.c               |   63 +
 arch/arm/mach-msm/board-dt-8960.c               |   49 +
 arch/arm/mach-msm/board-halibut.c               |    5 +-
 arch/arm/mach-msm/board-msm7x30.c               |    9 +-
 arch/arm/mach-msm/board-msm8960.c               |  122 --
 arch/arm/mach-msm/board-msm8x60.c               |  161 ---
 arch/arm/mach-msm/board-qsd8x50.c               |    7 +-
 arch/arm/mach-msm/board-trout.c                 |    5 +-
 arch/arm/mach-msm/common.h                      |   30 +
 arch/arm/mach-msm/devices-msm8960.c             |   85 --
 arch/arm/mach-msm/include/mach/board.h          |    3 -
 arch/arm/mach-msm/include/mach/msm_iomap-7x00.h |    7 -
 arch/arm/mach-msm/include/mach/msm_iomap-7x30.h |    4 -
 arch/arm/mach-msm/include/mach/msm_iomap-8960.h |    4 -
 arch/arm/mach-msm/include/mach/msm_iomap-8x50.h |    4 -
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h |    4 -
 arch/arm/mach-msm/io.c                          |    2 +
 arch/arm/mach-msm/platsmp.c                     |    8 -
 arch/arm/mach-msm/timer.c                       |  186 ++-
 arch/arm/mach-mxs/Kconfig                       |   89 --
 arch/arm/mach-mxs/Makefile                      |   11 +-
 arch/arm/mach-mxs/Makefile.boot                 |    1 +
 arch/arm/mach-mxs/devices-mx23.h                |   43 -
 arch/arm/mach-mxs/devices-mx28.h                |   63 -
 arch/arm/mach-mxs/devices.c                     |   87 --
 arch/arm/mach-mxs/devices/Kconfig               |   33 -
 arch/arm/mach-mxs/devices/Makefile              |   12 -
 arch/arm/mach-mxs/devices/platform-auart.c      |   65 -
 arch/arm/mach-mxs/devices/platform-dma.c        |   31 -
 arch/arm/mach-mxs/devices/platform-fec.c        |   52 -
 arch/arm/mach-mxs/devices/platform-flexcan.c    |   51 -
 arch/arm/mach-mxs/devices/platform-gpio-mxs.c   |   33 -
 arch/arm/mach-mxs/devices/platform-gpmi-nand.c  |   81 --
 arch/arm/mach-mxs/devices/platform-mxs-i2c.c    |   52 -
 arch/arm/mach-mxs/devices/platform-mxs-mmc.c    |   76 --
 arch/arm/mach-mxs/devices/platform-mxs-pwm.c    |   22 -
 arch/arm/mach-mxs/devices/platform-mxs-saif.c   |   61 -
 arch/arm/mach-mxs/devices/platform-mxsfb.c      |   47 -
 .../mach-mxs/devices/platform-rtc-stmp3xxx.c    |   51 -
 arch/arm/mach-mxs/include/mach/common.h         |    9 -
 arch/arm/mach-mxs/include/mach/devices-common.h |  114 --
 arch/arm/mach-mxs/include/mach/iomux-mx23.h     |  355 -----
 arch/arm/mach-mxs/include/mach/iomux-mx28.h     |  537 --------
 arch/arm/mach-mxs/include/mach/iomux.h          |  168 ---
 arch/arm/mach-mxs/iomux.c                       |  101 --
 arch/arm/mach-mxs/mach-apx4devkit.c             |  273 ----
 arch/arm/mach-mxs/mach-m28evk.c                 |  366 ------
 arch/arm/mach-mxs/mach-mx23evk.c                |  190 ---
 arch/arm/mach-mxs/mach-mx28evk.c                |  477 -------
 arch/arm/mach-mxs/mach-mxs.c                    |  140 +-
 arch/arm/mach-mxs/mach-stmp378x_devb.c          |  123 --
 arch/arm/mach-mxs/mach-tx28.c                   |  184 ---
 arch/arm/mach-mxs/mm.c                          |   39 -
 arch/arm/mach-mxs/module-tx28.c                 |  160 ---
 arch/arm/mach-mxs/module-tx28.h                 |   10 -
 arch/arm/mach-omap2/Kconfig                     |    6 +
 arch/arm/mach-omap2/Makefile.boot               |    6 +
 arch/arm/mach-omap2/omap4-common.c              |    5 +-
 arch/arm/mach-omap2/omap_hwmod.c                |   27 +
 arch/arm/mach-omap2/timer.c                     |  103 +-
 arch/arm/mach-prima2/Makefile.boot              |    2 +
 arch/arm/mach-pxa/Kconfig                       |   12 +
 arch/arm/mach-pxa/Makefile                      |    3 +
 arch/arm/mach-pxa/clock-pxa3xx.c                |    8 +-
 arch/arm/mach-pxa/include/mach/pxa3xx-regs.h    |    1 +
 arch/arm/mach-pxa/irq.c                         |  131 +-
 arch/arm/mach-pxa/pxa-dt.c                      |   63 +
 arch/arm/mach-pxa/pxa3xx.c                      |   23 +-
 arch/arm/mach-shmobile/Makefile.boot            |    4 +
 arch/arm/mach-tegra/Makefile.boot               |    6 +-
 arch/arm/mach-ux500/Makefile                    |    2 +-
 ...{board-mop500-msp.c => board-mop500-audio.c} |  102 +-
 arch/arm/mach-ux500/board-mop500-msp.h          |   14 -
 arch/arm/mach-ux500/board-mop500-sdi.c          |    4 +-
 arch/arm/mach-ux500/board-mop500.c              |   39 +-
 arch/arm/mach-ux500/board-mop500.h              |   11 +
 arch/arm/mach-ux500/cpu-db8500.c                |   10 +-
 arch/arm/mach-ux500/include/mach/msp.h          |    2 -
 arch/arm/mach-vt8500/Kconfig                    |   73 --
 arch/arm/mach-vt8500/Makefile                   |    8 +-
 arch/arm/mach-vt8500/bv07.c                     |   81 --
 arch/arm/mach-vt8500/common.h                   |   28 +
 arch/arm/mach-vt8500/devices-vt8500.c           |   96 --
 arch/arm/mach-vt8500/devices-wm8505.c           |  103 --
 arch/arm/mach-vt8500/devices.c                  |  281 ----
 arch/arm/mach-vt8500/devices.h                  |   89 --
 arch/arm/mach-vt8500/gpio.c                     |  240 ----
 arch/arm/mach-vt8500/include/mach/restart.h     |    4 +-
 arch/arm/mach-vt8500/include/mach/vt8500_irqs.h |   88 --
 arch/arm/mach-vt8500/include/mach/vt8500_regs.h |   79 --
 arch/arm/mach-vt8500/include/mach/wm8505_irqs.h |  115 --
 arch/arm/mach-vt8500/include/mach/wm8505_regs.h |   78 --
 arch/arm/mach-vt8500/irq.c                      |  209 +--
 arch/arm/mach-vt8500/restart.c                  |   54 -
 arch/arm/mach-vt8500/timer.c                    |   67 +-
 arch/arm/mach-vt8500/vt8500.c                   |  195 +++
 arch/arm/mach-vt8500/wm8505_7in.c               |   80 --
 arch/arm/mm/cache-tauros2.c                     |   83 +-
 arch/arm/plat-mxc/include/mach/common.h         |    6 -
 arch/arm/plat-mxc/include/mach/iomux-mx53.h     | 1219 ------------------
 arch/arm/plat-omap/include/plat/omap_hwmod.h    |    1 +
 arch/arm/plat-omap/omap_device.c                |   79 +-
 drivers/clk/Makefile                            |    1 +
 drivers/clk/clk-vt8500.c                        |  510 ++++++++
 drivers/clk/mxs/clk-imx23.c                     |   55 +-
 drivers/clk/mxs/clk-imx28.c                     |  113 +-
 drivers/gpio/Kconfig                            |    6 +
 drivers/gpio/Makefile                           |    1 +
 drivers/gpio/gpio-pxa.c                         |   77 +-
 drivers/gpio/gpio-samsung.c                     |   63 +
 drivers/gpio/gpio-twl4030.c                     |   77 +-
 drivers/gpio/gpio-vt8500.c                      |  316 +++++
 drivers/mtd/nand/pxa3xx_nand.c                  |   87 +-
 drivers/pinctrl/pinctrl-sirf.c                  |   58 +-
 drivers/rtc/rtc-ab8500.c                        |    6 -
 drivers/rtc/rtc-pxa.c                           |   11 +
 drivers/rtc/rtc-vt8500.c                        |    9 +-
 drivers/tty/serial/vt8500_serial.c              |   58 +-
 drivers/video/Kconfig                           |    6 +-
 drivers/video/vt8500lcdfb.c                     |   79 +-
 drivers/video/wm8505fb.c                        |   97 +-
 drivers/video/wmt_ge_rops.c                     |    9 +-
 include/linux/mfd/abx500/ab8500-codec.h         |    6 +-
 include/linux/of_irq.h                          |    5 +
 sound/soc/codecs/ab8500-codec.c                 |   81 ++
 sound/soc/ux500/mop500.c                        |   47 +-
 sound/soc/ux500/ux500_msp_dai.c                 |    6 +
 sound/soc/ux500/ux500_msp_i2s.c                 |   89 +-
 sound/soc/ux500/ux500_msp_i2s.h                 |    8 +-
 269 files changed, 10743 insertions(+), 11219 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/mrvl/tauros2.txt
 create mode 100644 Documentation/devicetree/bindings/arm/msm/timer.txt
 create mode 100644 Documentation/devicetree/bindings/arm/vt8500.txt
 create mode 100644 Documentation/devicetree/bindings/arm/vt8500/via,vt8500-intc.txt
 create mode 100644 Documentation/devicetree/bindings/arm/vt8500/via,vt8500-pmc.txt
 create mode 100644 Documentation/devicetree/bindings/arm/vt8500/via,vt8500-timer.txt
 create mode 100644 Documentation/devicetree/bindings/clock/imx23-clock.txt
 create mode 100644 Documentation/devicetree/bindings/clock/imx28-clock.txt
 create mode 100644 Documentation/devicetree/bindings/clock/imx6q-clock.txt
 create mode 100644 Documentation/devicetree/bindings/clock/vt8500.txt
 create mode 100644 Documentation/devicetree/bindings/dma/mmp-dma.txt
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-vt8500.txt
 create mode 100644 Documentation/devicetree/bindings/lpddr2/lpddr2-timings.txt
 create mode 100644 Documentation/devicetree/bindings/lpddr2/lpddr2.txt
 create mode 100644 Documentation/devicetree/bindings/memory-controllers/ti/emif.txt
 create mode 100644 Documentation/devicetree/bindings/mtd/pxa3xx-nand.txt
 create mode 100644 Documentation/devicetree/bindings/rtc/pxa-rtc.txt
 create mode 100644 Documentation/devicetree/bindings/rtc/via,vt8500-rtc.txt
 create mode 100644 Documentation/devicetree/bindings/sound/ux500-mop500.txt
 create mode 100644 Documentation/devicetree/bindings/sound/ux500-msp.txt
 create mode 100644 Documentation/devicetree/bindings/tty/serial/via,vt8500-uart.txt
 create mode 100644 Documentation/devicetree/bindings/usb/via,vt8500-ehci.txt
 create mode 100644 Documentation/devicetree/bindings/video/via,vt8500-fb.txt
 create mode 100644 Documentation/devicetree/bindings/video/wm,prizm-ge-rops.txt
 create mode 100644 Documentation/devicetree/bindings/video/wm,wm8505-fb.txt
 rename arch/arm/boot/dts/{db8500.dtsi => dbx5x0.dtsi} (88%)
 create mode 100644 arch/arm/boot/dts/elpida_ecb240abacn.dtsi
 create mode 100644 arch/arm/boot/dts/hrefv60plus.dts
 create mode 100644 arch/arm/boot/dts/imx28-cfa10049.dts
 create mode 100644 arch/arm/boot/dts/msm8960-cdp.dts
 create mode 100644 arch/arm/boot/dts/omap2420.dtsi
 create mode 100644 arch/arm/boot/dts/omap2430.dtsi
 rename arch/arm/boot/dts/{omap3-beagle.dts => omap3-beagle-xm.dts} (52%)
 create mode 100644 arch/arm/boot/dts/omap3-overo.dtsi
 create mode 100644 arch/arm/boot/dts/omap3-tobi.dts
 create mode 100644 arch/arm/boot/dts/omap36xx.dtsi
 delete mode 100644 arch/arm/boot/dts/prima2-cb.dts
 create mode 100644 arch/arm/boot/dts/prima2-evb.dts
 create mode 100644 arch/arm/boot/dts/prima2.dtsi
 create mode 100644 arch/arm/boot/dts/pxa27x.dtsi
 create mode 100644 arch/arm/boot/dts/pxa2xx.dtsi
 create mode 100644 arch/arm/boot/dts/pxa3xx.dtsi
 create mode 100644 arch/arm/boot/dts/tegra20-medcom-wide.dts
 create mode 100644 arch/arm/boot/dts/tegra20-plutux.dts
 create mode 100644 arch/arm/boot/dts/tegra20-tamonten.dtsi
 create mode 100644 arch/arm/boot/dts/tegra20-tec.dts
 create mode 100644 arch/arm/boot/dts/tegra30-cardhu-a02.dts
 create mode 100644 arch/arm/boot/dts/tegra30-cardhu-a04.dts
 delete mode 100644 arch/arm/boot/dts/tegra30-cardhu.dts
 create mode 100644 arch/arm/boot/dts/tegra30-cardhu.dtsi
 create mode 100644 arch/arm/boot/dts/tps65217.dtsi
 create mode 100644 arch/arm/boot/dts/tps65910.dtsi
 create mode 100644 arch/arm/boot/dts/vt8500-bv07.dts
 create mode 100644 arch/arm/boot/dts/vt8500.dtsi
 create mode 100644 arch/arm/boot/dts/wm8505-ref.dts
 create mode 100644 arch/arm/boot/dts/wm8505.dtsi
 create mode 100644 arch/arm/boot/dts/wm8650-mid.dts
 create mode 100644 arch/arm/boot/dts/wm8650.dtsi
 delete mode 100644 arch/arm/mach-imx/devices-imx53.h
 delete mode 100644 arch/arm/mach-imx/efika.h
 rename arch/arm/mach-imx/{imx53-dt.c => mach-imx53.c} (81%)
 delete mode 100644 arch/arm/mach-imx/mach-mx51_efikamx.c
 delete mode 100644 arch/arm/mach-imx/mach-mx51_efikasb.c
 delete mode 100644 arch/arm/mach-imx/mach-mx53_ard.c
 delete mode 100644 arch/arm/mach-imx/mach-mx53_evk.c
 delete mode 100644 arch/arm/mach-imx/mach-mx53_loco.c
 delete mode 100644 arch/arm/mach-imx/mach-mx53_smd.c
 delete mode 100644 arch/arm/mach-imx/mx51_efika.c
 create mode 100644 arch/arm/mach-msm/board-dt-8660.c
 create mode 100644 arch/arm/mach-msm/board-dt-8960.c
 delete mode 100644 arch/arm/mach-msm/board-msm8960.c
 delete mode 100644 arch/arm/mach-msm/board-msm8x60.c
 create mode 100644 arch/arm/mach-msm/common.h
 delete mode 100644 arch/arm/mach-msm/devices-msm8960.c
 delete mode 100644 arch/arm/mach-mxs/devices-mx23.h
 delete mode 100644 arch/arm/mach-mxs/devices-mx28.h
 delete mode 100644 arch/arm/mach-mxs/devices.c
 delete mode 100644 arch/arm/mach-mxs/devices/Kconfig
 delete mode 100644 arch/arm/mach-mxs/devices/Makefile
 delete mode 100644 arch/arm/mach-mxs/devices/platform-auart.c
 delete mode 100644 arch/arm/mach-mxs/devices/platform-dma.c
 delete mode 100644 arch/arm/mach-mxs/devices/platform-fec.c
 delete mode 100644 arch/arm/mach-mxs/devices/platform-flexcan.c
 delete mode 100644 arch/arm/mach-mxs/devices/platform-gpio-mxs.c
 delete mode 100644 arch/arm/mach-mxs/devices/platform-gpmi-nand.c
 delete mode 100644 arch/arm/mach-mxs/devices/platform-mxs-i2c.c
 delete mode 100644 arch/arm/mach-mxs/devices/platform-mxs-mmc.c
 delete mode 100644 arch/arm/mach-mxs/devices/platform-mxs-pwm.c
 delete mode 100644 arch/arm/mach-mxs/devices/platform-mxs-saif.c
 delete mode 100644 arch/arm/mach-mxs/devices/platform-mxsfb.c
 delete mode 100644 arch/arm/mach-mxs/devices/platform-rtc-stmp3xxx.c
 delete mode 100644 arch/arm/mach-mxs/include/mach/devices-common.h
 delete mode 100644 arch/arm/mach-mxs/include/mach/iomux-mx23.h
 delete mode 100644 arch/arm/mach-mxs/include/mach/iomux-mx28.h
 delete mode 100644 arch/arm/mach-mxs/include/mach/iomux.h
 delete mode 100644 arch/arm/mach-mxs/iomux.c
 delete mode 100644 arch/arm/mach-mxs/mach-apx4devkit.c
 delete mode 100644 arch/arm/mach-mxs/mach-m28evk.c
 delete mode 100644 arch/arm/mach-mxs/mach-mx23evk.c
 delete mode 100644 arch/arm/mach-mxs/mach-mx28evk.c
 delete mode 100644 arch/arm/mach-mxs/mach-stmp378x_devb.c
 delete mode 100644 arch/arm/mach-mxs/mach-tx28.c
 delete mode 100644 arch/arm/mach-mxs/module-tx28.c
 delete mode 100644 arch/arm/mach-mxs/module-tx28.h
 create mode 100644 arch/arm/mach-pxa/pxa-dt.c
 rename arch/arm/mach-ux500/{board-mop500-msp.c => board-mop500-audio.c} (66%)
 delete mode 100644 arch/arm/mach-ux500/board-mop500-msp.h
 delete mode 100644 arch/arm/mach-vt8500/Kconfig
 delete mode 100644 arch/arm/mach-vt8500/bv07.c
 create mode 100644 arch/arm/mach-vt8500/common.h
 delete mode 100644 arch/arm/mach-vt8500/devices-vt8500.c
 delete mode 100644 arch/arm/mach-vt8500/devices-wm8505.c
 delete mode 100644 arch/arm/mach-vt8500/devices.c
 delete mode 100644 arch/arm/mach-vt8500/devices.h
 delete mode 100644 arch/arm/mach-vt8500/gpio.c
 delete mode 100644 arch/arm/mach-vt8500/include/mach/vt8500_irqs.h
 delete mode 100644 arch/arm/mach-vt8500/include/mach/vt8500_regs.h
 delete mode 100644 arch/arm/mach-vt8500/include/mach/wm8505_irqs.h
 delete mode 100644 arch/arm/mach-vt8500/include/mach/wm8505_regs.h
 delete mode 100644 arch/arm/mach-vt8500/restart.c
 create mode 100644 arch/arm/mach-vt8500/vt8500.c
 delete mode 100644 arch/arm/mach-vt8500/wm8505_7in.c
 delete mode 100644 arch/arm/plat-mxc/include/mach/iomux-mx53.h
 create mode 100644 drivers/clk/clk-vt8500.c
 create mode 100644 drivers/gpio/gpio-vt8500.c
