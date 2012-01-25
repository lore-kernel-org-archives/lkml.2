Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515Ab2AYO1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 09:27:12 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:37378
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750833Ab2AYO1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 09:27:12 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: rpurdie@rpsys.net
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] leds: Fix typo in leds-lp5521.c
Date: Wed, 25 Jan 2012 23:26:27 +0900
Message-Id: <1327501587-9791-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Crrect spelling "reseting" to "resetting" in
drivers/leds/leds-lp5521.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/leds/leds-lp5521.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index d62a798..c42c8f0 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -694,7 +694,7 @@ static int __devinit lp5521_probe(struct i2c_client *client,
 	 */
 	lp5521_read(client, LP5521_REG_R_CURRENT, &buf);
 	if (buf != LP5521_REG_R_CURR_DEFAULT) {
-		dev_err(&client->dev, "error in reseting chip\n");
+		dev_err(&client->dev, "error in resetting chip\n");
 		goto fail2;
 	}
 	usleep_range(10000, 20000);
-- 
1.7.6.5

