Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031645Ab2I1U5i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:57:38 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49275 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422962Ab2I1UsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:48:04 -0400
X-Sasl-enc: sBRWtX5RfpGdQhMkhZoDD7Aimr578bxHvBaP1urxkA2e 1348865283
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>, adam ? <adam3337@wp.pl>
Subject: [ 077/127] USB: add device quirk for Joss Optical touchboard
Date: Fri, 28 Sep 2012 13:34:10 -0700
Message-Id: <20120928203054.869936112@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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


