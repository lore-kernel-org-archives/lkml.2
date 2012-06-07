Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933460Ab2FGEX0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:23:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62777 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933426Ab2FGEXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:23:22 -0400
Message-Id: <20120607041400.354109232@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:14:13 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Wen-chien Jesse Sung <jesse.sung@canonical.com>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Jonathan Nieder <jrnieder@gmail.com>
Subject: [ 15/47] Bluetooth: Add support for Broadcom BCM20702A0
In-Reply-To: <20120607041504.GA13819@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wen-chien Jesse Sung <jesse.sung@canonical.com>

commit d13431ca3eb2a2c14314f04813cdc11cd869f150 upstream.

Since this device declares itself as vendor specific, must add
a new entry to device ID table to support it.

usb-device output of this device:

T:  Bus=01 Lev=02 Prnt=02 Port=03 Cnt=01 Dev#=  3 Spd=12  MxCh= 0
D:  Ver= 2.00 Cls=ff(vend.) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=413c ProdID=8197 Rev=01.12
S:  Manufacturer=Broadcom Corp
S:  Product=BCM20702A0
S:  SerialNumber=D0DF9AA9C9F1
C:  #Ifs= 4 Cfg#= 1 Atr=e0 MxPwr=0mA
I:  If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=01 Prot=01 Driver=(none)
I:  If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=01 Driver=(none)
I:  If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#= 3 Alt= 0 #EPs= 0 Cls=fe(app. ) Sub=01 Prot=01 Driver=(none)

Signed-off-by: Wen-chien Jesse Sung <jesse.sung@canonical.com>
Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
Cc: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bluetooth/btusb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -100,6 +100,9 @@ static struct usb_device_id btusb_table[
 	/* Canyon CN-BTU1 with HID interfaces */
 	{ USB_DEVICE(0x0c10, 0x0000) },
 
+	/* Broadcom BCM20702A0 */
+	{ USB_DEVICE(0x413c, 0x8197) },
+
 	{ }	/* Terminating entry */
 };
 


