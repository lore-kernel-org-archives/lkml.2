Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab2DYHeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 03:34:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58707 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479Ab2DYHe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 03:34:27 -0400
From: NeilBrown <neilb@suse.de>
To: Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Grazvydas Ignotas <notasas@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Wed, 25 Apr 2012 17:33:10 +1000
Subject: [PATCH 1/6] twl4030_charger: Fix some typos
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, NeilBrown <neilb@suse.de>
Message-ID: <20120425073310.20124.1097.stgit@notabene.brown>
In-Reply-To: <20120425072931.20124.56635.stgit@notabene.brown>
References: <20120425072931.20124.56635.stgit@notabene.brown>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by:  NeilBrown <neilb@suse.de>
---

 drivers/power/twl4030_charger.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/power/twl4030_charger.c b/drivers/power/twl4030_charger.c
index fdad850..3e6e991 100644
--- a/drivers/power/twl4030_charger.c
+++ b/drivers/power/twl4030_charger.c
@@ -103,7 +103,7 @@ static int twl4030_bci_read(u8 reg, u8 *val)
 
 static int twl4030_clear_set_boot_bci(u8 clear, u8 set)
 {
-	return twl4030_clear_set(TWL4030_MODULE_PM_MASTER, 0,
+	return twl4030_clear_set(TWL4030_MODULE_PM_MASTER, clear,
 			TWL4030_CONFIG_DONE | TWL4030_BCIAUTOWEN | set,
 			TWL4030_PM_MASTER_BOOT_BCI);
 }
@@ -151,14 +151,14 @@ static int twl4030_bci_have_vbus(struct twl4030_bci *bci)
 }
 
 /*
- * Enable/Disable USB Charge funtionality.
+ * Enable/Disable USB Charge functionality.
  */
 static int twl4030_charger_enable_usb(struct twl4030_bci *bci, bool enable)
 {
 	int ret;
 
 	if (enable) {
-		/* Check for USB charger conneted */
+		/* Check for USB charger connected */
 		if (!twl4030_bci_have_vbus(bci))
 			return -ENODEV;
 


