Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab1KBCXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 22:23:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55650 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab1KBCXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 22:23:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL 8/13] arm-soc general updates
Date: Tue, 1 Nov 2011 04:51:13 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <201111010348.13214.arnd@arndb.de>
In-Reply-To: <201111010348.13214.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201111010451.13903.arnd@arndb.de>
X-Provags-ID: V02:K0:3S+L5IwOmNbNrkAUI0B6bB4y4+pJkIT9yVKk8Lo9NVk
 Snt+KOlyPquuNii5S+NdprPWT3QXBV+xXoT6TSaYqn3jLU0Nsn
 jSevzUaVgutkgAbBMavnJOXE11bpGQ9SJEFQO9lcP47TgCRXU0
 xmplTSrYsfTRg1zAWfbtY7jmU1D4MuZiBKlHbl4w2qefnoLB8b
 hK4vuddTi3VOaFNm8HNkfihuOmI98sVuiIB9KZYGwRLNRp5dtJ
 aLMEB5tEAxpYQq+w1NBXTxG3cNBe83MnSJiUHTpYd29iZ5LkLD
 yGDr0xQslWy+cq7h469gkXLElsLISiRhTI7suLqco4pnDovTPw
 dS6y1Dzr0e5c+NIwpTUA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are updates to platforms all over the place that did not really fit anywhere else-
The most significant change in here is allowing various kinds of freescale i.mx
machines to be supported using a single kernel instead of one kernel per soc type.

	Arnd

The following changes since commit 611e518c9ad54adcf9bf704fbbc668af3a2f8e07:

  Merge branch 'next/board' into HEAD (2011-11-01 04:34:20 +0100)

are available in the git repository at:

  git://git.linaro.org/people/arnd/arm-soc.git next/devel

Arnaud Patard (2):
      efika: Configure esdhc cd/wp on efika mx/sb
      ARM: mx5: fix clock usage for suspend

Arnd Bergmann (6):
      Merge branch 'imx/cleanup' into imx/devel
      Merge branches 'sirf/devel', 'at91/devel', 'imx/devel' and 'davinci/devel' into next/devel
      Merge branch 'imx-features-for-arnd' of git://git.pengutronix.de/git/imx/linux-2.6 into imx/devel
      Merge branch 'imx/devel' into next/devel
      Merge branch 'tegra/devel' into next/devel
      Merge branch 'depends/rmk/gpio' into next/devel

Dong Aisheng (5):
      ARM: mxs: add saif clock
      ARM: mxs: add saif device
      ARM: mxs: add sgtl5000 i2c device
      ARM: mxs: add mxs-sgtl5000 device
      ARM: mxs: correct the using of frac div for saif

Fabio Estevam (5):
      ARM: imx: pwm: Add support for MX53
      ARM: mx53_loco: Add support for the accelerometer
      ARM: imx: Introduce generic function for displaying silicon revision
      ARM: mach-imx/mx25_3ds: Add FlexCAN support
      ARM: mach-qong: Add watchdog support

Hui Wang (1):
      ARM i.MX avic: convert to use generic irq chip

Ido Yariv (4):
      ARM: davinci: DA850: Add MMC/SD1 pinmux configuration
      ARM: davinci: DA850: Add GPIO pinmux configuration for wl1271
      mmc: davinci: Add support for set_power callback
      ARM: davinci: AM18x: Add wl1271/wlan support

Jason Liu (7):
      ARM: mx25: Print silicon revision on boot
      ARM: mx27: Print silicon revision on boot
      ARM: mx31: use generic function for displaying silicon revision
      ARM: mx35: use generic function for displaying silicon revision
      ARM: mx5: use generic function for displaying silicon revision
      ARM: i.MX: initialize l2x0 at early_init time
      ARM: mx25: Add the missing IIM base definition

Jean-Christophe PLAGNIOL-VILLARD (1):
      at91: ohci-at91: always provide all the clocks

Olof Johansson (1):
      ARM: tegra: update defconfig

