Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab0KSKBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 05:01:19 -0500
Received: from mail.pharmanord.com ([194.192.93.42]:48904 "EHLO pharmanord.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751279Ab0KSKBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 05:01:18 -0500
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Nov 2010 05:01:17 EST
Message-ID: <4CE63CC7.9040709@datanordisk.dk>
Date: Fri, 19 Nov 2010 10:00:55 +0100
From: Glenn Sommer <gsommer@datanordisk.dk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100628 Mandriva/3.0.5-1mdv2010.1 (2010.1) Lightning/1.0b1 Thunderbird/3.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, linux-input@vger.kernel.org
Subject: Patch for LG Flatron T1710B touchscreen
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've recently got my hands on a LG Flatron T1710B touchscreen.
As other LG products, this seems to use the ITM panel.

I've patches my kernel to use the ITM driver with this device, and it seems to work great.

--- PATCH START ---

--- drivers/input/touchscreen/usbtouchscreen.c.orig	2010-11-18 16:33:40.806381557 +0100
+++ drivers/input/touchscreen/usbtouchscreen.c	2010-11-19 09:40:13.909222383 +0100
@@ -173,6 +173,7 @@ static struct usb_device_id usbtouch_dev

  #ifdef CONFIG_TOUCHSCREEN_USB_ITM
  	{USB_DEVICE(0x0403, 0xf9e9), .driver_info = DEVTYPE_ITM},
+	{USB_DEVICE(0x16e3, 0xf9e9), .driver_info = DEVTYPE_ITM},
  #endif

  #ifdef CONFIG_TOUCHSCREEN_USB_ETURB

--- PATCH END ---

-- 
Med venlig hilsen / Best regards
Data Nordisk

Glenn Sommer
