Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab2GCJpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 05:45:33 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:43384 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755867Ab2GCJp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 05:45:27 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Patrice Chotard <patrice.chotard@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/3] pinctrl/nomadik: fix hsir_a_1_pins pin list
Date: Tue, 3 Jul 2012 11:22:57 +0200
Message-ID: <1341307377-28789-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrice Chotard <patrice.chotard@stericsson.com>

move DB8500_PIN_AJ11(HSIR_RDY0_a) from hsit_a_1_pins to hsir_a_1_pins

Signed-off-by: Patrice Chotard <patrice.chotard@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik-db8500.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik-db8500.c b/drivers/pinctrl/pinctrl-nomadik-db8500.c
index 8b20222..4f2a82c 100644
--- a/drivers/pinctrl/pinctrl-nomadik-db8500.c
+++ b/drivers/pinctrl/pinctrl-nomadik-db8500.c
@@ -467,9 +467,10 @@ static const unsigned mc1_a_1_pins[] = { DB8500_PIN_AH16, DB8500_PIN_AG15,
 	DB8500_PIN_AH15 };
 static const unsigned mc1dir_a_1_pins[] = { DB8500_PIN_AH13, DB8500_PIN_AG12,
 	DB8500_PIN_AH12, DB8500_PIN_AH11 };
-static const unsigned hsir_a_1_pins[] = { DB8500_PIN_AG10, DB8500_PIN_AH10 };
-static const unsigned hsit_a_1_pins[] = { DB8500_PIN_AJ11, DB8500_PIN_AJ9,
-	DB8500_PIN_AH9, DB8500_PIN_AG9, DB8500_PIN_AG8, DB8500_PIN_AF8 };
+static const unsigned hsir_a_1_pins[] = { DB8500_PIN_AG10, DB8500_PIN_AH10,
+	DB8500_PIN_AJ11 };
+static const unsigned hsit_a_1_pins[] = { DB8500_PIN_AJ9, DB8500_PIN_AH9,
+	DB8500_PIN_AG9, DB8500_PIN_AG8, DB8500_PIN_AF8 };
 static const unsigned clkout_a_1_pins[] = { DB8500_PIN_AH7, DB8500_PIN_AJ6 };
 static const unsigned clkout_a_2_pins[] = { DB8500_PIN_AG7, DB8500_PIN_AF7 };
 static const unsigned usb_a_1_pins[] = { DB8500_PIN_AF28, DB8500_PIN_AE29,
-- 
1.7.9.2

