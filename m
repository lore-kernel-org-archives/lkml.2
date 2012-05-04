Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab2EDGIZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 02:08:25 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47660 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193Ab2EDGIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 02:08:24 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <greg@kroah.com>
CC: <paul.gortmaker@windriver.com>, <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] memory: emif: Add Kconfig dependency for TI EMIF controller
Date: Fri, 4 May 2012 11:38:11 +0530
Message-ID: <1336111691-16728-1-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make TI_EMIF depends on ARCH_OMAP2PLUS to avoid build breaks on other
architectures. In future if other TI non OMAP socs start using it, the
dependency can be extended.

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Reported-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/memory/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/memory/Kconfig b/drivers/memory/Kconfig
index b08327c..e0b3156 100644
--- a/drivers/memory/Kconfig
+++ b/drivers/memory/Kconfig
@@ -9,6 +9,7 @@ if MEMORY
 
 config TI_EMIF
 	tristate "Texas Instruments EMIF driver"
+	depends on ARCH_OMAP2PLUS
 	select DDR
 	help
 	  This driver is for the EMIF module available in Texas Instruments
-- 
1.7.5.4

