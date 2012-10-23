Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965620Ab2JWVIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:08:30 -0400
Received: from cnc.isely.net ([75.149.91.89]:59600 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933703Ab2JWVI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 17:08:28 -0400
X-Greylist: delayed 311 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Oct 2012 17:08:28 EDT
Date: Tue, 23 Oct 2012 16:03:16 -0500 (CDT)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely at pobox <isely@pobox.com>
To: Kees Cook <keescook@chromium.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mike Isely at pobox <isely@pobox.com>
Subject: Re: [PATCH 065/193] drivers/media/video/pvrusb2: remove
 CONFIG_EXPERIMENTAL
In-Reply-To: <1351022666-6960-66-git-send-email-keescook@chromium.org>
Message-ID: <alpine.DEB.2.00.1210231602370.26321@cnc.isely.net>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org> <1351022666-6960-66-git-send-email-keescook@chromium.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I never liked that designation in the first place, so no argument 
here...

Acked-By: Mike Isely <isely@pobox.com>


On Tue, 23 Oct 2012, Kees Cook wrote:

> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.
> 
> CC: Mike Isely <isely@pobox.com>
> CC: Mauro Carvalho Chehab <mchehab@infradead.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/media/usb/pvrusb2/Kconfig |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/usb/pvrusb2/Kconfig b/drivers/media/usb/pvrusb2/Kconfig
> index 32b11c1..60a2604 100644
> --- a/drivers/media/usb/pvrusb2/Kconfig
> +++ b/drivers/media/usb/pvrusb2/Kconfig
> @@ -17,9 +17,9 @@ config VIDEO_PVRUSB2
>  	  module will be called pvrusb2
>  
>  config VIDEO_PVRUSB2_SYSFS
> -	bool "pvrusb2 sysfs support (EXPERIMENTAL)"
> +	bool "pvrusb2 sysfs support"
>  	default y
> -	depends on VIDEO_PVRUSB2 && SYSFS && EXPERIMENTAL
> +	depends on VIDEO_PVRUSB2 && SYSFS
>  	---help---
>  	  This option enables the operation of a sysfs based
>  	  interface for query and control of the pvrusb2 driver.
> @@ -33,9 +33,9 @@ config VIDEO_PVRUSB2_SYSFS
>  	  Note: This feature is experimental and subject to change.
>  
>  config VIDEO_PVRUSB2_DVB
> -	bool "pvrusb2 ATSC/DVB support (EXPERIMENTAL)"
> +	bool "pvrusb2 ATSC/DVB support"
>  	default y
> -	depends on VIDEO_PVRUSB2 && DVB_CORE && EXPERIMENTAL
> +	depends on VIDEO_PVRUSB2 && DVB_CORE
>  	select DVB_LGDT330X if MEDIA_SUBDRV_AUTOSELECT
>  	select DVB_S5H1409 if MEDIA_SUBDRV_AUTOSELECT
>  	select DVB_S5H1411 if MEDIA_SUBDRV_AUTOSELECT
> 

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
