Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068Ab2EHVlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 17:41:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50460 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660Ab2EHVlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 17:41:22 -0400
From: NeilBrown <neilb@suse.de>
To: Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
Date: Wed, 09 May 2012 07:40:39 +1000
Subject: [PATCH 1/4] power_supply: twl4030_charger: Fix some typos
Cc: Grazvydas Ignotas <notasas@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        NeilBrown <neilb@suse.de>
Message-ID: <20120508214039.2844.70581.stgit@notabene.brown>
In-Reply-To: <20120508213518.2844.95446.stgit@notabene.brown>
References: <20120508213518.2844.95446.stgit@notabene.brown>
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
 


