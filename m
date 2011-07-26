Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab1GZXZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 19:25:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52953 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab1GZXZg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 19:25:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>
Subject: [GIT PULL] arm-soc new features (part 1/2) for 3.1
Date: Wed, 27 Jul 2011 01:25:22 +0200
Message-ID: <1698068.Mn9Tmtfmzl@wuerfel>
User-Agent: KMail/4.6.0 (Linux/3.0.0-rc1nosema+; KDE/4.6.90; x86_64; ; )
In-Reply-To: <5818290.TCY0zMWmbr@wuerfel>
References: <3057645.NjCAYUXHGt@wuerfel> <2178768.MnKF3D4aeP@wuerfel> <5818290.TCY0zMWmbr@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:YHP2uRw8PRav7pdpFAkvVlJt53B4I3xUa7722tJlONr
 QPiREna3UHhk6sqF75zG93J7dxybR1BkW9ZL+GQTbo4Z1MoXRZ
 8mnZ6n0Rkj57YHT9sZOnjkeIv7f+cc0yfTI9GRoqbOcptgKQir
 6SVYvjnnVnjasdz08gbYEkAHJ/5M9tJCiyuyo1rs5iN1q1yp4R
 S3bXc4d0kPjUpJ/i7/mtg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the largest set of changes from arm-soc for 3.1, and unfortunately
causes a number of merge conflicts with branches you pulled earlier. 

The conflicts are all resolved in the for-next branch (which also contains
the other branches I submitted today), so if you like to resolve them
yourself, you can check if I came to the same conclusion. Alternatively,
I can send you a new branch that is already merged against your tree.

The changes in here are all over the ARM platforms, they mostly consist
of adding support for hardware in the platform code that has seen the
drivers getting added in other trees. This is to some degree churn that
shouldn't be necessary, but cannot be avoided completely as long as we
are still in the process of cleaning up the platforms to convert to
device tree probing form.

Some of the changes in here are also cleanups and other code that I would
have preferred to put in the other pull requests, but it's sometimes
hard to separate and we are still in the process of formalizing the rules
for this.

	Arnd

The following changes since commit ba5b56cb3e3d2cab73d4fee9a022bb69462a8cd9:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client (2011-07-26 13:38:50 -0700)

are available in the git repository at:

  git+ssh://master.kernel.org/pub/scm/linux/kernel/git/arm/linux-arm-soc.git/ next/devel


Andre Silva (7):
      ARM: mach-mx5/mx53_ard: Add support for i.MX53 ARD board
      ARM:mach-mx5/board-mx53_loco: Add CD and WP GPIOs
      ARM:mach-mx5/board-mx51_babbage: Add CD and WP GPIOs
      ARM:mach-mx5/mx53_ard: Add ESDHC support
      ARM:mach-mx5/mx53_ard: Add Watchdog timer support
      ARM:mx53: Add I2C3 support
      ARM:mach-mx5/mx53_ard: Add I2C2 and I2C3 support

Anton Vorontsov (1):
      ARM: cns3xxx: Add support for L2 Cache Controller

Arnd Bergmann (1):
      Merge branches 'cns3xxx/devel', 'davinci/devel', 'imx/devel', 'lpc32xx/devel', 'pxa/devel', 'tegra/devel' and 
'stericsson/master' of git+ssh://master.kernel.org/.../arm/linux-arm-soc into next/devel

Christian Riesch (1):
      davinci: da850: add a .set_rate method to ref_clk

Colin Cross (3):
      ARM: tegra: remove mach/barriers.h
      ARM: tegra: remove copy-and-pasted i2c platform data in boards
      ARM: tegra: remove copy-and-pasted usb platform data from boards

Daiane Angolini (1):
      ARM: mach-mx5/mx53_ard: Add gpio_keys support

Dinh Nguyen (1):
      ARM: mx51: Add support for low power suspend on MX51

