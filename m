Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab2HTECk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:02:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64908 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914Ab2HTECf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 00:02:35 -0400
Date: Mon, 20 Aug 2012 14:02:38 +1000
From: Ben Skeggs <skeggsb@gmail.com>
To: Daniel J Blueman <daniel@quora.org>
Cc: Ryan Bourgeois <bluedragonx@gmail.com>, Dave Airlie <airlied@linux.ie>,
        nouveau@lists.freedesktop.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Nouveau] nouveau Macbook EDID fix upstreaming...
Message-ID: <20120820040237.GA3207@nisroch.redhat.com>
References: <CAMVG2ssDVjwm2Fp6gBTKg2=MqWMDoO1_FpqoXOnskz5W58Unkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMVG2ssDVjwm2Fp6gBTKg2=MqWMDoO1_FpqoXOnskz5W58Unkg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 04:33:25PM +0800, Daniel J Blueman wrote:
> It looks like Ryan's Nouveau patch [1,2] to get the I2C working for
> EDID (thus modelines) is crucial for avoiding the Nvidia binary
> drivers on MacbookPro 2012s.
> 
> Any plans/chance for it to be upstreamed to eg 3.6-rc3?
Not at this stage, no.  I don't believe this is likely to be the correct fix.  I should have access to one of the new mbp systems in the near future and I'll investigate it further then.

Cheers,
Ben.

> 
> Many thanks,
>   Daniel
> 
> --- [1]
> 
> diff -urNp a/drivers/gpu/drm/nouveau/nouveau_bios.c
> b/drivers/gpu/drm/nouveau/nouveau_bios.c
> --- a/drivers/gpu/drm/nouveau/nouveau_bios.c	2012-07-08 22:48:05.589828510 -0500
> +++ b/drivers/gpu/drm/nouveau/nouveau_bios.c	2012-07-15 00:28:18.578864693 -0500
> @@ -6461,6 +6461,9 @@ nouveau_run_vbios_init(struct drm_device
>  		}
>  	}
> 
> +	if (!bios->execute)
> +		nouveau_gpio_reset(dev);
> +
>  	return ret;
>  }
> 
> [2] https://bugs.freedesktop.org/show_bug.cgi?id=51971
> -- 
> Daniel J Blueman
> _______________________________________________
> Nouveau mailing list
> Nouveau@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/nouveau
