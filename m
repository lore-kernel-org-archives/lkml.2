Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab2HTEBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:01:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54493 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303Ab2HTEBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 00:01:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeongdo Son <sohn9086@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 39/46] rt2x00: Add support for BUFFALO WLI-UC-GNM2 to rt2800usb.
Date: Sun, 19 Aug 2012 20:59:15 -0700
Message-Id: <20120820035837.693572515@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035832.274275502@linuxfoundation.org>
References: <20120820035832.274275502@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeongdo Son <sohn9086@gmail.com>

commit a769f9577232afe2c754606a83aad85127e7052a upstream.

This is a RT3070 based device.

Signed-off-by: Jeongdo Son <sohn9086@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rt2x00/rt2800usb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -971,6 +971,7 @@ static struct usb_device_id rt2800usb_de
 	{ USB_DEVICE(0x0411, 0x015d) },
 	{ USB_DEVICE(0x0411, 0x016f) },
 	{ USB_DEVICE(0x0411, 0x01a2) },
+	{ USB_DEVICE(0x0411, 0x01ee) },
 	/* Corega */
 	{ USB_DEVICE(0x07aa, 0x002f) },
 	{ USB_DEVICE(0x07aa, 0x003c) },


