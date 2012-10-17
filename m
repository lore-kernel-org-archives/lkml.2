Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab2JQPCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 11:02:49 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38193 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757317Ab2JQPCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 11:02:47 -0400
From: Sangho Yi <antiroot@gmail.com>
To: broonie@opensource.wolfsonmicro.com, cbow@mail.ru, dwmw2@inradead.org
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 3/3] power: wm831x_power.c: Fixed indentation bug and whitespace errors
Date: Thu, 18 Oct 2012 00:01:16 +0900
Message-Id: <1350486076-3784-3-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350486076-3784-1-git-send-email-antiroot@gmail.com>
References: <n>
 <1350486076-3784-1-git-send-email-antiroot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I removed trailing whitespaces and removed unnecessary whitespaces and
indentation tabs.

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/power/wm831x_power.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/power/wm831x_power.c b/drivers/power/wm831x_power.c
index 1afca43..ff8316e 100644
--- a/drivers/power/wm831x_power.c
+++ b/drivers/power/wm831x_power.c
@@ -632,9 +632,8 @@ static __devexit int wm831x_power_remove(struct platform_device *pdev)
 	int irq, i;
 
 	for (i = 0; i < ARRAY_SIZE(wm831x_bat_irqs); i++) {
-		irq = wm831x_irq(wm831x, 
-				 platform_get_irq_byname(pdev,
-							 wm831x_bat_irqs[i]));
+		irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev,
+			wm831x_bat_irqs[i]));
 		free_irq(irq, wm831x_power);
 	}
 
-- 
1.7.9.5

