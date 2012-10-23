Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964910Ab2JWUGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:06:55 -0400
Received: from smtp.outflux.net ([198.145.64.163]:47037 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964897Ab2JWUGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:06:52 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Ben Myers <bpm@sgi.com>,
        Alex Elder <elder@kernel.org>
Subject: [PATCH 154/193] fs/xfs: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:47 -0700
Message-Id: <1351022666-6960-155-git-send-email-keescook@chromium.org>
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

CC: Ben Myers <bpm@sgi.com>
CC: Alex Elder <elder@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/xfs/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index 6100ec0..d841fd1 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -69,8 +69,8 @@ config XFS_RT
 	  If unsure, say N.
 
 config XFS_DEBUG
-	bool "XFS Debugging support (EXPERIMENTAL)"
-	depends on XFS_FS && EXPERIMENTAL
+	bool "XFS Debugging support"
+	depends on XFS_FS
 	help
 	  Say Y here to get an XFS build with many debugging features,
 	  including ASSERT checks, function wrappers around macros,
-- 
1.7.9.5

