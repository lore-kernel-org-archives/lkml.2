Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344Ab0LGLnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 06:43:50 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39185 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab0LGLnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 06:43:49 -0500
Date: Tue, 7 Dec 2010 11:43:46 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
        lrg@slimlogic.co.uk
Subject: Re: [PATCH 29/29] drivers/regulator: Update WARN uses
Message-ID: <20101207114346.GC10722@sirena.org.uk>
References: <b0588ea464d551f9dbd80c0fee68a780d6279b50.1291670106.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0588ea464d551f9dbd80c0fee68a780d6279b50.1291670106.git.joe@perches.com>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 06, 2010 at 02:05:19PM -0800, Joe Perches wrote:
> Align arguments.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

but please do remember to send patches to maintainers - trying to merge
patches without going through the maintainers means that people working
on the actual tree concerned may either replicate your work or introduce
conflicts with your patches, neither of which is good.

Not cutting the patch for Liam's benefit:

> ---
>  drivers/regulator/core.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index a1b1237..5d07e5d 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -1379,8 +1379,7 @@ static int _regulator_disable(struct regulator_dev *rdev,
>  	*supply_rdev_ptr = NULL;
>  
>  	if (WARN(rdev->use_count <= 0,
> -			"unbalanced disables for %s\n",
> -			rdev_get_name(rdev)))
> +		 "unbalanced disables for %s\n", rdev_get_name(rdev)))
>  		return -EIO;
>  
>  	/* are we the last user and permitted to disable ? */
> -- 
> 1.7.3.2.245.g03276.dirty
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
"You grabbed my hand and we fell into it, like a daydream - or a fever."
