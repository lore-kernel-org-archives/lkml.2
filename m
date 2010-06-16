Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510Ab0FPROz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 13:14:55 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:47550 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755510Ab0FPROx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 13:14:53 -0400
Date: Wed, 16 Jun 2010 18:56:05 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Simon Arlott <cxacru@fire.lp0.eu>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       accessrunner-general@lists.sourceforge.net, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] usb: conexant: fixed spacing and brace coding style issues
Message-ID: <20100616185605.00ce6f31@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed spacing and brace coding style issues.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/usb/atm/cxacru.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index c89990f..191e8ae 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -564,7 +564,7 @@ static void cxacru_timeout_kill(unsigned long data)
 }
 
 static int cxacru_start_wait_urb(struct urb *urb, struct completion *done,
-				 int* actual_length)
+				 int *actual_length)
 {
 	struct timer_list timer;
 
@@ -952,7 +952,7 @@ static int cxacru_fw(struct usb_device *usb_dev, enum cxacru_fw_request fw,
 		put_unaligned(cpu_to_le32(addr), (__le32 *)(buf + offb));
 		offb += 4;
 		addr += l;
-		if(l)
+		if (l)
 			memcpy(buf + offb, data + offd, l);
 		if (l < stride)
 			memset(buf + offb + l, 0, stride - l);
@@ -967,7 +967,7 @@ static int cxacru_fw(struct usb_device *usb_dev, enum cxacru_fw_request fw,
 			}
 			offb = 0;
 		}
-	} while(offd < size);
+	} while (offd < size);
 	dbg("sent fw %#x", fw);
 
 	ret = 0;
@@ -1043,8 +1043,7 @@ static void cxacru_upload_firmware(struct cxacru_data *instance,
 	if (instance->modem_type->boot_rom_patch) {
 		val = cpu_to_le32(BR_ADDR);
 		ret = cxacru_fw(usb_dev, FW_WRITE_MEM, 0x2, 0x0, BR_STACK_ADDR, (u8 *) &val, 4);
-	}
-	else {
+	} else {
 		ret = cxacru_fw(usb_dev, FW_GOTO_MEM, 0x0, 0x0, FW_ADDR, NULL, 0);
 	}
 	if (ret) {
@@ -1068,7 +1067,7 @@ static void cxacru_upload_firmware(struct cxacru_data *instance,
 }
 
 static int cxacru_find_firmware(struct cxacru_data *instance,
-				char* phase, const struct firmware **fw_p)
+				char *phase, const struct firmware **fw_p)
 {
 	struct usbatm_data *usbatm = instance->usbatm;
 	struct device *dev = &usbatm->usb_intf->dev;
-- 
1.6.4.4

