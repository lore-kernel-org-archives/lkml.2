Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933331Ab2GCTEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 15:04:44 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:41993 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750803Ab2GCTEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 15:04:43 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Patrice Chotard <patrice.chotard@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl/nomadik: add pin group to mco function
Date: Tue, 3 Jul 2012 21:04:26 +0200
Message-ID: <1341342266-4240-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrice Chotard <patrice.chotard@stericsson.com>

mc0_dat47_a_1 and mc0dat31dir_a_1 groups are missing for mco function

Signed-off-by: Patrice Chotard <patrice.chotard@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik-db8500.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik-db8500.c b/drivers/pinctrl/pinctrl-nomadik-db8500.c
index 42c4b77..9817493 100644
--- a/drivers/pinctrl/pinctrl-nomadik-db8500.c
+++ b/drivers/pinctrl/pinctrl-nomadik-db8500.c
@@ -616,6 +616,8 @@ static const struct nmk_pingroup nmk_db8500_groups[] = {
 	DB8500_PIN_GROUP(msp0tfstck_a_1, NMK_GPIO_ALT_A),
 	DB8500_PIN_GROUP(msp0rfsrck_a_1, NMK_GPIO_ALT_A),
 	DB8500_PIN_GROUP(mc0_a_1, NMK_GPIO_ALT_A),
+	DB8500_PIN_GROUP(mc0_dat47_a_1, NMK_GPIO_ALT_A),
+	DB8500_PIN_GROUP(mc0dat31dir_a_1, NMK_GPIO_ALT_A),
 	DB8500_PIN_GROUP(msp1txrx_a_1, NMK_GPIO_ALT_A),
 	DB8500_PIN_GROUP(msp1_a_1, NMK_GPIO_ALT_A),
 	DB8500_PIN_GROUP(lcdb_a_1, NMK_GPIO_ALT_A),
@@ -740,7 +742,7 @@ DB8500_FUNC_GROUPS(ipi2c, "ipi2c_a_1", "ipi2c_a_2");
  */
 DB8500_FUNC_GROUPS(msp0, "msp0txrx_a_1", "msp0tfstck_a_1", "msp0rfstck_a_1",
 		   "msp0txrx_b_1", "msp0sck_b_1");
-DB8500_FUNC_GROUPS(mc0, "mc0_a_1");
+DB8500_FUNC_GROUPS(mc0, "mc0_a_1", "mc0_dat47_a_1", "mc0dat31dir_a_1");
 /* MSP0 can swap RX/TX like MSP0 but has no SCK pin available */
 DB8500_FUNC_GROUPS(msp1, "msp1txrx_a_1", "msp1_a_1", "msp1txrx_b_1");
 DB8500_FUNC_GROUPS(lcdb, "lcdb_a_1");
-- 
1.7.9.2

