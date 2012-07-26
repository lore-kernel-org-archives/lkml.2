Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab2GZOLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 10:11:55 -0400
Received: from mail2.matrix-vision.com ([85.214.244.251]:45563 "EHLO
	mail2.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab2GZOLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 10:11:53 -0400
From: Michael Jones <michael.jones@matrix-vision.de>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] regulator: grammar fix in Kconfig
Date: Thu, 26 Jul 2012 16:07:24 +0200
Message-Id: <1343311644-19739-3-git-send-email-michael.jones@matrix-vision.de>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1343311644-19739-1-git-send-email-michael.jones@matrix-vision.de>
References: <1343311644-19739-1-git-send-email-michael.jones@matrix-vision.de>
X-MV-Disclaimer: true (erinome)
X-AV-Checked: ClamAV using ClamSMTP (erinome)
X-AV-Checked: ClamAV using ClamSMTP (mail2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
---
 drivers/regulator/Kconfig |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 403503f..48419d1 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -32,9 +32,8 @@ config REGULATOR_DUMMY
 	help
 	  If this option is enabled then when a regulator lookup fails
 	  and the board has not specified that it has provided full
-	  constraints then the regulator core will provide an always
-	  enabled dummy regulator will be provided, allowing consumer
-	  drivers to continue.
+	  constraints, the regulator core will provide an always-
+	  enabled dummy regulator, allowing consumer drivers to continue.
 
 	  A warning will be generated when this substitution is done.
 
-- 
1.7.4.1


MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner, Erhard Meier
