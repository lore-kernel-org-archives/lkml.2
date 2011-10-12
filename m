Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab1JLM1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 08:27:42 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33900 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab1JLM1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 08:27:38 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 02/13] drbd: Use DRBD_MINOR_COUNT_DEF in one more place
Date: Wed, 12 Oct 2011 14:27:24 +0200
Message-Id: <1318422455-17539-3-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318422455-17539-1-git-send-email-philipp.reisner@linbit.com>
References: <1318422455-17539-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 73951cc..5b1865e 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2669,7 +2669,7 @@ int __init drbd_init(void)
 #ifdef MODULE
 		return -EINVAL;
 #else
-		minor_count = 8;
+		minor_count = DRBD_MINOR_COUNT_DEF;
 #endif
 	}
 
-- 
1.7.4.1

