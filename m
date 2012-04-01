Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583Ab2DAF4W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 01:56:22 -0400
Received: from ozlabs.org ([203.10.76.45]:50325 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394Ab2DAF4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 01:56:20 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>
Cc: Chris Metcalf <cmetcalf@tilera.com> (arch/tile)
Cc: cpufreq@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Jonas Aaberg <jonas.aberg@stericsson.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-hexagon@vger.kernel.org
Cc: linux-mips@linux-mips.org
Cc: Martin Persson <martin.persson@stericsson.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Sundar Iyer <sundar.iyer@stericsson.com>
Cc: user-mode-linux-devel@lists.sourceforge.net
Subject: [PULL] cpumask cleanups
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Sun, 01 Apr 2012 15:25:50 +0930
Message-ID: <87sjgovvvd.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Somehow forgot to send this out; it's been sitting in linux-next, and
if you don't want it, it can sit there another cycle)

To git@github.com:rustyrussell/linux.git
   f946eeb..615399c  master -> master
 + 9dcbe9d...6ac67b9 for-linus -> for-linus (forced update)
The following changes since commit b5174fa3a7f4f8f150bfa3b917c92608953dfa0f:

  Merge tag 'mmc-merge-for-3.4-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc (2012-03-28 20:59:45 -0700)

are available in the git repository at:

  git://github.com/rustyrussell/linux.git master

Rusty Russell (4):
      remove references to cpu_*_map in arch/
      drivers/cpufreq/db8500-cpufreq: remove references to cpu_*_map.
      documentation: remove references to cpu_*_map.
      cpumask: remove old cpu_*_map.

 Documentation/cgroups/cpusets.txt   |    2 +-
 Documentation/cpu-hotplug.txt       |   22 +++++++++++-----------
 arch/alpha/kernel/smp.c             |    2 +-
 arch/arm/kernel/kprobes.c           |    4 ++--
 arch/arm/kernel/smp.c               |    7 ++++---
 arch/hexagon/kernel/smp.c           |    8 ++++----
 arch/ia64/kernel/acpi.c             |    2 +-
 arch/mips/cavium-octeon/smp.c       |    4 ++--
 arch/mips/kernel/mips-mt-fpaff.c    |    2 +-
 arch/mips/kernel/proc.c             |    2 +-
 arch/mips/kernel/smp-bmips.c        |    2 +-
 arch/mips/kernel/smp.c              |   27 ++++++++++++---------------
 arch/mips/kernel/smtc.c             |    2 +-
 arch/mips/mm/c-octeon.c             |    6 +++---
 arch/mips/netlogic/common/smp.c     |    6 +++---
 arch/mips/pmc-sierra/yosemite/smp.c |    8 ++++----
 arch/mips/sgi-ip27/ip27-smp.c       |    2 +-
 arch/mips/sibyte/bcm1480/smp.c      |    7 +++----
 arch/mips/sibyte/sb1250/smp.c       |    7 +++----
 arch/sparc/kernel/leon_kernel.c     |    6 +++---
 arch/tile/kernel/setup.c            |    8 ++++----
 arch/um/kernel/skas/process.c       |    2 +-
 arch/um/kernel/smp.c                |    9 ++++-----
 arch/x86/xen/enlighten.c            |    2 +-
 drivers/cpufreq/db8500-cpufreq.c    |    2 +-
 include/linux/cpumask.h             |    6 ------
 init/Kconfig                        |    4 ++--
 kernel/cpuset.c                     |   10 +++++-----
 28 files changed, 80 insertions(+), 91 deletions(-)
-- 
  How could I marry someone with more hair than me?  http://baldalex.org
