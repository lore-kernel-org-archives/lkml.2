Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759405Ab2CaBhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 21:37:54 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:57888 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab2CaBhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 21:37:52 -0400
Date: Fri, 30 Mar 2012 21:37:48 -0400 (EDT)
Message-Id: <20120330.213748.222624235259680298.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 30 Mar 2012 18:37:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Like last night's 64-bit fixes, this fixes the build regressions
on the 32-bit side too, thanks to Sam Ravnborg.

Please pull, thanks a lot.

The following changes since commit 623ff7739e7c00fa3d55dbfd42a492a68298fd7a:

  Merge tag 'for-linus-3.4' of git://git.infradead.org/mtd-2.6 (2012-03-30 17:31:56 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git master

for you to fetch changes up to bde4d8b205bc3ccdf7f5a841bfbfa9896b44b1ce:

  sparc32: fix fallout from system.h removal (2012-03-30 18:16:58 -0700)

----------------------------------------------------------------
Sam Ravnborg (1):
      sparc32: fix fallout from system.h removal

 arch/sparc/include/asm/ptrace.h |    1 +
 arch/sparc/kernel/sun4d_smp.c   |    1 +
 arch/sparc/kernel/sun4m_smp.c   |    1 +
 3 files changed, 3 insertions(+), 0 deletions(-)
