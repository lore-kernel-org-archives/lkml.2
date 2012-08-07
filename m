Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964781Ab2HGDir (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:38:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59725 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757344Ab2HGDic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:38:32 -0400
Message-Id: <20120807032805.249296530@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:28:58 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jeongdo Son <sohn9086@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 63/70] rt2x00: Add support for BUFFALO WLI-UC-GNM2 to rt2800usb.
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeongdo Son <sohn9086@gmail.com>

commit a769f9577232afe2c754606a83aad85127e7052a upstream.

This is a RT3070 based device.

Signed-off-by: Jeongdo Son <sohn9086@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 20a5040..6cf3365 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -971,6 +971,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x0411, 0x015d) },
 	{ USB_DEVICE(0x0411, 0x016f) },
 	{ USB_DEVICE(0x0411, 0x01a2) },
+	{ USB_DEVICE(0x0411, 0x01ee) },
 	/* Corega */
 	{ USB_DEVICE(0x07aa, 0x002f) },
 	{ USB_DEVICE(0x07aa, 0x003c) },


