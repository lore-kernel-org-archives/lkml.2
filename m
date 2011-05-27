Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758658Ab1E0G4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 02:56:08 -0400
Received: from gate.crashing.org ([63.228.1.57]:39414 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757391Ab1E0G4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 02:56:06 -0400
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 May 2011 16:55:53 +1000
Message-ID: <1306479353.7481.546.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here's the 3 patches Kumar was complaining I forgot to pull :-)

Two are pretty old patches related to FSL RapidIO stuff, and
one is a bug fix.

Cheers,
Ben.

The following changes since commit dc7acbb2518f250050179c8581a972df3b6a24f1:

  Merge branch 'upstream/tidy-xen-mmu-2.6.39' of git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen (2011-05-26 19:01:15 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Benjamin Herrenschmidt (1):
      Merge remote branch 'kumar/merge' into merge

Shaohui Xie (2):
      powerpc/fsl_rio: move machine_check handler
      powerpc/fsl_rio: Error interrupt handler for sRIO on MPC85xx

Shengzhou Liu (1):
      powerpc/fsl_lbc: Add workaround for ELBC-A001 erratum

 arch/powerpc/include/asm/fsl_lbc.h |    2 +
 arch/powerpc/include/asm/rio.h     |    5 ++
 arch/powerpc/kernel/traps.c        |   13 +++++
 arch/powerpc/sysdev/fsl_lbc.c      |    9 +++-
 arch/powerpc/sysdev/fsl_rio.c      |  100 ++++++++++++++++++++++++++++-------
 5 files changed, 107 insertions(+), 22 deletions(-)


