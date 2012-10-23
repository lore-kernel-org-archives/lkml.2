Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965677Ab2JWVNa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:13:30 -0400
Received: from smtp.outflux.net ([198.145.64.163]:59617 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933650Ab2JWUFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:02 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 043/193] drivers/gpio: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:01:56 -0700
Message-Id: <1351022666-6960-44-git-send-email-keescook@chromium.org>
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

CC: Grant Likely <grant.likely@secretlab.ca>
CC: Linus Walleij <linus.walleij@linaro.org>
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

