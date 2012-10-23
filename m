Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965271Ab2JWUtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:49:21 -0400
Received: from smtp.outflux.net ([198.145.64.163]:60822 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933777Ab2JWUFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:23 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 118/193] drivers/rpmsg: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:11 -0700
Message-Id: <1351022666-6960-119-git-send-email-keescook@chromium.org>
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

CC: Ohad Ben-Cohen <ohad@wizery.com>
CC: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/rpmsg/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/rpmsg/Kconfig b/drivers/rpmsg/Kconfig
index 2bd911f..f6e0ea6 100644
--- a/drivers/rpmsg/Kconfig
+++ b/drivers/rpmsg/Kconfig
@@ -1,9 +1,8 @@
-menu "Rpmsg drivers (EXPERIMENTAL)"
+menu "Rpmsg drivers"
 
 # RPMSG always gets selected by whoever wants it
 config RPMSG
 	tristate
 	select VIRTIO
-	depends on EXPERIMENTAL
 
 endmenu
-- 
1.7.9.5

