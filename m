Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505Ab2CZOM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 10:12:28 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41014 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932452Ab2CZOM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 10:12:27 -0400
MIME-Version: 1.0
From: Guan Xin <guanx.bac@gmail.com>
Date: Mon, 26 Mar 2012 16:11:46 +0200
Message-ID: <CANeMGR5PECuVb=p7orzwHgcsa9GSW=-gMyqWo7RYm_NpmLm4Ug@mail.gmail.com>
Subject: [PATCH] USB: Add Motorola Rokr E6 Id to the USBNet driver "zaurus"
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Dave Jones <davej@redhat.com>,
        Guan Xin <guanx.bac@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guan Xin <guanx.bac@gmail.com>

Added Vendor/Device Id of Motorola Rokr E6 (22b8:6027) so it can be
recognized by the "zaurus" USBNet driver.
Applies to Linux 3.2.13 and 2.6.39.4.
Signed-off-by: Guan Xin <guanx.bac@gmail.com>
---
--- a/drivers/net/usb/zaurus.c	2012-03-26 15:28:43.964244583 +0200
+++ b/drivers/net/usb/zaurus.c	2012-03-26 15:02:16.860801959 +0200
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
