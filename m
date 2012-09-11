Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084Ab2IKDY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 23:24:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44458 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab2IKDYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 23:24:25 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org, linus.walleij@linaro.org
Cc: devicetree-discuss@lists.ozlabs.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, sachin.kamat@linaro.org
Subject: [PATCH Resend] dt: Fix incorrect reference in gpio-led documentation
Date: Tue, 11 Sep 2012 08:51:23 +0530
Message-Id: <1347333683-17879-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Path to gpio.txt (dt) document was broken.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 Documentation/devicetree/bindings/gpio/led.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/devicetree/bindings/gpio/led.txt b/Documentation/devicetree/bindings/gpio/led.txt
index 9bb308a..edc83c1 100644
--- a/Documentation/devicetree/bindings/gpio/led.txt
+++ b/Documentation/devicetree/bindings/gpio/led.txt
@@ -8,7 +8,7 @@ node's name represents the name of the corresponding LED.
 
 LED sub-node properties:
 - gpios :  Should specify the LED's GPIO, see "gpios property" in
-  Documentation/devicetree/gpio.txt.  Active low LEDs should be
+  Documentation/devicetree/bindings/gpio/gpio.txt.  Active low LEDs should be
   indicated using flags in the GPIO specifier.
 - label :  (optional) The label for this LED.  If omitted, the label is
   taken from the node name (excluding the unit address).
-- 
1.7.4.1

