Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317Ab2IFRL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 13:11:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50497 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab2IFRLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 13:11:54 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:ae16:2dff:fe07:4e83]
Date: Thu, 6 Sep 2012 10:11:54 -0700
Message-ID: <CAOesGMjWUgFJ_Gmpn_y5V7KOV5JAnDxW2=-Y1o-ZF6Ny-FUhdQ@mail.gmail.com>
Subject: [GIT PULL] ARM: SoC fixes for v3.6-rc5
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 9acb172543aecb783e2e1e53e3f447d4c0f5c150:

  Merge tag 'fixes-3.6-rc3' of
git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc (2012-08-25
17:33:33 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git
tags/fixes-for-linus

for you to fetch changes up to e829c66745e66558b624fd635be4a384fe854944:

  ARM: gemini: fix the gemini build (2012-09-04 22:17:34 -0700)

----------------------------------------------------------------
arm-soc: bug fixes for v3.6-rc5

Mostly Renesas and Atmel bugfixes this time, targeting boot and build
problems. A couple of patches for gemini and kirkwood as well. On a
whole nothing very controversial.

----------------------------------------------------------------
Andrew Lunn (1):
      ARM: Kirkwood: Fix 'SZ_1M' undeclared here for db88f6281-bp-setup.c

Bo Shen (1):
      ARM: at91/dts: remove partial parameter in at91sam9g25ek.dts

Kuninori Morimoto (5):
      ARM: shmobile: sh73a0: fixup RELOC_BASE of intca_irq_pins_desc
      ARM: shmobile: marzen: fixup smsc911x id for regulator
      ARM: shmobile: armadillo800eva: fixup: sound card detection order
      ARM: shmobile: mackerel: fixup usb module order
      ARM: shmobile: armadillo800eva: enable rw rootfs mount

Laurent Pinchart (2):
      ARM: mach-shmobile: armadillo800eva: Fix GPIO buttons descriptions
      ARM: mach-shmobile: armadillo800eva: Enable power button as wakeup source

Linus Walleij (1):
      ARM: gemini: fix the gemini build

Ludovic Desroches (3):
      ARM: at91: fix system timer irq issue due to sparse irq support
      ARM: at91: fix rtc-at91sam9 irq issue due to sparse irq support
      ARM: at91/feature-removal-schedule: delay at91_mci removal

Nicolas Ferre (1):
      ARM: at91/clock: fix PLLA overclock warning

Olof Johansson (6):
      Merge branch 'fixes' of git://git.kernel.org/.../rafael/renesas into fixes
      Merge tag 'at91-fixes' of git://github.com/at91linux/linux-at91 into fixes
      Merge branch 'armadillo800eva' of
git://git.kernel.org/.../horms/renesas into fixes
      Merge branch 'fixes-for-v3.6-v2' of
git://git.infradead.org/users/jcooper/linux into fixes
      Merge branch 'fixes' of git://git.kernel.org/.../horms/renesas into fixes
      Merge branch 'fixes' of git://git.kernel.org/.../horms/renesas into fixes

 Documentation/feature-removal-schedule.txt     |  2 +-
 arch/arm/boot/dts/at91sam9g25ek.dts            |  2 +-
 arch/arm/configs/armadillo800eva_defconfig     |  2 +-
 arch/arm/mach-at91/at91rm9200_time.c           |  2 +-
 arch/arm/mach-at91/at91sam9260_devices.c       |  6 +++++-
 arch/arm/mach-at91/at91sam9261_devices.c       |  6 +++++-
 arch/arm/mach-at91/at91sam9263_devices.c       | 10 ++++++++--
 arch/arm/mach-at91/at91sam9g45_devices.c       |  6 +++++-
 arch/arm/mach-at91/at91sam9rl_devices.c        |  6 +++++-
 arch/arm/mach-at91/clock.c                     | 12 ++++++++++++
 arch/arm/mach-gemini/irq.c                     |  1 +
 arch/arm/mach-kirkwood/db88f6281-bp-setup.c    |  1 +
 arch/arm/mach-shmobile/board-armadillo800eva.c | 13 +++++++------
 arch/arm/mach-shmobile/board-mackerel.c        |  3 ++-
 arch/arm/mach-shmobile/board-marzen.c          |  2 +-
 arch/arm/mach-shmobile/intc-sh73a0.c           |  4 ++--
 drivers/rtc/rtc-at91sam9.c                     | 22 +++++++++++++++-------
 17 files changed, 73 insertions(+), 27 deletions(-)
