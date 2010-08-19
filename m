Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab0HSSdN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 14:33:13 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43873 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab0HSSdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 14:33:12 -0400
Subject: RE: [PATCH] Fixes field names that changed
From: Henrique Camargo <henrique@henriquecamargo.com>
To: "Aguirre, Sergio" <saaguirre@ti.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <A24693684029E5489D1D202277BE89445718F57D@dlee02.ent.ti.com>
References: <1282055682.1883.5.camel@lemming>
	 <A24693684029E5489D1D202277BE89445718F57A@dlee02.ent.ti.com>
	 <A24693684029E5489D1D202277BE89445718F57D@dlee02.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Aug 2010 15:33:02 -0300
Message-ID: <1282242782.2213.8.camel@lemming>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you Sergio for your help, I resent the patch a couple of minutes
ago taking your changes into account.

Best Regards,
Henrique Camargo

On Wed, 2010-08-18 at 19:18 -0500, Aguirre, Sergio wrote:
> Oops, fixing my own typo below:
> 
> > -----Original Message-----
> > From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> > owner@vger.kernel.org] On Behalf Of Aguirre, Sergio
> > Sent: Wednesday, August 18, 2010 7:16 PM
> > To: henrique@henriquecamargo.com; Mauro Carvalho Chehab
> > Cc: Guennadi Liakhovetski; Karicheri, Muralidharan; linux-
> > media@vger.kernel.org; linux-kernel@vger.kernel.org
> > Subject: RE: [PATCH] Fixes field names that changed
> > 
> > Hi Henrique,
> > 
> > Just some minor comments about the patch description below:
> > 
> > > -----Original Message-----
> > > From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> > > owner@vger.kernel.org] On Behalf Of Henrique Camargo
> > > Sent: Tuesday, August 17, 2010 9:35 AM
> > > To: Mauro Carvalho Chehab
> > > Cc: Guennadi Liakhovetski; Karicheri, Muralidharan; linux-
> > > media@vger.kernel.org; linux-kernel@vger.kernel.org
> > > Subject: [PATCH] Fixes field names that changed
> > 
> > Add missing subject prefix to quickly describe the affected driver:
> > 
> > Subject: [PATCH] mt9t032: Fixes field names that changed
> 
> mt9t032 -> mt9t031.
> 
> Sorry...
> 
> Regards,
> Sergio
> > 
> > >
> > > If CONFIG_VIDEO_ADV_DEBUG was set, the driver failed to compile because
> > > the fields get_register and set_register changed names to s_register and
> > > s_register in the struct v4l2_subdev_core_ops.
> > 
> > Please break down this comment to 70 chars max.
> > 
> > Also, you said "s_register" twice.
> > 
> > Regards,
> > Sergio
> > 
> > >
> > > Signed-off-by: Henrique Camargo <henrique@henriquecamargo.com>
> > > ---
> > >  drivers/media/video/mt9t031.c |    4 ++--
> > >  1 files changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/media/video/mt9t031.c
> > b/drivers/media/video/mt9t031.c
> > > index 716fea6..f3d1995 100644
> > > --- a/drivers/media/video/mt9t031.c
> > > +++ b/drivers/media/video/mt9t031.c
> > > @@ -499,8 +499,8 @@ static const struct v4l2_subdev_core_ops
> > > mt9t031_core_ops = {
> > >  	.g_ctrl	= mt9t031_get_control,
> > >  	.s_ctrl	= mt9t031_set_control,
> > >  #ifdef CONFIG_VIDEO_ADV_DEBUG
> > > -	.get_register = mt9t031_get_register,
> > > -	.set_register = mt9t031_set_register,
> > > +	.g_register = mt9t031_get_register,
> > > +	.s_register = mt9t031_set_register,
> > >  #endif
> > >  };
> > >
> > > --
> > > 1.7.0.4
> > >
> > >
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-media"
> > in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html


