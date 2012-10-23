Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965568Ab2JWVDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:03:11 -0400
Received: from smtp.outflux.net ([198.145.64.163]:59229 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933697Ab2JWUFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:13 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 033/193] block: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:01:46 -0700
Message-Id: <1351022666-6960-34-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351022666-6960-1-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This config item has not carried much meaning for a while now and is
almost always enabled by default. As agreed during the Linux kernel
summit, remove it.

CC: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 block/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/Kconfig b/block/Kconfig
index 09acf1b..a7e40a7 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -89,7 +89,7 @@ config BLK_DEV_INTEGRITY
 
 config BLK_DEV_THROTTLING
 	bool "Block layer bio throttling support"
-	depends on BLK_CGROUP=y && EXPERIMENTAL
+	depends on BLK_CGROUP=y
 	default n
 	---help---
 	Block layer bio throttling support. It can be used to limit
-- 
1.7.9.5

