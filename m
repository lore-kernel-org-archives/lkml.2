Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181Ab2LNQTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 11:19:55 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:58244 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143Ab2LNQTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 11:19:53 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, Bibek Basu <bibek.basu@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
Subject: [PATCH 03/21] gpio: ab8500: Fix alternate function register address
Date: Fri, 14 Dec 2012 16:19:21 +0000
Message-Id: <1355501979-1157-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
References: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bibek Basu <bibek.basu@stericsson.com>

Alternate function register address is actually 0x50 and thus
changed accordingly.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Bibek Basu <bibek.basu@stericsson.com>
Signed-off-by: Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
Tested-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/gpio/gpio-ab8500.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-ab8500.c b/drivers/gpio/gpio-ab8500.c
index c3c7c5a..b7d4416 100644
--- a/drivers/gpio/gpio-ab8500.c
+++ b/drivers/gpio/gpio-ab8500.c
@@ -60,7 +60,7 @@
 #define AB8500_GPIO_IN4_REG	0x43
 #define AB8500_GPIO_IN5_REG	0x44
 #define AB8500_GPIO_IN6_REG	0x45
-#define AB8500_GPIO_ALTFUN_REG	0x45
+#define AB8500_GPIO_ALTFUN_REG	0x50
 #define ALTFUN_REG_INDEX	6
 #define AB8500_NUM_GPIO		42
 #define AB8500_NUM_VIR_GPIO_IRQ	16
-- 
1.7.9.5

