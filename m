Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857Ab1CBEzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 23:55:10 -0500
Received: from gate.crashing.org ([63.228.1.57]:33264 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754630Ab1CBEzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 23:55:08 -0500
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Mar 2011 15:54:56 +1100
Message-ID: <1299041696.8833.823.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are 3 patches for powerpc, one reverts an Anton mistake (such a thing
does exist indeed ! here goes my blind faith...) and a couple of fixes
that would be much welcome to have in .38

Cheers,
Ben.

The following changes since commit dd9c1549edef02290edced639f67b54a25abbe0e:

  Linux 2.6.38-rc7 (2011-03-01 13:55:12 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Anton Blanchard (1):
      powerpc/kexec: Restore ppc_md.machine_kexec

K.Prasad (1):
      powerpc: Fix call to flush_ptrace_hw_breakpoint()

Peter Zijlstra (1):
      powerpc/mm: Make hpte_need_flush() safe for preemption

 arch/powerpc/include/asm/machdep.h  |    6 ++++++
 arch/powerpc/kernel/machine_kexec.c |    5 ++++-
 arch/powerpc/kernel/process.c       |    8 +++++---
 arch/powerpc/mm/tlb_hash64.c        |    6 +++---
 4 files changed, 18 insertions(+), 7 deletions(-)


