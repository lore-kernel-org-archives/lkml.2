Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab1C0NWH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 09:22:07 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62533 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab1C0NWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 09:22:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=six+XrTwEGp/ets49zfLEpMkYEdc8C/gj/LhVScSQYnZgtRymCDFjLAlFzOSXQAas1
         cYqMKxFhOtkLHUgk1vD7hnSaK5+BIRWMsVGbxqMxP3RcUUcN7+a0aiY/3rqXmx8JJSQ1
         BIO3lH7xdUoQfVFydyDR/tTSbMynuutVFoJWY=
From: wanlong.gao@gmail.com
To: greg@kroah.com, harryxiyou@gmail.com
Cc: linux-kernel@vger.kernel.org, Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH] Fixed the format error for unnecessary spaces or required spaces.
Date: Sun, 27 Mar 2011 10:45:20 +0800
Message-Id: <1301193920-4515-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <wanlong.gao@gmail.com>

Better has no spaces at the start of a line
	FILE: ab3100-core.c:372

Better has no space before tabs
	FILE: adp5520.c:361

Space required after that ','
	FILE: dm355evm_msp.c:97

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 drivers/mfd/ab3100-core.c  |    2 +-
 drivers/mfd/adp5520.c      |    2 +-
 drivers/mfd/dm355evm_msp.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/ab3100-core.c b/drivers/mfd/ab3100-core.c
index 4193af5..010b358 100644
--- a/drivers/mfd/ab3100-core.c
+++ b/drivers/mfd/ab3100-core.c
@@ -369,7 +369,7 @@ EXPORT_SYMBOL(ab3100_event_register);
 int ab3100_event_unregister(struct ab3100 *ab3100,
 			    struct notifier_block *nb)
 {
-  return blocking_notifier_chain_unregister(&ab3100->event_subscribers,
+	return blocking_notifier_chain_unregister(&ab3100->event_subscribers,
 					    nb);
 }
 EXPORT_SYMBOL(ab3100_event_unregister);
diff --git a/drivers/mfd/adp5520.c b/drivers/mfd/adp5520.c
index 3122139..ccf6dc3 100644
--- a/drivers/mfd/adp5520.c
+++ b/drivers/mfd/adp5520.c
@@ -358,7 +358,7 @@ static struct i2c_driver adp5520_driver = {
 	.remove		= __devexit_p(adp5520_remove),
 	.suspend	= adp5520_suspend,
 	.resume		= adp5520_resume,
-	.id_table 	= adp5520_id,
+	.id_table	= adp5520_id,
 };
 
 static int __init adp5520_init(void)
diff --git a/drivers/mfd/dm355evm_msp.c b/drivers/mfd/dm355evm_msp.c
index 3d4a861..7ebe68b 100644
--- a/drivers/mfd/dm355evm_msp.c
+++ b/drivers/mfd/dm355evm_msp.c
@@ -94,7 +94,7 @@ EXPORT_SYMBOL(dm355evm_msp_read);
  * Many of the msp430 pins are just used as fixed-direction GPIOs.
  * We could export a few more of them this way, if we wanted.
  */
-#define MSP_GPIO(bit,reg)	((DM355EVM_MSP_ ## reg) << 3 | (bit))
+#define MSP_GPIO(bit, reg)	((DM355EVM_MSP_ ## reg) << 3 | (bit))
 
 static const u8 msp_gpios[] = {
 	/* eight leds */
-- 
1.7.3

