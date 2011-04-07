Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751187Ab1DGQLQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 12:11:16 -0400
Received: from 63.mail-out.ovh.net ([91.121.185.56]:49777 "HELO
	63.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755802Ab1DGQLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 12:11:13 -0400
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Patrice VILCHEZ <patrice.vilchez@atmel.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: [PATCH 1/2] genalloc: fix header multiple including support
Date: Thu,  7 Apr 2011 18:03:16 +0200
Message-Id: <1302192197-2248-1-git-send-email-plagnioj@jcrosoft.com>
X-Mailer: git-send-email 1.7.2.3
X-Ovh-Tracer-Id: 16292897552865995628
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
---
 include/linux/genalloc.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/genalloc.h b/include/linux/genalloc.h
index 9869ef3..b1c70f1 100644
--- a/include/linux/genalloc.h
+++ b/include/linux/genalloc.h
@@ -9,6 +9,8 @@
  */
 
 
+#ifndef __GENALLOC_H__
+#define __GENALLOC_H__
 /*
  *  General purpose special memory pool descriptor.
  */
@@ -34,3 +36,4 @@ extern int gen_pool_add(struct gen_pool *, unsigned long, size_t, int);
 extern void gen_pool_destroy(struct gen_pool *);
 extern unsigned long gen_pool_alloc(struct gen_pool *, size_t);
 extern void gen_pool_free(struct gen_pool *, unsigned long, size_t);
+#endif /* __GENALLOC_H__ */
-- 
1.7.4.1

