Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083Ab2GCLpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 07:45:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39031 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751668Ab2GCLpm (ORCPT
	<rfc822;linux-kernel@Vger.kernel.org>);
	Tue, 3 Jul 2012 07:45:42 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: arizona: Force on REGMAP for the core
Date: Tue,  3 Jul 2012 12:45:39 +0100
Message-Id: <1341315939-17579-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While the core isn't useful by itself it does depend on regmap so try to
force that on.

Reported-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index b5f5ceb..719c342 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -495,6 +495,7 @@ config MFD_S5M_CORE
 	 of the device
 
 config MFD_ARIZONA
+	select REGMAP
 	tristate
 
 config MFD_ARIZONA_I2C
-- 
1.7.10

