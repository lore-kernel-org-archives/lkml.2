Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933425Ab2AIWQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 17:16:17 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:57192 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933004Ab2AIWOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 17:14:01 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL 06/11] Board-level changes
Date: Mon,  9 Jan 2012 22:12:46 +0000
Message-Id: <1326147171-13752-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1326147171-13752-1-git-send-email-arnd@arndb.de>
References: <1326147171-13752-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:O7+9/fL11CGpwIFdRtQmF9VdhXz4Whwsod+1zRTobAr
 6XzUNJLzuP2B7TxfkaooWv1oHjX11ZJ0AKxLcQqWpwxT7X4Qbh
 R9WQwHuERp7YiEAP6R6/eBLGPKzgJRvvEW/9e0DpHtG9XOau0f
 0WoIXaAFzJizJ+MPOFeQ5HZtDj/WzjXy2rtb5/FpYf+8p5lObO
 X97+ddQYAWsSqGCKH3U5HCPDWEvbV6NNuPBKJf8Tmd/18bK/a3
 nwZGzYMubMd2+ApD88K5Iaen7Fxh2onNZhczpLZmjgKtRA0gUi
 VGRXDtaME8nJii5o5tb4N6oYtobNRp7Gg0LTubYQmH8YC2kjuQ
 uAX3ocT4ZcUHndmGC3nZmQPDaQD/p/W4HKmb/asKXjj+8C8tqj
 mQWFIwpcOUNbQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds and extends support for specific boards on a number of
ARM platforms:  omap, imx, samsung, tegra, ...

The following changes since commit 0566db064b435f4763bc9b6d19af102780ced8f0:

  Merge branch 'next/soc' into for-next2 (2012-01-09 16:48:42 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git next/boards

Aaro Koskinen (1):
      ARM: OMAP3: rx51: enable tsc2005 touchscreen

Ajay Kumar Gupta (1):
      ARM: OMAP: musb: Add ti81xx phy power function

Arnd Bergmann (7):
      Merge branch 'for-3.3/boards' of git://git.kernel.org/.../olof/tegra into tegra/boards
      Merge branch 'tegra/boards' into next/boards
      Merge branch 'pxa/board' into next/boards
      Merge branch 'imx-features-assorted' of git://git.pengutronix.de/git/imx/linux-2.6 into imx/board
      Merge branch 'imx/board' into next/boards
      Merge branch 'tegra/soc' into next/boards
      Merge branch 'samsung/cleanup' into next/boards

Denis Kuzmenko (1):
      ARM: S3C2440: Add new LCD (W35i) support for Mini2440 board

Dirk Behme (1):
      arm/imx6q: Rename Sabreauto to Armadillo2

Eric Miao (1):
      ARM: imx6q: generate imx6q dtb files

Fabio Estevam (1):
      ARM: mx31pdk: Add MC13783 RTC support

Gwenhael Goavec-Merou (1):
      MX1:apf9328: Add i2c support

Hemant Pedanekar (1):
      ARM: OMAP: TI814X: Create board support and enable build for TI8148 EVM

Igor Dmitriev (1):
      ARM: OMAP3: sdram-nokia: add 200 MHz memory timings info

Igor Grinberg (5):
      ARM: OMAP3: cm-t35: Add regulator for ads7846 touchscreen
      ARM: OMAP3: cm-t35: Use correct DSS regulator supply
      ARM: OMAP3: cm-t35: enable audio
      ARM: OMAP3: cm-t35: Add reset for USB hub
      ARM: OMAP3: cm-t35: fix mux mode for DSS pins

Jaccon Bastiaansen (1):
      Enable 32 bit flash support for iMX21ADS board

Leon Romanovsky (1):
      ARM: tegra: paz00: Fix board pinmux table.

Marc Dietrich (1):
      ARM: tegra: paz00: add support for wakeup gpio key

Mark Brown (12):
      ARM: S3C64XX: Update for conversion to SAMSUNG_GPIO_EXTRA
      ARM: SAMSUNG: Fix GPIO space reservation for S3C64xx platforms
      ARM: S3C64XX: Correct reservation of GPIOs for CPU module on Cragganmore
      ARM: S3C64XX: Raise the frequency of the second I2C bus on Cragganmore
      ARM: S3C64XX: Use software initiated powerdown for Cragganmore
      ARM: S3C64XX: Configure WM1250 EV1 GPIOs on Cragganmore
      ARM: S3C64XX: Improve logging of unknown Cragganmore module types
      ARM: S3C64XX: Run Tobermory interrupts in the default mode
      ARM: S3C64XX: Hook up platform data for Kilchomin module on Cragganmore
      ARM: S3C64XX: Hook up Littlemill audio card on Cragganmore
      ARM: S3C64XX: Power gate unused domains
      ARM: S3C64XX: Hook up VDDINT on Cragganmore

Olof Johansson (9):
      Merge branch 'board' of git://git.kernel.org/.../tmlind/linux-omap into omap/board
      Merge branch 'musb' of git://git.kernel.org/.../tmlind/linux-omap into omap/musb
      Merge branch 'imx6/boards' of git://git.linaro.org/people/shawnguo/linux-2.6 into imx6/boards
      Merge branch 'depends/rmk/devel-stable' into next/boards
      Merge branch 'omap/board' into next/boards
      Merge branch 'omap/musb' into next/boards
      Merge branch 'imx6/boards' into next/boards
      Merge branch 'samsung/board' into next/boards
      arm/tegra: remove __initdata annotation from pinmux tables

Paul Fertser (1):
      iomux-mx25: configuration to support CSPI3 on CSI pins

Peter Ujfalusi (2):
      ARM: OMAP4: devices: Register OMAP4 DMIC platform device
      ARM: OMAP4: board-4430sdp: Register platform device for digimic codec

Ravi Babu (2):
      ARM: OMAP: musb: Adding support for ti81xx
      ARM: OMAP: musb: Add support for ti816evm

Richard Zhao (4):
      dts/imx: rename gpio labels to consistent with hw spec
      dts/imx: rename uart labels to consistent with hw spec
      arm/imx6: add imx6q sabrelite board support
      arm/imx6q-sabrelite: add enet phy ksz9021rn fixup

Robert Jarzmik (1):
      mioa701: add newly available DoC G3 chip

Stephen Warren (9):
      arm/tegra: Split Seaboard GPIO table to allow for Ventana
      arm/tegra: Add AUXDATA for tegra-pinmux and tegra-gpio
      arm/tegra: Harmony PCIe: Don't touch pinmux
      arm/tegra: PCIe: Remove include of mach/pinmux.h
      arm/tegra: Remove useless entries from ventana_pinmux[]
      arm/tegra: Rework Seaboard-vs-Ventana pinmux table
      arm/tegra: Fix mistake in Trimslice's pinmux
      arm/tegra: Refactor board-*-pinmux.c to share code
      arm/tegra: Use bus notifiers to trigger pinmux setup

 Documentation/devicetree/bindings/arm/fsl.txt |    8 ++-
 arch/arm/boot/dts/imx51-babbage.dts           |   17 ++--
 arch/arm/boot/dts/imx51.dtsi                  |   20 ++--
 arch/arm/boot/dts/imx53-ard.dts               |   18 ++--
 arch/arm/boot/dts/imx53-evk.dts               |   17 ++--
 arch/arm/boot/dts/imx53-qsb.dts               |   18 ++--
 arch/arm/boot/dts/imx53-smd.dts               |   19 ++--
 arch/arm/boot/dts/imx53.dtsi                  |   34 ++++----
 arch/arm/boot/dts/imx6q-arm2.dts              |   62 +++++++++++++
 arch/arm/boot/dts/imx6q-sabreauto.dts         |   62 -------------
 arch/arm/boot/dts/imx6q-sabrelite.dts         |   49 ++++++++++
 arch/arm/boot/dts/imx6q.dtsi                  |   34 ++++----
 arch/arm/configs/imx_v4_v5_defconfig          |    1 -
 arch/arm/mach-imx/Kconfig                     |    1 +
 arch/arm/mach-imx/Makefile.boot               |    3 +
 arch/arm/mach-imx/mach-apf9328.c              |   10 ++
 arch/arm/mach-imx/mach-imx6q.c                |   24 +++++-
 arch/arm/mach-imx/mach-mx31_3ds.c             |    2 +-
 arch/arm/mach-omap2/Kconfig                   |    5 +
 arch/arm/mach-omap2/Makefile                  |    1 +
 arch/arm/mach-omap2/board-4430sdp.c           |    6 ++
 arch/arm/mach-omap2/board-cm-t35.c            |   82 ++++++++++++-----
 arch/arm/mach-omap2/board-rx51-peripherals.c  |   46 +++++++++-
 arch/arm/mach-omap2/board-ti8168evm.c         |   32 ++++++--
 arch/arm/mach-omap2/devices.c                 |   22 +++++
 arch/arm/mach-omap2/omap_phy_internal.c       |   35 +++++++
 arch/arm/mach-omap2/sdram-nokia.c             |   25 +++++-
 arch/arm/mach-omap2/usb-musb.c                |    3 +
 arch/arm/mach-pxa/mioa701.c                   |   29 ++++---
 arch/arm/mach-s3c2440/mach-mini2440.c         |   18 ++++
 arch/arm/mach-s3c64xx/Kconfig                 |    6 +-
 arch/arm/mach-s3c64xx/include/mach/crag6410.h |    6 +-
 arch/arm/mach-s3c64xx/include/mach/gpio.h     |    2 +-
 arch/arm/mach-s3c64xx/include/mach/irqs.h     |    2 +-
 arch/arm/mach-s3c64xx/mach-crag6410-module.c  |   56 +++++++++++-
 arch/arm/mach-s3c64xx/mach-crag6410.c         |   39 ++++++++-
 arch/arm/mach-s3c64xx/pm.c                    |   15 +++
 arch/arm/mach-tegra/Makefile                  |    1 +
 arch/arm/mach-tegra/board-dt-tegra20.c        |   16 ++--
 arch/arm/mach-tegra/board-harmony-pcie.c      |   10 --
 arch/arm/mach-tegra/board-harmony-pinmux.c    |   22 ++---
 arch/arm/mach-tegra/board-paz00-pinmux.c      |   24 ++---
 arch/arm/mach-tegra/board-paz00.c             |   27 ++++++
 arch/arm/mach-tegra/board-paz00.h             |    3 +
 arch/arm/mach-tegra/board-pinmux.c            |  104 +++++++++++++++++++++
 arch/arm/mach-tegra/board-pinmux.h            |   38 ++++++++
 arch/arm/mach-tegra/board-seaboard-pinmux.c   |  120 ++++++++++++-------------
 arch/arm/mach-tegra/board-trimslice-pinmux.c  |   26 +++---
 arch/arm/mach-tegra/pcie.c                    |    1 -
 arch/arm/plat-mxc/include/mach/iomux-mx25.h   |    4 +
 arch/arm/plat-omap/include/plat/uncompress.h  |    3 +
 arch/arm/plat-omap/include/plat/usb.h         |   32 +++++++
 arch/arm/plat-samsung/Kconfig                 |    8 ++
 53 files changed, 930 insertions(+), 338 deletions(-)
