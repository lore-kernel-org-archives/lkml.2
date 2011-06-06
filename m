Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab1FFJrD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 05:47:03 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:60545 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804Ab1FFJq7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 05:46:59 -0400
Date: Mon, 6 Jun 2011 11:46:56 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: soc_camera_video_start - type should be const
In-Reply-To: <1307306757-7068-1-git-send-email-geert@linux-m68k.org>
Message-ID: <Pine.LNX.4.64.1106061146070.11169@axis700.grange>
References: <1307306757-7068-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V02:K0:XZpfF2YUWs72c8RXkSG2iRFMxPz2TIyallF4VIvZVuD
 czFpeeZkv1ZF44oSSQw25ObZ/JrtaePoJwwvTfW1+hBrxDNWNB
 N4NOeT44UUKwScqAXgUG4oy9aRbfVBt539RMMFJDXR8iAy/YbN
 oIJFpY5HH0v/ajTRORA4xVg0PM+AsBkVrDcXaNM8NuFCJhPJtI
 czhgQUYZBt7dgI8JcM631oKlA2HS6PRSjmI3YwRdMU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert

On Sun, 5 Jun 2011, Geert Uytterhoeven wrote:

> drivers/media/video/soc_camera.c: In function ‘soc_camera_video_start’:
> drivers/media/video/soc_camera.c:1515: warning: initialization discards qualifiers from pointer target type
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  drivers/media/video/soc_camera.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
> index 3988643..4e4d412 100644
> --- a/drivers/media/video/soc_camera.c
> +++ b/drivers/media/video/soc_camera.c
> @@ -1512,7 +1512,7 @@ static int video_dev_create(struct soc_camera_device *icd)
>   */
>  static int soc_camera_video_start(struct soc_camera_device *icd)
>  {
> -	struct device_type *type = icd->vdev->dev.type;
> +	const struct device_type *type = icd->vdev->dev.type;
>  	int ret;
>  
>  	if (!icd->dev.parent)
> -- 
> 1.7.0.4

Thanks for the patchm unfortunately, you're not the first:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg32245.html

and not even the second;)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
