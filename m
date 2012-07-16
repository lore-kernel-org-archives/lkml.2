Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab2GPIgy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 04:36:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54301 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab2GPIgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 04:36:51 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        marek.belisko@gmail.com
Cc: Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH] staging/cptm1217: fix checkpatch warnings
Date: Mon, 16 Jul 2012 17:36:41 +0900
Message-Id: <1342427801-8972-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1342426322-7809-1-git-send-email-yamanetoshi@gmail.com>
References: <1342426322-7809-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below checkpatch warn, error, and typo was fixed,

drivers/staging/cptm1217/clearpad_tm1217.c:400: WARNING: quoted string split across lines
drivers/staging/cptm1217/cp_tm1217.h:5: ERROR: open brace '{' following struct go on the same line

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/cptm1217/clearpad_tm1217.c |    4 ++--
 drivers/staging/cptm1217/cp_tm1217.h       |    3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/cptm1217/clearpad_tm1217.c b/drivers/staging/cptm1217/clearpad_tm1217.c
index 5456f82..b154042 100644
--- a/drivers/staging/cptm1217/clearpad_tm1217.c
+++ b/drivers/staging/cptm1217/clearpad_tm1217.c
@@ -396,8 +396,8 @@ static int cp_tm1217_setup_gpio_irq(struct cp_tm1217_device *ts)
 
 	retval = gpio_to_irq(ts->gpio);
 	if (retval < 0) {
-		dev_err(ts->dev, "cp_tm1217: GPIO to IRQ failedi,"
-		" error %d\n", retval);
+		dev_err(ts->dev, "cp_tm1217: GPIO to IRQ failed, error %d\n",
+			retval);
 		gpio_free(ts->gpio);
 	}
 	dev_dbg(ts->dev,
diff --git a/drivers/staging/cptm1217/cp_tm1217.h b/drivers/staging/cptm1217/cp_tm1217.h
index a0ce31d..30bad35 100644
--- a/drivers/staging/cptm1217/cp_tm1217.h
+++ b/drivers/staging/cptm1217/cp_tm1217.h
@@ -1,8 +1,7 @@
 #ifndef __LINUX_I2C_CP_TM1217_H
 #define __LINUX_I2C_CP_TM1217_H
 
-struct cp_tm1217_platform_data
-{
+struct cp_tm1217_platform_data {
 	int gpio;		/* If not set uses the IRQ resource 0 */
 };
 
-- 
1.7.5.4

