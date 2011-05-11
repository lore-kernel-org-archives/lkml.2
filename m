Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab1EKQ0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:26:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43777 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757342Ab1EKQ0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:26:15 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Graeme Gregory <gg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: TPS65910 depends on I2C and must be built in
Date: Wed, 11 May 2011 10:47:47 +0200
Message-Id: <1305103667-17454-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <20110511122738.93d239cb.sfr@canb.auug.org.au>
References: <20110511122738.93d239cb.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index c78865e..0131d49 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -673,7 +673,7 @@ config MFD_OMAP_USB_HOST
 
 config MFD_TPS65910
 	bool "TPS65910 Power Management chip"
-	depends on I2C && GPIOLIB
+	depends on I2C=y && GPIOLIB
 	select MFD_CORE
 	help
 	  if you say yes here you get support for the TPS65910 series of
-- 
1.7.5.1

