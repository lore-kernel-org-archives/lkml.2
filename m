Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483Ab2CXWEQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 18:04:16 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60709 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549Ab2CXWDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 18:03:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL 09/09] ARM: device tree work
Date: Sat, 24 Mar 2012 22:02:48 +0000
Message-Id: <1332626568-17812-12-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1332626568-17812-1-git-send-email-arnd@arndb.de>
References: <1332626568-17812-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:c61ug2Ni2cp5ulN8RjgnU3AH3HWA5CqFilN/6Qg33+B
 mbxgLu3dJfkC4o6A0t540pg+UpzUog+l/KvWinU+pOZNd68qFd
 UTZluH6B1BLYsb4Ev5pNbBzouFBOPw+ABjpuAdb+fDANkKJuyR
 7CwBu3DUaaSSCBgpCGa2VBw5UBNZ8Gl7Y+4u+AbSGLN8TypBMT
 vc4+6YATTEs0QzBdKmZK478GA4w2N254+uQ4rAIVY4JaKWT+5o
 uUE4pB7zYQOHpYz0eA9GAkZtHroa4hxfSCGEAMNMVUegpbeuH2
 A6CLsOyU3Ww9lgV3thAr5ucXLbRdXIe+NnI1hVgx0soAx2qU++
 vU4dO4R/dk/JIdQjeL5xv8tRPH4sTJBRwp/0eQpZioVANHdyXJ
 vUpq08h4JE46Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of these patches convert code from using static platform data to
describing the hardware in the device tree. This is only the first
half of the changes for v3.4 because a lot of patches for this topic
came in the last week before the merge window.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

The following changes since commit "411a7a0 Merge branch 'next/dt'
into for-next", leading up to commit " cdc3df6 Merge branch 'dt-part2'
of git://git.kernel.org/pub/", are available in

git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/dt

Arnd Bergmann (9):
      Merge branch 'vexpress-dt-v3.3-rc4' of git://git.linaro.org/people/pawelmoll/linux into next/dt
      Merge branch 'imx/dt' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/dt
      Merge branch 'at91-3.4-base2+cleanup' of git://github.com/at91linux/linux-at91 into at91/staging/base2+cleanup
      Merge branch 'dt' of git://git.kernel.org/.../tmlind/linux-omap into next/dt
      Merge branches 'depends/irqdomain' and 'at91/base2+cleanup' into next/dt
      Merge branch 'at91-3.4-cleanup2+DT' of git://github.com/at91linux/linux-at91 into next/dt
      Merge branch 'features/imx27-dt' of git://git.pengutronix.de/git/imx/linux-2.6 into next/dt
      Merge tag 'tegra-dt' of git://git.kernel.org/.../olof/tegra into tegra/dt
      Merge branch 'next/dt' into for-next

Benoit Cousson (14):
      arm/dts: OMAP: Remove bootargs node from board files
      ARM: OMAP2+: kconfig: Enable devicetree by default for OMAP2+ systems
      ARM: OMAP2+: board-generic: Remove un-needed .atag_offset for DT_MACHINE
      ARM: OMAP2+: omap_device: Replace dev_warn by dev_dbg in omap_device_build_from_dt
      ARM: OMAP2+: pm: Do not init statically the SR and voltage layer with DT
      ARM: OMAP1: kconfig: Enable IRQ_DOMAIN by default for OMAP1 platforms
      arm/dts: OMAP3&4: Remove the '0x' prefix for serial nodes
      arm/dts: OMAP4: Add i2c controller nodes
      arm/dts: OMAP3: Add i2c controller nodes
      arm/dts: OMAP4: Update DTS file with new GIC bindings
      Merge branch 'irqdomain/next' of git://git.secretlab.ca/git/linux-2.6 into for_3.4/dt_irq_domain2
      ARM: OMAP2/3: intc: Add DT support for TI interrupt controller
      arm/dts: OMAP3: Add interrupt-controller bindings for INTC
      ARM: OMAP2+: board-generic: Use of_irq_init API

Haojian Zhuang (6):
      serial: pxa: add OF support
      i2c: pxa: add OF support
      ARM: mmp: enable rtc clk in pxa168
      ARM: mmp: append OF support on pxa168
      ARM: dts: append DTS file of pxa168
      Document: devicetree: add OF documents for arch-mmp

Ilya Yanok (1):
      arm/dts: mt_ventoux: very basic support for TeeJet Mt.Ventoux board

