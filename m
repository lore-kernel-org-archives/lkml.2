Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab1KZLk7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 06:40:59 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:36405 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394Ab1KZLk6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 06:40:58 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Axel Lin <axel.lin@gmail.com>
Subject: Re: [PATCH] [media] convert drivers/media/* to use module_platform_driver()
Date: Sat, 26 Nov 2011 12:40:59 +0100
User-Agent: KMail/1.13.7 (Linux/3.0.3-gentoo; KDE/4.7.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Richard =?utf-8?q?R=C3=B6jfors?= <richard.rojfors@pelagicore.com>,
        "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Muralidharan Karicheri <m-karicheri2@ti.com>,
        Anatolij Gustschin <agust@denx.de>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Jonathan Corbet <corbet@lwn.net>, Daniel Drake <dsd@laptop.org>,
        linux-media@vger.kernel.org
References: <1322290135.20464.1.camel@phoenix>
In-Reply-To: <1322290135.20464.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201111261240.59853.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Saturday 26 November 2011 07:48:55 Axel Lin wrote:
> This patch converts the drivers in drivers/media/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
> 
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: "Richard Röjfors" <richard.rojfors@pelagicore.com>
> Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
> Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>
> Cc: Manjunath Hadli <manjunath.hadli@ti.com>
> Cc: Muralidharan Karicheri <m-karicheri2@ti.com>
> Cc: Anatolij Gustschin <agust@denx.de>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Robert Jarzmik <robert.jarzmik@free.fr>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Daniel Drake <dsd@laptop.org>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/media/radio/radio-si4713.c         |   15 +----------
>  drivers/media/radio/radio-timb.c           |   15 +----------
>  drivers/media/radio/radio-wl1273.c         |   17 +-----------
>  drivers/media/video/davinci/dm355_ccdc.c   |   13 +---------
>  drivers/media/video/davinci/dm644x_ccdc.c  |   13 +---------
>  drivers/media/video/davinci/isif.c         |   13 +---------
>  drivers/media/video/davinci/vpbe.c         |   24 +-----------------
>  drivers/media/video/davinci/vpbe_display.c |   38 +------------------------
>  drivers/media/video/davinci/vpbe_osd.c     |   18 +------------
>  drivers/media/video/davinci/vpbe_venc.c    |   18 +------------
>  drivers/media/video/davinci/vpfe_capture.c |   18 +------------
>  drivers/media/video/fsl-viu.c              |   13 +---------
>  drivers/media/video/mx3_camera.c           |   14 +---------
>  drivers/media/video/omap1_camera.c         |   12 +--------
>  drivers/media/video/omap24xxcam.c          |   19 +-------------
>  drivers/media/video/omap3isp/isp.c         |   19 +-------------

For drivers/media/video/omap3isp/isp.c,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>  drivers/media/video/pxa_camera.c           |   14 +---------
>  drivers/media/video/s5p-g2d/g2d.c          |   16 +-----------
>  drivers/media/video/s5p-mfc/s5p_mfc.c      |   22 +---------------
>  drivers/media/video/s5p-tv/hdmi_drv.c      |   26 +------------------
>  drivers/media/video/s5p-tv/sdo_drv.c       |   22 +---------------
>  drivers/media/video/sh_mobile_csi2.c       |   13 +---------
>  drivers/media/video/soc_camera_platform.c  |   13 +---------
>  drivers/media/video/timblogiw.c            |   15 +----------
>  drivers/media/video/via-camera.c           |   12 +--------
>  25 files changed, 26 insertions(+), 406 deletions(-)

-- 
Regards,

Laurent Pinchart
