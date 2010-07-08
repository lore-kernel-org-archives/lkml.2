Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463Ab0GHIUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 04:20:09 -0400
Received: from gate.crashing.org ([63.228.1.57]:52910 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053Ab0GHIUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 04:20:06 -0400
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Jul 2010 18:19:44 +1000
Message-ID: <1278577184.28659.92.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are a few powerpc nits and bits still for 2.6.35. Mostly simple/trivial
stuff and some gcc-4.5 related fixes.

Thanks !

Cheers,
Ben.

The following changes since commit 2aa72f612144a0a7d4b0b22ae7c122692ac6a013:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/net-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Anton Blanchard (1):
      powerpc: Linux cannot run with 0 cores

Denis Kirjanov (1):
      powerpc/iseries: Fix possible null pointer dereference in iSeries_pcibios_fixup_resources

Johannes Berg (1):
      powerpc: Fix logic error in fixup_irqs

Matt Evans (1):
      powerpc/perf_event: Fix for power_pmu_disable()

Paul E. McKenney (1):
      powerpc: Fix default_machine_crash_shutdown #ifdef botch

Sam Ravnborg (1):
      powerpc: Fix userspace build of ptrace.h

Stephen Rothwell (3):
      powerpc: Fix module building for gcc 4.5 and 64 bit
      powerpc: Fix compile errors in prom_init_check for gcc 4.5
      powerpc: Fix feature-fixup tests for gcc 4.5

Yang Li (1):
      powerpc: Disable SPARSE_IRQ by default

 arch/powerpc/Kconfig                   |    4 +-
 arch/powerpc/Makefile                  |    4 +-
 arch/powerpc/include/asm/ptrace.h      |   32 ++++-----
 arch/powerpc/kernel/crash.c            |    2 +-
 arch/powerpc/kernel/irq.c              |    5 +-
 arch/powerpc/kernel/perf_event.c       |    5 +-
 arch/powerpc/kernel/prom_init.c        |    2 +-
 arch/powerpc/kernel/prom_init_check.sh |    6 ++
 arch/powerpc/lib/Makefile              |    4 +-
 arch/powerpc/lib/crtsavres.S           |  129 ++++++++++++++++++++++++++++++++
 arch/powerpc/lib/feature-fixups.c      |   17 ++--
 arch/powerpc/platforms/iseries/pci.c   |    6 +-
 scripts/mod/modpost.c                  |    5 +
 13 files changed, 184 insertions(+), 37 deletions(-)
 

