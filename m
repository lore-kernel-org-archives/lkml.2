Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751231Ab1KOFgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 00:36:35 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:45579 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab1KOFge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 00:36:34 -0500
From: Rajendra Nayak <rnayak@ti.com>
To: <linus.walleij@stericsson.com>, <rdunlap@xenotime.net>
CC: <linux-kernel@vger.kernel.org>, <linaro-dev@lists.linaro.org>,
        Rajendra Nayak <rnayak@ti.com>
Subject: [PATCH] Documentation: Fix minor typos in pinctrl.txt
Date: Tue, 15 Nov 2011 11:06:18 +0530
Message-ID: <1321335378-29064-1-git-send-email-rnayak@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some minor typos in the pinctrl documentation.

Signed-off-by: Rajendra Nayak <rnayak@ti.com>
---
 Documentation/pinctrl.txt |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index b04cb7d..c849a09 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -91,7 +91,7 @@ int __init foo_probe(void)
 Pins usually have fancier names than this. You can find these in the dataheet
 for your chip. Notice that the core pinctrl.h file provides a fancy macro
 called PINCTRL_PIN() to create the struct entries. As you can see I enumerated
-the pins from 0 in the upper left corner to 63 in the lower right corner,
+the pins from 0 in the lower left corner to 63 in the upper right corner,
 this enumeration was arbitrarily chosen, in practice you need to think
 through your numbering system so that it matches the layout of registers
 and such things in your driver, or the code may become complicated. You must
@@ -218,7 +218,7 @@ static struct pinctrl_gpio_range gpio_range_a = {
 	.gc = &chip_a;
 };
 
-static struct pinctrl_gpio_range gpio_range_a = {
+static struct pinctrl_gpio_range gpio_range_b = {
 	.name = "chip b",
 	.id = 0,
 	.base = 48,
@@ -762,42 +762,42 @@ case), we define a mapping like this:
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
1.7.1

