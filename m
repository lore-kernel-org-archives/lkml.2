Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059Ab2EZHXZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 03:23:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52354 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575Ab2EZHXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 03:23:12 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 6/8] arm-soc: device tree conversions, part 2
Date: Sat, 26 May 2012 00:22:36 -0700
Message-Id: <1338016958-7887-7-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.1.488.g05fbf7a
In-Reply-To: <1338016958-7887-1-git-send-email-olof@lixom.net>
References: <1338016958-7887-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These continue the device tree work from part 1, this set is for the
tegra, mxs and imx platforms, all of which have dependencies on clock
or pinctrl changes submitted earlier.

----------------------------------------------------------------

The following changes since commit 672b9ea0bd2e9c8ac957b888cdb08d1f29d332e8:

  Merge tag 'stmp-dev' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/dt2

for you to fetch changes up to deb88cc3c69975cbd9875ed9fac259b351f6b64d:

  Merge branch 'drivers/mmc' into next/dt2

----------------------------------------------------------------

Arnd Bergmann (4):
      Merge branch 'imx/pinctrl' into imx/dt
      Merge branch 'imx/dt/for-3.5' of git://git.linaro.org/people/shawnguo/linux-2.6.git into next/dt2
      Merge branch 'for-3.5/dt2' of git://git.kernel.org/.../swarren/linux-tegra into for-next
      Merge branch 'drivers/mmc' into next/dt2

Dirk Behme (1):
      ARM: imx6: Add UART2 for low-level debug

Dong Aisheng (6):
      ARM: dts: imx6q-arm2: add pinctrl state for usdhc
      ARM: mxs: add initial device tree support for imx28-evk board
      dma: mxs-dma: use global stmp_device functionality
      dma: mxs-dma: add device tree probe support
      ARM: mxs: do not add dma device by default
      ARM: mxs: add mxs-dma dt support

Fabio Estevam (4):
      ARM: dts: imx: Remove bootargs field
      ARM: imx6q-arm2: Remove hardcoded mac address
      ARM: dts: Add basic support for imx6q-sabresd
      ARM: dts: imx6q-sabrelite: Add SPI NOR support

Hiroshi DOYU (1):
      ARM: dt: tegra: Add device tree support for AHB

Laxman Dewangan (2):
      ARM: dt: tegra: enable als and proximity sensor
      ARM: dt: tegra: cardhu: register core regulator tps62361

Olof Johansson (3):
      ARM: dt: tegra seaboard: add i2c devices
      Merge branch 'for-3.5/dt' of git://git.kernel.org/.../swarren/linux-tegra into next/dt2
      Merge branch 'mxs/dt/for-3.5' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/dt2

Richard Zhao (9):
      ARM: imx6q: move imx6q_sabrelite specific code to a dedicated function
      ARM: dts: imx6q-sabrelite: add ssi device
      ARM: dts: imx6q-sabrelite: add audmux device
      ARM: dts: imx6q-sabrelite: add i2c1 pinctrl support
      ARM: dts: imx6q-sabrelite: add audmux pinctrl support
      ARM: imx6q: add ssi1_ipg clk_lookup
      ARM: imx6q_sabrelite: clk_register_clkdev cko1 for sgtl5000
      ARM: dts: imx6q-sabrelite: add sound device imx6q-sabrelite-sgtl5000
      ARM: dts: imx6q-sabrelite: add serial2 pinctrl support

