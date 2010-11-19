Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385Ab0KSDIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 22:08:11 -0500
Received: from mail.wdtv.com ([66.118.69.84]:39410 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211Ab0KSDIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 22:08:09 -0500
From: Gene Heskett <gene.heskett@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Missing nvidia.ko, cannot install nvidia driver
Date: Thu, 18 Nov 2010 22:07:59 -0500
User-Agent: KMail/1.13.5 (Linux/2.6.36; KDE/4.5.3; i686; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201011182208.00077.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings;

All of a sudden it seems I cannot find the option that makes a kernel build 
include the build and install of 
/lib/modules/2.6.36/kernel/drivers/video/nvidia.ko

It built for 2.6.33.7-pclos with this config grep for NVIDIA
[root@coyote src]# grep NVIDIA linux-2.6.33.7-pclos1/.config
CONFIG_AGP_NVIDIA=y
CONFIG_FB_NVIDIA=m
CONFIG_FB_NVIDIA_I2C=y
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_BACKLIGHT_MBP_NVIDIA=m

But not for this:
[root@coyote src]# grep NVIDIA linux-2.6.36/.config
CONFIG_AGP_NVIDIA=y
CONFIG_FB_NVIDIA=m
CONFIG_FB_NVIDIA_I2C=y
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set

Anyone have a clue they can spare?

Thanks.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Q:	How many IBM CPU's does it take to do a logical right shift?
A:	33.  1 to hold the bits and 32 to push the register.
