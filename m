Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987Ab2DIRpB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 13:45:01 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30267 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab2DIRpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 13:45:00 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6675"; a="177726097"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Tejun Heo <tj@kernel.org>
Subject: [TRIVIAL/PATCH] workqueue: Fix workqueue_execute_end() comment
Date: Mon,  9 Apr 2012 10:44:57 -0700
Message-Id: <1333993497-28215-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.10.rc3.3.g19a6c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

workqueue_execute_end() is called after the callback function,
not before.

Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 include/trace/events/workqueue.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/workqueue.h b/include/trace/events/workqueue.h
index 7d49729..4018f50 100644
--- a/include/trace/events/workqueue.h
+++ b/include/trace/events/workqueue.h
@@ -103,7 +103,7 @@ TRACE_EVENT(workqueue_execute_start,
 );
 
 /**
- * workqueue_execute_end - called immediately before the workqueue callback
+ * workqueue_execute_end - called immediately after the workqueue callback
  * @work:	pointer to struct work_struct
  *
  * Allows to track workqueue execution.
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

