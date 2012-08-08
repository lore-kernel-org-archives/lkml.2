Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab2HHG7I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 02:59:08 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59402 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131Ab2HHG7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 02:59:06 -0400
MIME-Version: 1.0
In-Reply-To: <20120808081317.40c883f9@amdc308.digital.local>
References: <CAN_1RdsTX5ZGSx7T6X0t70Q6k5_M1zgizL-KzPYrnHOnZ_nfSg@mail.gmail.com>
	<20120806101200.GJ17551@arwen.pp.htv.fi>
	<20120806151436.4761cd4d@amdc308.digital.local>
	<CAN_1RdsFh5-xZ7ijL-Cwf4cDzWYthFfMOM7dPdRUub2rQ_RMDw@mail.gmail.com>
	<20120807113416.57b03f4f@amdc308.digital.local>
	<CAN_1Rdu+xy9EzmHty+wT4GYUGADmNMOxk2_FcG9jJ6R2nO-iBQ@mail.gmail.com>
	<20120808081317.40c883f9@amdc308.digital.local>
Date: Wed, 8 Aug 2012 14:59:05 +0800
Message-ID: <CAN_1Rdvd=gZUn0GovPVQsVTzEUrUzjMFp9hnhZDEc1utHu3e5Q@mail.gmail.com>
Subject: Re: [BUG] Kernel panic when try s3c-hsotg.c with kernel 3.5
From: Peiyong Feng <peiyong.feng.kernel@gmail.com>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: balbi@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/8 Lukasz Majewski <l.majewski@samsung.com>:
> Dear Peiyong Feng,
>
>> > Please enable the debug at s3c-hsotg.c driver and then paste the
>> > dmesg/debug output.
>> I have defined DEGUG in s3c-hsotg.c
>
> Thank you for 2.6.36 log.
> I'd also need the log from 3.6-rc1 kernel with DEBUG enabled.
I have made a define like:
#define DEBUG
in s3c-hsotg.c of 3.6-rc1 kernel and the patch:
======================================
diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index b13e0bb..b35d275 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -36,6 +36,7 @@

 #include <mach/map.h>

+#define DEBUG
 #include "s3c-hsotg.h"

 #define DMA_ADDR_INVALID (~((dma_addr_t)0))
=-========================================

And the output is just the same as I have posted.

If that is not the way you want, please let me know.


>
> --
> Best regards,
>
> Lukasz Majewski
>
> Samsung Poland R&D Center | Linux Platform Group
