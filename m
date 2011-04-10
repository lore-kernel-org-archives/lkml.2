Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab1DJPHS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 11:07:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:55158 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165Ab1DJPHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 11:07:16 -0400
Date: Sun, 10 Apr 2011 08:07:15 -0700 (PDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm: radeon: Fix printk typo 'ib poll'
In-Reply-To: <1300307820.1954.8.camel@t41.thuisdomein>
Message-ID: <alpine.LNX.2.00.1104081929560.6392@deuxcents.site>
References: <1300307820.1954.8.camel@t41.thuisdomein>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Mar 2011, Paul Bolle wrote:

> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
>  drivers/gpu/drm/radeon/radeon_ring.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpu/drm/radeon/radeon_ring.c b/drivers/gpu/drm/radeon/radeon_ring.c
> index 239c3d7..6709182 100644
> --- a/drivers/gpu/drm/radeon/radeon_ring.c
> +++ b/drivers/gpu/drm/radeon/radeon_ring.c
> @@ -194,7 +194,7 @@ int radeon_ib_pool_init(struct radeon_device *rdev)
>  	r = radeon_bo_kmap(rdev->ib_pool.robj, &ptr);
>  	radeon_bo_unreserve(rdev->ib_pool.robj);
>  	if (r) {
> -		DRM_ERROR("radeon: failed to map ib poll (%d).\n", r);
> +		DRM_ERROR("radeon: failed to map ib pool (%d).\n", r);
>  		return r;
>  	}
>  	for (i = 0; i < RADEON_IB_POOL_SIZE; i++) {

Applied.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

