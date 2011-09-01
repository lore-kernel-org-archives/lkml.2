Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab1IAMtM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 08:49:12 -0400
Received: from mail09.linbit.com ([212.69.161.110]:55649 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757479Ab1IAMtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 08:49:08 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 01/18] drbd: default to detach on-io-error
Date: Thu,  1 Sep 2011 14:48:48 +0200
Message-Id: <1314881345-6420-2-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314881345-6420-1-git-send-email-philipp.reisner@linbit.com>
References: <1314881345-6420-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Old default behaviour was "pass-on",
which is not useful in production at all.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 include/linux/drbd_limits.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/drbd_limits.h b/include/linux/drbd_limits.h
index 75f05af..22920a8 100644
--- a/include/linux/drbd_limits.h
+++ b/include/linux/drbd_limits.h
@@ -125,7 +125,7 @@
 #define DRBD_DISK_SIZE_SECT_MAX  (1 * (2LLU << 40))
 #define DRBD_DISK_SIZE_SECT_DEF  0 /* = disabled = no user size... */
 
-#define DRBD_ON_IO_ERROR_DEF EP_PASS_ON
+#define DRBD_ON_IO_ERROR_DEF EP_DETACH
 #define DRBD_FENCING_DEF FP_DONT_CARE
 #define DRBD_AFTER_SB_0P_DEF ASB_DISCONNECT
 #define DRBD_AFTER_SB_1P_DEF ASB_DISCONNECT
-- 
1.7.4.1

