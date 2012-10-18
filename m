Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048Ab2JRQHI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 12:07:08 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:53037 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753324Ab2JRQHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 12:07:03 -0400
From: Roland Stigge <stigge@antcom.de>
To: a.zummo@towertech.it, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, s.hauer@pengutronix.de,
        linux-arm-kernel@lists.infradead.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 1/2] rtc-imxdi: Support for i.MX53
Date: Thu, 18 Oct 2012 18:06:08 +0200
Message-Id: <1350576370-29098-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables support for i.MX53 in addition to i.MX25 by enabling the
driver on ARCH_MXC generally.

Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 drivers/rtc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.orig/drivers/rtc/Kconfig
+++ linux-2.6/drivers/rtc/Kconfig
@@ -768,7 +768,7 @@ config RTC_DRV_DAVINCI
 
 config RTC_DRV_IMXDI
 	tristate "Freescale IMX DryIce Real Time Clock"
-	depends on SOC_IMX25
+	depends on ARCH_MXC
 	help
 	   Support for Freescale IMX DryIce RTC
 
