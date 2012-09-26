Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923Ab2IZRU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 13:20:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:10407 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757642Ab2IZRSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 13:18:44 -0400
X-IronPort-AV: E=Sophos;i="4.80,492,1344182400"; 
   d="scan'208";a="5922252"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 08/12] workqueue: fix comments of insert_work()
Date: Thu, 27 Sep 2012 01:20:39 +0800
Message-Id: <1348680043-5077-9-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1348680043-5077-1-git-send-email-laijs@cn.fujitsu.com>
References: <1348680043-5077-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/27 01:18:46,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/27 01:18:46,
	Serialize complete at 2012/09/27 01:18:46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This comment is so important to understand the CMWQ, fix it and make
new reviewer who read workqueue.c at the first time.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index d37f446..89fd1b2 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1169,7 +1169,7 @@ static void insert_work(struct cpu_workqueue_struct *cwq,
 	list_add_tail(&work->entry, head);
 
 	/*
-	 * Ensure either worker_sched_deactivated() sees the above
+	 * Ensure either wq_worker_sleeping() sees the above
 	 * list_add_tail() or we see zero nr_running to avoid workers
 	 * lying around lazily while there are works to be processed.
 	 */
-- 
1.7.7.6

