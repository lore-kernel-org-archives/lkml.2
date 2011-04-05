Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab1DELn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 07:43:28 -0400
Received: from gate.crashing.org ([63.228.1.57]:47731 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743Ab1DELn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 07:43:26 -0400
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Apr 2011 17:05:10 +1000
Message-ID: <1301987110.2549.146.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Some minor powerpc fixes for you, freescale device-tree updates
and a few nits like wrong ifdef's etc... 

Cheers,
Ben.

The following changes since commit b2a8b4b81966094703088a7bc76a313af841924d:

  Merge branch 'drm-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6 (2011-04-04 17:56:07 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Benjamin Herrenschmidt (2):
      Merge remote branch 'kumar/merge' into merge
      powerpc/pseries: Don't register global initcall

Kumar Gala (1):
      edac/mpc85xx: Limit setting/clearing of HID1[RFXE] to e500v1/v2 cores

Matt Evans (1):
      powerpc/pseries: Fix build without CONFIG_HOTPLUG_CPU

Paul Gortmaker (1):
      powerpc/kexec: Fix mismatched ifdefs for PPC64/SMP.

Prabhakar Kushwaha (1):
      powerpc/85xx: Update dts for PCIe memory maps to match u-boot of Px020RDB

Ryan Grimm (1):
      powerpc: Set nr_cpu_ids early and use it to free PACAs

 arch/powerpc/boot/dts/p1020rdb.dts            |   12 +++++-----
 arch/powerpc/boot/dts/p2020rdb.dts            |   12 +++++-----
 arch/powerpc/boot/dts/p2020rdb_camp_core0.dts |    4 +-
 arch/powerpc/boot/dts/p2020rdb_camp_core1.dts |   10 ++++----
 arch/powerpc/kernel/crash.c                   |    6 ++--
 arch/powerpc/kernel/paca.c                    |    2 +-
 arch/powerpc/kernel/setup-common.c            |    3 ++
 arch/powerpc/platforms/pseries/setup.c        |    2 +-
 arch/powerpc/platforms/pseries/smp.c          |   17 ++++++++++-----
 drivers/edac/mpc85xx_edac.c                   |   27 +++++++++++++++++-------
 10 files changed, 57 insertions(+), 38 deletions(-)


