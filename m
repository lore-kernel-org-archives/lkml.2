Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894Ab2JAX6a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:58:30 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:57381 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758841Ab2JAX5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:57:49 -0400
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 10/12] ARM: soc: device tree updates, take 2
Date: Mon,  1 Oct 2012 16:57:05 -0700
Message-Id: <1349135827-24790-11-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.1.488.g05fbf7a
In-Reply-To: <1349135827-24790-1-git-send-email-olof@lixom.net>
References: <1349135827-24790-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This branch contains mostly a set of changes for device tree bindings
on Samsung Exynos. It was staged behind the other branches due to
dependencies on pincontrol and board changes.

Conflicts:
* remove/remove conflict in arch/arm/mach-exynos/clock-exynos5.c. Remove
  both sides, i.e. the whole first entry.

----------------------------------------------------------------

The following changes since commit a8e1ceb728d249fbe0bc5e30b9b8ceb0f33b54f5:

  Merge branch 'next/boards' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/dt2

for you to fetch changes up to 7b27fa258c8f2670a8c09bbc6c4b2c874d155da2:

  Merge branch 'next/dt2' into HEAD

----------------------------------------------------------------

Kukjin Kim (3):
      ARM: dts: use uart2 for console on smdkv310 and smdk5250
      Merge branches 'next/pinctrl-samsung' and 'next/board-samsung' into next/dt-samsung-new
      Merge branch 'next/dt-samsung' into next/dt-samsung-new

Olof Johansson (4):
      Merge branch 'samsung/boards' into next/dt2
      Merge branch 'samsung/pinctrl' into next/dt2
      Merge branch 'next/dt-samsung-new' of git://git.kernel.org/.../kgene/linux-samsung into next/dt2
      Merge branch 'next/dt2' into HEAD

Thomas Abraham (3):
      ARM: EXYNOS: Add support for MSHC controller clocks
      ARM: EXYNOS: Add AUXDATA support for MSHC controllers
      ARM: dts: Add nodes for dw_mmc controllers for Samsung EXYNOS5250 platforms

Tomasz Figa (6):
      ARM: dts: Move parts common to EXYNOS4 from exynos4210.dtsi to exynos4.dtsi
      ARM: EXYNOS: Use exynos4 prefix instead of exynos4210 on exynos4-dt
      ARM: dts: Assume status of all optional nodes as disabled for exynos4
      ARM: dts: Specify address and size cells for i2c controllers for EXYNOS4
      ARM: EXYNOS: Add OF compatibility lookups for EXYNOS4 i2c adapters
      ARM: dts: Add basic dts file for Samsung Trats board

Tushar Behera (1):
      ARM: dts: Enable on-board keys as wakeup source for exynos4210-origen


 arch/arm/boot/dts/exynos4.dtsi            | 248 +++++++++++++++++++++++++
 arch/arm/boot/dts/exynos4210-origen.dts   |  63 +------
 arch/arm/boot/dts/exynos4210-smdkv310.dts |  54 +-----
 arch/arm/boot/dts/exynos4210-trats.dts    | 237 +++++++++++++++++++++++
 arch/arm/boot/dts/exynos4210.dtsi         | 186 +------------------
 arch/arm/boot/dts/exynos5250-smdk5250.dts |  59 +++++-
 arch/arm/boot/dts/exynos5250.dtsi         |  32 ++++
 arch/arm/mach-exynos/Makefile.boot        |   2 +-
 arch/arm/mach-exynos/clock-exynos5.c      |  45 ++---
 arch/arm/mach-exynos/include/mach/map.h   |   4 +
 arch/arm/mach-exynos/mach-exynos4-dt.c    |  32 +++-
 arch/arm/mach-exynos/mach-exynos5-dt.c    |   8 +
 12 files changed, 644 insertions(+), 326 deletions(-)
 create mode 100644 arch/arm/boot/dts/exynos4.dtsi
 create mode 100644 arch/arm/boot/dts/exynos4210-trats.dts
