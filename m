Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907Ab0JFAHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 20:07:42 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38904 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756357Ab0JFAHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 20:07:41 -0400
From: Fernando Guzman Lugo <x0095840@ti.com>
To: <gregkh@suse.de>
Cc: <felipe.contreras@nokia.com>, <nm@ti.com>, <Hiroshi.DOYU@nokia.com>,
        <ohad@wizery.com>, <linux-kernel@vger.kernel.org>,
        <andy.shevchenko@gmail.com>, <linux-omap@vger.kernel.org>,
        Fernando Guzman Lugo <x0095840@ti.com>
Subject: [PATCH] staging: tidspbridge - update Kconfig to select IOMMU module
Date: Tue,  5 Oct 2010 19:20:59 -0500
Message-Id: <1286324459-886-1-git-send-email-x0095840@ti.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IOMMU module most be selected when using tidspbridge, because
now tidsbridge depends on iommu module.

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
---
 drivers/staging/tidspbridge/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/tidspbridge/Kconfig b/drivers/staging/tidspbridge/Kconfig
index 93de4f2..ff64d46 100644
--- a/drivers/staging/tidspbridge/Kconfig
+++ b/drivers/staging/tidspbridge/Kconfig
@@ -6,6 +6,7 @@ menuconfig TIDSPBRIDGE
 	tristate "DSP Bridge driver"
 	depends on ARCH_OMAP3
 	select OMAP_MBOX_FWK
+	select OMAP_IOMMU
 	help
 	  DSP/BIOS Bridge is designed for platforms that contain a GPP and
 	  one or more attached DSPs.  The GPP is considered the master or
-- 
1.6.3.3

