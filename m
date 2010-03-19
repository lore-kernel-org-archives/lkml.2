Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548Ab0CSHTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 03:19:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:43550 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224Ab0CSHTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 03:19:04 -0400
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Mar 2010 18:18:50 +1100
Message-ID: <1268983130.8599.56.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here's a handful of powerpc fixes for 2.6.34, along with a patch
from Fujita Tomonori to remove a config option that is mostly
useless nowadays.

Cheers,
Ben.

The following changes since commit 39710479303fd3affb3e204e9a7a75cc676977b5:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../vapier/blackfin

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Benjamin Herrenschmidt (1):
      Merge commit 'kumar/merge' into merge

FUJITA Tomonori (2):
      powerpc: Fix swiotlb to respect the boot option
      powerpc: Remove IOMMU_VMERGE config option

Kumar Gala (2):
      powerpc/85xx: Make sure lwarx hint isn't set on ppc32
      powerpc/fsl-booke: Get coherent bit from PTE

Márton Németh (1):
      powerpc: Do not call prink when CONFIG_PRINTK is not defined

Nathan Lynch (1):
      powerpc: Use correct ccr bit for syscall error status

 arch/powerpc/Kconfig                  |   13 -------------
 arch/powerpc/include/asm/ppc-opcode.h |    6 +++---
 arch/powerpc/include/asm/syscall.h    |    6 +++---
 arch/powerpc/kernel/head_fsl_booke.S  |    7 ++++---
 arch/powerpc/kernel/iommu.c           |    7 +------
 arch/powerpc/kernel/setup_32.c        |    6 ------
 arch/powerpc/kernel/setup_64.c        |    6 ------
 arch/powerpc/mm/mem.c                 |    6 ++++++
 8 files changed, 17 insertions(+), 40 deletions(-)


