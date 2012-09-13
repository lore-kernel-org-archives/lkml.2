Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605Ab2IMPWi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 11:22:38 -0400
Received: from mailout05.t-online.de ([194.25.134.82]:32870 "EHLO
	mailout05.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532Ab2IMPWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 11:22:36 -0400
From: Thomas =?iso-8859-1?q?Sch=E4fer?= <tschaefer@t-online.de>
To: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [ 34/95] USB: option: add ZTE K5006-Z
Date: Thu, 13 Sep 2012 17:22:00 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.20-desktop; KDE/4.6.0; x86_64; ; )
Cc: =?iso-8859-1?q?Bj=F8rn_Mork?= <bjorn@mork.no>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20120909224155.514234762@decadent.org.uk> <87zk4xm2cd.fsf@nemi.mork.no> <1347416977.6699.1.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1347416977.6699.1.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201209131722.19730.tschaefer@t-online.de>
X-ID: TzsLsMZ1ZhqtMRB6HTG9Sh-+SiKhwunDs-qh7kxF4-zErjL5RNXsQUkqMusolbzgF0
X-TOI-MSGID: 987a6491-f400-42bf-82f1-c2e5ef16c7a1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=ba9edaa468869a8cea242a411066b0f490751798

 index cc40f47..5ce88d1 100644 (file)
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -886,8 +886,6 @@ static const struct usb_device_id option_ids[] = {
        { USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1010, 0xff, 0xff, 0xff),
          .driver_info = (kernel_ulong_t)&net_intf4_blacklist },
        { USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1012, 0xff, 0xff, 0xff) },
-       { USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1018, 0xff, 0xff, 0xff),
-         .driver_info = (kernel_ulong_t)&net_intf3_blacklist },
        { USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1057, 0xff, 0xff, 0xff) },
        { USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1058, 0xff, 0xff, 0xff) },
        { USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1059, 0xff, 0xff, 0xff) },
@@ -1092,6 +1090,10 @@ static const struct usb_device_id option_ids[] = {
         .driver_info = (kernel_ulong_t)&zte_ad3812_z_blacklist },
        { USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_MC2716, 0xff, 0xff, 0xff),
         .driver_info = (kernel_ulong_t)&zte_mc2716_z_blacklist },
+       { USB_VENDOR_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0xff, 0x02, 0x01) },
+       { USB_VENDOR_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0xff, 0x02, 0x05) },
+       { USB_VENDOR_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0xff, 0x86, 0x10) },
+
        { USB_DEVICE(BENQ_VENDOR_ID, BENQ_PRODUCT_H10) },
        { USB_DEVICE(DLINK_VENDOR_ID, DLINK_PRODUCT_DWM_652) },
        { USB_DEVICE(ALINK_VENDOR_ID, DLINK_PRODUCT_DWM_652_U5) }, /* Yes, ALINK_VENDOR_ID */


I tested the new patch with linux-next-20120913

It works as expected, at least for the K5006-Z.

Sorry for the confusion I triggered. I have no clue about the best matching methods. My focus is on testing.


Thomas


