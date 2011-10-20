Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348Ab1JTJsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 05:48:14 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:59436 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098Ab1JTJsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 05:48:12 -0400
Date: Thu, 20 Oct 2011 05:48:09 -0400 (EDT)
Message-Id: <20111020.054809.1247226868115473832.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 20 Oct 2011 02:48:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Two signal fixes to mirror that done on x86, and make PCI ROM mapping
work on sparc64.

Please pull, thanks a lot.

The following changes since commit 486cf46f3f9be5f2a966016c1a8fe01e32cde09e:

  mm: fix race between mremap and removing migration entry (2011-10-19 23:42:58 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git master

Daniel Hellstrom (1):
      sparc32,leon: SRMMU MMU Table probe fix

David S. Miller (1):
      sparc: Avoid calling sigprocmask()

Kjetil Oftedal (1):
      sparc: Add alignment flag to PCI expansion resources

Matt Fleming (1):
      sparc: Use set_current_blocked()

 arch/sparc/include/asm/pgtsrmmu.h |    2 +-
 arch/sparc/kernel/pci.c           |    3 ++-
 arch/sparc/kernel/signal32.c      |   21 +++++++--------------
 arch/sparc/kernel/signal_32.c     |   32 +++++++++++++-------------------
 arch/sparc/kernel/signal_64.c     |   32 +++++++++++++-------------------
 arch/sparc/mm/leon_mm.c           |    2 +-
 6 files changed, 37 insertions(+), 55 deletions(-)
