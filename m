Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab2IQBOb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 21:14:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33675 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753616Ab2IQAu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:50:27 -0400
Message-Id: <20120917003640.051782781@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:38:05 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Gertjan van Wingerde <gwingerde@gmail.com>,
        Maximilian Engelhardt <maxi@daemonizer.de>,
        Ivo Van Doorn <ivdoorn@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 100/135] rt2x00: Identify ASUS USB-N53 device.
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gertjan van Wingerde <gwingerde@gmail.com>

commit 177ef8360fabdc49ff08d2598c06e7f7a36b53e3 upstream.

This is an RT3572 based device.

Signed-off-by: Maximilian Engelhardt <maxi@daemonizer.de>
Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Ivo Van Doorn <ivdoorn@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 6cf3365..6681bfc 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1157,6 +1157,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x1690, 0x0744) },
 	{ USB_DEVICE(0x1690, 0x0761) },
 	{ USB_DEVICE(0x1690, 0x0764) },
+	/* ASUS */
+	{ USB_DEVICE(0x0b05, 0x179d) },
 	/* Cisco */
 	{ USB_DEVICE(0x167b, 0x4001) },
 	/* EnGenius */
@@ -1222,7 +1224,6 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x0b05, 0x1760) },
 	{ USB_DEVICE(0x0b05, 0x1761) },
 	{ USB_DEVICE(0x0b05, 0x1790) },
-	{ USB_DEVICE(0x0b05, 0x179d) },
 	/* AzureWave */
 	{ USB_DEVICE(0x13d3, 0x3262) },
 	{ USB_DEVICE(0x13d3, 0x3284) },


