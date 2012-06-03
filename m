Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab2FCMOq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 08:14:46 -0400
Received: from nm11-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.136]:22330 "HELO
	nm11-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750934Ab2FCMOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 08:14:45 -0400
X-Greylist: delayed 413 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Jun 2012 08:14:45 EDT
X-Yahoo-Newman-Id: 991099.13231.bm@smtp217.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: uusTrJ0VM1midnHTYZAtI8oeCuDLDRBeNGIdfTp7CiXPL6B
 RabONgVXuPKPkjTR65joJvWfLdxnWgp5sP9S9OJROQiMvfCLDoPR1vHwUDBS
 .tw885NunTL4295Y8.86MsVzIcce7gPxJnvIcdhsZLVGDHevll8F.kUEsRPw
 t23yQyDJE.2OkY5SCqsIobgTNHuIfFYFzuJJjfXzYCtwT2MsV4In1bymlFxd
 bRumkOA4mQZLNgKfkLIFbd8gN7kureZuqR53LxzHTcMqKRpG5kmvXnbgh0S.
 GHFLSUtg5rpTWCY3zJf8Pq2OSvbl0e_IUeYrudoqRUCx9DTUD6H2K0ULU1_k
 u.RksVgD_GmpPFABS8dqebROPtQiMabW0yaF1MI2C3tpy5XHxksdJqVSkBw0
 fbFRhZXsppYVIaS6iRMux_RElAjUNIZGy7doxnA8w.mKgN.dkZSSN8y8cE6F
 KZyW2FMqb7uN3ZK5L4vlsFtXvMkFMfYKtuhlueALzHMVl1w3dcRcFeBu.XCF
 n9AIgeot03GdH6XingfMd_QNz2w--
X-Yahoo-SMTP: dNW5aIGswBCf1iV6QK8RWrBgWyjShXs-
From: Jeffrin Jose <ahiliation@yahoo.co.in>
To: bryan.wu@canonical.com, rpurdie@rpsys.net
Cc: linux-kernel@vger.kernel.org, ahiliation@yahoo.co.in
Subject: [PATCH]drivers:leds:fixed a coding style issue.
Date: Sun,  3 Jun 2012 17:41:52 +0530
Message-Id: <1338725513-3156-1-git-send-email-ahiliation@yahoo.co.in>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue relating to trailing
white space error found by checkpatch.pl tool in drivers/leds/led-class.c

Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>
---
 drivers/leds/led-class.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 8ee92c8..e663e6f 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -29,7 +29,7 @@ static void led_update_brightness(struct led_classdev *led_cdev)
 		led_cdev->brightness = led_cdev->brightness_get(led_cdev);
 }
 
-static ssize_t led_brightness_show(struct device *dev, 
+static ssize_t led_brightness_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-- 
1.7.10

