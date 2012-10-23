Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965351Ab2JWUwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:52:14 -0400
Received: from smtp.outflux.net ([198.145.64.163]:35910 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933762Ab2JWUFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:21 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>
Subject: [PATCH 140/193] fs/befs: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:33 -0700
Message-Id: <1351022666-6960-141-git-send-email-keescook@chromium.org>
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
 fs/befs/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/befs/Kconfig b/fs/befs/Kconfig
index 7835d30..edc5cc2 100644
--- a/fs/befs/Kconfig
+++ b/fs/befs/Kconfig
@@ -1,6 +1,6 @@
 config BEFS_FS
-	tristate "BeOS file system (BeFS) support (read only) (EXPERIMENTAL)"
-	depends on BLOCK && EXPERIMENTAL
+	tristate "BeOS file system (BeFS) support (read only)"
+	depends on BLOCK
 	select NLS
 	help
 	  The BeOS File System (BeFS) is the native file system of Be, Inc's
-- 
1.7.9.5

