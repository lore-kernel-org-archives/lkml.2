Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab0EAPvZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 11:51:25 -0400
Received: from xenotime.net ([72.52.115.56]:37463 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755148Ab0EAPvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 11:51:23 -0400
Date: Sat, 1 May 2010 08:51:17 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Liang Li <liang.li@windriver.com>
Subject: [PATCH -mmotm] x86/mm/pgtable_32.c: add include asm/io.h
Message-Id: <20100501085117.5d1e48cc.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build error:
arch/x86/mm/pgtable_32.c:130: error: implicit declaration of function 'fixup_early_ioremap'

in patch: x86-fix-handling-of-the-reservetop-boot-option.patch

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Liang Li <liang.li@windriver.com>
---
 arch/x86/mm/pgtable_32.c |    1 +
 1 file changed, 1 insertion(+)

--- mmotm-2010-0428-1653.orig/arch/x86/mm/pgtable_32.c
+++ mmotm-2010-0428-1653/arch/x86/mm/pgtable_32.c
@@ -15,6 +15,7 @@
 #include <asm/pgalloc.h>
 #include <asm/fixmap.h>
 #include <asm/e820.h>
+#include <asm/io.h>
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
 
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
