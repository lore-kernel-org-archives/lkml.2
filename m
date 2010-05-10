Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab0EJJjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 05:39:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:43487 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755512Ab0EJJjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 05:39:42 -0400
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, tglx@linuxtronix.de, mingo@elte.hu,
       davem@davemloft.net, lethal@linux-sh.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 02/25] lmb: No reason to include asm/lmb.h late
Date: Mon, 10 May 2010 19:38:36 +1000
Message-Id: <1273484339-28911-3-git-send-email-benh@kernel.crashing.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1273484339-28911-2-git-send-email-benh@kernel.crashing.org>
References: <1273484339-28911-1-git-send-email-benh@kernel.crashing.org>
 <1273484339-28911-2-git-send-email-benh@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 include/linux/lmb.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/lmb.h b/include/linux/lmb.h
index d225d78..de8031f 100644
--- a/include/linux/lmb.h
+++ b/include/linux/lmb.h
@@ -16,6 +16,8 @@
 #include <linux/init.h>
 #include <linux/mm.h>
 
+#include <asm/lmb.h>
+
 #define MAX_LMB_REGIONS 128
 
 struct lmb_region {
@@ -82,8 +84,6 @@ lmb_end_pfn(struct lmb_type *type, unsigned long region_nr)
 	       lmb_size_pages(type, region_nr);
 }
 
-#include <asm/lmb.h>
-
 #endif /* __KERNEL__ */
 
 #endif /* _LINUX_LMB_H */
-- 
1.6.3.3

