Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab2IRRAQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 13:00:16 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:48607 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab2IRRAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 13:00:14 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: nsekhar@ti.com
Cc: khilman@ti.com, linux@arm.linux.org.uk,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH v2] arch/arm/mach-davinci/board-dm646x-evm.c: Remove unecessary semicolon
Date: Tue, 18 Sep 2012 18:59:59 +0200
Message-Id: <1347987599-30802-1-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found by http://coccinelle.lip6.fr/

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 arch/arm/mach-davinci/board-dm646x-evm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
index 958679a..1ccaace 100644
--- a/arch/arm/mach-davinci/board-dm646x-evm.c
+++ b/arch/arm/mach-davinci/board-dm646x-evm.c
@@ -193,7 +193,7 @@ static int evm_led_setup(struct i2c_client *client, int gpio,
 	while (ngpio--) {
 		leds->gpio = gpio++;
 		leds++;
-	};
+	}
 
 	evm_led_dev = platform_device_alloc("leds-gpio", 0);
 	platform_device_add_data(evm_led_dev, &evm_led_data,
-- 
1.7.11.4

