Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982Ab2KEXRc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:17:32 -0500
Received: from smtp.outflux.net ([198.145.64.163]:36667 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932816Ab2KEXF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:28 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Florian Fainelli <florian@openwrt.org>
Subject: [PATCH 084/104] drivers/vlynq: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:41 -0800
Message-Id: <1352156701-4038-85-git-send-email-keescook@chromium.org>
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

Cc: Florian Fainelli <florian@openwrt.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/vlynq/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vlynq/Kconfig b/drivers/vlynq/Kconfig
index d874b4f..e011620 100644
--- a/drivers/vlynq/Kconfig
+++ b/drivers/vlynq/Kconfig
@@ -1,5 +1,5 @@
 menu "TI VLYNQ"
-	depends on AR7 && EXPERIMENTAL
+	depends on AR7
 
 config VLYNQ
 	bool "TI VLYNQ bus support"
-- 
1.7.9.5

