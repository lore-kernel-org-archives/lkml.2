Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744Ab2DSVHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:07:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38883 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932715Ab2DSVHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:07:15 -0400
Message-Id: <20120419210306.899131358@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:03:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Santiago Garcia Mantinan <manty@debian.org>
Subject: [ 44/75] USB: option: re-add NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED to option_id array
In-Reply-To: <20120419210322.GA6478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Santiago Garcia Mantinan <manty@debian.org>

commit 9ac2feb22b5b821d81463bef92698ef7682a3145 upstream.

Re-add NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED to option_id array

Signed-off-by: Santiago Garcia Mantinan <manty@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -708,6 +708,7 @@ static const struct usb_device_id option
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_EVDO_EMBEDDED_FULLSPEED) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_HSPA_EMBEDDED_FULLSPEED) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_EVDO_HIGHSPEED) },
+	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED3) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED4) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED5) },


