Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab2IWN12 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 09:27:28 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61713 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab2IWN1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 09:27:25 -0400
Date: Sun, 23 Sep 2012 09:30:12 -0400
From: "Maxin B. John" <maxin.john@gmail.com>
To: Peter Korsgaard <jacmet@sunsite.dk>,
        "Jean Delvare (PC drivers,core)" <khali@linux-fr.org>
Cc: "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 1/2] i2c: busses: i2c-ocores: Fix documentation filename
Message-ID: <20120923133012.GA22830@linux-3ix0.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the wrong filename.

Signed-off-by: Maxin B. John <maxin.john@gmail.com>
---
diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
index bffd550..e39c122 100644
--- a/drivers/i2c/busses/i2c-ocores.c
+++ b/drivers/i2c/busses/i2c-ocores.c
@@ -11,7 +11,7 @@
 
 /*
  * This driver can be used from the device tree, see
- *     Documentation/devicetree/bindings/i2c/ocore-i2c.txt
+ *     Documentation/devicetree/bindings/i2c/i2c-ocores.txt
  */
 #include <linux/kernel.h>
 #include <linux/module.h>
