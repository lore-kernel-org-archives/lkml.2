Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab1JJL4n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 07:56:43 -0400
Received: from mail09.linbit.com ([212.69.161.110]:45071 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab1JJLzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 07:55:14 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 07/13] drbd: Use more generic constant names
Date: Mon, 10 Oct 2011 13:55:00 +0200
Message-Id: <1318247706-7732-8-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318247706-7732-1-git-send-email-philipp.reisner@linbit.com>
References: <1318247706-7732-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

These constants are useful for the same purpose in more than one place.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 include/linux/drbd_limits.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/drbd_limits.h b/include/linux/drbd_limits.h
index 07d5df9..2b364d5 100644
--- a/include/linux/drbd_limits.h
+++ b/include/linux/drbd_limits.h
@@ -111,10 +111,10 @@
 #define DRBD_AL_EXTENTS_MAX  6433
 #define DRBD_AL_EXTENTS_DEF  127
 
-#define DRBD_RESYNC_AFTER_MIN  -1
-#define DRBD_RESYNC_AFTER_MAX  (1<<30)
-#define DRBD_RESYNC_AFTER_DEF  -1
-#define DRBD_RESYNC_AFTER_SCALE '1'
+#define DRBD_MINOR_NUMBER_MIN  -1
+#define DRBD_MINOR_NUMBER_MAX  (1<<30)
+#define DRBD_MINOR_NUMBER_DEF  -1
+#define DRBD_MINOR_NUMBER_SCALE '1'
 
 /* } */
 
-- 
1.7.4.1

