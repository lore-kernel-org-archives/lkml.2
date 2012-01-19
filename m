Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073Ab2ASVfQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 16:35:16 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48380 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab2ASVfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 16:35:12 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] Documentation/pinctrl: fix a few syntax errors in code examples
Date: Thu, 19 Jan 2012 22:35:05 +0100
Message-Id: <1327008905-20544-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1323383765-30742-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1323383765-30742-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

this is what's left from the patch I sent in the mail with message-id
1323383765-30742-1-git-send-email-u.kleine-koenig@pengutronix.de after
rebasing to current linus/master. The original submission got an ack by
Stephen Warren that I assumed for this patch, too.

Best regards
Uwe

 Documentation/pinctrl.txt |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index 6727b92..5324d31 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -857,42 +857,41 @@ case), we define a mapping like this:
 
 ...
 {
-	.name "2bit"
+	.name = "2bit"
 	.ctrl_dev_name = "pinctrl-foo",
 	.function = "mmc0",
 	.group = "mmc0_1_grp",
 	.dev_name = "foo-mmc.0",
 },
 {
-	.name "4bit"
+	.name = "4bit"
 	.ctrl_dev_name = "pinctrl-foo",
 	.function = "mmc0",
 	.group = "mmc0_1_grp",
 	.dev_name = "foo-mmc.0",
 },
 {
-	.name "4bit"
+	.name = "4bit"
 	.ctrl_dev_name = "pinctrl-foo",
 	.function = "mmc0",
 	.group = "mmc0_2_grp",
 	.dev_name = "foo-mmc.0",
 },
 {
-	.name "8bit"
+	.name = "8bit"
 	.ctrl_dev_name = "pinctrl-foo",
-	.function = "mmc0",
 	.group = "mmc0_1_grp",
 	.dev_name = "foo-mmc.0",
 },
 {
-	.name "8bit"
+	.name = "8bit"
 	.ctrl_dev_name = "pinctrl-foo",
 	.function = "mmc0",
 	.group = "mmc0_2_grp",
 	.dev_name = "foo-mmc.0",
 },
 {
-	.name "8bit"
+	.name = "8bit"
 	.ctrl_dev_name = "pinctrl-foo",
 	.function = "mmc0",
 	.group = "mmc0_3_grp",
@@ -995,7 +994,7 @@ This is enabled by simply setting the .hog_on_boot field in the map to true,
 like this:
 
 {
-	.name "POWERMAP"
+	.name = "POWERMAP"
 	.ctrl_dev_name = "pinctrl-foo",
 	.function = "power_func",
 	.hog_on_boot = true,
-- 
1.7.8.3

