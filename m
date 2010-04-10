Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407Ab0DJHET (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 03:04:19 -0400
Received: from smtprelay-h12.telenor.se ([62.127.194.5]:40750 "EHLO
	smtprelay-h12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab0DJHER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 03:04:17 -0400
X-SENDER-IP: [83.226.251.151]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhM4ADfAv0tT4vuXPGdsb2JhbACHZZNdDAEBAQE1LapljWWFCgQ
X-IronPort-AV: E=Sophos;i="4.52,181,1270418400"; 
   d="scan'208";a="61850655"
From: Lars Lindley <lindley@coyote.org>
To: gregkh@suse.de, alan@linux.intel.com, o.hartmann@telovital.com,
       tj@kernel.org, cl@linux-foundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Lars Lindley <lindley@coyote.org>
Subject: [PATCH] staging: et131x: et1310_eeprom.c coding style fixes.
Date: Sat, 10 Apr 2010 09:04:02 +0200
Message-Id: <1270883042-16632-1-git-send-email-lindley@coyote.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed indentation in one place and two long lines.

Signed-off-by: Lars Lindley <lindley@coyote.org>
---
 drivers/staging/et131x/et1310_eeprom.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/et131x/et1310_eeprom.c b/drivers/staging/et131x/et1310_eeprom.c
index e4d095b..5a8e6b9 100644
--- a/drivers/staging/et131x/et1310_eeprom.c
+++ b/drivers/staging/et131x/et1310_eeprom.c
@@ -302,7 +302,7 @@ static int eeprom_read(struct et131x_adapter *etdev, u32 addr, u8 *pdata)
 	err = eeprom_wait_ready(pdev, NULL);
 	if (err)
 		return err;
- 	/*
+	/*
 	 * Write to the LBCIF Control Register:  bit 7=1, bit 6=0, bit 3=0,
 	 * and bits 1:0 both =0.  Bit 5 should be set according to the type
 	 * of EEPROM being accessed (1=two byte addressing, 0=one byte
@@ -383,9 +383,9 @@ int et131x_init_eeprom(struct et131x_adapter *etdev)
 
 			/* This error could mean that there was an error
 			 * reading the eeprom or that the eeprom doesn't exist.
-			 * We will treat each case the same and not try to gather
-			 * additional information that normally would come from the
-			 * eeprom, like MAC Address
+			 * We will treat each case the same and not try to
+			 * gather additional information that normally would
+			 * come from the eeprom, like MAC Address
 			 */
 			etdev->has_eeprom = 0;
 			return -EIO;
-- 
1.7.0.4

