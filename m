Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab1A0UhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 15:37:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564Ab1A0UhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 15:37:03 -0500
Date: Thu, 27 Jan 2011 22:37:01 +0200
From: Shahar Havivi <shaharh@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] USB 10/100 RJ45 Ethernet Network Adapter
Message-ID: <20110127203656.GA17842@redhat.com>
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

