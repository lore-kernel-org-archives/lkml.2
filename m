Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022Ab2C3HkB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 03:40:01 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:47692 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab2C3Hjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 03:39:53 -0400
Date: Fri, 30 Mar 2012 03:39:47 -0400 (EDT)
Message-Id: <20120330.033947.681145423995124443.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 30 Mar 2012 00:39:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This just fixes build fallout due to recent changes that went
int your tree.

Please pull, thanks a lot.

The following changes since commit 4bde23f8751f388867766b0a62ed1ef8b7e01561:

  Merge tag 'fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc (2012-03-29 21:30:28 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git master

for you to fetch changes up to 8befc9f23c695395de011ced289c611fada22f35:

  sparc: Fix even more fallout from system.h split. (2012-03-29 22:40:52 -0700)

----------------------------------------------------------------
David S. Miller (1):
      sparc: Fix even more fallout from system.h split.

Stephen Rothwell (1):
      sparc: fix fallout from system.h split

 arch/sparc/include/asm/ptrace.h |    1 +
 arch/sparc/kernel/jump_label.c  |    2 ++
 arch/sparc/kernel/kgdb_64.c     |    1 +
 3 files changed, 4 insertions(+), 0 deletions(-)
