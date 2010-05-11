Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab0EKFT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 01:19:57 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35900 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186Ab0EKFTw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 01:19:52 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Date: Tue, 11 May 2010 10:49:37 +0530
Subject: RE: linux-next: manual merge of the v4l-dvb tree with Linus' tree
Thread-Topic: linux-next: manual merge of the v4l-dvb tree with Linus' tree
Thread-Index: Acrv2FSlRnadsU1aTWWw+XefsJNO5wA79crw
Message-ID: <19F8576C6E063C45BE387C64729E7394044E404AA4@dbde02.ent.ti.com>
References: <20100510103249.55e033bd.sfr@canb.auug.org.au>
In-Reply-To: <20100510103249.55e033bd.sfr@canb.auug.org.au>
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

> -----Original Message-----
> From: Stephen Rothwell [mailto:sfr@canb.auug.org.au]
> Sent: Monday, May 10, 2010 6:03 AM
> To: Mauro Carvalho Chehab
> Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Guennadi
> Liakhovetski; Hiremath, Vaibhav
> Subject: linux-next: manual merge of the v4l-dvb tree with Linus' tree
> 
> Hi Mauro,
> 
> Today's linux-next merge of the v4l-dvb tree got a conflict in
> drivers/media/video/Makefile between commit
> b704e82a54591d69816b45f4324caf143f1a6fc8 ("V4L/DVB: V4L - Makfile:Removed
> duplicate entry of davinci") from Linus' tree and commit
> 3b5ce90284aff5f8683cfd08e0e1b38f73ad0aa8 ("V4L/DVB: V4L: SuperH Video
> Output Unit (VOU) driver") from the v4l-dvb tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix
> for a while.
[Hiremath, Vaibhav] Thanks Stephen,

Looks ok to me.

Thanks,
Vaibhav

> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc drivers/media/video/Makefile
> index c51c386,cc93859..0000000
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@@ -160,6 -166,10 +166,8 @@@ obj-$(CONFIG_VIDEO_MX3)			+=
> mx3_camera
>   obj-$(CONFIG_VIDEO_PXA27x)		+= pxa_camera.o
>   obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
> 
>  -obj-$(CONFIG_ARCH_DAVINCI)		+= davinci/
>  -
> + obj-$(CONFIG_VIDEO_SH_VOU)		+= sh_vou.o
> +
>   obj-$(CONFIG_VIDEO_AU0828) += au0828/
> 
>   obj-$(CONFIG_USB_VIDEO_CLASS)	+= uvc/
