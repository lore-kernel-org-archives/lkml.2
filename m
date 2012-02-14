Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab2BNGVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 01:21:16 -0500
Received: from gate.crashing.org ([63.228.1.57]:38452 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246Ab2BNGVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 01:21:10 -0500
Message-ID: <1329200460.3772.1.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Tue, 14 Feb 2012 17:21:00 +1100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are a few powerpc fixes for 3.3, all pretty trivial. I also
added the patch to define GET_IP/SET_IP so we can use some more
asm-generic goodness.

Cheers,
Ben.

The following changes since commit 3ec1e88b33a3bdd852ce8e014052acec7a9da8b5:

  Merge branch 'for-linus' of git://git.kernel.dk/linux-block (2012-02-11 10:07:11 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to 778a785f02ad846446e91dab49331bd7d853c514:

  powerpc/pseries/eeh: Fix crash when error happens during device probe (2012-02-14 15:01:39 +1100)

----------------------------------------------------------------
Benjamin Herrenschmidt (3):
      powerpc/wsp: Permanently enable PCI class code workaround
      powerpc/wsp: Fix IRQ affinity setting
      powerpc: Fix WARN_ON in decrementer_check_overflow

Brian King (1):
      powerpc/pseries: Fix partition migration hang in stop_topology_update

Michael Ellerman (1):
      powerpc/powernv: Disable interrupts while taking phb->lock

Srikar Dronamraju (1):
      powerpc: Implement GET_IP/SET_IP

Thadeu Lima de Souza Cascardo (1):
      powerpc/pseries/eeh: Fix crash when error happens during device probe

 arch/powerpc/include/asm/ppc-pci.h       |    5 +++++
 arch/powerpc/include/asm/ptrace.h        |   20 ++++++++++++--------
 arch/powerpc/kernel/irq.c                |    6 +++++-
 arch/powerpc/kernel/rtas.c               |    5 +++--
 arch/powerpc/platforms/powernv/pci.c     |   22 ++++++++++++++--------
 arch/powerpc/platforms/pseries/eeh.c     |    4 ++--
 arch/powerpc/platforms/pseries/suspend.c |    6 +++++-
 arch/powerpc/platforms/wsp/ics.c         |    2 +-
 arch/powerpc/platforms/wsp/wsp_pci.c     |    8 ++++----
 9 files changed, 51 insertions(+), 27 deletions(-)


