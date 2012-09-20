Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab2ITO4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 10:56:31 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:40745 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409Ab2ITO4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 10:56:30 -0400
MIME-Version: 1.0
In-Reply-To: <1348138235-3625-1-git-send-email-thierry.reding@avionic-design.de>
References: <1348138235-3625-1-git-send-email-thierry.reding@avionic-design.de>
Date: Thu, 20 Sep 2012 20:26:28 +0530
Message-ID: <CAK9yfHyzJ5MsuPakn3coccYdmfMk_miVFbGr76ybKZxX5Lqd2A@mail.gmail.com>
Subject: Re: [PATCH] pwm-backlight: Take over maintenance
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Arun Murthy <arun.murthy@stericsson.com>,
        Matthew Garrett <mjg@redhat.com>, Robert Morell <rmorell@nvidia.com>,
        Dilan Lee <dilee@nvidia.com>, Axel Lin <axel.lin@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 September 2012 16:20, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
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

Acked-by: Sachin Kamat <sachin.kamat@linaro.org>


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
> @@ -5543,6 +5543,8 @@ F:        Documentation/devicetree/bindings/pwm/
>  F:     include/linux/pwm.h
>  F:     include/linux/of_pwm.h
>  F:     drivers/pwm/
> +F:     drivers/video/backlight/pwm_bl.c
> +F:     include/linux/pwm_backlight.h
>
>  PXA2xx/PXA3xx SUPPORT
>  M:     Eric Miao <eric.y.miao@gmail.com>
> --
> 1.7.12
>



-- 
With warm regards,
Sachin