Shawn Guo (29):
      ARM: imx: rename uart and fec device tree nodes
      ARM: imx6q: register phy fixup only when CONFIG_PHYLIB is enabled
      ARM: imx: add more imx5 ssi clocks
      ARM: imx: add audmux pad setting for imx51-babbage
      ARM: imx: add audio codec clk lookup for imx53-qsb
      ARM: dts: imx51-babbage: enable audio support
      ARM: dts: imx53-qsb: enable audio support
      Merge branches 'clk/mxs' and 'imx/pinctrl/for-3.5' into mxs/dt/for-3.5
      ARM: mxs: add initial device tree support for imx23-evk board
      ARM: mxs: always build in device tree support
      dma: mxs-dma: let dma_is_apbh and apbh_is_old take parameter
      dma: mxs-dma: make platform_device_id more generic
      gpio/mxs: use devm_* helpers to make error handling simple
      gpio/mxs: get rid of the use of cpu_is_xxx
      gpio/mxs: add device tree probe
      ARM: mxs: add gpio support for device tree boot
      mmc: mxs-mmc: use global stmp_device functionality
      mmc: mxs-mmc: let ssp_is_old take host as parameter
      mmc: mxs-mmc: get rid of the use of cpu_is_xxx
      mmc: mxs-mmc: move header from mach into linux folder
      mmc: mxs-mmc: use devm_* helper to make cleanup simpler
      mmc: mxs-mmc: have dma_channel than dma_res in mxs_mmc_host
      mmc: mxs-mmc: copy wp_gpio in struct mxs_mmc_host
      mmc: mxs-mmc: add device tree support
      ARM: dts: enable mmc for imx23-evk
      ARM: dts: enable mmc for imx28-evk
      i2c: mxs: add device tree probe support
      ARM: dts: enable i2c device for imx28-evk
      ARM: dts: enable audio support for imx28-evk

Stephen Warren (17):
      ARM: dt: tegra seaboard: fix I2C2 SCL rate
      ARM: dt: tegra seaboard: configure I2C2 pinmux
      ARM: dt: tegra trimslice: add RTC I2C device
      ARM: dt: tegra trimslice: enable SDHCI1 controller
      ARM: dt: tegra trimslice: add support for audio
      Merge branch 'for-3.5/usb-ulpi' into for-3.5/dt2-new
      Merge branch 'for-3.5/dt' into for-3.5/dt2-new
      ARM: dt: tegra cardhu: fix typo in SDHCI node name
      ARM: dt: tegra: whitespace cleanup
      ARM: dt: tegra: remove unnecessary unit addresses
      ARM: dt: tegra: gpio comment cleanup
      ARM: dt: tegra: format regs properties consistently
      ARM: dt: tegra: consistenly use lower-case for hex constants
      ARM: dt: tegra: remove duplicate device_type property
      ARM: dt: tegra: sort nodes based on bus order
      ARM: dt: tegra: consistent basic property ordering
      ARM: dt: tegra: invert status=disable vs status=okay

Ying-Chun Liu (PaulLiu) (2):
      ARM: dts: imx6q: add anatop regulators
      ARM: dts: imx53-qsb: Add Dialog DA9053 PMIC support

