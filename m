Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab0KVJMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 04:12:38 -0500
Received: from mail.pharmanord.com ([194.192.93.42]:51519 "EHLO pharmanord.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751133Ab0KVJMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 04:12:36 -0500
Message-ID: <4CEA3401.8070804@datanordisk.dk>
Date: Mon, 22 Nov 2010 10:12:33 +0100
From: Glenn Sommer <gsommer@datanordisk.dk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100628 Mandriva/3.0.5-1mdv2010.1 (2010.1) Lightning/1.0b1 Thunderbird/3.0.5
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        linux-input@vger.kernel.org
Subject: Patch for LG Flatron T1710B Touchscreen
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've recently got my hands on a LG Flatron T1710B touchscreen.
As other LG products, this seems to use the ITM panel.

I've patches my kernel to use the ITM driver with this device, and it seems to work great.

--- drivers/input/touchscreen/usbtouchscreen.c.orig	2010-11-18 16:33:40.806381557 +0100
+++ drivers/input/touchscreen/usbtouchscreen.c	2010-11-19 09:40:13.909222383 +0100
@@ -173,6 +173,7 @@ static struct usb_device_id usbtouch_dev

  #ifdef CONFIG_TOUCHSCREEN_USB_ITM
  	{USB_DEVICE(0x0403, 0xf9e9), .driver_info = DEVTYPE_ITM},
+	{USB_DEVICE(0x16e3, 0xf9e9), .driver_info = DEVTYPE_ITM},
  #endif

  #ifdef CONFIG_TOUCHSCREEN_USB_ETURBO

Signed-off-by: Glenn Sommer <gsommer@datanordisk.dk>


-- 
Med venlig hilsen / Best regards
Data Nordisk

Glenn Sommer
