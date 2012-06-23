Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab2FWKFr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 06:05:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753952Ab2FWKFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 06:05:01 -0400
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Cong Wang <amwang@redhat.com>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH 04/12] frv: remove km_type definitions
Date: Sat, 23 Jun 2012 18:04:15 +0800
Message-Id: <1340445863-16111-5-git-send-email-amwang@redhat.com>
In-Reply-To: <1340445863-16111-1-git-send-email-amwang@redhat.com>
References: <1340445863-16111-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cong Wang <amwang@redhat.com>
---
 arch/frv/include/asm/kmap_types.h |   24 +-----------------------
 1 files changed, 1 insertions(+), 23 deletions(-)

diff --git a/arch/frv/include/asm/kmap_types.h b/arch/frv/include/asm/kmap_types.h
index f8e16b2..43901f2 100644
--- a/arch/frv/include/asm/kmap_types.h
+++ b/arch/frv/include/asm/kmap_types.h
@@ -2,28 +2,6 @@
 #ifndef _ASM_KMAP_TYPES_H
 #define _ASM_KMAP_TYPES_H
 
-enum km_type {
-	/* arch specific kmaps - change the numbers attached to these at your peril */
-	__KM_CACHE,		/* cache flush page attachment point */
-	__KM_PGD,		/* current page directory */
-	__KM_ITLB_PTD,		/* current instruction TLB miss page table lookup */
-	__KM_DTLB_PTD,		/* current data TLB miss page table lookup */
-
-	/* general kmaps */
-        KM_BOUNCE_READ,
-        KM_SKB_SUNRPC_DATA,
-        KM_SKB_DATA_SOFTIRQ,
-        KM_USER0,
-        KM_USER1,
-	KM_BIO_SRC_IRQ,
-	KM_BIO_DST_IRQ,
-	KM_PTE0,
-	KM_PTE1,
-	KM_IRQ0,
-	KM_IRQ1,
-	KM_SOFTIRQ0,
-	KM_SOFTIRQ1,
-	KM_TYPE_NR
-};
+#define KM_TYPE_NR 17
 
 #endif
-- 
1.7.7.6

