Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab2HELbC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 07:31:02 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59824 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab2HELbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 07:31:00 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6793"; a="220227921"
From: Tatyana Brokhman <tlinder@codeaurora.org>
To: axboe@kernel.dk
Cc: linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Tatyana Brokhman <tlinder@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC/PATCH 1/2] block: Expose kblock_schedule_delayed_work()
Date: Sun,  5 Aug 2012 14:30:40 +0300
Message-Id: <1344166241-18708-2-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1344166241-18708-1-git-send-email-tlinder@codeaurora.org>
References: <1344166241-18708-1-git-send-email-tlinder@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is exported in blk-core.c to be used in other modules
but it's definition in h file is missing.

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
---
 include/linux/blkdev.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index dc63297..ac0d069 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1208,6 +1208,8 @@ static inline void put_dev_sector(Sector p)
 
 struct work_struct;
 int kblockd_schedule_work(struct request_queue *q, struct work_struct *work);
+int kblockd_schedule_delayed_work(struct request_queue *q,
+			struct delayed_work *dwork, unsigned long delay);
 
 #ifdef CONFIG_BLK_CGROUP
 /*
-- 
1.7.6
--
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

