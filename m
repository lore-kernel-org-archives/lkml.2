Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab1KQIut (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 03:50:49 -0500
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:48711 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751709Ab1KQIus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 03:50:48 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, Stephen Warren <swarren@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Barry Song <21cnbao@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl: misc documentation fixups
Date: Thu, 17 Nov 2011 09:50:21 +0100
Message-ID: <1321519821-25022-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This fixes up some various confusions in the pinctrl
documentation.

Reported-by: Rajendra Nayak <rnayak@ti.com>
Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 Documentation/pinctrl.txt |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index ea50804..348a59d 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -59,13 +59,13 @@ this in our driver:
 #include <linux/pinctrl/pinctrl.h>
 
 const struct pinctrl_pin_desc foo_pins[] = {
-      PINCTRL_PIN(0, "A1"),
-      PINCTRL_PIN(1, "A2"),
-      PINCTRL_PIN(2, "A3"),
+      PINCTRL_PIN(0, "A8"),
+      PINCTRL_PIN(1, "B8"),
+      PINCTRL_PIN(2, "C8"),
       ...
-      PINCTRL_PIN(61, "H6"),
-      PINCTRL_PIN(62, "H7"),
-      PINCTRL_PIN(63, "H8"),
+      PINCTRL_PIN(61, "F1"),
+      PINCTRL_PIN(62, "G1"),
+      PINCTRL_PIN(63, "H1"),
 };
 
 static struct pinctrl_desc foo_desc = {
@@ -90,11 +90,11 @@ selected drivers, you need to select them from your machine's Kconfig entry,
 since these are so tightly integrated with the machines they are used on.
 See for example arch/arm/mach-u300/Kconfig for an example.
 
-Pins usually have fancier names than this. You can find these in the dataheet
+Pins usually have fancier names than this. You can find these in the datasheet
 for your chip. Notice that the core pinctrl.h file provides a fancy macro
 called PINCTRL_PIN() to create the struct entries. As you can see I enumerated
-the pins from 0 in the upper left corner to 63 in the lower right corner,
-this enumeration was arbitrarily chosen, in practice you need to think
+the pins from 0 in the upper left corner to 63 in the lower right corner.
+This enumeration was arbitrarily chosen, in practice you need to think
 through your numbering system so that it matches the layout of registers
 and such things in your driver, or the code may become complicated. You must
 also consider matching of offsets to the GPIO ranges that may be handled by
@@ -842,42 +842,42 @@ case), we define a mapping like this:
 	.name "2bit"
 	.ctrl_dev_name = "pinctrl.0",
 	.function = "mmc0",
-	.group = "mmc0_0_grp",
+	.group = "mmc0_1_grp",
 	.dev_name = "foo-mmc.0",
 },
 {
 	.name "4bit"
 	.ctrl_dev_name = "pinctrl.0",
 	.function = "mmc0",
-	.group = "mmc0_0_grp",
+	.group = "mmc0_1_grp",
 	.dev_name = "foo-mmc.0",
 },
 {
 	.name "4bit"
 	.ctrl_dev_name = "pinctrl.0",
 	.function = "mmc0",
-	.group = "mmc0_1_grp",
+	.group = "mmc0_2_grp",
 	.dev_name = "foo-mmc.0",
 },
 {
 	.name "8bit"
 	.ctrl_dev_name = "pinctrl.0",
 	.function = "mmc0",
-	.group = "mmc0_0_grp",
+	.group = "mmc0_1_grp",
 	.dev_name = "foo-mmc.0",
 },
 {
 	.name "8bit"
 	.ctrl_dev_name = "pinctrl.0",
 	.function = "mmc0",
-	.group = "mmc0_1_grp",
+	.group = "mmc0_2_grp",
 	.dev_name = "foo-mmc.0",
 },
 {
 	.name "8bit"
 	.ctrl_dev_name = "pinctrl.0",
 	.function = "mmc0",
-	.group = "mmc0_2_grp",
+	.group = "mmc0_3_grp",
 	.dev_name = "foo-mmc.0",
 },
 ...
-- 
1.7.3.2

