Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965528Ab2JWVEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:04:52 -0400
Received: from smtp.outflux.net ([198.145.64.163]:40606 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933690Ab2JWUFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:12 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 059/193] drivers/lguest: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:02:12 -0700
Message-Id: <1351022666-6960-60-git-send-email-keescook@chromium.org>
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

CC: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/lguest/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/lguest/Kconfig b/drivers/lguest/Kconfig
index 34ae49d..6cdcdb0 100644
--- a/drivers/lguest/Kconfig
+++ b/drivers/lguest/Kconfig
@@ -1,6 +1,6 @@
 config LGUEST
 	tristate "Linux hypervisor example code"
-	depends on X86_32 && EXPERIMENTAL && EVENTFD
+	depends on X86_32 && EVENTFD
 	select HVC_DRIVER
 	---help---
 	  This is a very simple module which allows you to run
-- 
1.7.9.5

