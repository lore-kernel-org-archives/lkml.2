Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab0IRTCY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:02:24 -0400
Received: from kroah.org ([198.145.64.141]:51224 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759Ab0IRTB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:27 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:55 2010
Message-Id: <20100918185955.308523357@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:57:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Russ Nelson <nelson@crynwr.com>
Subject: [029/123] USB: cdc-acm: add another device quirk
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=usb-cdc-acm-add-another-device-quirk.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russ Nelson <nelson@crynwr.com>

commit c3baa19b0a9b711b02cec81d9fea33b7b9628957 upstream.

The Maretron USB100 needs this quirk in order to work properly.

Signed-off-by: Russ Nelson <nelson@crynwr.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/class/cdc-acm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1527,6 +1527,9 @@ static struct usb_device_id acm_ids[] =
 	{ USB_DEVICE(0x1bbb, 0x0003), /* Alcatel OT-I650 */
 	.driver_info = NO_UNION_NORMAL, /* reports zero length descriptor */
 	},
+	{ USB_DEVICE(0x1576, 0x03b1), /* Maretron USB100 */
+	.driver_info = NO_UNION_NORMAL, /* reports zero length descriptor */
+	},
 
 	/* Nokia S60 phones expose two ACM channels. The first is
 	 * a modem and is picked up by the standard AT-command


