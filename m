Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031215Ab2I1T2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:28:40 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:50498 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030304Ab2I1TCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:02:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>, adam ? <adam3337@wp.pl>
Subject: [ 162/262] USB: add device quirk for Joss Optical touchboard
Date: Fri, 28 Sep 2012 11:51:31 -0700
Message-Id: <20120928183017.104138633@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 92fc7a8b0f20bdb243c706daf42658e8e0cd2ef0 upstream.

This patch (as1604) adds a CONFIG_INTF_STRINGS quirk for the Joss
infrared touchboard device.  The device doesn't like to be asked for
its interface strings.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: adam ? <adam3337@wp.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/quirks.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -96,6 +96,10 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x04b4, 0x0526), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },
 
+	/* Microchip Joss Optical infrared touchboard device */
+	{ USB_DEVICE(0x04d8, 0x000c), .driver_info =
+			USB_QUIRK_CONFIG_INTF_STRINGS },
+
 	/* Samsung Android phone modem - ID conflict with SPH-I500 */
 	{ USB_DEVICE(0x04e8, 0x6601), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },


