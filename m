Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab2D3Bo5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 21:44:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:56753 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754432Ab2D3Bo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 21:44:56 -0400
Message-ID: <1335750286.20866.25.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Mon, 30 Apr 2012 11:44:46 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are a handful more fixes for powerpc. The irq stuff are all
regression fixes, and Gavin's patch is a simple compile fix.

Cheers,
Ben.

The following changes since commit 69964ea4c7b68c9399f7977aa5b9aa6539a6a98a:

  Linux 3.4-rc5 (2012-04-29 15:19:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to 810b4de25e53459323ff48957b0162b48d6cbd57:

  tty/serial/pmac_zilog: Fix "nobody cared" IRQ message (2012-04-30 10:59:58 +1000)

----------------------------------------------------------------
Gavin Shan (1):
      powerpc/pseries: Rivet CONFIG_EEH for pSeries platform

Grant Likely (2):
      powerpc/8xx: Fix NR_IRQ bugs and refactor 8xx interrupt controller
      powerpc/irqdomain: Fix broken NR_IRQ references

Larry Finger (1):
      tty/serial/pmac_zilog: Fix "nobody cared" IRQ message

 arch/powerpc/include/asm/irq.h               |    4 --
 arch/powerpc/kernel/irq.c                    |    6 +--
 arch/powerpc/kernel/machine_kexec.c          |    7 +--
 arch/powerpc/platforms/cell/axon_msi.c       |    8 ++--
 arch/powerpc/platforms/cell/beat_interrupt.c |    2 +-
 arch/powerpc/platforms/powermac/pic.c        |    6 +--
 arch/powerpc/platforms/pseries/Kconfig       |    4 +-
 arch/powerpc/sysdev/cpm2_pic.c               |    3 +-
 arch/powerpc/sysdev/mpc8xx_pic.c             |   61 +++++++++-----------------
 arch/powerpc/sysdev/xics/xics-common.c       |    7 ++-
 drivers/tty/serial/pmac_zilog.c              |    6 +--
 11 files changed, 39 insertions(+), 75 deletions(-)


