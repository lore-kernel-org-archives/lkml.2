Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab2FWKFt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 06:05:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753995Ab2FWKFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 06:05:07 -0400
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Cong Wang <amwang@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 03/12] powerpc: remove km_type definitions
Date: Sat, 23 Jun 2012 18:04:14 +0800
Message-Id: <1340445863-16111-4-git-send-email-amwang@redhat.com>
In-Reply-To: <1340445863-16111-1-git-send-email-amwang@redhat.com>
References: <1340445863-16111-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cong Wang <amwang@redhat.com>
---
 arch/powerpc/include/asm/kmap_types.h |   31 +------------------------------
 1 files changed, 1 insertions(+), 30 deletions(-)

diff --git a/arch/powerpc/include/asm/kmap_types.h b/arch/powerpc/include/asm/kmap_types.h
index bca8fdc..5acabbd 100644
--- a/arch/powerpc/include/asm/kmap_types.h
+++ b/arch/powerpc/include/asm/kmap_types.h
@@ -10,36 +10,7 @@
  * 2 of the License, or (at your option) any later version.
  */
 
-enum km_type {
-	KM_BOUNCE_READ,
-	KM_SKB_SUNRPC_DATA,
-	KM_SKB_DATA_SOFTIRQ,
-	KM_USER0,
-	KM_USER1,
-	KM_BIO_SRC_IRQ,
-	KM_BIO_DST_IRQ,
-	KM_PTE0,
-	KM_PTE1,
-	KM_IRQ0,
-	KM_IRQ1,
-	KM_SOFTIRQ0,
-	KM_SOFTIRQ1,
-	KM_PPC_SYNC_PAGE,
-	KM_PPC_SYNC_ICACHE,
-	KM_KDB,
-	KM_TYPE_NR
-};
-
-/*
- * This is a temporary build fix that (so they say on lkml....) should no longer
- * be required after 2.6.33, because of changes planned to the kmap code.
- * Let's try to remove this cruft then.
- */
-#ifdef CONFIG_DEBUG_HIGHMEM
-#define KM_NMI		(-1)
-#define KM_NMI_PTE	(-1)
-#define KM_IRQ_PTE	(-1)
-#endif
+#define KM_TYPE_NR 16
 
 #endif	/* __KERNEL__ */
 #endif	/* _ASM_POWERPC_KMAP_TYPES_H */
-- 
1.7.7.6