Peter De Schrijver (3):
      arm/tegra: prepare Seaboard pinmux code for derived boards
      arm/tegra: add support for ventana pinmuxing
      arm/tegra: device tree support for ventana board

Philippe Rétornaz (1):
      mx31moboard: Add poweroff support

Sascha Hauer (12):
      ARM i.MX: allow to compile together ARMv4 and ARMv5 based SoCs
      ARM i.MX: allow to compile together all i.MX5 based SoCs
      ARM i.MX5: update defconfig
      ARM i.MX defconfigs: use one defconfig for all ARMv4/v5 SoCs
      Merge branches 'features/assorted', 'features/imx-cpurev', 'features/imx-pata', 'features/multisoc' and 'features/mxs' into imx-features-for-arnd
      ARM i.MX avic: add handle_irq function
      ARM i.MX tzic: add handle_irq function
      ARM i.MX boards: use CONFIG_MULTI_IRQ_HANDLER
      ARM i.MX entry-macro.S: remove now unused code
      Merge branches 'features/assorted', 'features/imx-pata' and 'features/imx-multi-irq-v2' into imx-features
      Merge branch 'features/ahci' into for-arnd-features
      Merge branch 'features/denx-mx28' into for-arnd-features

Stephen Warren (6):
      arm/tegra: Prep boards for gpio/pinmux conversion to pdevs
      arm/dt: Tegra: Add pinmux node to tegra20.dtsi
      arm/tegra: Convert pinmux driver to a platform device
      gpio/tegra: Convert to a platform device
      arm/tegra: pinmux: ioremap registers
      arm/tegra: Harmony: Configure PMC for low-level interrupts

Thomas Petazzoni (3):
      at91: ohci-at91: add vbus_pin_inverted platform attribute
      at91: at91-ohci: support overcurrent notification
      at91: at91-ohci: configure overcurrent pins as input GPIOs

