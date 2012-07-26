Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab2GZOvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 10:51:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37447 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752160Ab2GZOvM (ORCPT
	<rfc822;linux-kernel@Vger.kernel.org>);
	Thu, 26 Jul 2012 10:51:12 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Michael Jones <michael.jones@matrix-vision.de>, Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: core: Clarify grammar for dummy help text
Date: Thu, 26 Jul 2012 15:51:11 +0100
Message-Id: <1343314271-26550-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Too many thens in the if...then clause.

Reported-by: Michael Jones <michael.jones@matrix-vision.de>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/Kconfig |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 4e932cc..17c41ad 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -33,9 +33,8 @@ config REGULATOR_DUMMY
 	help
 	  If this option is enabled then when a regulator lookup fails
 	  and the board has not specified that it has provided full
-	  constraints then the regulator core will provide an always
-	  enabled dummy regulator will be provided, allowing consumer
-	  drivers to continue.
+	  constraints the regulator core will provide an always
+	  enabled dummy regulator, allowing consumer drivers to continue.
 
 	  A warning will be generated when this substitution is done.
 
-- 
1.7.10.4

