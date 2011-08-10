Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab1HJP2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 11:28:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:59395 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438Ab1HJP2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 11:28:02 -0400
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 10:27:52 -0500
Message-ID: <1312990072.1674.5.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are a few fixes for powerpc. Mostly innocuous stuff, in fact most of
it has been in my tree for a while, I just hadn't got a chance to actually
send it as I was travelling.

Cheers,
Ben.

The following changes since commit 53d1e658df6e26d62500410719aaee2b82067c03:

  Merge branch 'devicetree/merge' of git://git.secretlab.ca/git/linux-2.6 (2011-08-04 06:37:07 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git ..BRANCH.NOT.VERIFIED..

Anatolij Gustschin (1):
      MAINTAINERS: change maintainership of mpc5xxx

Anton Blanchard (10):
      powerpc: Fix device tree claim code
      powerpc: Clean up some panic messages in prom_init
      powerpc: Jump label misalignment causes oops at boot
      powerpc: pseries: Fix kexec on machines with more than 4TB of RAM
      powerpc: Move kdump default base address to half RMO size on 64bit
      powerpc: Lack of ibm,io-events not that important!
      powerpc: Make KVM_GUEST default to n
      powerpc/pseries: Fix kexec on recent firmware versions
      powerpc/pseries: Cleanup VPA registration and deregistration errors
      powerpc/pseries: Simplify vpa deregistration functions

Benjamin Herrenschmidt (3):
      powerpc/4xx: Fix build of PCI code on 405
      powerpc: Fix build without CONFIG_PCI
      powerpc: Really fix build without CONFIG_PCI

David Ahern (1):
      powerpc/perf: Disable pagefaults during callchain stack read

Nishanth Aravamudan (1):
      powerpc/kvm: Fix build errors with older toolchains

Peter Zijlstra (1):
      ppc: Remove duplicate definition of PV_POWER7

Scott Wood (2):
      powerpc: mtspr/mtmsr should take an unsigned long
      powerpc: Return the_cpu_ spec from identify_cpu

 MAINTAINERS                                     |    4 +-
 arch/powerpc/include/asm/jump_label.h           |    2 -
 arch/powerpc/include/asm/kdump.h                |   10 -------
 arch/powerpc/include/asm/reg.h                  |    8 +++--
 arch/powerpc/kernel/cputable.c                  |   11 ++++---
 arch/powerpc/kernel/iomap.c                     |    2 +
 arch/powerpc/kernel/machine_kexec.c             |   10 +++++--
 arch/powerpc/kernel/perf_callchain.c            |   20 +++++++++++--
 arch/powerpc/kernel/prom_init.c                 |   14 +++++----
 arch/powerpc/kvm/book3s_hv_rmhandlers.S         |    4 +-
 arch/powerpc/platforms/Kconfig                  |    2 +-
 arch/powerpc/platforms/pseries/dtl.c            |    2 +-
 arch/powerpc/platforms/pseries/hotplug-cpu.c    |    4 +-
 arch/powerpc/platforms/pseries/io_event_irq.c   |    8 ++---
 arch/powerpc/platforms/pseries/kexec.c          |   34 +++++++++++++++--------
 arch/powerpc/platforms/pseries/lpar.c           |   19 ++++++-------
 arch/powerpc/platforms/pseries/plpar_wrappers.h |   12 ++++----
 arch/powerpc/platforms/pseries/setup.c          |    5 ++-
 arch/powerpc/sysdev/ppc4xx_pci.c                |    5 ++-
 19 files changed, 99 insertions(+), 77 deletions(-)
 

