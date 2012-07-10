Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab2GJHPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 03:15:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:55226 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152Ab2GJHPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 03:15:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="120632527"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [PATCH] block: remove dead func declaration
Date: Tue, 10 Jul 2012 15:21:03 +0800
Message-Id: <1341904863-29150-1-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__generic_unplug_device() function is removed with commit
7eaceaccab5f40bbfda044629a6298616aeaed50, which forgot to
remove the declaration at meantime. Here remove it.

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 block/blk.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/block/blk.h b/block/blk.h
index 85f6ae4..a62195b 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -33,7 +33,6 @@ bool __blk_end_bidi_request(struct request *rq, int error,
 void blk_rq_timed_out_timer(unsigned long data);
 void blk_delete_timer(struct request *);
 void blk_add_timer(struct request *);
-void __generic_unplug_device(struct request_queue *);
 
 /*
  * Internal atomic flags for request handling
-- 
1.7.7.6

