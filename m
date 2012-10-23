Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965590Ab2JWVHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:07:20 -0400
Received: from smtp.outflux.net ([198.145.64.163]:45325 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933682Ab2JWUFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:09 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Stephen Warren <swarren@nvidia.com>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH 050/193] drivers/i2c/muxes: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:02:03 -0700
Message-Id: <1351022666-6960-51-git-send-email-keescook@chromium.org>
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

CC: Stephen Warren <swarren@nvidia.com>
CC: Peter Korsgaard <peter.korsgaard@barco.com>
CC: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/i2c/muxes/Kconfig |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/i2c/muxes/Kconfig b/drivers/i2c/muxes/Kconfig
index a0edd98..0be5b83 100644
--- a/drivers/i2c/muxes/Kconfig
+++ b/drivers/i2c/muxes/Kconfig
@@ -19,7 +19,6 @@ config I2C_MUX_GPIO
 
 config I2C_MUX_PCA9541
 	tristate "NXP PCA9541 I2C Master Selector"
-	depends on EXPERIMENTAL
 	help
 	  If you say yes here you get support for the NXP PCA9541
 	  I2C Master Selector.
@@ -29,7 +28,6 @@ config I2C_MUX_PCA9541
 
 config I2C_MUX_PCA954x
 	tristate "Philips PCA954x I2C Mux/switches"
-	depends on EXPERIMENTAL
 	help
 	  If you say yes here you get support for the Philips PCA954x
 	  I2C mux/switch devices.
-- 
1.7.9.5

