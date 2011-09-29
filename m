Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595Ab1I2UA4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 16:00:56 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:56755 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab1I2UAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 16:00:53 -0400
Date: Thu, 29 Sep 2011 13:00:49 -0700
From: Andrew Morton <akpm00@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] backlight: Rename corgibl_limit_intensity to
 genericbl_limit_intensity
Message-Id: <20110929130049.a3b56e19.akpm00@gmail.com>
In-Reply-To: <1316916753.5006.1.camel@phoenix>
References: <1316916753.5006.1.camel@phoenix>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Sep 2011 10:12:33 +0800
Axel Lin <axel.lin@gmail.com> wrote:

> The rename of corgibl_limit_intensity is missed in commit d00ba726
> "backlight: Rename the corgi backlight driver to generic".
> Let's fix it now.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> ---
>  drivers/video/backlight/generic_bl.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/video/backlight/generic_bl.c b/drivers/video/backlight/generic_bl.c
> index 8c6befd..adb1914 100644
> --- a/drivers/video/backlight/generic_bl.c
> +++ b/drivers/video/backlight/generic_bl.c
> @@ -56,7 +56,7 @@ static int genericbl_get_intensity(struct backlight_device *bd)
>   * Called when the battery is low to limit the backlight intensity.
>   * If limit==0 clear any limit, otherwise limit the intensity
>   */
> -void corgibl_limit_intensity(int limit)
> +void genericbl_limit_intensity(int limit)
>  {
>  	struct backlight_device *bd = generic_backlight_device;
>  
> @@ -68,7 +68,7 @@ void corgibl_limit_intensity(int limit)
>  	backlight_update_status(generic_backlight_device);
>  	mutex_unlock(&bd->ops_lock);
>  }
> -EXPORT_SYMBOL(corgibl_limit_intensity);
> +EXPORT_SYMBOL(genericbl_limit_intensity);
>  

Why does corgibl_limit_intensity/genericbl_limit_intensity exist? 
Nothing in the tree references it?

