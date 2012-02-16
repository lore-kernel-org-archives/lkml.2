Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab2BPAw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 19:52:26 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:58659 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674Ab2BPAwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 19:52:23 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Danny Kukawka <dkukawka@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Javier Martin <javier.martin@vista-silicon.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mt9p031.c included media/v4l2-subdev.h twice
Date: Thu, 16 Feb 2012 01:52:22 +0100
Message-ID: <3038951.aMMalgvgKS@avalon>
User-Agent: KMail/4.8.0 (Linux/3.2.1-gentoo-r2; KDE/4.8.0; x86_64; ; )
In-Reply-To: <1329333655-32103-1-git-send-email-danny.kukawka@bisect.de>
References: <1329333655-32103-1-git-send-email-danny.kukawka@bisect.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Danny,

Thanks for the patch.

On Wednesday 15 February 2012 20:20:55 Danny Kukawka wrote:
> drivers/media/video/mt9p031.c included 'media/v4l2-subdev.h' twice,
> remove the duplicate.
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I'll push the patch through my tree.

> ---
>  drivers/media/video/mt9p031.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/mt9p031.c b/drivers/media/video/mt9p031.c
> index 93c3ec7..dd937df 100644
> --- a/drivers/media/video/mt9p031.c
> +++ b/drivers/media/video/mt9p031.c
> @@ -19,7 +19,6 @@
>  #include <linux/log2.h>
>  #include <linux/pm.h>
>  #include <linux/slab.h>
> -#include <media/v4l2-subdev.h>
>  #include <linux/videodev2.h>
> 
>  #include <media/mt9p031.h>

-- 
Regards,

Laurent Pinchart
