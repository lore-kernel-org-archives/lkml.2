Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049Ab1FWWMk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 18:12:40 -0400
Received: from cobra.newdream.net ([66.33.216.30]:33575 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759896Ab1FWWMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 18:12:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:in-reply-to:message-id:references:mime-version:
	content-type; q=dns; s=newdream.net; b=4OMQvyWe3+i+QNveeo/871Sja
	ST7bh1tDno7WHK7YQJGdAJALZUUJ/Gznl9VZgT5TtjuY8txsVf6uCuTQOMddH02m
	Zc9FBqTFogngjw3ZlDkVJo2MA+DEOwLXwKYV2k4ihf9XH/gZE/8LpsDrXAJz1EIn
	vUek6Xj7OvuY0EeBe8=
Date: Thu, 23 Jun 2011 15:15:11 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Jesper Juhl <jj@chaosbits.net>
cc: LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org,
        linux-media@vger.kernel.org, ceph-devel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 03/37] Remove unneeded version.h includes from include/
In-Reply-To: <alpine.LNX.2.00.1106232356530.17688@swampdragon.chaosbits.net>
Message-ID: <Pine.LNX.4.64.1106231514530.6417@cobra.newdream.net>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
 <alpine.LNX.2.00.1106232356530.17688@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jun 2011, Jesper Juhl wrote:

> It was pointed out by 'make versioncheck' that some includes of
> linux/version.h were not needed in include/.
> This patch removes them.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Acked-by: Sage Weil <sage@newdream.net>

for the ceph bit.

sage

> ---
>  include/linux/ceph/messenger.h |    1 -
>  include/media/pwc-ioctl.h      |    1 -
>  2 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
> index 31d91a6..291aa6e 100644
> --- a/include/linux/ceph/messenger.h
> +++ b/include/linux/ceph/messenger.h
> @@ -6,7 +6,6 @@
>  #include <linux/net.h>
>  #include <linux/radix-tree.h>
>  #include <linux/uio.h>
> -#include <linux/version.h>
>  #include <linux/workqueue.h>
>  
>  #include "types.h"
> diff --git a/include/media/pwc-ioctl.h b/include/media/pwc-ioctl.h
> index 0f19779..1ed1e61 100644
> --- a/include/media/pwc-ioctl.h
> +++ b/include/media/pwc-ioctl.h
> @@ -53,7 +53,6 @@
>   */
>  
>  #include <linux/types.h>
> -#include <linux/version.h>
>  
>  /* Enumeration of image sizes */
>  #define PSZ_SQCIF	0x00
> -- 
> 1.7.5.2
> 
> 
> -- 
> Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
> Don't top-post http://www.catb.org/jargon/html/T/top-post.html
> Plain text mails only, please.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
