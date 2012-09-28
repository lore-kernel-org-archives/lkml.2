Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032704Ab2I1U2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:28:40 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52836 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964869Ab2I1U2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:28:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>, adam ? <adam3337@wp.pl>
Subject: [ 130/218] USB: add device quirk for Joss Optical touchboard
Date: Fri, 28 Sep 2012 13:15:47 -0700
Message-Id: <20120928201516.377846866@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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


