Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513Ab2HHIIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 04:08:42 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:49751 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932322Ab2HHII3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 04:08:29 -0400
Message-ID: <1344413298.17894.1.camel@phoenix>
Subject: [PATCH] power_supply: Remove broken mark for da9052-battery
From: Axel Lin <axel.lin@gmail.com>
To: Anton Vorontsov <cbou@mail.ru>
Cc: linux-kernel@vger.kernel.org, David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>
Date: Wed, 08 Aug 2012 16:08:18 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fix for MFD part is already merged so we can remove the broken mark
for da9052-battery.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/power/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index c1892f3..fcc1bb0 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -167,7 +167,6 @@ config BATTERY_DA9030
 config BATTERY_DA9052
 	tristate "Dialog DA9052 Battery"
 	depends on PMIC_DA9052
-	depends on BROKEN
 	help
 	  Say Y here to enable support for batteries charger integrated into
 	  DA9052 PMIC.
-- 
1.7.9.5



