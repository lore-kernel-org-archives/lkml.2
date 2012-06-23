Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab2FWKF5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 06:05:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060Ab2FWKFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 06:05:38 -0400
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Cong Wang <amwang@redhat.com>,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net
Subject: [PATCH 07/12] um: remove km_type definitions
Date: Sat, 23 Jun 2012 18:04:18 +0800
Message-Id: <1340445863-16111-8-git-send-email-amwang@redhat.com>
In-Reply-To: <1340445863-16111-1-git-send-email-amwang@redhat.com>
References: <1340445863-16111-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cong Wang <amwang@redhat.com>
---
 arch/um/include/asm/kmap_types.h |   18 +-----------------
 1 files changed, 1 insertions(+), 17 deletions(-)

diff --git a/arch/um/include/asm/kmap_types.h b/arch/um/include/asm/kmap_types.h
index 6c03acd..2e0a6b1 100644
--- a/arch/um/include/asm/kmap_types.h
+++ b/arch/um/include/asm/kmap_types.h
@@ -8,22 +8,6 @@
 
 /* No more #include "asm/arch/kmap_types.h" ! */
 
-enum km_type {
-	KM_BOUNCE_READ,
-	KM_SKB_SUNRPC_DATA,
-	KM_SKB_DATA_SOFTIRQ,
-	KM_USER0,
-	KM_USER1,
-	KM_UML_USERCOPY,	/* UML specific, for copy_*_user - used in do_op_one_page */
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
+#define KM_TYPE_NR 14
 
 #endif
-- 
1.7.7.6

