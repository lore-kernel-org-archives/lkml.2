Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667Ab2JWGAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 02:00:55 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59753 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab2JWGAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 02:00:54 -0400
From: SeongJae Park <sj38.park@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH 1/2] Remove struct CsrThread
Date: Tue, 23 Oct 2012 15:00:06 +0900
Message-Id: <1350972007-5855-1-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nobody use struct CsrThread. So, remove it.

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 drivers/staging/csr/csr_framework_ext_types.h |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/staging/csr/csr_framework_ext_types.h b/drivers/staging/csr/csr_framework_ext_types.h
index 0d06d95..2bf854a 100644
--- a/drivers/staging/csr/csr_framework_ext_types.h
+++ b/drivers/staging/csr/csr_framework_ext_types.h
@@ -24,11 +24,6 @@ extern "C" {
 
 #ifdef __KERNEL__
 
-struct CsrThread {
-	struct task_struct *thread_task;
-	char                name[16];
-};
-
 struct CsrEvent {
 	/* wait_queue for waking the kernel thread */
 	wait_queue_head_t wakeup_q;
-- 
1.7.9.5

