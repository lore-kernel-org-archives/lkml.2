Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab1DRGfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 02:35:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:42129 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911Ab1DRGfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 02:35:41 -0400
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Apr 2011 16:35:01 +1000
Message-ID: <1303108501.28876.155.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are a few fixes and quirks for powerpc post -rc3. Hopefully that
should be the end of it pending major bugs/issues/regressions.

Cheers,
Ben.

The following changes since commit a1b49cb7e2a7961ec3aa8b64860bf480d4ec9077:

  Merge branch 'i2c-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging (2011-04-17 17:37:02 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Anton Blanchard (1):
      powerpc: Fix oops if scan_dispatch_log is called too early

Benjamin Herrenschmidt (2):
      Merge remote branch 'kumar/merge' into merge
      powerpc/powermac: Build fix with SMP and CPU hotplug

Eric B Munson (1):
      powerpc/perf_event: Skip updating kernel counters if register value shrinks

Kumar Gala (2):
      powerpc/book3e: Fix CPU feature handling on 64-bit e5500
      powerpc/85xx: disable Suspend support if SMP enabled

Nishanth Aravamudan (1):
      powerpc/pseries: Use a kmem cache for DTL buffers

Paul Gortmaker (1):
      powerpc/kexec: Fix regression causing compile failure on UP

Prabhakar Kushwaha (2):
      powerpc/85xx: Don't add disabled PCIe devices
      powerpc: Check device status before adding serial device

Scott Wood (1):
      powerpc/e500mc: Remove CPU_FTR_MAYBE_CAN_NAP/CPU_FTR_MAYBE_CAN_DOZE

Stefan Roese (1):
      powerpc: Don't write protect kernel text with CONFIG_DYNAMIC_FTRACE enabled

 arch/powerpc/Kconfig                   |    2 +-
 arch/powerpc/include/asm/cputable.h    |   16 ++++++++++++-
 arch/powerpc/include/asm/pte-common.h  |    2 +-
 arch/powerpc/kernel/cputable.c         |    2 +-
 arch/powerpc/kernel/crash.c            |   12 +++++-----
 arch/powerpc/kernel/legacy_serial.c    |    8 ++++--
 arch/powerpc/kernel/perf_event.c       |   37 +++++++++++++++++++++++++------
 arch/powerpc/kernel/time.c             |    3 ++
 arch/powerpc/platforms/powermac/smp.c  |    8 ++++--
 arch/powerpc/platforms/pseries/setup.c |   12 ++++++++-
 arch/powerpc/sysdev/fsl_pci.c          |    5 ++++
 11 files changed, 81 insertions(+), 26 deletions(-)


