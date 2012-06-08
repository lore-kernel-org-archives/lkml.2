Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761907Ab2FHFTr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:19:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43319 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761428Ab2FHFHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:24 -0400
Message-Id: <20120608041848.199949472@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:35 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?= 
	<jprvita@openbossa.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Johan Hedberg <johan.hedberg@intel.com>
Subject: [ 55/82] Bluetooth: btusb: Add USB device ID "0a5c 21e8"
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: João Paulo Rechi Vita <jprvita@openbossa.org>

commit 6dfc326f0605fd87e4c10ccde10de0ce4280d72d upstream.

One more vendor-specific ID for BCM20702A0.

T:  Bus=01 Lev=03 Prnt=05 Port=02 Cnt=01 Dev#=  9 Spd=12  MxCh= 0
D:  Ver= 2.00 Cls=ff(vend.) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0a5c ProdID=21e8 Rev=01.12
S:  Manufacturer=Broadcom Corp
S:  Product=BCM20702A0
S:  SerialNumber=00027221F4E2
C:  #Ifs= 4 Cfg#= 1 Atr=e0 MxPwr=0mA
I:  If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=01 Prot=01 Driver=(none)
I:  If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=01 Driver=(none)
I:  If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#= 3 Alt= 0 #EPs= 0 Cls=fe(app. ) Sub=01 Prot=01 Driver=(none)

Signed-off-by: João Paulo Rechi Vita <jprvita@openbossa.org>
Acked-by: Gustavo F. Padovan <padovan@profusion.mobi>
Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/bluetooth/btusb.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 480cad9..b633854 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -103,6 +103,7 @@ static struct usb_device_id btusb_table[] = {
 	/* Broadcom BCM20702A0 */
 	{ USB_DEVICE(0x0a5c, 0x21e3) },
 	{ USB_DEVICE(0x0a5c, 0x21e6) },
+	{ USB_DEVICE(0x0a5c, 0x21e8) },
 	{ USB_DEVICE(0x0a5c, 0x21f3) },
 	{ USB_DEVICE(0x413c, 0x8197) },
 


