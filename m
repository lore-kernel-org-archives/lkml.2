Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab2JGX1E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:27:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38677 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754676Ab2JGXX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:23:26 -0400
Message-Id: <20121007225839.272131544@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:07 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?S=C3=B8ren=20holm?= <sgh@sgh.dk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 033/108] asix: Support DLink DUB-E100 H/W Ver C1
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Søren Holm <sgh@sgh.dk>

commit ed3770a9cd5764a575b83810ea679bbff2b03082 upstream.

Signed-off-by: Søren Holm <sgh@sgh.dk>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/usb/asix.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/usb/asix.c
+++ b/drivers/net/usb/asix.c
@@ -1648,6 +1648,10 @@ static const struct usb_device_id	produc
 	USB_DEVICE (0x2001, 0x3c05),
 	.driver_info = (unsigned long) &ax88772_info,
 }, {
+       // DLink DUB-E100 H/W Ver C1
+       USB_DEVICE (0x2001, 0x1a02),
+       .driver_info = (unsigned long) &ax88772_info,
+}, {
 	// Linksys USB1000
 	USB_DEVICE (0x1737, 0x0039),
 	.driver_info = (unsigned long) &ax88178_info,


