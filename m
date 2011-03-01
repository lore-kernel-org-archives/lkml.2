Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab1CAOUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 09:20:15 -0500
Received: from cantor.suse.de ([195.135.220.2]:49844 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982Ab1CAOUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 09:20:13 -0500
Date: Tue, 1 Mar 2011 15:20:11 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Paul Bolle <pebolle@tiscali.nl>, David Airlie <airlied@linux.ie>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] drm: drop commented out code and preceding
 comment
In-Reply-To: <1298151381.1977.7.camel@t41.thuisdomein>
Message-ID: <alpine.LNX.2.00.1103011519340.32580@pobox.suse.cz>
References: <1298151381.1977.7.camel@t41.thuisdomein>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Feb 2011, Paul Bolle wrote:

> r100_gpu_init() was dropped in 90aca4d ("drm/radeon/kms: simplify &
> improve GPU reset V2") but here it was only commented out.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
>  drivers/gpu/drm/radeon/r100.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
> index ac493ec..e0f7fd9 100644
> --- a/drivers/gpu/drm/radeon/r100.c
> +++ b/drivers/gpu/drm/radeon/r100.c
> @@ -3746,8 +3746,6 @@ static int r100_startup(struct radeon_device *rdev)
>  	r100_mc_program(rdev);
>  	/* Resume clock */
>  	r100_clock_startup(rdev);
> -	/* Initialize GPU configuration (# pipes, ...) */
> -//	r100_gpu_init(rdev);
>  	/* Initialize GART (initialize after TTM so we can allocate
>  	 * memory through TTM but finalize after TTM) */
>  	r100_enable_bm(rdev);

Dave, going to pick this one up?

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
