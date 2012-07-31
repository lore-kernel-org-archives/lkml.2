Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab2GaEvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 00:51:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48876 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755726Ab2GaEvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:51:09 -0400
Message-Id: <20120731044315.612631174@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 31 Jul 2012 05:43:37 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Albert Pool <albertpool@solcon.nl>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 27/73] rt2800usb: 2001:3c17 is an RT3370 device
In-Reply-To: <20120731044310.013763753@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Albert Pool <albertpool@solcon.nl>

commit 8fd9d059af12786341dec5a688e607bcdb372238 upstream.

D-Link DWA-123 rev A1

Signed-off-by: Albert Pool<albertpool@solcon.nl>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index bf78317..20a5040 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1137,6 +1137,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
 #ifdef CONFIG_RT2800USB_RT33XX
 	/* Belkin */
 	{ USB_DEVICE(0x050d, 0x945b) },
+	/* D-Link */
+	{ USB_DEVICE(0x2001, 0x3c17) },
 	/* Panasonic */
 	{ USB_DEVICE(0x083a, 0xb511) },
 	/* Philips */
@@ -1237,7 +1239,6 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	/* D-Link */
 	{ USB_DEVICE(0x07d1, 0x3c0b) },
 	{ USB_DEVICE(0x07d1, 0x3c17) },
-	{ USB_DEVICE(0x2001, 0x3c17) },
 	/* Encore */
 	{ USB_DEVICE(0x203d, 0x14a1) },
 	/* Gemtek */


