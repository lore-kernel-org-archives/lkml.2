Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab2JRJYB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 05:24:01 -0400
Received: from gate.crashing.org ([63.228.1.57]:42113 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736Ab2JRJX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 05:23:59 -0400
Message-ID: <1350552198.2476.5.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Thu, 18 Oct 2012 20:23:18 +1100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are a handful of powerpc related fixes for you to pull.

Cheers,
Ben.

The following changes since commit 18673533256a2953ccefded52df2679de8640685:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2012-10-17 12:41:18 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to 83dac59409387789b88bed40b1be86a8abc572be:

  cpuidle/powerpc: Fix snooze state problem in the cpuidle design on pseries. (2012-10-18 10:57:25 +1100)

----------------------------------------------------------------
Aneesh Kumar K.V (1):
      powerpc: Build fix for powerpc KVM

Benjamin Herrenschmidt (1):
      Revert "powerpc/perf: Use pmc_overflow() to detect rolled back events"

Deepthi Dharwar (3):
      cpuidle/powerpc: Fix target residency initialisation in pseries cpuidle
      cpuidle/powerpc: Fix smt_snooze_delay functionality.
      cpuidle/powerpc: Fix snooze state problem in the cpuidle design on pseries.

 arch/powerpc/include/asm/kvm_book3s_32.h        |    1 +
 arch/powerpc/include/asm/processor.h            |    4 +-
 arch/powerpc/kernel/sysfs.c                     |    2 +-
 arch/powerpc/kvm/book3s_32_mmu_host.c           |    4 +-
 arch/powerpc/perf/core-book3s.c                 |    2 +-
 arch/powerpc/platforms/pseries/processor_idle.c |   62 +++++++++++------------
 6 files changed, 36 insertions(+), 39 deletions(-)


