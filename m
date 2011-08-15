Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab1HOWr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 18:47:28 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:35274 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab1HOWr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 18:47:26 -0400
Date: Mon, 15 Aug 2011 15:47:23 -0700 (PDT)
Message-Id: <20110815.154723.78978175770791283.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 15 Aug 2011 15:47:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get these sparc changes, thanks!

1) sparc32 unlock needs to use inline asm to avoid compiler
   reordering.  From Mikael Pettersson.

2) Sparc should use the C based recordmcount, thanks to Steven Rostedt
   for the tip.

The following changes since commit 2f6a123821a7feaba7cee787ef0f21d2354d1730:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus (2011-08-15 08:46:11 -0700)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc.git master

David S. Miller (1):
      sparc64: Set HAVE_C_RECORDMCOUNT

Mikael Pettersson (2):
      sparc64: remove unnecessary macros from spinlock_64.h
      sparc32: unbreak arch_write_unlock()

 arch/sparc/Kconfig                   |    1 +
 arch/sparc/include/asm/spinlock_32.h |   11 +++++++++--
 arch/sparc/include/asm/spinlock_64.h |    6 ------
 3 files changed, 10 insertions(+), 8 deletions(-)
