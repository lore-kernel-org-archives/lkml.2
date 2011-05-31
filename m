Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab1EaBMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 21:12:52 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:39535 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab1EaBMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 21:12:51 -0400
X-AuditID: cbfee61b-b7c62ae0000056ed-38-4de44091d8ca
Date: Tue, 31 May 2011 10:12:45 +0900
From: Kyungmin Park <kmpark@infradead.org>
Subject: [PATCH] CFQ: Fix typo and remove unnecessary semicolon
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Message-id: <20110531011245.GA7980@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 31 May 2011 01:12:45.0829 (UTC)
 FILETIME=[D967E350:01CC1F2F]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyungmin Park <kyungmin.park@samsung.com>

Fix comment typo and remove unnecessary semicolon at macro

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 7c52d68..8a02c95 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -185,7 +185,7 @@ struct cfq_group {
 	int nr_cfqq;
 
 	/*
-	 * Per group busy queus average. Useful for workload slice calc. We
+	 * Per group busy queues average. Useful for workload slice calc. We
 	 * create the array for each prio class but at run time it is used
 	 * only for RT and BE class and slot for IDLE class remains unused.
 	 * This is primarily done to avoid confusion and a gcc warning.
@@ -369,16 +369,16 @@ CFQ_CFQQ_FNS(wait_busy);
 #define cfq_log_cfqq(cfqd, cfqq, fmt, args...)	\
 	blk_add_trace_msg((cfqd)->queue, "cfq%d%c %s " fmt, (cfqq)->pid, \
 			cfq_cfqq_sync((cfqq)) ? 'S' : 'A', \
-			blkg_path(&(cfqq)->cfqg->blkg), ##args);
+			blkg_path(&(cfqq)->cfqg->blkg), ##args)
 
 #define cfq_log_cfqg(cfqd, cfqg, fmt, args...)				\
 	blk_add_trace_msg((cfqd)->queue, "%s " fmt,			\
-				blkg_path(&(cfqg)->blkg), ##args);      \
+				blkg_path(&(cfqg)->blkg), ##args)       \
 
 #else
 #define cfq_log_cfqq(cfqd, cfqq, fmt, args...)	\
 	blk_add_trace_msg((cfqd)->queue, "cfq%d " fmt, (cfqq)->pid, ##args)
-#define cfq_log_cfqg(cfqd, cfqg, fmt, args...)		do {} while (0);
+#define cfq_log_cfqg(cfqd, cfqg, fmt, args...)		do {} while (0)
 #endif
 #define cfq_log(cfqd, fmt, args...)	\
 	blk_add_trace_msg((cfqd)->queue, "cfq " fmt, ##args)
