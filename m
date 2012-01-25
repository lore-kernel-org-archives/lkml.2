Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842Ab2AYDB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 22:01:29 -0500
Received: from gate.crashing.org ([63.228.1.57]:48303 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460Ab2AYDB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 22:01:28 -0500
Message-ID: <1327460475.19850.51.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 25 Jan 2012 14:01:15 +1100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are a few fixes on top of rc1, a couple of important compile
regressions and a couple of minor embedded additions.

Cheers,
Ben.

The following changes since commit 4a7cbb56fdbd92a47f57ca8b25bf5db35f0d6518:

  regulator: Fix documentation for of_node parameter of regulator_register() (2012-01-24 10:40:06 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Benjamin Herrenschmidt (3):
      Merge remote-tracking branch 'kumar/merge' into merge
      powerpc/powernv: Fix PCI resource handling
      powerpc: Fix build on some non-freescale platforms

Christian Kujau (1):
      powerpc/crash: Fix build error without SMP

Deepthi Dharwar (1):
      powerpc/cpuidle: Make it a bool, not a tristate

Jerry Huang (1):
      powerpc/85xx: Fix cmd12 bug and add the chip compatible for eSDHC

Julia Lawall (1):
      arch/powerpc/sysdev/fsl_pci.c: add missing iounmap

Michael Neuling (1):
      powerpc: fix compile error with 85xx/p1022_ds.c

Ramneek Mehresh (2):
      powerpc/85xx: Enable USB2 controller node for P1020RDB
      powerpc/85xx: Add dr_mode property in USB nodes

 arch/powerpc/boot/dts/fsl/mpc8536si-post.dtsi |    4 ++
 arch/powerpc/boot/dts/fsl/p1010si-post.dtsi   |    3 +-
 arch/powerpc/boot/dts/fsl/p1020si-post.dtsi   |    4 ++
 arch/powerpc/boot/dts/fsl/p1022si-post.dtsi   |    3 +-
 arch/powerpc/boot/dts/fsl/p2020si-post.dtsi   |    4 ++
 arch/powerpc/boot/dts/p1020rdb.dtsi           |   13 +++----
 arch/powerpc/boot/dts/p1021mds.dts            |    3 +-
 arch/powerpc/boot/dts/p2020ds.dtsi            |    3 +-
 arch/powerpc/boot/dts/p2020rdb.dts            |    3 +-
 arch/powerpc/kernel/crash.c                   |    2 +-
 arch/powerpc/kernel/legacy_serial.c           |    2 +
 arch/powerpc/platforms/85xx/p1022_ds.c        |    1 +
 arch/powerpc/platforms/powernv/pci-ioda.c     |   43 +++++++++++++++---------
 arch/powerpc/platforms/pseries/Kconfig        |    2 +-
 arch/powerpc/sysdev/fsl_pci.c                 |    5 ++-
 15 files changed, 63 insertions(+), 32 deletions(-)


