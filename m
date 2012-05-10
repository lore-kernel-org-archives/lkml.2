Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab2EJUws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 16:52:48 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:54281 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757062Ab2EJUwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 16:52:47 -0400
Date: Thu, 10 May 2012 16:52:44 -0400 (EDT)
Message-Id: <20120510.165244.1634080676100822022.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 10 May 2012 13:52:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get this sparc64 bug fix, thanks!

The following changes since commit bc46f9375a286d05f84a9464efc2b7f1f5614ff4:

  Merge tag 'nfs-for-3.4-5' of git://git.linux-nfs.org/projects/trondmy/linux-nfs (2012-05-10 10:05:19 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git master

for you to fetch changes up to a5a737e090e25981e99d69f01400e3a80356581c:

  sparc64: Do not clobber %g2 in xcall_fetch_glob_regs(). (2012-05-10 11:00:46 -0700)

----------------------------------------------------------------
David S. Miller (1):
      sparc64: Do not clobber %g2 in xcall_fetch_glob_regs().

 arch/sparc/kernel/central.c |    2 +-
 arch/sparc/mm/ultra.S       |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)
