Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759582Ab1KWBxY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 20:53:24 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:48352 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab1KWBxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 20:53:23 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Dmitry Artamonow <mad_soft@inbox.ru>
Subject: Re: [PATCH] [media] omap3isp: fix compilation of ispvideo.c
Date: Wed, 23 Nov 2011 02:53:20 +0100
User-Agent: KMail/1.13.7 (Linux/3.0.3-gentoo; KDE/4.7.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org
References: <1321808066-1791-1-git-send-email-mad_soft@inbox.ru>
In-Reply-To: <1321808066-1791-1-git-send-email-mad_soft@inbox.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201111230253.21007.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Sunday 20 November 2011 17:54:26 Dmitry Artamonow wrote:
> Fix following build error by explicitely including <linux/module.h>
> header file.
> 
>   CC      drivers/media/video/omap3isp/ispvideo.o
> drivers/media/video/omap3isp/ispvideo.c:1267: error: 'THIS_MODULE'
> undeclared here (not in a function) make[4]: ***
> [drivers/media/video/omap3isp/ispvideo.o] Error 1
> make[3]: *** [drivers/media/video/omap3isp] Error 2
> make[2]: *** [drivers/media/video] Error 2
> make[1]: *** [drivers/media] Error 2
> make: *** [drivers] Error 2
> 
> Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Mauro, can you pick this for v3.2, or would you like me to send a pull request 
?

> ---
>  drivers/media/video/omap3isp/ispvideo.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/omap3isp/ispvideo.c
> b/drivers/media/video/omap3isp/ispvideo.c index d100072..f229057 100644
> --- a/drivers/media/video/omap3isp/ispvideo.c
> +++ b/drivers/media/video/omap3isp/ispvideo.c
> @@ -26,6 +26,7 @@
>  #include <asm/cacheflush.h>
>  #include <linux/clk.h>
>  #include <linux/mm.h>
> +#include <linux/module.h>
>  #include <linux/pagemap.h>
>  #include <linux/scatterlist.h>
>  #include <linux/sched.h>

-- 
Regards,

Laurent Pinchart
