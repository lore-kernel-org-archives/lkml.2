Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965144Ab2JWUmb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:42:31 -0400
Received: from smtp.outflux.net ([198.145.64.163]:40742 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933811Ab2JWUF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:28 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Joern Engel <joern@logfs.org>,
        Prasad Joshi <prasadjoshi.linux@gmail.com>
Subject: [PATCH 150/193] fs/logfs: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:43 -0700
Message-Id: <1351022666-6960-151-git-send-email-keescook@chromium.org>
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

CC: Joern Engel <joern@logfs.org>
CC: Prasad Joshi <prasadjoshi.linux@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/logfs/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/logfs/Kconfig b/fs/logfs/Kconfig
index daf9a9b..09ed066 100644
--- a/fs/logfs/Kconfig
+++ b/fs/logfs/Kconfig
@@ -1,6 +1,6 @@
 config LOGFS
-	tristate "LogFS file system (EXPERIMENTAL)"
-	depends on (MTD || BLOCK) && EXPERIMENTAL
+	tristate "LogFS file system"
+	depends on (MTD || BLOCK)
 	select ZLIB_INFLATE
 	select ZLIB_DEFLATE
 	select CRC32
-- 
1.7.9.5

