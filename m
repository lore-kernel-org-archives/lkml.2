Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab2BDOgF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 09:36:05 -0500
Received: from smtp-68.nebula.fi ([83.145.220.68]:33658 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab2BDOgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 09:36:03 -0500
Date: Sat, 4 Feb 2012 16:35:58 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
        Tuukka Toivonen <tuukkat76@gmail.com>
Subject: Re: [PATCH] media, adp1653: Remove unneeded include of version.h
 from drivers/media/video/adp1653.c
Message-ID: <20120204143558.GA7784@valkosipuli.localdomain>
References: <alpine.LNX.2.00.1202022212550.16813@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1202022212550.16813@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesper,

On Thu, Feb 02, 2012 at 10:15:06PM +0100, Jesper Juhl wrote:
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  drivers/media/video/adp1653.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
>   compile tested only.
> 
> diff --git a/drivers/media/video/adp1653.c b/drivers/media/video/adp1653.c
> index 12eedf4..badbdb6 100644
> --- a/drivers/media/video/adp1653.c
> +++ b/drivers/media/video/adp1653.c
> @@ -35,7 +35,6 @@
>  #include <linux/i2c.h>
>  #include <linux/module.h>
>  #include <linux/slab.h>
> -#include <linux/version.h>
>  #include <media/adp1653.h>
>  #include <media/v4l2-device.h>

Thanks for the patch! I've applied it to my tree --- plus removing extra
module.h at the same time.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
