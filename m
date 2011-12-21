Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab1LUAUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 19:20:42 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50458 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753758Ab1LUAUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 19:20:38 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant@secretlab.ca>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/4] gpio: Fix typo in comment in Samsung driver
Date: Wed, 21 Dec 2011 00:20:15 +0000
Message-Id: <1324426817-2196-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1324426817-2196-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1324426817-2196-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
---
 drivers/gpio/gpio-samsung.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
index f1c1ecd..f44c020 100644
--- a/drivers/gpio/gpio-samsung.c
+++ b/drivers/gpio/gpio-samsung.c
@@ -233,7 +233,7 @@ static int samsung_gpio_setcfg_2bit(struct samsung_gpio_chip *chip,
  * @chip: The gpio chip that is being configured.
  * @off: The offset for the GPIO being configured.
  *
- * The reverse of samsung_gpio_setcfg_2bit(). Will return a value whicg
+ * The reverse of samsung_gpio_setcfg_2bit(). Will return a value which
  * could be directly passed back to samsung_gpio_setcfg_2bit(), from the
  * S3C_GPIO_SPECIAL() macro.
  */
-- 
1.7.7.3

