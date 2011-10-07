Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965416Ab1JGL2i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 07:28:38 -0400
Received: from mail09.linbit.com ([212.69.161.110]:36052 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965163Ab1JGL1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 07:27:53 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 12/12] drbd: Rename DISK_SIZE_SECT -> DISK_SIZE
Date: Fri,  7 Oct 2011 13:27:45 +0200
Message-Id: <1317986865-3706-13-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317986865-3706-1-git-send-email-philipp.reisner@linbit.com>
References: <1317986865-3706-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

We don't have the units in constant names in other places, either.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 include/linux/drbd_limits.h |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/drbd_limits.h b/include/linux/drbd_limits.h
index 62e93b2..07d5df9 100644
--- a/include/linux/drbd_limits.h
+++ b/include/linux/drbd_limits.h
@@ -123,9 +123,10 @@
  * the upper limit with 64bit kernel, enough ram and flexible meta data
  * is 1 PiB, currently. */
 /* DRBD_MAX_SECTORS */
-#define DRBD_DISK_SIZE_SECT_MIN  0
-#define DRBD_DISK_SIZE_SECT_MAX  (1 * (2LLU << 40))
-#define DRBD_DISK_SIZE_SECT_DEF  0 /* = disabled = no user size... */
+#define DRBD_DISK_SIZE_MIN  0
+#define DRBD_DISK_SIZE_MAX  (16 * (2LLU << 30))
+#define DRBD_DISK_SIZE_DEF  0 /* = disabled = no user size... */
+#define DRBD_DISK_SIZE_SCALE 's'  /* sectors */
 
 #define DRBD_ON_IO_ERROR_DEF EP_DETACH
 #define DRBD_FENCING_DEF FP_DONT_CARE
-- 
1.7.4.1

