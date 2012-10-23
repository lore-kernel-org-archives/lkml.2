Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964787Ab2JWUgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:36:18 -0400
Received: from smtp.outflux.net ([198.145.64.163]:57880 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933841Ab2JWUFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:34 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Evgeniy Polyakov <zbr@ioremap.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Walmsley <paul@pwsan.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 134/193] drivers/w1/masters: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:27 -0700
Message-Id: <1351022666-6960-135-git-send-email-keescook@chromium.org>
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

CC: Evgeniy Polyakov <zbr@ioremap.net>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Paul Walmsley <paul@pwsan.com>
CC: Felipe Balbi <balbi@ti.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/w1/masters/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/w1/masters/Kconfig b/drivers/w1/masters/Kconfig
index 7e98403..c433a74 100644
--- a/drivers/w1/masters/Kconfig
+++ b/drivers/w1/masters/Kconfig
@@ -26,7 +26,7 @@ config W1_MASTER_DS2490
 
 config W1_MASTER_DS2482
 	tristate "Maxim DS2482 I2C to 1-Wire bridge"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get support for the Maxim DS2482
 	  I2C to 1-Wire bridge.
-- 
1.7.9.5

