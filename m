Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933576Ab2KEX3e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:29:34 -0500
Received: from smtp.outflux.net ([198.145.64.163]:41558 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755056Ab2KEXFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:21 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Tim Waugh <tim@cyberelk.net>
Subject: [PATCH 042/104] drivers/block/paride: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:03:59 -0800
Message-Id: <1352156701-4038-43-git-send-email-keescook@chromium.org>
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

CC: Tim Waugh <tim@cyberelk.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/block/paride/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/paride/Kconfig b/drivers/block/paride/Kconfig
index 28cf308..efefb5a 100644
--- a/drivers/block/paride/Kconfig
+++ b/drivers/block/paride/Kconfig
@@ -205,8 +205,8 @@ config PARIDE_EPAT
 	  support.
 
 config PARIDE_EPATC8
-	bool "Support c7/c8 chips (EXPERIMENTAL)"
-	depends on PARIDE_EPAT && EXPERIMENTAL
+	bool "Support c7/c8 chips"
+	depends on PARIDE_EPAT
 	help
 	  This option enables support for the newer Shuttle EP1284 (aka c7 and
 	  c8) chip. You need this if you are using any recent Imation SuperDisk
-- 
1.7.9.5

