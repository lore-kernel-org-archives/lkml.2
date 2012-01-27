Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab2A0VK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 16:10:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:32851 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab2A0VK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 16:10:58 -0500
From: "James M. Leddy" <james.leddy@canonical.com>
To: linux-bluetooth@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        "James M. Leddy" <james.leddy@canonical.com>
Subject: [PATCH] Bluetooth: Add support for BCM20702A0 [0a5c:21e6]
Date: Fri, 27 Jan 2012 16:10:06 -0500
Message-Id: <1327698606-12503-1-git-send-email-james.leddy@canonical.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "James M. Leddy" <james.leddy@canonical.com>

Add another vendor specific ID for BCM20702A0. This has 
been tested and works on hardware with this device.

output of usb-devices:
T: Bus=01 Lev=02 Prnt=02 Port=03 Cnt=04 Dev#= 6 Spd=12 MxCh= 0
D: Ver= 2.00 Cls=ff(vend.) Sub=01 Prot=01 MxPS=64 #Cfgs= 1
P: Vendor=0a5c ProdID=21e6 Rev=01.12
S: Manufacturer=Broadcom Corp
S: Product=BCM20702A0
S: SerialNumber=D0DF9AFB227B
C: #Ifs= 4 Cfg#= 1 Atr=e0 MxPwr=0mA
I: If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=01 Prot=01 Driver=(none)
I: If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=01 Driver=(none)
I: If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I: If#= 3 Alt= 0 #EPs= 0 Cls=fe(app. ) Sub=01 Prot=01 Driver=(none)

Signed-off-by: James M. Leddy <james.leddy@canonical.com>
---
 drivers/bluetooth/btusb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index f00f596..e618cf1 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -102,6 +102,7 @@ static struct usb_device_id btusb_table[] = {
 
 	/* Broadcom BCM20702A0 */
 	{ USB_DEVICE(0x0a5c, 0x21e3) },
+	{ USB_DEVICE(0x0a5c, 0x21e6) },
 	{ USB_DEVICE(0x413c, 0x8197) },
 
 	{ }	/* Terminating entry */
-- 
1.7.5.4

