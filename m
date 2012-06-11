Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab2FKJOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 05:14:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56765 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab2FKJOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 05:14:06 -0400
Date: Mon, 11 Jun 2012 02:13:54 -0700
From: tip-bot for Wanpeng Li <liwp@linux.vnet.ibm.com>
Message-ID: <tip-9efc31b81d740487fd204fade0913ffa8cc97fc3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        liwp@linux.vnet.ibm.com, liwp.linux@gmail.com, tglx@linutronix.de,
        shangw@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        liwp@linux.vnet.ibm.com, tglx@linutronix.de, liwp.linux@gmail.com,
        shangw@linux.vnet.ibm.com
In-Reply-To: <1339296652-2935-1-git-send-email-liwp.linux@gmail.com>
References: <1339296652-2935-1-git-send-email-liwp.linux@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/mm: Fix some kernel-doc warnings
Git-Commit-ID: 9efc31b81d740487fd204fade0913ffa8cc97fc3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 11 Jun 2012 02:13:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9efc31b81d740487fd204fade0913ffa8cc97fc3
Gitweb:     http://git.kernel.org/tip/9efc31b81d740487fd204fade0913ffa8cc97fc3
Author:     Wanpeng Li <liwp@linux.vnet.ibm.com>
AuthorDate: Sun, 10 Jun 2012 10:50:52 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 11 Jun 2012 10:54:45 +0200

x86/mm: Fix some kernel-doc warnings

Fix kernel-doc warnings in arch/x86/mm/ioremap.c and
arch/x86/mm/pageattr.c, just like this one:

  Warning(arch/x86/mm/ioremap.c:204):
     No description found for parameter 'phys_addr'
  Warning(arch/x86/mm/ioremap.c:204):
     Excess function parameter 'offset' description in 'ioremap_nocache'

Signed-off-by: Wanpeng Li <liwp@linux.vnet.ibm.com>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: Wanpeng Li <liwp.linux@gmail.com>
Link: http://lkml.kernel.org/r/1339296652-2935-1-git-send-email-liwp.linux@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/mm/ioremap.c  |    4 ++--
 arch/x86/mm/pageattr.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index be1ef57..78fe3f1 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -180,7 +180,7 @@ err_free_memtype:
 
 /**
  * ioremap_nocache     -   map bus memory into CPU space
- * @offset:    bus address of the memory
+ * @phys_addr:    bus address of the memory
  * @size:      size of the resource to map
  *
  * ioremap_nocache performs a platform specific sequence of operations to
@@ -217,7 +217,7 @@ EXPORT_SYMBOL(ioremap_nocache);
 
 /**
  * ioremap_wc	-	map memory into CPU space write combined
- * @offset:	bus address of the memory
+ * @phys_addr:	bus address of the memory
  * @size:	size of the resource to map
  *
  * This version of ioremap ensures that the memory is marked write combining.
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index e1ebde3..a718e0d 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -122,7 +122,7 @@ within(unsigned long addr, unsigned long start, unsigned long end)
 
 /**
  * clflush_cache_range - flush a cache range with clflush
- * @addr:	virtual start address
+ * @vaddr:	virtual start address
  * @size:	number of bytes to flush
  *
  * clflush is an unordered instruction which needs fencing with mfence
