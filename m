Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965382Ab2JWUwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:52:18 -0400
Received: from smtp.outflux.net ([198.145.64.163]:52801 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933760Ab2JWUFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:21 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>
Subject: [PATCH 137/193] fs/adfs: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:30 -0700
Message-Id: <1351022666-6960-138-git-send-email-keescook@chromium.org>
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
 fs/adfs/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/adfs/Kconfig b/fs/adfs/Kconfig
index e55182a..c5a7787 100644
--- a/fs/adfs/Kconfig
+++ b/fs/adfs/Kconfig
@@ -1,6 +1,6 @@
 config ADFS_FS
-	tristate "ADFS file system support (EXPERIMENTAL)"
-	depends on BLOCK && EXPERIMENTAL
+	tristate "ADFS file system support"
+	depends on BLOCK
 	help
 	  The Acorn Disc Filing System is the standard file system of the
 	  RiscOS operating system which runs on Acorn's ARM-based Risc PC
-- 
1.7.9.5