Jean-Christophe PLAGNIOL-VILLARD (24):
      ARM: at91: factorise duplicated at91sam9 idle
      ARM: at91/at91x40: remove use of at91_sys_read/write
      ARM: at91: make matrix register base soc independent
      ARM: at91: make ST (System Timer) soc independent
      ARM: at91/pm_slowclock: rename register to named define
      ARM: at91/pm_slowclock: function slow_clock() accepts parameters
      ARM: at91: move at91rm9200 sdramc defines to at91rm9200_sdramc.h
      ARM: at91: make sdram/ddr register base soc independent
      ARM: at91/pm_slowclock: add runtime detection of memory contoller
      ARM: at91/PMC: make register base soc independent
      ARM: at91/rtc-at91sam9: each SoC can select the RTT device to use
      ARM: at91:rtc/rtc-at91sam9: ioremap register bank
      ARM: at91/rtc-at91sam9: pass the GPBR to use via resources
      ARM: at91: finally drop at91_sys_read/write
      ARM: at91: merge SRAM Memory banks thanks to mirroring
      Atmel: move console default platform_device to serial driver
      ARM: at91/board-dt: drop default console
      ARM: at91: properly sort dtb files in Makefile.boot
      ARM: at91: pit add DT support
      ARM: at91: usb_a9g20/dt: add leds support
      ARM: at91: at91sam9m10g45ek/dt: add leds support
      ARM: at91: at91sam9m10g45ek/dt: add gpio-keys support
      ARM: at91: usb_a9g20/dt: add gpio-keys support
      ARM: at91: at91sam9x5cm/dt: add leds support

Leon Romanovsky (1):
      ASoC: DT: Add digital microphone binding to PAZ00 board.

Nicolas Ferre (22):
      Merge remote-tracking branch 'armsoc/at91/device-board' into at91-3.4-base2
      Merge remote-tracking branch 'armsoc/at91/9x5' into at91-3.4-base2
      ARM: at91/ST: remove not needed casts
      ARM: at91/PMC: move assignment out of printf
      ARM: at91: add at91sam9g25ek.dts in Makefile.boot
      Merge branch 'irqdomain/next' of git://git.secretlab.ca/git/linux-2.6
      ARM: at91/aic: add irq domain and device tree support
      ARM: at91/snapper9260: move gpio_to_irq out of structure initialization
      ARM/USB: at91/ohci-at91: remove the use of irq_to_gpio
      ARM: at91/gpio: change comments and one variable name
      ARM: at91/gpio: add irqdomain and DT support
      ARM: at91/gpio: non-DT builds do not have gpio_chip.of_node field
      ARM: at91/gpio: add .to_irq gpio_chip handler
      ARM: at91/gpio: remove the static specification of gpio_chip.base
      ARM: at91/board-dt: remove AIC irq domain from board file
      ARM: at91: AIC and GPIO IRQ device tree initialization
      ARM: at91/pit: add traces in case of error
      ARM: at91/tclib: take iomem size from resource
      ARM: at91/tc: add device tree support to atmel_tclib
      ARM: at91/tc/clocksource: Add 32 bit variant to Timer Counter
      ARM: at91: add sam9_smc.o to at91sam9x5 build
      ARM: at91/pio: add new PIO3 features

Olof Johansson (6):
      Merge branch 'at91-3.4-base' of git://github.com/at91linux/linux-at91 into at91/base
      Merge branch 'at91-3.4-base+device_board' of git://github.com/at91linux/linux-at91 into at91/device-board
      Merge branch 'at91-3.4-base+pm_cleanup' of git://github.com/at91linux/linux-at91 into at91/pm_cleanup
      Merge branch 'at91-3.4-base+9x5' of git://github.com/at91linux/linux-at91 into at91/9x5
      Merge branch 'dt' of git://github.com/hzhuang1/linux into next/dt
      Merge branch 'dt-part2' of git://git.kernel.org/.../tmlind/linux-omap into next/dt

Pawel Moll (6):
      ARM: vexpress: Use FDT data in platform SMP calls
      ARM: vexpress: Add Device Tree support
      ARM: vexpress: Motherboard RS1 memory map support
      ARM: vexpress: Add Device Tree for V2P-CA5s core tile
      ARM: vexpress: Add Device Tree for V2P-CA9 core tile
      ARM: vexpress: Add Device Tree for V2P-CA15 core tile (TC1 variant)

