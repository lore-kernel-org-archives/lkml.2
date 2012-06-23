Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab2FWKFx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 06:05:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039Ab2FWKF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 06:05:26 -0400
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Cong Wang <amwang@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [PATCH 08/12] tile: remove km_type definitions
Date: Sat, 23 Jun 2012 18:04:19 +0800
Message-Id: <1340445863-16111-9-git-send-email-amwang@redhat.com>
In-Reply-To: <1340445863-16111-1-git-send-email-amwang@redhat.com>
References: <1340445863-16111-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cong Wang <amwang@redhat.com>
---
 arch/tile/include/asm/kmap_types.h |   26 --------------------------
 1 files changed, 0 insertions(+), 26 deletions(-)

diff --git a/arch/tile/include/asm/kmap_types.h b/arch/tile/include/asm/kmap_types.h
index 3d0f202..054374c 100644
--- a/arch/tile/include/asm/kmap_types.h
+++ b/arch/tile/include/asm/kmap_types.h
@@ -27,31 +27,5 @@ enum km_type {
 	KM_TYPE_NR = 8
 };
 
-/*
- * We provide dummy definitions of all the stray values that used to be
- * required for kmap_atomic() and no longer are.
- */
-enum {
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
-	KM_SYNC_ICACHE,
-	KM_SYNC_DCACHE,
-	KM_UML_USERCOPY,
-	KM_IRQ_PTE,
-	KM_NMI,
-	KM_NMI_PTE,
-	KM_KDB
-};
 
 #endif /* _ASM_TILE_KMAP_TYPES_H */
-- 
1.7.7.6

