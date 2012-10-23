Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933970Ab2JWUKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:10:54 -0400
Received: from smtp.outflux.net ([198.145.64.163]:42516 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933470Ab2JWUKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:10:50 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Evgeniy Dushistov <dushistov@mail.ru>
Subject: [PATCH 153/193] fs/ufs: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:46 -0700
Message-Id: <1351022666-6960-154-git-send-email-keescook@chromium.org>
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

CC: Evgeniy Dushistov <dushistov@mail.ru>
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

