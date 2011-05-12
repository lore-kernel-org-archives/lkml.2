Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab1ELEn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 00:43:28 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:53663 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab1ELEn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 00:43:27 -0400
Date: Thu, 12 May 2011 00:42:50 -0400 (EDT)
Message-Id: <20110512.004250.1962490475502866566.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 11 May 2011 21:42:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Three sparc32 bug fixes here:

1) Correct unaligned pointer determination in sparc32 checksumming asm
   code, from Tkhai Kirill.

2) Sparc5 bootup busted because of incorrect CPU ID probing, fix from
   Sam Ravnborg.

3) Bad __init markings cause references to freed up memory after bootup,
   also from Sam Ravnborg.

Please pull, thanks a lot!

The following changes since commit 3568bd9720b4a775f28a718fcbb462ce2f386988:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client (2011-05-11 19:13:34 -0700)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

Sam Ravnborg (2):
      sparc32: fix section mismatch warnings in apc, pmc and time_32
      sparc32: fix sparcstation 5 boot

Tkhai Kirill (1):
      sparc32: Fixed unaligned memory copying in function __csum_partial_copy_sparc_generic

 arch/sparc/kernel/apc.c      |    2 +-
 arch/sparc/kernel/pmc.c      |    2 +-
 arch/sparc/kernel/smp_32.c   |   10 +++++++---
 arch/sparc/kernel/time_32.c  |    2 +-
 arch/sparc/lib/checksum_32.S |   12 +++++++++---
 5 files changed, 19 insertions(+), 9 deletions(-)
