Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab2GAP4j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 11:56:39 -0400
Received: from nm34-vm3.bullet.mail.bf1.yahoo.com ([72.30.239.75]:44604 "HELO
	nm34-vm3.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751422Ab2GAP4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 11:56:38 -0400
X-Greylist: delayed 370 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Jul 2012 11:56:37 EDT
X-Yahoo-Newman-Id: 276814.50478.bm@smtp210.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 6j_G81UVM1m6.514mjY2cC_X33Lvjh4gmgmvqHXJs48qUYv
 hgpMpIFNcaynPn3AInp.99AXp9oKS2UxCv1pNnkq.trZ2J_OZw8HhoYklV0Q
 WR3v4FRfhEllHqQJNseMBBmfTro6JkSXnx5Lu9MlYFTOZzN4IgR3VUszi1PL
 4KNIM0ZrDTSmY9evhFvVqMRUx9PHG1CbEA9UMh_kErtq8CmG2cDdOBSI1ym2
 .Y3skbdI.3o2STv1gHgw9uus_BPY6WuyK36Okewu4Zys58BNfGtiOYZn5E6c
 .BcxigYA0pUS1NVIyGN5gxLvtnN7zBGMo6W7qRYugqj1TRWou8G6FC5Fe.se
 VlElVRnhh2IHL8ntQGzxYPuf9IYdiHeEGWYXizYD3hhM.5bDkq0cKqGboWAx
 1R5XOKtko2lCAc4zzl9CW1NWl.BUqNJXICRbnBfTKdnDc9Qtp3KCoRG3EzvH
 mxw--
X-Yahoo-SMTP: dNW5aIGswBCf1iV6QK8RWrBgWyjShXs-
From: Jeffrin Jose <ahiliation@yahoo.co.in>
To: oliver@neukum.name, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        ahiliation@yahoo.co.in
Subject: [PATCH]usb:class:Fixed coding style issue.
Date: Sun,  1 Jul 2012 21:25:16 +0530
Message-Id: <1341158116-3013-1-git-send-email-ahiliation@yahoo.co.in>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issue related to
prohibited space in drivers/usb/class/cdc-acm.c

Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>
---
 drivers/usb/class/cdc-acm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index b32ccb4..5ba556d 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -988,7 +988,7 @@ static int acm_probe(struct usb_interface *intf,
 		case USB_CDC_CALL_MANAGEMENT_TYPE:
 			call_management_function = buffer[3];
 			call_interface_num = buffer[4];
-			if ( (quirks & NOT_A_MODEM) == 0 && (call_management_function & 3) != 3)
+			if ((quirks & NOT_A_MODEM) == 0 && (call_management_function & 3) != 3)
 				dev_err(&intf->dev, "This device cannot do calls on its own. It is not a modem.\n");
 			break;
 		default:
-- 
1.7.10

