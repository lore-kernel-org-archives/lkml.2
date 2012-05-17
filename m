Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761247Ab2EQHj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 03:39:29 -0400
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1424 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757989Ab2EQHj2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 03:39:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] radio: fix build error in rtrack2_alloc()
Date: Thu, 17 May 2012 09:39:14 +0200
User-Agent: KMail/1.13.7 (Linux/3.4.0-rc3-durdane; KDE/4.7.4; x86_64; ; )
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <20120517023222.GA7788@localhost>
In-Reply-To: <20120517023222.GA7788@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201205170939.14829.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu May 17 2012 04:32:22 Fengguang Wu wrote:
> Fix compile error
> 
> drivers/media/radio/radio-rtrack2.c: In function ‘rtrack2_alloc’:                                                                         
> drivers/media/radio/radio-rtrack2.c:46:2: error: implicit declaration of function ‘kzalloc’

This fix has already been merged in the v4l staging tree, so it will find its
way into 3.5.

Regards,

	Hans

> 
> CC: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
> ---
>  drivers/media/radio/radio-rtrack2.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux.orig/drivers/media/radio/radio-rtrack2.c	2012-04-06 13:23:52.548862660 +0800
> +++ linux/drivers/media/radio/radio-rtrack2.c	2012-05-17 10:18:20.679495193 +0800
> @@ -17,6 +17,7 @@
>  #include <linux/videodev2.h>	/* kernel radio structs		*/
>  #include <linux/mutex.h>
>  #include <linux/io.h>		/* outb, outb_p			*/
> +#include <linux/slab.h>		/* kzalloc			*/
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-ioctl.h>
>  #include "radio-isa.h"
> 
