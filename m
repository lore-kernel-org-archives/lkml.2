Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946449Ab2CPXph (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:45:37 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38586 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965536Ab2CPXk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:40:58 -0400
Message-Id: <20120316233812.998873518@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 16 Mar 2012 16:38:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Joerg Neikes <j.neikes@midlandgate.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 27/41] usb: asix: Patch for Sitecom LN-031
In-Reply-To: <20120316233829.GA14022@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Neikes <j.neikes@midlandgate.de>

commit 4e50391968849860dff1aacde358b4eb14aa5127 upstream.

This patch adds support for the Sitecom LN-031 USB adapter with a AX88178 chip.

Added USB id to find correct driver for AX88178 1000 Ethernet adapter.

Signed-off-by: Joerg Neikes <j.neikes@midlandgate.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/usb/asix.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/usb/asix.c
+++ b/drivers/net/usb/asix.c
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


