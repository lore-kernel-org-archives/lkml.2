Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab2DUU6l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 16:58:41 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:43869 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab2DUU6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 16:58:40 -0400
Date: Sat, 21 Apr 2012 16:58:37 -0400 (EDT)
Message-Id: <20120421.165837.76978862714579140.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 21 Apr 2012 13:58:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get this sparc32 LEON smp bootup bug fix.

Thanks!

The following changes since commit 8f4f9d4d3cb84686a75f6195b8f8705376763fc7:

  Merge tag 'fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc (2012-04-21 12:45:52 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git master

for you to fetch changes up to e9a5ea1852cd8d7e155d2e3a45e4a6ea25110f7d:

  sparc32,leon: add notify_cpu_starting() (2012-04-21 16:35:06 -0400)

----------------------------------------------------------------
Yong Zhang (1):
      sparc32,leon: add notify_cpu_starting()

 arch/sparc/kernel/leon_smp.c |    3 +++
 1 file changed, 3 insertions(+)
