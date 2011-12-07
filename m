Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934031Ab1LGQbw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:31:52 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39725 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757735Ab1LGQZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:25:07 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/4] gpio: Fix typo in comment in Samsung driver
Date: Thu,  8 Dec 2011 00:23:59 +0800
Message-Id: <1323275041-25493-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323275041-25493-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20111207162256.GI22355@opensource.wolfsonmicro.com>
 <1323275041-25493-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
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

