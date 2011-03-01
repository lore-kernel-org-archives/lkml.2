Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab1CAOTJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 09:19:09 -0500
Received: from cantor.suse.de ([195.135.220.2]:49829 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061Ab1CAOTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 09:19:08 -0500
Date: Tue, 1 Mar 2011 15:19:06 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm: fix printk typo 'sracth'
In-Reply-To: <1298151270.1977.5.camel@t41.thuisdomein>
Message-ID: <alpine.LNX.2.00.1103011518530.32580@pobox.suse.cz>
References: <1298151270.1977.5.camel@t41.thuisdomein>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Feb 2011, Paul Bolle wrote:

> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> A similar patch was sent three weeks ago, this version is rebased
> against current for-next.
> 
>  drivers/gpu/drm/radeon/r100.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
> index ac493ec..a78d09f 100644
> --- a/drivers/gpu/drm/radeon/r100.c
> +++ b/drivers/gpu/drm/radeon/r100.c
> @@ -3584,7 +3584,7 @@ int r100_ib_test(struct radeon_device *rdev)
>  	if (i < rdev->usec_timeout) {
>  		DRM_INFO("ib test succeeded in %u usecs\n", i);
>  	} else {
> -		DRM_ERROR("radeon: ib test failed (sracth(0x%04X)=0x%08X)\n",
> +		DRM_ERROR("radeon: ib test failed (scratch(0x%04X)=0x%08X)\n",
>  			  scratch, tmp);
>  		r = -EINVAL;
>  	}

Seems to be still present in linux-next as of today. I have picked it up.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
