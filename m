Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab2A0Aqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 19:46:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57166 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab2A0Aqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 19:46:51 -0500
From: Manoj Iyer <manoj.iyer@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-bluetooth@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Subject: [PATCH] Bluetooth: Add support for BCM20702A0 [0a5c:21e1]
Date: Thu, 26 Jan 2012 18:46:39 -0600
Message-Id: <1327625199-10750-2-git-send-email-manoj.iyer@canonical.com>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1327625199-10750-1-git-send-email-manoj.iyer@canonical.com>
References: <1327625199-10750-1-git-send-email-manoj.iyer@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add vendor specific ID for BCM20702A0.

usb-devices:
T:  Bus=02 Lev=02 Prnt=02 Port=05 Cnt=01 Dev#=  4 Spd=12  MxCh= 0
D:  Ver= 2.00 Cls=ff(vend.) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0a5c ProdID=21e1 Rev=01.12
S:  Manufacturer=Broadcom Corp
S:  Product=BCM20702A0
S:  SerialNumber=60D819F03A6D
C:  #Ifs= 4 Cfg#= 1 Atr=e0 MxPwr=0mA
I:  If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
I:  If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
I:  If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#= 3 Alt= 0 #EPs= 0 Cls=fe(app. ) Sub=01 Prot=01 Driver=(none)

Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
---
 drivers/bluetooth/btusb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index f00f596..233b48d 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -101,6 +101,7 @@ static struct usb_device_id btusb_table[] = {
 	{ USB_DEVICE(0x0c10, 0x0000) },
 
 	/* Broadcom BCM20702A0 */
+	{ USB_DEVICE(0x0a5c, 0x21e1) },
 	{ USB_DEVICE(0x0a5c, 0x21e3) },
 	{ USB_DEVICE(0x413c, 0x8197) },
 
-- 
1.7.8.3

