Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965262Ab2JWUrk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:47:40 -0400
Received: from smtp.outflux.net ([198.145.64.163]:51246 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933785Ab2JWUFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:23 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>
Subject: [PATCH 148/193] fs/hfs: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:41 -0700
Message-Id: <1351022666-6960-149-git-send-email-keescook@chromium.org>
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
 fs/hfs/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/hfs/Kconfig b/fs/hfs/Kconfig
index b77c5bc..998e3a6 100644
--- a/fs/hfs/Kconfig
+++ b/fs/hfs/Kconfig
@@ -1,6 +1,6 @@
 config HFS_FS
-	tristate "Apple Macintosh file system support (EXPERIMENTAL)"
-	depends on BLOCK && EXPERIMENTAL
+	tristate "Apple Macintosh file system support"
+	depends on BLOCK
 	select NLS
 	help
 	  If you say Y here, you will be able to mount Macintosh-formatted
-- 
1.7.9.5

