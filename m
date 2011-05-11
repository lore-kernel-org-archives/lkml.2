Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360Ab1EKQRN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:17:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756164Ab1EKQRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:17:06 -0400
Date: Wed, 11 May 2011 09:30:33 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blk-throttle: fix typos on struct throtl_grp init code
Message-ID: <20110511133033.GD31633@redhat.com>
References: <20110511130732.GB31633@redhat.com>
 <1305120045-5111-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305120045-5111-1-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 10:20:45PM +0900, Namhyung Kim wrote:
> s/td/tg/

I think jens would like to have little more changelog than that.

Otherwise looks good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> ---
>  block/blk-throttle.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index 0475a22a420d..d1e317e0fc34 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -201,7 +201,7 @@ static struct throtl_grp * throtl_find_alloc_tg(struct throtl_data *td,
>  	RB_CLEAR_NODE(&tg->rb_node);
>  	bio_list_init(&tg->bio_lists[0]);
>  	bio_list_init(&tg->bio_lists[1]);
> -	td->limits_changed = false;
> +	tg->limits_changed = false;
>  
>  	/*
>  	 * Take the initial reference that will be released on destroy
> @@ -1072,7 +1072,7 @@ int blk_throtl_init(struct request_queue *q)
>  	/* Practically unlimited BW */
>  	tg->bps[0] = tg->bps[1] = -1;
>  	tg->iops[0] = tg->iops[1] = -1;
> -	td->limits_changed = false;
> +	tg->limits_changed = false;
>  
>  	/*
>  	 * Set root group reference to 2. One reference will be dropped when
> -- 
> 1.7.5
