Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab2LLQmn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 11:42:43 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37689 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563Ab2LLQml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 11:42:41 -0500
Date: Wed, 12 Dec 2012 08:42:35 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
Subject: [GIT PULL 5/5] ARM: arm-soc: Board updates for 3.8
Message-ID: <20121212164235.GE16288@quad.lixom.net>
References: <20121212163942.GA16036@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121212163942.GA16036@quad.lixom.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,


This branch contains a set of various board updates for ARM platforms.

A few shmobile platforms that are stale have been removed, some
defconfig updates for various boards selecting new features such as
pinctrl subsystem support, and various updates enabling peripherals, etc.


Conflicts seen with this merge:

arch/arm/configs/marzen_defconfig:
Keep the SPI options.

arch/arm/mach-kirkwood/board-lsxl.c:
gpio-fan.h include can be dropped.

arch/arm/mach-omap2/board-omap4panda.c:
Keep the video/omap-panel-tfp410.h include, the others are dropped.

drivers/leds/leds-ns2.c:
Conflict with the __dev* removal. Keep the new code, but remove the
__dev* annotations.

----------------------------------------------------------------

The following changes since commit e628ba09c44d1dcdbb255e1cb4627870846321b1:

  Merge branch 'next/soc' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/boards

for you to fetch changes up to 006309132f57ccc20dd69e971e2041ebd2cbb7e5:

  Merge branch 'next/board-samsung-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung into next/boards

----------------------------------------------------------------

Arnd Bergmann (1):
      Merge tag 'omap-for-v3.8/board-v2-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/boards

Dimitris Papastamos (1):
      ARM: S3C64XX: Fix up IRQ mapping for balblair on Cragganmore

Fabio Estevam (2):
      ARM: imx_v6_v7_defconfig: Add DA9052 regulator support
      ARM: imx: configs: Enable CONFIG_MEDIA_CAMERA_SUPPORT

Guennadi Liakhovetski (1):
      ARM: shmobile: leave CONFIG_INOTIFY_USER enabled by default

Haojian Zhuang (1):
      ARM: mmp: select pinctrl driver

Heiko Schocher (2):
      ARM: davinci: da850: add SoC DT data
      ARM: davinci: add support for am1808 based EnBW CMC board

Jason Cooper (3):
      ARM: Kirkwood: add Netspace boards to defconfig
      ARM: Kirkwood: new board USI Topkick
      ARM: Kirkwood: update defconfig for new boards

Jason Gunthorpe (1):
      ARM: Kirkwood: Enable the second I2C bus

Javier Martin (1):
      Visstrim SM10: Use mo_version to decide board video mode.

Kuninori Morimoto (4):
      ARM: shmobile: mackerel: defconfig update
      ARM: shmobile: armadillo800eva: enable L2X0 cache on defconfig
      ARM: shmobile: armadillo800eva: enable restart
      ARM: shmobile: marzen: add HSPI support

Mark Brown (11):
      ARM: S3C64XX: Add more Glenfarclas module ID strings
      ARM: S3C64XX: Update hookup for Arizona class devices
      ARM: S3C64XX: Provide platform data for Tomatin/Balblair on Cragganmore
      ARM: S3C64XX: Handle revision-specific differences in Cragganmore modules
      ARM: S3C64XX: Handle new Amrut modules on Cragganmore
      ARM: S3C64XX: Add hookup for Deanston module on Cragganmore
      ARM: S3C64XX: Add WM2200 module for Cragganmore
      ARM: S3C64XX: Add handset module to probed Glenfarclas modules
      ARM: S3C64XX: Add missing device selects for Cragganmore
      ARM: S3C64XX: Add registration of WM2200 Bells device on Cragganmore
      ARM: S3C64XX: Add dummy supplies for Glenfarclas LDOs

Matt Porter (2):
      ARM: davinci: da850 evm: clean up include ordering
      ARM: davinci: da850 evm: register uio_pruss device

Michael Walle (1):
      ARM: kirkwood: use gpio-fan DT binding on lsxl

Nobuhiro Iwamatsu (4):
      ARM: mach-shmobile: Use DT_MACHINE for mackerel
      ARM: shmobile: Remove G3EVM machine support
      ARM: shmobile: Remove G4EVM machine support
      ARM: kirkwood: Add Plat'Home OpenBlocks A6 support

Olof Johansson (10):
      Merge branch 'boards' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge branch 'defconfig' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge tag 'davinci-for-v3.8/board' of git://gitorious.org/linux-davinci/linux-davinci into next/boards
      Merge tag 'davinci-for-v3.8/defconfig' of git://gitorious.org/linux-davinci/linux-davinci into next/boards
      Merge branch 'armsoc/board' of git://github.com/hzhuang1/linux into next/boards
      Merge branch 'next/board-samsung' of git://git.kernel.org/.../kgene/linux-samsung into next/boards
      Merge branch 'imx/board' into next/boards
      Merge tag 'imx-defconfig' of git://git.pengutronix.de/git/imx/linux-2.6 into next/boards
      Merge tag 'orion_boards_for_3.8' of git://git.infradead.org/users/jcooper/linux into next/boards
      Merge branch 'next/board-samsung-2' of git://git.kernel.org/.../kgene/linux-samsung into next/boards

Pavel Machek (1):
      ARM: OMAP2+: Nokia N9/N900/N950 -- mention product names

Sasha Levin (1):
      ARM: OMAP1: use BUG_ON where possible

Sebastian Hesselbarth (1):
      ARM: Dove: update defconfig

Sekhar Nori (4):
      ARM: davinci: da850: add DT boot support
      ARM: davinci: da850 evm: add DT data
      ARM: davinci: da850: generate dtbs for da850 boards
      ARM: davinci: da8xx defconfig: enable DT config options

Simon Guinot (4):
      leds: leds-ns2: add device tree binding
      ARM: kirkwood: DT board setup for Network Space v2 and parents
      ARM: kirkwood: DT board setup for Network Space Lite v2
      ARM: kirkwood: DT board setup for Network Space Mini v2

Stefan Peter (1):
      ARM: kirkwood: Add support for the MPL CEC4

Tero Jaasko (1):
      arm: kirkwood: add support for ZyXEL NSA310

Tetsuyuki Kobayashi (3):
      ARM: shmobile: kzm9g: enable magnetometer ak8975.
      ARM: shmobile: kzm9g: enable three-axis digital accelerometer ADXL345
      ARM: shmobile: kzm9g: enable DMAEngine on SHDI0 and SDHI2

Thomas Petazzoni (4):
      arm: orion5x: mechanical defconfig update
      arm: orion5x: basic Device Tree support
      arm: orion5x: convert 'LaCie Ethernet Disk mini v2' to Device Tree
      arm: orion5x: add DT related options in defconfig

Tomasz Figa (1):
      ARM: EXYNOS: Add missing USB regulators for origen

Tomi Valkeinen (3):
      OMAP: panda: move display init from board file to dss-common.c
      OMAP: omap4sdp: move display init from board file to dss-common.c
      OMAP: board-generic: enable DSS for panda & sdp boards


 .../devicetree/bindings/arm/davinci.txt         |  17 +
 .../devicetree/bindings/gpio/leds-ns2.txt       |  26 ++
 arch/arm/Kconfig                                |   1 +
 arch/arm/boot/dts/Makefile                      |  15 +-
 arch/arm/boot/dts/da850-enbw-cmc.dts            |  30 ++
 arch/arm/boot/dts/da850-evm.dts                 |  28 ++
 arch/arm/boot/dts/da850.dtsi                    |  60 +++
 arch/arm/boot/dts/kirkwood-is2.dts              |  30 ++
 arch/arm/boot/dts/kirkwood-lsxl.dtsi            |  11 +
 arch/arm/boot/dts/kirkwood-mplcec4.dts          | 119 ++++++
 arch/arm/boot/dts/kirkwood-ns2-common.dtsi      |  63 +++
 arch/arm/boot/dts/kirkwood-ns2.dts              |  30 ++
 arch/arm/boot/dts/kirkwood-ns2lite.dts          |  30 ++
 arch/arm/boot/dts/kirkwood-ns2max.dts           |  49 +++
 arch/arm/boot/dts/kirkwood-ns2mini.dts          |  49 +++
 arch/arm/boot/dts/kirkwood-nsa310.dts           | 144 +++++++
 arch/arm/boot/dts/kirkwood-openblocks_a6.dts    |  39 ++
 arch/arm/boot/dts/kirkwood-topkick.dts          |  85 ++++
 .../dts/orion5x-lacie-ethernet-disk-mini-v2.dts |  55 +++
 arch/arm/boot/dts/orion5x.dtsi                  |  98 +++++
 arch/arm/boot/dts/sh7372-mackerel.dts           |  22 ++
 arch/arm/configs/ap4evb_defconfig               |   1 -
 arch/arm/configs/armadillo800eva_defconfig      |   2 +-
 arch/arm/configs/da8xx_omapl_defconfig          |   3 +
 arch/arm/configs/dove_defconfig                 |  24 ++
 arch/arm/configs/g3evm_defconfig                |  57 ---
 arch/arm/configs/g4evm_defconfig                |  57 ---
 arch/arm/configs/imx_v4_v5_defconfig            |   1 +
 arch/arm/configs/imx_v6_v7_defconfig            |   3 +
 arch/arm/configs/kirkwood_defconfig             |   9 +
 arch/arm/configs/kota2_defconfig                |   1 -
 arch/arm/configs/kzm9g_defconfig                |   5 +-
 arch/arm/configs/mackerel_defconfig             |  19 +-
 arch/arm/configs/marzen_defconfig               |   2 +
 arch/arm/configs/orion5x_defconfig              |  36 +-
 arch/arm/mach-davinci/Kconfig                   |   8 +
 arch/arm/mach-davinci/Makefile                  |   1 +
 arch/arm/mach-davinci/Makefile.boot             |   2 +
 arch/arm/mach-davinci/board-da850-evm.c         |  34 +-
 arch/arm/mach-davinci/da8xx-dt.c                |  66 ++++
 arch/arm/mach-exynos/mach-origen.c              |   2 +
 arch/arm/mach-imx/mach-imx27_visstrim_m10.c     |  52 ++-
 arch/arm/mach-kirkwood/Kconfig                  |  65 ++++
 arch/arm/mach-kirkwood/Makefile                 |   9 +
 arch/arm/mach-kirkwood/board-dt.c               |  30 ++
 arch/arm/mach-kirkwood/board-lsxl.c             |  47 ---
 arch/arm/mach-kirkwood/board-mplcec4.c          |  80 ++++
 arch/arm/mach-kirkwood/board-ns2.c              |  87 +++++
 arch/arm/mach-kirkwood/board-nsa310.c           | 105 +++++
 arch/arm/mach-kirkwood/board-openblocks_a6.c    |  71 ++++
 arch/arm/mach-kirkwood/board-usi_topkick.c      |  82 ++++
 arch/arm/mach-kirkwood/common.c                 |   1 +
 arch/arm/mach-kirkwood/common.h                 |  34 ++
 arch/arm/mach-mmp/Kconfig                       |   4 +
 arch/arm/mach-omap1/board-fsample.c             |   3 +-
 arch/arm/mach-omap1/board-h2.c                  |   3 +-
 arch/arm/mach-omap1/board-h3.c                  |   3 +-
 arch/arm/mach-omap1/board-perseus2.c            |   3 +-
 arch/arm/mach-omap2/Kconfig                     |   4 +-
 arch/arm/mach-omap2/Makefile                    |   2 +-
 arch/arm/mach-omap2/board-4430sdp.c             | 157 +-------
 arch/arm/mach-omap2/board-generic.c             |  10 +
 arch/arm/mach-omap2/board-omap4panda.c          |  67 +---
 arch/arm/mach-omap2/board-rm680.c               |   2 +-
 arch/arm/mach-omap2/board-rx51.c                |   2 +-
 arch/arm/mach-omap2/dss-common.c                | 276 +++++++++++++
 arch/arm/mach-omap2/dss-common.h                |  14 +
 arch/arm/mach-orion5x/Kconfig                   |  14 +-
 arch/arm/mach-orion5x/Makefile                  |   4 +-
 arch/arm/mach-orion5x/board-dt.c                |  79 ++++
 arch/arm/mach-orion5x/common.c                  |   4 +-
 arch/arm/mach-orion5x/common.h                  |   9 +
 arch/arm/mach-orion5x/edmini_v2-setup.c         |  88 +----
 arch/arm/mach-s3c64xx/Kconfig                   |   2 +
 arch/arm/mach-s3c64xx/mach-crag6410-module.c    | 141 +++++--
 arch/arm/mach-s3c64xx/mach-crag6410.c           |  49 ++-
 arch/arm/mach-shmobile/Kconfig                  |  17 +-
 arch/arm/mach-shmobile/Makefile                 |   2 -
 arch/arm/mach-shmobile/board-armadillo800eva.c  |   8 +
 arch/arm/mach-shmobile/board-g3evm.c            | 343 -----------------
 arch/arm/mach-shmobile/board-g4evm.c            | 384 -------------------
 arch/arm/mach-shmobile/board-kzm9g.c            |  14 +-
 arch/arm/mach-shmobile/board-mackerel.c         |   8 +-
 arch/arm/mach-shmobile/board-marzen.c           |  25 ++
 drivers/leds/Kconfig                            |   4 +-
 drivers/leds/leds-ns2.c                         |  78 +++-
 86 files changed, 2500 insertions(+), 1320 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/davinci.txt
 create mode 100644 Documentation/devicetree/bindings/gpio/leds-ns2.txt
 create mode 100644 arch/arm/boot/dts/da850-enbw-cmc.dts
 create mode 100644 arch/arm/boot/dts/da850-evm.dts
 create mode 100644 arch/arm/boot/dts/da850.dtsi
 create mode 100644 arch/arm/boot/dts/kirkwood-is2.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-mplcec4.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-ns2-common.dtsi
 create mode 100644 arch/arm/boot/dts/kirkwood-ns2.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-ns2lite.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-ns2max.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-ns2mini.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-nsa310.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-openblocks_a6.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-topkick.dts
 create mode 100644 arch/arm/boot/dts/orion5x-lacie-ethernet-disk-mini-v2.dts
 create mode 100644 arch/arm/boot/dts/orion5x.dtsi
 create mode 100644 arch/arm/boot/dts/sh7372-mackerel.dts
 delete mode 100644 arch/arm/configs/g3evm_defconfig
 delete mode 100644 arch/arm/configs/g4evm_defconfig
 create mode 100644 arch/arm/mach-davinci/da8xx-dt.c
 create mode 100644 arch/arm/mach-kirkwood/board-mplcec4.c
 create mode 100644 arch/arm/mach-kirkwood/board-ns2.c
 create mode 100644 arch/arm/mach-kirkwood/board-nsa310.c
 create mode 100644 arch/arm/mach-kirkwood/board-openblocks_a6.c
 create mode 100644 arch/arm/mach-kirkwood/board-usi_topkick.c
 create mode 100644 arch/arm/mach-omap2/dss-common.c
 create mode 100644 arch/arm/mach-omap2/dss-common.h
 create mode 100644 arch/arm/mach-orion5x/board-dt.c
 delete mode 100644 arch/arm/mach-shmobile/board-g3evm.c
 delete mode 100644 arch/arm/mach-shmobile/board-g4evm.c
