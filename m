Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab1EKPiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:38:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189Ab1EKPiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:38:14 -0400
Date: Wed, 11 May 2011 09:07:32 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blk-throttle: fix a typo in blk_throtl_init()
Message-ID: <20110511130732.GB31633@redhat.com>
References: <1305118862-4861-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305118862-4861-1-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 10:01:02PM +0900, Namhyung Kim wrote:
> s/td/tg/
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> ---
>  block/blk-throttle.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index 0475a22a420d..e7986b8a0085 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -1072,7 +1072,7 @@ int blk_throtl_init(struct request_queue *q)
>  	/* Practically unlimited BW */
>  	tg->bps[0] = tg->bps[1] = -1;
>  	tg->iops[0] = tg->iops[1] = -1;
> -	td->limits_changed = false;
> +	tg->limits_changed = false;
>  

Thanks Namhyung. I noticed it recently too. There is one more such typo
in throtl_find_alloc_tg(). Can you fix that too and repost the patch.

Thanks
Vivek
