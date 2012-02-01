Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654Ab2BAVKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:10:38 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49780 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932585Ab2BAVKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:10:32 -0500
X-Sasl-enc: +hERQr+1j/sefYhXjEtkz8668r4ZRrBeLWONPe9h/9Hj 1328130631
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:48 2012
Message-Id: <20120201210048.812671450@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 13:00:20 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Harrison Metzger <harrisonmetz@gmail.com>,
        Stuart Pook <stuart@acm.org>
Subject: [56/89] USB: usbsevseg: fix max length
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harrison Metzger <harrisonmetz@gmail.com>

commit 1097ccebe630170080c41df0edcf88e0626e9c75 upstream.

This changes the max length for the usb seven segment delcom device to 8
from 6. Delcom has both 6 and 8 variants and having 8 works fine with
devices which are only 6.

Signed-off-by: Harrison Metzger <harrisonmetz@gmail.com>
Signed-off-by: Stuart Pook <stuart@acm.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/usbsevseg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/misc/usbsevseg.c
+++ b/drivers/usb/misc/usbsevseg.c
@@ -24,7 +24,7 @@
 
 #define VENDOR_ID	0x0fc5
 #define PRODUCT_ID	0x1227
-#define MAXLEN		6
+#define MAXLEN		8
 
 /* table of devices that work with this driver */
 static const struct usb_device_id id_table[] = {


