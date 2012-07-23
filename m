Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab2GWUdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 16:33:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:53791 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823Ab2GWUcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 16:32:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org
Subject: =?UTF-8?q?=5BGIT=20PULL=2015/15=5D=20arm-soc=3A=20clk=20changes?=
Date: Mon, 23 Jul 2012 22:32:41 +0200
Message-Id: <1343075561-17446-16-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1343075561-17446-1-git-send-email-arnd@arndb.de>
References: <1343075561-17446-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:K4yUeRzlt8jYkgja4ORIJ7PM+AAushgPHrzDDBOKxLA
 1Vmkn2nYhn/4q+NUXJy84O74ofvlsf69nKq9zrXvH4K9qxiU63
 ZFCtxZkiJKip1rOzc9mZIhdg56YXdtckNaGH98vq6ZxIOdkAQZ
 Uys2aUROjQ9lAlpndBZMG97n8XQBmC2zvp/E0gLZRPjRFDSsiI
 XyjRAD2rRAa2Eo0nnkB/jKyGgBwBDHErPcwV1JEmCstgxWXRrI
 eVuSc5hvG+L6EBOkcXNmJSqFPLOL69cVVVkjFbY/1ry7IHQKo6
 h7NLt3hOz/dkiPw+WdrpFYXq5LD1ZYm8IPGk0t2Aw8rgmTKLwd
 sSrxKRY5eRbkfo/3/VXEIXt2bWBvVpwJ8UTS3szcH
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit fb584511c4664573097ece7df0de06ad00b713a2:

  ARM: OMAP: sdrc: Fix the build break for OMAP4 only builds (2012-07-09 01:44:11 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git next/clk

for you to fetch changes up to 36c678f3c91ac92e9524abcf9b39f9f539d60279:

  Merge tag 'imx-clk' of git://git.pengutronix.de/git/imx/linux-2.6 into next/clk (2012-07-17 22:41:50 +0200)

----------------------------------------------------------------

arm-soc: clk changes

Clock support is moving to the clk subsystem. These tegra, omap and imx
changes are for code that is still platform specific and not (yet)
part of that subsystem.

----------------------------------------------------------------

Alexander Shiyan (4):
      ARM: i.MX5x clocks: Add EPIT support
      ARM: i.MX5x clocks: Fix parent for PWM clocks
      ARM: i.MX5x clocks: Fix GPT clocks
      ARM: i.MX5x CSPI: Fixed clock name for CSPI

Arnd Bergmann (6):
      Merge branch 'tegra/cleanup' into next/clk
      Merge branch 'for-3.6/common-clk' of git://git.kernel.org/.../swarren/linux-tegra into next/clk
      Merge branch 'omap/cleanup2' into next/clk
      Merge tag 'omap-devel-am33xx-data-for-v3.6' of git://git.kernel.org/.../tmlind/linux-omap into next/clk
      Merge tag 'imx-clk' of git://git.pengutronix.de/git/imx/linux-2.6 into next/clk
      Merge branch 'next/clk' into for-next

Fabio Estevam (3):
      ARM: clk-imx27: Fix rtc clock id
      ARM: mx27: Reenable silicon version print
      ARM: imx: clk-imx31: Fix clock id for rnga driver

Laxman Dewangan (1):
      ARM: tegra: dma: rename driver name for clock to "tegra-apbdma"

Paul Walmsley (1):
      ARM: OMAP3+: clock: Move common clksel_rate & clock data to common file

Prashant Gaikwad (10):
      ARM: tegra: add clk_prepare/clk_unprepare
      i2c: tegra: Add clk_prepare/clk_unprepare
      mmc: tegra: add clk_prepare/clk_unprepare
      USB: ehci-tegra: add clk_prepare/clk_unprepare
      Input: tegra-kbc - add clk_prepare/clk_unprepare
      spi/tegra: add clk_prepare/clk_unprepare
      staging: nvec: add clk_prepare/clk_unprepare
      ASoC: tegra: add clk_prepare/clk_unprepare
      crypto: add clk_prepare/clk_unprepare
      ARM: tegra: Remove second instance of uart clk

Simon Que (1):
      ARM: tegra: Fix PWM clock programming

Thierry Reding (1):
      ARM: tegra: Provide clock for only one PWM controller

Tony Lindgren (1):
      Merge tag 'omap-devel-e-for-3.5' of git://git.kernel.org/.../pjw/omap-pending into devel-am33xx-data

Uwe Kleine-König (1):
      ARM: imx: add missing item to the list of clock event modes

Vaibhav Hiremath (1):
      ARM: OMAP3+: clock33xx: Add AM33XX clock tree data

 arch/arm/mach-imx/clk-imx27.c                 |    4 +-
 arch/arm/mach-imx/clk-imx31.c                 |    4 +-
 arch/arm/mach-imx/clk-imx51-imx53.c           |   23 +-
 arch/arm/mach-omap2/Makefile                  |    1 +
 arch/arm/mach-omap2/clock.h                   |   14 +
 arch/arm/mach-omap2/clock33xx_data.c          | 1105 +++++++++++++++++++++++++
 arch/arm/mach-omap2/clock3xxx_data.c          |   20 +-
 arch/arm/mach-omap2/clock44xx_data.c          |   72 --
 arch/arm/mach-omap2/clock_common_data.c       |   77 ++
 arch/arm/mach-omap2/io.c                      |    2 +
 arch/arm/mach-tegra/cpu-tegra.c               |    6 +-
 arch/arm/mach-tegra/dma.c                     |    4 +-
 arch/arm/mach-tegra/pcie.c                    |    6 +-
 arch/arm/mach-tegra/powergate.c               |    4 +-
 arch/arm/mach-tegra/tegra2_clocks.c           |   58 +-
 arch/arm/mach-tegra/tegra30_clocks.c          |   28 +-
 arch/arm/mach-tegra/timer.c                   |    4 +-
 arch/arm/mach-tegra/usb_phy.c                 |   16 +-
 arch/arm/plat-mxc/devices/platform-spi_imx.c  |    2 +-
 arch/arm/plat-mxc/time.c                      |    3 +-
 arch/arm/plat-omap/include/plat/clkdev_omap.h |    1 +
 drivers/crypto/tegra-aes.c                    |   12 +-
 drivers/i2c/busses/i2c-tegra.c                |   10 +-
 drivers/input/keyboard/tegra-kbc.c            |    4 +-
 drivers/mmc/host/sdhci-tegra.c                |    6 +-
 drivers/spi/spi-tegra.c                       |    4 +-
 drivers/staging/nvec/nvec.c                   |    8 +-
 drivers/usb/host/ehci-tegra.c                 |   20 +-
 sound/soc/tegra/tegra20_i2s.c                 |    4 +-
 sound/soc/tegra/tegra20_spdif.c               |    4 +-
 sound/soc/tegra/tegra30_ahub.c                |    8 +-
 sound/soc/tegra/tegra30_i2s.c                 |    4 +-
 sound/soc/tegra/tegra_asoc_utils.c            |   12 +-
 33 files changed, 1347 insertions(+), 203 deletions(-)
