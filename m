Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab0DTItI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 04:49:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41611
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753983Ab0DTItD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 04:49:03 -0400
Date: Tue, 20 Apr 2010 01:49:08 -0700 (PDT)
Message-Id: <20100420.014908.46443175.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get these sparc bug fixes.

Including a IRQ tracing trap return blunder I've been tracking
down for 2 weeks :-)

Thanks!

The following changes since commit 13bd8e4673d527a9e48f41956b11d391e7c2cfe0:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../anholt/drm-intel

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (5):
      sparc64: Allocate sufficient stack space in ftrace stubs.
      sparc64: Run NMIs on the hardirq stack.
      sparc64: Fix PREEMPT_ACTIVE value.
      sparc64: Use correct pt_regs in decode_access_size() error paths.
      sparc64: Fix hardirq tracing in trap return path.

Frederic Weisbecker (1):
      sparc: Fix forgotten kmemleak headers inclusion

 arch/sparc/include/asm/thread_info_64.h |    2 +-
 arch/sparc/kernel/irq_64.c              |   20 ++------------------
 arch/sparc/kernel/kstack.h              |   19 +++++++++++++++++++
 arch/sparc/kernel/nmi.c                 |    7 +++++++
 arch/sparc/kernel/rtrap_64.S            |   12 +++++++++++-
 arch/sparc/kernel/unaligned_64.c        |    6 +++---
 arch/sparc/lib/mcount.S                 |    8 ++++----
 7 files changed, 47 insertions(+), 27 deletions(-)
