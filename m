Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab1H3JI3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 05:08:29 -0400
Received: from mail09.linbit.com ([212.69.161.110]:38215 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab1H3JFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 05:05:54 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 06/15] drbd: fix typo in comment
Date: Tue, 30 Aug 2011 11:05:40 +0200
Message-Id: <1314695149-387-7-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314695149-387-1-git-send-email-philipp.reisner@linbit.com>
References: <1314695149-387-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index ad61863..1ce3de6 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -546,7 +546,7 @@ cancel:
 }
 
 /**
- * drbd_al_apply_to_bm() - Sets the bitmap to diry(1) where covered ba active AL extents
+ * drbd_al_apply_to_bm() - Sets the bitmap to dirty(1) where covered by active AL extents
  * @mdev:	DRBD device.
  */
 void drbd_al_apply_to_bm(struct drbd_conf *mdev)
-- 
1.7.4.1

