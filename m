Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934260Ab1JEJiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 05:38:15 -0400
Received: from mail09.linbit.com ([212.69.161.110]:56217 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934189Ab1JEJiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 05:38:09 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 05/16] drbd: fix copy/paste error in comment
Date: Wed,  5 Oct 2011 11:37:53 +0200
Message-Id: <1317807484-24628-6-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317807484-24628-1-git-send-email-philipp.reisner@linbit.com>
References: <1317807484-24628-1-git-send-email-philipp.reisner@linbit.com>
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
index 50b851e..933404e 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -307,7 +307,7 @@ static unsigned int rs_extent_to_bm_page(unsigned int rs_enr)
 	return rs_enr >>
 		/* bit to page */
 		((PAGE_SHIFT + 3) -
-		/* al extent number to bit */
+		/* resync extent number to bit */
 		 (BM_EXT_SHIFT - BM_BLOCK_SHIFT));
 }
 
-- 
1.7.4.1

