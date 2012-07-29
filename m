Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab2G2X01 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 19:26:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43657 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665Ab2G2X0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 19:26:25 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:470:1f05:1640:cab:32f2:2e5d:2fb]
Date: Sun, 29 Jul 2012 16:26:25 -0700
Message-ID: <CAOesGMgCOwkFM0nZ9aHhrP=P5XhnjUVVccY4YS3-go0PmJbKWw@mail.gmail.com>
Subject: [GIT PULL 2/2] ARM: arm-soc board updates, take 2
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This branch contains board updates, mostly for shmobile, but also a
couple for PXA.

The shmobile platforms are still in the early stages of DT enablement,
so there's a bit more updates here than we'd ideally want to see:
- regulator updates to provide some fixed regulators on several boards
- gpio support updates for multiple boards
- misc updates for recently-introduced boards armadillo800eva and kzm9g
- defconfig updates

----------------------------------------------------------------

The following changes since commit a737874bda296ea1b4876564970c3a0107834efc:

  Merge tag 'soc2' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/boards2

for you to fetch changes up to 43cb4a02d27ad9525ad23984d4fd06972810439f:

  Merge branch 'board-specific' of git://github.com/hzhuang1/linux
into late/board

----------------------------------------------------------------

Arnd Bergmann (3):
      Merge tag 'topic/fixed' of
git://git.kernel.org/.../broonie/regulator into late/board
      Merge branch 'board' of git://git.kernel.org/.../rafael/renesas
into late/board
      Merge branch 'board-specific' of git://github.com/hzhuang1/linux
into late/board

Guennadi Liakhovetski (12):
      ARM: mach-shmobile: add 3.3V and 1.8V fixed regulators to mackerel
      ARM: mach-shmobile: add fixed voltage regulators to ag5evm
      ARM: mach-shmobile: add fixed voltage regulators to ap4evb
      ARM: mach-shmobile: add fixed voltage regulators to armadillo800eva
      ARM: mach-shmobile: add fixed voltage regulators to bonito
      ARM: mach-shmobile: add fixed voltage regulators to g4evm
      ARM: mach-shmobile: add fixed voltage regulators to kota2
      ARM: mach-shmobile: add fixed voltage regulators to kzm9d
      ARM: mach-shmobile: add fixed voltage regulators to kzm9g
      ARM: mach-shmobile: add fixed voltage regulators to marzen
      ARM: mach-shmobile: add SDHI2 to the 2.8V fixed regulator
consumers on kzm9g
      ARM: mach-shmobile: select the fixed regulator driver on several boards

Kuninori Morimoto (19):
      ARM: shmobile: armadillo800eva: enable HDMI
      ARM: shmobile: kzm9g: enable FSI-AK4648
      ARM: shmobile: armadillo800eva: enable camera
      ARM: shmobile: armadillo800eva: enable FSI-WM8978 sound
      ARM: shmobile: armadillo800eva: enable FSI-HDMI sound
      ARM: shmobile: armadillo800eva: enable DMAEngine on FSI
      ARM: shmobile: armadillo800eva: enable DMAEngine on SDHI
      ARM: shmobile: armadillo800eva: enable DMAEngine on USB
      ARM: shmobile: use common extra gpio functions on armadillo800eva
      ARM: shmobile: kzm9g: enable USB function
      ARM: shmobile: kzm9g: enable MicroSD
      ARM: shmobile: kzm9g: enable DMAEngine on FSI
      ARM: shmobile: kzm9g: enable DMAEngine on MMCIF
      ARM: shmobile: use common extra gpio functions on Mackerel
      ARM: shmobile: use common extra gpio functions on ap4evb
      ARM: shmobile: use common extra gpio functions on g4evm
      ARM: shmobile: armadillo800eva: USB Func enables external IRQ mode
      ARM: shmobile: armadillo800eva: A4LC domain includes LCDC
      ARM: shmobile: armadillo800eva: A3SP domain includes USB

Magnus Damm (1):
      ARM: mach-shmobile: kzm9d: Add defconfig

Paul Bolle (1):
      ARM: pxa: remove eseries.h

Paul Parsons (1):
      ARM: pxa: hx4700: Use DEFINE_RES_* macros consistently

Rafael J. Wysocki (22):
      Merge branch 'renesas-kzm9g' into renesas-board
      Merge branch 'renesas-r8a7740' into renesas-armadillo
      Merge branch 'renesas-sh73a0' into renesas-kzm9g
      Merge tag 'topic/fixed' of
git://git.kernel.org/.../broonie/regulator into renesas-board-common
      Merge branch 'renesas-board-common' into renesas-mackerel
      Merge branch 'renesas-board-common' into renesas-ap4evb
      Merge branch 'renesas-board-common' into renesas-armadillo
      Merge branch 'renesas-board-common' into renesas-g4evm
      Merge branch 'renesas-board-common' into renesas-kzm9g
      Merge branch 'renesas-r8a7740' into renesas-armadillo
      Merge branch 'renesas-soc' into renesas-board
      Merge branch 'renesas-board-common' into renesas-board
      Merge branch 'renesas-armadillo' into renesas-board
      Merge branch 'renesas-ag5evm' into renesas-board
      Merge branch 'renesas-ap4evb' into renesas-board
      Merge branch 'renesas-bonito' into renesas-board
      Merge branch 'renesas-g4evm' into renesas-board
      Merge branch 'renesas-kota2' into renesas-board
      Merge branch 'renesas-kzm9d' into renesas-board
      Merge branch 'renesas-kzm9g' into renesas-board
      Merge branch 'renesas-mackerel' into renesas-board
      Merge branch 'renesas-marzen' into renesas-board

Simon Horman (2):
      ARM: mach-shmobile: armadillo800eva: defconfig Allow use of
armhf userspace
      ARM: shmobile: kzm9g: defconfig enable INOTIFY_USER

Tetsuyuki Kobayashi (1):
      ARM: shmobile: kzm9g: Support Real Time Clock


 arch/arm/configs/armadillo800eva_defconfig     |  25 +-
 arch/arm/configs/kzm9d_defconfig               |  89 ++++
 arch/arm/configs/kzm9g_defconfig               |   8 +-
 arch/arm/mach-pxa/eseries.h                    |  14 -
 arch/arm/mach-pxa/hx4700.c                     |  56 +--
 arch/arm/mach-shmobile/Kconfig                 |  12 +
 arch/arm/mach-shmobile/board-ag5evm.c          |  82 +++-
 arch/arm/mach-shmobile/board-ap4evb.c          |  48 ++-
 arch/arm/mach-shmobile/board-armadillo800eva.c | 454 +++++++++++++++++++-
 arch/arm/mach-shmobile/board-bonito.c          |  10 +
 arch/arm/mach-shmobile/board-g4evm.c           |  52 ++-
 arch/arm/mach-shmobile/board-kota2.c           |  30 ++
 arch/arm/mach-shmobile/board-kzm9d.c           |  10 +
 arch/arm/mach-shmobile/board-kzm9g.c           | 320 ++++++++++++++
 arch/arm/mach-shmobile/board-mackerel.c        |  59 +--
 arch/arm/mach-shmobile/board-marzen.c          |  10 +
 16 files changed, 1126 insertions(+), 153 deletions(-)
 create mode 100644 arch/arm/configs/kzm9d_defconfig
 delete mode 100644 arch/arm/mach-pxa/eseries.h
