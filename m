Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724Ab1HLBJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 21:09:22 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:37803 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab1HLBJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 21:09:20 -0400
Date: Thu, 11 Aug 2011 18:08:46 -0700 (PDT)
Message-Id: <20110811.180846.1821152818786929944.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 11 Aug 2011 18:08:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get this Sparc bug fix, thanks!

The following changes since commit 068ef739127af1faf6f342b56d41ceea89f76c75:

  Merge branch 'fixes' of master.kernel.org:/home/rmk/linux-2.6-arm (2011-08-10 17:37:17 -0700)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc.git master

David S. Miller (1):
      sparc: Don't do hypervisor calls on non-sun4v in DS driver.

 arch/sparc/kernel/ds.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)
