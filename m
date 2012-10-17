Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab2JQPCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 11:02:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42050 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757272Ab2JQPCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 11:02:40 -0400
From: Sangho Yi <antiroot@gmail.com>
To: broonie@opensource.wolfsonmicro.com, cbow@mail.ru, dwmw2@inradead.org
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 1/3] power: wm831x_power: Fixed indentation errors
Date: Thu, 18 Oct 2012 00:01:14 +0900
Message-Id: <1350486076-3784-1-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed the following indentation errors (a couple of errors were on the
wm831x_power.c)
WARNING: suspect code indent for conditional statements

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/power/wm831x_power.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/power/wm831x_power.c b/drivers/power/wm831x_power.c
index fc1ad95..833841b 100644
--- a/drivers/power/wm831x_power.c
+++ b/drivers/power/wm831x_power.c
@@ -555,14 +555,14 @@ static __devinit int wm831x_power_probe(struct platform_device *pdev)
 	power->have_battery = ret & WM831X_CHG_ENA;
 
 	if (power->have_battery) {
-		    battery->name = power->battery_name;
-		    battery->properties = wm831x_bat_props;
-		    battery->num_properties = ARRAY_SIZE(wm831x_bat_props);
-		    battery->get_property = wm831x_bat_get_prop;
-		    battery->use_for_apm = 1;
-		    ret = power_supply_register(&pdev->dev, battery);
-		    if (ret)
-			    goto err_usb;
+		battery->name = power->battery_name;
+		battery->properties = wm831x_bat_props;
+		battery->num_properties = ARRAY_SIZE(wm831x_bat_props);
+		battery->get_property = wm831x_bat_get_prop;
+		battery->use_for_apm = 1;
+		ret = power_supply_register(&pdev->dev, battery);
+		if (ret)
+			goto err_usb;
 	}
 
 	irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "SYSLO"));
-- 
1.7.9.5

