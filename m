Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933505Ab1JNV6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 17:58:51 -0400
Received: from mail09.linbit.com ([212.69.161.110]:60881 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756999Ab1JNV54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 17:57:56 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 07/11] drbd: Print memory address in hex instead of decimal in error message
Date: Fri, 14 Oct 2011 23:57:48 +0200
Message-Id: <1318629472-11110-8-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318629472-11110-1-git-send-email-philipp.reisner@linbit.com>
References: <1318629472-11110-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index d4e677c..bfbc103 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1611,7 +1611,7 @@ find_request(struct drbd_conf *mdev, struct rb_root *root, u64 id,
 	if (drbd_contains_interval(root, sector, &req->i) && req->i.local)
 		return req;
 	if (!missing_ok) {
-		dev_err(DEV, "%s: failed to find request %lu, sector %llus\n", func,
+		dev_err(DEV, "%s: failed to find request 0x%lx, sector %llus\n", func,
 			(unsigned long)id, (unsigned long long)sector);
 	}
 	return NULL;
-- 
1.7.4.1

