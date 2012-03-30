Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965046Ab2C3XHo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 19:07:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37370 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934732Ab2C3VEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:04:34 -0400
Message-Id: <20120330195726.270333215@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:57:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mikhail Kryshen <mikhail@kryshen.net>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Ivo van Doorn <IvDoorn@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 029/108] rt2x00: Add support for D-Link DWA-127 to rt2800usb.
In-Reply-To: <20120330195812.GA31833@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gertjan van Wingerde <gwingerde@gmail.com>

commit d42a179b941a9e4cc6cf41d0f3cbadd75fc48a89 upstream.

This is an RT3070 based device.

Reported-by: Mikhail Kryshen <mikhail@kryshen.net>
Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rt2x00/rt2800usb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -839,6 +839,7 @@ static struct usb_device_id rt2800usb_de
 	{ USB_DEVICE(0x07d1, 0x3c0f) },
 	{ USB_DEVICE(0x07d1, 0x3c11) },
 	{ USB_DEVICE(0x07d1, 0x3c16) },
+	{ USB_DEVICE(0x2001, 0x3c1b) },
 	/* Draytek */
 	{ USB_DEVICE(0x07fa, 0x7712) },
 	/* Edimax */


