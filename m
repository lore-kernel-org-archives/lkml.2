Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965616Ab2JWVLN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:11:13 -0400
Received: from smtp.outflux.net ([198.145.64.163]:37769 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933663Ab2JWUFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:04 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH 010/193] arch/cris/arch-v32/drivers: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:01:23 -0700
Message-Id: <1351022666-6960-11-git-send-email-keescook@chromium.org>
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

CC: Mikael Starvik <starvik@axis.com>
CC: Jesper Nilsson <jesper.nilsson@axis.com>
CC: "David S. Miller" <davem@davemloft.net>
CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/cris/arch-v32/drivers/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/cris/arch-v32/drivers/Kconfig b/arch/cris/arch-v32/drivers/Kconfig
index de43aad..af4a486 100644
--- a/arch/cris/arch-v32/drivers/Kconfig
+++ b/arch/cris/arch-v32/drivers/Kconfig
@@ -680,7 +680,7 @@ config ETRAX_SPI_MMC_BOARD
 
 config SPI_ETRAX_SSER
 	tristate
-	depends on SPI_MASTER && ETRAX_ARCH_V32 && EXPERIMENTAL
+	depends on SPI_MASTER && ETRAX_ARCH_V32
 	select SPI_BITBANG
 	help
 	  This enables using an synchronous serial (sser) port as a
@@ -689,7 +689,7 @@ config SPI_ETRAX_SSER
 
 config SPI_ETRAX_GPIO
 	tristate
-	depends on SPI_MASTER && ETRAX_ARCH_V32 && EXPERIMENTAL
+	depends on SPI_MASTER && ETRAX_ARCH_V32
 	select SPI_BITBANG
 	help
 	  This enables using GPIO pins port as a SPI master controller
-- 
1.7.9.5

