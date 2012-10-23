Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933449Ab2JWVnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:43:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:51138 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932796Ab2JWVnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 17:43:06 -0400
Date: Tue, 23 Oct 2012 19:42:58 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 063/193] drivers/media: remove CONFIG_EXPERIMENTAL
Message-ID: <20121023194258.465965c5@infradead.org>
In-Reply-To: <1351022666-6960-64-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
	<1351022666-6960-64-git-send-email-keescook@chromium.org>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kees,

Em Tue, 23 Oct 2012 13:02:16 -0700
Kees Cook <keescook@chromium.org> escreveu:

> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.
> 
> CC: Mauro Carvalho Chehab <mchehab@infradead.org>

For all patches on this series that you c/c me:

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/media/Kconfig |    7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
> index 4ef0d80..8567a7a 100644
> --- a/drivers/media/Kconfig
> +++ b/drivers/media/Kconfig
> @@ -79,8 +79,7 @@ config MEDIA_RC_SUPPORT
>  #
>  
>  config MEDIA_CONTROLLER
> -	bool "Media Controller API (EXPERIMENTAL)"
> -	depends on EXPERIMENTAL
> +	bool "Media Controller API"
>  	depends on MEDIA_CAMERA_SUPPORT
>  	---help---
>  	  Enable the media controller API used to query media devices internal
> @@ -100,8 +99,8 @@ config VIDEO_DEV
>  	default y
>  
>  config VIDEO_V4L2_SUBDEV_API
> -	bool "V4L2 sub-device userspace API (EXPERIMENTAL)"
> -	depends on VIDEO_DEV && MEDIA_CONTROLLER && EXPERIMENTAL
> +	bool "V4L2 sub-device userspace API"
> +	depends on VIDEO_DEV && MEDIA_CONTROLLER
>  	---help---
>  	  Enables the V4L2 sub-device pad-level userspace API used to configure
>  	  video format, size and frame rate between hardware blocks.




Cheers,
Mauro
