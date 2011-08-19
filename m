Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857Ab1HSEy4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 00:54:56 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:36304 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab1HSEyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 00:54:55 -0400
Date: Thu, 18 Aug 2011 21:54:22 -0700 (PDT)
Message-Id: <20110818.215422.291743606960028861.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 18 Aug 2011 21:54:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get this array bounds fix from Ian Campbell.

Thanks!

The following changes since commit 5c80c71b9a0ec518b4b58d2a61de01a04f4a4453:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable (2011-08-18 14:20:00 -0700)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc.git master

Ian Campbell (1):
      sparc: fix array bounds error setting up PCIC NMI trap

 arch/sparc/kernel/pcic.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)
