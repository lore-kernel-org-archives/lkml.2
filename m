Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab1HZHkG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 03:40:06 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49217 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab1HZHkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 03:40:04 -0400
Date: Fri, 26 Aug 2011 15:39:48 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Zhao Jin <cronozhj@gmail.com>
Cc: cl@linux-foundation.org, penberg@kernel.org, mpm@selenic.com,
        trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: trivial: cleanup: remove unneeded return
Message-ID: <20110826073948.GA29130@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <CADqbE94+eZPeMggwkeZsXYxmkCRddRT7OXeiEyj_b3m=g5GxUQ@mail.gmail.com>
 <CADqbE97+FKz-7op-nmdOVmq3mrXadaxQrtk9Zud90E7iMMEUVQ@mail.gmail.com>
 <4E573F68.1020603@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4E573F68.1020603@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 02:38:32PM +0800, Zhao Jin wrote:
> Terribly sorry. It was gmail who wrapped the line.
> Please see this following version. Thanks!

You can use git send-email instead or mail client,

Thanks,
Yong
> 
> ---
>  mm/slab.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/slab.c b/mm/slab.c
> index 6d90a09..82e0a0e 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -3678,13 +3678,12 @@ static inline void __cache_free(struct
> kmem_cache *cachep, void *objp,
> 
>      if (likely(ac->avail < ac->limit)) {
>          STATS_INC_FREEHIT(cachep);
> -        ac->entry[ac->avail++] = objp;
> -        return;
>      } else {
>          STATS_INC_FREEMISS(cachep);
>          cache_flusharray(cachep, ac);
> -        ac->entry[ac->avail++] = objp;
>      }
> +
> +    ac->entry[ac->avail++] = objp;
>  }
> 
>  /**
> -- 
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Only stand for myself
