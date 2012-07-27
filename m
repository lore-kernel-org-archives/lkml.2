Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab2G0B4q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 21:56:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37668 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab2G0B4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 21:56:45 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
Date: Thu, 26 Jul 2012 18:56:45 -0700
Message-ID: <CAOesGMiyPjMhLLV9_u8tRHE9UZZAx7_YCs_NS0D_E5kZJuy3vw@mail.gmail.com>
Subject: [GIT PULL] ARM: SoC fixes
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,


The following changes since commit 9161c3b796a2841a9a7be3d9c9dd121269ce90e8:

  Merge tag 'clk-for-linus' of
git://git.linaro.org/people/mturquette/linux (2012-07-24 16:40:57
-0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git
tags/fixes-for-linus

for you to fetch changes up to fa7c865ad999d6ca340bca471fab7f3a3e6ae011:

  ARM: mxs: fix compile error caused by prom_update_property change
(2012-07-25 22:36:39 -0700)

----------------------------------------------------------------
ARM: SoC fixes

A mixed bag of fixes, some for merge window fallout (tegra, MXS), and
a short series of fixes for marvell platforms that didn't make it in
before 3.5.

----------------------------------------------------------------
Andrew Lunn (2):
      ARM: Kirkwood: Ensure runit clock always ticks.
      ARM: Kirkwood: Replace mrvl with marvell

Arnd Bergmann (2):
      Merge branch 'master' of git://git.kernel.org/.../torvalds/linux
into fixes
      Merge branch 'v3.5-rc7-fixes' of git://github.com/lunn/linux into fixes

Hannes Reinecke (1):
      ARM: Dove: Fixup ge00 initialisation

Laxman Dewangan (1):
      ARM: tegra: harmony: add regulator supply name and its input supply

Pawel Moll (1):
      ARM: versatile: Don't use platform clock for Integrator & VE

Shawn Guo (1):
      ARM: mxs: fix compile error caused by prom_update_property change

Simon Baatz (2):
      ARM: Kirkwood: Fix PHY disable clk problems
      ARM: Orion: fix driver probe error handling with respect to clk

Stephen Warren (2):
      ARM: dt: tegra trimslice: add vbus-gpio property
      ARM: dt: tegra trimslice: enable USB2 port

Tony Prisk (1):
      ARM: vt8500: Add maintainer for VT8500 architecture

 .../devicetree/bindings/mtd/orion-nand.txt         |  4 +-
 MAINTAINERS                                        | 11 ++++
 arch/arm/Kconfig                                   |  2 -
 arch/arm/boot/dts/kirkwood-dns320.dts              |  2 +-
 arch/arm/boot/dts/kirkwood-dns325.dts              |  2 +-
 arch/arm/boot/dts/kirkwood-dreamplug.dts           |  2 +-
 arch/arm/boot/dts/kirkwood-ib62x0.dts              |  2 +-
 arch/arm/boot/dts/kirkwood-iconnect.dts            |  2 +-
 arch/arm/boot/dts/kirkwood.dtsi                    |  6 +-
 arch/arm/boot/dts/tegra20-trimslice.dts            |  2 +
 arch/arm/mach-dove/common.c                        |  4 +-
 arch/arm/mach-kirkwood/common.c                    | 70 +++++++++++++++++-----
 arch/arm/mach-mxs/mach-mxs.c                       |  8 +--
 arch/arm/mach-tegra/board-harmony-power.c          | 33 ++++++----
 drivers/crypto/mv_cesa.c                           |  4 ++
 drivers/mmc/host/mvsdio.c                          |  4 ++
 drivers/mtd/nand/orion_nand.c                      |  6 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c         |  6 ++
 drivers/rtc/rtc-mv.c                               |  2 +-
 drivers/usb/host/ehci-orion.c                      |  4 ++
 sound/soc/kirkwood/kirkwood-i2s.c                  |  8 ++-
 21 files changed, 133 insertions(+), 51 deletions(-)