Richard Zhao (2):
      ARM: dts: imx6q-sabrelite: add 2p5v and 3p3v regulators
      ARM: dts: imx6q-sabrelite: add sgtl5000 audio codec

Sascha Hauer (4):
      ARM i.MX5/6: Add dt support for generic boards
      ARM i.MX27: Add devicetree support
      ARM i.MX: Add phytec phycore-i.MX27 (aka pcm038) devicetree support
      devicetree-bindings: Add documentation for i.MX generic boards

Shawn Guo (4):
      ARM: imx5: generate dtbs for imx5 boards
      ARM: dts: imx51-babbage: update mc13892 device
      ARM: dts: imx6q-arm2: add vmmc-supply for usdhc
      ARM: dts: imx6q-sabrelite: add vmmc-supply for usdhc

Stephen Warren (2):
      ARM: dt: Add SD controller configuration to Tegra Cardhu
      ARM: dt: Add ARM PMU to tegra*.dtsi

Tony Lindgren (6):
      Merge branch 'for_3.4/dt_base' of git://git.kernel.org/.../bcousson/linux-omap-dt into dt
      ARM: OMAP2+: Set Kconfig dependencies for PROC_DEVICETREE
      Merge branch 'for_3.4/dts_updates' of git://git.kernel.org/.../bcousson/linux-omap-dt into dt
      Merge branch 'for_3.4/dt_irq_domain' of git://git.kernel.org/.../bcousson/linux-omap-dt into dt-part2
      ARM: OMAP2+: Fix build error when only ARCH_OMAP2/3 or 4 is selected
      ARM: OMAP2+: Remove extra ifdefs for board-generic

