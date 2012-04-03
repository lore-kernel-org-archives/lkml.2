Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab2DCIvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 04:51:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64850 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab2DCIvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 04:51:00 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com, ben@simtec.co.uk,
        sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH] ARM: EXYNOS: Fix compiler warning in gpio-samsung.c file
Date: Tue,  3 Apr 2012 14:12:55 +0530
Message-Id: <1333442575-8777-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following warning when "SAMSUNG EXYNOS5" is not selected:

warning: ‘exynos5_gpios_1’ defined but not used [-Wunused-variable]
warning: ‘exynos5_gpios_2’ defined but not used [-Wunused-variable]
warning: ‘exynos5_gpios_3’ defined but not used [-Wunused-variable]
warning: ‘exynos5_gpios_4’ defined but not used [-Wunused-variable]

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/gpio/gpio-samsung.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
index 4627787..19d6fc0 100644
--- a/drivers/gpio/gpio-samsung.c
+++ b/drivers/gpio/gpio-samsung.c
@@ -2382,8 +2382,8 @@ static struct samsung_gpio_chip exynos4_gpios_3[] = {
 #endif
 };
 
-static struct samsung_gpio_chip exynos5_gpios_1[] = {
 #ifdef CONFIG_ARCH_EXYNOS5
+static struct samsung_gpio_chip exynos5_gpios_1[] = {
 	{
 		.chip	= {
 			.base	= EXYNOS5_GPA0(0),
@@ -2541,11 +2541,11 @@ static struct samsung_gpio_chip exynos5_gpios_1[] = {
 			.to_irq	= samsung_gpiolib_to_irq,
 		},
 	},
-#endif
 };
+#endif
 
-static struct samsung_gpio_chip exynos5_gpios_2[] = {
 #ifdef CONFIG_ARCH_EXYNOS5
+static struct samsung_gpio_chip exynos5_gpios_2[] = {
 	{
 		.chip	= {
 			.base	= EXYNOS5_GPE0(0),
@@ -2602,11 +2602,11 @@ static struct samsung_gpio_chip exynos5_gpios_2[] = {
 
 		},
 	},
-#endif
 };
+#endif
 
-static struct samsung_gpio_chip exynos5_gpios_3[] = {
 #ifdef CONFIG_ARCH_EXYNOS5
+static struct samsung_gpio_chip exynos5_gpios_3[] = {
 	{
 		.chip	= {
 			.base	= EXYNOS5_GPV0(0),
@@ -2638,11 +2638,11 @@ static struct samsung_gpio_chip exynos5_gpios_3[] = {
 			.label	= "GPV4",
 		},
 	},
-#endif
 };
+#endif
 
-static struct samsung_gpio_chip exynos5_gpios_4[] = {
 #ifdef CONFIG_ARCH_EXYNOS5
+static struct samsung_gpio_chip exynos5_gpios_4[] = {
 	{
 		.chip	= {
 			.base	= EXYNOS5_GPZ(0),
@@ -2650,8 +2650,8 @@ static struct samsung_gpio_chip exynos5_gpios_4[] = {
 			.label	= "GPZ",
 		},
 	},
-#endif
 };
+#endif
 
 
 #if defined(CONFIG_ARCH_EXYNOS) && defined(CONFIG_OF)
-- 
1.7.4.1