hdoyu@nvidia.com (4):
      ARM: dt: tegra20.dtsi: Add Memory Controller(MC) nodes
      ARM: dt: tegra30.dtsi: Add Memory Controller(MC) nodes
      ARM: dt: tegra20.dtsi: Add GART node
      ARM: dt: tegra30.dtsi: Add SMMU node


 Documentation/devicetree/bindings/arm/fsl.txt   |  12 +
 .../devicetree/bindings/dma/fsl-mxs-dma.txt     |  19 +
 .../devicetree/bindings/gpio/gpio-mxs.txt       |  87 ++++
 .../devicetree/bindings/i2c/i2c-mxs.txt         |  16 +
 .../devicetree/bindings/mmc/mxs-mmc.txt         |  25 +
 .../devicetree/bindings/net/fsl-fec.txt         |   2 +-
 .../bindings/tty/serial/fsl-imx-uart.txt        |   2 +-
 arch/arm/Kconfig                                |   1 +
 arch/arm/Kconfig.debug                          |   8 +
 arch/arm/boot/dts/imx23-evk.dts                 |  43 ++
 arch/arm/boot/dts/imx23.dtsi                    | 295 +++++++++++
 arch/arm/boot/dts/imx27-phytec-phycore.dts      |   8 +-
 arch/arm/boot/dts/imx27.dtsi                    |  14 +-
 arch/arm/boot/dts/imx28-evk.dts                 | 114 +++++
 arch/arm/boot/dts/imx28.dtsi                    | 497 +++++++++++++++++++
 arch/arm/boot/dts/imx51-babbage.dts             |  40 +-
 arch/arm/boot/dts/imx51.dtsi                    |  41 +-
 arch/arm/boot/dts/imx53-ard.dts                 |   6 +-
 arch/arm/boot/dts/imx53-evk.dts                 |   8 +-
 arch/arm/boot/dts/imx53-qsb.dts                 | 121 ++++-
 arch/arm/boot/dts/imx53-smd.dts                 |  12 +-
 arch/arm/boot/dts/imx53.dtsi                    |  45 +-
 arch/arm/boot/dts/imx6q-arm2.dts                |  13 +-
 arch/arm/boot/dts/imx6q-sabrelite.dts           |  50 +-
 arch/arm/boot/dts/imx6q-sabresd.dts             |  53 ++
 arch/arm/boot/dts/imx6q.dtsi                    | 171 ++++++-
 arch/arm/boot/dts/tegra-cardhu.dts              |  85 ++--
 arch/arm/boot/dts/tegra-harmony.dts             | 104 ++--
 arch/arm/boot/dts/tegra-paz00.dts               | 112 ++---
 arch/arm/boot/dts/tegra-seaboard.dts            | 213 ++++----
 arch/arm/boot/dts/tegra-trimslice.dts           |  83 ++--
 arch/arm/boot/dts/tegra-ventana.dts             | 102 ++--
 arch/arm/boot/dts/tegra20.dtsi                  | 275 +++++-----
 arch/arm/boot/dts/tegra30.dtsi                  | 292 ++++++-----
 arch/arm/configs/mxs_defconfig                  |   1 +
 arch/arm/mach-imx/Makefile.boot                 |   3 +-
 arch/arm/mach-imx/clk-imx51-imx53.c             |  40 ++
 arch/arm/mach-imx/clk-imx6q.c                   |  35 +-
 arch/arm/mach-imx/imx53-dt.c                    |  19 +
 arch/arm/mach-imx/lluart.c                      |   6 +
 arch/arm/mach-imx/mach-imx6q.c                  |  55 +-
 arch/arm/mach-imx/mach-mx51_babbage.c           |   6 +
 arch/arm/mach-mxs/Kconfig                       |  10 +
 arch/arm/mach-mxs/Makefile                      |   1 +
 arch/arm/mach-mxs/devices/Kconfig               |   1 -
 arch/arm/mach-mxs/devices/platform-dma.c        |  21 +-
 arch/arm/mach-mxs/devices/platform-gpio-mxs.c   |  24 +-
 arch/arm/mach-mxs/devices/platform-mxs-mmc.c    |  21 +-
 arch/arm/mach-mxs/include/mach/common.h         |   7 +-
 arch/arm/mach-mxs/include/mach/devices-common.h |   3 +-
 arch/arm/mach-mxs/mach-mxs.c                    | 121 +++++
 arch/arm/mach-mxs/mm.c                          |  16 +
 arch/arm/plat-mxc/include/mach/debug-macro.S    |   2 +
 arch/arm/plat-mxc/include/mach/mx6q.h           |   2 +
 drivers/clk/mxs/clk-imx23.c                     |   9 +-
 drivers/clk/mxs/clk-imx28.c                     |  13 +-
 drivers/dma/Kconfig                             |   1 +
 drivers/dma/mxs-dma.c                           | 188 ++++---
 drivers/gpio/gpio-mxs.c                         | 156 +++---
 drivers/i2c/busses/i2c-mxs.c                    |  13 +
 drivers/mmc/host/mxs-mmc.c                      | 197 ++++----
 include/linux/fsl/mxs-dma.h                     |  12 +-
 .../mach/mmc.h => include/linux/mmc/mxs-mmc.h   |   7 +-
 63 files changed, 2972 insertions(+), 987 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/dma/fsl-mxs-dma.txt
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-mxs.txt
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-mxs.txt
 create mode 100644 Documentation/devicetree/bindings/mmc/mxs-mmc.txt
 create mode 100644 arch/arm/boot/dts/imx23-evk.dts
 create mode 100644 arch/arm/boot/dts/imx23.dtsi
 create mode 100644 arch/arm/boot/dts/imx28-evk.dts
 create mode 100644 arch/arm/boot/dts/imx28.dtsi
 create mode 100644 arch/arm/boot/dts/imx6q-sabresd.dts
 create mode 100644 arch/arm/mach-mxs/mach-mxs.c
 rename arch/arm/mach-mxs/include/mach/mmc.h => include/linux/mmc/mxs-mmc.h (81%)
