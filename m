Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761951Ab2FHFUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:20:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43291 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760048Ab2FHFHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:23 -0400
Message-Id: <20120608041848.860487170@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:40 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Steven Harms <sjharms@gmail.com>,
        Gustavo Padovan <gustavo@padovan.org>
Subject: [ 60/82] Add Foxconn / Hon Hai IDs for btusb module
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Harms <sjharms@gmail.com>

commit 985140369be1e886754d8ac0375dd64e4f727311 upstream.

This change adds 0x0489:0xe033 to the btusb module.

This bluetooth usb device is integrated in the Acer TimelineX AS4830TG-6808 notebook.

Output from /sys/kernel/debug/usb/devices:

T:  Bus=01 Lev=02 Prnt=02 Port=05 Cnt=02 Dev#=  4 Spd=12   MxCh= 0
D:  Ver= 2.00 Cls=ff(vend.) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0489 ProdID=e033 Rev= 2.29
S:  Manufacturer=Broadcom Corp
S:  Product=Acer Module
S:  SerialNumber=60D819F74101
C:* #Ifs= 4 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
I:  If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
I:  If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  32 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  32 Ivl=1ms
I:  If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  64 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  64 Ivl=1ms
I:  If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  64 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  64 Ivl=1ms
I:* If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=84(I) Atr=02(Bulk) MxPS=  32 Ivl=0ms
E:  Ad=04(O) Atr=02(Bulk) MxPS=  32 Ivl=0ms
I:* If#= 3 Alt= 0 #EPs= 0 Cls=fe(app. ) Sub=01 Prot=01 Driver=(none)

Signed-off-by: Steven Harms <sjharms@gmail.com>
Signed-off-by: Gustavo Padovan <gustavo@padovan.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/bluetooth/btusb.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 93cc828..9217121 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -108,6 +108,9 @@ static struct usb_device_id btusb_table[] = {
 	{ USB_DEVICE(0x0a5c, 0x21f3) },
 	{ USB_DEVICE(0x413c, 0x8197) },
 
+	/* Foxconn - Hon Hai */
+	{ USB_DEVICE(0x0489, 0xe033) },
+
 	{ }	/* Terminating entry */
 };
 


