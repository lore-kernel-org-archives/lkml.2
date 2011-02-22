Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab1BVOHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 09:07:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670Ab1BVOHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 09:07:23 -0500
Date: Tue, 22 Feb 2011 16:07:10 +0200
From: Shahar Havivi <shaharh@redhat.com>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Peter Korsgaard <jacmet@sunsite.dk>, Greg Kroah-Hartman <gregkh@suse.de>,
        netdev@vger.kernel.org
Subject: [PATCH] USB 10/100 RJ45 Ethernet Network Adapter
Message-ID: <20110222140705.GA6055@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device is very similar to (0x0fe6, 0x8101),
And works well with dm9601 driver.
---
 drivers/net/usb/dm9601.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/usb/dm9601.c b/drivers/net/usb/dm9601.c
index 02b622e..2d1c8ae 100644
--- a/drivers/net/usb/dm9601.c
+++ b/drivers/net/usb/dm9601.c
@@ -654,6 +654,11 @@ static const struct usb_device_id products[] = {
 	 USB_DEVICE(0x0a46, 0x9000),	/* DM9000E */
 	 .driver_info = (unsigned long)&dm9601_info,
 	 },
+	{
+	 USB_DEVICE(0x0fe6, 0x9700),	/* DM9601 USB to Fast Ethernet Adapter */
+
+	 .driver_info = (unsigned long)&dm9601_info,
+	 },
 	{},			// END
 };
 
-- 
1.7.3.4

