Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab2HNI5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 04:57:39 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:50633 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755315Ab2HNI5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 04:57:37 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Patrice Chotard <patrice.chotard@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl/nomadik: add kp_b_2 keyboard function group list
Date: Tue, 14 Aug 2012 10:57:21 +0200
Message-ID: <1344934641-16043-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrice Chotard <patrice.chotard@stericsson.com>

There is yet another way to mux the keyboard, so fix up that
group.

Signed-off-by: Patrice Chotard <patrice.chotard@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik-db8500.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik-db8500.c b/drivers/pinctrl/pinctrl-nomadik-db8500.c
index 5f3e9d0..a39fb7a 100644
--- a/drivers/pinctrl/pinctrl-nomadik-db8500.c
+++ b/drivers/pinctrl/pinctrl-nomadik-db8500.c
@@ -505,6 +505,8 @@ static const unsigned kp_b_1_pins[] = { DB8500_PIN_F3, DB8500_PIN_F1,
 	DB8500_PIN_J3, DB8500_PIN_H2, DB8500_PIN_J2, DB8500_PIN_H1,
 	DB8500_PIN_F4, DB8500_PIN_E3, DB8500_PIN_E4, DB8500_PIN_D2,
 	DB8500_PIN_C1, DB8500_PIN_D3, DB8500_PIN_C2, DB8500_PIN_D5 };
+static const unsigned kp_b_2_pins[] = { DB8500_PIN_F3, DB8500_PIN_F1,
+	DB8500_PIN_G3, DB8500_PIN_G2, DB8500_PIN_F4, DB8500_PIN_E3};
 static const unsigned sm_b_1_pins[] = { DB8500_PIN_C6, DB8500_PIN_B3,
 	DB8500_PIN_C4, DB8500_PIN_E6, DB8500_PIN_A3, DB8500_PIN_B6,
 	DB8500_PIN_D6, DB8500_PIN_B7, DB8500_PIN_D7, DB8500_PIN_D8,
@@ -662,6 +664,7 @@ static const struct nmk_pingroup nmk_db8500_groups[] = {
 	DB8500_PIN_GROUP(spi3_b_1, NMK_GPIO_ALT_B),
 	DB8500_PIN_GROUP(msp1txrx_b_1, NMK_GPIO_ALT_B),
 	DB8500_PIN_GROUP(kp_b_1, NMK_GPIO_ALT_B),
+	DB8500_PIN_GROUP(kp_b_2, NMK_GPIO_ALT_B),
 	DB8500_PIN_GROUP(sm_b_1, NMK_GPIO_ALT_B),
 	DB8500_PIN_GROUP(smcs0_b_1, NMK_GPIO_ALT_B),
 	DB8500_PIN_GROUP(smcs1_b_1, NMK_GPIO_ALT_B),
@@ -751,7 +754,7 @@ DB8500_FUNC_GROUPS(msp1, "msp1txrx_a_1", "msp1_a_1", "msp1txrx_b_1");
 DB8500_FUNC_GROUPS(lcdb, "lcdb_a_1");
 DB8500_FUNC_GROUPS(lcd, "lcdvsi0_a_1", "lcdvsi1_a_1", "lcd_d0_d7_a_1",
 	"lcd_d8_d11_a_1", "lcd_d12_d23_a_1", "lcd_b_1");
-DB8500_FUNC_GROUPS(kp, "kp_a_1", "kp_b_1", "kp_c_1", "kp_oc1_1");
+DB8500_FUNC_GROUPS(kp, "kp_a_1", "kp_b_1", "kp_b_2", "kp_c_1", "kp_oc1_1");
 DB8500_FUNC_GROUPS(mc2, "mc2_a_1", "mc2rstn_c_1");
 DB8500_FUNC_GROUPS(ssp1, "ssp1_a_1");
 DB8500_FUNC_GROUPS(ssp0, "ssp0_a_1");
-- 
1.7.11.3

