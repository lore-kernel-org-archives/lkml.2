Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab1H3JIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 05:08:36 -0400
Received: from mail09.linbit.com ([212.69.161.110]:38187 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab1H3JFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 05:05:52 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 03/15] drbd: Remove obsolete comment
Date: Tue, 30 Aug 2011 11:05:37 +0200
Message-Id: <1314695149-387-4-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314695149-387-1-git-send-email-philipp.reisner@linbit.com>
References: <1314695149-387-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_req.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 18eb3d1..157c737 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -667,10 +667,9 @@ static int drbd_may_do_local_read(struct drbd_conf *mdev, sector_t sector, int s
 		return 0;
 	if (mdev->state.disk <  D_INCONSISTENT)
 		return 0;
-	/* state.disk == D_INCONSISTENT   We will have a look at the BitMap */
-	nr_sectors = drbd_get_capacity(mdev->this_bdev);
 	esector = sector + (size >> 9) - 1;
 
+	nr_sectors = drbd_get_capacity(mdev->this_bdev);
 	D_ASSERT(sector  < nr_sectors);
 	D_ASSERT(esector < nr_sectors);
 
-- 
1.7.4.1

