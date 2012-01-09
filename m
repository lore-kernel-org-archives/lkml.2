Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab2AIWWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 17:22:23 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:36680 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab2AIWWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 17:22:22 -0500
Date: Mon, 09 Jan 2012 14:22:20 -0800 (PST)
Message-Id: <20120109.142220.2296949606301841005.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 09 Jan 2012 14:22:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just some cleanups and removal of unused code from Sam Ravnborg.

Nothing earth shattering.

Please pull, thanks a lot.

The following changes since commit 6b3da11b3c36fdafce3a72e0e90d6c4e99e9aad5:

  Merge branch 'for-3.3' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu (2012-01-09 13:08:28 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-next.git master

Sam Ravnborg (7):
      sparc32: drop unused atomic24 support
      sparc32: drop useless preprocessor conditional in atomic_32.h
      apbuart: fix section mismatch warning
      sparc32: support atomic64_t
      sparc32: enable different preemptions models
      sparc32: fix PAGE_SIZE definition
      sparc32: remove unused file: include/asm/pgtsun4.h

 arch/sparc/Kconfig                      |    3 +-
 arch/sparc/include/asm/atomic_32.h      |  104 +-------------------
 arch/sparc/include/asm/page_32.h        |   10 +--
 arch/sparc/include/asm/pgtsun4.h        |  171 -------------------------------
 arch/sparc/include/asm/thread_info_32.h |    2 +-
 arch/sparc/lib/atomic_32.S              |   55 ----------
 arch/sparc/lib/ksyms.c                  |    6 -
 drivers/tty/serial/apbuart.c            |    4 +-
 8 files changed, 8 insertions(+), 347 deletions(-)
 delete mode 100644 arch/sparc/include/asm/pgtsun4.h
