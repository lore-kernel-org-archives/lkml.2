Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480Ab1DKEFv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 00:05:51 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:56233 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750696Ab1DKEFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 00:05:51 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtQGAOp8ok15LHHJgWdsb2JhbACZAI0YFQEBFiYlwHUOhWAElQA
Date: Mon, 11 Apr 2011 14:05:44 +1000
From: Dave Chinner <david@fromorbit.com>
To: wanlong.gao@gmail.com
Cc: broonie@opensource.wolfsonmicro.com, geert@linux-m68k.org,
        starvik@axis.com, jesper.nilsson@axis.com, sameo@linux.intel.com,
        ian@opensource.wolfsonmicro.com, dp@opensource.wolfsonmicro.com,
        lrg@slimlogic.co.uk, James.Bottomley@suse.de, aelder@sgi.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs:removed the unused variable
Message-ID: <20110411040544.GB21395@dastard>
References: <1302444629-17043-1-git-send-email-wanlong.gao@gmail.com>
 <1302444629-17043-5-git-send-email-wanlong.gao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302444629-17043-5-git-send-email-wanlong.gao@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 10, 2011 at 10:10:29PM +0800, wanlong.gao@gmail.com wrote:
> From: Wanlong Gao <wanlong.gao@gmail.com>
> 
> removed the unused variable "bdi" of xfs_buf.c .
> 
> Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
> ---
>  fs/xfs/linux-2.6/xfs_buf.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
> index 5ea4020..a125b32 100644
> --- a/fs/xfs/linux-2.6/xfs_buf.c
> +++ b/fs/xfs/linux-2.6/xfs_buf.c
> @@ -657,8 +657,6 @@ xfs_buf_readahead(
>  	xfs_off_t		ioff,
>  	size_t			isize)
>  {
> -	struct backing_dev_info *bdi;
> -
>  	if (bdi_read_congested(target->bt_bdi))
>  		return;

<sigh>

Doesn't anyone look anymore to see if a problem has already been
reported before or fixed in the maintainers tree?

FYI, you're about the 5th person to send this same patch....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
