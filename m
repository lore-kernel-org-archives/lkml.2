Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab2KEXPu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:15:50 -0500
Received: from smtp.outflux.net ([198.145.64.163]:39341 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754699Ab2KEXFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:30 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Joern Engel <joern@logfs.org>,
        Prasad Joshi <prasadjoshi.linux@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 098/104] fs/logfs: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:55 -0800
Message-Id: <1352156701-4038-99-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352156701-4038-1-git-send-email-keescook@chromium.org>
References: <1352156701-4038-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

CC: Joern Engel <joern@logfs.org>
CC: Prasad Joshi <prasadjoshi.linux@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
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

