Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab1KXCqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 21:46:39 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56397 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab1KXCqi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 21:46:38 -0500
MIME-Version: 1.0
In-Reply-To: <CAJ0PZbSF_iEY0=rSrA+nUEVuPA5Co_XtXZY3gCAXHnfc9VBuhg@mail.gmail.com>
References: <CAJ0PZbSF_iEY0=rSrA+nUEVuPA5Co_XtXZY3gCAXHnfc9VBuhg@mail.gmail.com>
Date: Thu, 24 Nov 2011 11:46:36 +0900
Message-ID: <CAJ0PZbQ0Mv1jgxSy42L7THR05Z702rJfSrLf=a=yoC3TRe67nQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] Multistate Switch Class: import Android's switch
 class and modify.
From: MyungJoo Ham <myungjoo.ham@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Lockwood <lockwood@android.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>, MyungJoo Ham <myungjoo.ham@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 11:05 AM, MyungJoo Ham <myungjoo.ham@samsung.com> wrote:
> Multistate switch class is based on and an extension of Android
> kernel's switch class located at linux/drivers/switch/.
> This patch provides the before-extension switch class moved to the
> location where multistate switch class will be located.
>
> The before-extension class, switch class of Android kernel, commits
> imported are:
>
> switch: switch class and GPIO drivers.
> Author: Mike Lockwood <lockwood@android.com>
>
> switch: gpio: Don't call request_irq with interrupts disabled
> Author: Arve Hj첩nnev책g <arve@android.com>
>
> switch: Use device_create instead of device_create_drvdata.
> Author: Arve Hj첩nnev책g <arve@android.com>
>
> switch_gpio: Add missing #include <linux/interrupt.h>
> Author: Mike Lockwood <lockwood@android.com>
>
> In this patch, upon the commits of Android kernel, we have added:
> - Relocated and renamed for multistate switch class
> - Comments, module name, and author information are updated
> - Code clean for successing patches
> - Bugfix: enabling write access without write functions
>
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/Makefile            |    1 +
[]
>
> diff --git a/drivers/Makefile b/drivers/Makefile
> index 1b31421..7b042da 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -100,6 +100,7 @@ obj-$(CONFIG_CPU_IDLE)              += cpuidle/
>  obj-$(CONFIG_MMC)              += mmc/
>  obj-$(CONFIG_MEMSTICK)         += memstick/
>  obj-y                          += leds/
> +obj-$(CONFIG_SWITCH)           += switch/
>  obj-$(CONFIG_INFINIBAND)       += infiniband/
>  obj-$(CONFIG_SGI_SN)           += sn/
>  obj-y                          += firmware/

Please never mind the part of /drivers/Makefile. That should be removed.



Cheers!
MyungJoo

-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
