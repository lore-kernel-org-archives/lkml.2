Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab2J0LBh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 07:01:37 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:55140 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab2J0LBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 07:01:35 -0400
From: Jeff Cook <jeff@deserettechnology.com>
To: linux-bluetooth@vger.kernel.org, marcel@holtmann.org, gustavo@padovan.org,
        johan.hedberg@gmail.com
Cc: linux-kernel@vger.kernel.org, Jeff Cook <jeff@deserettechnology.com>
Subject: [PATCH] Bluetooth: Add support for BCM20702A0 [0b05, 17b5]
Date: Sat, 27 Oct 2012 05:01:28 -0600
Message-Id: <1351335688-17936-1-git-send-email-jeff@deserettechnology.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <5087B517.9090703@deserettechnology.com>
References: <5087B517.9090703@deserettechnology.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vendor-specific ID for BCM20702A0.
Support for bluetooth over Asus Wi-Fi GO!, included with Asus P8Z77-V
Deluxe.

T:  Bus=07 Lev=02 Prnt=02 Port=00 Cnt=01 Dev#=  3 Spd=12  MxCh= 0
D:  Ver= 2.00 Cls=ff(vend.) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0b05 ProdID=17b5 Rev=01.12
S:  Manufacturer=Broadcom Corp
S:  Product=BCM20702A0
S:  SerialNumber=94DBC98AC113
C:  #Ifs= 4 Cfg#= 1 Atr=e0 MxPwr=0mA
I:  If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=01 Prot=01 Driver=(none)
I:  If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=01 Driver=(none)
I:  If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#= 3 Alt= 0 #EPs= 0 Cls=fe(app. ) Sub=01 Prot=01 Driver=(none)

Signed-off-by: Jeff Cook <jeff@deserettechnology.com>
---
 drivers/bluetooth/btusb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 654e248..1d7b126 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -96,6 +96,7 @@ static struct usb_device_id btusb_table[] = {
 	{ USB_DEVICE(0x0c10, 0x0000) },
 
 	/* Broadcom BCM20702A0 */
+	{ USB_DEVICE(0x0b05, 0x17b5) },
 	{ USB_DEVICE(0x0489, 0xe042) },
 	{ USB_DEVICE(0x413c, 0x8197) },
 
-- 
1.8.0

