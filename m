Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299Ab0HSAQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 20:16:37 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56823 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977Ab0HSAQe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 20:16:34 -0400
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: "henrique@henriquecamargo.com" <henrique@henriquecamargo.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 18 Aug 2010 19:16:28 -0500
Subject: RE: [PATCH] Fixes field names that changed
Thread-Topic: [PATCH] Fixes field names that changed
Thread-Index: Acs+GYAxAAnfoAQ8TFmfA+Z3x8xO9wBGb7SQ
Message-ID: <A24693684029E5489D1D202277BE89445718F57A@dlee02.ent.ti.com>
References: <1282055682.1883.5.camel@lemming>
In-Reply-To: <1282055682.1883.5.camel@lemming>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrique,

Just some minor comments about the patch description below:

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Henrique Camargo
> Sent: Tuesday, August 17, 2010 9:35 AM
> To: Mauro Carvalho Chehab
> Cc: Guennadi Liakhovetski; Karicheri, Muralidharan; linux-
> media@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] Fixes field names that changed

Add missing subject prefix to quickly describe the affected driver:

Subject: [PATCH] mt9t032: Fixes field names that changed

> 
> If CONFIG_VIDEO_ADV_DEBUG was set, the driver failed to compile because
> the fields get_register and set_register changed names to s_register and
> s_register in the struct v4l2_subdev_core_ops.

Please break down this comment to 70 chars max.

Also, you said "s_register" twice.

Regards,
Sergio

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
> @@ -499,8 +499,8 @@ static const struct v4l2_subdev_core_ops
> mt9t031_core_ops = {
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
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
