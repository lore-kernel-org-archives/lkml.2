Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933930Ab2JWUHi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:07:38 -0400
Received: from smtp.outflux.net ([198.145.64.163]:51359 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933917Ab2JWUHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:07:35 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 149/193] fs/jffs2: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:42 -0700
Message-Id: <1351022666-6960-150-git-send-email-keescook@chromium.org>
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

CC: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/jffs2/Kconfig |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/jffs2/Kconfig b/fs/jffs2/Kconfig
index 6ae169c..d8bb6c4 100644
--- a/fs/jffs2/Kconfig
+++ b/fs/jffs2/Kconfig
@@ -50,8 +50,8 @@ config JFFS2_FS_WBUF_VERIFY
 	  write-buffer, and check for errors.
 
 config JFFS2_SUMMARY
-	bool "JFFS2 summary support (EXPERIMENTAL)"
-	depends on JFFS2_FS && EXPERIMENTAL
+	bool "JFFS2 summary support"
+	depends on JFFS2_FS
 	default n
 	help
 	  This feature makes it possible to use summary information
@@ -63,8 +63,8 @@ config JFFS2_SUMMARY
 	  If unsure, say 'N'.
 
 config JFFS2_FS_XATTR
-	bool "JFFS2 XATTR support (EXPERIMENTAL)"
-	depends on JFFS2_FS && EXPERIMENTAL
+	bool "JFFS2 XATTR support"
+	depends on JFFS2_FS
 	default n
 	help
 	  Extended attributes are name:value pairs associated with inodes by
@@ -173,7 +173,7 @@ config JFFS2_CMODE_PRIORITY
 	  successful one.
 
 config JFFS2_CMODE_SIZE
-	bool "size (EXPERIMENTAL)"
+	bool "size"
 	help
 	  Tries all compressors and chooses the one which has the smallest
 	  result.
-- 
1.7.9.5

