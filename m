Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab1IELsi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:48:38 -0400
Received: from mail09.linbit.com ([212.69.161.110]:60528 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab1IELqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:46:12 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 50/54] drbd: Remove unnecessary assertion
Date: Mon,  5 Sep 2011 13:45:41 +0200
Message-Id: <1315223145-20640-51-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315223145-20640-1-git-send-email-philipp.reisner@linbit.com>
References: <1315223145-20640-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

This is also checked further below in the same function.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_req.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index fa799e3..f91f9c9 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -1010,7 +1010,6 @@ int drbd_make_request(struct request_queue *q, struct bio *bio)
 	 */
 	D_ASSERT(bio->bi_size > 0);
 	D_ASSERT(IS_ALIGNED(bio->bi_size, 512));
-	D_ASSERT(bio->bi_idx == 0);
 
 	/* to make some things easier, force alignment of requests within the
 	 * granularity of our hash tables */
-- 
1.7.4.1

