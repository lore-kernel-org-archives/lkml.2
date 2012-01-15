Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab2AOW3O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 17:29:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603Ab2AOW3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 17:29:13 -0500
Date: Sun, 15 Jan 2012 17:29:00 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Jesper Juhl <jj@chaosbits.net>
cc: dm-devel@redhat.com, Neil Brown <neilb@suse.de>,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH] There's no need to include linux/version.h in
 drivers/md/dm-bufio.c
In-Reply-To: <alpine.LNX.2.00.1201152110290.13389@swampdragon.chaosbits.net>
Message-ID: <Pine.LNX.4.64.1201151728510.26479@hs20-bc2-1.build.redhat.com>
References: <alpine.LNX.2.00.1201152110290.13389@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Mikulas Patocka <mpatocka@redhat.com>

On Sun, 15 Jan 2012, Jesper Juhl wrote:

> As 'make versioncheck' points out, drivers/md/dm-bufio.c has no need
> to include linux/version.h, so this patch removes the unneeded
> include.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  drivers/md/dm-bufio.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> index 0a6806f..b6e58c7 100644
> --- a/drivers/md/dm-bufio.c
> +++ b/drivers/md/dm-bufio.c
> @@ -12,7 +12,6 @@
>  #include <linux/dm-io.h>
>  #include <linux/slab.h>
>  #include <linux/vmalloc.h>
> -#include <linux/version.h>
>  #include <linux/shrinker.h>
>  #include <linux/module.h>
>  
> -- 
> 1.7.8.3
> 
> 
> -- 
> Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
> Don't top-post http://www.catb.org/jargon/html/T/top-post.html
> Plain text mails only, please.
> 
