Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab2FWKFu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 06:05:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030Ab2FWKFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 06:05:12 -0400
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Cong Wang <amwang@redhat.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: [PATCH 05/12] avr32: remove km_type definitions
Date: Sat, 23 Jun 2012 18:04:16 +0800
Message-Id: <1340445863-16111-6-git-send-email-amwang@redhat.com>
In-Reply-To: <1340445863-16111-1-git-send-email-amwang@redhat.com>
References: <1340445863-16111-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cong Wang <amwang@redhat.com>
---
 arch/avr32/include/asm/kmap_types.h |   24 ++----------------------
 1 files changed, 2 insertions(+), 22 deletions(-)

diff --git a/arch/avr32/include/asm/kmap_types.h b/arch/avr32/include/asm/kmap_types.h
index b7f5c68..479330b 100644
--- a/arch/avr32/include/asm/kmap_types.h
+++ b/arch/avr32/include/asm/kmap_types.h
@@ -2,29 +2,9 @@
 #define __ASM_AVR32_KMAP_TYPES_H
 
 #ifdef CONFIG_DEBUG_HIGHMEM
-# define D(n) __KM_FENCE_##n ,
+# define KM_TYPE_NR 29
 #else
-# define D(n)
+# define KM_TYPE_NR 14
 #endif
 
-enum km_type {
-D(0)	KM_BOUNCE_READ,
-D(1)	KM_SKB_SUNRPC_DATA,
-D(2)	KM_SKB_DATA_SOFTIRQ,
-D(3)	KM_USER0,
-D(4)	KM_USER1,
-D(5)	KM_BIO_SRC_IRQ,
-D(6)	KM_BIO_DST_IRQ,
-D(7)	KM_PTE0,
-D(8)	KM_PTE1,
-D(9)	KM_PTE2,
-D(10)	KM_IRQ0,
-D(11)	KM_IRQ1,
-D(12)	KM_SOFTIRQ0,
-D(13)	KM_SOFTIRQ1,
-D(14)	KM_TYPE_NR
-};
-
-#undef D
-
 #endif /* __ASM_AVR32_KMAP_TYPES_H */
-- 
1.7.7.6