Eric Miao (6):
      ARM: pxa: enable AUTO_ZRELADDR
      ARM: pxa: add common header file for pxa3xx
      ARM: pxa: avoid accessing interrupt registers directly
      ARM: pxa: introduce {icip,ichp}_handle_irq() to prepare MULTI_IRQ_HANDLER
      ARM: pxa: move declarations from generic.h to <soc>.h
      ARM: pxa: enable MULTI_IRQ_HANDLER for all boards

Fabio Estevam (11):
      ARM: mx5/mx53_loco: Add support for LED
      ARM: mx5/mx53_evk: Add support for LED
      ARM: mx53: Add SDMA clock
      ARM: mx53: Add SDMA support for MX53
      ARM: imx2: Fix GPIO iosize
      ARM: mach-imx/mx27_3ds: Add LCD support
      ARM: mach-imx/mx27_3ds: Add touchscreen support
      ARM: mx53: Add support for missing UARTs
      ARM: mx53: Add SSI suport
      ARM: mx53: Add keypad support
      ARM: mach-mx5/mx53_ard: Add missing definition

Haojian Zhuang (2):
      ARM: pxa: add clk_set_rate()
      ARM: mmp/dkb: enable max7312 gpio expander

Imre Kaloz (1):
      ARM: cns3xxx: Should select CPU_V6K

Jürgen Lambrecht (1):
      Enable RTC driver.

KOSAKI Motohiro (1):
      arm,tegra: replace cpu_set() with modern api

Linus Walleij (9):
      mach-ux500: add HREFv60 Kconfig option
      mach-ux500: fix HREFv60 regression
      mach-ux500: correct MMC/SDI parameters
      mach-ux500: activate USB in the U8500 defconfig
      mach-ux500: complete regulator constraints for MOP500 board
      mach-u300: cleanup clockevent code
      mach-u300: set apropriate FIFO trigger levels
      mach-ux500: register a clock for the SMP TWD
      mach-ux500: fix USB build error

Marc Dietrich (5):
      ARM: tegra: paz00: whitespace cleanup
      ARM: tegra: paz00: register i2c busses
      ARM: tegra: paz00: enable usb ports
      ARM: tegra: paz00: cleanup sdhci ports
      ARM: tegra: paz00: change the machine name

Mathieu J. Poirier (3):
      mach-ux500: setting proper uart for snowball
      mach-ux500: Add SDI support for snowball board
      mach-ux500: Kconfig for snowball board

Mattias Wallin (1):
      mach-ux500: iomap PRCMU TCDM memory

Mike Rapoport (3):
      ARM: tegra: trimslice: register i2c busses and devices
      ARM: tegra: trimslice: add audio devices and clocks
      ARM: tegra: trimslice: enable USB ports

Robert Marklund (4):
      mach-x500: fix SECTION warnings in uib
      mach-ux500: add basic support for snowball board
      mach-ux500: Add pin configuration for snowball board
      mach-ux500: add configs for snowball board

Robert Morell (1):
      arm: tegra: remove generic disp clock divisor flag

Russell King - ARM Linux (1):
      ARM: introduce handle_IRQ() not to dump exception stack

Sascha Hauer (1):
      Merge remote-tracking branch 'grant/gpio/next-mx' into devel-features

Sekhar Nori (4):
      davinci: pass clock flags to davinci_psc_config()
      davinci: enable forced transitions on PSC
      davinci: da850: add support for SATA interface
      davinci: da850 evm: register SATA device

Shawn Guo (5):
      ARM: mxs_defconfig: Add mx23evk and mx28evk build
      ARM: mxs/mx28evk: add leds-gpio device for heartbeat
      ARM: mxc: convert tzic to use generic irq chip
      ARM: mxc: clean up imx-dma device registration
      dmaengine: imx-sdma: pass sdma firmware name via platform data

Stephen Warren (1):
      ARM: Tegra: Seaboard: Re-order sdhci device registration

Tanmay Upadhyay (3):
      ARM: pxa168: Add support for UART3
      ARM: pxa168: Add support for Ethernet
      ARM: pxa168: Add board support for gplugD

Vasily Khoruzhick (1):
      ARM: pxa/z2: add poweroff function

