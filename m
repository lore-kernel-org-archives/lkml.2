Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964844Ab2JLIki (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 04:40:38 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:59208 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933255Ab2JLIkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 04:40:35 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl/nomadik: update other alternate-C functions on DB8500
Date: Fri, 12 Oct 2012 10:40:08 +0200
Message-ID: <1350031208-3616-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>

In pinctrl-nomadik-db8500.c, add missing definitions that deal
with other alternate-C functions.

Signed-off-by: Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik-db8500.c | 101 +++++++++++++++++++++++++++++--
 1 file changed, 96 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik-db8500.c b/drivers/pinctrl/pinctrl-nomadik-db8500.c
index debaa75b..ef6f26d 100644
--- a/drivers/pinctrl/pinctrl-nomadik-db8500.c
+++ b/drivers/pinctrl/pinctrl-nomadik-db8500.c
@@ -600,14 +600,66 @@ static const unsigned usbsim_c_2_pins[] = { DB8500_PIN_AF8 };
 static const unsigned i2c3_c_2_pins[] = { DB8500_PIN_AG7, DB8500_PIN_AF7 };
 
 /* Other C1 column */
+static const unsigned u2rx_oc1_1_pins[] = { DB8500_PIN_AB2 };
+static const unsigned stmape_oc1_1_pins[] = { DB8500_PIN_AA4, DB8500_PIN_Y4,
+	DB8500_PIN_Y2, DB8500_PIN_AA2, DB8500_PIN_AA1 };
+static const unsigned remap0_oc1_1_pins[] = { DB8500_PIN_E1 };
+static const unsigned remap1_oc1_1_pins[] = { DB8500_PIN_E2 };
+static const unsigned ptma9_oc1_1_pins[] = { DB8500_PIN_G5, DB8500_PIN_G4,
+	DB8500_PIN_H4, DB8500_PIN_H3, DB8500_PIN_J3, DB8500_PIN_H2,
+	DB8500_PIN_J2, DB8500_PIN_H1 };
 static const unsigned kp_oc1_1_pins[] = { DB8500_PIN_C6, DB8500_PIN_B3,
 	DB8500_PIN_C4, DB8500_PIN_E6, DB8500_PIN_A3, DB8500_PIN_B6,
 	DB8500_PIN_D6, DB8500_PIN_B7 };
+static const unsigned rf_oc1_1_pins[] = { DB8500_PIN_D8, DB8500_PIN_D9 };
+static const unsigned hxclk_oc1_1_pins[] = { DB8500_PIN_D16 };
+static const unsigned uartmodrx_oc1_1_pins[] = { DB8500_PIN_B17 };
+static const unsigned uartmodtx_oc1_1_pins[] = { DB8500_PIN_C16 };
+static const unsigned stmmod_oc1_1_pins[] = { DB8500_PIN_C19, DB8500_PIN_C17,
+	DB8500_PIN_A18, DB8500_PIN_C18, DB8500_PIN_B19 };
+static const unsigned hxgpio_oc1_1_pins[] = { DB8500_PIN_D21, DB8500_PIN_D20,
+	DB8500_PIN_C20, DB8500_PIN_B21, DB8500_PIN_C21, DB8500_PIN_A22,
+	DB8500_PIN_B24, DB8500_PIN_C22 };
+static const unsigned rf_oc1_2_pins[] = { DB8500_PIN_C23, DB8500_PIN_D23 };
 static const unsigned spi2_oc1_1_pins[] = { DB8500_PIN_AH13, DB8500_PIN_AG12,
 	DB8500_PIN_AH12, DB8500_PIN_AH11 };
 static const unsigned spi2_oc1_2_pins[] = { DB8500_PIN_AH13, DB8500_PIN_AH12,
 	DB8500_PIN_AH11 };
 
+/* Other C2 column */
+static const unsigned sbag_oc2_1_pins[] = { DB8500_PIN_AA4, DB8500_PIN_AB2,
+	DB8500_PIN_Y4, DB8500_PIN_Y2, DB8500_PIN_AA2, DB8500_PIN_AA1 };
+static const unsigned etmr4_oc2_1_pins[] = { DB8500_PIN_G5, DB8500_PIN_G4,
+	DB8500_PIN_H4, DB8500_PIN_H3, DB8500_PIN_J3, DB8500_PIN_H2,
+	DB8500_PIN_J2, DB8500_PIN_H1 };
+static const unsigned ptma9_oc2_1_pins[] = { DB8500_PIN_D17, DB8500_PIN_D16,
+	DB8500_PIN_B17, DB8500_PIN_C16, DB8500_PIN_C19, DB8500_PIN_C17,
+	DB8500_PIN_A18, DB8500_PIN_C18, DB8500_PIN_B19, DB8500_PIN_B20,
+	DB8500_PIN_D21, DB8500_PIN_D20,	DB8500_PIN_C20, DB8500_PIN_B21,
+	DB8500_PIN_C21, DB8500_PIN_A22, DB8500_PIN_B24, DB8500_PIN_C22 };
+
+/* Other C3 column */
+static const unsigned stmmod_oc3_1_pins[] = { DB8500_PIN_AB2, DB8500_PIN_W2,
+	DB8500_PIN_W3, DB8500_PIN_V3, DB8500_PIN_V2 };
+static const unsigned stmmod_oc3_2_pins[] = { DB8500_PIN_G5, DB8500_PIN_G4,
+	DB8500_PIN_H4, DB8500_PIN_H3, DB8500_PIN_J3 };
+static const unsigned uartmodrx_oc3_1_pins[] = { DB8500_PIN_H2 };
+static const unsigned uartmodtx_oc3_1_pins[] = { DB8500_PIN_J2 };
+static const unsigned etmr4_oc3_1_pins[] = { DB8500_PIN_D17, DB8500_PIN_D16,
+	DB8500_PIN_B17, DB8500_PIN_C16, DB8500_PIN_C19, DB8500_PIN_C17,
+	DB8500_PIN_A18, DB8500_PIN_C18, DB8500_PIN_B19, DB8500_PIN_B20,
+	DB8500_PIN_D21, DB8500_PIN_D20,	DB8500_PIN_C20, DB8500_PIN_B21,
+	DB8500_PIN_C21, DB8500_PIN_A22, DB8500_PIN_B24, DB8500_PIN_C22 };
+
+/* Other C4 column */
+static const unsigned sbag_oc4_1_pins[] = { DB8500_PIN_G5, DB8500_PIN_G4,
+	DB8500_PIN_H4, DB8500_PIN_H3, DB8500_PIN_J3, DB8500_PIN_H1 };
+static const unsigned hwobs_oc4_1_pins[] = { DB8500_PIN_D17, DB8500_PIN_D16,
+	DB8500_PIN_B17, DB8500_PIN_C16, DB8500_PIN_C19, DB8500_PIN_C17,
+	DB8500_PIN_A18, DB8500_PIN_C18, DB8500_PIN_B19, DB8500_PIN_B20,
+	DB8500_PIN_D21, DB8500_PIN_D20,	DB8500_PIN_C20, DB8500_PIN_B21,
+	DB8500_PIN_C21, DB8500_PIN_A22, DB8500_PIN_B24, DB8500_PIN_C22 };
+
 #define DB8500_PIN_GROUP(a,b) { .name = #a, .pins = a##_pins,		\
 			.npins = ARRAY_SIZE(a##_pins), .altsetting = b }
 
@@ -726,9 +778,34 @@ static const struct nmk_pingroup nmk_db8500_groups[] = {
 	DB8500_PIN_GROUP(usbsim_c_2, NMK_GPIO_ALT_C),
 	DB8500_PIN_GROUP(i2c3_c_2, NMK_GPIO_ALT_C),
 	/* Other alt C1 column */
+	DB8500_PIN_GROUP(u2rx_oc1_1, NMK_GPIO_ALT_C1),
+	DB8500_PIN_GROUP(stmape_oc1_1, NMK_GPIO_ALT_C1),
+	DB8500_PIN_GROUP(remap0_oc1_1, NMK_GPIO_ALT_C1),
+	DB8500_PIN_GROUP(remap1_oc1_1, NMK_GPIO_ALT_C1),
+	DB8500_PIN_GROUP(ptma9_oc1_1, NMK_GPIO_ALT_C1),
 	DB8500_PIN_GROUP(kp_oc1_1, NMK_GPIO_ALT_C1),
+	DB8500_PIN_GROUP(rf_oc1_1, NMK_GPIO_ALT_C1),
+	DB8500_PIN_GROUP(hxclk_oc1_1, NMK_GPIO_ALT_C1),
+	DB8500_PIN_GROUP(uartmodrx_oc1_1, NMK_GPIO_ALT_C1),
+	DB8500_PIN_GROUP(uartmodtx_oc1_1, NMK_GPIO_ALT_C1),
+	DB8500_PIN_GROUP(stmmod_oc1_1, NMK_GPIO_ALT_C1),
+	DB8500_PIN_GROUP(hxgpio_oc1_1, NMK_GPIO_ALT_C1),
+	DB8500_PIN_GROUP(rf_oc1_2, NMK_GPIO_ALT_C1),
 	DB8500_PIN_GROUP(spi2_oc1_1, NMK_GPIO_ALT_C1),
 	DB8500_PIN_GROUP(spi2_oc1_2, NMK_GPIO_ALT_C1),
+	/* Other alt C2 column */
+	DB8500_PIN_GROUP(sbag_oc2_1, NMK_GPIO_ALT_C2),
+	DB8500_PIN_GROUP(etmr4_oc2_1, NMK_GPIO_ALT_C2),
+	DB8500_PIN_GROUP(ptma9_oc2_1, NMK_GPIO_ALT_C2),
+	/* Other alt C3 column */
+	DB8500_PIN_GROUP(stmmod_oc3_1, NMK_GPIO_ALT_C3),
+	DB8500_PIN_GROUP(stmmod_oc3_2, NMK_GPIO_ALT_C3),
+	DB8500_PIN_GROUP(uartmodrx_oc3_1, NMK_GPIO_ALT_C3),
+	DB8500_PIN_GROUP(uartmodtx_oc3_1, NMK_GPIO_ALT_C3),
+	DB8500_PIN_GROUP(etmr4_oc3_1, NMK_GPIO_ALT_C3),
+	/* Other alt C4 column */
+	DB8500_PIN_GROUP(sbag_oc4_1, NMK_GPIO_ALT_C4),
+	DB8500_PIN_GROUP(hwobs_oc4_1, NMK_GPIO_ALT_C4),
 };
 
 /* We use this macro to define the groups applicable to a function */
@@ -742,7 +819,7 @@ DB8500_FUNC_GROUPS(u1, "u1rxtx_a_1", "u1ctsrts_a_1");
  * only available on two pins in alternative function C
  */
 DB8500_FUNC_GROUPS(u2, "u2rxtx_b_1", "u2rxtx_c_1", "u2ctsrts_c_1",
-		   "u2rxtx_c_2", "u2rxtx_c_3");
+		   "u2rxtx_c_2", "u2rxtx_c_3", "u2rx_oc1_1");
 DB8500_FUNC_GROUPS(ipi2c, "ipi2c_a_1", "ipi2c_a_2");
 /*
  * MSP0 can only be on a certain set of pins, but the TX/RX pins can be
@@ -784,8 +861,10 @@ DB8500_FUNC_GROUPS(i2c2, "i2c2_b_1", "i2c2_b_2");
  * so select one of each.
  */
 DB8500_FUNC_GROUPS(uartmod, "uartmodtx_b_1", "uartmodrx_b_1", "uartmodrx_b_2",
-		   "uartmodrx_c_1", "uartmod_tx_c_1");
-DB8500_FUNC_GROUPS(stmmod, "stmmod_b_1", "stmmod_c_1");
+		"uartmodrx_c_1", "uartmod_tx_c_1", "uartmodrx_oc1_1",
+		"uartmodtx_oc1_1", "uartmodrx_oc3_1", "uartmodtx_oc3_1");
+DB8500_FUNC_GROUPS(stmmod, "stmmod_b_1", "stmmod_c_1", "stmmod_oc1_1",
+		"stmmod_oc3_1", "stmmod_oc3_2");
 DB8500_FUNC_GROUPS(spi3, "spi3_b_1");
 /* Select between CS0 on alt B or PS1 on alt C */
 DB8500_FUNC_GROUPS(sm, "sm_b_1", "smcs0_b_1", "smcs1_b_1", "smcleale_c_1",
@@ -799,13 +878,19 @@ DB8500_FUNC_GROUPS(ipjtag, "ipjtag_c_1");
 DB8500_FUNC_GROUPS(slim0, "slim0_c_1");
 DB8500_FUNC_GROUPS(ms, "ms_c_1");
 DB8500_FUNC_GROUPS(iptrigout, "iptrigout_c_1");
-DB8500_FUNC_GROUPS(stmape, "stmape_c_1", "stmape_c_2");
+DB8500_FUNC_GROUPS(stmape, "stmape_c_1", "stmape_c_2", "stmape_oc1_1");
 DB8500_FUNC_GROUPS(mc5, "mc5_c_1");
 DB8500_FUNC_GROUPS(usbsim, "usbsim_c_1", "usbsim_c_2");
 DB8500_FUNC_GROUPS(i2c3, "i2c3_c_1", "i2c3_c_2");
 DB8500_FUNC_GROUPS(spi0, "spi0_c_1");
 DB8500_FUNC_GROUPS(spi2, "spi2_oc1_1", "spi2_oc1_2");
-
+DB8500_FUNC_GROUPS(remap, "remap0_oc1_1", "remap1_oc1_1");
+DB8500_FUNC_GROUPS(sbag, "sbag_oc2_1", "sbag_oc4_1");
+DB8500_FUNC_GROUPS(ptm, "ptma9_oc1_1", "ptma9_oc2_1");
+DB8500_FUNC_GROUPS(rf, "rf_oc1_1", "rf_oc1_2");
+DB8500_FUNC_GROUPS(hx, "hxclk_oc1_1", "hxgpio_oc1_1");
+DB8500_FUNC_GROUPS(etm, "etmr4_oc2_1", "etmr4_oc3_1");
+DB8500_FUNC_GROUPS(hwobs, "hwobs_oc4_1");
 #define FUNCTION(fname)					\
 	{						\
 		.name = #fname,				\
@@ -858,6 +943,12 @@ static const struct nmk_function nmk_db8500_functions[] = {
 	FUNCTION(i2c3),
 	FUNCTION(spi0),
 	FUNCTION(spi2),
+	FUNCTION(remap),
+	FUNCTION(ptm),
+	FUNCTION(rf),
+	FUNCTION(hx),
+	FUNCTION(etm),
+	FUNCTION(hwobs),
 };
 
 static const struct prcm_gpiocr_altcx_pin_desc db8500_altcx_pins[] = {
-- 
1.7.11.3

