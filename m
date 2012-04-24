Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964899Ab2DXWkl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:40:41 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:33944 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964853Ab2DXWjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:39:11 -0400
Message-Id: <20120424223256.227976314@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:25 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eduardo Bacchi Kienetz <eduardo@kienetz.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Ivo van Doorn <IvDoorn@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 32/42] rt2800usb: Add new device ID for Belkin
In-Reply-To: <20120424223311.GA8456@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduardo Bacchi Kienetz <eduardo@kienetz.com>

commit 43bf8c245237b8309153aa39d4e8f1586cf56af0 upstream.

Belkin's Connect N150 Wireless USB Adapter, model F7D1101 version 2, uses ID 0x945b.
Chipset info: rt: 3390, rf: 000b, rev: 3213.
I have just bought one, which started to work perfectly after the ID was added through this patch.

Signed-off-by: Eduardo Bacchi Kienetz <eduardo@kienetz.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rt2x00/rt2800usb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -976,6 +976,8 @@ static struct usb_device_id rt2800usb_de
 	{ USB_DEVICE(0x0586, 0x341e) },
 	{ USB_DEVICE(0x0586, 0x343e) },
 #ifdef CONFIG_RT2800USB_RT33XX
+	/* Belkin */
+	{ USB_DEVICE(0x050d, 0x945b) },
 	/* Ralink */
 	{ USB_DEVICE(0x148f, 0x3370) },
 	{ USB_DEVICE(0x148f, 0x8070) },


