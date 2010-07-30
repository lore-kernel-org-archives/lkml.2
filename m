Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399Ab0G3TDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 15:03:33 -0400
Received: from kroah.org ([198.145.64.141]:51685 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758036Ab0G3RSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:18:53 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:06 2010
Message-Id: <20100730171506.166333994@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:15:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Omer Sezgin Ugurlu <omer.ugurlu@a-kent.com>
Subject: [072/165] USB: option: add support for 1da5:4518
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: =?UTF-8?q?=C3=96mer=20Sezgin=20Ugurlu?= <omer.ugurlu@a-kent.com>

commit 646d90e2b925578abef5c45853e0b166b6a450bf upstream.

Signed-off-by: Omer Sezgin Ugurlu <omer.ugurlu@a-kent.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -316,6 +316,7 @@ static int  option_resume(struct usb_ser
 #define QISDA_PRODUCT_H21_4512			0x4512
 #define QISDA_PRODUCT_H21_4523			0x4523
 #define QISDA_PRODUCT_H20_4515			0x4515
+#define QISDA_PRODUCT_H20_4518			0x4518
 #define QISDA_PRODUCT_H20_4519			0x4519
 
 /* TLAYTECH PRODUCTS */
@@ -836,6 +837,7 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(QISDA_VENDOR_ID, QISDA_PRODUCT_H21_4512) },
 	{ USB_DEVICE(QISDA_VENDOR_ID, QISDA_PRODUCT_H21_4523) },
 	{ USB_DEVICE(QISDA_VENDOR_ID, QISDA_PRODUCT_H20_4515) },
+	{ USB_DEVICE(QISDA_VENDOR_ID, QISDA_PRODUCT_H20_4518) },
 	{ USB_DEVICE(QISDA_VENDOR_ID, QISDA_PRODUCT_H20_4519) },
 	{ USB_DEVICE(TOSHIBA_VENDOR_ID, TOSHIBA_PRODUCT_G450) },
 	{ USB_DEVICE(TOSHIBA_VENDOR_ID, TOSHIBA_PRODUCT_HSDPA_MINICARD ) }, /* Toshiba 3G HSDPA == Novatel Expedite EU870D MiniCard */


