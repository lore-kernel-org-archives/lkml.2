Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935633Ab2JYL2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 07:28:53 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:41507 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934929Ab2JYL2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 07:28:51 -0400
From: Roland Stigge <stigge@antcom.de>
To: wim@iguana.be, grant.likely@secretlab.ca, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH] watchdog: Support imx watchdog on SOC_IMX53
Date: Thu, 25 Oct 2012 13:28:33 +0200
Message-Id: <1351164513-27999-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes watchdog support after devicetree switch for imx53

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
 arch/arm/mach-imx/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.orig/arch/arm/mach-imx/Kconfig
+++ linux-2.6/arch/arm/mach-imx/Kconfig
@@ -739,6 +739,7 @@ config	SOC_IMX53
 	select ARCH_MX5
 	select ARCH_MX53
 	select HAVE_CAN_FLEXCAN if CAN
+	select IMX_HAVE_PLATFORM_IMX2_WDT
 	select PINCTRL
 	select PINCTRL_IMX53
 	select SOC_IMX5