Vaibhav Hiremath (1):
      arm/dts: Add support for TI OMAP3 EVM board


 .../devicetree/bindings/arm/atmel-aic.txt          |   38 ++
 .../devicetree/bindings/arm/atmel-at91.txt         |   32 +
 Documentation/devicetree/bindings/arm/fsl.txt      |   22 +
 Documentation/devicetree/bindings/arm/mrvl.txt     |    6 +
 .../devicetree/bindings/arm/omap/intc.txt          |   27 +
 Documentation/devicetree/bindings/arm/vexpress.txt |  146 +++++
 .../devicetree/bindings/gpio/gpio_atmel.txt        |   20 +
 .../devicetree/bindings/gpio/mrvl-gpio.txt         |   23 +
 Documentation/devicetree/bindings/i2c/mrvl-i2c.txt |   37 ++
 .../devicetree/bindings/rtc/sa1100-rtc.txt         |   17 +
 .../devicetree/bindings/serial/mrvl-serial.txt     |    4 +
 arch/arm/Kconfig                                   |    1 +
 arch/arm/boot/dts/am3517_mt_ventoux.dts            |   27 +
 arch/arm/boot/dts/at91sam9g20.dtsi                 |   68 ++-
 arch/arm/boot/dts/at91sam9g45.dtsi                 |   87 +++-
 arch/arm/boot/dts/at91sam9m10g45ek.dts             |   72 +++
 arch/arm/boot/dts/at91sam9x5.dtsi                  |   12 +-
 arch/arm/boot/dts/at91sam9x5cm.dtsi                |   15 +
 arch/arm/boot/dts/imx27-phytec-phycore.dts         |   76 +++
 arch/arm/boot/dts/imx27.dtsi                       |  217 +++++++
 arch/arm/boot/dts/imx51-babbage.dts                |   91 +++-
 arch/arm/boot/dts/imx6q-arm2.dts                   |   14 +
 arch/arm/boot/dts/imx6q-sabrelite.dts              |   34 ++
 arch/arm/boot/dts/omap3-beagle.dts                 |    9 -
 arch/arm/boot/dts/omap3-evm.dts                    |   20 +
 arch/arm/boot/dts/omap3.dtsi                       |   35 +-
 arch/arm/boot/dts/omap4-panda.dts                  |    9 -
 arch/arm/boot/dts/omap4-sdp.dts                    |    9 -
 arch/arm/boot/dts/omap4.dtsi                       |   38 +-
 arch/arm/boot/dts/pxa168-aspenite.dts              |   38 ++
 arch/arm/boot/dts/pxa168.dtsi                      |   98 +++
 arch/arm/boot/dts/tegra-cardhu.dts                 |   18 +
 arch/arm/boot/dts/tegra-paz00.dts                  |    3 +-
 arch/arm/boot/dts/tegra20.dtsi                     |    6 +
 arch/arm/boot/dts/tegra30.dtsi                     |    8 +
 arch/arm/boot/dts/usb_a9g20.dts                    |   23 +
 arch/arm/boot/dts/vexpress-v2m-rs1.dtsi            |  201 +++++++
 arch/arm/boot/dts/vexpress-v2m.dtsi                |  200 +++++++
 arch/arm/boot/dts/vexpress-v2p-ca15-tc1.dts        |  157 +++++
 arch/arm/boot/dts/vexpress-v2p-ca5s.dts            |  162 +++++
 arch/arm/boot/dts/vexpress-v2p-ca9.dts             |  192 ++++++
 arch/arm/mach-at91/Makefile                        |    2 +-
 arch/arm/mach-at91/Makefile.boot                   |    8 +-
 arch/arm/mach-at91/at91rm9200.c                    |    8 +-
 arch/arm/mach-at91/at91rm9200_devices.c            |   14 +-
 arch/arm/mach-at91/at91rm9200_time.c               |   37 +-
 arch/arm/mach-at91/at91sam9260.c                   |   30 +-
 arch/arm/mach-at91/at91sam9260_devices.c           |   59 ++-
 arch/arm/mach-at91/at91sam9261.c                   |   10 +-
 arch/arm/mach-at91/at91sam9261_devices.c           |   31 +-
 arch/arm/mach-at91/at91sam9263.c                   |   11 +-
 arch/arm/mach-at91/at91sam9263_devices.c           |   59 ++-
 arch/arm/mach-at91/at91sam926x_time.c              |   68 ++-
 arch/arm/mach-at91/at91sam9_alt_reset.S            |   12 +-
 arch/arm/mach-at91/at91sam9g45.c                   |   14 +-
 arch/arm/mach-at91/at91sam9g45_devices.c           |   52 ++-
 arch/arm/mach-at91/at91sam9g45_reset.S             |   12 +-
 arch/arm/mach-at91/at91sam9rl.c                    |   10 +-
 arch/arm/mach-at91/at91sam9rl_devices.c            |   31 +-
 arch/arm/mach-at91/at91sam9x5.c                    |    7 +-
 arch/arm/mach-at91/at91x40.c                       |    2 +-
 arch/arm/mach-at91/at91x40_time.c                  |   28 +-
 arch/arm/mach-at91/board-cpu9krea.c                |    5 +-
 arch/arm/mach-at91/board-cpuat91.c                 |    1 +
 arch/arm/mach-at91/board-dt.c                      |   20 +-
 arch/arm/mach-at91/board-eco920.c                  |    5 +-
 arch/arm/mach-at91/board-kb9202.c                  |    1 +
 arch/arm/mach-at91/board-picotux200.c              |    1 +
 arch/arm/mach-at91/board-rm9200dk.c                |    1 +
 arch/arm/mach-at91/board-rm9200ek.c                |    1 +
 arch/arm/mach-at91/board-snapper9260.c             |   10 +-
 arch/arm/mach-at91/board-yl-9200.c                 |    3 +-
 arch/arm/mach-at91/clock.c                         |   88 ++--
 arch/arm/mach-at91/generic.h                       |   16 +
 arch/arm/mach-at91/gpio.c                          |  625 +++++++++++++++++---
 arch/arm/mach-at91/include/mach/at91_matrix.h      |   23 +
 arch/arm/mach-at91/include/mach/at91_pio.h         |   25 +
 arch/arm/mach-at91/include/mach/at91_pmc.h         |   56 ++-
 arch/arm/mach-at91/include/mach/at91_ramc.h        |   32 +
 arch/arm/mach-at91/include/mach/at91_st.h          |   32 +-
 arch/arm/mach-at91/include/mach/at91rm9200.h       |   10 +-
 arch/arm/mach-at91/include/mach/at91rm9200_mc.h    |   58 +--
 .../arm/mach-at91/include/mach/at91rm9200_sdramc.h |   63 ++
 arch/arm/mach-at91/include/mach/at91sam9260.h      |   14 +-
 .../mach-at91/include/mach/at91sam9260_matrix.h    |   36 +-
 arch/arm/mach-at91/include/mach/at91sam9261.h      |   10 +-
 .../mach-at91/include/mach/at91sam9261_matrix.h    |   18 +-
 arch/arm/mach-at91/include/mach/at91sam9263.h      |   12 +-
 .../mach-at91/include/mach/at91sam9263_matrix.h    |   74 ++--
 arch/arm/mach-at91/include/mach/at91sam9_ddrsdr.h  |    6 -
 arch/arm/mach-at91/include/mach/at91sam9_sdramc.h  |    6 -
 arch/arm/mach-at91/include/mach/at91sam9g45.h      |   12 +-
 .../mach-at91/include/mach/at91sam9g45_matrix.h    |   84 ++--
 arch/arm/mach-at91/include/mach/at91sam9rl.h       |    7 +-
 .../arm/mach-at91/include/mach/at91sam9rl_matrix.h |   42 +-
 arch/arm/mach-at91/include/mach/at91sam9x5.h       |    5 +-
 arch/arm/mach-at91/include/mach/at91x40.h          |   18 +-
 arch/arm/mach-at91/include/mach/gpio.h             |   17 +-
 arch/arm/mach-at91/include/mach/hardware.h         |    3 +-
 arch/arm/mach-at91/include/mach/io.h               |   18 -
 arch/arm/mach-at91/irq.c                           |  132 ++++-
 arch/arm/mach-at91/pm.c                            |   35 +-
 arch/arm/mach-at91/pm.h                            |   11 +-
 arch/arm/mach-at91/pm_slowclock.S                  |  271 +++++----
 arch/arm/mach-at91/setup.c                         |    9 +
 arch/arm/mach-imx/Kconfig                          |    8 +
 arch/arm/mach-imx/Makefile                         |    1 +
 arch/arm/mach-imx/Makefile.boot                    |    3 +
 arch/arm/mach-imx/clock-imx27.c                    |   18 +
 arch/arm/mach-imx/imx27-dt.c                       |   89 +++
 arch/arm/mach-imx/imx51-dt.c                       |    1 +
 arch/arm/mach-imx/imx53-dt.c                       |    1 +
 arch/arm/mach-imx/mach-imx6q.c                     |    1 +
 arch/arm/mach-mmp/Kconfig                          |   10 +
 arch/arm/mach-mmp/Makefile                         |    1 +
 arch/arm/mach-mmp/mmp-dt.c                         |   75 +++
 arch/arm/mach-mmp/pxa168.c                         |    2 +
 arch/arm/mach-omap2/Kconfig                        |    1 -
 arch/arm/mach-omap2/board-generic.c                |  111 ++--
 arch/arm/mach-omap2/common.h                       |   12 +
 arch/arm/mach-omap2/irq.c                          |   60 ++-
 arch/arm/mach-omap2/pm.c                           |    8 +
 arch/arm/mach-vexpress/Kconfig                     |   47 ++-
 arch/arm/mach-vexpress/Makefile.boot               |    6 +
 arch/arm/mach-vexpress/core.h                      |    2 +
 arch/arm/mach-vexpress/include/mach/debug-macro.S  |   30 +-
 arch/arm/mach-vexpress/include/mach/irqs.h         |    2 +-
 arch/arm/mach-vexpress/include/mach/motherboard.h  |    6 +
 arch/arm/mach-vexpress/include/mach/uncompress.h   |   22 +-
 arch/arm/mach-vexpress/platsmp.c                   |  155 +++++-
 arch/arm/mach-vexpress/v2m.c                       |  213 +++++++-
 arch/arm/plat-mxc/include/mach/common.h            |    1 +
 arch/arm/plat-omap/Kconfig                         |    3 +
 arch/arm/plat-omap/omap_device.c                   |    2 +-
 arch/avr32/mach-at32ap/at32ap700x.c                |    2 -
 drivers/clocksource/tcb_clksrc.c                   |   90 ++-
 drivers/i2c/busses/i2c-pxa.c                       |   95 +++-
 drivers/misc/atmel_tclib.c                         |   64 ++-
 drivers/pcmcia/at91_cf.c                           |    5 +-
 drivers/rtc/rtc-at91sam9.c                         |   85 +--
 drivers/tty/serial/atmel_serial.c                  |    2 +
 drivers/tty/serial/pxa.c                           |   49 ++-
 drivers/usb/gadget/at91_udc.c                      |    9 +-
 drivers/usb/gadget/atmel_usba_udc.c                |    6 +-
 drivers/usb/host/ohci-at91.c                       |    5 +-
 drivers/watchdog/at91rm9200_wdt.c                  |    8 +-
 include/linux/atmel_tc.h                           |   10 +
 147 files changed, 5017 insertions(+), 1037 deletions(-)
