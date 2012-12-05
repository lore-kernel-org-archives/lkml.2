Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab2LEXRz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 18:17:55 -0500
Received: from mail-qa0-f74.google.com ([209.85.216.74]:59330 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab2LEXRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 18:17:54 -0500
From: Michael Spang <spang@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        Michael Spang <spang@chromium.org>
Subject: [PATCH] samsung: Add missing include guard to gpio-core.h
Date: Wed,  5 Dec 2012 18:17:12 -0500
Message-Id: <1354749432-6028-1-git-send-email-spang@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michael Spang <spang@chromium.org>
---
 arch/arm/plat-samsung/include/plat/gpio-core.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-samsung/include/plat/gpio-core.h b/arch/arm/plat-samsung/include/plat/gpio-core.h
index 1fe6917..8622c9a 100644
--- a/arch/arm/plat-samsung/include/plat/gpio-core.h
+++ b/arch/arm/plat-samsung/include/plat/gpio-core.h
@@ -11,6 +11,9 @@
  * published by the Free Software Foundation.
 */
 
+#ifndef __PLAT_SAMSUNG_GPIO_CORE_H
+#define __PLAT_SAMSUNG_GPIO_CORE_H
+
 #define GPIOCON_OFF	(0x00)
 #define GPIODAT_OFF	(0x04)
 
@@ -122,3 +125,5 @@ extern struct samsung_gpio_pm samsung_gpio_pm_4bit;
 /* locking wrappers to deal with multiple access to the same gpio bank */
 #define samsung_gpio_lock(_oc, _fl) spin_lock_irqsave(&(_oc)->lock, _fl)
 #define samsung_gpio_unlock(_oc, _fl) spin_unlock_irqrestore(&(_oc)->lock, _fl)
+
+#endif /* __PLAT_SAMSUNG_GPIO_CORE_H */
-- 
1.7.7.3