Wolfram Sang (3):
      arm: mxs: add mmc-device for mach-tx28
      arm: lpc32xx: add tsc-device
      arm: lpc32xx: add rtc-device


 arch/arm/Kconfig                                 |    8 +-
 arch/arm/common/gic.c                            |    6 -
 arch/arm/configs/mxs_defconfig                   |    2 +
 arch/arm/configs/u8500_defconfig                 |   32 +-
 arch/arm/include/asm/hardware/gic.h              |    6 +
 arch/arm/include/asm/irq.h                       |    1 +
 arch/arm/kernel/irq.c                            |   19 +-
 arch/arm/mach-cns3xxx/cns3420vb.c                |    2 +
 arch/arm/mach-cns3xxx/core.c                     |   43 ++
 arch/arm/mach-cns3xxx/core.h                     |    6 +
 arch/arm/mach-davinci/board-da850-evm.c          |    7 +
 arch/arm/mach-davinci/clock.c                    |    8 +-
 arch/arm/mach-davinci/clock.h                    |    1 +
 arch/arm/mach-davinci/da850.c                    |   10 +
 arch/arm/mach-davinci/devices-da8xx.c            |  126 ++++
 arch/arm/mach-davinci/include/mach/da8xx.h       |    2 +
 arch/arm/mach-davinci/include/mach/psc.h         |    7 +-
 arch/arm/mach-davinci/psc.c                      |   14 +-
 arch/arm/mach-exynos4/Kconfig                    |   33 +-
 arch/arm/mach-exynos4/Makefile                   |   11 +-
 arch/arm/mach-exynos4/clock.c                    |   61 ++
 arch/arm/mach-exynos4/cpu.c                      |   39 +-
 arch/arm/mach-exynos4/dev-audio.c                |    2 +
 arch/arm/mach-exynos4/dev-dwmci.c                |   82 +++
 arch/arm/mach-exynos4/hotplug.c                  |   13 +-
 arch/arm/mach-exynos4/include/mach/dwmci.h       |   20 +
 arch/arm/mach-exynos4/include/mach/entry-macro.S |   11 +-
 arch/arm/mach-exynos4/include/mach/irqs.h        |  196 +++---
 arch/arm/mach-exynos4/include/mach/map.h         |   19 +-
 arch/arm/mach-exynos4/include/mach/pm-core.h     |   10 +
 arch/arm/mach-exynos4/include/mach/pmu.h         |   25 +
 arch/arm/mach-exynos4/include/mach/regs-audss.h  |   18 +
 arch/arm/mach-exynos4/include/mach/regs-clock.h  |   12 +
 arch/arm/mach-exynos4/include/mach/regs-pmu.h    |    1 +
 arch/arm/mach-exynos4/localtimer.c               |   26 -
 arch/arm/mach-exynos4/mach-nuri.c                |  753 +++++++++++++++++++++-
 arch/arm/mach-exynos4/mach-smdkc210.c            |   73 +++
 arch/arm/mach-exynos4/mach-smdkv310.c            |    3 +
 arch/arm/mach-exynos4/mach-universal_c210.c      |  121 ++++
 arch/arm/mach-exynos4/mct.c                      |    2 +-
 arch/arm/mach-exynos4/platsmp.c                  |   57 ++-
 arch/arm/mach-exynos4/pm.c                       |  248 +++++---
 arch/arm/mach-exynos4/pmu.c                      |  175 +++++
 arch/arm/mach-exynos4/setup-fimd0.c              |   43 ++
 arch/arm/mach-exynos4/time.c                     |  301 ---------
 arch/arm/mach-imx/Kconfig                        |    1 +
 arch/arm/mach-imx/mach-mx27_3ds.c                |   93 +++-
 arch/arm/mach-imx/mm-imx1.c                      |   10 +
 arch/arm/mach-imx/mm-imx21.c                     |   12 +
 arch/arm/mach-imx/mm-imx25.c                     |   32 +
 arch/arm/mach-imx/mm-imx27.c                     |   12 +
 arch/arm/mach-imx/mm-imx31.c                     |   33 +
 arch/arm/mach-imx/mm-imx35.c                     |   53 ++
 arch/arm/mach-lpc32xx/clock.c                    |    2 +-
 arch/arm/mach-lpc32xx/common.c                   |   42 ++
 arch/arm/mach-lpc32xx/common.h                   |    2 +
 arch/arm/mach-mmp/Kconfig                        |    7 +
 arch/arm/mach-mmp/Makefile                       |    1 +
 arch/arm/mach-mmp/clock.c                        |   15 +
 arch/arm/mach-mmp/clock.h                        |    1 +
 arch/arm/mach-mmp/gplugd.c                       |  189 ++++++
 arch/arm/mach-mmp/include/mach/mfp-gplugd.h      |   52 ++
 arch/arm/mach-mmp/include/mach/mfp-pxa168.h      |   19 +
 arch/arm/mach-mmp/include/mach/pxa168.h          |    8 +
 arch/arm/mach-mmp/include/mach/regs-apmu.h       |    1 +
 arch/arm/mach-mmp/pxa168.c                       |    6 +
 arch/arm/mach-mmp/ttc_dkb.c                      |   31 +-
 arch/arm/mach-mx5/Kconfig                        |   14 +
 arch/arm/mach-mx5/Makefile                       |    2 +
 arch/arm/mach-mx5/board-mx51_babbage.c           |   22 +-
 arch/arm/mach-mx5/board-mx53_ard.c               |  254 ++++++++
 arch/arm/mach-mx5/board-mx53_evk.c               |   17 +
 arch/arm/mach-mx5/board-mx53_loco.c              |   35 +-
 arch/arm/mach-mx5/clock-mx51-mx53.c              |   18 +
 arch/arm/mach-mx5/crm_regs.h                     |    2 +
 arch/arm/mach-mx5/devices-imx53.h                |    8 +
 arch/arm/mach-mx5/mm.c                           |   61 ++
 arch/arm/mach-mx5/pm-imx5.c                      |   73 +++
 arch/arm/mach-mxs/Kconfig                        |    2 +
 arch/arm/mach-mxs/mach-mx28evk.c                 |   21 +
 arch/arm/mach-mxs/mach-tx28.c                    |    6 +
 arch/arm/mach-pxa/balloon3.c                     |    1 +
 arch/arm/mach-pxa/capc7117.c                     |    1 +
 arch/arm/mach-pxa/clock.c                        |   15 +
 arch/arm/mach-pxa/clock.h                        |    1 +
 arch/arm/mach-pxa/cm-x2xx.c                      |    5 +-
 arch/arm/mach-pxa/cm-x300.c                      |    1 +
 arch/arm/mach-pxa/colibri-pxa270.c               |    2 +
 arch/arm/mach-pxa/colibri-pxa300.c               |    1 +
 arch/arm/mach-pxa/colibri-pxa320.c               |    4 +-
 arch/arm/mach-pxa/corgi.c                        |    3 +
 arch/arm/mach-pxa/csb726.c                       |    4 +-
 arch/arm/mach-pxa/em-x270.c                      |    2 +
 arch/arm/mach-pxa/eseries.c                      |    6 +
 arch/arm/mach-pxa/ezx.c                          |    6 +
 arch/arm/mach-pxa/generic.h                      |   13 -
 arch/arm/mach-pxa/gumstix.c                      |    1 +
 arch/arm/mach-pxa/h5000.c                        |    2 +
 arch/arm/mach-pxa/himalaya.c                     |    4 +-
 arch/arm/mach-pxa/hx4700.c                       |    1 +
 arch/arm/mach-pxa/icontrol.c                     |    1 +
 arch/arm/mach-pxa/idp.c                          |    1 +
 arch/arm/mach-pxa/include/mach/irqs.h            |   12 +
 arch/arm/mach-pxa/include/mach/pxa25x.h          |    9 +
 arch/arm/mach-pxa/include/mach/pxa27x.h          |    5 +
 arch/arm/mach-pxa/include/mach/pxa300.h          |    3 +-
 arch/arm/mach-pxa/include/mach/pxa320.h          |    3 +-
 arch/arm/mach-pxa/include/mach/pxa3xx.h          |   14 +
 arch/arm/mach-pxa/include/mach/pxa930.h          |    3 +-
 arch/arm/mach-pxa/include/mach/regs-intc.h       |   30 -
 arch/arm/mach-pxa/irq.c                          |   36 +-
 arch/arm/mach-pxa/littleton.c                    |    1 +
 arch/arm/mach-pxa/lpd270.c                       |    1 +
 arch/arm/mach-pxa/lubbock.c                      |    1 +
 arch/arm/mach-pxa/magician.c                     |    1 +
 arch/arm/mach-pxa/mainstone.c                    |    1 +
 arch/arm/mach-pxa/mioa701.c                      |    1 +
 arch/arm/mach-pxa/mp900.c                        |    1 +
 arch/arm/mach-pxa/palmld.c                       |    1 +
 arch/arm/mach-pxa/palmt5.c                       |    1 +
 arch/arm/mach-pxa/palmtc.c                       |    4 +-
 arch/arm/mach-pxa/palmte2.c                      |    3 +-
 arch/arm/mach-pxa/palmtreo.c                     |    2 +
 arch/arm/mach-pxa/palmtx.c                       |    1 +
 arch/arm/mach-pxa/palmz72.c                      |    1 +
 arch/arm/mach-pxa/pcm027.c                       |    1 +
 arch/arm/mach-pxa/poodle.c                       |    1 +
 arch/arm/mach-pxa/pxa3xx.c                       |    5 +-
 arch/arm/mach-pxa/pxa95x.c                       |    1 -
 arch/arm/mach-pxa/raumfeld.c                     |    8 +-
 arch/arm/mach-pxa/saar.c                         |    1 +
 arch/arm/mach-pxa/saarb.c                        |    1 +
 arch/arm/mach-pxa/spitz.c                        |    3 +
 arch/arm/mach-pxa/stargate2.c                    |    2 +
 arch/arm/mach-pxa/tavorevb.c                     |    1 +
 arch/arm/mach-pxa/tavorevb3.c                    |    1 +
 arch/arm/mach-pxa/tosa.c                         |    1 +
 arch/arm/mach-pxa/trizeps4.c                     |    2 +
 arch/arm/mach-pxa/viper.c                        |    1 +
 arch/arm/mach-pxa/vpac270.c                      |    1 +
 arch/arm/mach-pxa/xcep.c                         |    4 +-
 arch/arm/mach-pxa/z2.c                           |   18 +
 arch/arm/mach-pxa/zeus.c                         |    4 +-
 arch/arm/mach-pxa/zylonite.c                     |    3 +-
 arch/arm/mach-s3c2410/include/mach/pm-core.h     |    3 +
 arch/arm/mach-s3c64xx/include/mach/irqs.h        |    1 +
 arch/arm/mach-s3c64xx/include/mach/pm-core.h     |   19 +-
 arch/arm/mach-s3c64xx/irq.c                      |   12 +-
 arch/arm/mach-s5p64x0/Makefile                   |    2 +-
 arch/arm/mach-s5p64x0/include/mach/irqs.h        |    2 +
 arch/arm/mach-s5p64x0/include/mach/regs-gpio.h   |   10 +
 arch/arm/mach-s5p64x0/irq-eint.c                 |  152 +++++
 arch/arm/mach-s5pv210/Kconfig                    |    1 +
 arch/arm/mach-s5pv210/clock.c                    |    7 +
 arch/arm/mach-s5pv210/cpu.c                      |    2 +-
 arch/arm/mach-s5pv210/dev-audio.c                |    2 +
 arch/arm/mach-s5pv210/include/mach/map.h         |    3 +
 arch/arm/mach-s5pv210/include/mach/pm-core.h     |    3 +
 arch/arm/mach-s5pv210/include/mach/regs-audss.h  |   18 +
 arch/arm/mach-s5pv210/mach-goni.c                |   13 +
 arch/arm/mach-s5pv210/mach-smdkv210.c            |    1 +
 arch/arm/mach-tegra/board-harmony.c              |   22 -
 arch/arm/mach-tegra/board-paz00-pinmux.c         |   10 +-
 arch/arm/mach-tegra/board-paz00.c                |   31 +-
 arch/arm/mach-tegra/board-paz00.h                |   10 +-
 arch/arm/mach-tegra/board-seaboard.c             |   26 +-
 arch/arm/mach-tegra/board-trimslice-pinmux.c     |    7 +-
 arch/arm/mach-tegra/board-trimslice.c            |   56 ++
 arch/arm/mach-tegra/board-trimslice.h            |    3 +
 arch/arm/mach-tegra/devices.c                    |   53 ++-
 arch/arm/mach-tegra/include/mach/barriers.h      |   30 -
 arch/arm/mach-tegra/platsmp.c                    |    2 +-
 arch/arm/mach-tegra/tegra2_clocks.c              |    4 +-
 arch/arm/mach-u300/spi.c                         |    4 +-
 arch/arm/mach-u300/timer.c                       |   33 +-
 arch/arm/mach-ux500/Kconfig                      |   15 +-
 arch/arm/mach-ux500/board-mop500-pins.c          |   43 ++
 arch/arm/mach-ux500/board-mop500-regulators.c    |    9 +-
 arch/arm/mach-ux500/board-mop500-sdi.c           |   61 ++-
 arch/arm/mach-ux500/board-mop500-uib.c           |    2 +-
 arch/arm/mach-ux500/board-mop500.c               |  154 +++++-
 arch/arm/mach-ux500/board-mop500.h               |    5 +
 arch/arm/mach-ux500/clock.c                      |   48 ++
 arch/arm/mach-ux500/cpu-db5500.c                 |    1 +
 arch/arm/mach-ux500/include/mach/uncompress.h    |    3 +-
 arch/arm/mach-ux500/usb.c                        |    1 +
 arch/arm/mm/Kconfig                              |    2 +-
 arch/arm/plat-mxc/devices.c                      |   16 +-
 arch/arm/plat-mxc/devices/platform-imx-dma.c     |  204 +------
 arch/arm/plat-mxc/devices/platform-imx-i2c.c     |    3 +-
 arch/arm/plat-mxc/devices/platform-imx-keypad.c  |    5 +
 arch/arm/plat-mxc/devices/platform-imx-ssi.c     |   10 +
 arch/arm/plat-mxc/devices/platform-imx-uart.c    |    2 +
 arch/arm/plat-mxc/include/mach/devices-common.h  |    6 +
 arch/arm/plat-mxc/include/mach/mx53.h            |   28 +-
 arch/arm/plat-mxc/include/mach/sdma.h            |    6 +-
 arch/arm/plat-mxc/include/mach/uncompress.h      |    1 +
 arch/arm/plat-mxc/irq-common.c                   |   13 +-
 arch/arm/plat-mxc/tzic.c                         |   97 +--
 arch/arm/plat-s5p/Kconfig                        |   11 +
 arch/arm/plat-s5p/Makefile                       |    3 +-
 arch/arm/plat-s5p/dev-fimd0.c                    |   67 ++
 arch/arm/plat-s5p/dev-mfc.c                      |  123 ++++
 arch/arm/plat-s5p/include/plat/map-s5p.h         |    5 +-
 arch/arm/plat-s5p/include/plat/mfc.h             |   27 +
 arch/arm/plat-samsung/adc.c                      |   84 ++-
 arch/arm/plat-samsung/dev-asocdma.c              |   10 +
 arch/arm/plat-samsung/include/plat/audio.h       |    1 +
 arch/arm/plat-samsung/include/plat/devs.h        |    6 +
 arch/arm/plat-samsung/include/plat/fb-core.h     |   15 +
 arch/arm/plat-samsung/include/plat/fb.h          |   15 +
 arch/arm/plat-samsung/include/plat/regs-adc.h    |    1 +
 arch/arm/plat-samsung/irq-uart.c                 |    7 +
 arch/arm/plat-samsung/pm.c                       |    2 +
 drivers/dma/imx-sdma.c                           |    6 +-
 215 files changed, 4611 insertions(+), 1130 deletions(-)
