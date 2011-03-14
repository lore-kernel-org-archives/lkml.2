Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688Ab1CNUMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 16:12:42 -0400
Received: from s15407518.onlinehome-server.info ([82.165.136.167]:49689 "EHLO
	s15407518.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751959Ab1CNUMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 16:12:41 -0400
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Vasily Khoruzhick <anarsoul@gmail.com>, linux-kernel@vger.kernel.org,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] s3c_adc_battery: Fix method names when PM not set
Date: Mon, 14 Mar 2011 21:12:39 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-2-686; KDE/4.4.5; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201103142112.39392.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Stuebner <heiko@sntech.de>

s3c_adc_battery declares wrong method names when CONFIG_PM is not set.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>

---
 drivers/power/s3c_adc_battery.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/s3c_adc_battery.c b/drivers/power/s3c_adc_battery.c
index 4255f23..d36c289 100644
--- a/drivers/power/s3c_adc_battery.c
+++ b/drivers/power/s3c_adc_battery.c
@@ -406,8 +406,8 @@ static int s3c_adc_bat_resume(struct platform_device *pdev)
 	return 0;
 }
 #else
-#define s3c_adc_battery_suspend NULL
-#define s3c_adc_battery_resume NULL
+#define s3c_adc_bat_suspend NULL
+#define s3c_adc_bat_resume NULL
 #endif
 
 static struct platform_driver s3c_adc_bat_driver = {
-- 
tg: (2fbfac4..) topic/fixes/s3c_adc_battery_nopm (depends on: master)