Wolfram Sang (3):
      arm: mxs: mx28evk: add fixed regulators for audio
      arm: mach-mxs: add device for rtc
      arm: mach-mxs: add rtc to all boards

 .../devicetree/bindings/pinmux/pinmux_nvidia.txt   |    5 +
 arch/arm/Kconfig                                   |    1 +
 arch/arm/Makefile                                  |    4 +-
 arch/arm/boot/dts/tegra-ventana.dts                |   32 +++
 arch/arm/boot/dts/tegra20.dtsi                     |    8 +
 arch/arm/configs/imx_v4_v5_defconfig               |  170 ++++++++++++++
 arch/arm/configs/mx1_defconfig                     |   91 --------
 arch/arm/configs/mx21_defconfig                    |   97 --------
 arch/arm/configs/mx27_defconfig                    |  130 -----------
 arch/arm/configs/mx51_defconfig                    |  170 --------------
 arch/arm/configs/mx5_defconfig                     |  184 +++++++++++++++
 arch/arm/configs/tegra_defconfig                   |   39 +++-
 arch/arm/mach-at91/at91cap9.c                      |    2 +
 arch/arm/mach-at91/at91cap9_devices.c              |    6 +
 arch/arm/mach-at91/at91rm9200.c                    |    2 +
 arch/arm/mach-at91/at91rm9200_devices.c            |    8 +
 arch/arm/mach-at91/at91sam9260.c                   |    2 +
 arch/arm/mach-at91/at91sam9260_devices.c           |    8 +
 arch/arm/mach-at91/at91sam9261.c                   |   29 ++--
 arch/arm/mach-at91/at91sam9261_devices.c           |    8 +
 arch/arm/mach-at91/at91sam9263.c                   |    2 +
 arch/arm/mach-at91/at91sam9263_devices.c           |    6 +
 arch/arm/mach-at91/at91sam9g45.c                   |    2 +
 arch/arm/mach-at91/at91sam9g45_devices.c           |    6 +
 arch/arm/mach-at91/include/mach/board.h            |    5 +
 arch/arm/mach-davinci/Kconfig                      |   10 +
 arch/arm/mach-davinci/board-da850-evm.c            |  114 ++++++++++
 arch/arm/mach-davinci/da850.c                      |    9 +
 arch/arm/mach-davinci/include/mach/mmc.h           |    3 +
 arch/arm/mach-davinci/include/mach/mux.h           |   10 +
 arch/arm/mach-imx/Kconfig                          |   52 ++---
 arch/arm/mach-imx/Makefile                         |    2 +-
 arch/arm/mach-imx/clock-imx25.c                    |    6 +
 arch/arm/mach-imx/clock-imx27.c                    |    2 +
 arch/arm/mach-imx/clock-imx31.c                    |    4 +-
 arch/arm/mach-imx/clock-imx35.c                    |    3 +-
 arch/arm/mach-imx/cpu-imx25.c                      |   41 ++++
 arch/arm/mach-imx/cpu-imx27.c                      |   28 +--
 arch/arm/mach-imx/cpu-imx31.c                      |   49 +++--
 arch/arm/mach-imx/cpu-imx35.c                      |   30 ++--
 arch/arm/mach-imx/mach-apf9328.c                   |    1 +
 arch/arm/mach-imx/mach-armadillo5x0.c              |    1 +
 arch/arm/mach-imx/mach-bug.c                       |    1 +
 arch/arm/mach-imx/mach-cpuimx27.c                  |    1 +
 arch/arm/mach-imx/mach-cpuimx35.c                  |    1 +
 arch/arm/mach-imx/mach-eukrea_cpuimx25.c           |    1 +
 arch/arm/mach-imx/mach-imx27_visstrim_m10.c        |    1 +
 arch/arm/mach-imx/mach-imx27ipcam.c                |    1 +
 arch/arm/mach-imx/mach-imx27lite.c                 |    1 +
 arch/arm/mach-imx/mach-kzm_arm11_01.c              |    1 +
 arch/arm/mach-imx/mach-mx1ads.c                    |    2 +
 arch/arm/mach-imx/mach-mx21ads.c                   |    1 +
 arch/arm/mach-imx/mach-mx25_3ds.c                  |   11 +
 arch/arm/mach-imx/mach-mx27_3ds.c                  |    1 +
 arch/arm/mach-imx/mach-mx27ads.c                   |    1 +
 arch/arm/mach-imx/mach-mx31_3ds.c                  |    1 +
 arch/arm/mach-imx/mach-mx31ads.c                   |    1 +
 arch/arm/mach-imx/mach-mx31lilly.c                 |    1 +
 arch/arm/mach-imx/mach-mx31lite.c                  |    1 +
 arch/arm/mach-imx/mach-mx31moboard.c               |   18 ++
 arch/arm/mach-imx/mach-mx35_3ds.c                  |    1 +
 arch/arm/mach-imx/mach-mxt_td60.c                  |    1 +
 arch/arm/mach-imx/mach-pca100.c                    |    1 +
 arch/arm/mach-imx/mach-pcm037.c                    |    1 +
 arch/arm/mach-imx/mach-pcm038.c                    |    1 +
 arch/arm/mach-imx/mach-pcm043.c                    |    1 +
 arch/arm/mach-imx/mach-qong.c                      |    2 +
 arch/arm/mach-imx/mach-scb9328.c                   |    1 +
 arch/arm/mach-imx/mach-vpr200.c                    |    1 +
 arch/arm/mach-mx5/Kconfig                          |   18 +--
 arch/arm/mach-mx5/board-cpuimx51.c                 |    1 +
 arch/arm/mach-mx5/board-cpuimx51sd.c               |    1 +
 arch/arm/mach-mx5/board-mx50_rdp.c                 |    1 +
 arch/arm/mach-mx5/board-mx51_3ds.c                 |    1 +
 arch/arm/mach-mx5/board-mx51_babbage.c             |    1 +
 arch/arm/mach-mx5/board-mx51_efikamx.c             |   12 +-
 arch/arm/mach-mx5/board-mx51_efikasb.c             |   19 ++-
 arch/arm/mach-mx5/board-mx53_ard.c                 |    1 +
 arch/arm/mach-mx5/board-mx53_evk.c                 |    1 +
 arch/arm/mach-mx5/board-mx53_loco.c                |   21 ++
 arch/arm/mach-mx5/board-mx53_smd.c                 |    1 +
 arch/arm/mach-mx5/clock-mx51-mx53.c                |    6 +-
 arch/arm/mach-mx5/cpu.c                            |   74 ++-----
 arch/arm/mach-mx5/devices-imx53.h                  |    1 +
 arch/arm/mach-mx5/mx51_efika.c                     |    1 -
 arch/arm/mach-mxs/Kconfig                          |    6 +
 arch/arm/mach-mxs/clock-mx28.c                     |    8 +-
 arch/arm/mach-mxs/devices-mx23.h                   |    2 +
 arch/arm/mach-mxs/devices-mx28.h                   |    5 +
 arch/arm/mach-mxs/devices/Kconfig                  |    6 +
 arch/arm/mach-mxs/devices/Makefile                 |    2 +
 arch/arm/mach-mxs/devices/platform-mxs-saif.c      |   60 +++++
 arch/arm/mach-mxs/devices/platform-rtc-stmp3xxx.c  |   51 ++++
 arch/arm/mach-mxs/include/mach/devices-common.h    |   12 +
 arch/arm/mach-mxs/mach-mx23evk.c                   |    1 +
 arch/arm/mach-mxs/mach-mx28evk.c                   |   80 +++++++
 arch/arm/mach-mxs/mach-stmp378x_devb.c             |    1 +
 arch/arm/mach-mxs/mach-tx28.c                      |    1 +
 arch/arm/mach-tegra/Kconfig                        |    6 +
 arch/arm/mach-tegra/Makefile                       |    1 +
 arch/arm/mach-tegra/Makefile.boot                  |    1 +
 arch/arm/mach-tegra/board-dt.c                     |   26 ++-
 arch/arm/mach-tegra/board-harmony-pinmux.c         |    8 +
 arch/arm/mach-tegra/board-harmony-power.c          |   13 +-
 arch/arm/mach-tegra/board-paz00-pinmux.c           |    8 +
 arch/arm/mach-tegra/board-seaboard-pinmux.c        |   69 ++++++-
 arch/arm/mach-tegra/board-trimslice-pinmux.c       |    7 +
 arch/arm/mach-tegra/devices.c                      |   84 +++++++
 arch/arm/mach-tegra/devices.h                      |    2 +
 arch/arm/mach-tegra/include/mach/pinmux.h          |    4 +
 arch/arm/mach-tegra/pinmux-t2-tables.c             |   76 +-----
 arch/arm/mach-tegra/pinmux.c                       |  163 +++++++++++---
 arch/arm/plat-mxc/Kconfig                          |   39 +---
 arch/arm/plat-mxc/avic.c                           |   91 ++++++--
 arch/arm/plat-mxc/cpu.c                            |    9 +
 arch/arm/plat-mxc/include/mach/common.h            |   15 ++
 arch/arm/plat-mxc/include/mach/entry-macro.S       |   58 +-----
 arch/arm/plat-mxc/include/mach/iomux-mx3.h         |    1 +
 arch/arm/plat-mxc/include/mach/mx25.h              |    5 +
 arch/arm/plat-mxc/include/mach/mx3x.h              |   18 +--
 arch/arm/plat-mxc/irq-common.c                     |   21 +-
 arch/arm/plat-mxc/irq-common.h                     |    3 +-
 arch/arm/plat-mxc/pwm.c                            |    2 +-
 arch/arm/plat-mxc/tzic.c                           |   32 +++-
 drivers/gpio/gpio-tegra.c                          |  143 ++++++++----
 drivers/mmc/host/davinci_mmc.c                     |   13 +
 drivers/usb/host/ohci-at91.c                       |  239 ++++++++++++++++++--
 127 files changed, 1995 insertions(+), 995 deletions(-)

