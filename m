Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab1GPRsX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 13:48:23 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:44986 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab1GPRsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 13:48:22 -0400
Date: Sat, 16 Jul 2011 10:48:19 -0700 (PDT)
Message-Id: <20110716.104819.855316771212871477.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 16 Jul 2011 10:48:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull, to get these Sparc bug fixes.

Thanks!

The following changes since commit 1765a367a3b5d5e9692949b0c5ec933eff2c0701:

  Merge branch 'gpio/merge' of git://git.secretlab.ca/git/linux-2.6 (2011-07-15 18:03:30 -0700)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

Matthias Rosenfelder (1):
      sparc32,leon: Added __init declaration to leon_flush_needed()

Steven Rostedt (1):
      sparc/irqs: Do not trace arch_local_{*,irq_*} functions

Will Simoneau (1):
      sparc: sun4m SMP: fix wrong shift instruction in IPI handler

 arch/sparc/include/asm/irqflags_32.h |    8 ++++----
 arch/sparc/include/asm/irqflags_64.h |   14 +++++++-------
 arch/sparc/kernel/entry.S            |    2 +-
 arch/sparc/mm/leon_mm.c              |    2 +-
 4 files changed, 13 insertions(+), 13 deletions(-)
