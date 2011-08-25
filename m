Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab1HYPJn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:09:43 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33981 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab1HYPJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:26 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 044/118] drbd: Remove redundant initialization
Date: Thu, 25 Aug 2011 17:07:40 +0200
Message-Id: <1314284934-17999-45-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

packet_seq is initialized by both sides of a connection in
drbd_connect().

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_main.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index a673693..32e44e3 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2953,7 +2953,6 @@ void drbd_init_set_defaults(struct drbd_conf *mdev)
 	atomic_set(&mdev->rs_pending_cnt, 0);
 	atomic_set(&mdev->unacked_cnt, 0);
 	atomic_set(&mdev->local_cnt, 0);
-	atomic_set(&mdev->packet_seq, 0);
 	atomic_set(&mdev->pp_in_use, 0);
 	atomic_set(&mdev->pp_in_use_by_net, 0);
 	atomic_set(&mdev->rs_sect_in, 0);
-- 
1.7.4.1

