Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab1G1ORB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 10:17:01 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36231 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab1G1OQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 10:16:59 -0400
Subject: [PATCH RESEND] gpio: ab8500: fix MODULE_ALIAS for ab8500
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: BIBEK BASU <bibek.basu@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jul 2011 22:16:49 +0800
Message-ID: <1311862609.2419.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf (platform: prefix MODALIAS
with "platform:"), the platform modalias is prefixed with "platform:".

This patch changes the MODULE_ALIAS to "platform:ab8500-gpio".

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/gpio-ab8500.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-ab8500.c b/drivers/gpio/gpio-ab8500.c
index ed795e6..050c05d 100644
--- a/drivers/gpio/gpio-ab8500.c
+++ b/drivers/gpio/gpio-ab8500.c
@@ -516,5 +516,5 @@ module_exit(ab8500_gpio_exit);
 
 MODULE_AUTHOR("BIBEK BASU <bibek.basu@stericsson.com>");
 MODULE_DESCRIPTION("Driver allows to use AB8500 unused pins to be used as GPIO");
-MODULE_ALIAS("AB8500 GPIO driver");
+MODULE_ALIAS("platform:ab8500-gpio");
 MODULE_LICENSE("GPL v2");
-- 
1.7.4.1



