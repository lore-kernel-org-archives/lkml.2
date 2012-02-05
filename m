Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab2BEW5N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:57:13 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:56482 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753084Ab2BEW5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:57:12 -0500
Date: Sun, 5 Feb 2012 14:57:11 -0800 (PST)
From: Jakob Bornecrantz <jakob@vmware.com>
To: Masanari Iida <standby24x7@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, airlied@linux.ie,
        dri-devel@lists.freedesktop.org
Message-ID: <109863178.578869.1328482631740.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
In-Reply-To: <1328449836-1752-1-git-send-email-standby24x7@gmail.com>
Subject: Re: [PATCH] [trivial] drm: Fix typo in vmwgfx_drv.c
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [94.108.2.250]
X-Mailer: Zimbra 7.1.3_GA_3374 (ZimbraWebClient - GC16 (Mac)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Jakob Bornecrantz <jakob@vmware.com>

----- Original Message -----
> Correct spelling "unsuported" to "unsupported" in
> drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  drivers/gpu/drm/vmwgfx/vmwgfx_drv.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
> b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
> index f390f5f..2d6f573 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
> @@ -430,7 +430,7 @@ static int vmw_driver_load(struct drm_device
> *dev, unsigned long chipset)
>  	svga_id = vmw_read(dev_priv, SVGA_REG_ID);
>  	if (svga_id != SVGA_ID_2) {
>  		ret = -ENOSYS;
> -		DRM_ERROR("Unsuported SVGA ID 0x%x\n", svga_id);
> +		DRM_ERROR("Unsupported SVGA ID 0x%x\n", svga_id);
>  		mutex_unlock(&dev_priv->hw_mutex);
>  		goto out_err0;
>  	}
> --
> 1.7.6.5
