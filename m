Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab2HVXjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 19:39:24 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:60487 "EHLO
	homiemail-a46.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755770Ab2HVXjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 19:39:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=shealevy.com; h=from:to:cc
	:subject:date:message-id; q=dns; s=shealevy.com; b=Um+2OXdfxTvA9
	lsxMLfx2Ian/tZNDcsEaNnzZ1YfJYSgNk0dDb4pIUMOIHFbEAh4+It9bcjcg3HGd
	Bypv65Q/ZmxuCgHbd6hvCoa0++h9LB2bYpyLCl+MHQHcpj195pJ+Dt+TtotJMmPU
	pMRwPEWgzwHJgo1ZSiO6INouHumTbI=
From: Shea Levy <shea@shealevy.com>
To: linux-bluetooth@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hedberg <johan.hedberg@gmail.com>,
        Gustavo Padovan <gustavo@padovan.org>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH RESEND RESEND] Bluetooth: Add support for Apple MacBook Pro 9,2
Date: Wed, 22 Aug 2012 19:39:13 -0400
Message-Id: <1345678753-32753-1-git-send-email-shea@shealevy.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

$ usb-devices
<snip>
T:  Bus=04 Lev=04 Prnt=04 Port=02 Cnt=01 Dev#=  9 Spd=12  MxCh= 0
D:  Ver= 2.00 Cls=ff(vend.) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=05ac ProdID=821d Rev=00.86
S:  Manufacturer=Apple Inc.
S:  Product=Bluetooth USB Host Controller
C:  #Ifs= 4 Cfg#= 1 Atr=e0 MxPwr=0mA
I:  If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
I:  If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
I:  If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#= 3 Alt= 0 #EPs= 0 Cls=fe(app. ) Sub=01 Prot=01 Driver=(none)
<snip>

Signed-off-by: Shea Levy <shea@shealevy.com>
---
 drivers/bluetooth/btusb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index f077f4d..fdddb6e 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -73,6 +73,9 @@ static struct usb_device_id btusb_table[] = {
 	/* Apple MacBookPro8,2 */
 	{ USB_DEVICE(0x05ac, 0x821a) },
 
+	/* Apple MacBookPro9,2 */
+	{ USB_DEVICE(0x05ac, 0x821d) },
+
 	/* Apple MacMini5,1 */
 	{ USB_DEVICE(0x05ac, 0x8281) },
 
-- 
1.7.11.4

