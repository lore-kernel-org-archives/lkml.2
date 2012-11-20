Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab2KTMF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 07:05:58 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47416 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616Ab2KTMFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 07:05:55 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Tero Kristo <t-kristo@ti.com>, Grazvydas Ignotas <notasas@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pwm: pwm-twl-led: Correct comment for cycle configuration
Date: Tue, 20 Nov 2012 13:05:48 +0100
Message-ID: <1353413148-5319-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original commit was not documenting correctly the behavior of the cycle
configuration.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---

Hi Thierry,

small update to the new pwm-twl-led driver to correct the comment describing the
cycle configuration for the PWMA/B of TWL4030.
The update is on top of v3 of the twl pwm series:
https://lkml.org/lkml/2012/11/20/193

Regards,
Peter

 drivers/pwm/pwm-twl-led.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-twl-led.c b/drivers/pwm/pwm-twl-led.c
index 9468720..e62b95e 100644
--- a/drivers/pwm/pwm-twl-led.c
+++ b/drivers/pwm/pwm-twl-led.c
@@ -73,8 +73,8 @@ static int twl4030_pwmled_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	 * 0 -> off cycle = 2,
 	 * 1 -> off cycle = 2,
 	 * 2 -> off cycle = 3,
-	 * 125 - > off cycle 127,
-	 * 126 - > off cycle 1
+	 * 126 - > off cycle 127,
+	 * 127 - > off cycle 1
 	 * When on cycle == off cycle the PWM will be always on
 	 */
 	duty_cycle += 1;
-- 
1.8.0

