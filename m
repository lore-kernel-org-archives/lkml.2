Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964839Ab2JWUeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:34:37 -0400
Received: from smtp.outflux.net ([198.145.64.163]:39541 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933851Ab2JWUFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:36 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 152/193] fs/nilfs2: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:45 -0700
Message-Id: <1351022666-6960-153-git-send-email-keescook@chromium.org>
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

CC: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/nilfs2/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/nilfs2/Kconfig b/fs/nilfs2/Kconfig
index 251da07..80da8eb 100644
--- a/fs/nilfs2/Kconfig
+++ b/fs/nilfs2/Kconfig
@@ -1,6 +1,5 @@
 config NILFS2_FS
-	tristate "NILFS2 file system support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "NILFS2 file system support"
 	select CRC32
 	help
 	  NILFS2 is a log-structured file system (LFS) supporting continuous
-- 
1.7.9.5

