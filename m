Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965142Ab2LFKwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 05:52:21 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:36546 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965097Ab2LFKwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 05:52:14 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: [PATCH v2 3/3] gpio: twl4030: TODO comment to remove the PWMA/B (LEDA/B) handling
Date: Thu, 6 Dec 2012 11:52:07 +0100
Message-ID: <1354791127-20545-4-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1354791127-20545-1-git-send-email-peter.ujfalusi@ti.com>
References: <1354791127-20545-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This GPIO driver should not configure anything else then GPIOs.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/gpio/gpio-twl4030.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpio/gpio-twl4030.c b/drivers/gpio/gpio-twl4030.c
index a38e6e9c..1e9f08c4 100644
--- a/drivers/gpio/gpio-twl4030.c
+++ b/drivers/gpio/gpio-twl4030.c
@@ -47,6 +47,7 @@
  * intended to support multiple hosts.
  *
  * There are also two LED pins used sometimes as output-only GPIOs.
+ * TODO: Handling of PWMA/B (LEDA/B) should be removed from this GPIO driver!
  */
 
 /* genirq interfaces are not available to modules */
@@ -131,6 +132,7 @@ static inline int gpio_twl4030_read(u8 address)
 
 /*----------------------------------------------------------------------*/
 
+/* TODO: Handling of PWMA/B (LEDA/B) should be removed from this GPIO driver! */
 static u8 cached_leden;
 
 /* The LED lines are open drain outputs ... a FET pulls to GND, so an
-- 
1.8.0

