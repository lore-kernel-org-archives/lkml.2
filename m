Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab1HYP0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:26:24 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33981 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab1HYPJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:33 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 056/118] drbd: Remove unused variable in struct drbd_conf
Date: Thu, 25 Aug 2011 17:07:52 +0200
Message-Id: <1314284934-17999-57-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index faa7cbd..c730f20 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1045,9 +1045,6 @@ struct drbd_conf {
 	struct list_head read_ee;   /* IO in progress (any read) */
 	struct list_head net_ee;    /* zero-copy network send in progress */
 
-	/* this one is protected by ee_lock, single thread */
-	struct drbd_epoch_entry *last_write_w_barrier;
-
 	int next_barrier_nr;
 	struct list_head resync_reads;
 	atomic_t pp_in_use;		/* allocated from page pool */
-- 
1.7.4.1

