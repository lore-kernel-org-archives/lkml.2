Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965369Ab2JWUwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:52:16 -0400
Received: from smtp.outflux.net ([198.145.64.163]:55157 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933761Ab2JWUFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:21 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>
Subject: [PATCH 138/193] fs/affs: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:31 -0700
Message-Id: <1351022666-6960-139-git-send-email-keescook@chromium.org>
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

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/affs/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/affs/Kconfig b/fs/affs/Kconfig
index cfad9af..a04d9e8 100644
--- a/fs/affs/Kconfig
+++ b/fs/affs/Kconfig
@@ -1,6 +1,6 @@
 config AFFS_FS
-	tristate "Amiga FFS file system support (EXPERIMENTAL)"
-	depends on BLOCK && EXPERIMENTAL
+	tristate "Amiga FFS file system support"
+	depends on BLOCK
 	help
 	  The Fast File System (FFS) is the common file system used on hard
 	  disks by Amiga(tm) systems since AmigaOS Version 1.3 (34.20).  Say Y
-- 
1.7.9.5

