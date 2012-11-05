Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896Ab2KEXGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:06:18 -0500
Received: from smtp.outflux.net ([198.145.64.163]:48146 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754715Ab2KEXF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:58 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Evgeniy Dushistov <dushistov@mail.ru>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 100/104] fs/ufs: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:57 -0800
Message-Id: <1352156701-4038-101-git-send-email-keescook@chromium.org>
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

CC: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/ufs/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ufs/Kconfig b/fs/ufs/Kconfig
index e4f10a4..0bf6e16 100644
--- a/fs/ufs/Kconfig
+++ b/fs/ufs/Kconfig
@@ -29,7 +29,7 @@ config UFS_FS
 
 config UFS_FS_WRITE
 	bool "UFS file system write support (DANGEROUS)"
-	depends on UFS_FS && EXPERIMENTAL
+	depends on UFS_FS
 	help
 	  Say Y here if you want to try writing to UFS partitions. This is
 	  experimental, so you should back up your UFS partitions beforehand.
-- 
1.7.9.5

