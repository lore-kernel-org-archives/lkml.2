Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab2GSKlJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 06:41:09 -0400
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51631 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751026Ab2GSKlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 06:41:07 -0400
X-Greylist: delayed 607 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jul 2012 06:41:07 EDT
Date: Thu, 19 Jul 2012 13:30:55 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Duan Jiong <djduanjiong@gmail.com>
Cc: mchehab@infradead.org, sakari.ailus@maxwell.research.nokia.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smiapp-core.c: remove duplicated include
Message-ID: <20120719103055.GD22859@valkosipuli.retiisi.org.uk>
References: <5006CA58.8080301@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5006CA58.8080301@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Duan,

On Wed, Jul 18, 2012 at 10:38:16PM +0800, Duan Jiong wrote:
> 
> Signed-off-by: Duan Jiong <djduanjiong@gmail.com>
> ---
>  drivers/media/video/smiapp/smiapp-core.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/media/video/smiapp/smiapp-core.c b/drivers/media/video/smiapp/smiapp-core.c
> index 9cf5bda..297acaf 100644
> --- a/drivers/media/video/smiapp/smiapp-core.c
> +++ b/drivers/media/video/smiapp/smiapp-core.c
> @@ -33,7 +33,6 @@
>  #include <linux/module.h>
>  #include <linux/slab.h>
>  #include <linux/regulator/consumer.h>
> -#include <linux/slab.h>
>  #include <linux/v4l2-mediabus.h>
>  #include <media/v4l2-device.h>

Thanks for the patch.

I'll apply it into my tree, with the change that the other slab.h is removed
--- that keeps the include files in alphabetical order.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
