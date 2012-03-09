Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab2CII3X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 03:29:23 -0500
Received: from mail.aixtema.de ([212.117.64.100]:36410 "EHLO mail.aixtema.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601Ab2CII3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 03:29:22 -0500
X-Greylist: delayed 1060 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Mar 2012 03:29:22 EST
Message-ID: <1331280697.5426.4.camel@mobile>
Subject: Patch for Sitecom LN-031
From: Joerg Neikes <j.neikes@midlandgate.de>
To: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Date: Fri, 09 Mar 2012 09:11:37 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-AntiVirus: checked by AntiVir MailGate (version: 2.0.1.16; AVE: 7.9.10.14; VDF: 7.11.24.248; host: mail.aixtema.de)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the Sitecom LN-031 USB adapter with a AX88178 chip.

Added USB id to find correct driver for AX88178 1000 Ethernet adapter.

Signed-off-by: Joerg Neikes <j.neikes@midlandgate.de>



--- linux-3.2.6-gentoo/drivers/net/usb/asix.c	2012-02-14 14:54:11.079152551 +0100
+++ linux-3.2.9-gentoo/drivers/net/usb/asix.c	2012-03-09 00:01:34.657806558 +0100
@@ -1595,6 +1595,10 @@ static const struct usb_device_id	produc
 	USB_DEVICE (0x6189, 0x182d),
 	.driver_info =  (unsigned long) &ax8817x_info,
 }, {
+	// Sitecom LN-031 "USB 2.0 10/100/1000 Ethernet adapter"
+	USB_DEVICE (0x0df6, 0x0056),
+	.driver_info =  (unsigned long) &ax88178_info,
+}, {
 	// corega FEther USB2-TX
 	USB_DEVICE (0x07aa, 0x0017),
 	.driver_info =  (unsigned long) &ax8817x_info,




