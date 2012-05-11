Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532Ab2EKED4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 00:03:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47846 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab2EKEDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 00:03:55 -0400
Date: Thu, 10 May 2012 21:03:51 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: peter.ujfalusi@ti.com, broonie@opensource.wolfsonicro.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] TWL6040: fix build error
Message-ID: <20120511040351.GA31496@core.coreip.homeip.net>
References: <1336675473-24774-1-git-send-email-levinsasha928@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336675473-24774-1-git-send-email-levinsasha928@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sasha,

On Thu, May 10, 2012 at 08:44:33PM +0200, Sasha Levin wrote:
> Fixes build error due to missing of_property_read_u32.
> 
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> ---
>  drivers/input/misc/twl6040-vibra.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/misc/twl6040-vibra.c b/drivers/input/misc/twl6040-vibra.c
> index bb134ce..97447ee 100644
> --- a/drivers/input/misc/twl6040-vibra.c
> +++ b/drivers/input/misc/twl6040-vibra.c
> @@ -27,6 +27,7 @@
>   */
>  #include <linux/module.h>
>  #include <linux/platform_device.h>
> +#include <linux/of.h>
>  #include <linux/of_device.h>
>  #include <linux/workqueue.h>
>  #include <linux/input.h>

Thank you for the fix; I folded it into original patch to avoid bisection
troubles.

-- 
Dmitry
