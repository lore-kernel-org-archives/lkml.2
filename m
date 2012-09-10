Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab2IJIbn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 04:31:43 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:36737 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751594Ab2IJIbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 04:31:41 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Patrice Chotard <patrice.chotard@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl/nomadik : add MC1_a_2 pin MC1 function group list
Date: Mon, 10 Sep 2012 10:31:14 +0200
Message-ID: <1347265874-3342-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrice Chotard <patrice.chotard@stericsson.com>

Another possible pin configuration for the MC1 pin group.

Signed-off-by: Patrice Chotard <patrice.chotard@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik-db8500.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik-db8500.c b/drivers/pinctrl/pinctrl-nomadik-db8500.c
index a39fb7a..ec6209d 100644
--- a/drivers/pinctrl/pinctrl-nomadik-db8500.c
+++ b/drivers/pinctrl/pinctrl-nomadik-db8500.c
@@ -465,6 +465,8 @@ static const unsigned mc4_a_1_pins[] = { DB8500_PIN_AH24, DB8500_PIN_AG25,
 static const unsigned mc1_a_1_pins[] = { DB8500_PIN_AH16, DB8500_PIN_AG15,
 	DB8500_PIN_AJ15, DB8500_PIN_AG14, DB8500_PIN_AF13, DB8500_PIN_AG13,
 	DB8500_PIN_AH15 };
+static const unsigned mc1_a_2_pins[] = { DB8500_PIN_AH16, DB8500_PIN_AJ15,
+	DB8500_PIN_AG14, DB8500_PIN_AF13, DB8500_PIN_AG13,DB8500_PIN_AH15 };
 static const unsigned mc1dir_a_1_pins[] = { DB8500_PIN_AH13, DB8500_PIN_AG12,
 	DB8500_PIN_AH12, DB8500_PIN_AH11 };
 static const unsigned hsir_a_1_pins[] = { DB8500_PIN_AG10, DB8500_PIN_AH10,
@@ -641,6 +643,7 @@ static const struct nmk_pingroup nmk_db8500_groups[] = {
 	DB8500_PIN_GROUP(msp2_a_1, NMK_GPIO_ALT_A),
 	DB8500_PIN_GROUP(mc4_a_1, NMK_GPIO_ALT_A),
 	DB8500_PIN_GROUP(mc1_a_1, NMK_GPIO_ALT_A),
+	DB8500_PIN_GROUP(mc1_a_2, NMK_GPIO_ALT_A),
 	DB8500_PIN_GROUP(hsir_a_1, NMK_GPIO_ALT_A),
 	DB8500_PIN_GROUP(hsit_a_1, NMK_GPIO_ALT_A),
 	DB8500_PIN_GROUP(hsit_a_2, NMK_GPIO_ALT_A),
@@ -768,7 +771,7 @@ DB8500_FUNC_GROUPS(ipgpio, "ipgpio0_a_1", "ipgpio1_a_1", "ipgpio7_b_1",
 /* MSP2 can not invert the RX/TX pins but has the optional SCK pin */
 DB8500_FUNC_GROUPS(msp2, "msp2sck_a_1", "msp2_a_1");
 DB8500_FUNC_GROUPS(mc4, "mc4_a_1", "mc4rstn_c_1");
-DB8500_FUNC_GROUPS(mc1, "mc1_a_1", "mc1dir_a_1");
+DB8500_FUNC_GROUPS(mc1, "mc1_a_1", "mc1_a_2", "mc1dir_a_1");
 DB8500_FUNC_GROUPS(hsi, "hsir_a_1", "hsit_a_1", "hsit_a_2");
 DB8500_FUNC_GROUPS(clkout, "clkout_a_1", "clkout_a_2", "clkout_c_1");
 DB8500_FUNC_GROUPS(usb, "usb_a_1");
-- 
1.7.11.3

