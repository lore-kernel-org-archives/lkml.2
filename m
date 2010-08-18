Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab0HRBDK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 21:03:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41006
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752530Ab0HRBDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 21:03:06 -0400
Date: Tue, 17 Aug 2010 18:03:25 -0700 (PDT)
Message-Id: <20100817.180325.104051399.davem@davemloft.net>
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


Among other things, this fixes the rwsem signedness issue we
were discussing earlier today.

Add entries for the new 2.6.36 system calls.

Make console=tty* on the kernel command line work properly
for serial consoles.

Please pull, thanks a lot!

The following changes since commit da5cabf80e2433131bf0ed8993abc0f7ea618c73:

  Linux 2.6.36-rc1 (2010-08-15 17:41:37 -0700)

are available in the git repository at:
  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (5):
      sparc: Really fix "console=" for serial consoles.
      Merge branch 'master' of git://git.kernel.org/.../torvalds/linux-2.6
      sparc: Hook up new fanotify and prlimit64 syscalls.
      sparc64: Fix rwsem constant bug leading to hangs.
      sparc64: Fix atomic64_t routine return values.

 arch/sparc/include/asm/atomic_64.h   |    6 +++---
 arch/sparc/include/asm/fb.h          |    4 ++++
 arch/sparc/include/asm/rwsem-const.h |    2 +-
 arch/sparc/include/asm/unistd.h      |    5 ++++-
 arch/sparc/kernel/sys32.S            |    9 +++++++++
 arch/sparc/kernel/systbls_32.S       |    3 ++-
 arch/sparc/kernel/systbls_64.S       |    6 ++++--
 drivers/serial/suncore.c             |   15 +++++++++------
 8 files changed, 36 insertions(+), 14 deletions(-)
