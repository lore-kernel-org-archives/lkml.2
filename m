Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab0HXWX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:23:26 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:57925 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755842Ab0HXWXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:23:23 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/aNQYwF4TacZu3M5VUBLWNTVMVnqAF+q4b1WnVYA
	3lPvWbxyrnV0sx
Date: Wed, 25 Aug 2010 00:23:20 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Henrique Camargo <henrique@henriquecamargo.com>
cc: "Aguirre, Sergio" <saaguirre@ti.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mt9t031: Fixes field names that changed
In-Reply-To: <1282243015.2213.13.camel@lemming>
Message-ID: <Pine.LNX.4.64.1008250020540.19669@axis700.grange>
References: <1282243015.2213.13.camel@lemming>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Aug 2010, Henrique Camargo wrote:

> If CONFIG_VIDEO_ADV_DEBUG was set, the driver failed to compile 
> because the fields get_register and set_register changed names to 
> g_register and s_register in the struct v4l2_subdev_core_ops.
> 
> Signed-off-by: Henrique Camargo <henrique@henriquecamargo.com>
> ---
>  drivers/media/video/mt9t031.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
> index 716fea6..f3d1995 100644
> --- a/drivers/media/video/mt9t031.c
> +++ b/drivers/media/video/mt9t031.c
> @@ -499,8 +499,8 @@ static const struct v4l2_subdev_core_ops mt9t031_core_ops = {
>  	.g_ctrl	= mt9t031_get_control,
>  	.s_ctrl	= mt9t031_set_control,
>  #ifdef CONFIG_VIDEO_ADV_DEBUG
> -	.get_register = mt9t031_get_register,
> -	.set_register = mt9t031_set_register,
> +	.g_register = mt9t031_get_register,
> +	.s_register = mt9t031_set_register,
>  #endif
>  };
>  
> -- 
> 1.7.0.4

I might be missing something obvious, but I do not understand against 
which tree / version is this patch? I don't see this problem in the 
mainline.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
