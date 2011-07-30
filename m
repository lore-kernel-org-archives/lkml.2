Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab1G3UgO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 16:36:14 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:52704 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab1G3UgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 16:36:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: Re: [PATCH] uvcvideo: correct kernel version reference
Date: Sat, 30 Jul 2011 22:36:12 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37-gentoo-r3; KDE/4.6.5; x86_64; ; )
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        jpiszcz@lucidpixels.com
References: <alpine.DEB.2.02.1107301020220.4925@p34.internal.lan> <1312040850-21475-1-git-send-email-Gregory.Dietsche@cuw.edu>
In-Reply-To: <1312040850-21475-1-git-send-email-Gregory.Dietsche@cuw.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107302236.13354.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Thanks for the patch.

On Saturday 30 July 2011 17:47:30 Greg Dietsche wrote:
> change from v2.6.42 to v3.2

This patch would be queued for v3.2. As the code it fixes will go away at the 
same time, it would be pretty pointless to apply it :-) Thanks for warning me 
though.

> Reported-by: Justin Piszcz <jpiszcz@lucidpixels.com>
> Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
> ---
>  drivers/media/video/uvc/uvc_v4l2.c |    2 +-
>  drivers/media/video/uvc/uvcvideo.h |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/uvc/uvc_v4l2.c
> b/drivers/media/video/uvc/uvc_v4l2.c index ea71d5f..6d6e3f9 100644
> --- a/drivers/media/video/uvc/uvc_v4l2.c
> +++ b/drivers/media/video/uvc/uvc_v4l2.c
> @@ -546,7 +546,7 @@ static void uvc_v4l2_ioctl_warn(void)
>  		return;
> 
>  	uvc_printk(KERN_INFO, "Deprecated UVCIOC_CTRL_{ADD,MAP_OLD,GET,SET} "
> -		   "ioctls will be removed in 2.6.42.\n");
> +		   "ioctls will be removed in 3.2.\n");
>  	uvc_printk(KERN_INFO, "See http://www.ideasonboard.org/uvc/upgrade/ "
>  		   "for upgrade instructions.\n");
>  	warned = 1;
> diff --git a/drivers/media/video/uvc/uvcvideo.h
> b/drivers/media/video/uvc/uvcvideo.h index df32a43..4419c34 100644
> --- a/drivers/media/video/uvc/uvcvideo.h
> +++ b/drivers/media/video/uvc/uvcvideo.h
> @@ -7,7 +7,7 @@
>  #ifndef __KERNEL__
>  /*
>   * This header provides binary compatibility with applications using the
> private - * uvcvideo API. This API is deprecated and will be removed in
> 2.6.42. + * uvcvideo API. This API is deprecated and will be removed in
> 3.2. * Applications should be recompiled against the public
> linux/uvcvideo.h header. */
>  #warn "The uvcvideo.h header is deprecated, use linux/uvcvideo.h instead."

-- 
Regards,

Laurent Pinchart
