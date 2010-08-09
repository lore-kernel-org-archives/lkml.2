Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab0HIK1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 06:27:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48877
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756106Ab0HIK1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 06:27:46 -0400
Date: Mon, 09 Aug 2010 03:28:06 -0700 (PDT)
Message-Id: <20100809.032806.226789571.davem@davemloft.net>
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


Just some misc sparc64 bits:

1) Add missing ID to sparc64 parport support.

2) Sync sparc64's perf_arch_get_caller_regs() with recent changes.

3) Toss user-copy check code, it never worked properly on sparc for
   whatever reason and just adds warning noise to the logs.

Please pull, thanks a lot!

The following changes since commit 45d7f32c7a43cbb9592886d38190e379e2eb2226:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile (2010-08-08 10:10:11 -0700)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (4):
      sparc64: Add missing ID to parport probing code.
      sparc64: Fix perf_arch_get_caller_regs().
      sparc: Kill user copy check code.
      sparc64: Update defconfig.

 arch/sparc/Kconfig.debug             |   14 ------
 arch/sparc/configs/sparc64_defconfig |   67 +++++++++++++++++-------------
 arch/sparc/include/asm/parport.h     |    4 ++
 arch/sparc/include/asm/perf_event.h  |   25 +++++++++--
 arch/sparc/include/asm/uaccess_32.h  |   15 -------
 arch/sparc/include/asm/uaccess_64.h  |   23 ++--------
 arch/sparc/kernel/helpers.S          |   75 ----------------------------------
 7 files changed, 68 insertions(+), 155 deletions(-)
