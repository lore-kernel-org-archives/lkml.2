Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449Ab0IKEZ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 00:25:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56411
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751163Ab0IKEZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 00:25:27 -0400
Date: Fri, 10 Sep 2010 21:25:44 -0700 (PDT)
Message-Id: <20100910.212544.193703159.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This just kills off those completely bogus BKL uses in
the sparc code that were discussed the other day.

Please pull, thanks a lot!

The following changes since commit 3e6dce76d99b328716b43929b9195adfee1de00c:

  Merge branch 'drm-intel-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/ickle/drm-intel (2010-09-10 18:19:43 -0700)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (1):
      sparc: Kill all BKL usage.

 arch/sparc/kernel/sys_sparc_32.c |    2 --
 arch/sparc/kernel/unaligned_32.c |    3 +--
 arch/sparc/kernel/windows.c      |    2 --
 3 files changed, 1 insertions(+), 6 deletions(-)
