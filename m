Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989Ab2F2UqA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 16:46:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:46293 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932770Ab2F2UpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 16:45:21 -0400
Message-ID: <1341002709.2563.28.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Sat, 30 Jun 2012 06:45:09 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are a few powerpc fixes. Arguably some of this should have come to
you earlier but I'm only just catching up after my medical leave.

Mostly these fixes regressions, a couple are long standing bugs.

Cheers,
Ben.

The following changes since commit 9acc7bde23ebb19a704395f76490685e1513e422:

  Merge tag 'hwmon-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging (2012-06-28 12:38:51 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to bc6dc752f35488160ffac07ae91bed1bddaea32a:

  powerpc/pseries: Fix software invalidate TCE (2012-06-29 14:35:37 +1000)

----------------------------------------------------------------
Anton Blanchard (1):
      powerpc: check_and_cede_processor() never cedes

Li Zhong (1):
      powerpc: Fix Section mismatch warnings in prom_init.c

Michael Ellerman (1):
      powerpc: Fix BPF_JIT code to link with multiple TOCs

Michael Neuling (2):
      powerpc: Fix uninitialised error in numa.c
      powerpc/pseries: Fix software invalidate TCE

Steven Rostedt (1):
      powerpc/ftrace: Do not trace restore_interrupts()

Tiejun Chen (1):
      ppc64: fix missing to check all bits of _TIF_USER_WORK_MASK in preempt

 arch/powerpc/include/asm/hw_irq.h               |    5 ++
 arch/powerpc/kernel/entry_64.S                  |   97 ++++++++++-------------
 arch/powerpc/kernel/irq.c                       |    2 +-
 arch/powerpc/kernel/prom_init.c                 |    4 +-
 arch/powerpc/mm/numa.c                          |    2 +-
 arch/powerpc/net/bpf_jit_64.S                   |    2 +
 arch/powerpc/platforms/pseries/iommu.c          |    4 +-
 arch/powerpc/platforms/pseries/processor_idle.c |    2 +-
 8 files changed, 54 insertions(+), 64 deletions(-)


