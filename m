Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945Ab1FFKzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 06:55:42 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:35298 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752191Ab1FFKzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 06:55:41 -0400
Date: Mon, 6 Jun 2011 12:53:16 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Dave Airlie <airlied@linux.ie>
Cc: Greg Dietsche <Gregory.Dietsche@cuw.edu>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] savage: remove unecessary if statement
Message-ID: <20110606125316.312fad32@absol.kitzblitz>
In-Reply-To: <1307320332-31429-1-git-send-email-Gregory.Dietsche@cuw.edu>
References: <1307320332-31429-1-git-send-email-Gregory.Dietsche@cuw.edu>
Organization: -
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwAQMAAABtzGvEAAAAAXNSR0IArs4c6QAAAAZQTFRF
 AJnV/f/88sgWwwAAAKNJREFUGNM10LENwyAQheFHKCgZgTVSRHI2gy5reROTDSiREvnyHhdXnwXS+
 T+ACJgBYTiGSmDDOTdR7XDeTi9ksxEcoKFcTOCJLO7kC5SWFjPZCR69nI9+x5u6OJM1RN5UYUiNKa
 ZRpHHUoqh1v8hKEZ1FSGCrYOvgVmxd9DIXcSJwLTycm7bj0e4wkJGB48w/FckAwUKl/OGDZAcqItk
 BU+wHXLqKsjYyPeMAAAAASUVORK5CYII=
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg Dietsche <Gregory.Dietsche@cuw.edu>:
> the code always returns ret regardless, so if(ret) check is unecessary.
/unecessary/unnecessary/

> 
> Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
Reviewed-by: Nicolas Kaiser <nikai@nikai.net>

Best regards,
Nicolas Kaiser
> ---
>  drivers/gpu/drm/savage/savage_bci.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/savage/savage_bci.c b/drivers/gpu/drm/savage/savage_bci.c
> index bf5f83e..cb1ee4e 100644
> --- a/drivers/gpu/drm/savage/savage_bci.c
> +++ b/drivers/gpu/drm/savage/savage_bci.c
> @@ -647,9 +647,6 @@ int savage_driver_firstopen(struct drm_device *dev)
>  	ret = drm_addmap(dev, aperture_base, SAVAGE_APERTURE_SIZE,
>  			 _DRM_FRAME_BUFFER, _DRM_WRITE_COMBINING,
>  			 &dev_priv->aperture);
> -	if (ret)
> -		return ret;
> -
>  	return ret;
>  }
>  
