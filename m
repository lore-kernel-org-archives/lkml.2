Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab0KRFrB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 00:47:01 -0500
Received: from gate.crashing.org ([63.228.1.57]:60299 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619Ab0KRFrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 00:47:00 -0500
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Nov 2010 16:46:48 +1100
Message-ID: <1290059208.32570.3.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are a handful of bug fixes and trivialities for powerpc for you
to pull.

Thanks !

Cheers,
Ben.

The following changes since commit 7957f0a857754c555e07f58a3fb83ac29501478c:
  Linus Torvalds (1):
        Fix build failure due to hwirq.h needing smp_lock.h

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Alessio Igor Bogani (1):
      powerpc: Update a BKL related comment

Benjamin Herrenschmidt (1):
      powerpc: Fix div64 in bootloader

Kumar Gala (2):
      powerpc/mm: Fix build error in setup_initial_memory_limit
      powerpc/mm: Fix module instruction tlb fault handling on Book-E 64

Michael Neuling (1):
      powerpc: Fix call to subpage_protection()

Nishanth Aravamudan (1):
      powerpc/pseries: Don't override CONFIG_PPC_PSERIES_DEBUG

kerstin jonsson (1):
      powerpc: Set CONFIG_32BIT on ppc32

 arch/powerpc/Kconfig                       |    4 ++++
 arch/powerpc/boot/div64.S                  |    3 ++-
 arch/powerpc/kernel/setup_64.c             |    5 ++---
 arch/powerpc/mm/hash_utils_64.c            |    2 +-
 arch/powerpc/mm/tlb_low_64e.S              |    5 ++++-
 arch/powerpc/mm/tlb_nohash.c               |    2 +-
 arch/powerpc/platforms/pseries/Kconfig     |    6 ++++++
 arch/powerpc/platforms/pseries/eeh.c       |    2 --
 arch/powerpc/platforms/pseries/pci_dlpar.c |    2 --
 9 files changed, 20 insertions(+), 11 deletions(-)


