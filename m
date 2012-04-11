Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965433Ab2DKXYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:24:12 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:51056 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965383Ab2DKXYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:24:08 -0400
Message-Id: <20120411231044.648668392@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:11:29 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Guan Xin <guanx.bac@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 54/59] USB: Add Motorola Rokr E6 Id to the USBNet driver "zaurus"
In-Reply-To: <20120411231213.GA13124@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guan Xin <guanx.bac@gmail.com>

commit a2daf263107ba3eb6db33931881731fa51c95045 upstream.

Added Vendor/Device Id of Motorola Rokr E6 (22b8:6027) so it can be
recognized by the "zaurus" USBNet driver.
Applies to Linux 3.2.13 and 2.6.39.4.
Signed-off-by: Guan Xin <guanx.bac@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/usb/zaurus.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/usb/zaurus.c
+++ b/drivers/net/usb/zaurus.c
@@ -332,6 +332,11 @@ static const struct usb_device_id	produc
 	.driver_info = ZAURUS_PXA_INFO,
 },
 {
+	/* Motorola Rokr E6 */
+	USB_DEVICE_AND_INTERFACE_INFO(0x22b8, 0x6027, USB_CLASS_COMM,
+			USB_CDC_SUBCLASS_MDLM, USB_CDC_PROTO_NONE),
+	.driver_info = (unsigned long) &bogus_mdlm_info,
+}, {
 	/* Motorola MOTOMAGX phones */
 	USB_DEVICE_AND_INTERFACE_INFO(0x22b8, 0x6425, USB_CLASS_COMM,
 			USB_CDC_SUBCLASS_MDLM, USB_CDC_PROTO_NONE),


