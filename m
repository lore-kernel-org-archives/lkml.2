Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab1BTWNq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 17:13:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754920Ab1BTWNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 17:13:45 -0500
Subject: Re: [PATCH] gpu: drm: nouveau: Remove unused variable to prevent
 compile warning.
From: Ben Skeggs <bskeggs@redhat.com>
Reply-To: bskeggs@redhat.com
To: Ralf Thielow <ralf.thielow@googlemail.com>
Cc: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1298224727-5474-1-git-send-email-ralf.thielow@googlemail.com>
References: <1298224727-5474-1-git-send-email-ralf.thielow@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Feb 2011 08:16:23 +1000
Message-ID: <1298240183.16998.40.camel@caspar>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-02-20 at 18:58 +0100, Ralf Thielow wrote:
> Remove unused variable "dev_priv" in function "nv50_vm_map_pgt" to
> prevent compile warning.
> 
Thanks for this, however, it has already been fixed in the nouveau tree.

Ben.
> Signed-off-by: Ralf Thielow <ralf.thielow@googlemail.com>
> ---
>  drivers/gpu/drm/nouveau/nv50_vm.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpu/drm/nouveau/nv50_vm.c b/drivers/gpu/drm/nouveau/nv50_vm.c
> index 459ff08..03c1a63 100644
> --- a/drivers/gpu/drm/nouveau/nv50_vm.c
> +++ b/drivers/gpu/drm/nouveau/nv50_vm.c
> @@ -31,7 +31,6 @@ void
>  nv50_vm_map_pgt(struct nouveau_gpuobj *pgd, u32 pde,
>  		struct nouveau_gpuobj *pgt[2])
>  {
> -	struct drm_nouveau_private *dev_priv = pgd->dev->dev_private;
>  	u64 phys = 0xdeadcafe00000000ULL;
>  	u32 coverage = 0;
>  


