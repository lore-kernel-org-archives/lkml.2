Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759231Ab2HITC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 15:02:28 -0400
Received: from svenfoo.org ([82.94.215.22]:58147 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759203Ab2HITC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 15:02:26 -0400
From: Daniel Mack <zonque@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, broonie@opensource.wolfsonmicro.com,
        swarren@wwwdotorg.org, Daniel Mack <zonque@gmail.com>
Subject: [PATCH] Documentation/pinctrl.txt: Fix some misspelled macros
Date: Thu,  9 Aug 2012 21:02:19 +0200
Message-Id: <1344538939-15903-1-git-send-email-zonque@gmail.com>
X-Mailer: git-send-email 1.7.11.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Mack <zonque@gmail.com>
---
 Documentation/pinctrl.txt | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index e40f4b4..1479aca 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -840,9 +840,9 @@ static unsigned long i2c_pin_configs[] = {
 
 static struct pinctrl_map __initdata mapping[] = {
 	PIN_MAP_MUX_GROUP("foo-i2c.0", PINCTRL_STATE_DEFAULT, "pinctrl-foo", "i2c0", "i2c0"),
-	PIN_MAP_MUX_CONFIGS_GROUP("foo-i2c.0", PINCTRL_STATE_DEFAULT, "pinctrl-foo", "i2c0", i2c_grp_configs),
-	PIN_MAP_MUX_CONFIGS_PIN("foo-i2c.0", PINCTRL_STATE_DEFAULT, "pinctrl-foo", "i2c0scl", i2c_pin_configs),
-	PIN_MAP_MUX_CONFIGS_PIN("foo-i2c.0", PINCTRL_STATE_DEFAULT, "pinctrl-foo", "i2c0sda", i2c_pin_configs),
+	PIN_MAP_CONFIGS_GROUP("foo-i2c.0", PINCTRL_STATE_DEFAULT, "pinctrl-foo", "i2c0", i2c_grp_configs),
+	PIN_MAP_CONFIGS_PIN("foo-i2c.0", PINCTRL_STATE_DEFAULT, "pinctrl-foo", "i2c0scl", i2c_pin_configs),
+	PIN_MAP_CONFIGS_PIN("foo-i2c.0", PINCTRL_STATE_DEFAULT, "pinctrl-foo", "i2c0sda", i2c_pin_configs),
 };
 
 Finally, some devices expect the mapping table to contain certain specific
-- 
1.7.11.2

