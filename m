Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108Ab1BQVeJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 16:34:09 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46670
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752519Ab1BQVeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 16:34:06 -0500
Date: Thu, 17 Feb 2011 13:34:42 -0800 (PST)
Message-Id: <20110217.133442.183044409.davem@davemloft.net>
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


Some small fixups:

1) Get perf working again.

2) sparc32 iommu code scans wrong range of bits in bitmap, from Akinobu Mita.

3) sparc32 unaligned access trap handler regression fix, from Daniel Hellstrom.

Please pull, thanks a lot!

The following changes since commit ee715087024b91a6ceb85ba2d02f6c35d354a48c:

  Merge branch 'for-2.6.38' of git://linux-nfs.org/~bfields/linux (2011-02-16 21:53:41 -0800)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

Akinobu Mita (2):
      sparc: use bitmap_set()
      sparc: fix size argument to find_next_zero_bit()

Daniel Hellstrom (1):
      sparc32: unaligned memory access (MNA) trap handler bug

David S. Miller (1):
      sparc64: Fix NMI startup bug which also breaks perf.

 arch/sparc/include/asm/pcr.h   |    2 ++
 arch/sparc/kernel/iommu.c      |    5 ++---
 arch/sparc/kernel/pcr.c        |    2 --
 arch/sparc/kernel/smp_64.c     |    2 ++
 arch/sparc/kernel/una_asm_32.S |    4 ++--
 arch/sparc/lib/bitext.c        |    5 ++---
 6 files changed, 10 insertions(+), 10 deletions(-)
