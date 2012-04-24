Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964851Ab2DXWly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:41:54 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:33944 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964813Ab2DXWiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:38:50 -0400
Message-Id: <20120424223256.311669106@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Teika Kazura <teika@lavabit.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Ivo van Doorn <IvDoorn@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 33/42] rt2x00: Add USB device ID of Buffalo WLI-UC-GNHP.
In-Reply-To: <20120424223311.GA8456@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gertjan van Wingerde <gwingerde@gmail.com>

commit c18b7806e4f3373b2f296a65fb19251a3b49a532 upstream.

This is reported to be an RT3070 based device.

Reported-by: Teika Kazura <teika@lavabit.com>
Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rt2x00/rt2800usb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -824,6 +824,7 @@ static struct usb_device_id rt2800usb_de
 	{ USB_DEVICE(0x050d, 0x935b) },
 	/* Buffalo */
 	{ USB_DEVICE(0x0411, 0x00e8) },
+	{ USB_DEVICE(0x0411, 0x0158) },
 	{ USB_DEVICE(0x0411, 0x016f) },
 	{ USB_DEVICE(0x0411, 0x01a2) },
 	/* Corega */


