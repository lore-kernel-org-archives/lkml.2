Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558Ab2DMTZA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 15:25:00 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:52033 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459Ab2DMTY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 15:24:58 -0400
Date: Fri, 13 Apr 2012 15:24:55 -0400 (EDT)
Message-Id: <20120413.152455.900761231064979707.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 13 Apr 2012 12:24:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get these two sparc bug fixes.

With special guest sparc64 assembler hacker, Paul E. McKenney.

Thanks.

The following changes since commit 4166fb64593514ad920b7dbd290e0a934b37d24a:

  Merge tag 'srpt-srq-type' of git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband (2012-04-12 18:51:32 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git master

for you to fetch changes up to 3d3eeb2ef26112a200785e5fca58ec58dd33bf1e:

  sparc64: Eliminate obsolete __handle_softirq() function (2012-04-13 11:58:38 -0700)

----------------------------------------------------------------
David S. Miller (1):
      sparc64: Fix bootup crash on sun4v.

Paul E. McKenney (1):
      sparc64: Eliminate obsolete __handle_softirq() function

 arch/sparc/kernel/ds.c       |    2 +-
 arch/sparc/kernel/rtrap_64.S |    7 -------
 2 files changed, 1 insertion(+), 8 deletions(-)
