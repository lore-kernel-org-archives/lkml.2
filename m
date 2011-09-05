Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab1IELsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:48:09 -0400
Received: from mail09.linbit.com ([212.69.161.110]:60183 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab1IELqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:46:12 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 49/54] drbd: Remove duplicate initialization
Date: Mon,  5 Sep 2011 13:45:40 +0200
Message-Id: <1315223145-20640-50-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315223145-20640-1-git-send-email-philipp.reisner@linbit.com>
References: <1315223145-20640-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_state.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index c2b2f49..a14511b 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -985,7 +985,7 @@ static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
 {
 	enum drbd_fencing_p fp;
 	enum drbd_req_event what = NOTHING;
-	union drbd_state nsm = (union drbd_state){ .i = -1 };
+	union drbd_state nsm;
 	struct sib_info sib;
 
 	sib.sib_reason = SIB_STATE_CHANGE;
-- 
1.7.4.1

