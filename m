Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965332Ab2JWUue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:50:34 -0400
Received: from smtp.outflux.net ([198.145.64.163]:46426 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933769Ab2JWUFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:22 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Chris Mason <chris.mason@fusionio.com>
Subject: [PATCH 142/193] fs/btrfs: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:35 -0700
Message-Id: <1351022666-6960-143-git-send-email-keescook@chromium.org>
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

CC: Chris Mason <chris.mason@fusionio.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/btrfs/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index d33f01c..ccd25ba 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -1,6 +1,5 @@
 config BTRFS_FS
-	tristate "Btrfs filesystem (EXPERIMENTAL) Unstable disk format"
-	depends on EXPERIMENTAL
+	tristate "Btrfs filesystem Unstable disk format"
 	select LIBCRC32C
 	select ZLIB_INFLATE
 	select ZLIB_DEFLATE
-- 
1.7.9.5

