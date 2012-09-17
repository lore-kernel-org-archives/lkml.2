Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab2IQBZA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 21:25:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33517 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753170Ab2IQAtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:49:55 -0400
Message-Id: <20120917003642.123662314@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:38:20 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>,
        adam ? <adam3337@wp.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 115/135] USB: add device quirk for Joss Optical touchboard
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 92fc7a8b0f20bdb243c706daf42658e8e0cd2ef0 upstream.

This patch (as1604) adds a CONFIG_INTF_STRINGS quirk for the Joss
infrared touchboard device.  The device doesn't like to be asked for
its interface strings.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: adam ? <adam3337@wp.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/core/quirks.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index f15501f4c..e77a8e8 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -71,6 +71,10 @@ static const struct usb_device_id usb_quirk_list[] = {
 	{ USB_DEVICE(0x04b4, 0x0526), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },
 
+	/* Microchip Joss Optical infrared touchboard device */
+	{ USB_DEVICE(0x04d8, 0x000c), .driver_info =
+			USB_QUIRK_CONFIG_INTF_STRINGS },
+
 	/* Samsung Android phone modem - ID conflict with SPH-I500 */
 	{ USB_DEVICE(0x04e8, 0x6601), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },


