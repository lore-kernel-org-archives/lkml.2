Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab2FWKFp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 06:05:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753932Ab2FWKFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 06:05:01 -0400
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Cong Wang <amwang@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 02/12] arm: remove km_type definitions
Date: Sat, 23 Jun 2012 18:04:13 +0800
Message-Id: <1340445863-16111-3-git-send-email-amwang@redhat.com>
In-Reply-To: <1340445863-16111-1-git-send-email-amwang@redhat.com>
References: <1340445863-16111-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cong Wang <amwang@redhat.com>
---
 arch/arm/include/asm/kmap_types.h |   26 +-------------------------
 1 files changed, 1 insertions(+), 25 deletions(-)

diff --git a/arch/arm/include/asm/kmap_types.h b/arch/arm/include/asm/kmap_types.h
index e51b1e8..83eb2f7 100644
--- a/arch/arm/include/asm/kmap_types.h
+++ b/arch/arm/include/asm/kmap_types.h
@@ -4,30 +4,6 @@
 /*
  * This is the "bare minimum".  AIO seems to require this.
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
-	KM_L1_CACHE,
-	KM_L2_CACHE,
-	KM_KDB,
-	KM_TYPE_NR
-};
-
-#ifdef CONFIG_DEBUG_HIGHMEM
-#define KM_NMI		(-1)
-#define KM_NMI_PTE	(-1)
-#define KM_IRQ_PTE	(-1)
-#endif
+#define KM_TYPE_NR 16
 
 #endif
-- 
1.7.7.6

