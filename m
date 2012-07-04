Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933565Ab2GDJ1L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 05:27:11 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:51806 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755850Ab2GDJ1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 05:27:07 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl/nomadik: kerneldoc fix
Date: Wed, 4 Jul 2012 11:26:42 +0200
Message-ID: <1341394002-10393-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Document a missing function parameter to nmk_config_pin().

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 095bbc6..e2a2dd1 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -434,7 +434,7 @@ static int __nmk_config_pins(pin_cfg_t *cfgs, int num, bool sleep)
 /**
  * nmk_config_pin - configure a pin's mux attributes
  * @cfg: pin confguration
- *
+ * @sleep: Non-zero to apply the sleep mode configuration
  * Configures a pin's mode (alternate function or GPIO), its pull up status,
  * and its sleep mode based on the specified configuration.  The @cfg is
  * usually one of the SoC specific macros defined in mach/<soc>-pins.h.  These
-- 
1.7.9.2

