Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab0DMKdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 06:33:13 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:63517 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab0DMKdM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 06:33:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=MjFq7KvT+Fr3SdaGAA+hyzTzSZGN9a4v4UIeTuVsHD8moS/jHPghtX2ljaAopJO3Kx
         y0qJ4aujBUHDXPbdvVkD0wOa3/nWoBXdR0xsQMDadXTLZykjsJ8ji5tun6ASgnN/9gFP
         Lc/5jGxomJxS843hSBKFGCiqxiY8ZZuiRS4YQ=
MIME-Version: 1.0
In-Reply-To: <x2led984c71004130329l3a531dag88242427583d5a78@mail.gmail.com>
References: <x2led984c71004130329l3a531dag88242427583d5a78@mail.gmail.com>
Date: Tue, 13 Apr 2010 16:03:11 +0530
Message-ID: <z2ned984c71004130333t5a9534beqac5269f8e5fb4b88@mail.gmail.com>
Subject: [PATCH] ZTEAC8710 Support with Device ID 0xffff
From: Mahesh Kuruganti <maheshkuruganti@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a patch in the correct format compiled against
Linux-2.6.34-rc3.Also I tested it and it compiled with no problem and
I am using it now as i type.

PATCH TO EXTEND SUPPORT TO AC8710 WITH 0xFFFF Product ID.


--- drivers/usb/serial/option.c.orig    2010-04-12 21:44:55.902548876 +0530
+++ drivers/usb/serial/option.c    2010-04-12 21:51:47.302549297 +0530
@@ -304,6 +304,8 @@ static int  option_resume(struct usb_ser
 #define ZTE_PRODUCT_CDMA_TECH            0xfffe
 #define ZTE_PRODUCT_AC8710            0xfff1
 #define ZTE_PRODUCT_AC2726            0xfff5
+//There seems to be an Alternate Device ID for the AC8710 supplied in India.
+#define ZTE_PRODUCT_AC8710T            0xffff

 #define BENQ_VENDOR_ID                0x04a5
 #define BENQ_PRODUCT_H10            0x4068
@@ -677,6 +679,7 @@ static const struct usb_device_id option
     { USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0141, 0xff, 0xff, 0xff) },
     { USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID,
ZTE_PRODUCT_CDMA_TECH, 0xff, 0xff, 0xff) },
     { USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID,
ZTE_PRODUCT_AC8710, 0xff, 0xff, 0xff) },
+    { USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID,
ZTE_PRODUCT_AC8710T, 0xff, 0xff, 0xff) },
     { USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID,
ZTE_PRODUCT_AC2726, 0xff, 0xff, 0xff) },
     { USB_DEVICE(BENQ_VENDOR_ID, BENQ_PRODUCT_H10) },
     { USB_DEVICE(DLINK_VENDOR_ID, DLINK_PRODUCT_DWM_652) },

Signed-off-by: Mahesh Kuruganti <maheshkuruganti@gmail.com>




--
Mahesh Kuruganti
