Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443Ab2JOH4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 03:56:12 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47416 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab2JOH4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 03:56:11 -0400
From: SeongJae Park <sj38.park@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH] staging: csr: fix coding style
Date: Mon, 15 Oct 2012 16:55:45 +0900
Message-Id: <1350287745-14442-1-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coding style of csr_framework_ext_types.h

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 drivers/staging/csr/csr_framework_ext_types.h |   33 +++++++++++--------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/csr/csr_framework_ext_types.h b/drivers/staging/csr/csr_framework_ext_types.h
index 57194ee..7e9cf8e 100644
--- a/drivers/staging/csr/csr_framework_ext_types.h
+++ b/drivers/staging/csr/csr_framework_ext_types.h
@@ -2,11 +2,11 @@
 #define CSR_FRAMEWORK_EXT_TYPES_H__
 /*****************************************************************************
 
-            (c) Cambridge Silicon Radio Limited 2010
-            All rights reserved and confidential information of CSR
+	(c) Cambridge Silicon Radio Limited 2010
+	All rights reserved and confidential information of CSR
 
-            Refer to LICENSE.txt included with this source for details
-            on the license terms.
+	Refer to LICENSE.txt included with this source for details
+	on the license terms.
 
 *****************************************************************************/
 
@@ -24,17 +24,15 @@ extern "C" {
 
 #ifdef __KERNEL__
 
-struct CsrThread
-{
-    struct task_struct *thread_task;
-    char                name[16];
+struct CsrThreadi {
+	struct task_struct *thread_task;
+	char                name[16];
 };
 
-struct CsrEvent
-{
-    /* wait_queue for waking the kernel thread */
-    wait_queue_head_t wakeup_q;
-    unsigned int      wakeup_flag;
+struct CsrEvent {
+	/* wait_queue for waking the kernel thread */
+	wait_queue_head_t wakeup_q;
+	unsigned int      wakeup_flag;
 };
 
 typedef struct CsrEvent CsrEventHandle;
@@ -43,11 +41,10 @@ typedef struct CsrThread CsrThreadHandle;
 
 #else /* __KERNEL __ */
 
-struct CsrEvent
-{
-    pthread_cond_t  event;
-    pthread_mutex_t mutex;
-    u32       eventBits;
+struct CsrEvent {
+	pthread_cond_t  event;
+	pthread_mutex_t mutex;
+	u32       eventBits;
 };
 
 typedef struct CsrEvent CsrEventHandle;
-- 
1.7.9.5

