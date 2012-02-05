Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab2BEW7P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:59:15 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:29122 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab2BEW7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:59:14 -0500
Date: Sun, 5 Feb 2012 23:59:43 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Masanari Iida <standby24x7@gmail.com>
cc: airlied@linux.ie, dri-devel@lists.freedesktop.org, trivial@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [trivial] drm: Fix typo in vmwgfx_drv.c
In-Reply-To: <1328449836-1752-1-git-send-email-standby24x7@gmail.com>
Message-ID: <alpine.LNX.2.00.1202052359120.32529@swampdragon.chaosbits.net>
References: <1328449836-1752-1-git-send-email-standby24x7@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Feb 2012, Masanari Iida wrote:

> Correct spelling "unsuported" to "unsupported" in
> drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Reviewed-by: Jesper Juhl <jj@chaosbits.net>


> ---
>  drivers/gpu/drm/vmwgfx/vmwgfx_drv.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
> index f390f5f..2d6f573 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
> @@ -430,7 +430,7 @@ static int vmw_driver_load(struct drm_device *dev, unsigned long chipset)
>  	svga_id = vmw_read(dev_priv, SVGA_REG_ID);
>  	if (svga_id != SVGA_ID_2) {
>  		ret = -ENOSYS;
> -		DRM_ERROR("Unsuported SVGA ID 0x%x\n", svga_id);
> +		DRM_ERROR("Unsupported SVGA ID 0x%x\n", svga_id);
>  		mutex_unlock(&dev_priv->hw_mutex);
>  		goto out_err0;
>  	}
> 

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

