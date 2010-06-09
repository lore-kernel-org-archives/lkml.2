Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194Ab0FISrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 14:47:18 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:60525 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758141Ab0FISrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 14:47:14 -0400
Date: Wed, 9 Jun 2010 20:22:03 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Duncan Sands <duncan.sands@free.fr>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] speedtouch: fixed brace and spacing coding style issues
Message-ID: <20100609202203.66ab0192@absol.kitzblitz>
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

Fixed brace coding style issues.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/usb/atm/speedtch.c |    4 +++-
 drivers/usb/atm/usbatm.c   |    9 +++------
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/atm/speedtch.c b/drivers/usb/atm/speedtch.c
index 1335456..50c44b2 100644
--- a/drivers/usb/atm/speedtch.c
+++ b/drivers/usb/atm/speedtch.c
@@ -753,7 +753,9 @@ static struct usb_driver speedtch_usb_driver = {
 	.id_table	= speedtch_usb_ids
 };
 
-static void speedtch_release_interfaces(struct usb_device *usb_dev, int num_interfaces) {
+static void speedtch_release_interfaces(struct usb_device *usb_dev,
+					int num_interfaces)
+{
 	struct usb_interface *cur_intf;
 	int i;
 
diff --git a/drivers/usb/atm/usbatm.c b/drivers/usb/atm/usbatm.c
index 9b53e8d..a67166e 100644
--- a/drivers/usb/atm/usbatm.c
+++ b/drivers/usb/atm/usbatm.c
@@ -273,8 +273,7 @@ static void usbatm_complete(struct urb *urb)
 
 	if (unlikely(status) &&
 			(!(channel->usbatm->flags & UDSL_IGNORE_EILSEQ) ||
-			 status != -EILSEQ ))
-	{
+			 status != -EILSEQ )) {
 		if (status == -ESHUTDOWN)
 			return;
 
@@ -516,8 +515,7 @@ static unsigned int usbatm_write_cells(struct usbatm_data *instance,
 			target[3] |= 0x2;	/* adjust PTI */
 
 			ctrl->len = 0;		/* tag this skb finished */
-		}
-		else
+		} else
 			ctrl->crc = crc32_be(ctrl->crc, ptr, left);
 	}
 
@@ -1390,9 +1388,8 @@ static int usbatm_print_packet(const unsigned char *data, int len)
 	for (i = 0; i < len;) {
 		buffer[0] = '\0';
 		sprintf(buffer, "%.3d :", i);
-		for (j = 0; (j < 16) && (i < len); j++, i++) {
+		for (j = 0; (j < 16) && (i < len); j++, i++)
 			sprintf(buffer, "%s %2.2x", buffer, data[i]);
-		}
 		dbg("%s", buffer);
 	}
 	return i;
-- 
1.6.4.4

