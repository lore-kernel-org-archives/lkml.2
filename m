Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab1HYPdC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:33:02 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33062 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab1HYPJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:07 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 025/118] drbd: Inline function overlaps() is now unused
Date: Thu, 25 Aug 2011 17:07:21 +0200
Message-Id: <1314284934-17999-26-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_req.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/block/drbd/drbd_req.h b/drivers/block/drbd/drbd_req.h
index 6dbbe89..9d75647 100644
--- a/drivers/block/drbd/drbd_req.h
+++ b/drivers/block/drbd/drbd_req.h
@@ -260,11 +260,6 @@ static inline void drbd_req_free(struct drbd_request *req)
 	mempool_free(req, drbd_request_mempool);
 }
 
-static inline int overlaps(sector_t s1, int l1, sector_t s2, int l2)
-{
-	return !((s1 + (l1>>9) <= s2) || (s1 >= s2 + (l2>>9)));
-}
-
 /* Short lived temporary struct on the stack.
  * We could squirrel the error to be returned into
  * bio->bi_size, or similar. But that would be too ugly. */
-- 
1.7.4.1

