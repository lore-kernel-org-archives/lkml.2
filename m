Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab2HQFpJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 01:45:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50538 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab2HQFo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 01:44:57 -0400
From: Daniel J Blueman <daniel@quora.org>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>,
        Daniel J Blueman <daniel@quora.org>
Subject: [PATCH v3] Add device ID for Bluetooth on Macbook Pro 2012
Date: Fri, 17 Aug 2012 13:44:46 +0800
Message-Id: <1345182286-21776-1-git-send-email-daniel@quora.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the device ID for supporting the Macbook Pro 2012 'MacBookPro10,1'.
The bluetooth device presents itself as:

T:  Bus=02 Lev=04 Prnt=04 Port=02 Cnt=03 Dev#=  8 Spd=12  MxCh= 0
D:  Ver= 2.00 Cls=ff(vend.) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=05ac ProdID=8286 Rev=00.86
S:  Manufacturer=Apple Inc.
S:  Product=Bluetooth USB Host Controller
C:  #Ifs= 4 Cfg#= 1 Atr=e0 MxPwr=0mA
I:  If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=01 Prot=01 Driver=(none)
I:  If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=(none)
I:  If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#= 3 Alt= 0 #EPs= 0 Cls=fe(app. ) Sub=01 Prot=01 Driver=(none)

Patch originally written and tested by clipcarl (forums.opensuse.org).

Signed-off-by: Daniel J Blueman <daniel@quora.org>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/bluetooth/btusb.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index e272214..61f4eb7 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -76,6 +76,9 @@ static struct usb_device_id btusb_table[] = {
 	/* Apple MacMini5,1 */
 	{ USB_DEVICE(0x05ac, 0x8281) },
 
+	/* Apple MacBookPro10,1 */
+	{ USB_DEVICE(0x05ac, 0x8286) },
+
 	/* AVM BlueFRITZ! USB v2.0 */
 	{ USB_DEVICE(0x057c, 0x3800) },
 
-- 
1.7.10.4

