Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab2I1CQL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 22:16:11 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1421 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952Ab2I1CQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 22:16:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 27 Sep 2012 19:15:59 -0700
From: Alex Courbot <acourbot@nvidia.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arun Murthy <arun.murthy@stericsson.com>,
        Matthew Garrett <mjg@redhat.com>, Robert Morell <rmorell@nvidia.com>,
        Dilan Lee <dilee@nvidia.com>, Axel Lin <axel.lin@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Sachin Kamat <sachin.kamat@linaro.org>
Subject: Re: [PATCH] pwm-backlight: Take over maintenance
Date: Fri, 28 Sep 2012 11:18:06 +0900
Message-ID: <1608992.fV4uusRRUm@percival>
Organization: NVIDIA
User-Agent: KMail/4.9.1 (Linux/3.5.3-1-ARCH; KDE/4.9.1; x86_64; ; )
In-Reply-To: <1348138235-3625-1-git-send-email-thierry.reding@avionic-design.de>
References: <1348138235-3625-1-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 September 2012 18:50:35 Thierry Reding wrote:
> Since the pwm-backlight driver is lacking a proper maintainer and is the
> heaviest user of the PWM framework I'm taking over maintenance.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> Cc: Arun Murthy <arun.murthy@stericsson.com>
> Cc: Matthew Garrett <mjg@redhat.com>
> Cc: Robert Morell <rmorell@nvidia.com>
> Cc: Dilan Lee <dilee@nvidia.com>
> Cc: Axel Lin <axel.lin@gmail.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Alexandre Courbot <acourbot@nvidia.com>
> Cc: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
> Andrew: As previously discussed this patch makes me the new maintainer
> for the pwm-backlight driver. I contacted Richard Purdie and requested
> his Acked-by for this because he's the backlight subsystem maintainer.
> Unfortunately he hasn't answered yet. Looking at the commit log, every
> commit in the last 2+ years has gone through your tree, which seems to
> be reason enough for me to take over this driver but I still wanted to
> get an Acked-by at least from you so that this doesn't look like
> hijacking. I've also Cc'ed a couple of people that have done work on
> the driver in the past to give them a chance to object or send their
> Acked-by.

Probably too late, but:

Acked-by: Alexandre Courbot <acourbot@nvidia.com>

> 
> Obviously I will take this patch through my tree so this is not a
> request to include it in your tree.
> 
>  MAINTAINERS | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 61ad79e..a6f023e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5543,6 +5543,8 @@ F:	Documentation/devicetree/bindings/pwm/
>  F:	include/linux/pwm.h
>  F:	include/linux/of_pwm.h
>  F:	drivers/pwm/
> +F:	drivers/video/backlight/pwm_bl.c
> +F:	include/linux/pwm_backlight.h
> 
>  PXA2xx/PXA3xx SUPPORT
>  M:	Eric Miao <eric.y.miao@gmail.com>
