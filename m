Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759106Ab0J2Dps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 23:45:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33124
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758315Ab0J2Dpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 23:45:41 -0400
Date: Thu, 28 Oct 2010 20:46:04 -0700 (PDT)
Message-Id: <20101028.204604.226766493.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some left over signal fixes from Al, please some build
fixups for LEON and other configurations from Namhyung
Kim.

Please pull, thanks!

The following changes since commit b18cae4224bde7e5a332c19bc99247b2098ea232:

  Merge branch 'for-next' of git://android.git.kernel.org/kernel/tegra (2010-10-25 18:42:06 -0700)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

Al Viro (1):
      sparc: keep calling do_signal() as long as pending signals remain

Daniel Hellstrom (1):
      sparc: Fixed random SPARC/LEON SMP CPU Stuck problem.

David S. Miller (1):
      sparc32: Fix unaligned stack handling on trap return.

Namhyung Kim (4):
      sparc: don't #include asm/system.h in asm/jump_label.h
      sparc32: remove CONFIG_HAVE_PERF_EVENTS option
      sparc32: fix build failure on CONFIG_SPARC_LEON
      kbuild: add ARCH=sparc32 target

 Makefile                            |    3 ++
 arch/sparc/Kconfig                  |    3 --
 arch/sparc/include/asm/jump_label.h |    1 -
 arch/sparc/kernel/irq_32.c          |    4 +-
 arch/sparc/kernel/leon_smp.c        |    4 +-
 arch/sparc/kernel/rtrap_32.S        |    6 ++--
 arch/sparc/kernel/rtrap_64.S        |   36 ++--------------------------------
 arch/sparc/mm/fault_32.c            |   12 +++++++++++
 8 files changed, 25 insertions(+), 44 deletions(-)
