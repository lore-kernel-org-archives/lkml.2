Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933585Ab2KEXbu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:31:50 -0500
Received: from smtp.outflux.net ([198.145.64.163]:47294 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932880Ab2KEXFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:20 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 045/104] drivers/gpio: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:02 -0800
Message-Id: <1352156701-4038-46-git-send-email-keescook@chromium.org>
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

CC: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/gpio/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index d055cee..402b3b6 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -62,7 +62,7 @@ config DEBUG_GPIO
 
 config GPIO_SYSFS
 	bool "/sys/class/gpio/... (sysfs interface)"
-	depends on SYSFS && EXPERIMENTAL
+	depends on SYSFS
 	help
 	  Say Y here to add a sysfs interface for GPIOs.
 
-- 
1.7.9.5

