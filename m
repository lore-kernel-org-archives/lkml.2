Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab1HXGen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 02:34:43 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:37153 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab1HXGem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 02:34:42 -0400
Date: Tue, 23 Aug 2011 23:34:12 -0700 (PDT)
Message-Id: <20110823.233412.1348896296603900179.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 23 Aug 2011 23:34:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get this signal handling, and array bounds bug fix.

Thanks!

The following changes since commit 5c80c71b9a0ec518b4b58d2a61de01a04f4a4453:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable (2011-08-18 14:20:00 -0700)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc.git master

David S. Miller (1):
      sparc: Allow handling signals when stack is corrupted.

Ian Campbell (1):
      sparc: fix array bounds error setting up PCIC NMI trap

 arch/sparc/include/asm/sigcontext.h |   14 +++
 arch/sparc/kernel/Makefile          |    1 +
 arch/sparc/kernel/pcic.c            |    4 +-
 arch/sparc/kernel/signal32.c        |  184 ++++++++++++++++++++---------------
 arch/sparc/kernel/signal_32.c       |  172 +++++++++++++++------------------
 arch/sparc/kernel/signal_64.c       |  108 +++++++++------------
 arch/sparc/kernel/sigutil.h         |    9 ++
 arch/sparc/kernel/sigutil_32.c      |  120 +++++++++++++++++++++++
 arch/sparc/kernel/sigutil_64.c      |   93 ++++++++++++++++++
 9 files changed, 470 insertions(+), 235 deletions(-)
 create mode 100644 arch/sparc/kernel/sigutil.h
 create mode 100644 arch/sparc/kernel/sigutil_32.c
 create mode 100644 arch/sparc/kernel/sigutil_64.c
