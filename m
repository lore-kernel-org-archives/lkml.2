Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab1CAJzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 04:55:04 -0500
Received: from compulab.co.il ([67.18.134.219]:45346 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756093Ab1CAJzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 04:55:02 -0500
From: Igor Grinberg <grinberg@compulab.co.il>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Igor Grinberg <grinberg@compulab.co.il>
Subject: [PATCH] regulator: fix typo in Kconfig
Date: Tue,  1 Mar 2011 11:54:44 +0200
Message-Id: <1298973284-17872-1-git-send-email-grinberg@compulab.co.il>
X-Mailer: git-send-email 1.7.3.4
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix typo: s/TPS695x0/TPS659x0/

Signed-off-by: Igor Grinberg <grinberg@compulab.co.il>
---
 drivers/regulator/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index e1d9436..66a82e1 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -117,7 +117,7 @@ config REGULATOR_MAX8998
 	  and S5PC1XX chips to control VCC_CORE and VCC_USIM voltages.
 
 config REGULATOR_TWL4030
-	bool "TI TWL4030/TWL5030/TWL6030/TPS695x0 PMIC"
+	bool "TI TWL4030/TWL5030/TWL6030/TPS659x0 PMIC"
 	depends on TWL4030_CORE
 	help
 	  This driver supports the voltage regulators provided by
-- 
1.7.3.4

