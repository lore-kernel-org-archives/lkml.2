Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182Ab0FIWdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 18:33:44 -0400
Received: from www.tglx.de ([62.245.132.106]:36514 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758024Ab0FIWdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 18:33:41 -0400
Date: Thu, 10 Jun 2010 00:32:50 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ben Nizette <bn@niasdigital.com>
Subject: Re: [PATCH 08/12] MAINTAINERS: Remove section SMX UIO Interface
Message-ID: <20100609223249.GA2555@local>
References: <cover.1276112117.git.joe@perches.com>
 <864afd7fe86e75278b76c1f32f2c85306c98d6e6.1276112117.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <864afd7fe86e75278b76c1f32f2c85306c98d6e6.1276112117.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 09, 2010 at 12:38:34PM -0700, Joe Perches wrote:
> commit d6e976c0d258c9547a308bd8a9a82ec93e2bc6e2
> removed the file

oops, I forgot the MAINTAINERS entry when I removed the driver.
Thank you for cleaning up these things!

Hans

> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Hans J. Koch <hjk@linutronix.de>

> Cc: Ben Nizette <bn@niasdigital.com>
> ---
>  MAINTAINERS |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 765322e..8aac474 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5226,11 +5226,6 @@ L:	netdev@vger.kernel.org
>  S:	Supported
>  F:	drivers/net/smsc9420.*
>  
> -SMX UIO Interface
> -M:	Ben Nizette <bn@niasdigital.com>
> -S:	Maintained
> -F:	drivers/uio/uio_smx.c
> -
>  SN-IA64 (Itanium) SUB-PLATFORM
>  M:	Jes Sorensen <jes@sgi.com>
>  L:	linux-altix@sgi.com
> -- 
> 1.7.1.244.gbdc4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
