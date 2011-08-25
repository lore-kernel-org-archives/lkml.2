Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab1HYPJL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:09:11 -0400
Received: from mail09.linbit.com ([212.69.161.110]:32956 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144Ab1HYPJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:01 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 008/118] drbd: Update outdated comment
Date: Thu, 25 Aug 2011 17:07:04 +0200
Message-Id: <1314284934-17999-9-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_receiver.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index bafc233..26810ce 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1512,7 +1512,7 @@ static int receive_RSDataReply(struct drbd_conf *mdev, enum drbd_packets cmd, un
 	if (get_ldev(mdev)) {
 		/* data is submitted to disk within recv_resync_read.
 		 * corresponding put_ldev done below on error,
-		 * or in drbd_endio_write_sec. */
+		 * or in drbd_endio_sec. */
 		ok = recv_resync_read(mdev, sector, data_size);
 	} else {
 		if (__ratelimit(&drbd_ratelimit_state))
@@ -1673,7 +1673,7 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned
 
 	/* get_ldev(mdev) successful.
 	 * Corresponding put_ldev done either below (on various errors),
-	 * or in drbd_endio_write_sec, if we successfully submit the data at
+	 * or in drbd_endio_sec, if we successfully submit the data at
 	 * the end of this function. */
 
 	sector = be64_to_cpu(p->sector);
-- 
1.7.4.1

