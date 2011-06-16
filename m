Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab1FPHBN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:01:13 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:43408 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755579Ab1FPHBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:01:05 -0400
X-Sasl-enc: W3akcUAIN5LeljkYUZAfnQT2CPQ/ou4nEDEZAK7POoZh 1308207665
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:34 2011
Message-Id: <20110616000234.200378234@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:00:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Williams <dcbw@redhat.com>
Subject: [53/89] option: add Prolink PH300 modem IDs
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Williams <dcbw@redhat.com>

commit 5c3e4076ee8253c1e3688d10653ddee47a03b0db upstream.

Simple ID addition.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -340,6 +340,7 @@ static void option_instat_callback(struc
 #define TOSHIBA_PRODUCT_G450			0x0d45
 
 #define ALINK_VENDOR_ID				0x1e0e
+#define ALINK_PRODUCT_PH300			0x9100
 #define ALINK_PRODUCT_3GU			0x9200
 
 /* ALCATEL PRODUCTS */
@@ -945,6 +946,7 @@ static const struct usb_device_id option
 	{ USB_DEVICE(TOSHIBA_VENDOR_ID, TOSHIBA_PRODUCT_G450) },
 	{ USB_DEVICE(TOSHIBA_VENDOR_ID, TOSHIBA_PRODUCT_HSDPA_MINICARD ) }, /* Toshiba 3G HSDPA == Novatel Expedite EU870D MiniCard */
 	{ USB_DEVICE(ALINK_VENDOR_ID, 0x9000) },
+	{ USB_DEVICE(ALINK_VENDOR_ID, ALINK_PRODUCT_PH300) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ALINK_VENDOR_ID, ALINK_PRODUCT_3GU, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE(ALCATEL_VENDOR_ID, ALCATEL_PRODUCT_X060S_X200),
 	  .driver_info = (kernel_ulong_t)&alcatel_x200_blacklist


