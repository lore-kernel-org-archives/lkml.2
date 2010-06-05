Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593Ab0FEPkt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 11:40:49 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:40478 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757490Ab0FEPkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 11:40:47 -0400
Date: Sat, 5 Jun 2010 11:40:42 -0400
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, x86@kernel.org
Subject: [PATCH] x86: use __ASSEMBLY__ rather than __ASSEMBLER__
Message-ID: <20100605114042.35ac69c1@dev.queued.net>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As Ingo pointed out in a separate patch, we should be using __ASSEMBLY__.
Make that the case in pgtable headers.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 arch/x86/include/asm/pgtable_32_types.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_32_types.h b/arch/x86/include/asm/pgtable_32_types.h
index 5f52bb0..1b4f19e 100644
--- a/arch/x86/include/asm/pgtable_32_types.h
+++ b/arch/x86/include/asm/pgtable_32_types.h
@@ -26,7 +26,7 @@
  */
 #define VMALLOC_OFFSET	(8 * 1024 * 1024)
 
-#ifndef __ASSEMBLER__
+#ifndef __ASSEMBLY__
 extern bool __vmalloc_start_set; /* set once high_memory is set */
 #endif
 
-- 
1.5.6.5

