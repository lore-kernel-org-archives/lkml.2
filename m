Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab1DYUXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:23:23 -0400
Received: from 1wt.eu ([62.212.114.60]:33729 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755509Ab1DYUXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:23:19 -0400
Message-Id: <20110425200233.085993434@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:02:34 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Ivo van Doorn <IvDoorn@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 002/173] rt2x00: add device id for windy31 usb device
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

commit 9c4cf6d94fb362c27a24df5223ed6e327eb7279a upstream.

This patch adds the device id for the windy31 USB device to the rt73usb
driver.

Thanks to Ralf Flaxa for reporting this and providing testing and a
sample device.

Reported-by: Ralf Flaxa <rf@suse.de>
Tested-by: Ralf Flaxa <rf@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>

diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 0b4e859..029be3c 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2446,6 +2446,7 @@ static struct usb_device_id rt73usb_device_table[] = {
 	{ USB_DEVICE(0x04bb, 0x093d), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x148f, 0x2573), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x148f, 0x2671), USB_DEVICE_DATA(&rt73usb_ops) },
+	{ USB_DEVICE(0x0812, 0x3101), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Qcom */
 	{ USB_DEVICE(0x18e8, 0x6196), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x18e8, 0x6229), USB_DEVICE_DATA(&rt73usb_ops) },


